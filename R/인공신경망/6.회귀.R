df<-read.csv("c:/data/ozone/ozone2.csv")
head(df)
library(dplyr)
# 필드 제거
df<-df %>% select(-Month, -Day, -Result)
head(df)
library(caret)
#랜덤 시드 고정
set.seed(123)
#학습용:검증용 8:2로 구분
#list=FALSE, 인덱스값들의 리스트를 반환하지 않음
idx_train <- createDataPartition(y=df$Ozone, p=0.8,list=FALSE)
#학습용
train <- df[idx_train, ]
X_train <- train[, -1]
y_train <- train[, 1]
#검증용
test <- df[-idx_train, ]
X_test <- test[, -1]
y_test <- test[, 1]
#install.packages('neuralnet')
library(neuralnet)
# threshold : 에러의 감소분이 threshold 값보다 작으면 stop
set.seed(123)
#모형을 만들 때 시간이 많이 걸림
# 에러가 발생할 경우 stepmax를 늘려주어야 함
model <- neuralnet(Ozone ~ ., data=train, hidden=10,
                   threshold=0.05, stepmax =1e7)
win.graph(); plot(model)
pred<-predict(model, X_test)
pred
mean((y_test - pred)^2) #평균제곱오차
