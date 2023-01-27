setwd("C:/workspace/R/R_shiny")
load("./06_geodataframe/06_apt_price.rdata")
library(sf)
bnd<-st_read("./01_code/sigun_bnd/seoul.shp")
load("./07_map/07_kde_high.rdata")
load("./07_map/07_kde_hot.rdata")
grid<-st_read("./01_code/sigun_grid/seoul.shp") #서울시 격자

###1단계: 마커 클러스터링###
pcnt_10<-as.numeric(quantile(apt_price$py, probs=seq(.1, .9, by=.1))[1])
pcnt_90<-as.numeric(quantile(apt_price$py, probs=seq(.1, .9, by=.1))[9])
load("./01_code/circle_marker/circle_marker.rdata")
circle.colors<-sample(x=c("red","green","blue"), size=1000, replace=TRUE)

###2단계: 반응형 지도 만들기###
library(leaflet)
library(purrr)
library(raster)
leaflet()%>%
  #기본 맵 설정: 오픈스트리트맵
  addTiles(options=providerTileOptions(minZoom=9, maxZoom=18))%>%
  #최고가 지역:KDE(kernal density estimate 커널 밀도 추정)
  addRasterImage(raster_high,
                 colors=colorNumeric(c("blue","green","yellow","red"), values(raster_high),
                                     na.color="transparent"), opacity=0.4, group="2021 최고가")%>%
  #급등지 지역 KDE
  addRasterImage(raster_hot,
                 colors=colorNumeric(c("blue","green","yellow","red"), values(raster_hot),
                                     na.color="transparent"), opacity=0.4, group="2021 급등지")%>%
  #스위치 메뉴 생성
  addLayersControl(baseGroups=c("2021 최고가","2021 급등지"),
                   options=layersControlOptions(collapsed=F))%>%
  #서울시 외곽 경계선
  addPolygons(data=bnd, weight=3, stroke=T, color="red", fillOpacity=0)%>%
  #마커 클러스터링
  addCircleMarkers(data=apt_price, lng=unlist(map(apt_price$geometry, 1)),
                   lat=unlist(map(apt_price$geometry, 2)), radius=10, stroke=F,
                   fillOpacity=0.6, fillColor=circle.colors, weight=apt_price$py,
                   clusterOptions=markerClusterOptions(iconCreateFunction=JS(avg.formula)))

###3단계: 지도 어플리케이션 만들기###
grid<-st_read("./01_code/sigun_grid/seoul.shp")
grid<-as(grid, "Spatial") ; grid<-as(grid, "sfc")
grid<-grid[which(sapply(st_contains(st_sf(grid), apt_price), length)>0)]
plot(grid)

###4단계: 반응형 지도 모듈화###
m<-leaflet()%>%
  #기본 맵 설정: 오픈스트리트맵
  addTiles(options=providerTileOptions(minZoom=9, maxZoom=18))%>%
  #최고가 지역:KDE(kernal density estimate 커널 밀도 추정)
  addRasterImage(raster_high,
                 colors=colorNumeric(c("blue","green","yellow","red"), values(raster_high),
                                     na.color="transparent"), opacity=0.4, group="2021 최고가")%>%
  #급등지 지역 KDE
  addRasterImage(raster_hot,
                 colors=colorNumeric(c("blue","green","yellow","red"), values(raster_hot),
                                     na.color="transparent"), opacity=0.4, group="2021 급등지")%>%
  #스위치 메뉴 생성
  addLayersControl(baseGroups=c("2021 최고가","2021 급등지"),
                   options=layersControlOptions(collapsed=F))%>%
  #서울시 외곽 경계선
  addPolygons(data=bnd, weight=3, stroke=T, color="red", fillOpacity=0)%>%
  #마커 클러스터링
  addCircleMarkers(data=apt_price, lng=unlist(map(apt_price$geometry, 1)),
                   lat=unlist(map(apt_price$geometry, 2)), radius=10, stroke=F,
                   fillOpacity=0.6, fillColor=circle.colors, weight=apt_price$py,
                   clusterOptions=markerClusterOptions(iconCreateFunction=JS(avg.formula)))%>%
  leafem::addFeatures(st_sf(grid), layerId=~seq_len(length(grid)), color='grey')
