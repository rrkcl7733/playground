
# infert 데이터셋 불러오기
data("infert", package = "datasets")
str(infert)
#'data.frame':	248 obs. of  8 variables:
#$ education     : Factor w/ 3 levels "0-5yrs","6-11yrs",..: 1 1 1 1 2 2 2 2 2 2 ...
#$ age           : num  26 42 39 34 35 36 23 32 21 28 ...
#$ parity        : num  6 1 6 4 3 4 1 2 1 2 ...
#$ induced       : num  1 1 2 2 1 2 0 0 0 0 ...
#$ case          : num  1 1 1 1 1 1 1 1 1 1 ...
#$ spontaneous   : num  2 0 0 0 1 1 0 0 1 0 ...
#$ stratum       : int  1 2 3 4 5 6 7 8 9 10 ...
#$ pooled.stratum: num  3 1 4 2 32 36 6 22 5 19 ...

table(infert$case)
#   0   1 
# 165  83


# 결측값(Missing value), 중복 데이터(Duplicated data) 확인 및 제거하기
colSums(is.na(infert))
#education            age         parity        induced           case    spontaneous 
#        0              0              0              0              0              0 
#stratum pooled.stratum 
#      0              0 

nrow(infert)
#[1] 248

sum(duplicated(infert))
#[1] 31

infert2 <- infert[!duplicated(infert), ]
nrow(infert2)
#[1] 217

sum(duplicated(infert2))
#[1] 0


# 반응변수 구성 분포 확인하기
table(infert2$case); cat("total :", margin.table(table(infert2$case)))
#  0   1 
#134  83 
#total : 217

prop.table(table(infert2$case)) # 0 = 대조 61.75% vs. 1 = 사례 38.25%
#         0         1 
# 0.6175115 0.3824885 


# 목표변수(case)를 Y, 설명변수를 X라는 데이터프레임으로 분리하기
library(dplyr)
Y <- infert2$case
X <- infert2 %>%
  select('age', 'parity', 'induced', 'spontaneous', 'stratum', 'pooled.stratum')


# 설명변수 간의 산점도와 상관계수값 확인하기
library(PerformanceAnalytics)
chart.Correlation(X, histogram = TRUE, col = "grey10", pch = 1)


# 설명변수 간의 상관계수 히트맵 그리기
library(GGally)
ggcorr(X, name = "corr", label = T)


# 설명변수 간의 분산팽창지수(VIF) 확인하기
library(fmsb)
VIF(lm(age ~ ., data = X))
#[1] 1.082952
VIF(lm(parity ~ ., data = X))
#[1] 2.278814
VIF(lm(induced ~ ., data = X))
#[1] 1.773881
VIF(lm(spontaneous ~ ., data = X))
#[1] 1.669696
VIF(lm(stratum ~ ., data = X))
#[1] 3.873179
VIF(lm(pooled.stratum ~ ., data = X))
#[1] 3.667886


# 설명변수 표준화하기
X2 <- scale(X)
var(X2[,])
#                       age     parity     induced spontaneous     stratum pooled.stratum
#age             1.00000000  0.1067976 -0.07064768 -0.04451437 -0.19519692     -0.1392943
#parity          0.10679763  1.0000000  0.40037688  0.34393582 -0.30761505      0.1420194
#induced        -0.07064768  0.4003769  1.00000000 -0.30214629 -0.11164181      0.1474183
#spontaneous    -0.04451437  0.3439358 -0.30214629  1.00000000  0.03446012      0.1937914
#stratum        -0.19519692 -0.3076150 -0.11164181  0.03446012  1.00000000      0.7482550
#pooled.stratum -0.13929427  0.1420194  0.14741830  0.19379142  0.74825495      1.0000000


