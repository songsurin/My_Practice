v1<-c(1,3,6,10,18)
#거리행렬
d1<-dist(v1)
d1

#거리행렬 모델(average 평균기준, complete 최장거리기준, single
최단거리기준, median 중앙값기준)
m1<-hclust(d1, method='average')
m1

#2개의 클러스터로 구분
plot(m1); rect.hclust(m1, k=2)

#3개의 클러스터로 구분
plot(m1); rect.hclust(m1, k=3)

###################################################
df<-read.csv("c:/data/iris/iris.csv")
head(df)
library(dplyr)

# 필드 제거
df<-df %>% select(-target)
df

#그래프 출력을 위해 40개만 선택
idx<-sample(1:nrow(df), 40)
iris_samp <- df[idx,]

#스케일링
iris.scaled <- scale(iris_samp[, -5])
#head(dist_iris)
iris.hclust <- hclust(dist(iris.scaled))
summary(iris.hclust)

#hang 라벨을 아래쪽으로 이동시킴
plot(iris.hclust, hang=-1, labels=iris$Species[idx])
rect.hclust(iris.hclust, k=3)

#클러스터링 결과 확인
#3개의 군집으로 클러스터링한 결과
groups<-cutree(iris.hclust, k=3)
groups