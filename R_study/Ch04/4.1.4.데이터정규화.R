

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


# scale() 함수를 이용해 몸무게와 키를 표준화하기
scale_data <- apply(data[, 3:4], 2, scale)
colnames(scale_data) <- c("weight_scale", "height_scale")
data <- cbind(data, scale_data)
head(data)
#   no sex weight height weight_scale height_scale
#1   1   m     64    198  -0.17205709    1.6121604
#2   2   m     77    170   1.03841515    0.3842109
#3   3   m     59    170  -0.63762334    0.3842109
#4   4   m     66    198   0.01416941    1.6121604
#5   5   m     71    170   0.47973566    0.3842109
#6   6   m     70    165   0.38662241    0.1649342


# 몸무게와 키 값에 대한 히스토그램 그리기
par(mfrow = c(1, 2))
hist(data$weight, freq = FALSE, main = "대학생 몸무게 확률밀도함수 그래프")
hist(data$height, freq = FALSE, main = "대학생 키 확률밀도함수 그래프")
par(mfrow=c(1,1))


# 표준화된 몸무게와 키 값에 대한 히스토그램 그리기
par(mfrow=c(1,2))
hist(data$weight_scale, freq = FALSE, main = "대학생 몸무게 확률밀도함수 그래프")
hist(data$height_scale, freq = FALSE, main = "대학생 키 확률밀도함수 그래프")
par(mfrow=c(1,1))


# 변수 x의 값을 0~1 사이로 표준화하는 std() 함수 만들기
std <- function(x) {
  return((x- min(x)) / ((max(x)-min(x))))
}


# std() 함수를 이용해 [0-1] 변환(표준화)하기
std_data <- apply(data[ ,3:4], 2, std)
colnames(std_data) <- c("weight_std","height_std")
data <- cbind(data, std_data)
head(data)
#  no sex weight height weight_scale height_scale weight_std height_std
#1  1   m     64    198  -0.17205709    1.6121604  0.3818182  1.0000000
#2  2   m     77    170   1.03841515    0.3842109  0.6181818  0.7500000
#3  3   m     59    170  -0.63762334    0.3842109  0.2909091  0.7500000
#4  4   m     66    198   0.01416941    1.6121604  0.4181818  1.0000000
#5  5   m     71    170   0.47973566    0.3842109  0.5090909  0.7500000
#6  6   m     70    165   0.38662241    0.1649342  0.4909091  0.7053571


# 대학생 92명의 [0-1]변환된 몸무게, 키 확률밀도함수 그래프 
par(mfrow=c(1,2))
hist(data$weight_std, freq = FALSE, main = "대학생 몸무게 확률밀도함수 그래프")
hist(data$height_std, freq = FALSE, main = "대학생 키 확률밀도함수 그래프")
par(mfrow=c(1,1))


