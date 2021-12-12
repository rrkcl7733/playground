
# 훈련용 데이터로 서포트 벡터 머신 모델 생성하기
library(e1071)
svm.fit <- svm(Species ~., data = iris.train)
svm.fit
#
#Call:
#  svm(formula = Species ~ ., data = iris.train)
#
#Parameters:
#  SVM-Type:  C-classification 
#SVM-Kernel:  radial 
#cost:  1 
#
#Number of Support Vectors:  45


# 적합된 모델 추가적인 정보 확인하기
ls(svm.fit)
#[1] "call" "coef0" "coefs" "compprob" "cost"
#[6] "decision.values" "degree" "epsilon" "fitted" "gamma"
#[11] "index" "kernel" "labels" "levels" "na.action"
#[16] "nclasses" "nSV" "nu" "probA" "probB"
#[21] "rho" "scaled" "sigma" "sparse" "SV"
#[26] "terms" "tot.nSV" "type" "x.scale" "y.scale"

svm.fit$cost
#[1] 1

svm.fit$gamma
#[1] 0.25


# 테스트 데이터로 예측을 수행하고, 서포트 벡터 머신 모델의 성능 평가하기
svm.pred <- predict(svm.fit, newdata = iris.test)
table(svm.pred, iris.test$Species)
#svm.pred      setosa versicolor virginica
#  setosa          10          0         0
#  versicolor       0          9         0
#  virginica        0          1        10

mean(iris.test$Species == svm.pred)     # accuracy
#[1] 0.9666667

(1-sum(diag(svm.tb))/sum(svm.tb))       # Error Rate
#[1] 0.03333333


