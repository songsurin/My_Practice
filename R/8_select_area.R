setwd("C:/workspace/R/R_shiny")
load("./06_geodataframe/06_apt_price.rdata")
load("./07_map/07_kde_high.rdata")
grid<-st_read("seoul.shp")

#1단계: 관심지역 그리드 찾기
#install.packages("tmap")
library(tmap)
tmap_mode('view')
tm_shape(grid) + tm_borders() + tm_text("ID", col="red") +
  tm_shape(raster_high) +
  tm_raster(palette=c("blue","green","yellow","red"), alpha=.4) +
  tm_basemap(server=c('OpenStreetMap'))

library(dplyr)
apt_price<-st_join(apt_price, grid, join=st_intersects)
all<-apt_price
sel<-apt_price%>%filter(ID==81016)
dir.create("08_chart")
save(all, file="./08_chart/all.rdata")
save(sel, file="./08_chart/sel.rdata")
rm(list=ls())
