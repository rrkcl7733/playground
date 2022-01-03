
# BreastCancer 데이터셋 종양 구분자 분할표 작성하기
library(mlbench)
data("BreastCancer")
table(BreastCancer$Class)
#benign malignant
#   458       241


# BreastCancer 데이터셋을 훈련용 데이터(70%)와 검증용 데이터(30%)로 분리하기
library(caret)
data <- subset(BreastCancer, select = -Id)
set.seed(123)
parts <- createDataPartition(data$Class, p = 0.7)
data.train <- data[parts$Resample1, ]
table(data.train$Class)
#benign malignant
#   321       169

data.test <- data[-parts$Resample1, ]
table(data.test$Class)
#benign malignant
#   137        72


# 훈련용 데이터를 이용해 의사결정나무 모델을 학습시키고, 
# 검증용 데이터로 의사결정나무 모델의 성능 평가를 수행하기
library(rpart)
dt.m1 <- rpart(Class~., data = data.train)
confusionMatrix(data.test$Class, predict(dt.m1, newdata = data.test, type = "class"))
#Confusion Matrix and Statistics
#
#           Reference
#Prediction  benign malignant
#  benign       128         9
#  malignant      4        68
#
#              Accuracy : 0.9378         
#                95% CI : (0.896, 0.9665)
#   No Information Rate : 0.6316         
#   P-Value [Acc > NIR] : <2e-16         
#
#                 Kappa : 0.8645         
#
#Mcnemar's Test P-Value : 0.2673         
#
#           Sensitivity : 0.9697         
#           Specificity : 0.8831         
#        Pos Pred Value : 0.9343         
#        Neg Pred Value : 0.9444         
#            Prevalence : 0.6316         
#        Detection Rate : 0.6124         
#  Detection Prevalence : 0.6555         
#     Balanced Accuracy : 0.9264         
#
#      'Positive' Class : benign  

