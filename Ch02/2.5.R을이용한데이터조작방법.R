# 2.5   R을 이용한 데이터 조작 방법 
# 2.5.1 데이터의 대략적인 특징 파악에 유용한 함수 

# 2.5.1.1 head() 함수 

head(Orange)
head(Orange, 3) 


# 2.5.1.2 tail() 함수

tail(Orange)
tail(Orange, 3)


# 2.5.1.3 str() 함수 

str(Orange) 


# 2.5.1.4 summary() 함수

summary(Orange)


# 2.5.1.5 dim() 함수

dim(Orange)


# 2.5.2 외부 파일 읽기

# 2.5.2.1 CSV 파일 불러오기 

nhis <- read.csv("data/NHIS_OPEN_GJ_EUC-KR.csv")
head(nhis)
 
getwd() 

nhis <- read.csv("data/NHIS_OPEN_GJ_EUC-KR.csv", fileEncoding = "EUC-KR")
nhis <- read.csv("data/NHIS_OPEN_GJ_UTF-8.csv", fileEncoding = "UTF-8")
nhis <- read.csv("data/NHIS_OPEN_GJ_UTF-8.csv", fileEncoding = "UTF-8", stringsAsFactor = TRUE)
str(nhis)

nhis <- read.table("data/NHIS_OPEN_GJ_EUC-KR.csv", 
                   header = T, 
                   sep = ",")  

nhis <- read.table("data/NHIS_OPEN_GJ_EUC-KR.txt", 
                   header = T, 
                   sep = ",")  


# 2.5.2.2 엑셀 파일 불러오기

install.packages('openxlsx')  
library(openxlsx) 

nhis_sheet1 <- read.xlsx('data/NHIS_OPEN_GJ_EUC-KR.xlsx') 
head(nhis_sheet1)

nhis_sheet2 <- read.xlsx('data/NHIS_OPEN_GJ_EUC-KR.xlsx', sheet = 2)


# 2.5.2.3 빅데이터 파일 불러오기 

install.packages('data.table') 
library(data.table)

nhis_bigdata = fread("data/NHIS_OPEN_GJ_BIGDATA_UTF-8.csv", encoding = "UTF-8")
str(nhis_bigdata) 


# 2.5.3 데이터 추출

# 2.5.3.1 행 제한 

Orange[1, ]
Orange[1:5, ]
Orange[6:10, ]
Orange[c(1, 5), ]
Orange[-c(1:29), ]

Orange[Orange$age == 118, ] 
Orange[Orange$age %in% c(118, 484), ] 
Orange[Orange$age >= 1372, ] 

subset(Orange, Tree == 1) 
subset(Orange, age >= 1500 | Tree == 1)
subset(Orange, Tree%in%c(3, 2) & age >= 1000)


# 2.5.3.2 열 제한 

Orange[, "circumference"]
Orange[1, c("Tree", "circumference")]

Orange[, 1] 
Orange[, c(1, 3)] 
Orange[, c(1:3)] 
Orange[, -c(1, 3)]  

subset(Orange, , c("age", "Tree"))
subset(Orange, , c(1, 2))


# 2.5.3.3 행과 열 제한

Orange[1:5, "circumference"]
Orange[Orange$Tree %in% c(3, 2), c("Tree", "circumference")]
subset(Orange, Tree == 1, "age") 


# 2.5.3.4 정렬

OrangeT1 <- Orange[Orange$circumference < 50, ] 
OrangeT1
order(OrangeT1$circumference)
OrangeT1[order(OrangeT1$circumference) , ]  
OrangeT1[order(-OrangeT1$circumference), ]  


# 2.5.3.5 그룹별 집계 

aggregate(circumference ~ Tree, Orange, mean)
aggregate(age ~ Tree, Orange, mean)


# 2.5.3.6 plyr 패키지 

install.packages("plyr") 
library(plyr)

ddply(Orange, .(Tree), summarise, m = mean(circumference))
ddply(Orange[Orange$age >1300, ], .(Tree), transform, m = mean(circumference))


# 2.5.3.7 dplyr 패키지

install.packages("dplyr")  
library(dplyr)

Orange %>% filter(age >= 200) 
Orange %>% select(circumference) 
Orange %>% select(Tree, circumference) 
Orange %>% select(-age) 
Orange %>% select(-age) %>% head 
Orange %>% filter(age >= 200) %>% select(age, circumference) %>% head
Orange %>% filter(Tree == 1) %>% select(age, circumference) 
Orange %>% filter(Tree %in% c(1, 2)) %>% select(age, circumference) 
Orange %>% arrange(age) 
Orange %>% arrange(-age) 
Orange %>% arrange(age, circumference) 
Orange %>% filter(age >= 200) %>% arrange(age) %>% select(Tree, age) 
Orange %>% group_by(Tree) %>% summarise(n()) 
Orange %>% group_by(Tree) %>% summarise(n(), mean(circumference))

Orange %>% group_by(Tree) %>% 
  summarise(n(), mean(circumference), sum(age) , mean(age))

Orange %>% group_by(Tree) %>% summarise(n = n()) %>% mutate(tot = sum(n)) 


# 2.5.3.8 sqldf 패키지 

install.packages("sqldf")  
library(sqldf)

sqldf("select * from Orange where age > 1500 order by age, circumference desc") 
sqldf("select Tree, age from Orange where age > 1200 and Tree = 1 order by age desc")
sqldf("select avg(circumference) from Orange group by Tree" )


# 2.5.4 데이터 구조 변경 

# 2.5.4.1 데이터 병합

stu1 <- data.frame(no = c(1, 2, 3), midterm = c(100, 90, 80)) 
stu2 <- data.frame(no = c(1, 2, 3), finalterm = c(100, 90, 80)) 
stu3 <- data.frame(no = c(1, 4, 5), quiz = c(99, 88, 77)) 

stu1
stu2
merge(stu1, stu2) 

stu1
stu3
merge(stu1, stu3) 
merge(stu1, stu3, all = TRUE)
merge(stu1, stu3, all.x = TRUE)
merge(stu1, stu3, all.y = TRUE)

cbind(stu1, stu2)
cbind(stu1, stu3)

stu4 <- data.frame(no = c(4, 5, 6), midterm = c(99, 88, 77)) 
rbind(stu1, stu4)


# 2.5.4.2 데이터 구조 변환 

product_info = data.frame(product_no = c("1", "2", "3"),
                          seoul_qty = c(3, 5, 6),
                          busan_qty = c(10, 20, 30))
product_info

install.packages("reshape2") 
library(reshape2) 

m_prod <- melt(product_info, id.vars = "product_no") 
m_prod 
dcast(m_prod, product_no ~ variable)

