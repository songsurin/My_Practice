df<-read.csv("c:/data/iris/iris.csv")
head(df)
tail(df)
##########################################
library(dplyr)
# 필드 제거
df<-df %>% select(-Name)
#Species 변수가 int로 되어 있는데 Factor 타입으로 변경해야 함
str(df)
##########################################
df$Species <- as.factor(df$Species)
str(df)
##########################################
head(df)
dim(df)
summary(df)
##########################################
#상관계수 행렬
(corrmatrix <- cor(df[1:4]))
##########################################
library(corrplot)
corrplot(cor(df[1:4]), method="circle")
##########################################
library(caret)
#랜덤 시드 고정
set.seed(123)
#학습용:검증용 8:2로 구분
#list=FALSE, 인덱스값들의 리스트를 반환하지 않음
idx_train <- createDataPartition(y=df$Species, p=0.8,
                                 list=FALSE)
#학습용
train <- df[idx_train, ]
X_train <- train[, -5]
y_train <- train[, 5]
#검증용
test <- df[-idx_train, ]
X_test <- test[, -5]
y_test <- test[, 5]
head(X_train)
head(y_train)
##########################################
# 가장 에러율이 적은 cost, gamma value 확인
library("e1071")
set.seed(123)
tune.out <-tune(svm, Species ~ ., data = train,
                range=list(cost=c(0.001,0.01,0.1,1,10),
                           gamma=c(0.0001, 0.001, 0.01, 0.1)))
summary(tune.out)
##########################################
bestmodel <-tune.out$best.model
summary(bestmodel)
##########################################
pred <- predict(bestmodel, X_train)
table(y_train, pred)
mean(y_train == pred)
##########################################
pred <- predict(bestmodel, X_test)
table(y_test, pred)
mean(y_test == pred)

