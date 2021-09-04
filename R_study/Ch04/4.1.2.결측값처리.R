

# 데이터 프레임 형식의 데이터셋 생성하기 
data <- data.frame(y1=c(10,12,14,25,30,34,37),
                   y2=c(15,20,25,35,45,45,49),
                   y3=c(20,30,40,50,55,60,70))
data
#  y1 y2 y3
#1 10 15 20
#2 12 20 30
#3 14 25 40
#4 16 35 50
#5 20 40 65
#6 25 45 70
#7 28 49 75


# lm() 함수를 사용한 선형회귀 모델을 생성하기 
m <- lm(y3 ~ y1 + y2, data = data)
m
#
#Call:
#  lm(formula = y3 ~ y1 + y2, data = data)
#
#Coefficients:
#  (Intercept)           y1           y2  
#       5.1054       0.2051       1.0942  


# 회귀식을 이용한 예측값을 직접 계산하기
(5.1054) + (0.2051 * 40) + (1.0942 * 55)
# [1] 73.4904
(5.1054) + (0.2051 * 44) + (1.0942 * 60)
# [1] 79.7818
(5.1054) + (0.2051 * 49) + (1.0942 * 68)
# [1] 89.5609


# predict() 함수를 이용한 예측값 예측하기
predict(m, newdata = data.frame(y1=40, y2=55))
#        1 
# 73.48874 

predict(m, newdata = data.frame(y1=44, y2=60))
#        1 
# 79.77998 

predict(m, newdata = data.frame(y1=49, y2=68))
#        1 
# 89.55887 


# Amelia 패키지를 설치하고 불러오기
install.packages("Amelia")
library(Amelia)


# freetrade 데이터셋 확인하기
data("freetrade")
head(freetrade)
#  year  country tariff polity      pop   gdp.pc intresmi signed fiveop     usheg
#1 1981 SriLanka     NA      6 14988000 461.0236 1.937347      0   12.4 0.2593112
#2 1982 SriLanka     NA      5 15189000 473.7634 1.964430      0   12.5 0.2558008
#3 1983 SriLanka   41.3      5 15417000 489.2266 1.663936      1   12.3 0.2655022
#4 1984 SriLanka     NA      5 15599000 508.1739 2.797462      0   12.3 0.2988009
#5 1985 SriLanka   31.0      5 15837000 525.5609 2.259116      0   12.3 0.2952431
#6 1986 SriLanka     NA      5 16117000 538.9237 1.832549      0   12.5 0.2886563
NROW(freetrade)
# [1] 171
NROW(freetrade[complete.cases(freetrade), ]) # 결측값이 포함되지 않은 데이터
# 96


# freetrade 모든 데이터를 연도와 국가를 고려해 결측값에 대해 대치하는 모델
freetrade.out <- amelia(freetrade, m = 5, ts = "year", cs = "country")
write.amelia(obj = freetrade.out, file.stem = "data/outdata")


# freetrade 데이터셋 결측값의 위치 맵 그리기
missmap(freetrade.out)


# 5번째 데이터의 관세율(tariff) 속성값으로 처리 후 결측값 위치 맵 그리기
freetrade$tariff <- freetrade.out$imputations[[5]]$tariff   
missmap(freetrade)


# 결측값이 포함된 데이터셋 생성하기  
data <- data.frame(y1=c(10,NA,NA,25,30,34,37,40,44,49),
                   y2=c(15,20,25,35,NA,NA,49,55,60,68),
                   y3=c(20,30,40,50,55,60,70,NA,NA,NA))
data
#   y1 y2 y3
#1  10 15 20
#2  NA 20 30
#3  NA 25 40
#4  25 35 50
#5  30 NA 55
#6  34 NA 60
#7  37 49 70
#8  40 55 NA
#9  44 60 NA
#10 49 68 NA


# is.na() 함수
is.na(data$y1)
#[1] FALSE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
is.na(data$y2)
#[1] FALSE FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE FALSE
is.na(data$y3)
#[1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE


# complete.cases() 함수
data[complete.cases(data),]
#  y1 y2 y3
#1 10 15 20
#4 25 35 50
#7 37 49 70


# data 객체를 이용해 속성 y1, y2, y3의 중앙값 확인하기
mapply(median, data, na.rm = TRUE ) 
#  y1   y2   y3 
#35.5 42.0 50.0 


# DMwR 패키지를 설치하고 불러오기
install.packages("DMwR2")
library(DMwR2)


# centrallmputation() 함수를 이용해 중앙값으로 대체하기
centralImputation(data = data)
#     y1 y2 y3
#1  10.0 15 20
#2  35.5 20 30
#3  35.5 25 40
#4  25.0 35 50
#5  30.0 42 55
#6  34.0 42 60
#7  37.0 49 70
#8  40.0 55 50
#9  44.0 60 50
#10 49.0 68 50


# k=2인 이웃까지의 거리를 고려한 가중 평균값으로 대체하기
knnImputation(data = data, k=2)
#         y1       y2       y3
#1  10.00000 15.00000 20.00000
#2  14.82613 20.00000 30.00000
#3  19.29274 25.00000 40.00000
#4  25.00000 35.00000 50.00000
#5  30.00000 40.18029 55.00000
#6  34.00000 43.07967 60.00000
#7  37.00000 49.00000 70.00000
#8  40.00000 55.00000 65.37015
#9  44.00000 60.00000 65.38886
#10 49.00000 68.00000 65.38145


