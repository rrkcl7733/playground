
# Vehicle 데이터셋 준비하기
library(mlbench)
data("Vehicle")
Vehicle <- subset(Vehicle,
             select = c("Class", "Sc.Var.maxis", "Scat.Ra","Elong", "Pr.Axis.Rect", "Sc.Var.Maxis"))
table(Vehicle$Class)
#Bus opel saab van
#218  212  217 199

Vehicle <- subset(Vehicle, Class == "bus" | Class == "van")
Vehicle$Class <- factor(Vehicle$Class)
table(Vehicle$Class)
# bus van
# 218 199


# 훈련용 데이터(70%)와 테스트용(30%) 데이터 분리하기
set.seed(123)
Vehicle <- Vehicle[sample(nrow(Vehicle)), ]
trainData <- Vehicle[1:(nrow(Vehicle)*0.7), ]
testData <- Vehicle[((nrow(Vehicle)*0.7) + 1):nrow(Vehicle), ]
nrow(trainData)
#[1] 291

nrow(testData)
#[1] 125


# 훈련용 데이터로 신경망, 의사결정나무, 랜덤 포레스트 함수를 이용해 모델 학습하기
library(nnet)
library(rpart)
library(randomForest)
nn.Vehicle <- nnet(Class~., data = trainData, size = 2, rang = 0.1, decay = 5e-4, maxit = 200)
#weights: 15
#initial value 201.419995
#iter 10 value 162.640091
#iter 20 value 158.458745
#iter 30 value 158.442881
#iter 40 value 150.964174
#iter 50 value 147.230521
#iter 60 value 146.973669
#iter 70 value 146.946561
#iter 80 value 146.913141
#iter 90 value 146.909103
#final value 146.906403
#converged

dt.Vehicle <- rpart(Class~., data = trainData)

rf.Vehicle <- randomForest(Class~., data = trainData)


# predict() 함수를 이용해 학습된 모델을 테스트 데이터로 예측하기
nn.pred <- predict(nn.Vehicle, testData, type = "class")
dt.pred <- predict(dt.Vehicle, testData, type = "class")
rf.pred <- predict(rf.Vehicle, testData, type = "class")


# confusionMatrix() 함수로 정오분류표 생성하기
library(e1071)
library(caret)
nn.cmtx <- confusionMatrix(as.factor(nn.pred), testData$Class)
dt.cmtx <- confusionMatrix(as.factor(dt.pred), testData$Class)
rf.cmtx <- confusionMatrix(as.factor(rf.pred), testData$Class)

nn.cmtx$table
#          Reference
#Prediction bus van
#        bus 34   5
#        van 32  54

dt.cmtx$table
#          Reference
#Prediction bus van
#        bus 63   6
#         van 3  53

rf.cmtx$table
#          Reference
#Prediction bus van
#        bus 61   1
#        van  5  58


# 정오분류표를 이용한 대표적인 지표인 정분류율(Accuracy), 
# 정밀도(Precision), 재현율(Recall), F1지표(f1)로 모델 평가하기
accuracy <- c(nn.cmtx$overall['Accuracy'], dt.cmtx$overall['Accuracy'],
              rf.cmtx$overall['Accuracy'])
precision <- c(nn.cmtx$byClass['Pos Pred Value'], dt.cmtx$byClass['Pos Pred Value'],
               rf.cmtx$byClass['Pos Pred Value'])
recall <- c(nn.cmtx$byClass['Sensitivity'], dt.cmtx$byClass['Sensitivity'],
            rf.cmtx$byClass['Sensitivity'])
f1 <- 2 * ((precision * recall) / (precision + recall))
result <- data.frame(rbind(accuracy, precision, recall, f1))
names(result) <- c("Nueral Network", "Decision Tree", "Random Forest")
result
#          Nueral Network Decision Tree Random Forest
#accuracy       0.7040000     0.9280000     0.9520000
#precision      0.8717949     0.9130435     0.9838710
#recall         0.5151515     0.9545455     0.9242424
#f1             0.6476190     0.9333333     0.9531250


