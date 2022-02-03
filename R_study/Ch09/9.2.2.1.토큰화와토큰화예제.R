
# MorphAnalyzer() 함수를 이용해 형태소 분석 수행하기
library(KoNLP)
sentence1 <- "철수는 텍스트 마이닝 공부를 열심히 한다."
MorphAnalyzer(sentence1)
#$철수는
#[1] "철수/ncpa+는/jxc"    "철수/ncpa+는/jcs"    "철수/ncn+는/jxc"     "철수/ncn+는/jcs"    
#[5] "철/xp+수/ncn+는/jxc" "철/xp+수/ncn+는/jcs"
#
#$텍스트
#[1] "텍스트/ncn"
#
#$마이닝
#[1] "마이닝/ncn" "마이닝/nqq"
#
#$공부를
#[1] "공부/ncpa+를/jco"     "공부/ncpa+를/jcs"     "공부/ncn+를/jco"      "공부/ncn+를/jcs"     
#[5] "공/xp+부/ncn+를/jco"  "공/xp+부/ncn+를/jcs"  "공/nnc+부/nbu+를/jco" "공/nnc+부/nbu+를/jcs"
#
#$열심히
#[1] "열심히/mag"       "열심/ncn+히/xsas" "열심/ncn+히/ncn" 
#
#$한다
#[1] "하/pvg+ㄴ다/ef" "하/px+ㄴ다/ef" 
#
#$.
#[1] "./sf" "./sy"


# SimplePos22() 함수(KAIST 품사 태그)를 이용해 품사 태그를 달아보기
SimplePos22(sentence1)
#$철수는
#[1] "철수/NC+는/JX"
#
#$텍스트
#[1] "텍스트/NC"
#
#$마이닝
#[1] "마이닝/NC"
#
#$공부를
#[1] "공부/NC+를/JC"
#
#$열심히
#[1] "열심히/MA"
#
#$한다
#[1] "하/PX+ㄴ다/EF"
#
#$.
#[1] "./SF"


# extractNoun() 함수와 우리말쌈(Woorimalsam) 사전을 이용해 명사 추출하기
library(KoNLP)
useNIADic()
#Backup was just finished!
#983012 words dictionary was built.

extractNoun(sentence1)
#[1] "철수" "텍스트" "마이닝" "공부"


