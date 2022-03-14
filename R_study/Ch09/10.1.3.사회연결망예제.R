
# 환경 설정 
packages <- c("dplyr", "tidytext", "tm", "igraph", "dplyr", "tidytext")
load_pkgs(packages)


# 말뭉치 읽어오기
briefing.text.location <- paste(getwd(), "/tm/briefings/corpus", sep = "")
brf.corpus <- VCorpus(DirSource(briefing.text.location),
                      readerControl = list(language = 'lat'))
summary(brf.corpus)
#        Length Class             Mode
#486.txt 2      PlainTextDocument list
#487.txt 2      PlainTextDocument list
#488.txt 2      PlainTextDocument list


# 말뭉치의 구성 및 내용 확인하기
summary(brf.corpus[[1]]$content)
#Length Class     Mode
#     9 character character
(brf.corpus[[1]]$content)[[1]]
#[1] "president moon jaein premier li keqiang people republic china held meeting attended dinner chengdu china evening local time leaders indepth discussions issues mutual concern including ways promote substantive bilateral cooperation areas economy trade environment culture"

summary(brf.corpus[[2]]$content)
#Length Class     Mode
#     8 character character
(brf.corpus[[2]]$content)[[1]]
#[1] " sidelines korea japan china summit chengdu china president moon jaein japanese prime minister shinzo abe held summit minutes today local time"

summary(brf.corpus[[3]]$content)
#Length Class     Mode
#    14 character character
(brf.corpus[[3]]$content)[[1]]
#[1] "president moon jaein met prime minister hun sen kingdom cambodia cheong wa dae today indepth discussions promote substantive bilateral cooperation "


# 말뭉치의 단어문서행렬(TDM) 구축하기
mtx.ctrl <- list(language = "english",
                 removeNumbers = FALSE,
                 removePunctuation = FALSE,
                 stopwords = FALSE,
                 stemming = FALSE,
                 wordLengths = c(2, Inf))
tdm <- TermDocumentMatrix(brf.corpus, control = mtx.ctrl)
tdm
#<<TermDocumentMatrix (terms: 443, documents: 3)>>
#Non-/sparse entries: 545/784
#Sparsity           : 59%
#Maximal term length: 16
#Weighting          : term frequency (tf)


# 생성된 TDM을 행렬 형식으로 변환하기
tdm.mtx <- as.matrix(tdm)
colnames(tdm.mtx) <- c("doc486", "doc487", "doc488")
tdm.mtx[1:6,]
#          Docs
#Terms      doc486 doc487 doc488
#  abducted      0      1      0
#  abe           0      6      0
#  abundant      0      0      1
#  achieved      1      0      0
#  active        0      0      3
#  actively      2      0      0


# 각 단어 행의 빈도수를 합산하고, 단어 빈도가 1보다 큰 단어들만 추출하기
term_freq <- sort(rowSums(tdm.mtx), decreasing = TRUE)
head(term_freq)
#president        moon       korea       china cooperation   countries 
#       23          21          19          14          14          14 


brf_tdm1 <- tdm.mtx[rownames(tdm.mtx) %in% names(term_freq[term_freq > 1]), ]
nrow(brf_tdm1)
#[1] 144

head(brf_tdm1)
#           Docs
#Terms       doc486 doc487 doc488
#  abe            0      6      0
#  active         0      0      3
#  actively       2      0      0
#  added          1      1      2
#  advance        2      0      0
#  agreement      4      0      2


# 각 단어들을 행과 열의 대칭 행렬로 생성하고, 인접행렬(Adjacency matrix)로 변환하기
brf_term_adj.mtx <- brf_tdm1 %*% t(brf_tdm1)
brf_term_adj.mtx[brf_term_adj.mtx >1] <- 1
brf_term_adj.mtx[1:5, 1:5]
#          Terms
#Terms      abe active actively added advance
#  abe        1      0        0     1       0
#  active     0      1        0     1       0
#  actively   0      0        1     1       1
#  added      1      1        1     1       1
#  advance    0      0        1     1       1


# 인접행렬을 이용해 그래프 객체 생성하기
brf.g <- graph.adjacency(brf_term_adj.mtx, weight = T, mode = 'undirected')


# 방향 연결망의 출선 수(Outdegree)와 입선 수(Indegree) 확인하기
brf.g.out <- degree(brf.g, mode = "out")
head(brf.g.out)
#abe active actively added advance agreement
# 61     92       96   145      96       136

head(degree(brf.g, mode = "in"))
#abe    active  actively     added   advance agreement 
# 61        92        96       145        96       136


# 사회연결망의 밀도(Density) 확인하기
graph.density(brf.g)
#[1] 0.7910839

sum(degree(brf.g, mode = "out"))/(length(brf.g.out)*(length(brf.g.out)-1))
#[1] 0.7910839


# 사회연결망의 최단거리(최단경로) 확인하기
shortest.paths(brf.g, mode = "out")[1:5, 1:5]
#         abe active actively added advance
#abe        0      2        2     1       2
#active     2      0        2     1       2
#actively   2      2        0     1       1
#added      1      1        1     0       1
#advance    2      2        1     1       0


