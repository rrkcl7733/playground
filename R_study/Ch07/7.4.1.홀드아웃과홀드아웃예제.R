
# iris 데이터셋 불러오기
data("iris")
nrow(iris)
#[1] 150

head(iris)
#  Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#1          5.1         3.5          1.4         0.2  setosa
#2          4.9         3.0          1.4         0.2  setosa
#3          4.7         3.2          1.3         0.2  setosa
#4          4.6         3.1          1.5         0.2  setosa
#5          5.0         3.6          1.4         0.2  setosa
#6          5.4         3.9          1.7         0.4  setosa


# iris 데이터셋에서 70%를 훈련용 데이터로 30%를 검정용 데이터로 분리하기
set.seed(123)
idx <- sample(2, nrow(iris), replace = TRUE, prob = c(0.7, 0.3))
trainData <- iris[idx == 1, ]
testData <- iris[idx == 2, ]
nrow(trainData)
#[1] 106

nrow(testData)
#[1] 44

