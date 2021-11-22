
# 유방암(BreastCancer) 데이터셋 불러오기
library(mlbench)
data("BreastCancer")
str(BreastCancer)
#'data.frame':	699 obs. of  11 variables:
#$ Id             : chr  "1000025" "1002945" "1015425" "1016277" ...
#$ Cl.thickness   : Ord.factor w/ 10 levels "1"<"2"<"3"<"4"<..: 5 5 3 6 4 8 1 2 2 4 ...
#$ Cell.size      : Ord.factor w/ 10 levels "1"<"2"<"3"<"4"<..: 1 4 1 8 1 10 1 1 1 2 ...
#$ Cell.shape     : Ord.factor w/ 10 levels "1"<"2"<"3"<"4"<..: 1 4 1 8 1 10 1 2 1 1 ...
#$ Marg.adhesion  : Ord.factor w/ 10 levels "1"<"2"<"3"<"4"<..: 1 5 1 1 3 8 1 1 1 1 ...
#$ Epith.c.size   : Ord.factor w/ 10 levels "1"<"2"<"3"<"4"<..: 2 7 2 3 2 7 2 2 2 2 ...
#$ Bare.nuclei    : Factor w/ 10 levels "1","2","3","4",..: 1 10 2 4 1 10 10 1 1 1 ...
#$ Bl.cromatin    : Factor w/ 10 levels "1","2","3","4",..: 3 3 3 3 3 9 3 3 1 2 ...
#$ Normal.nucleoli: Factor w/ 10 levels "1","2","3","4",..: 1 2 1 7 1 7 1 1 1 1 ...
#$ Mitoses        : Factor w/ 9 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 5 1 ...
#$ Class          : Factor w/ 2 levels "benign","malignant": 1 1 1 1 1 2 1 1 1 1 ...

table(BreastCancer$Class)
#benign malignant 
#   458       241 


# 결측값(Missing value) 확인 및 제거하기
colSums(is.na(BreastCancer))
#Id    Cl.thickness       Cell.size      Cell.shape   Marg.adhesion    Epith.c.size     Bare.nuclei 
# 0               0               0               0               0               0              16 
#Bl.cromatin Normal.nucleoli         Mitoses           Class 
#          0               0               0               0 

sum(is.na(BreastCancer))
# [1] 16

BreastCancer2 <- BreastCancer[complete.cases(BreastCancer), ]
sum(is.na(BreastCancer2))
# [1] 0


# 중복 데이터(Duplicated data) 확인 및 제거하기
nrow(BreastCancer2)
# [1] 683

sum(duplicated(BreastCancer2))
# [1] 8

BreastCancer3 <- BreastCancer2[!duplicated(BreastCancer2), ]
nrow(BreastCancer3)
# [1] 675

sum(duplicated(BreastCancer3))
#[1] 0


# 반응변수 구성 분포 확인
table(BreastCancer3$Class); cat("total :", margin.table(table(BreastCancer3$Class)))
nrow(BreastCancer3)
# benign malignant
#   439       236
# total : 675

prop.table(table(BreastCancer3$Class))
#    benign  malignant
# 0.6503704  0.3496296


# 설명변수의 타입을 숫자타입으로 변환하기
Y <- ifelse(BreastCancer3$Class == 'malignant', 1, 0)
X <- BreastCancer3[, c(2:10)]
X$Cl.thickness <- as.integer(X$Cl.thickness)
X$Cell.size <- as.integer(X$Cell.size)
X$Cell.shape <- as.integer(X$Cell.shape)
X$Marg.adhesion <- as.integer(X$Marg.adhesion)
X$Epith.c.size <- as.integer(X$Epith.c.size)
X$Bare.nuclei <- as.integer(X$Bare.nuclei)
X$Bl.cromatin <- as.integer(X$Bl.cromatin)
X$Normal.nucleoli <- as.integer(X$Normal.nucleoli)
X$Mitoses <- as.integer(X$Mitoses)


# 설명변수 간의 산점도와 상관계수 확인하기
library(PerformanceAnalytics)
chart.Correlation(X, histogram = TRUE, col = "grey10", pch = 1)


# 설명변수 간의 상관계수 히트맵 그리기
library(GGally)
ggcorr(X, name = "corr", label = T)


# 설명변수 간의 분산팽창지수(VIF) 확인하기
library(fmsb)
VIF(lm(Cl.thickness ~ ., data = X))
# [1] 1.90642
VIF(lm(Cell.size ~ ., data = X))
# [1] 7.109585
VIF(lm(Cell.shape ~ ., data = X))
# [1] 6.462976
VIF(lm(Marg.adhesion ~ ., data = X))
# [1] 2.523803
VIF(lm(Epith.c.size ~ ., data = X))
# [1] 2.530673
VIF(lm(Bare.nuclei ~ ., data = X))
# [1] 2.589232
VIF(lm(Bl.cromatin ~ ., data = X))
# [1] 2.903433
VIF(lm(Normal.nucleoli ~ ., data = X))
# [1] 2.461502
VIF(lm(Mitoses ~ .,data = X))
# [1] 1.403406


