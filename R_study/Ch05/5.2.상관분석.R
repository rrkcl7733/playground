# 5.2   상관분석
# 5.2.1 분석 방법

# 5.2.1.1 피어슨 상관계수  

cor(Orange$circumference, Orange$age)
plot(Orange$circumference, Orange$age, col = "red", pch = 19 )
cor(iris[, 1:4]) 


# 5.2.2 상관계수 검정

cor.test(iris$Petal.Length, iris$Petal.Width, method = "pearson")
 