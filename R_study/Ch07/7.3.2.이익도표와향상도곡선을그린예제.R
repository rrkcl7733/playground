
# 이익도표 그리기
library(ROCR)
library(dplyr)
library(ggplot2)
cls = c('N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N',
        'N', 'N', 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P')
score = c(0.18, 0.24, 0.32, 0.33, 0.4, 0.53, 0.58, 0.59, 0.6, 0.7,
          0.75, 0.85, 0.52, 0.72, 0.73, 0.79, 0.82, 0.88, 0.9, 0.92)
pred = prediction(score, cls)
gain = performance(pred, "tpr", "rpp")
gain.x = unlist(slot(gain, 'x.values'))
gain.y = unlist(slot(gain, 'y.values'))
gain.data = data.frame(gain.x, gain.y)
gain.data %>%
  ggplot(aes(x = gain.x, y = gain.y)) +
  geom_point(size = 2) +
  geom_line(size = 1.3) +
  geom_abline(slope = 1.0, intercept = 0) +
  geom_abline(slope = 2.5, intercept = 0) +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1), labels = scales::percent) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1), labels = scales::percent) +
  theme_minimal(base_family = "NanumGothic") +
  labs(x = "Rate of Positive Predictions", y = "True Positive Rate", title = "Gain Chart")


# 향상도 곡선 그리기
lift = performance(pred, "lift", "rpp")
lift.x = unlist(slot(lift, 'x.values'))
lift.y = unlist(slot(lift, 'y.values'))
lift.data <- data.frame(lift.x, lift.y)
lift.data %>%
  ggplot(aes(x = lift.x, y = lift.y)) +
  geom_point(size = 2) +
  geom_line(size = 1.3) +
  geom_hline(yintercept = 1, size = 1.3, color = "darkgray") +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1)) +
  scale_y_continuous(limits = c(0, 3), breaks = seq(0, 3, 0.5)) +
  theme_minimal(base_family = "NanumGothic") +
  labs(x = "Rate of Positive Predictions", y = "Lift value", title = "Lift Curve")

