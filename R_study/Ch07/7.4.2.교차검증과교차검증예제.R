
# 10겹(K=10) 교차검증을 위한 훈련용 자료와 검증용 자료를 추출하기
library(cvTools)
K = 10
set.seed(123)
cv <- cvFolds(nrow(iris), K = K, type = c("random"))
trainData <- list(0) # an Empty list of length K
testData <- list(0)
for (i in 1:K) {
  test_idx <- cv$subsets[which(cv$which == i), ]
  trainData[[i]] <- iris[-test_idx, ]
  testData[[i]] <- iris[test_idx, ]
}
NROW(trainData[[1]])
#[1] 135

table(trainData[[1]]$Species)
#setosa versicolor virginica
#    44         46        45

head(trainData[[1]])
#  Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#1          5.1         3.5          1.4         0.2  setosa
#2          4.9         3.0          1.4         0.2  setosa
#3          4.7         3.2          1.3         0.2  setosa
#4          4.6         3.1          1.5         0.2  setosa
#6          5.4         3.9          1.7         0.4  setosa
#7          4.6         3.4          1.4         0.3  setosa

NROW(testData[[1]])
#[1] 15

table(testData[[1]]$Species)
#setosa versicolor virginica
#     6          4         5

head(testData[[1]])
#    Sepal.Length Sepal.Width Petal.Length Petal.Width   Species
#44           5.0         3.5          1.6         0.6    setosa
#134          6.3         2.8          5.1         1.5 virginica
#116          6.4         3.2          5.3         2.3 virginica
#147          6.3         2.5          5.0         1.9 virginica
#16           5.7         4.4          1.5         0.4    setosa
#5            5.0         3.6          1.4         0.2    setosa


# caret 패키지의 createFolds() 함수 
# 10겹(K=10) 교차검증을 위한 훈련용 자료와 검증용 자료로 분리하기
library(caret)
K = 10
set.seed(123)
folds <- createFolds(iris$Species, k = K)
trainData <- list(0) # an Empty list of length K
testData <- list(0)
for (i in 1:K) {
  test_idx <- folds[[i]]
  trainData[[i]] <- iris[-test_idx, ]
  testData[[i]] <- iris[test_idx, ]
}
str(trainData)
#List of 10
#$ :'data.frame':	135 obs. of  5 variables:
#..$ Sepal.Length: num [1:135] 5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
#..$ Sepal.Width : num [1:135] 3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
#..$ Petal.Length: num [1:135] 1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
#..$ Petal.Width : num [1:135] 0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
#..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
#... 
#str(testData)
#List of 10
#$ :'data.frame':	15 obs. of  5 variables:
#..$ Sepal.Length: num [1:15] 5.7 5.1 5.1 4.9 5.1 6.1 6.7 6.1 6 5.8 ...
#..$ Sepal.Width : num [1:15] 3.8 3.7 3.3 3.1 3.4 2.9 3.1 2.8 2.7 2.6 ...
#..$ Petal.Length: num [1:15] 1.7 1.5 1.7 1.5 1.5 4.7 4.4 4.7 5.1 4 ...
#..$ Petal.Width : num [1:15] 0.3 0.4 0.5 0.2 0.2 1.4 1.4 1.2 1.6 1.2 ...
#..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 2 2 2 2 2 ...
#...

NROW(trainData[[1]])
#[1] 135

table(trainData[[1]]$Species)
#setosa versicolor virginica
#    45         45        45

head(trainData[[1]])
#  Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#1          5.1         3.5          1.4         0.2  setosa
#2          4.9         3.0          1.4         0.2  setosa
#3          4.7         3.2          1.3         0.2  setosa
#4          4.6         3.1          1.5         0.2  setosa
#5          5.0         3.6          1.4         0.2  setosa
#6          5.4         3.9          1.7         0.4  setosa

NROW(testData[[1]])
#[1] 15

table(testData[[1]]$Species)
#setosa versicolor virginica
#     5          5         5

head(testData[[1]])
#   Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
#19          5.7         3.8          1.7         0.3     setosa
#22          5.1         3.7          1.5         0.4     setosa
#24          5.1         3.3          1.7         0.5     setosa
#35          4.9         3.1          1.5         0.2     setosa
#40          5.1         3.4          1.5         0.2     setosa
#64          6.1         2.9          4.7         1.4 versicolor