# 설명변수 표준화하기
X2 <- scale(X)
var(X2[, ])
#                Cl.thickness Cell.size Cell.shape Marg.adhesion Epith.c.size Bare.nuclei Bl.cromatin
#Cl.thickness       1.0000000 0.6408468  0.6526171     0.4894212    0.5191716   0.5939357   0.5564040
#Cell.size          0.6408468 1.0000000  0.9057554     0.7146499    0.7488287   0.6898953   0.7594179
#Cell.shape         0.6526171 0.9057554  1.0000000     0.6940289    0.7171865   0.7108760   0.7378729
#Marg.adhesion      0.4894212 0.7146499  0.6940289     1.0000000    0.6034792   0.6764278   0.6717437
#Epith.c.size       0.5191716 0.7488287  0.7171865     0.6034792    1.0000000   0.5827524   0.6226487
#Bare.nuclei        0.5939357 0.6898953  0.7108760     0.6764278    0.5827524   1.0000000   0.6791367
#Bl.cromatin        0.5564040 0.7594179  0.7378729     0.6717437    0.6226487   0.6791367   1.0000000
#Normal.nucleoli    0.5338912 0.7237118  0.7232412     0.6021876    0.6341289   0.5879502   0.6688204
#Mitoses            0.3548217 0.4667208  0.4485088     0.4245258    0.4846702   0.3495506   0.3532766
#                Normal.nucleoli   Mitoses
#Cl.thickness          0.5338912 0.3548217
#Cell.size             0.7237118 0.4667208
#Cell.shape            0.7232412 0.4485088
#Marg.adhesion         0.6021876 0.4245258
#Epith.c.size          0.6341289 0.4846702
#Bare.nuclei           0.5879502 0.3495506
#Bl.cromatin           0.6688204 0.3532766
#Normal.nucleoli       1.0000000 0.4363314
#Mitoses               0.4363314 1.0000000


# t-검증(t-test)을 통한 반응변수와 설명변수 간의 차이가 존재하는지 확인하기
library(dplyr)
BreastCancer4 <- data.frame(Y, X2)
X_names <- names(data.frame(X2))
t.test_p.value_df <- data.frame()
for (i in 1:length(X_names)) {
  t.test_p.value <- t.test(BreastCancer4[, X_names[i]]~BreastCancer4$Y,
                           var.equal = TRUE)$p.value
  t.test_p.value_df[i, 1] <- X_names[i]
  t.test_p.value_df[i, 2] <- t.test_p.value
}
colnames(t.test_p.value_df) <- c("x_var_name", "p.value")
t.test_p.value_df <- t.test_p.value_df %>% arrange(p.value)
t.test_p.value_df
#       x_var_name       p.value
#1      Cell.shape 9.592587e-166
#2       Cell.size 1.000379e-165
#3     Bare.nuclei 1.248282e-165
#4     Bl.cromatin 3.791752e-127
#5 Normal.nucleoli 9.247143e-110
#6    Cl.thickness 5.148514e-107
#7   Marg.adhesion 5.278548e-105
#8    Epith.c.size  2.242968e-96
#9         Mitoses  4.251643e-32


# 데이터셋을 훈련용 데이터(80%)와 테스트 데이터(20%)로 분리하기
set.seed(123)
train <- sample(1:nrow(BreastCancer4), size = 0.8*nrow(BreastCancer4), replace = F)
test <- (-train)
Y.test <- Y[test]
scales::percent(length(train)/nrow(BreastCancer4))
# [1] "80%"
head(train)
# [1] 195 532 276 594 632  31


# 훈련용 데이터로 로지스틱 회귀 모델 적합하기
glm.fit <- glm(Y~., data = BreastCancer4, family = binomial(link = "logit"), subset = train)
summary(glm.fit)
#
#Call:
#  glm(formula = Y ~ ., family = binomial(link = "logit"), data = BreastCancer4, 
#      subset = train)
#
#Deviance Residuals: 
#    Min       1Q   Median       3Q      Max  
#-3.3535  -0.1344  -0.0686   0.0216   2.3780  
#
#Coefficients:
#  Estimate Std. Error z value Pr(>|z|)    
#(Intercept)     -1.00864    0.36832  -2.738 0.006172 ** 
#Cl.thickness     1.41131    0.43279   3.261 0.001110 ** 
#Cell.size       -0.05671    0.68019  -0.083 0.933554    
#Cell.shape       0.87409    0.72839   1.200 0.230128    
#Marg.adhesion    0.98337    0.37274   2.638 0.008334 ** 
#Epith.c.size     0.43534    0.36779   1.184 0.236547    
#Bare.nuclei      1.47806    0.39113   3.779 0.000158 ***
#Bl.cromatin      0.80216    0.44001   1.823 0.068294 .  
#Normal.nucleoli  0.58023    0.35380   1.640 0.101007    
#Mitoses          0.84191    0.69655   1.209 0.226778    
#---
#  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#
#(Dispersion parameter for binomial family taken to be 1)
#
#    Null deviance: 691.519  on 539  degrees of freedom
#Residual deviance:  92.505  on 530  degrees of freedom
#AIC: 112.5
#
#Number of Fisher Scoring iterations: 8


