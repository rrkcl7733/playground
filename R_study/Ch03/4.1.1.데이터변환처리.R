
# 데이터 프레임 형식의 데이터셋 생성하기
data <- data.frame(이름=c("홍길동","이순신","유관순","유성룔"),
                   성별=c("남자","남자","여자","남자"),
                   AI=c(96, 98, 90, 89),
                   BigData=c(92, 93, 90, 89))
data
#    이름 성별 AI BigData
#1 홍길동 남자 96      92
#2 이순신 남자 98      93
#3 유관순 여자 90      90
#4 유성룔 남자 89      89


# reshape2 패키지를 설치하고 불러오기
install.packages("reshape2")
library(reshape2)


# melt() 함수를 이용해 데이터셋 구조를 변형하기
m <- melt(data, 
          id.vars = c("이름", "성별"), 
          measure.vars = c("AI", "BigData"))
m
#    이름 성별 variable value
#1 홍길동 남자       AI    96
#2 이순신 남자       AI    98
#3 유관순 여자       AI    90
#4 유성룔 남자       AI    89
#5 홍길동 남자  BigData    92
#6 이순신 남자  BigData    93
#7 유관순 여자  BigData    90
#8 유성룔 남자  BigData    89


# dcast() 함수를 이용해 melt()된 데이터를 원래 데이터셋 구조로 변환하기
data <- dcast(m, 이름+성별 ~ ...)
data
#    이름 성별 AI BigData
#1 유관순 여자 90      90
#2 유성룔 남자 89      89
#3 이순신 남자 98      93
#4 홍길동 남자 96      92


