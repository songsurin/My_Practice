#install.packages("devtools")
#install.packages("latticeExtra")
#install.packages("ggrepel")
#install.packages("showtext")
library(devtools) ; library(sf) ; library(purrr) ; library(dplyr) ; library(DT)
library(rgdal) ; library(lattice) ; library(latticeExtra) ; library(lubridate)
library(ggplot2) ; library(ggfortify) ; library(ggrepel) ; library(showtext)
library(leaflet) ; library(leaflet.extras) ; library(raster) ; library(shiny)
library(mapview) ; library(mapedit) ; library(grid)

#01_Korean font
require(showtext)
font_add_google(name="Nanum Gothic", regular.wt=400, bold.wt=700)
showtext_auto()
showtext_opts(dpi=112)

#02_Data load
#setwd("C:/workspace/R/R_shiny")
load("./06_geodataframe/06_apt_price.rdata")
load("./07_map/07_kde_high.rdata")
load("./07_map/07_kde_hot.rdata")
bnd<-st_read("./01_code/sigun_bnd/seoul.shp")
grid<-st_read("./01_code/sigun_grid/seoul.shp")

#03_Marker clustering
pcnt_10<-as.numeric(quantile(apt_price$py, probs=seq(.1, .9, by=.1))[1])
pcnt_90<-as.numeric(quantile(apt_price$py, probs=seq(.1, .9, by=.1))[9])
load("./01_code/circle_marker/circle_marker.rdata")
circle.colors<-sample(x=c("red","green","blue"), size=1000, replace=TRUE)

#04_Grid filtering
grid<-st_read("./01_code/sigun_grid/seoul.shp")
grid<-as(grid, "Spatial") ; grid<-as(grid, "sfc")
grid<-grid[which(sapply(st_contains(st_sf(grid), apt_price), length)>0)]

#05_Shiny_UI
ui<-fluidPage(
  fluidRow(
    column(9, selectModUI("selectmap"), div(style="height:45px")),
    column(3,
           sliderInput("range_area","Area",sep="",min=0,max=350,value=c(0,200)),
           sliderInput("range_time","Construction Year",sep="",min=1960,max=2020,value=c(1970,2020)),)),
  
tabsetPanel(
  tabPanel("Chart",
           column(4, h5("Price Range", align="center"),
                  plotOutput("density", height=300),),
           column(4, h5("Price Trends", align="center"),
                  plotOutput("regression", height=300)),
           column(4, h5("PCA", align="center"),
                  plotOutput("pca", height=300)),),
  tabPanel("Table", DT::dataTableOutput("table"))
))         

