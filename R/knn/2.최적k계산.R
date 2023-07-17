df<-read.csv("c:/data/ozone/ozone2.csv")
head(df)
#######################################################
library(dplyr)
# 필드 제거
df<-df %>% select(-Ozone,-Month,-Day)
#불균형 데이터셋
tbl<-table(df$Result)
tbl
barplot(tbl, beside = T, legend = T, col = rainbow(2))
#######################################################
# under sampling
#install.packages("ROSE")
library(ROSE)
# method: under,over,both N: 샘플링 후의 샘플 개수(적은 쪽 x2) 또는 p=0.5 50:50으로 선택
df_samp <- ovun.sample(Result ~ . ,data = df, seed=1, method = "under", N=72*2)$data
tbl<-table(df_samp$Result)
tbl
#######################################################
library(caret)
#랜덤 시드 고정
set.seed(123)
#학습용:검증용 8:2로 구분
#list=FALSE, 인덱스값들의 리스트를 반환하지 않음
idx_train <- createDataPartition(y=df_samp$Result, p=0.8, list=FALSE)

#학습용
train <- df_samp[idx_train, ]
X_train <- train[, -4]
y_train <- train[, 4]

#검증용
test <- df_samp[-idx_train, ]
X_test <- test[, -1]
y_test <- test[, 1]
head(X_train)
head(y_train)
#######################################################
library(e1071)
#최적의 k값을 찾는 함수, 10회 교차검증
tune.out <- tune.knn(x=X_train, y=as.factor(y_train), k=1:10)
#                             0,1 값을 숫자가 아닌 요인으로 변경
tune.out # best k = 5
plot(tune.out) # k=5일 때 에러율 최저
#######################################################
library(class)
pred <- knn(X_train, X_test, y_train, k=5)
tbl <- table(real=y_test, predict=pred)
tbl
#######################################################
(tbl[1,1]+tbl[2,2])/sum(tbl) #정확도
#######################################################
#install.packages('gmodels')
library(gmodels)
#정오분류표에 카이제곱검정값을 세부적으로 출력하는 함수
CrossTable(y_test, pred)
#Cell Contents(셀의 내용)
# N : 셀의 샘플개수
# Chi-square contribution:
# 각 셀의 값에 카이제곱 기여도 포함
# (관측값 - 기대값)^2 / 기대값 - 확률변수에 대하여 평균적으로 기대하는 값
# N / Row Total(행의 샘플수) 13/14
# N / Col Total(열의 샘플수) 13/18
# N / Table Total(전체샘플수) 13/28
#install.packages('Epi')
library(Epi)
ROC(test=pred, stat=y_test, plot="ROC", AUC=T, main="KNN")
