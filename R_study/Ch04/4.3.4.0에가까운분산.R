

# mlbench, caret 패키지를 설치하고 불러오기
install.packages("mlbench")
install.packages("caret")
library(mlbench)
library(caret)


# Soybean 데이터셋 읽어오기
data("Soybean")
NROW(Soybean)
#[1] 683
NCOL(Soybean)
#[1] 36


# nearZeroVar() 함수로 데이터에서 분산이 0에 가까운 변수 확인하기
nearZeroVar(Soybean, saveMetrics=TRUE)
#                 freqRatio percentUnique zeroVar   nzv
#Class             1.010989     2.7818448   FALSE FALSE
#date              1.137405     1.0248902   FALSE FALSE
#plant.stand       1.208191     0.2928258   FALSE FALSE
#precip            4.098214     0.4392387   FALSE FALSE
#temp              1.879397     0.4392387   FALSE FALSE
#hail              3.425197     0.2928258   FALSE FALSE
#crop.hist         1.004587     0.5856515   FALSE FALSE
#area.dam          1.213904     0.5856515   FALSE FALSE
#sever             1.651282     0.4392387   FALSE FALSE
#seed.tmt          1.373874     0.4392387   FALSE FALSE
#germ              1.103627     0.4392387   FALSE FALSE
#plant.growth      1.951327     0.2928258   FALSE FALSE
#leaves            7.870130     0.2928258   FALSE FALSE
#leaf.halo         1.547511     0.4392387   FALSE FALSE
#leaf.marg         1.615385     0.4392387   FALSE FALSE
#leaf.size         1.479638     0.4392387   FALSE FALSE
#leaf.shread       5.072917     0.2928258   FALSE FALSE
#leaf.malf        12.311111     0.2928258   FALSE FALSE
#leaf.mild        26.750000     0.4392387   FALSE  TRUE
#stem              1.253378     0.2928258   FALSE FALSE
#lodging          12.380952     0.2928258   FALSE FALSE
#stem.cankers      1.984293     0.5856515   FALSE FALSE
#canker.lesion     1.807910     0.5856515   FALSE FALSE
#fruiting.bodies   4.548077     0.2928258   FALSE FALSE
#ext.decay         3.681481     0.4392387   FALSE FALSE
#mycelium        106.500000     0.2928258   FALSE  TRUE
#int.discolor     13.204545     0.4392387   FALSE FALSE
#sclerotia        31.250000     0.2928258   FALSE  TRUE
#fruit.pods        3.130769     0.5856515   FALSE FALSE
#fruit.spots       3.450000     0.5856515   FALSE FALSE
#seed              4.139130     0.2928258   FALSE FALSE
#mold.growth       7.820896     0.2928258   FALSE FALSE
#seed.discolor     8.015625     0.2928258   FALSE FALSE
#seed.size         9.016949     0.2928258   FALSE FALSE
#shriveling       14.184211     0.2928258   FALSE FALSE
#roots             6.406977     0.4392387   FALSE FALSE


# 데이터에서 분산이 0에 가까운 변수만 선택하여 제거하기
nearZeroVar(Soybean)
#[1] 19 26 28
colnames(Soybean[,nearZeroVar(Soybean)])
#[1] "leaf.mild" "mycelium"  "sclerotia"
data_Soybean <- Soybean[, -nearZeroVar(Soybean)]
nearZeroVar(data_Soybean)
#integer(0)

