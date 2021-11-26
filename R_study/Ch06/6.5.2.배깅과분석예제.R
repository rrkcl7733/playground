
# adabag 패키지와 iris 데이터 불러오기
library(adabag)
data("iris")
summary(iris)
# Sepal.Length    Sepal.Width     Petal.Length    Petal.Width          Species  
#Min.   :4.300   Min.   :2.000   Min.   :1.000   Min.   :0.100   setosa    :50  
#1st Qu.:5.100   1st Qu.:2.800   1st Qu.:1.600   1st Qu.:0.300   versicolor:50  
#Median :5.800   Median :3.000   Median :4.350   Median :1.300   virginica :50  
#Mean   :5.843   Mean   :3.057   Mean   :3.758   Mean   :1.199                  
#3rd Qu.:6.400   3rd Qu.:3.300   3rd Qu.:5.100   3rd Qu.:1.800                  
#Max.   :7.900   Max.   :4.400   Max.   :6.900   Max.   :2.500     


# iris 자료를 훈련용 데이터(80%)와 테스트 데이터(20%)로 분리하기
library(caret)
parts <- createDataPartition(iris$Species, p = 0.8)
iris.train <- iris[parts$Resample1, ]
table(iris.train$Species)
#setosa versicolor virginica
#    40         40        40

iris.test <- iris[-parts$Resample1, ]
table(iris.test$Species)
#setosa versicolor virginica
#    10         10        10


# 훈련용 데이터로 100회 반복(또는 100개 트리 수 사용)으로 배깅 모델 적합하기
bag.fit <- bagging(Species~., data = iris.train, mfinal = 100)


# 적합된 모델의 추가적인 정보 확인하기
ls(bag.fit)
#[1] "call"       "class"      "formula"    "importance" "prob"       "samples"    "terms"     
#[8] "trees"      "votes"


# 적합된 모델에서 첫 번째 트리 확인하기
bag.fit$trees[[1]]
#n= 120 
#
#node), split, n, loss, yval, (yprob)
#      * denotes terminal node
#
#1) root 120 77 virginica (0.3416667 0.3000000 0.3583333)  
#  2) Petal.Width< 1.75 77 36 setosa (0.5324675 0.4675325 0.0000000)  
#    4) Petal.Length< 2.45 41  0 setosa (1.0000000 0.0000000 0.0000000) *
#    5) Petal.Length>=2.45 36  0 versicolor (0.0000000 1.0000000 0.0000000) *
#  3) Petal.Width>=1.75 43  0 virginica (0.0000000 0.0000000 1.0000000) *

plot(bag.fit$trees[[1]])
text(bag.fit$trees[[1]])  
  
  
# 설명변수 중요도 확인하기
bag.fit$importance
#Petal.Length  Petal.Width Sepal.Length  Sepal.Width 
#    71.24008     28.75992      0.00000      0.00000 

barplot(bag.fit$importance[order(bag.fit$importance, decreasing = TRUE)],
        ylim = c(0, 100),
        main = "Variables Relative Importtance")


# 테스트 데이터로 예측을 수행하고, 배깅 모델의 성능 평가하기
bag.pred <- predict(bag.fit, newdata = iris.test)
bag.tb <- table(bag.pred$class, iris.test$Species)
bag.tb
#
#           setosa versicolor virginica
#setosa         10          0         0
#versicolor      0         10         2
#virginica       0          0         8


# 정분류율(Accuracy)과 오분류율(Error Rate) 계산하기
mean(iris.test$Species == bag.pred$class) # accuracy
#[1] 0.9

(1-sum(diag(bag.tb))/sum(bag.tb)) # Error Rate
#[1] 0.1

