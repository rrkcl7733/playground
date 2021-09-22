

# 데이터셋 읽어오기  
data <- read.csv("D:/사용자/다운로드/소스코드_데이터의모든것_0125/data/securities_2007.csv",     
                 sep = ",", 
                 stringsAsFactors = FALSE, 
                 header = TRUE, 
                 na.strings = "")
tail(data)
#  company   V1    V2    V3     V4   V5
#1  oo증권 2.43 11.10 18.46 441.67 0.90
#2  00증권 3.09  9.95 29.46 239.43 0.90
#3  00증권 2.22  6.86 28.62 249.36 0.69
#4  00증권 5.76 23.19 23.47 326.09 1.43
#5  oo증권 1.60  5.64 25.64 289.98 1.42
#6  oo증권 3.53 10.64 32.25 210.10 1.17


# 데이터 표준화 수행하기 
data <- transform(data,
                  V1z = scale(V1),
                  V2z = scale(V2),
                  V3z = scale(V3),
                  V4z = scale(V4),
                  V5z = scale(V5))
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


# 변수간 상관계수 분석, 산점도 행렬 그래프 그리기
round(cor(data2[,-1]), digits=3)
#       V1z    V2z    V3z    V4z    V5z
#V1z  1.000  0.617  0.324 -0.355  0.014
#V2z  0.617  1.000 -0.512  0.466  0.423
#V3z  0.324 -0.512  1.000 -0.937 -0.563
#V4z -0.355  0.466 -0.937  1.000  0.540
#V5z  0.014  0.423 -0.563  0.540  1.000

# 변수들간의 산점도 행렬도 
plot(data2[,-1])


# 주성분분석 수행하기
data_princomp <- princomp(data2[,-1], cor=TRUE)
summary(data_princomp)
#Importance of components:
#                          Comp.1    Comp.2    Comp.3     Comp.4      Comp.5
#Standard deviation     1.6617648 1.2671437 0.7419994 0.25310701 0.135123510
#Proportion of Variance 0.5522924 0.3211306 0.1101126 0.01281263 0.003651673
#Cumulative Proportion  0.5522924 0.8734231 0.9835357 0.99634833 1.000000000

loadings(data_princomp)
#
#Loadings:
#    Comp.1 Comp.2 Comp.3 Comp.4 Comp.5
#V1z         0.780         0.141  0.605
#V2z -0.395  0.565 -0.295 -0.118 -0.651
#V3z  0.570  0.162  0.241  0.638 -0.429
#V4z -0.560 -0.197 -0.257  0.748  0.150
#V5z -0.448         0.888              
#
#               Comp.1 Comp.2 Comp.3 Comp.4 Comp.5
#SS loadings       1.0    1.0    1.0    1.0    1.0
#Proportion Var    0.2    0.2    0.2    0.2    0.2
#Cumulative Var    0.2    0.4    0.6    0.8    1.0


# 스크리 그림(Scree plot)
plot(data_princomp, type="lines")


# 누적 기여율 
data_cum_prop <- c(0.5522924, 0.8734231, 0.9835357, 0.99634833, 1.000000000)
(data_cum_prop <- as.data.frame(data_cum_prop))
colnames(data_cum_prop) <- c("cum.prop")
data_cum_prop$cum.prop <- round(data_cum_prop$cum.prop, 3)
data_cum_prop$pc <- paste("Comp.", 1:NROW(data_cum_prop), sep="")
data_cum_prop$no <- 1:NROW(data_cum_prop)
data_cum_prop$grp <- c("pc.cum")
data_cum_prop
#  cum.prop     pc no    grp
#1    0.552 Comp.1  1 pc.cum
#2    0.873 Comp.2  2 pc.cum
#3    0.984 Comp.3  3 pc.cum
#4    0.996 Comp.4  4 pc.cum
#5    1.000 Comp.5  5 pc.cum

# 누적기여율 그래프
install.packages('ggplot2')
library(ggplot2)
ggplot(data_cum_prop, aes(x=reorder(pc, no), y=cum.prop, group=as.factor(grp))) +
  geom_line(size=1.0) +
  geom_point(size=2.5, colour="red") +
  geom_text(aes(label=cum.prop), vjust=-0.5, colour="black", position=position_dodge(0.5), size=5) +
  geom_hline(yintercept = 0.7, colour = "red") +
  geom_hline(yintercept = 0.9, colour = "red") +
  ylab("Cumulative proportion") + 
  xlab("PC") +
  scale_y_continuous(breaks=c(0.00,0.10,0.20,0.30,0.40,0.50,0.60,0.70,0.80,0.90,1.00)) +
  theme_bw() +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    axis.title.x = element_text(face = "bold", size = 15),
    axis.title.y = element_text(face = "bold", size = 15),
    axis.text.x = element_text(face = "bold", angle = 45, vjust = 1, hjust = 1, size = 14),
    axis.text.y = element_text(face = "bold", size = 14) 
  ) 


# 고유값을 이용한 막대 그래프 그리기
library(reshape2)
data_eigenvalue <- melt(apply(as.matrix(data2[,-1]) %*% 
                                as.matrix(data_princomp$loadings[,]), 2, var))
data_eigenvalue$PC <- row.names(data_eigenvalue)
colnames(data_eigenvalue) <- c("eigenvalue","PC")
data_eigenvalue$NO <- 1:NROW(data_eigenvalue)
data_eigenvalue$eigenvalue <- round(data_eigenvalue$eigenvalue, 3)
data_eigenvalue
#       eigenvalue     PC NO
#Comp.1      2.924 Comp.1  1
#Comp.2      1.700 Comp.2  2
#Comp.3      0.583 Comp.3  3
#Comp.4      0.068 Comp.4  4
#Comp.5      0.019 Comp.5  5

library(ggplot2)
ggplot(data_eigenvalue, aes(x=reorder(PC, NO), y=eigenvalue)) +
  geom_bar(stat = "identity", width = 0.6, position = position_dodge(0.8), 
           aes(fill=factor(PC))) +
  geom_text(aes(label=eigenvalue), vjust=-0.5, colour="black", 
            position=position_dodge(0.5), size=5) +
  geom_hline(yintercept = 1, colour = "red", size = 1) +
  ylab("eigenvalue") + 
  xlab("PC") +
  ylim(0, 5) +
  theme_bw() +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    axis.title.x = element_text(face = "bold", size = 15),
    axis.title.y = element_text(face = "bold", size = 15),
    axis.text.x = element_text(face="bold", angle=45, vjust=1, hjust=1, size=15),
    axis.text.y = element_text(face = "bold", size = 14)
  ) 


# 주성분점수를 이용한 Biplot 그래프 그리기
biplot(data_princomp, cex = c(0.7, 0.8))
data_pc1 <- predict(data_princomp)[, 1]
data_pc2 <- predict(data_princomp)[, 2]
text(data_pc1, data_pc2, labels = data2$company, cex = 0.7, pos = 3, col = "blue")


