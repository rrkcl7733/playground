# 5.4   시계열분석
# 5.4.1 시계열 데이터 개요 
# 5.4.2 정상성
# 5.4.3 비정상 시계열을 정상 시계열로 전환하는 방법 

n <- head(Nile)
n
n.diff1 <- diff(n, differences = 1)
n.diff1
n.diff2 <- diff(n, differences = 2)
n.diff2
plot(Nile)

Nile.diff1 <- diff(Nile, differences = 1)
Nile.diff2 <- diff(Nile, differences = 2)
plot(Nile.diff1) 
plot(Nile.diff2) 


# 5.4.4 시계열 모델 

# 5.4.4.1 자기회귀 모델 
# 5.4.4.2 이동평균 모델 
# 5.4.4.3 자기회귀 누적이동평균 모델

install.packages("forecast") 
library(forecast)

auto.arima(Nile)

Nile.arima <- arima(Nile, order=c(1, 1, 1))
Nile.arima

forecast(Nile.arima, h = 5)
plot( forecast(Nile.arima, h = 5) )


# 5.4.4.4 분해시계열

plot(ldeaths)

ldeaths.decomp <-decompose(ldeaths)
plot(ldeaths.decomp)

ldeaths.decomp.trend <- ldeaths.decomp$trend
plot(ldeaths.decomp.trend)

ldeaths.decomp.seasonal <- ldeaths.decomp$seasonal
plot(ldeaths.decomp.seasonal)


