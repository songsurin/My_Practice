setwd("C:/workspace/R/R_shiny")
load("./08_chart/all.rdata")
load("./08_chart/sel.rdata")
library(dplyr)
library(lubridate)

#1단계: 월별 거래가 요약
all<-all%>%
  group_by(month=floor_date(ymd, "month"))%>%
  summarize(all_py=mean(py))
sel<-sel%>%
  group_by(month=floor_date(ymd, "month"))%>%
  summarize(sel_py=mean(py))

#2단계: 회귀식 모델링
fit_all<-lm(all$all_py~all$month)
fit_sel<-lm(sel$sel_py~sel$month)
coef_all<-round(summary(fit_all)$coefficients[2],1)*365
coef_sel<-round(summary(fit_sel)$coefficients[2],1)*365

#3단계: 그래프 그리기
library(grid)
grob_1<-grobTree(textGrob(paste0("전체 지역: ", coef_all, "만원(평당)"), x=0.05,
                 y=0.88, hjust=0, gp=gpar(col="blue", fontsize=13, fontface="italic")))
grob_2<-grobTree(textGrob(paste0("관심 지역: ", coef_sel, "만원(평당)"), x=0.05,
                 y=0.95, hjust=0, gp=gpar(col="red", fontsize=16, fontface="bold")))

#install.packages("ggpmisc")
library(ggpmisc)
gg<-ggplot(sel, aes(x=month, y=sel_py)) +
  geom_line() + xlab("월") + ylab("가격") +
  theme(axis.text.x=element_text(angle=90)) +
  stat_smooth(method='lm', color="dark grey", linetype="dashed") +
  theme_bw()
gg + geom_line(color="red", size=1.5) +
  geom_line(data=all, aes(x=month, y=all_py), color="blue", linewidth=1.5) +
  annotation_custom(grob_1) +
  annotation_custom(grob_2)
rm(list=ls())
