df<-read.csv("c:/data/ozone/ozone2.csv")
head(df)
library(dplyr)
# 필드 제거
df<-df %>% select(-Result)
library(caret)
#랜덤 시드 고정
set.seed(123)
#학습용:검증용 8:2로 구분
#list=FALSE, 인덱스값들의 리스트를 반환하지 않음
idx_train <- createDataPartition(y=df$Ozone, p=0.8, list=F)
#학습용
train <- df[idx_train, ]
X_train <- train[, -4]
y_train <- train[, 4]
#검증용
test <- df[-idx_train, ]
X_test <- test[, -4]
y_test <- test[, 4]
head(X_train)
head(y_train)
#install.packages("h2o")
library(h2o)
h2o.init()
set.seed(123)
tr_data <- as.h2o(train)
te_data <- as.h2o(test)
target <- "Ozone"
#독립변수들의 이름
features <- names(train)[2:4]
features
model <- h2o.deeplearning(x = features, y = target,
                          training_frame = tr_data, 
                          ignore_const_cols = FALSE,
                          hidden=c(8,7,5,5))
summary(model)
# 예측값
pred <- h2o.predict(model, te_data)
pred
# MSE 계산
perf <- h2o.performance(model, newdata = te_data)
perf
#H2ORegressionMetrics: deeplearning
#MSE: 341.2713
#RMSE: 18.47353
#MAE: 14.16487
#RMSLE: 0.7233031 (Root Mean Squared Log Error)
h2o.mse(perf)
