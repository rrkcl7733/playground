
# 훈련용 데이터에 업샘플링 적용하기
library(caret)
data.train.up <- upSample(subset(data.train, select = -Class), data.train$Class)
table(data.train.up$Class)
#benign malignant
#   321       321


# 훈련용 데이터를 이용해 의사결정나무 모델을 학습시키고, 
# 검증용 데이터로 의사결정나무 모델의 성능 평가를 수행하기
dt.m2 <- rpart(Class ~., data = data.train.up)
confusionMatrix(data.test$Class, predict(dt.m2, newdata = data.test, type = "class"))
#Confusion Matrix and Statistics
#
#           Reference
#Prediction  benign malignant
#  benign       133         4
#  malignant      6        66
#
#               Accuracy : 0.9522          
#                 95% CI : (0.9138, 0.9768)
#    No Information Rate : 0.6651          
#    P-Value [Acc > NIR] : <2e-16          
#
#                  Kappa : 0.8934          
#
# Mcnemar's Test P-Value : 0.7518          
#                                          
#            Sensitivity : 0.9568          
#            Specificity : 0.9429          
#         Pos Pred Value : 0.9708          
#         Neg Pred Value : 0.9167          
#             Prevalence : 0.6651          
#         Detection Rate : 0.6364          
#   Detection Prevalence : 0.6555          
#      Balanced Accuracy : 0.9498          
#                                          
#       'Positive' Class : benign  

