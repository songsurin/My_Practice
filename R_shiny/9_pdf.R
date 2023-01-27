setwd("C:/workspace/R/R_shiny")
load("./08_chart/all.rdata")
load("./08_chart/sel.rdata")

#확률 밀도 분포로 변환
max_all<-density(all$py) ; max_all<-max(max_all$y)
max_sel<-density(sel$py) ; max_sel<-max(max_sel$y)
plot_high<-max(max_all, max_sel)
rm(list=c("max_all","max_sel"))

avg_all<-mean(all$py)
avg_sel<-mean(sel$py)
avg_all ; avg_sel ; plot_high

#그래프 그리기
plot(stats::density(all$py), ylim=c(0, plot_high),
     col="blue", lwd=3, main=NA)
abline(v=avg_all, lwd=2, col="blue", lty=2)
text(avg_all + (avg_all)*0.15, plot_high*0.1,
     sprintf("%.0f", avg_all), srt=0.2, col="blue")
lines(stats::density(sel$py), col="red", lwd=3)
abline(v=avg_sel, lwd=2, col="red", lty=2)
text(avg_sel+avg_sel*0.15, plot_high*0.1,
     sprintf("%.0f", avg_sel), srt=0.2, col="red")
