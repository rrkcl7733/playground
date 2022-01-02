
# 붓스트랩 방법으로 10개 데이터셋으로 리샘플링 수행하기
library(caret)
boot <- createResample(iris$Species, times = 10)
str(boot)
#List of 10
# $ Resample01: int [1:150] 1 4 8 8 9 9 9 10 11 11 ...
# $ Resample02: int [1:150] 2 2 3 5 6 6 9 13 15 15 ...
# $ Resample03: int [1:150] 1 3 3 4 5 6 6 8 8 9 ...
# $ Resample04: int [1:150] 1 1 2 4 4 4 4 6 7 7 ...
# $ Resample05: int [1:150] 1 2 2 3 3 4 6 7 8 8 ...
# $ Resample06: int [1:150] 1 2 2 3 4 7 7 7 8 10 ...
# $ Resample07: int [1:150] 1 4 5 5 9 10 11 11 11 12 ...
# $ Resample08: int [1:150] 1 1 2 4 4 5 6 7 7 7 ...
# $ Resample09: int [1:150] 1 2 3 3 4 4 4 7 8 8 ...
# $ Resample10: int [1:150] 1 3 3 4 4 4 5 5 7 7 ...

NROW(iris[boot[[1]], ])
#[1] 150

table(iris[boot[[1]], ]$Species)
#setosa versicolor  virginica 
#    48         56         46 

head(iris[boot[[1]], ])
#    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#1            5.1         3.5          1.4         0.2  setosa
#4            4.6         3.1          1.5         0.2  setosa
#8            5.0         3.4          1.5         0.2  setosa
#8.1          5.0         3.4          1.5         0.2  setosa
#9            4.4         2.9          1.4         0.2  setosa
#9.1          4.4         2.9          1.4         0.2  setosa

NROW(unique(iris[boot[[1]], ]))
#[1] 97

table(unique(iris[boot[[1]], ])$Species)
#setosa versicolor virginica
#    30         35        32

