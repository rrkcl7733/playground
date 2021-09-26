

# mlbench 패키지 설치하고 불러오기
install.packages("mlbench")
library(mlbench)


# Vehicle 데이트셋 불러오기
data("Vehicle")
head(Vehicle,2)
#  Comp Circ D.Circ Rad.Ra Pr.Axis.Ra Max.L.Ra Scat.Ra Elong Pr.Axis.Rect Max.L.Rect
#1   95   48     83    178         72       10     162    42           20        159
#2   91   41     84    141         57        9     149    45           19        143
#  Sc.Var.Maxis Sc.Var.maxis Ra.Gyr Skew.Maxis Skew.maxis Kurt.maxis Kurt.Maxis Holl.Ra Class
#1          176          379    184         70          6         16        187     197   van
#2          170          330    158         72          9         14        189     199   van
NROW(Vehicle)
#[1] 846
NCOL(Vehicle)
#[1] 19


# 상관계수 분석하기
round(cor(subset(Vehicle, select = -c(Class)))[1:6, 1:6], 3)
#            Comp  Circ D.Circ Rad.Ra Pr.Axis.Ra Max.L.Ra
#Comp       1.000 0.693  0.792  0.692      0.093    0.148
#Circ       0.693 1.000  0.798  0.623      0.150    0.247
#D.Circ     0.792 0.798  1.000  0.772      0.162    0.264
#Rad.Ra     0.692 0.623  0.772  1.000      0.665    0.448
#Pr.Axis.Ra 0.093 0.150  0.162  0.665      1.000    0.648
#Max.L.Ra   0.148 0.247  0.264  0.448      0.648    1.000


# 상관계수가 높은 변수 확인하기
install.packages("caret")
library(caret)
(col.idx <-  findCorrelation(cor(subset(Vehicle, select = -c(Class)))))
#[1]  3  8 11  7  9  2
colnames(subset(Vehicle, select = -c(Class)))[col.idx]
#[1] "D.Circ"   "Elong"   "Sc.Var.Maxis" "Scat.Ra"  "Pr.Axis.Rect" "Circ"       


# 상관계수가 높은 변수의 상관계수 분석하기
cor(subset(Vehicle, select = -c(Class)))[c(3,8,11,7,9,2), c(3,8,11,7,9,2)]
#                 D.Circ      Elong Sc.Var.Maxis    Scat.Ra Pr.Axis.Rect       Circ
#D.Circ        1.0000000 -0.9123072    0.8644323  0.9072801    0.8953261  0.7984920
#Elong        -0.9123072  1.0000000   -0.9383919 -0.9733853   -0.9505124 -0.8287548
#Sc.Var.Maxis  0.8644323 -0.9383919    1.0000000  0.9518621    0.9382664  0.8084963
#Scat.Ra       0.9072801 -0.9733853    0.9518621  1.0000000    0.9920883  0.8603671
#Pr.Axis.Rect  0.8953261 -0.9505124    0.9382664  0.9920883    1.0000000  0.8579253
#Circ          0.7984920 -0.8287548    0.8084963  0.8603671    0.8579253  1.0000000


# 산점도 행렬도
plot(Vehicle[,c(3,8,11,7,9,2)])



