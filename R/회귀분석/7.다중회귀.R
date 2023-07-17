data()

head(attitude)
tail(attitude)

model<-lm(rating ~ . , data=attitude)
model

summary(model)
#complaints, learning이 기여도가 높은 변수
#p-value가 0.05보다 작으므로 통계적으로 유의함
#모델의 설명력(예측의 정확성) 66%

#후진제거법
reduced<-step(model, direction="backward")
#최종적으로 complaints와 learning 2가지 변수 외에는 제거됨

summary(reduced)
#p-value가 0.05보다 작으므로 이 회귀모델은 통계적으로 유의함.
#모델의 설명력(신뢰도,예측정확성) : 68%