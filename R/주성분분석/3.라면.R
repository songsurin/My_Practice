data<-read.table("c:/data/noodle/noodle.txt",header=T, fileEncoding="euc-kr")
data

summary(data)
cor(data)

p1<-prcomp(data,scale=T) # scale=T 데이터 표준화 처리 포함
p1

plot(p1, type="l")

summary(p1)
predict(p1)
biplot(p1)
