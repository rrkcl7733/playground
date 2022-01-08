
# 훈련용 데이터에 SMOTE 적용하기
library(DMwR)
data.train.smote <- SMOTE(Class ~., data = data.train, perc.over = 200, perc.under = 150)
table(data.train.smote$Class)
#benign malignant 
#   507       507 


# 훈련용 데이터를 이용해 의사결정나무 모델을 학습시키고, 
# 검증용 데이터로 의사결정나무 모델의 성능 평가를 수행하기
dt.m3 <- rpart(Class ~., data = data.train.smote)
confusionMatrix(data.test$Class, predict(dt.m3, newdata = data.test, type = "class"))
#Confusion Matrix and Statistics
#
#           Reference
#Prediction  benign malignant
#  benign       124        13
#  malignant      3        69
#
#               Accuracy : 0.9234          
#                 95% CI : (0.8787, 0.9556)
#    No Information Rate : 0.6077          
#    P-Value [Acc > NIR] : < 2e-16         
#
#                  Kappa : 0.8359          
#
# Mcnemar's Test P-Value : 0.02445         
#                                          
#            Sensitivity : 0.9764          
#            Specificity : 0.8415          
#         Pos Pred Value : 0.9051          
#         Neg Pred Value : 0.9583          
#             Prevalence : 0.6077          
#         Detection Rate : 0.5933          
#   Detection Prevalence : 0.6555          
#      Balanced Accuracy : 0.9089          
#                                          
#       'Positive' Class : benign  