# t-검증(t-test)을 통한 반응변수와 설명변수 간의 차이가 존재하는지 확인하기
library(dplyr)
infert.data <- data.frame(Y, X2)
X_names <- names(data.frame(X2))
t.test_p.value_df <- data.frame()
for (i in 1:length(X_names)) {
  t.test_p.value <- t.test(infert.data[, X_names[i]]~infert.data$Y,
                           var.equal = TRUE)$p.value
  t.test_p.value_df[i, 1] <- X_names[i]
  t.test_p.value_df[i, 2] <- t.test_p.value
}
colnames(t.test_p.value_df) <- c("x_var_name", "p.value")
t.test_p.value_df <- t.test_p.value_df %>% arrange(p.value)
t.test_p.value_df
#      x_var_name      p.value
#1    spontaneous 8.597087e-07
#2 pooled.stratum 6.001363e-01
#3            age 6.298927e-01
#4        stratum 7.987689e-01
#5        induced 9.365415e-01
#6         parity 9.818527e-01


# 데이터셋(infert.data)을 훈련용 데이터(80%)와 테스트 데이터(20%)로 분리하기
set.seed(123)
train <- sample(1:nrow(infert.data), size = 0.8*nrow(infert.data), replace = F)
test <- (-train)
Y.test <- Y[test]
scales::percent(length(train)/nrow(infert.data))
#[1] "80%"
head(train)
#[1] 63 171 88 189 201 10


# 훈련용 데이터셋을 이용해 인공신경망 모델을 적합하기
library(neuralnet)
net.fit <- neuralnet(formula = Y~spontaneous + pooled.stratum + age + stratum,
                     data = infert.data[train, ],
                     hidden = c(2, 2), err.fct = "ce", threshold = 0.01,
                     linear.output = FALSE, likelihood = TRUE)


# 적합된 모델 시각화하기
plot(net.fit)


# 적합된 모델의 추가적인 정보 확인하기
names(net.fit)
# [1] "call"                "response"            "covariate"           "model.list"         
# [5] "err.fct"             "act.fct"             "linear.output"       "data"               
# [9] "exclude"             "net.result"          "weights"             "generalized.weights"
#[13] "startweights"        "result.matrix"


# 모델 적합에 사용된 자료와 적합된 값 확인하기
out <- cbind(net.fit$covariate, net.fit$net.result[[1]])
dimnames(out) <- list(NULL,
                      c("spontaneous", "pooled.stratum", "age", "stratum", "nn-output"))
head(out)
#     spontaneous pooled.stratum        age    stratum nn-output
#[1,]   0.4783518      0.7322587  0.5168355  0.8522816 0.8057797
#[2,]   0.4783518     -0.8462195 -0.4450282 -1.3127669 0.3195655
#[3,]  -0.8524475     -0.1446736  0.7092082 -1.5625802 0.1393385
#[4,]  -0.8524475      0.5568722 -0.2526554  0.1028417 0.1389183
#[5,]  -0.8524475      1.1414938  0.7092082  0.7690105 0.1389183
#[6,]  -0.8524475     -0.9046817 -0.6374009 -1.3544024 0.3195655


# 일반화 가중치(generalized weights)에 대한 시각화하기
par(mfrow = c(2, 2))
gwplot(net.fit, selected.covariate = "spontaneous", min = -2.5, max = 5)
gwplot(net.fit, selected.covariate = "pooled.stratum", min = -2.5, max = 5)
gwplot(net.fit, selected.covariate = "age", min = -2.5, max = 5)
gwplot(net.fit, selected.covariate = "stratum", min = -2.5, max = 5)
par(mfrow = c(1, 1))


# 테스트 데이터로 적합된 모델의 뉴런 출력값 계산하기(예측값 구하기)
test.data.out <- compute(net.fit, infert.data[test, ])
head(test.data.out$net.result)
#        [,1]
#2  0.3195655
#3  0.3195655
#4  0.3195655
#11 0.3195654
#18 0.3195750
#22 0.1389183

net.pred <- ifelse(test.data.out$net.result > .5, 1, 0)
table(infert.data[test, ]$Y, net.pred)
#net.pred
#   0 1
#0 20 5
#1 11 8

mean(infert.data[test,]$Y == net.pred)   # Accuracy
#[1] 0.6363636


