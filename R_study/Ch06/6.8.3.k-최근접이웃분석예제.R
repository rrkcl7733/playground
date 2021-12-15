
# kknn 패키지와 BreastCancer 데이터 불러오기
library(kknn)
library(mlbench)
data("BreastCancer")


# 결측값(Missing value) 확인 및 제거하기
colSums(is.na(BreastCancer))
#Id Cl.thickness Cell.size Cell.shape Marg.adhesion Epith.c.size
# 0            0         0          0             0            0
#Bare.nuclei Bl.cromatin Normal.nucleoli Mitoses Class
#         16           0               0       0     0

sum(is.na(BreastCancer))
#[1] 16

BreastCancer2 <- BreastCancer[complete.cases(BreastCancer), ]


# BreastCancer 데이터로 훈련용 데이터(80%)와 테스트 데이터(20%)로 분리하기
library(caret)
parts <- createDataPartition(BreastCancer2$Class, p = 0.8)
data.train <- BreastCancer2[parts$Resample1, ]
table(data.train$Class)
#benign malignant
#   356       192

data.test <- BreastCancer2[-parts$Resample1, ]
table(data.test$Class)
#benign malignant
#    88        47


# 훈련용 데이터셋을 이용해 최적의 k값 확인하기
kkn.tr <- train.kknn(Class ~ ., data.train[, -1], kmax = 10,
                     distance = 1, kernel = "rectangular")
kkn.tr$MISCLASS
#  rectangular
#1  0.03649635
#2  0.05109489
#3  0.03284672
#4  0.04927007
#5  0.04197080
#6  0.04014599
#7  0.04197080
#8  0.04197080
#9  0.04014599
#10 0.04379562

kkn.tr$best.parameters
#$kernel
#[1] "rectangular"

#$k
#[1] 3


# 준비된 데이터를 이용해 k-최근접 이웃 모델 생성하기
kkn.fit <- kknn(Class~., data.train[, -1], data.test[, -1],
                k = 3, distance = 1, kernel = "rectangular")
summary(kkn.fit)
#Call:
#  kknn(formula = Class~., train = data.train[, -1], test = data.test[, -1],
#       k = 3, distance = 1, kernel = "triangular")
#Response: "nominal"
#     fit prob.benign prob.malignant
#1 benign  1.00000000      0.0000000
#2 benign  1.00000000      0.0000000
#3 benign  1.00000000      0.0000000
# ... [이하 생략]


# 적합된 모델의 추가적인 정보 확인하기
ls(kkn.fit)
#[1] "C"      "call"      "CL"      "D"   "distance"  "fitted.values"
#[7] "prob"   "response"  "terms"   "W"    


# 테스트 데이터로 예측을 수행하고, k-최근접 이웃 모델의 성능 평가하기
kkn.tb <- table(kkn.fit$fitted.values, data.test$Class)
kkn.tb
#          benign malignant
#benign        88         1
#malignant      0        46

mean(data.test$Class == kkn.fit$fitted.values) # Accuracy
#[1] 0.9925926

(1-sum(diag(kkn.tb))/sum(kkn.tb)) # Error Rate
#[1] 0.007407407


