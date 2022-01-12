
# USArrests 데이터셋 불러오기
data("USArrests")
str(USArrests)
#'data.frame':	50 obs. of  4 variables:
#$ Murder  : num  13.2 10 8.1 8.8 9 7.9 3.3 5.9 15.4 17.4 ...
#$ Assault : int  236 263 294 190 276 204 110 238 335 211 ...
#$ UrbanPop: int  58 48 80 50 91 78 77 72 80 60 ...
#$ Rape    : num  21.2 44.5 31 19.5 40.6 38.7 11.1 15.8 31.9 25.8 ...


# USArrests 데이터로 유클리드 거리 계산하기
euc.d <- dist(USArrests, method = "euclidean")


# 유클리드 거리로 계층적 군집분석하기
avg.h <- hclust(euc.d, method = "average")


# 계층적 군집 결과로 덴드로그램 시각화하기
plot(avg.h)


# 계층적 군집 결과를 이용하여 6개 그룹으로 나누기
groups <- cutree(avg.h, k = 6)
groups
#Alabama         Alaska        Arizona       Arkansas     California       Colorado 
#      1              1              1              2              1              2 
#Connecticut       Delaware        Florida        Georgia         Hawaii          Idaho 
#          3              1              4              2              5              3 
#Illinois        Indiana           Iowa         Kansas       Kentucky      Louisiana 
#       1              3              5              3              3              1 
#Maine       Maryland  Massachusetts       Michigan      Minnesota    Mississippi 
#    5              1              6              1              5              1 
#Missouri        Montana       Nebraska         Nevada  New Hampshire     New Jersey 
#       2              3              3              1              5              6 
#New Mexico       New York North Carolina   North Dakota           Ohio       Oklahoma 
#         1              1              4              5              3              6 
#Oregon   Pennsylvania   Rhode Island South Carolina   South Dakota      Tennessee 
#     6              3              6              1              5              2 
#Texas           Utah        Vermont       Virginia     Washington  West Virginia 
#    2              3              5              6              6              5 
#Wisconsin        Wyoming 
#        5              6 


# 계층적 군집 결과를 이용하여 6개 그룹을 사각형으로 구분하기
plot(avg.h)
rect.hclust(avg.h, k = 6, border = "red")


# 계층적 군집 결과를 이용해 3개 군집을 사각형으로 구분하고, 
# tree의 높이(h) 50으로 1, 4번째 군집의 위치(which)를 사각형으로 구분하기
cmp.h <- hclust(dist(USArrests), method = "complete")
plot(cmp.h)
rect.hclust(cmp.h, k = 3, border = "red")
rect.hclust(cmp.h, h = 50, which = c(1, 4), border = 3:4)