# 설명변수 제거를 위해 후진제거법(backward elimination)을 사용해서 모델을 적합하기
step(glm.fit, direction = "backward")
#Start:  AIC=112.5
#Y ~ Cl.thickness + Cell.size + Cell.shape + Marg.adhesion + Epith.c.size + 
#    Bare.nuclei + Bl.cromatin + Normal.nucleoli + Mitoses
#
#                  Df Deviance    AIC
#- Cell.size        1   92.512 110.51
#- Cell.shape       1   93.859 111.86
#- Epith.c.size     1   93.895 111.89
#<none>                 92.505 112.50
#- Normal.nucleoli  1   95.290 113.29
#- Mitoses          1   95.318 113.32
#- Bl.cromatin      1   95.993 113.99
#- Marg.adhesion    1   99.899 117.90
#- Cl.thickness     1  105.193 123.19
#- Bare.nuclei      1  109.832 127.83
#
#Step:  AIC=110.51
#Y ~ Cl.thickness + Cell.shape + Marg.adhesion + Epith.c.size + 
#    Bare.nuclei + Bl.cromatin + Normal.nucleoli + Mitoses
#
#                  Df Deviance    AIC
#- Epith.c.size     1   93.899 109.90
#<none>                 92.512 110.51
#- Cell.shape       1   95.176 111.18
#- Normal.nucleoli  1   95.297 111.30
#- Mitoses          1   95.339 111.34
#- Bl.cromatin      1   96.085 112.08
#- Marg.adhesion    1  100.038 116.04
#- Cl.thickness     1  105.326 121.33
#- Bare.nuclei      1  109.842 125.84
#
#Step:  AIC=109.9
#Y ~ Cl.thickness + Cell.shape + Marg.adhesion + Bare.nuclei + 
#    Bl.cromatin + Normal.nucleoli + Mitoses
#
#                  Df Deviance    AIC
#<none>                 93.899 109.90
#- Mitoses          1   96.757 110.76
#- Normal.nucleoli  1   97.143 111.14
#- Cell.shape       1   97.833 111.83
#- Bl.cromatin      1   98.440 112.44
#- Marg.adhesion    1  102.992 116.99
#- Cl.thickness     1  107.009 121.01
#- Bare.nuclei      1  112.294 126.29
#
#Call:  glm(formula = Y ~ Cl.thickness + Cell.shape + Marg.adhesion + 
#     Bare.nuclei + Bl.cromatin + Normal.nucleoli + Mitoses, family = binomial(link = "logit"), 
#     data = BreastCancer4, subset = train)
#
#Coefficients:
#  (Intercept)     Cl.thickness       Cell.shape    Marg.adhesion      Bare.nuclei      Bl.cromatin  
#        -0.9608           1.4003           0.9914           1.0430           1.5215           0.8882  
#Normal.nucleoli          Mitoses  
#         0.6295           0.7982  
#
#Degrees of Freedom: 539 Total (i.e. Null);  532 Residual
#Null Deviance:	    691.5 
#Residual Deviance: 93.9 	AIC: 109.9


# 후진제거법의 3모델(Cell.size, Epith.c.size 설명변수 제거)을 적합하고, 모델의 유의성 검정하기
glm.fit.2 <- glm(Y~ Cell.shape + Normal.nucleoli + Mitoses + Bl.cromatin + Marg.adhesion +
                    Cl.thickness + Bare.nuclei,
                    data = BreastCancer4, family = binomial(link = "logit"), subset = train)
anova(glm.fit.2, test = "Chisq")
#Analysis of Deviance Table
#
#Model: binomial, link: logit
#
#Response: Y
#
#Terms added sequentially (first to last)
#
#                Df Deviance Resid. Df Resid. Dev  Pr(>Chi)    
#NULL                              539     691.52              
#Cell.shape       1   471.35       538     220.17 < 2.2e-16 ***
#Normal.nucleoli  1    31.21       537     188.96 2.315e-08 ***
#Mitoses          1    17.66       536     171.30 2.648e-05 ***
#Bl.cromatin      1    24.47       535     146.84 7.567e-07 ***
#Marg.adhesion    1    14.34       534     132.50 0.0001526 ***
#Cl.thickness     1    20.20       533     112.29 6.970e-06 ***
#Bare.nuclei      1    18.40       532      93.90 1.795e-05 ***
#---
#Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1


# 테스트 데이터로 모델 성능 평가 수행하기
glm.probs <- predict(glm.fit.2, BreastCancer4[test, ], type = "response")
glm.pred <- ifelse(glm.probs > .5, 1, 0)
table(Y.test, glm.pred)
#       glm.pred
#Y.test  0  1
#     0 81  1
#     1  0 53

mean(Y.test == glm.pred) # Accuracy
# [1] 0.9925926
mean(Y.test != glm.pred) # Error Rate
# [1] 0.007407407


# ROC 그래프와 AUC 확인하기
library(ROCR)
pr <- prediction(glm.probs, Y.test)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf, main = "ROC Curve")
auc <- performance(pr, measure = "auc")
auc <- auc@y.values[[1]]
auc
# [1] 0.9990796


