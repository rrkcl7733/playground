
# randomForest, rpart 패키지와 stagec 데이터 불러오기
library(randomForest)
library(rpart)
data(stagec)
str(stagec)
#'data.frame':	146 obs. of  8 variables:
#$ pgtime : num  6.1 9.4 5.2 3.2 1.9 4.8 5.8 7.3 3.7 15.9 ...
#$ pgstat : int  0 0 1 1 1 0 0 0 1 0 ...
#$ age    : int  64 62 59 62 64 69 75 71 73 64 ...
#$ eet    : int  2 1 2 2 2 1 2 2 2 2 ...
#$ g2     : num  10.26 NA 9.99 3.57 22.56 ...
#$ grade  : int  2 3 3 2 4 3 2 3 3 3 ...
#$ gleason: int  4 8 7 4 8 7 NA 7 6 7 ...
#$ ploidy : Factor w/ 3 levels "diploid","tetraploid",..: 1 3 1 1 2 1 2 3 1 2 ...

table(stagec$ploidy)
#diploid tetraploid  aneuploid 
#     67         68         11 


# 결측값(missing value), 중복 데이터(duplicated data) 확인 및 제거하기
colSums(is.na(stagec))
#pgtime pgstat age eet g2 grade gleason ploidy
#     0      0   0   2  7     0       3      0

sum(is.na(stagec))
#[1] 12

stagec2 <- stagec[complete.cases(stagec), ]
colSums(is.na(stagec2))
#pgtime pgstat age eet g2 grade gleason ploidy
#     0      0   0   0  0     0       0      0

NROW(stagec2)
#[1] 134

sum(duplicated(stagec2))


# 데이터셋(stagec2)을 훈련용 데이터(80%)와 테스트 데이터(20%)로 분리하기
library(caret)
parts <- createDataPartition(stagec2$ploidy, p = 0.8)
stagec.train <- stagec2[parts$Resample1, ]
table(stagec.train$ploidy)
#diploid tetraploid aneuploid
#     52         52         4

stagec.test <- stagec2[-parts$Resample1, ]
table(stagec.test$ploidy)
#diploid tetraploid aneuploid
#     13         12         1


# 훈련용 데이터로 랜덤 포레스트 모델을 생성하기
rf.fit <- randomForest(ploidy~., data = stagec.train, ntree = 500, proximity = TRUE)
rf.fit
#
#Call:
#  randomForest(formula = ploidy ~ ., data = stagec.train, ntree = 500, proximity = TRUE) 
#                Type of random forest: classification
#                      Number of trees: 500
#No. of variables tried at each split: 2
#
#        OOB estimate of  error rate: 6.48%
#Confusion matrix:
#           diploid tetraploid aneuploid class.error
#diploid         49          2         1  0.05769231
#tetraploid       0         52         0  0.00000000
#aneuploid        3          1         0  1.00000000


# plot() 함수로 반응변수 범주별 정오분류율 시각화하기
plot(rf.fit)


l# 설명변수 중요도 확인하기
importance(rf.fit)[order(importance(rf.fit), decreasing = TRUE), ]
#        g2    pgtime       age   gleason    pgstat     grade       eet
#40.4518025 5.0464672 3.8263701 2.4263521 2.0786111 1.2265411 0.9333177

varImpPlot(rf.fit)


# 테스트 데이터로 예측을 수행하고, 랜덤 포레스트 모델의 성능 평가하기
rf.pred <- predict(rf.fit, newdata = stagec.test)
rf.tb <- table(rf.pred, stagec.test$ploidy)
rf.tb
#rf.pred      diploid tetraploid aneuploid
#  diploid         13          0         1
#  tetraploid       0         12         0
#  aneuploid        0          0         0

mean(stagec.test$ploidy == rf.pred) # Accuracy
#[1] 0.9615385

(1-sum(diag(rf.tb))/sum(rf.tb))    # Error Rate
#[1] 0.03846154


