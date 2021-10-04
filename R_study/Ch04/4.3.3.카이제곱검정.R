
# 누적분포함수(cumulative distribution function)
1 - pchisq(q = 12, df = 5, lower.tail = TRUE)
# [1] 0.03478778


# 누적분포함수(cumulative distribution function)
1 - pchisq(q = 8.33, df = 1, lower.tail = TRUE)
# [1] 0.003899566


# 자유도가 1인 카이제곱 분포
ggplot(data.frame(x=c(0,10)), aes(x=x)) +
  stat_function(fun=dchisq, args=list(df=1), colour="black", size=1.0) +
  geom_text(x=1.0, y=1, label="df=1", size=7.0) +
  geom_vline(xintercept = 3.84, colour = "red", size=1.0)


# FSelector, mlbench 패키지를 설치하고 불러오기
install.packages("FSelector")
install.packages("mlbench")
library(FSelector)
library(mlbench)

data('Vehicle')
# 독립성 검정으로 변수의 중요도 가중치 계산하기
(data_chi <- chi.squared(Class~.,data=Vehicle))
#             attr_importance
#Comp               0.3043172
#Circ               0.2974762
#D.Circ             0.3587826
#Rad.Ra             0.3509038
#Pr.Axis.Ra         0.2264652
#Max.L.Ra           0.3234535
#Scat.Ra            0.4653985
#Elong              0.4556748
#Pr.Axis.Rect       0.4475087
#Max.L.Rect         0.3059760
#Sc.Var.Maxis       0.4338378
#Sc.Var.maxis       0.4921648
#Ra.Gyr             0.2940064
#Skew.Maxis         0.3087694
#Skew.maxis         0.2470216
#Kurt.maxis         0.3338930
#Kurt.Maxis         0.2732117
#Holl.Ra            0.3886266


# 독립성 검정으로 변수의 중요도 가중치 계산에서 5번째 등수까지 선택
cutoff.k(data_chi, 5)
#[1] "Sc.Var.maxis" "Scat.Ra"      "Elong"        "Pr.Axis.Rect" "Sc.Var.Maxis"


