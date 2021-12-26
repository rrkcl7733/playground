
# 테스트 데이터의 예측 결과로 인공신경망, 의사결정나무, 로지스틱 회귀 모델의 ROC 곡선 그리기
library(pROC)
nn_roc <- roc(testData$case, testData$nn_pred)
dt_roc <- roc(testData$case, testData$dt_pred)
glm_roc <- roc(testData$case, testData$glm_pred)
plot.roc(nn_roc, col = "red", lty = 1, lwd = 3, print.auc = TRUE, print.auc.adj = c(2.9, -12.5),
         max.auc.polygon = FALSE, print.thres = FALSE, print.thres.pch = 19,
         print.thres.col = "red", print.thres.adj = c(0.3, -1.2))
plot.roc(dt_roc, add = TRUE, col = "blue", lty = 3, lwd = 3, print.auc = TRUE,
         print.auc.adj = c(1.2, 1.2), print.thres = FALSE, print.thres.pch = 19,
         print.thres.col = "blue", print.thres.adj = c(-0.085, 1.1))
plot.roc(glm_roc, add = TRUE, col = "black", lty = 5, lwd = 3, print.auc = TRUE,
         print.auc.adj = c(2.0, -4.5), print.thres = FALSE, print.thres.pch = 19,
         print.thres.col = "black", print.thres.adj = c(-0.085, 1.1))
legend("bottomright", legend = c("neural network", "decision tree", "logistic regression"),
       col = c("red", "blue", "black"), lty = c(1, 3, 5), lwd = 1)

