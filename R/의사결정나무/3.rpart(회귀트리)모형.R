df <- read.csv('c:/data/ozone/ozone2.csv')
head(df)

#필드 제거
library(dplyr)
df <- df %>% select(-Result, -Month, -Day)

library(caret)
set.seed(123) # 랜덤 시드 고정

#학습용:검증용 8:2로 구분
idx_train <- createDataPartition(y=df$Ozone, p=0.8, list=F)

#학습용
train <- df[idx_train, ]
X_train <- train[, -1]
y_train <- train[, 1]

#검증용
test <- df[-idx_train, ]
X_test <- test[, -1]
y_test <- test[, 1]

head(X_train)
head(y_train)

#스케일링 전 박스플롯
library(reshape)
meltData <- melt(X_train)
win.graph()
boxplot(data=meltData, value~variable)

#스케일링
X_train_scaled <- as.data.frame(scale(X_train))
X_test_scaled <- as.data.frame(scale(X_test))

#데이터프레임 연결
train_scaled <- cbind(X_train_scaled, Ozone=y_train)
test_scaled <- cbind(X_test_scaled, Ozone=y_test)

head(train_scaled)
head(test_scaled)

#스케일링 후 박스플롯
meltData <- melt(X_train_scaled)
win.graph() 
boxplot(data=meltData, value~variable)

#최대깊이 제한
library(rpart)
a <- rpart.control(maxdepth=20)
model <- rpart(Ozone ~ ., method='anova', data=train_scaled, control=a)
model # 트리모형의 규칙

#트리 그래프
win.graph()
plot(model, uniform=T, main='Tree')
text(model, use.n=T, all=T, cex=.8)

#가지치기를 위한 최적의 노드 개수 확인
printcp(model)
win.graph()
plotcp(model)

#세부적인 노드정보
summary(model)

#트리를 pdf로 저장하기 위해 postscript 생성
post(model, file='c:/data/ozone/ozone_tree.ps', title='Tree Model')

#가지치기(에러율이 가장 낮을 때의 CP값으로 가지치기 진행)
pfit <- prune(model, cp=model$cptable[which.min(model$cptable[, 'xerror']), 'CP'])
win.graph()
plot(pfit, uniform=T, main='Pruned Tree')
text(pfit, use.n=T, all=T, cex=.8)
post(pfit, file = "c:/data/ozone/ozone_ptree.ps", title="Pruned Tree")

#트리를 시각적으로 꾸며주는 패키지
library(rattle)
library(rpart.plot)
win.graph()
rpart.plot(pfit) #기본형 트리
win.graph()
fancyRpartPlot(pfit) #파스텔톤의 트리

#예측값
pred <- predict(pfit, newdata=X_test_scaled)
pred

#RMS
RMSE(pred=pred, obs=y_test)


