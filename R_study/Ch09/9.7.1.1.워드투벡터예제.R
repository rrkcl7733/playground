
# 환경 설정
packages <- c("dplyr", "tidytext", "janeaustenr", "quanteda", "ggplot2",
              "tm", "wordVectors", "MASS")
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


# 말뭉치의 문서 내용을 하나의 텍스트로 병합하는 corpus_text() 함수 만들기
corpus_text <- function(corpus) {
  corpus.text <- NULL
  for (i in 1:length(corpus)) {
    doc.text <- NULL
    for (j in 1:length(corpus[[i]]$content)) {
      doc.text <- paste(doc.text, corpus[[i]]$content[[j]], sep = " ")
    }
    corpus.text <- paste(corpus.text, doc.text, sep = " ")
  }
  return(corpus.text)
}


# corpus_text() 함수를 이용해 말뭉치의 문서 내용을 하나의 텍스트로 병합하여 저장하기
corpus.text <- corpus_text(brf.corpus)
str(corpus.text)
#chr " president moon jaein premier li keqiang … 이하 생략

write.table(corpus.text,
  file.path("data/word2vec/txt", "brf_486_487_488.txt"))


# Word2Vec 인공신경망 알고리즘의 Skip-Gram 방법을 이용해 학습하기
model = train_word2vec(file.path("data/word2vec/txt", "brf_486_487_488.txt"),
                       output_file = file.path("data/word2vec/bin", "brf_486_487_488.bin"),
                       threads = 4,
                       cbow = 0,
                       vectors = 100,
                       iter = 100,
                       min_count = 1,
                       window = 4)


# 학습된 모델 읽어오기
file.name <- paste(getwd(), "/data/word2vec/bin/brf_486_487_488.bin", sep = "")
model00 <- read.vectors(file.name)
str(model00)
#Formal class 'VectorSpaceModel' [package "wordVectors"] with 2 slots
#..@ .Data : num [1:445, 1:100] 0.004 0.0893 -0.1681 -0.6086 0.06 ...
#.. ..- attr(*, "dimnames")=List of 2
#.. .. ..$ : chr [1:445] "</s>" "president" "moon" "korea" ...
#.. .. ..$ : NULL
#..@ .cache:<environment: 0x000000005efa45a8> 
  
model00[, 1:5] 
#A VectorSpaceModel object of  445  words and  5  vectors
#                    [,1]         [,2]         [,3]          [,4]         [,5]
#</s>         0.004002686  0.004419403 -0.003830261 -0.0032780457  0.001366577
#president    0.089341030 -0.660583019  0.297424942  0.2428652346 -0.050140914
#moon        -0.168100208 -0.973614335 -0.090108894  0.3102994859  0.018542485
#korea       -0.608582258  0.148161128  0.527049243 -0.0782054588  0.432240427
#cooperation  0.060005467 -0.393559426 -0.396817803  0.2806343734  0.531147540
#china        0.002047729  0.003516693 -0.003788147  0.0009999084  0.003601074
#countries    0.026451442 -0.641435385 -0.037961349  0.2341964990 -0.150087476
#minister     0.435342461  0.107976966  0.489935130 -0.5159037709  0.837238550
#prime        0.037685350 -0.419854462  0.389808148 -0.7666120529  0.878820837
#korean       0.286976427 -1.246194005  0.015507024 -0.0421076752 -0.030628687
#attr(,".cache")
#<environment: 0x000000005eba0498>  


# 학습된 모델에서 “korea” 단어와 가장 가까운 20개 단어 막대 그래프 그리기
korea_word_sim <- model00 %>% closest_to("korea", n = 20)
colnames(korea_word_sim) <- c("word", "similarity")
korea_word_sim
#            word similarity
#1          korea  1.0000000
#2         future  0.7184074
#3   technologies  0.6818577
#4          build  0.6789725
#5       combined  0.6334249
#6        largest  0.6284981
#7      potential  0.6277829
#8   construction  0.6089014
#9     employment  0.5876938
#10        number  0.5848766
#11         asean  0.5672044
#12             "  0.5651610
#13          held  0.5567085
#14     completed  0.5514099
#15        builds  0.5487954
#16        active  0.5470718
#17     proposing  0.5424374
#18 strengthening  0.5388235
#19        looked  0.5377508
#20       support  0.5259151

korea_word_sim %>%
  mutate(word = factor(word, levels = rev(unique(word)))) %>%
  ggplot(aes(word, similarity)) +
  geom_col(show.legend = FALSE) +
  labs(x = NULL, y = "similarity") +
  coord_flip()


# 학습된 모델에서 “korea”, “china” 두 단어의 코사인 유사도 계산 결과를 산점도 그리기
word_vec <- c("korea", "china")
word_word_sim <- model00[[word_vec, average = F]]
word_word_sim <- model00 %>% cosineSimilarity(word_word_sim)
word_word_sim <- word_word_sim[-1, ]
head(word_word_sim)
#                 korea       china
#president   0.29171573 -0.08717345
#moon        0.09123712  0.01039922
#korea       1.00000000  0.01607617
#cooperation 0.29422947  0.05549458
#china       0.01607617  1.00000000
#countries   0.28169429  0.12131780

plot(word_word_sim, type = "n", xlab = "china", ylab = "korea")
text(word_word_sim, labels = rownames(word_word_sim))


# 학습된 모델을 2차원으로 축소하여 산점도 그리기
brf_words_w2v <- as.data.frame(model00)
brf_words_w2v$word <- rownames(brf_words_w2v)
brf_words_w2v_mds <- isoMDS(dist(as.matrix(brf_words_w2v[2:444, 1:100])))
brf_words_w2v_mds$points[1:6, ]
#                   [,1]        [,2]
#president   -0.09582192  1.43250367
#moon        -0.25261201  3.40209992
#korea       -3.09959144  0.76421955
#cooperation  0.55751200 -1.68838116
#china        0.79798410 -0.03367848
#countries   -0.53570130 -2.10734518

plot(brf_words_w2v_mds$points, type = "n",
     xlab = "First Dimension", ylab = "Second Dimension")
text(brf_words_w2v_mds$points,
     labels = as.character(rownames(as.data.frame(brf_words_w2v_mds[[1]]))))

