
# cluster 패키지 불러오기
library(cluster)


# 계층적 군집분석을 수행하고, 분석 결과 시각화하기
cmp.agn <- agnes(daisy(USArrests), diss = TRUE,
                 metric = "euclidean", method = "complete")
par(mfrow = c(1, 2))
plot(cmp.agn)
par(mfrow = c(1, 1))



