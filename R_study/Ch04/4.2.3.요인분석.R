

# 국내 18개 증권회사 주요 재무제표(2007.3.31기준)  
data <- read.csv(file.path("data", "securities_2007.csv"),     
                 sep = ",", 
                 stringsAsFactors = FALSE, 
                 header = TRUE, 
                 na.strings = "")
head(data)
#  company   V1    V2    V3     V4   V5
#1  oo증권 2.43 11.10 18.46 441.67 0.90
#2  00증권 3.09  9.95 29.46 239.43 0.90
#3  00증권 2.22  6.86 28.62 249.36 0.69
#4  00증권 5.76 23.19 23.47 326.09 1.43
#5  oo증권 1.60  5.64 25.64 289.98 1.42
#6  oo증권 3.53 10.64 32.25 210.10 1.17


# 데이터 표준화 
data <- transform(data,
                  V1z = scale(V1),
                  V2z = scale(V2),
                  V3z = scale(V3),
                  V4z = scale(V4),
                  V5z = scale(V5))
head(data)
#  company   V1    V2    V3     V4   V5        V1z        V2z        V3z          V4z         V5z
#1  oo증권 2.43 11.10 18.46 441.67 0.90 -0.5327135  0.3828740 -0.9182381  1.338962052  0.05067071
#2  00증권 3.09  9.95 29.46 239.43 0.90  0.0484285  0.1311912 -0.3116550 -0.074929674  0.05067071
#3  00증권 2.22  6.86 28.62 249.36 0.69 -0.7176223 -0.5450696 -0.3579759 -0.005507479 -0.52973922
#4  00증권 5.76 23.19 23.47 326.09 1.43  2.3994120  3.0288265 -0.6419671  0.530924049  1.51551482
#5  oo증권 1.60  5.64 25.64 289.98 1.42 -1.2635436 -0.8120723 -0.5223048  0.278473346  1.48787625
#6  oo증권 3.53 10.64 32.25 210.10 1.17  0.4358565  0.2822009 -0.1578035 -0.279980329  0.79691205


colnames(data)
#[1] "company" "V1"      "V2"      "V3"      "V4"      "V5"      "V1z"     "V2z"     "V3z"     "V4z"     "V5z"    

data2 <- data[, c("company","V1z","V2z","V3z","V4z","V5z")]
head(data2)
#  company        V1z        V2z        V3z          V4z         V5z
#1  oo증권 -0.5327135  0.3828740 -0.9182381  1.338962052  0.05067071
#2  00증권  0.0484285  0.1311912 -0.3116550 -0.074929674  0.05067071
#3  00증권 -0.7176223 -0.5450696 -0.3579759 -0.005507479 -0.52973922
#4  00증권  2.3994120  3.0288265 -0.6419671  0.530924049  1.51551482
#5  oo증권 -1.2635436 -0.8120723 -0.5223048  0.278473346  1.48787625
#6  oo증권  0.4358565  0.2822009 -0.1578035 -0.279980329  0.79691205


# factanal() 함수로 요인분석 수행하기 
data_factanal <- factanal(data2[,-1], 
                          factors=2, 
                          rotation="varimax", 
                          scores="regression")
print(data_factanal, cutoff=0)
#
#Call:
#  factanal(x = data2[, -1], factors = 2, scores = "regression",     rotation = "varimax")
#
#Uniquenesses:
#   V1z   V2z   V3z   V4z   V5z 
# 0.005 0.026 0.036 0.083 0.660 
#
#Loadings:
#   Factor1 Factor2
#V1z -0.252   0.965 
#V2z  0.588   0.792 
#V3z -0.979   0.080 
#V4z  0.950  -0.120 
#V5z  0.562   0.155 
#
#Factor1 Factor2
#SS loadings      2.586   1.604
#Proportion Var   0.517   0.321
#Cumulative Var   0.517   0.838
#
#Test of the hypothesis that 2 factors are sufficient.
#The chi square statistic is 1.59 on 1 degree of freedom.
#The p-value is 0.207 


# 요인 점수를 이용한 Biplot 그래프 그리기 
data_factanal$scores
#          Factor1     Factor2
# [1,]  1.01782141 -0.28535410
# [2,]  0.17230586  0.08808775
# [3,]  0.13294211 -0.71511403
# [4,]  1.03557284  2.77950626
# [5,]  0.34416962 -1.21841127
# [6,]  0.01993668  0.44223954
# [7,]  0.62177426  1.26909067
# [8,] -1.79002399  0.28314793
# [9,] -1.60353334  0.52158445
#[10,]  0.55591603 -0.12331881
#[11,] -0.55387868 -1.03939155
#[12,]  0.93740279 -0.74332879
#[13,] -0.45680247  0.06433085
#[14,]  1.13490535 -0.63034122
#[15,] -1.36209539 -0.98147959
#[16,] -1.57141053  0.89812864
#[17,]  0.56190944  0.38006982
#[18,]  0.80308800 -0.98944656


# Biplot 
plot(data_factanal$scores)
text(data_factanal$scores[,1], 
     data_factanal$scores[,2], 
     labels = data2$company, 
     cex=0.7, pos=3, col="blue")
points(data_factanal$loadings, pch=19, col="red")
text(data_factanal$loadings[,1], 
     data_factanal$loadings[,2],
     labels = rownames(data_factanal$loadings),
     cex=0.8, pos=3, col="red")
arrows(0, 0, data_factanal$loadings[1,1], data_factanal$loadings[1,2], col="red")
arrows(0, 0, data_factanal$loadings[2,1], data_factanal$loadings[2,2], col="red")
arrows(0, 0, data_factanal$loadings[3,1], data_factanal$loadings[3,2], col="red")
arrows(0, 0, data_factanal$loadings[4,1], data_factanal$loadings[4,2], col="red")
arrows(0, 0, data_factanal$loadings[5,1], data_factanal$loadings[5,2], col="red")

