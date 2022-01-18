
# Nclus 데이터 읽어오기
library(flexclust)
data("Nclus")
str(Nclus)
#num [1:550, 1:2] -0.208 -0.74 -0.72 0.373 0.954 ...

Nclus[1:5, ]
#           [,1]       [,2]
#[1,] -0.2078751  0.4990719
#[2,] -0.7404924 -0.2988594
#[3,] -0.7198511  0.5920086
#[4,]  0.3725182  0.1519670
#[5,]  0.9538773  0.9913636


# Nclus 데이터 산점도 그리기
plot(Nclus)


# k-평균 군집분석 및 결과 시각화하기
kc.fit <- kcca(Nclus, k = 4, family = kccaFamily("kmeans"))
summary(kc.fit)
#kcca object of family ‘kmeans’ 
#
#call:
#  kcca(x = Nclus, k = 4, family = kccaFamily("kmeans"))
#
#cluster info:
#  size  av_dist max_dist separation
#1   98 1.475313 3.512398   3.424897
#2  147 1.540631 4.460326   3.373556
#3  105 1.337802 2.892710   2.920576
#4  200 1.155187 4.184644   2.846542
#
#convergence after 7 iterations
#sum of within cluster distances: 742.5601 

image(kc.fit)
points(Nclus)


# 각 군집의 중심이 전체 군집의 중심(상자 안의 막대)으로부터 떨어진 거리 확인하기
kc.fit@centers
#           [,1]        [,2]
#[1,]  7.9571439 -0.04604713
#[2,] -2.0821258  6.06052451
#[3,]  0.1424604  0.05483231
#[4,]  4.0258285  4.03333593


barplot(kc.fit)


# 줄무늬를 이용하여 각 군집 내의 자료들이 해당 군집의 평균으로부터 떨어진 거리 그래프 그리기
stripes(kc.fit)


