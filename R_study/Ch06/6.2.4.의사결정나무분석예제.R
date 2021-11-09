
# iris 데이터셋을 훈련용 데이터(80%)와 테스트 데이터(20%)로 분리하기
library(caret)

parts <- createDataPartition(iris$Species, p = 0.8)
data.train <- iris[parts$Resample1, ]
table(data.train$Species)
#setosa versicolor virginica
#    40         40        40

data.test <- iris[-parts$Resample1, ]
table(data.test$Species)
#setosa versicolor virginica
#    10         10        10


# 훈련용 데이터로 의사결정나무 모델 학습하기
library(rpart)
(dt.m <- rpart(Species ~., data = data.train))
#n = 120
#node), split, n, loss, yval, (yprob)
#* denotes terminal node
#1) root 120 80 setosa (0.33333333 0.33333333 0.33333333)
#  2) Petal.Length < 2.45 40 0 setosa (1.00000000 0.00000000 0.00000000) *
#  3) Petal.Length >= 2.45 80 40 versicolor (0.00000000 0.50000000 0.50000000)
#     6) Petal.Length < 4.75 37 0 versicolor (0.00000000 1.00000000 0.00000000) *
#     7) Petal.Length >= 4.75 43 3 virginica (0.00000000 0.06976744 0.93023256) *


# 적합된 의사결정나무 모델 시각화하기
plot(dt.m, compress = TRUE, margin = 0.1)
text(dt.m, cex = 1.5)


# 테스트 데이터로 예측을 수행하고, 의사결정나무 모델의 성능 평가하기
dt.m.pred <- predict(dt.m, newdata = data.test, type = "class")
install.packages('e1071')
confusionMatrix(data.test$Species, dt.m.pred)
# Confusion Matrix and Statistics
#
#            Reference
#Prediction   setosa versicolor virginica
#  setosa         10          0         0
#  versicolor      0          9         1
#  virginica       0          0        10

#Overall Statistics
#              Accuracy : 0.8667
#                95% CI : (0.6928, 0.9624)
#   No Information Rate : 0.4
#   P-Value [Acc > NIR] : 1.769e-07
#                 Kappa : 0.8
#Mcnemar's Test P-Value : NA

#Statistics by Class:
#                     Class: setosa Class: versicolor Class: virginica
#Sensitivity                 1.0000            1.0000           0.9091
#Specificity                 1.0000            0.9524           1.0000
#Pos Pred Value              1.0000            0.9000           1.0000
#Neg Pred Value              1.0000            1.0000           0.9500
#Prevalence                  0.3333            0.3000           0.3667
#Detection Rate              0.3333            0.3000           0.3333
#Detection Prevalence        0.3333            0.3333           0.3333
#Balanced Accuracy           1.0000            0.9762           0.9545


# rpart.plot 패키지의 prp() 함수로 적합된 의사결정나무 모델 시각화하기
library(rpart.plot)
prp(dt.m, type = 4, extra = 2)


