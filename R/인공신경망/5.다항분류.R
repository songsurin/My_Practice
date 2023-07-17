df<-read.csv("c:/data/iris/iris.csv")
head(df)
library(dplyr)
# 필드 제거
df<-df %>% select(-Name)
head(df)
tbl<-table(df$Species)
tbl
library(caret)
#랜덤 시드 고정
set.seed(123)
#학습용:검증용 8:2로 구분
#list=FALSE, 인덱스값들의 리스트를 반환하지 않음
idx_train <- createDataPartition(y=df$Species, p=0.8,list=FALSE)
#학습용lib
train <- df[idx_train, ]
X_train <- train[, -5]
y_train <- train[, 5]
#검증용
test <- df[-idx_train, ]
X_test <- test[, -5]
y_test <- test[, 5]
#install.packages('neuralnet')
library(neuralnet)
# threshold : 에러의 감소분이 threshold 값보다 작으면 stop
set.seed(123)
model <- neuralnet(as.factor(Species) ~ ., data=train,
                   hidden=10, threshold=0.01, linear.output = F)
#model$result.matrix #가중치 정보
win.graph(); plot(model)
pred<-predict(model, X_test, type='prob')
pred
# apply(x, direction, function) direction: 1 행방향, 2 열방향
result <- apply(pred, 1, function(x) which.max(x)-1)
result
table(y_test , result)
mean(y_test == result)
