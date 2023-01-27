setwd("C:/workspace/R/R_shiny")
load("./06_geodataframe/06_apt_price.rdata")
load("./07_map/07_kde_high.rdata")
load("./07_map/07_kde_hot.rdata")
bnd<-st_read("seoul.shp")
grid<-st_read("seoul.shp")

#1단계: 이상치 설정
pcnt_10<-as.numeric(quantile(apt_price$py, probs=seq(.1, .9, by=.1))[1])
pcnt_90<-as.numeric(quantile(apt_price$py, probs=seq(.1, .9, by=.1))[9])
load("circle_marker.rdata")
circle.colors<-sample(x=c("red","green","blue"), size=1000, replace=TRUE)

#2단계: 마커 클러스터링 시각화
#install.packages("purrr")
library(purrr)
leaflet()%>%
  addTiles()%>%
  addPolygons(data=bnd, weight=1, color="red", fill=NA)%>%
  addRasterImage(raster_high,
                 colors=colorNumeric(c("blue","yellow","red"), values(raster_high),
                 na.color="transparent"), opacity=0.4, group="2021 최고가")%>%
  addRasterImage(raster_hot,
                 colors=colorNumeric(c("blue","yellow","red"), values(raster_hot),
                 na.color="transparent"), opacity=0.4, group="2021 급등지")%>%
  addLayersControl(baseGroups=c("2021 최고가","2021 급등지"),
                   options=layersControlOptions(collapsed=F))%>%
  addCircleMarkers(data=apt_price, lng=unlist(map(apt_price$geometry, 1)),
                   lat=unlist(map(apt_price$geometry, 2)), radius=10, stroke=F,
                   fillOpacity=0.6, fillColor=circle.colors, weight=apt_price$py,
                   clusterOptions=markerClusterOptions(iconCreateFunction=JS(avg.formula)))

rm(list=ls())