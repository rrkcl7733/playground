
# 훈련용 데이터에 다운샘플링 적용하기
data.train.down <- downSample(subset(data.train, select = -Class), data.train$Class)
table(data.train.down$Class)
#benign malignant
#   169       169


