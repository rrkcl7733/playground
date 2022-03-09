
# 환경 설정
packages <- c("dplyr", "tidytext", "janeaustenr", "quanteda", "ggplot2",
              "tm", " text2vec", "MASS")
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


# corpus_text() 함수를 이용해 말뭉치의 문서 내용을 하나의 텍스트로 병합하기
corpus.text <- corpus_text(brf.corpus)
str(corpus.text)
#chr "  president moon jaein premier li keqiang people republic china held meeting attended dinner chengdu china even"| __truncated__


# 텍스트를 단어 토큰화하기
brf_words_toks <- tokens(corpus.text)
str(brf_words_toks)
#List of 1
# $ text1: chr [1:856] "president" "moon" "jaein" "premier" ...
# - attr(*, "types")= chr [1:443] "president" "moon" "jaein" "premier" ...
# - attr(*, "padding")= logi FALSE
# - attr(*, "class")= chr "tokens"
# - attr(*, "what")= chr "word"
# - attr(*, "ngrams")= int 1
# - attr(*, "skip")= int 0
# - attr(*, "concatenator")= chr "_"
# - attr(*, "docvars")='data.frame':	1 obs. of  0 variables


# 단어 토큰화를 이용해 피처 동시 등장 행렬(Feature co-occurrence matrix) 생성하기
brf_words_toks_fcm <- fcm(brf_words_toks,
                          context = "window",
                          count = "weighted",
                          weights = 1/(1:5), tri = TRUE)
brf_words_toks_fcm[1:5, 1:5]
#Feature co-occurrence matrix of: 5 by 5 features.
#5 x 5 sparse Matrix of class "fcm"
#           features
#features    president moon jaein   premier        li
#  president         0   21   1.5 0.3333333 0.2500000
#  moon              0    0   3.0 0.5000000 0.3333333
#  jaein             0    0   0   1.0000000 0.5000000
#  premier           0    0   0   0.4000000 5.2500000
#  li                0    0   0   0         0        


# 글로벌 벡터 워드-임베딩 모델(Global Vectors word-embeddings model)을 생성하기
m.glove <- GlobalVectors$new(word_vectors_size = 100,
                             vocabulary = featnames(brf_words_toks_fcm),
                             x_max = 10)


# 모델을 데이터에 적합하고 데이터 변환하기
fit.vectors <- fit_transform(brf_words_toks_fcm, m.glove, n_iter = 1000)
str(fit.vectors)
#num [1:443, 1:100] 0.0269 -0.1661 -0.2536 -0.1769 -0.2584 ...
#- attr(*, "dimnames") = List of 2
# ..$ : chr [1:443] "president" "moon" "jaein" "premier" ...
# ..$ : NULL
fit.vectors[1:5, 1:5]
#                 [,1]       [,2]         [,3]        [,4]        [,5]
#president  0.37855962  0.3881144 -0.190702066  0.38752228 -0.08131041
#moon       0.28615597  0.3333575  0.087041289  0.52351379 -0.05732320
#jaein     -0.09673693 -0.1571644  0.296279252  0.45935997  0.17713954
#premier    0.06443618 -0.6476011 -0.250394374 -0.19664562 -0.27364770
#li         0.07888400 -0.2579880 -0.008760163  0.06070848 -0.45491359


# 학습된 모델을 문서 피처 행렬(Document-feature matrix)로 변환하기
fit_vectors_dfm <- as.dfm(fit.vectors)
fit_vectors_dfm
#Document-feature matrix of: 443 documents, 100 features (0.0% sparse).


# 학습된 모델에서 “korea” 단어와 코사인 유사도가 높은 20개 단어 막대 그래프 그리기
korea_similarity <- textstat_simil(fit_vectors_dfm, selection = c("korea"),
                                   margin = "documents", method = "cosine")
korea_similarity <- as.data.frame(korea_similarity)
colnames(korea_similarity) <- c("word", "documents", "similarity")
korea_similarity <- korea_similarity %>%
  arrange(desc(similarity)) %>%
  dplyr::mutate(rank = row_number())
korea_similarity <- korea_similarity[rank(-korea_similarity[, 3]) < 20, ]
korea_similarity %>% arrange(desc(similarity)) %>%
  mutate(word = factor(word, levels = rev(unique(word)))) %>%
  top_n(20) %>%
  ggplot(aes(word, similarity)) +
  geom_col(show.legend = FALSE) +
  labs(x = NULL, y = "similarity") +
  coord_flip()


# 학습된 모델에서 “korea”, “china” 두 단어의 코사인 유사도 계산 결과를 산점도 그리기
korea_china_similarity <- textstat_simil(fit_vectors_dfm,
                                         selection = c("korea", "china"),
                                         margin = "documents",
                                         method = "cosine")
korea_china_similarity_df <- as.data.frame(as.matrix(korea_china_similarity[1:443, 1:2]))
plot(korea_china_similarity_df, type = "n", xlab = "korea", ylab = "china")
text(korea_china_similarity_df, labels = rownames(korea_china_similarity_df))


# 학습된 모델에서 “korea”-“china”+”japan” 단어의 벡터 연산 수행하기
new_word <- fit.vectors["korea", ] - fit.vectors["china", ] + fit.vectors["japan", ]
brf_vectors_new_word_dfm <- as.dfm(rbind(fit.vectors, new_word))
new_word_similarity <- textstat_simil(brf_vectors_new_word_dfm,
                                      selection = c("new_word"),
                                      margin = "documents",
                                      method = "cosine")
new_word_similarity <- as.data.frame(new_word_similarity)
colnames(new_word_similarity) <- c("word","documents", "similarity")
new_word_similarity %>% arrange(desc(similarity)) %>%
  mutate(word = factor(word, levels = rev(unique(word)))) %>%
  top_n(20) %>%
ggplot(aes(word, similarity)) +
  geom_col(show.legend = FALSE) +
  labs(x = NULL, y = "similarity") +
  coord_flip()


# 학습된 모델을 2차원으로 축소하여 산점도 그리기
fit_vectors_mtx <- as.matrix(fit.vectors[1:443, 1:100])
fit_vectors_dist <- dist(fit_vectors_mtx)
fit_vectors_2dim <- isoMDS(fit_vectors_dist)
plot(fit_vectors_2dim$points, type = "n",
     xlab = "First Dimension", ylab = "Second Dimension")
text(fit_vectors_2dim$points,
     labels = as.character(rownames(as.data.frame(fit_vectors_2dim[[1]]))))


