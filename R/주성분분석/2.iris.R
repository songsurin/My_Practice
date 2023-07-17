head(iris)
cor(iris[1:4])

log.ir<-log(iris[,1:4])
ir.species<-iris[,5]

ir.pca<-prcomp(log.ir, center=T, scale=T) 
#                       평균 0  표준편차 0
ir.pca

#elbow그래프
plot(ir.pca, type="l")

summary(ir.pca)

#행렬곱셈
PRC<-as.matrix(log.ir) %*% ir.pca$rotation
head(PRC)

train1<-cbind(ir.species, as.data.frame(PRC))
train1[,1]<-as.factor(train1[,1])
colnames(train1)[1]<-"label"
head(train1)

fit1<-lm(label~PC1+PC2, data=train1)

fit1_pred<-predict(fit1,newdata=train1)

b<-round(fit1_pred)
b[b==0 | b==1] <- "setosa"
b[b==2]<-"versicolor"
b[b==3]<-"virginica"

a<-ir.species
table(b,a)
mean(b==a).