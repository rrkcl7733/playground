# 3.1   탐색적 데이터 분석 개요
# 3.1.1 데이터 대표값 탐색 

# 3.1.1.1 평균과 중앙값

A_salary <- c(25, 28, 50, 60, 30, 35, 40, 70, 40, 70, 40, 100, 30, 30)  
B_salary <- c(20, 40, 25, 25, 35, 25 ,20, 10, 55, 65, 100, 100, 150, 300) 
mean(A_salary)
mean(B_salary)
mean(A_salary, na.rm = T)

median(A_salary)
median(B_salary)
median (A_salary, na.rm = T) 


# 3.1.1.2 절사평균

mean(A_salary, trim = 0.1) 
mean(B_salary, trim = 0.1)

 
# 3.1.2 데이터 분산도 탐색

# 3.1.2.1 최소값, 최대값으로 범위 탐색

range(A_salary)
range(B_salary)
min(A_salary) 
max(A_salary) 
min(B_salary) 
max(B_salary) 


# 3.1.2.2 분산과 표준편차 

var(A_salary)
var(B_salary)
sd(A_salary)
sd(B_salary)


# 3.1.3 데이터 분포 탐색 

# 3.1.3.1 백분위수와 사분위수 

quantile(A_salary, 0.9)
quantile(B_salary, 0.9)

quantile(A_salary)
# 3.1.3.2 상자그림 

boxplot (A_salary, B_salary, names = c("A회사 salary", "B회사 salary"))


# 3.1.3.3 히스토그램

hist(A_salary, xlab = "A사 salary ", ylab = "인원수", breaks = 5)
hist(B_salary, xlab = "B사 salary ", ylab = "인원수", breaks = 5)


# 3.1.3.4 도수분포표

A_salary <- c(25, 28, 50, 60, 30, 35, 40, 70, 40, 70, 40, 100, 30, 30)
cut_value <- cut(A_salary, breaks = 5)
freq <- table(cut_value)
freq

A_salary <- c(25, 28, 50, 60, 30, 35, 40, 70, 40, 70, 40, 100, 30, 30)
B_salary <- c(20, 40, 25, 25, 35, 25, 20, 10, 55, 65, 100, 100, 150, 300)
A_gender <- as.factor(c('남', '남', '남', '남', '남', '남', '남', '남', '남', '여', '여', '여', 
                          '여', '여'))
B_gender <- as.factor(c('남', '남', '남', '남', '여', '여', '여', '여', '여', '여', '여', '남', 
                          '여', '여')) 
A <- data.frame(gender <- A_gender,
                salary <- A_salary) 
B <- data.frame(gender <- B_gender,
                salary <- B_salary)

freqA <- table(A$gender) 
freqA

freqB <- table(B$gender)
freqB

prop.table(freqA)
prop.table(freqB)


# 3.1.3.5 막대 그래프

barplot(freqA, names = c("남", "녀"), col = c("skyblue", "pink"), ylim = c(0, 10))
title(main = "A사")
barplot(freqB, names = c("남", "녀"), col = c("skyblue", "pink"), ylim = c(0, 10))
title(main = "B사")


# 3.1.3.6 파이 그래프 

pie(x = freqA, col = c("skyblue", "pink"), main = "A사")
pie(x = freqB, col = c("skyblue", "pink"), main = "B사")


# 3.1.4 변수 간 관계 탐색

# 3.1.4.1 산점도 그래프

A_salary <- c(25, 28, 50, 60, 30, 35, 40, 70, 40, 70, 40, 100, 30, 30) # 연봉 변수
A_hireyears <- c(1, 1, 5, 6, 3, 3, 4, 7, 4, 7, 4, 10, 3, 3) # 근무년차 변수 
A <- data.frame(salary <- A_salary ,
                  hireyears <- A_hireyears)
plot(A$hireyears, A$salary, xlab = "근무년수", ylab = "연봉(백만원단위)")

pairs(iris[, 1:4] , main = "iris data") 


# 3.1.4.2 상관계수

cor(A$hireyears, A$salary)


# 3.1.4.3 상관행렬 

cor(iris[, 1:4])


# 3.1.4.4 상관행렬 히트맵 

heatmap(cor(iris[, 1:4]))
