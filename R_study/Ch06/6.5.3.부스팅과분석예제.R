
# adabag 패키지와 iris 데이터 불러오기
library(adabag)
data("iris")


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


#훈련용 데이터로 100회 반복(또는 100개 트리 수 사용)으로 부스팅 모델 적합하기
boo.fit <- boosting(Species~., data = iris.train, boos = TRUE, mfinal = 100)


# 적합된 모델의 추가적인 정보 확인하기
ls(boo.fit)
#[1] "call"       "class"      "formula"    "importance" "prob"       "terms"      "trees"     
#[8] "votes"      "weights"   

table(boo.fit$class)
#setosa versicolor  virginica 
#    40         40         40 


# 적합된 모델에서 100번째 트리 확인하기
boo.fit$trees[[100]]
#n= 120 
#
#node), split, n, loss, yval, (yprob)
#      * denotes terminal node
#
#1) root 120 63 virginica (0.11666667 0.40833333 0.47500000)  
#  2) Petal.Length< 2.45 14  0 setosa (1.00000000 0.00000000 0.00000000) *
#  3) Petal.Length>=2.45 106 49 virginica (0.00000000 0.46226415 0.53773585)  
#    6) Petal.Width< 1.75 69 23 versicolor (0.00000000 0.66666667 0.33333333)  
#     12) Petal.Length< 5.05 47  7 versicolor (0.00000000 0.85106383 0.14893617) *
#     13) Petal.Length>=5.05 22  6 virginica (0.00000000 0.27272727 0.72727273) *
#    7) Petal.Width>=1.75 37  3 virginica (0.00000000 0.08108108 0.91891892) *
  
plot(boo.fit$trees[[100]])
text(boo.fit$trees[[100]])


# 설명변수 중요도 확인하기
boo.fit$importance
#Petal.Length  Petal.Width Sepal.Length  Sepal.Width 
#    48.73783     22.85562     15.79965     12.60690 

barplot(boo.fit$importance[order(boo.fit$importance, decreasing = TRUE)],
        ylim = c(0, 100),
        main = "Variables Relative Importtance")


# 테스트 데이터로 예측을 수행하고, 부스팅 모델의 성능 평가하기
boo.pred <- predict(boo.fit, newdata = iris.test)
boo.tb <- table(boo.pred$class, iris.test$Species)
boo.tb
#           setosa versicolor virginica
#setosa         10          0         0
#versicolor      0         10         1
#virginica       0          0         9

mean(iris.test$Species == boo.pred$class) # Accuracy
#[1] 0.9666667

(1-sum(diag(boo.tb))/sum(boo.tb)) # Error Rate
#[1] 0.03333333


