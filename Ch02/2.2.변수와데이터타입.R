# 2.2   변수와 데이터 타입
# 2.2.1 변수

# 2.2.1.1 변수에 데이터를 저장하고, 불러오기  

age <- 20	   
age        	 

age <- 30 	 
age        	 


# 2.2.2.1 숫자타입 

age <- 20	   
class(age)   
age <- 10L   
class(age) 


# 2.2.2.2 문자타입 

name <- "LJI" 	 
class(name) 		 

no <- "10" 
class(no) 


# 2.2.2.3 논리타입

is_effective <- TRUE   
is_effective

class(is_effective)    
is_effective <- FALSE  


# 2.2.2.4 펙터타입 

sido <- factor("서울", c("서울", "부산", "제주")) 
sido 
 
class(sido) 
levels(sido)  

size <- factor("L", c("XS", "S", "M", "L", "XL"), ordered = TRUE) 
size <- ordered("L", c("XS", "S", "M", "L", "XL")) 
size

a <- 10 
a[2] <- 20  
a


