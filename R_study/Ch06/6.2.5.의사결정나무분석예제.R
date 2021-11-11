
# 훈련용 데이터로 의사결정나무 모델 학습하기
library(party)
(dt.m2 <- ctree(Species ~., data = data.train))
#
#      Conditional inference tree with 4 terminal nodes
#
#Response:  Species 
#Inputs:  Sepal.Length, Sepal.Width, Petal.Length, Petal.Width 
#Number of observations:  120 
#
#1) Petal.Length <= 1.9; criterion = 1, statistic = 112.224
#  2)*  weights = 40 
#1) Petal.Length > 1.9
#  3) Petal.Width <= 1.6; criterion = 1, statistic = 52.249
#    4) Petal.Length <= 4.8; criterion = 0.999, statistic = 14.29
#      5)*  weights = 36 
#    4) Petal.Length > 4.8
#      6)*  weights = 7 
#  3) Petal.Width > 1.6
#    7)*  weights = 37 


# 적합된 의사결정나무 모델 시각화하기
plot(dt.m2)
# 테스트 데이터로 예측을 수행하고, 의사결정나무 모델의 성능 평가하기
dt.m2.pred <- predict(dt.m2, newdata = data.test)
confusionMatrix(data.test$Species, dt.m2.pred)
# Confusion Matrix and Statistics
#
#            Reference
#Prediction   setosa versicolor virginica
#  setosa         10          0         0
#  versicolor      0          9         1
#  virginica       0          0        10
#
#Overall Statistics
#
#              Accuracy : 0.9667          
#                95% CI : (0.8278, 0.9992)
#   No Information Rate : 0.3667          
#   P-Value [Acc > NIR] : 4.476e-12       
#
#                 Kappa : 0.95            
#
#Mcnemar's Test P-Value : NA              
#
#Statistics by Class:
#
#                     Class: setosa Class: versicolor Class: virginica
#Sensitivity                 1.0000            1.0000           0.9091
#Specificity                 1.0000            0.9524           1.0000
#Pos Pred Value              1.0000            0.9000           1.0000
#Neg Pred Value              1.0000            1.0000           0.9500
#Prevalence                  0.3333            0.3000           0.3667
#Detection Rate              0.3333            0.3000           0.3333
#Detection Prevalence        0.3333            0.3333           0.3333
#Balanced Accuracy           1.0000            0.9762           0.9545

