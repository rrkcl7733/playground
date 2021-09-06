
# 대학생 92명의 몸무게와 키 데이터셋 읽어오기
data <- read.csv(file.path("data", "student92.csv"),     
                 sep = ",", 
                 stringsAsFactors = FALSE, 
                 header = TRUE, 
                 na.strings = "")
head(data)
#  no sex weight height
#1  1   m     64    198
#2  2   m     77    170
#3  3   m     59    170
#4  4   m     66    198
#5  5   m     71    170
#6  6   m     70    165


# 대학생 92명의 몸무게(kg)와 키(cm)의 산포도 
plot(weight ~ height, data = data, 
     xlab = "키(cm)", 
     ylab = "몸무게(kg)")


# 줄기-잎 그림 - 몸무게(kg)
stem(data$weight)


# 줄기-잎 그림 - 키(cm)
stem(data$height)


# 몸무게(kg) 데이터의 상자그림 그리기와 이상값 확인하기
out.weight <- boxplot(data$weight)
out.weight$out
#[1] 98


out_weight <- boxplot(data$weight)
out_weight$out


# 키 데이터의 상자그림 그리기와 이상값 확인하기
out.height <- boxplot(data$height)
out.height$out
#[1] 86


out_height <- boxplot(data$height)
out_height$out


# outlier 패키지를 이용한 이상값 검색 예시 
install.packages("outliers")
library(outliers)


outlier(data$weight)
#[1] 98


outlier(data$weight, opposite = TRUE)
#[1] 43


outlier(data$height)
#[1] 86


outlier(data$height, opposite = TRUE)
#[1] 198


out_weight <- boxplot(data$weight)
out_weight$out


# 성별 몸무게 데이터의 상자그림 그리기와 이상값 확인하기 
out.weight <- boxplot(weight ~ sex, data = data)
out.weight$out
#[1] 98


# 성별 키 데이터의 상자그림 그리기와 이상값 확인하기
out.height <- boxplot(height ~ sex, data = data)
out.height$out
#[1] 86


