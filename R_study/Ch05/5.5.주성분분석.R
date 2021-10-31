# 5.5   주성분분석 
# 5.5.4 주성분분석의 예 

fit <- princomp(iris[,1:4], cor = TRUE) 


# 5.5.5 주성분분석 해석

summary(fit) 
loadings(fit)


# 5.5.6 적절한 주성분 개수 선택법 

screeplot(fit , type = "lines", main = "scree plot")


# 참고 : 다차원 척도법 

install.packages("HSAUR")
data(watervoles, package = "HSAUR")

head (watervoles) 
loc <- cmdscale(watervoles)
head(loc)

plot(loc, main = "watervoles")  
text(loc, rownames(loc) , col = "blue") 
abline(v = 0, h = 0)
