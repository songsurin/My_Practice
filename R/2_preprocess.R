setwd("C:/workspace/R/R_shiny")

#1단계: 아파트 실거래가 불러오기
load("./03_integrated/03_apt_price.rdata")
head(apt_price, 2)

#2단계: 결측값 확인
table(is.na(apt_price))
apt_price<-na.omit(apt_price)
table(is.na(apt_price))
head(apt_price$price, 2)

apt_price<-as.data.frame(apply(apt_price,2,str_trim))
head(apt_price$price, 2)

#3단계: 항목별 데이터 전처리
#3-1: 연월일 데이터를 연월 데이터로 만들기
#install.packages("lubridate")
library(lubridate)
#install.packages("dplyr")
library(dplyr)
#install.packages("cli")
library(cli)

apt_price<-apt_price%>%mutate(ymd=make_date(year, month, day))
apt_price$ym<-floor_date(apt_price$ydm, 'month')
head(apt_price, 2)

#3-2: 매매가 변환
head(apt_price$price, 3)
apt_price$price<-apt_price$price%>%sub(",", "", .)%>%as.numeric()
head(apt_price$price, 3)

#3-3: 주소 조합
head(apt_price$apt_nm, 30)
loc<-read.csv("sigun_code.csv")
apt_price<-merge(apt_price, loc, by='code')
apt_price$juso_jibun<-paste0(apt_price$addr_2, apt_price$dong_nm," ",
                             apt_price$jibun," ", apt_price$apt_nm)
head(apt_price, 2)
apt_price$apt_nm<-gsub("\\(.*", "", apt_price$apt_nm) # 괄호 이후 이름 삭제

#3-4: 건축연도 변환
head(apt_price$con_year, 3)
apt_price$con_year<-apt_price$con_year%>%as.numeric()
head(apt_price$con_year, 3)

#3-5: 평당 매매가 만들기
head(apt_price$area, 3)
apt_price$area<-apt_price$area%>%as.numeric()%>%round(0)
head(apt_price$area, 3)

apt_price$py<-round(((apt_price$price/apt_price$area)*3.3),0)
head(apt_price$py, 3)

#3-6: 층수 변환
head(apt_price$floor, 3)
min(apt_price$floor)
apt_price$floor<-apt_price$floor%>%as.numeric()%>%abs()
min(apt_price$floor)

apt_price$cnt<-1
head(apt_price, 2)

#4단계: 저장하기
#4-1: 컬럼 추출
apt_price<-apt_price%>%select(ymd, year, code, addr_1, apt_nm, juso_jibun, 
                              price, con_year, area, floor, py, cnt)
head(apt_price, 2)

#4-2: 저장
dir.create("./04_pre_process")
save(apt_price, file="./04_pre_process/04_pre_process.rdata")
write.csv(apt_price,"./04_pre_process/04_pre_process.csv")
