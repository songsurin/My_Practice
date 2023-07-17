#의사결정나무 모형의 종류
# tree: 불순도의 척도로 엔트로피 사용
# rpart: tree()의 과적합 문제를 해결한 모형, CART에 기반한 모형
# CART: 반복적으로 두개의 자식 노드를 생성하기 위해 모든 변수를 사용하여 데이터를 나누는 방식
# ctree: 별도로 가지치기를 할 필요가 없음, 변수의 개수는 31개로 제한
# C4.5, C5.0: 가장 최근의 트리 알고리즘, 샘플 개수가 적을 경우 분류가 잘 이루어지지 않음
df <- read.csv('c:/data/ozone/ozone2.csv')
head(df)

#필드제거
library(dplyr)
df <- df %>% select(-Ozone, -Month, -Day)

#불균형 데이터셋
tbl <- table(df$Result)
win.graph()
barplot(tbl, beside=T, legend=T, col=rainbow(2))

#언더샘플링
#install.packages(ROSE)
library(ROSE)
df_samp <- ovun.sample(Result ~ ., data=df, seed=1, method='under', N=72*2)$data
table(df_samp$Result)

library(caret)
set.seed(123) # 랜덤 시드 고정

#학습용:검증용 8:2로 구분
idx_train <- createDataPartition(y=df_samp$Result, p=0.8, list=F)

#학습용
train <- df_samp[idx_train, ]
X_train <- train[, -1]
y_train <- train[, 1]

#검증용
test <- df_samp[-idx_train, ]
X_test <- test[, -1]
y_test <- test[, 1]

head(X_train)
head(y_train)

#트리 모형
#install.packages('tree')
library(tree)
model <- tree(Result ~ ., data=train)
model # 트리모형의 규칙

#트리 그래프
win.graph()
plot(model, uniform=T, main='Tree')
text(model, use.n=T, all=T, cex=.8)

#교차검증을 통한 최적의 가지수
trees <- cv.tree(model, FUN=prune.tree)
trees
win.graph()
plot(trees) # 노드가 4개일 때 분산이 가장 낮음

#가지치기(노드 4개)
ptrees <- prune.tree(model, best=4)
win.graph()
plot(ptrees)
text(ptrees, pretty=0)

#예측값(확률)
#install.packages('e1071')
library(e1071)
pred <- predict(ptrees, X_test, type='vector')
pred

#0.5보다 크면 1, 아니면 0으로 설정
result <- ifelse(pred > 0.5, 1, 0)
# 범주형으로 변환
y_test_f <- as.factor(y_test)
result_f <- as.factor(result)
confusionMatrix(result_f, y_test_f)

