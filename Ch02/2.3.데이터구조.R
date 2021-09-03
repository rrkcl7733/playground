# 2.3   데이터 구조
# 2.3.1 벡터 

students_age <- c(11, 12, 13, 20, 15, 21) 
students_age 
length(students_age) 


# 2.3.1.1 일부 데이터만 접근 

students_age[1]
students_age[3]
students_age[-1] 
students_age[1:3]
students_age[4:6]


# 2.3.1.2 백터의 구조 

students_age <- c(11, 12, 13, 20, 15, 21) 
class(students_age) 
length(students_age)
str(students_age)


# 2.3.1.3 벡터 데이터 추가, 갱신, 삭제 
score <- c(1, 2, 3)
score[1] <- 10  
score[4] <- 4  
score


# 2.3.1.4 벡터의 데이터 타입 

code <- c(1, 12, "30")  
class(code)  
str(code)
code <- c(1, 12, TRUE, FALSE)  
class(code)  
str(code) 


# 2.3.1.5 벡터 데이터 생성

data <- c(1:10)  
data 
data1 <- seq(1, 10)  
data1 
data2 <- seq(1, 10, by = 2)  
data2
data3 <- rep(1, times = 5)  
data3 
data4 <- rep(1:3, times = 3 )  
data4 
data5 <- rep(1:3, each = 3)  
data5 
data6 <- rep(1:3, each = 2, times = 3) 
data6 


# 2.3.2 매트릭스(행렬)

var1 <- c(1, 2, 3, 4, 5, 6) 
x1 <- matrix(var1, nrow = 2, ncol = 3) 
x1
x2 <- matrix(var1, ncol = 2)
x2 


# 2.3.2.1 일부 데이터만 접근  
x1[1, ]  
x1[, 1]  
x1[2, 2]

dimnames(x2) <- list(c("r1", "r2", "r3"), c("c1", "c2"))  
x2
x2[, "c1"]
x2["r1", ] 
x2["r1", "c1"]


# 2.3.2.2 행렬에 데이터 추가 

x1
x1 <- rbind(x1, c(10, 10, 10))
x1
x1 <- cbind(x1, c(20, 20, 20))
x1


# 2.3.3 데이터프레임

no <- c(10, 20, 30, 40, 50, 60, 70)
age <- c(18, 15, 13, 12, 10, 9, 7)
gender <- c("M", "M", "M", "M", "M" ,"F", "M") 
students <- data.frame(no, age, gender) 
students
 
colnames(students)
rownames(students)

colnames(students) <- c("no", "나이", "성별")
rownames(students) <- c('A', 'B', 'C', 'D', 'E', 'F', 'G')
students

colnames(students) <- c("no", "age", "gender") 


# 2.3.3.1 일부 데이터만 접근 

students$no  
students$age  
students[, "no"]  
students[, "age"] 

students[, 1]  
students[, 2]   

students["A", ] 

students[1, ]  
students[2, ] 
students[3, 1] 
students["A", "no"]


# 2.3.3.2 데이터프레임의 데이터 타입 

class(students)

class(students$no)  
class(students$gender)

no <- c(10, 20, 30, 40, 50, 60, 70)
age <- c(18 , 15, 13, 12, 10, 9, 7)
gender <- c("M", "M", "M", "M", "M" ,"F", "M") 
new_students <- data.frame(no, age, gender, stringsAsFactors = TRUE) 
class(new_students$gender) 


# 2.3.3.3 데이터프레임의 구조 

str(students)
dim(students)
head(students)
tail(students)


# 2.3.3.4 데이터프레임 데이터 추가 

students$name <- c("이용", "준희", "이훈", "서희", "승희", "하정", "하준") 
students

students["H",] <- c(80, 10, 'M', '홍길동')  
tail(students)


# 2.3.4 배열 

var1 <- c(1:12) 
var1 
arr1 <- array(var1, dim = c(2, 2, 3))  
arr1
arr2 <- array(var1, dim = c(6, 2))  
arr3 <- array(var1, dim = c(2, 2, 2, 2)) 


# 2.3.5 리스트

v_data <- c("02-111-2222", "01022223333")  
m_data <- matrix(c(21:26), nrow = 2)  
a_data <- array(c(31:36), dim = c(2, 2, 2))  
d_data <- data.frame(address = c("seoul", "busan"),  
                     name = c("Lee", "Kim"), stringsAsFactors = F)

list_data <- list(name = "홍길동",  
                  tel = v_data,  
                  score1 = m_data,  
                  score2 = a_data,  
                  friends = d_data)  
list_data$name   
list_data$tel  
list_data[1] 
