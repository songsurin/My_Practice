#neuralnet: hidden-layers 두개 이상 가능
#install.packages('neuralnet')
library(neuralnet)
set.seed(100)
X <- as.matrix(sample(seq(-2,2,length=50),50,replace=FALSE),ncol=1)
y <- X^2
plot(y~X)
df<-as.data.frame(cbind(X,y))
colnames(df) <- c("X","y")
df

#신경망 모형
nn<-neuralnet(y~X, data=df,hidden=c(10,10)) #10개짜리 hidden-layer 두 층
win.graph(); plot(nn) #신경망 그래프
test<- as.matrix(sample(seq(-2,2,length=10),10,replace=FALSE),ncol=1)
pred<-predict(nn,test)
test^2 #실제값
pred #예측값
#Mean Squared Error(평균제곱오차)
mean((pred - test^2)^2)
result<- cbind(test, test^2, pred)
colnames(result) <- c("test","test^2","pred")
result