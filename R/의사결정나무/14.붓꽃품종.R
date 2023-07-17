df<-read.csv("c:/data/iris/iris.csv")
head(df)
tail(df)

library(dplyr)
# 필드 제거
df<-df %>% select(-Name)
head(df)
dim(df)
summary(df)

#상관계수 행렬
(corrmatrix <- cor(df))

library(corrplot)
corrplot(cor(df), method="circle")

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

#install.packages("nnet")
library(nnet)
#로지스틱 회귀모델 생성(3개 이상의 class인 경우 multinom 함수사용)
model <- multinom(Species~., data=train)
#모델정보 요약
summary(model)

#회귀계수 확인
(coef1 <- coef(model))

#클래스로 출력
pred<-predict(model, newdata=X_test)
pred
mean(y_test == pred)
table(y_test,pred)

#확률로 출력
pred<-predict(model, newdata=X_test,type='probs')
pred
head(pred)

#0.5보다 크면 1, 아니면 0으로 설정
result <- ifelse(pred>0.5,1,0)
head(result)
head(y_test)

new_result <- c()
for(i in 1:nrow(result)){
  for(j in 1:ncol(result)){
    if(result[i,j]==1){
      new_result[i] <- j-1 # 품종이 0,1,2 이므로 1을 빼야 함
    }
  }
}
y_test == new_result

mean(y_test == new_result)
table(y_test,new_result)
