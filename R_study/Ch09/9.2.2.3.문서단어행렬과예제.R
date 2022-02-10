
# 말뭉치에서 문서단어행렬(DTM)로 구축하기
dtm <- DocumentTermMatrix(corpus)
dtm
#<<DocumentTermMatrix (documents: 3, terms: 437)>>
#Non-/sparse entries : 539/772
#Sparsity : 59%
#Maximal term length : 16
#Weighting : term frequency (tf)


# 생성된 DTM에서 각 문서의 첫 번째에서 여섯 번째 단어의 분포 확인하기
inspect(dtm[, 1:6])
#<<DocumentTermMatrix (documents: 3, terms: 6)>>
#Non-/sparse entries: 6/12
#Sparsity           : 67%
#Maximal term length: 8
#Weighting          : term frequency (tf)
#Sample             :
#         Terms
#Docs      abducted abe abundant achieved active actively
#  486.txt        0   0        0        1      0        2
#  487.txt        1   6        0        0      0        0
#  488.txt        0   0        1        0      3        0


# 생성된 DTM에서 5에서 10회 사이로 사용된 단어를 확인하기
findFreqTerms(dtm, 5, 10)
# [1] "abe"       "agreement" "bilateral" "dialogue"  "expressed" "forward"   "hope"      "issues"   
# [9] "japan"     "leaders"   "mou"       "peace"     "peninsula" "premier"   "project"   "support"  
#[17] "time"


# 생성된 DTM에서 “president” 단어와 연관성(0.0~1.0범위)이 0.9 이상인 단어 확인하기
findAssocs(dtm, c('president'), c(0.9))
#$president
#        peace   discussions          hope          moon       promote         trade   cooperation 
#         1.00          0.99          0.99          0.99          0.99          0.99          0.97 
#         year     bilateral collaboration   development           end        future        global 
#         0.95          0.92          0.92          0.92          0.92          0.92          0.92 
#      indepth    initiative         korea     mentioned           met     necessity       network 
#         0.92          0.92          0.92          0.92          0.92          0.92          0.92 
#participation     peninsula        people          plan     promoting        signed 
#         0.92          0.92          0.92          0.92          0.92          0.92


# 생성된 DTM에서 희소성(Sparsity) 값을 0.2까지 허용하고, 넘는 경우는 제외하기
inspect(removeSparseTerms(dtm, 0.2))
#<<DocumentTermMatrix (documents: 3, terms: 21)>>
#Non-/sparse entries: 63/0
#Sparsity           : 0%
#Maximal term length: 14
#Weighting          : term frequency (tf)
#Sample             :
#         Terms
#Docs      added countries expressed hope issues korea korean moon peninsula president
#  486.txt     1         2         2    3      3     7      2    7         2         8
#  487.txt     1         4         2    1      2     5      2    5         1         5
#  488.txt     2         8         4    5      1     7      7    9         2        10


# 말뭉치에서 분석에 사용하고자 하는 단어와 새로운 단어 “jang”를 추가하여 DTM 구축하기
dic <- c("japan", "korea", "president", "export", "moon", "jang")
inspect(DocumentTermMatrix(corpus, control = list(dictionary = dic)))
#<<DocumentTermMatrix (documents: 3, terms: 6)>>
#Non-/sparse entries: 11/7
#Sparsity           : 39%
#Maximal term length: 9
#Weighting          : term frequency (tf)
#Sample             :
#         Terms
#Docs      export jang japan korea moon president
#  486.txt      0    0     0     7    7         8
#  487.txt      3    0     6     5    5         5
#  488.txt      0    0     0     7    9        10



