df<-read.csv("c:/data/rides/rides.csv")
head(df)
model<-lm(overall~num.child + distance + rides + games +
            wait + clean, data=df)
summary(model)
save(model, file="c:/data/R/rides_regress.model")
rm(list=ls()) #현재 작업중인 모든 변수들을 제거
load("c:/data/R/rides_regress.model")
ls()
summary(model)
