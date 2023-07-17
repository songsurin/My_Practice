x<-c(0,1,4,9)
y<-c(1,2,3,4)
z<-c(0,5,7,9)
mean(x)
mean(y)
mean(z)

cor(x,y,method="pearson") #기본값
cor(x,y,method="spearman")

cor(y,z,method="pearson")
cor(y,z,method="spearman")

cor(x,z,method="pearson")
cor(x,z,method="spearman")


#귀무가설: 담배값 인상과 흡연과 상관관계가 없다.
x<-c(70,72,62,64,71,76,0,65,74,72) # 인상 전 매출
y<-c(70,74,65,68,72,74,61,66,76,75) # 인상 후 매출
cor.test(x,y,method="pearson")
# p-value가 0.05보다 작으므로 대립가설을 채택
# 즉 담배값 인상과 흡연과 상관관계가 있다.
# cor상관계수가 0.77로 강한 양의 상관관계


df<-read.csv("c:/data/rides/rides.csv")
head(df)

#산점도
plot(df$overall~df$rides) # y ~ X
# rides overall 와 은 양의 상관관계가 있는 것으로 보임

#공분산
cov(df$overall, df$rides)
cov(1:5, 2:6) # x,y가 같은 방향으로 증가하므로 양수
cov(1:5, rep(3,5)) # x의 변화에 y가 영향을 받지 않으므로 0 
cov(1:5, 5:1) # x,y의 증가 방향이 다르므로 음수
cov(c(10,20,30,40,50), 5:1) # 숫자 단위가 커지면 공분산도 함께 커짐

#상관계수
cor(1:5, 5:1) 
cor(c(10,20,30,40,50), 5:1) 


#피어슨 상관계수
cor(df$overall, df$rides, method='pearson')
# use='complete.obs' 결측값을 제외하고 계산하는 옵션
cor(df$overall, df$rides, use='complete.obs',
    method='pearson')

# 귀무가설: 상관계수가 0이다
# 대립가설: 상관계수가 0이 아니다
cor.test(df$overall, df$rides, method = "pearson",
         conf.level = 0.95)
# p-value 0.05 가 이하이므로 귀무가설 기각
# 결론: 두 변수는 선형적으로 상관관계가 있음

head(df[,4:8])

#산점도 행렬
plot(df[,4:8])

# ( ) 추세선 회귀선 그리기
pairs(df[,4:8], panel=panel.smooth)

#install.packages("PerformanceAnalytics")
library(PerformanceAnalytics)
chart.Correlation(df[,4:8], histogram=TRUE, pch=19)

#결측값이 있는 경우
df <- na.omit(df)
#상관계수 행렬
cor(df[,4:8])

#상관계수 플롯
#install.packages('corrplot')
library(corrplot)
X<-cor(df[,4:8])
corrplot(X) #원의 크기로 표시됨

#숫자로 출력됨
corrplot(X, method="number")
# method: circle,square,ellipse,number,shade,color,pie
corrplot.mixed(X, lower='ellipse',upper='circle') 

# 계층적 군집의 결과에 따라 사각형 표시, addrect 군집개수
#hclust ; hierarchical clustering order(계층적 군집순서)로 정렬
corrplot(X,order="hclust",addrect=3)