m

###5단계: 샤이니와 mapedit으로 어플리케이션 구동###
library(shiny)
#install.packages("mapedit")
library(mapedit)
library(dplyr)

ui<-fluidPage(
  selectModUI("selectmap"),
  "선택은 할 수 있지만 아무런 반응이 없습니다.")

server<-function(input, output){
  callModule(selectMod, "selectmap", m)}
shinyApp(ui, server)

###6단계: 반응식 추가###
ui<-fluidPage(
  selectModUI("selectmap"),
  textOutput("sel")
  )

server<-function(input, output, session){
  df<-callModule(selectMod, "selectmap", m)
  output$sel<-renderPrint({df()[1]})}
shinyApp(ui, server)

###7단계: 반응형 지도 어플리케이션 완성###
#install.packages("DT")
library(DT)
ui<-fluidPage(
  fluidRow(
    column(9, selectModUI("selectmap"), div(style="height:45px")),
    column(3,
          sliderInput("range_area","전용면적",sep="",min=0,max=350,value=c(0,200)),
          sliderInput("range_time","건축연도",sep="",min=1960,max=2020,value=c(1980,2020))),
    column(12, dataTableOutput(outputId="table"), div(style="height:200px"))))

server <- function(input, output, session) {
  apt_sel=reactive({
    apt_sel=subset(apt_price, con_year>=input$range_time[1]&
                     con_year<=input$range_time[2]&area>=input$range_area[1]&
                     area<=input$range_area[2])
    return(apt_sel)})
  g_sel<-callModule(selectMod,"selectmap",
                    leaflet()%>%
                      #기본 맵 설정: 오픈스트리트맵
                      addTiles(options=providerTileOptions(minZoom=9, maxZoom=18))%>%
                      #최고가 지역:KDE(kernal density estimate 커널 밀도 추정)
                      addRasterImage(raster_high,
                                     colors=colorNumeric(c("blue","green","yellow","red"), values(raster_high),
                                                         na.color="transparent"), opacity=0.4, group="2021 최고가")%>%
                      #급등지 지역 KDE
                      addRasterImage(raster_hot,
                                     colors=colorNumeric(c("blue","green","yellow","red"), values(raster_hot),
                                                         na.color="transparent"), opacity=0.4, group="2021 급등지")%>%
                      #스위치 메뉴 생성
                      addLayersControl(baseGroups=c("2021 최고가","2021 급등지"),
                                       options=layersControlOptions(collapsed=F))%>%
                      #서울시 외곽 경계선
                      addPolygons(data=bnd, weight=3, stroke=T, color="red", fillOpacity=0)%>%
                      #마커 클러스터링
                      addCircleMarkers(data=apt_price, lng=unlist(map(apt_price$geometry, 1)),
                                       lat=unlist(map(apt_price$geometry, 2)), radius=10, stroke=F,
                                       fillOpacity=0.6, fillColor=circle.colors, weight=apt_price$py,
                                       clusterOptions=markerClusterOptions(iconCreateFunction=JS(avg.formula)))%>%
                      leafem::addFeatures(st_sf(grid), layerId=~seq_len(length(grid)), color='grey'))
  #선택에 따른 반응 결과 저장
  #반응 초기값 설정(NULL)
  rv<-reactiveValues(intersect=NULL, selectgrid=NULL)
  #반응 경과 (rv) 저장
  observe({
    gs<-g_sel()
    rv$selectgrid<-st_sf(grid[as.numeric(gs[which(gs$selected==T), "id"])])
    if(length(rv$selectgrid)>0){
      rv$intersect<-st_intersects(rv$selectgrid, apt_sel())
      rv$sel<-st_drop_geometry(apt_price[apt_price[unlist(rv$intersect[1:10]),],])
    }else{
      rv$intersect<-NULL
    }
  })
  #반응 결과 렌더링
  output$table<-DT::renderDataTable({
    dplyr::select(rv$sel, ymd, addr_1, apt_nm, price, area, floor,py)%>%
      arrange(desc(py))}, extensions='Buttons', options=list(dom='Bfrtip',
      scrolly=300, scrollCollapse=T, paging=T, buttons=c('excel')))
  }
shinyApp(ui, server)
