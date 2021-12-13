
# e1071, mlbench 패키지와 HouseVote84 데이터 불러오기
library(e1071)
library(mlbench)
data(HouseVotes84, package = "mlbench")
str(HouseVotes84)
#'data.frame':	435 obs. of  17 variables:
#$ Class: Factor w/ 2 levels "democrat","republican": 2 2 1 1 1 1 1 2 2 1 ...
#$ V1   : Factor w/ 2 levels "n","y": 1 1 NA 1 2 1 1 1 1 2 ...
#$ V2   : Factor w/ 2 levels "n","y": 2 2 2 2 2 2 2 2 2 2 ...
#$ V3   : Factor w/ 2 levels "n","y": 1 1 2 2 2 2 1 1 1 2 ...
#$ V4   : Factor w/ 2 levels "n","y": 2 2 NA 1 1 1 2 2 2 1 ...
#$ V5   : Factor w/ 2 levels "n","y": 2 2 2 NA 2 2 2 2 2 1 ...
#$ V6   : Factor w/ 2 levels "n","y": 2 2 2 2 2 2 2 2 2 1 ...
#$ V7   : Factor w/ 2 levels "n","y": 1 1 1 1 1 1 1 1 1 2 ...
#$ V8   : Factor w/ 2 levels "n","y": 1 1 1 1 1 1 1 1 1 2 ...
#$ V9   : Factor w/ 2 levels "n","y": 1 1 1 1 1 1 1 1 1 2 ...
#$ V10  : Factor w/ 2 levels "n","y": 2 1 1 1 1 1 1 1 1 1 ...
#$ V11  : Factor w/ 2 levels "n","y": NA 1 2 2 2 1 1 1 1 1 ...
#$ V12  : Factor w/ 2 levels "n","y": 2 2 1 1 NA 1 1 1 2 1 ...
#$ V13  : Factor w/ 2 levels "n","y": 2 2 2 2 2 2 NA 2 2 1 ...
#$ V14  : Factor w/ 2 levels "n","y": 2 2 2 1 2 2 2 2 2 1 ...
#$ V15  : Factor w/ 2 levels "n","y": 1 1 1 1 2 2 2 NA 1 NA ...
#$ V16  : Factor w/ 2 levels "n","y": 2 NA 1 2 2 2 2 2 2 NA ...

table(HouseVotes84$Class)
#democrat republican 
#     267        168 

# HouseVotes84 자료 요약하기
summary(HouseVotes84)
#         Class        V1         V2         V3         V4         V5         V6         V7     
#democrat  :267   n   :236   n   :192   n   :171   n   :247   n   :208   n   :152   n   :182  
#republican:168   y   :187   y   :195   y   :253   y   :177   y   :212   y   :272   y   :239  
#                 NA's: 12   NA's: 48   NA's: 11   NA's: 11   NA's: 15   NA's: 11   NA's: 14  
#    V8         V9        V10        V11        V12        V13        V14        V15        V16     
# n   :178   n   :206   n   :212   n   :264   n   :233   n   :201   n   :170   n   :233   n   : 62  
# y   :242   y   :207   y   :216   y   :150   y   :171   y   :209   y   :248   y   :174   y   :269  
# NA's: 15   NA's: 22   NA's:  7   NA's: 21   NA's: 31   NA's: 25   NA's: 17   NA's: 28   NA's:104  

colSums(is.na(HouseVotes84))
#Class    V1    V2    V3    V4    V5    V6    V7    V8    V9   V10   V11   V12   V13   V14   V15   V16 
#    0    12    48    11    11    15    11    14    15    22     7    21    31    25    17    28   104 


# HouseVotes84 자료를 훈련용 데이터(80%)와 테스트 데이터(20%)로 분리하기
library(caret)
parts <- createDataPartition(HouseVotes84$Class, p = 0.8)
data.train <- HouseVotes84[parts$Resample1, ]
table(data.train$Class)
#democrat republican
#     214        135

data.test <- HouseVotes84[-parts$Resample1, ]
table(data.test$Class)
#democrat republican 
#      53         33 


# 훈련용 데이터로 나이브 베이즈 모델을 생성하기
nai.fit <- naiveBayes(Class~., data = data.train)


# 테스트 데이터로 예측을 수행하고, 나이브 베이즈 모델의 성능 평가하기
nai.pred <- predict(nai.fit, data.test[, -1], type = 'class')
nai.tb <- table(nai.pred, data.test$Class)
nai.tb
#nai.pred     democrat republican
#  democrat         50          2
#  republican        3         31

mean(data.test$Class == nai.pred)   # Accuracy
#[1] 0.9418605

(1-sum(diag(nai.tb))/sum(nai.tb))    # Error Rate
#[1] 0.05813953


