
# infert 데이터셋 준비하기
data("infert")
set.seed(123)
infert <- infert[sample(nrow(infert)), ]
infert <- infert[, c("age", "parity", "induced", "spontaneous", "case")]


# 모델 학습 및 검증을 위해 훈련용(70%) 데이터와 테스트용(30%) 데이터 분리하기
trainData <- infert[1:(nrow(infert)*0.7), ]
testData <- infert[((nrow(infert)*0.7) + 1):nrow(infert), ]
nrow(trainData)
#[1] 173

nrow(testData)
#[1] 74


# 훈련용 데이터로 인공신경망 모델을 학습하고, 
# 테스트 데이터로 예측한 결과를 테스트 데이터의 속성으로 추가하기
library(neuralnet)
library(C50)
nn.infert <- neuralnet(case ~ age + parity + induced + spontaneous,
                       data = trainData,
                       hidden = 3,
                       err.fct = "ce",
                       linear.output = FALSE,
                       likelihood = TRUE)
nn.pred <- compute(nn.infert, subset(testData, select = -case))
testData$nn_pred <- nn.pred$net.result
head(testData)
#    age parity induced spontaneous case    nn_pred
#141  28      2       2           0    0 0.48179316
#78   25      1       1           0    1 0.09623713
#124  39      3       1           0    0 0.09534660
#27   38      2       0           2    1 0.72341105
#96   31      1       0           0    0 0.09534661
#62   25      1       0           1    1 0.71845509


# 훈련용 데이터로 의사결정나무 모델을 학습하고, 
# 테스트 데이터로 예측한 결과를 테스트 데이터의 속성으로 추가하기
trainData$case <- factor(trainData$case)
dt.infert <- C5.0(case ~ age + parity + induced + spontaneous, data = trainData)
testData$dt_pred <- predict(dt.infert, testData, type = "prob")[, 2]
head(testData)
#    age parity induced spontaneous case    nn_pred   dt_pred
#141  28      2       2           0    0 0.48179316 0.1563053
#78   25      1       1           0    1 0.09623713 0.1563053
#124  39      3       1           0    0 0.09534660 0.1563053
#27   38      2       0           2    1 0.72341105 0.6069364
#96   31      1       0           0    0 0.09534661 0.1563053
#62   25      1       0           1    1 0.71845509 0.6527168


# 훈련용 데이터로 로지스틱 회귀 모델을 학습하고, 
# 테스트 데이터로 예측한 결과를 테스트 데이터의 속성으로 추가하기
trainData$case <- factor(trainData$case)
glm.infert <- glm(case ~ age + parity + induced + spontaneous,
                  data = trainData, family = "binomial")
testData$glm_pred <- predict(glm.infert, testData)
head(testData)
#    age parity induced spontaneous case    nn_pred   dt_pred   glm_pred
#141  28      2       2           0    0 0.48179316 0.1563053 -0.3763508
#78   25      1       1           0    1 0.09623713 0.1563053 -1.0055906
#124  39      3       1           0    0 0.09534660 0.1563053 -1.9334082
#27   38      2       0           2    1 0.72341105 0.6069364  1.5821414
#96   31      1       0           0    0 0.09534661 0.1563053 -2.0120801
#62   25      1       0           1    1 0.71845509 0.6527168 -0.2429922


# 테스트 데이터의 예측 결과로 인공신경망 모델의 ROC 곡선 그리기
library(Epi)
ROC(form = case ~ nn_pred, data = testData, plot = "ROC")


# 테스트 데이터의 예측 결과로 의사결정나무 모델의 ROC 곡선 그리기
ROC(form = case ~ dt_pred, data = testData, plot = "ROC")


# 테스트 데이터의 예측 결과로 로지스틱 회귀 모델의 ROC 곡선 그리기
ROC(form = case ~ glm_pred, data = testData, plot = "ROC")



