# 5.3   선형회귀분석
# 5.3.1 단순선형회귀 

# 5.3.1.1 모델 생성 

data(Orange)
head(Orange)
model <- lm(circumference ~ age, Orange) 
model
coef(model)
r <- residuals(model)
r[0:4] 

f <- fitted(model)
r <- residuals(model)
f[0:4] + r[0:4] 
Orange[0:4,'circumference'] 
deviance(model)


# 5.3.1.3 예측

predict.lm(model, newdata = data.frame(age = 100))


# 5.3.1.4 결정계수와 수정된 결정계수

summary(model)
cor(Orange$circumference, Orange$age)
cor(Orange$circumference, Orange$age) ^ 2


# 5.3.1.5 단순회귀 모델의 시각화

plot(Orange$age, Orange$circumference)
abline(coef(model))


# 5.3.2 다중선형회귀 

# 5.3.2.1 모델 생성 

height_father <- c(180, 172, 150, 180, 177, 160, 170, 165, 179, 159) # 아버지 키 
height_mohter <- c(160, 164, 166, 188, 160, 160, 171, 158, 169, 159) # 어머니 키
height_son <- c(180, 173, 163, 184, 165, 165, 175, 168, 179, 160) # 아들 키 
height <- data.frame(height_father, height_mohter, height_son)
head(height) 

model <-lm (height_son ~ height_father + height_mohter, data = height)
model 

coef(model)


# 5.3.2.2 잔차 
r <- residuals(model)
r[0:4]
deviance(model)


# 5.3.2.3 예측 

predict.lm(model, newdata = data.frame(height_father = 170, height_mohter = 160))
predict.lm(model, newdata = data.frame(height_father = 170, height_mohter = 160)
           , interval = "confidence")


# 5.3.2.4 결정계수와 수정된 결정계수

summary(model)


# 5.3.2.5 설명변수 선택 방법 

model <- lm(mpg ~ . , data = mtcars) 
new_model <- step(model, direction = "both")


# 5.3.3 모델 진단 그래프

model <- lm(mpg ~ wt + qsec + am, data = mtcars)
plot(model)