# 그래프 객체에서 도달가능도(reachability) 확인하기
D <- shortest.paths(brf.g, mode = "out")
reachability <- (D <= 3)
diag(reachability) <- NA
reachability[1:5, 1:5]
#          abe active actively added advance
#abe        NA   TRUE     TRUE  TRUE    TRUE
#active   TRUE     NA     TRUE  TRUE    TRUE
#actively TRUE   TRUE       NA  TRUE    TRUE
#added    TRUE   TRUE     TRUE    NA    TRUE
#advance  TRUE   TRUE     TRUE  TRUE      NA


# 그래프 객체를 단수화하여 사회연결망 그래프 그리기
brf.g <- simplify(brf.g)
plot(brf.g)


# 그래프 객체의 새로운 레이아웃 생성하기
brf.layout <- layout.fruchterman.reingold(brf.g)


# 그래프 객체에 점과 선을 차별화 후 사회연결망 그래프 그리기
V(brf.g)$label.cex <- 2.2 * V(brf.g)$degree / max(V(brf.g)$degree) + 0.2
V(brf.g)$label.color <- rgb(0, 0, 0.2, 0.8)
V(brf.g)$frame.color <- NA
egam <- (log(E(brf.g)$weight) + 0.4) / max(log(E(brf.g)$weight) + 0.4)
E(brf.g)$width <- egam
E(brf.g)$color <- rgb(0.5, 0.5, 0, egam)
plot(brf.g, brf.layout)


# 그래프 객체에서 점의 레이블과 연결된 노드 수 확인하기
V(brf.g)$label <- V(brf.g)$name
head(V(brf.g)$label, 5)
#[1] "abe" "active" "actively" "added" "advance"

V(brf.g)$degree <- degree(brf.g)
head(V(brf.g)$degree, 5)
#[1]  59  90  94 143  94


# 그래프 객체에서 근접 중심성(Closeness centrality) 계산하기
closeness.df <- round(closeness(brf.g, mode = "out"), 5) %>%
  as.data.frame() %>%
  data.frame(word = rownames(.))
colnames(closeness.df) <- c("value", "word")
closeness.df <- closeness.df %>% arrange(desc(value)) %>%
  dplyr::mutate(rank = row_number())
head(closeness.df)
#    value      word rank
#1 0.00699     added    1
#2 0.00699 countries    2
#3 0.00699 exchanges    3
#4 0.00699 expressed    4
#5 0.00699      held    5
#6 0.00699      hope    6


# 그래프 객체에서 근접 중심성 값을 계산하고 선 그래프 그리기
closeness.df %>%
  ggplot(aes(rank, value)) +
  geom_line(size = 1.1, alpha = 0.8, show.legend = FALSE) +
  scale_x_log10() +
  scale_y_log10()


# 그래프 객체에서 중개 중심성(Betweenness centrality) 계산하기
betweenness.df <- round(betweenness(brf.g), 5) %>%
  as.data.frame() %>%
  data.frame(word = rownames(.))
colnames(betweenness.df) <- c("value", "word")
betweenness.df <- betweenness.df %>% arrange(desc(value)) %>%
  dplyr::mutate(rank = row_number())
head(betweenness.df)
#     value      word rank
#1 45.46367     added    1
#2 45.46367 countries    2
#3 45.46367 exchanges    3
#4 45.46367 expressed    4
#5 45.46367      held    5
#6 45.46367      hope    6


# 그래프 객체에서 중개 중심성 값을 계산하고 선 그래프 그리기
betweenness.df %>%
  ggplot(aes(rank, value)) +
  geom_line(size = 1.1, alpha = 0.8, show.legend = FALSE) +
  scale_x_log10() +
  scale_y_log10()


# 그래프 객체에서 고유 벡터 중심성(Eigenvector centrality) 계산하기
eigen.df <- round(eigen_centrality(brf.g, scale = F)$vector, 5) %>%
  as.data.frame() %>%
  data.frame(word = rownames(.))
colnames(eigen.df) <- c("value", "word")
eigen.df <- eigen.df %>% arrange(desc(value)) %>%
  dplyr::mutate(rank = row_number())
head(eigen.df)
#    value      word rank
#1 0.10094     added    1
#2 0.10094 countries    2
#3 0.10094 exchanges    3
#4 0.10094 expressed    4
#5 0.10094      held    5
#6 0.10094      hope    6


# 그래프 객체에서 고유 벡터 중심성 값을 계산하고 선 그래프 그리기
eigen.df %>%
  ggplot(aes(rank, value)) +
  geom_line(size = 1.1, alpha = 0.8, show.legend = FALSE) +
  scale_x_log10() +
  scale_y_log10()


# 그래프 객체에서 구글의 Page 순위 계산하기
page.df <- round(page.rank(brf.g)$vector, 5) %>%
  as.data.frame() %>%
  data.frame(word = rownames(.))
colnames(page.df) <- c("value", "word")
page.df <- page.df %>% arrange(desc(value)) %>%
  dplyr::mutate(rank = row_number())
head(page.df)
#   value      word rank
#1 0.0087     added    1
#2 0.0087 countries    2
#3 0.0087 exchanges    3
#4 0.0087 expressed    4
#5 0.0087      held    5
#6 0.0087      hope    6


# 그래프 객체에서 구글 Page 순위 값을 계산하고 선 그래프 그리기
page.df %>%
  ggplot(aes(rank, value)) +
  geom_line(size = 1.1, alpha = 0.8, show.legend = FALSE) +
  scale_x_log10() +
  scale_y_log10()


