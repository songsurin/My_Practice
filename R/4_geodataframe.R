setwd("C:/workspace/R/R_shiny")

#1단계: 데이터 불러오기
load("./04_pre_process/04_pre_process.rdata")
load("./05_geocoding/05_juso_geocoding.rdata")

#2단계: 주소+좌표
library(dplyr)
apt_price<-left_join(apt_price, juso_geocoding,
                     by=c('juso_jibun'='apt_juso'))
apt_price<-na.omit(apt_price)

#3단계: 지오 데이터프레임 만들기
#install.packages("sp")
library(sp)
#install.packages("sf")
library(sf)
#install.packages("leaflet")
library(leaflet)

coordinates(apt_price)<-~coord_x+coord_y
proj4string(apt_price)<-"+proj=longlat +datum=WGS84 +no_defs"
apt_price<-st_as_sf(apt_price)

plot(apt_price$geometry, axes=T, pch=1)
leaflet()%>%
  addTiles()%>%
  addCircleMarkers(data=apt_price[1:1000,], label=~apt_nm)

#3-2단계: 지오 데이터프레임 저장
dir.create("06_geodataframe")
save(apt_price, file="./06_geodataframe/06_apt_price.rdata")
write.csv(apt_price, "./06_geodataframe/06_apt_price.csv")
