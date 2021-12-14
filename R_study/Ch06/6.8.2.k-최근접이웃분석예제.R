
# class 패키지와 iris 데이터 불러오기
library(class)
data("iris")


# iris 자료를 훈련용 데이터(80%)와 테스트 데이터(20%)로 분리하기
library(caret)
parts <- createDataPartition(iris$Species, p = 0.8)
data.train <- iris[parts$Resample1, ]
table(data.train$Species)
#setosa versicolor virginica
#    40         40        40

data.test <- iris[-parts$Resample1, ]
table(data.test$Species)
#setosa versicolor  virginica 
#    10         10         10 


# k=1부터 k=9 사이의 범위에서 정분류율(Accuracy) 계산하기
library(foreach)
knn.k <- c(1, 2 , 3 ,4, 5, 6, 7, 8, 9)
knn_result <- foreach(k = knn.k, .combine = rbind) %do% {
  knn.pred <- knn(data.train[, 1:4], data.test[, 1:4],
                  data.train$Species, k = k, prob = TRUE)
  acc.val <- mean(knn.pred == data.test$Species)
  return(data.frame(k = k, acc = acc.val))
}
knn_result
#  k       acc
#1 1 0.9000000
#2 2 0.9000000
#3 3 0.9666667
#4 4 0.9333333
#5 5 0.9333333
#6 6 0.9333333
#7 7 0.9333333
#8 8 0.9333333
#9 9 0.9666667


# 준비된 데이터셋으로 k-최근접 이웃 모델 생성하기
knn.pred <- knn(data.train[, 1:4], data.test[, 1:4],
                data.train$Species, k = 3, prob = TRUE)


# 테스트 데이터로 예측을 수행하고, k-최근접 이웃 모델의 성능 평가하기
knn.tb <- table(knn.pred, data.test$Species)
knn.tb
#knn.pred     setosa versicolor virginica
# setosa          10          0         0
# versicolor       0         10         1
# virginica        0          0         9

mean(data.test$Species == knn.pred)  # Accuracy
#[1] 0.9666667

(1-sum(diag(knn.tb))/sum(knn.tb))    # Error Rate
#[1] 0.03333333


