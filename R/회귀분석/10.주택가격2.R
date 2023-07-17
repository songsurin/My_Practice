df<-read.csv("c:/data/house_regress/data.csv")
head(df)
tail(df)

library(dplyr)
# Suburb, Address, Type, Method, SellerG, Date, CouncilArea, Regionname필드 제거
df<-df %>% select(-Suburb, -Address, -Type, -Method,
                  -SellerG, -Date, -CouncilArea, -Regionname)

dim(df)

# 결측값이 있는 행을 제거
df<-na.omit(df)
tail(df)

dim(df)
summary(df)

#상관계수 행렬
(corrmatrix <- cor(df))

#강한 양의 상관관계, 강한 음의 상관관계
corrmatrix[corrmatrix > 0.5 | corrmatrix < -0.5]

#install.packages("corrplot")
library(corrplot)
corrplot(cor(df), method="circle")

#다중회귀분석 모델 생성
model<-lm(Price ~ ., data = df )
model

#분석결과 요약
summary(model)

#후진제거법
reduced<-step(model, direction="backward")
#최종적으로 선택된 변수들 확인

#최종 결과 확인
summary(reduced)

