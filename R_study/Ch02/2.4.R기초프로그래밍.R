# 2.4   R 기초 프로그래밍
# 2.4.1 연산 

# 2.4.1.1 벡터 연산 
   
score <- c(10, 20) 
score + 2  
score 
score <- score + 2 
score

first_score <- c(100, 200) 
second_score <- c(90, 91) 
sum_score <- first_score + second_score # 벡터와 벡터의 더하기 연산
sum_score
diff <- first_score - second_score 
diff

first_score <- c(100, 200, 300) 
second_score <- c(100, 91) 
sum <- first_score + second_score
sum

first_score <- c(100, 200, 300) 
second_score <- c(100, 91, 300) 
first_score == second_score 
first_score >= 0 & first_score <= 100
first_score %in% c(1, 2, 100)  


# 2.4.1.2 행렬 연산 

m1 <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 2) 
m1 <- m1 * 10  
m1

m1 <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 2) 
m1 <- m1 * 10  
m1
m2
m1 + m2 
m1 * m2 

jumsu <- matrix(c(1, 2, 3, 4), ncol = 2, byrow = T) 
jumsu
 
weight <- matrix(c(5, 6, 7, 8, 9, 10), ncol = 3, byrow = T)
weight 
jumsu %*% weight 

jumsu
t(jumsu) 
solve(jumsu) 


# 2.4.2 흐름 제어

# 2.4.2.1 if ~ else 문 

score <- 95
if(score <= 100 & score >= 80) { # 조건이 TRUE이므로 아래 문장이 실행 
  print("조건이 TRUE인 경우만 수행할 문장") 
  }

score <- 86
if(score >= 91) { # 이 조건의 결과는 FALSE 
    print("A") # 조건이 TRUE일 때 수행할 문장 
} else {
      print("B or C or D") # 조건이 FALSE일 때 수행할 문장 
}

score <- 86
if(score >= 91) {print("A") 
} else if(score >= 81) {print(" B ") # score는86이므로 이 조건이 TRUE 
} else if(score >= 71) {print(" C ") 
} else if(score >= 61) {print(" D ") 
} else {print (" F ")}


# 2.4.2.2 ifelse() 함수  

score <- 85 
ifelse(score>= 91, "A", "FALSE일 때 수행")  

score <- 85 
ifelse(score>= 91, "A", ifelse(score >= 81, "B", "C or D "))

score <- 95 
ifelse(score >= 91, "A", ifelse(score >= 81, "B","C or D ")) 

score <- 65 
ifelse(score >= 91, "A", ifelse(score >= 81, "B", ifelse(score >= 71, "C", "D ")))


# 2.4.2.3 for 문 

for(num in(1:3)) { 
    print(num)
}

for(num in(1:3)) 
    print(num)

for(num in (1:5)) {
    if(num %% 2 == 0)
      print(paste(num, "짝수"))
    else 
      print(paste(num, "홀수"))
} 

num <- c(1:5)
ifelse(num %% 2 == 0, paste(num, "짝수"), paste(num, "홀수"))


# 2.4.2.4 while 문 

num <- 1
while(num <= 5) {  
   print(num)
   num <- num + 1
}


# 2.4.2.5 break 문

s <- 0 
for(x in(1:1000)) { 
    s <- s + x 
    if(s >= 100) 
      break  
    }
print(s)


# 2.4.2.6 next 문 

cnt = 0 
for(x in c(1, 2, NA, 3, NA, 4, 5)) {
  if(is.na(x))  
    next  
    print(x)
} 


# 2.4.2.7 repeat 문 

num <- 1 
repeat {
  print(num)
  num <- num + 2 
  if(num > 10) 
    break;
}


# 2.4.3 함수 

# 2.4.3.1 함수 생성과 호출  

a <- function() {  
  print("testa") 
  print("testa")
}

a()


# 2.4.3.2 매개변수가 있는 함수

a <- function(num) {  
      print(num)   
}

a(20)
a(10)


# 2.4.3.3 두 개 이상의 매개변수가 있는 함수

a <- function(num1, num2) {  
       print(paste(num1, ' ', num2)) 
    }
a(10, 20)
a(num1 = 10, num2 = 20)
a(num2 = 20, num1 = 10)

a(num1 <- 10, num2 = 20)
print(num1) 


# 2.4.3.4 디폴트값이 있는 매개변수

a <- function(num1, num2 = 10) {  
       print(paste(num1,' ',num2))
   }
a(num1 = 10) 
a(10)
a(10, 30)  

calculator <- function(num1, num2, op = "+") { 
  result <- 0
  if(op == "+") {
    result <- num1 + num2 
  }else if(op == "-") {
    result <- num1 - num2 
  }else if(op == "*") {
    result <- num1 * num2 
  }else if(op == "/") {
    result <- num1 / num2
  } 
  print(result)
}
calculator(10, 20, "-")
calculator(10, 20) 


# 2.4.3.5 가변길이 매개변수

a <- function(...) { 
       for(n in c(...)) {
        print(n)
       }
    }
a(1, 2) 
a(1, 2, 3, 4) 
a(10) 


# 2.4.3.6 리턴 데이터가 있는 함수 

calculator <- function(num1, op = "+", num2) {
                result <- 0
                if(op == "+") {
                    result <- num1 + num2 
                }else if(op == "-") {
                    result <- num1 - num2 
                }else if(op == "*") {
                    result <- num1 * num2 
                }else if(op == "/") {
                    result <- num1 / num2
                } 
                return(result)
              }

n <- calculator(1, "+", 2)
print(n) 
n <- calculator(1, "+", 2)
print(n)
n <- calculator(n, "*", 2) 
print(n)
n <- calculator(n, "-", 2) 
print(n)
print(calculator(calculator(calculator(1, "+", 2), "*", 2), "-", 2)) 


# 2.4.4 유용한 함수와 상수

# 2.4.4.1 NULL과 NA 

a <- NULL
is.null(a)  
b <- NA 
jumsu <- c(NA, 90, 100)  
is.na(b)  
is.na(jumsu)


# 2.4.4.2 Inf 와 NaN 

num <- 10 / 0   ; num 
num <- -10 / 0  ; num
num <- 0 / 0    ; num


# 2.4.4.3 데이터 타입 변환과 타입 확인

data <- c(1, 2, 3)
d1 <- as.character(data)
d2 <- as.numeric(data)
d3 <- as.factor(data) 
d4 <- as.matrix(data) 
d5 <- as.array(data) 
d6 <- as.data.frame(data)

data <- c(1, 2, 3) 
is.character(data) 
is.numeric(data) 
is.factor(data) 
is.matrix(data) 
is.array(data)
is.data.frame(data) 
class(data)
str(data)


# 2.4.4.4 변수 삭제

score <- 100 
remove(score)  

 








