
# proxy 패키지를 설치하고 불러오기
install.packages("proxy")
library(proxy)


# DTM(Document-Term Matrix, 가로줄에 문서가 세로줄에 단어가 배치된 행렬) 만들기
doc1 <- c(1, 1, 5)
doc2 <- c(4, 6, 3)
doc3 <- c(40, 60, 30)
doc_corpus <- rbind(doc1, doc2, doc3)
colnames(doc_corpus) <- c("Life", "Performance", "Learn")
doc_corpus
#     Life Performance Learn
#doc1    1           1     5
#doc2    4           6     3
#doc3   40          60    30


# proxy 패키지의 dist() 함수로 코사인 거리를 계산하고, 행렬로 표현하기
cosine_dist <- as.matrix(round(dist(doc_corpus, method = "cosine"), 8))
cosine_dist
#          doc1      doc2      doc3
#doc1 0.0000000 0.3839823 0.3839823
#doc2 0.3839823 0.0000000 0.0000000
#doc3 0.3839823 0.0000000 0.0000000


# proxy 패키지의 dist() 함수로 자카드 거리를 계산하고, 행렬로 표현하기
jaccard_dist <- as.matrix(round(dist(doc_corpus, method = "Jaccard"), 8))
jaccard_dist
#     doc1 doc2 doc3
#doc1    0    0    0
#doc2    0    0    0
#doc3    0    0    0

doc4 <- c(1, 0, 5)
doc5 <- c(4, 6, 0)
doc6 <- c(40, 60, 30)
doc_corpus2 <- rbind(doc4, doc5, doc6)
colnames(doc_corpus2) <- c("Life", "Performance", "Learn")
jaccard_dist <- as.matrix(round(dist(doc_corpus2, method = "Jaccard"), 8))
jaccard_dist
#          doc4      doc5      doc6
#doc4 0.0000000 0.6666667 0.3333333
#doc5 0.6666667 0.0000000 0.3333333
#doc6 0.3333333 0.3333333 0.0000000


# proxy 패키지의 dist() 함수로 유클리드 거리를 계산하고, 행렬로 표현하기
euclidean_dist <- as.matrix(round(dist(doc_corpus, method = "euclidean"), 8))
euclidean_dist
#          doc1      doc2     doc3
#doc1  0.000000  6.164414 75.01333
#doc2  6.164414  0.000000 70.29225
#doc3 75.013332 70.292247  0.00000


# proxy 패키지의 dist() 함수로 맨하튼 거리를 계산하고, 행렬로 표현하기
manhattan_dist <- as.matrix(round(dist(doc_corpus, method = "manhattan"), 8))
manhattan_dist
#     doc1 doc2 doc3
#doc1    0   10  123
#doc2   10    0  117
#doc3  123  117    0


# proxy 패키지의 dist() 함수로 민코우스키 거리(m = 1인 경우)를 계산하고, 행렬로 표현하기
minkowski_dist <- as.matrix(round(dist(doc_corpus, method = "minkowski", p = 1), 8))
minkowski_dist
#     doc1 doc2 doc3
#doc1    0   10  123
#doc2   10    0  117
#doc3  123  117    0


# proxy 패키지의 dist() 함수로 민코우스키 거리(m = 2인 경우)를 계산하고, 행렬로 표현하기
minkowski_dist <- as.matrix(round(dist(doc_corpus, method = "minkowski", p = 2), 8))
minkowski_dist
#          doc1      doc2     doc3
#doc1  0.000000  6.164414 75.01333
#doc2  6.164414  0.000000 70.29225
#doc3 75.013332 70.292247  0.00000