#06_Shiny_Sever
server <- function(input, output, session) {
  apt_all=reactive({
    apt_all=subset(apt_price, con_year>=input$range_time[1]&
                     con_year<=input$range_time[2]&
                     area>=input$range_area[1]&
                     area<=input$range_area[2])
    return(apt_all)})
  
  #-------#
  g_sel<-callModule(selectMod,"selectmap",
                    leaflet()%>%
                      #기본 맵 설정: 오픈스트리트맵
                      addTiles(options=providerTileOptions(minZoom=9, maxZoom=18))%>%
                      #최고가 지역:KDE(kernal density estimate 커널 밀도 추정)
                      addRasterImage(raster_high,
                                     colors=colorNumeric(c("blue","green","yellow","red"), values(raster_high),
                                                         na.color="transparent"), opacity=0.4, group="2021 High Price")%>%
                      #급등지 지역 KDE
                      addRasterImage(raster_hot,
                                     colors=colorNumeric(c("blue","green","yellow","red"), values(raster_hot),
                                                         na.color="transparent"), opacity=0.4, group="2021 Hot Spot")%>%
                      #스위치 메뉴 생성
                      addLayersControl(baseGroups=c("2021 High Price","2021 Hot Spot"),
                                       options=layersControlOptions(collapsed=F))%>%
                      #서울시 외곽 경계선
                      addPolygons(data=bnd, weight=3, stroke=T, color="red", fillOpacity=0)%>%
                      #마커 클러스터링
                      addCircleMarkers(data=apt_price, lng=unlist(map(apt_price$geometry, 1)),
                                       lat=unlist(map(apt_price$geometry, 2)), radius=10, stroke=F,
                                       fillOpacity=0.6, fillColor=circle.colors, weight=apt_price$py,
                                       clusterOptions=markerClusterOptions(iconCreateFunction=JS(avg.formula)))%>%
                      leafem::addFeatures(st_sf(grid), layerId=~seq_len(length(grid)), color='grey'))
  
  #--------#
  rv<-reactiveValues(intersect=NULL, selectgrid=NULL)
  observe({
    gs<-g_sel()
    rv$selectgrid<-st_sf(grid[as.numeric(gs[which(gs$selected==T), "id"])])
    if(length(rv$selectgrid)>0){
      rv$intersect<-st_intersects(rv$selectgrid, apt_all())
      rv$sel<-st_drop_geometry(apt_price[apt_price[unlist(rv$intersect[1:10]),],])
    }else{
      rv$intersect<-NULL
    }
  })
  
  #----density#
  output$density<-renderPlot({
    if(nrow(rv$intersect)==0)
       return(NULL)
    max_all<-density(apt_all()$py)
    max_all<-max(max_all$y)
    max_sel<-density(rv$sel$py)
    max_sel<-max(max_sel$y)
    plot_high<-max(max_all, max_sel)
    avg_all<-mean(apt_all()$py)
    avg_sel<-mean(rv$sel$py)
    plot(stats::density(apt_all()$py), xlab=NA, ylab=NA, ylim=c(0,plot_high))
    abline(v=avg_all, lwd=2, col="blue", lty=2)
    text(avg_all+(avg_all)*0.13, plot_high*0.1,
         sprintf("%.0f", avg_all), srt=0.2, col="blue")
    lines(stats::density(rv$sel$py), ylim=c(0, plot_high),
          col='red', lwd=3, main=NA)
    abline(v=avg_sel, lwd=2, col='red', lty=2)
    text(avg_sel+(avg_sel)*0.13, plot_high*0.3,
         sprintf("%.0f", avg_sel), srt=0.2, col='red')
  })
  
  #-----regression#
  output$regression<-renderPlot({
    if(nrow(rv$intersect)==0)
      return(NULL)
    apt_all<-aggregate(apt_all()$py, by=list(apt_all()$ym), mean)
    sel<-aggregate(rv$sel$py, by=list(rv$sel$ym), mean)
    fit_all<-lm(apt_all$x~apt_all$Group.1)
    fit_sel<-lm(sel$x~sel$Group.1)
    coef_all<-round(summary(fit_all)$coefficients[2],1)*365
    coef_sel<-round(summary(fit_sel)$coefficients[2],1)*365
    grob_1<-grobTree(textGrob(paste0("All: ", coef_all), x=0.05,
                              y=0.84, hjust=0, gp=gpar(col="blue", fontsize=13)))
    grob_2<-grobTree(textGrob(paste0("Sel: ", coef_sel), x=0.05,
                              y=0.95, hjust=0, gp=gpar(col="red", fontsize=16, fontface="bold")))
    gg<-ggplot(sel, aes(x=Group.1, y=x, group=1)) +
      geom_smooth(color='red', size=1.5, se=F) + xlab("Year") + ylab("Price") +
      theme(axis.text.x=element_text(angle=90)) +
      stat_smooth(method='lm', linetype="dashed", se=F) +
      theme_bw()
    gg + geom_smooth(data=apt_all, aes(x=Group.1, y=x, group=1, se=F), 
                     color="blue", size=1, se=F) +
      annotation_custom(grob_1) +
      annotation_custom(grob_2)
  })
  
  #-----pca#
  output$pca<-renderPlot({
    if(nrow(rv$intersect)==0)
      return(NULL)
    pca_01<-aggregate(list(rv$sel$con_year, rv$sel$floor, rv$sel$py, rv$sel$area),
                      by=list(rv$sel$apt_nm), mean)
    colnames(pca_01)<-c("apt_nm","new","floor","price","area")
    m<-prcomp(~new+floor+price+area, data=pca_01, scale=T)
    autoplot(m, size=NA, loadings.label=T, loadings.label.size=4) +
    geom_label_repel(aes(label=pca_01$apt_nm), size=3, alpha=0.7, family="Nanum Gothic")
  })
  
  #-----table#
  output$table<-DT::renderDataTable({
    dplyr::select(rv$sel, ymd, addr_1, apt_nm, price, area, floor,py)%>%
      arrange(desc(py))}, extensions='Buttons', options=list(dom='Bfrtip', scrolly=300, scrollCollapse=T, 
                                                             paging=T, buttons=c('excel')))
}
shinyApp(ui, server)
