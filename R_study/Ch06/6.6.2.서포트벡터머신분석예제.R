
# kernlab 패키지와 iris 데이터 불러오기
library(kernlab)
data(iris)


# iris 자료를 훈련용 데이터(80%)와 테스트 데이터(20%)로 분리하기
library(caret)
parts <- createDataPartition(iris$Species, p = 0.8)
iris.train <- iris[parts$Resample1, ]
table(iris.train$Species)
#setosa versicolor virginica
#    40         40        40

iris.test <- iris[-parts$Resample1, ]
table(iris.test$Species)
#setosa versicolor  virginica 
#    10         10         10 


# 훈련용 데이터로 서포트 벡터 머신 모델 생성하기
svm.fit <- ksvm(Species ~., data = iris.train)
svm.fit
#Support Vector Machine object of class "ksvm" 
#
#SV type: C-svc  (classification) 
#parameter : cost C = 1 
#
#Gaussian Radial Basis kernel function. 
#Hyperparameter : sigma =  0.737377165774547 
#
#Number of Support Vectors : 57 
#
#Objective Function Value : -4.188 -4.6394 -18.1973 
#Training error : 0.016667 


# 테스트 데이터로 예측을 수행하고, 서포트 벡터 머신 모델의 성능 평가하기
svm.pred <- predict(svm.fit, newdata = iris.test)
head(svm.pred)
#[1] setosa setosa setosa setosa setosa setosa
#Levels: setosa versicolor virginica

svm.tb <- table(svm.pred, iris.test$Species)
svm.tb
#svm.pred      setosa versicolor virginica
#  setosa          10          0         0
#  versicolor       0          9         0
#  virginica        0          1        10

mean(iris.test$Species == svm.pred)   # Accuracy
#[1] 0.9666667

(1-sum(diag(svm.tb))/sum(svm.tb))     # Error Rate
#[1] 0.03333333

