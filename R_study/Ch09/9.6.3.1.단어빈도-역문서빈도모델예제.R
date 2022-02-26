
# 환경 설정
packages <- c("dplyr", "tidytext", "janeaustenr", "quanteda", "ggplot2", "tm", "lsa", "qdap",
              "proxy")
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


# 말뭉치를 데이터프레임 형식으로 변환하는 corpus_dfm_text() 함수 만들기
corpus_dfm_text <- function(corpus, doc.name) {
  doc.names <- doc.name
  doc.df <- data.frame()
  for (i in 1:length(corpus)) {
    doc.text <- NULL
    for (j in 1:length(corpus[[i]]$content)) {
      doc.text <- paste(doc.text, corpus[[i]]$content[[j]], sep = " ")
    }
    doc.df <- rbind(doc.df,
                    data.frame(doc = doc.names[i],
                               text = doc.text,
                               stringsAsFactors = FALSE))
  }
  return(doc.df)
}


# corpus_dfm_text() 함수를 이용해 말뭉치의 문서별 문서 내용 생성하기
doc.names <- c("doc486", "doc487", "doc488")
corpus.dfm.text <- corpus_dfm_text(brf.corpus, doc.names)
str(corpus.dfm.text)
#'data.frame':	3 obs. of  2 variables:
#$ doc : chr  "doc486" "doc487" "doc488"
#$ text: chr  " president moon jaein premier li keqiang people republic china held meeting attended dinner chengdu china eveni"| __truncated__ "  sidelines korea japan china summit chengdu china president moon jaein japanese prime minister shinzo abe held"| __truncated__ " president moon jaein met prime minister hun sen kingdom cambodia cheong wa dae today indepth discussions promo"| __truncated__


# 문서 내용이 저장된 text 속성을 토큰으로 변환하고, 
# 문서(doc)와 단어(word)의 빈도의 역순으로 정렬하여 데이터프레임으로 생성하기
brf_words <- corpus.dfm.text %>% unnest_tokens(word, text) %>%
  dplyr::count(doc, word, sort = TRUE)
head(brf_words)
# A tibble: 6 x 3
#  doc    word            n
#  <chr>  <chr>       <int>
#1 doc486 china          12
#2 doc488 cambodia       11
#3 doc488 cooperation    10
#4 doc488 president      10
#5 doc486 premier         9
#6 doc488 moon            9


# 문서별 총 단어 빈도 계산하기
total_words <- brf_words %>% dplyr::group_by(doc) %>% dplyr::summarize(total = sum(n))
head(total_words)
# A tibble: 3 x 2
#  doc    total
#  <chr>  <int>
#1 doc486   321
#2 doc487   193
#3 doc488   342


# 문서(doc), 단어(word), 단어 빈도(n)와 문서별 총 단어 빈도(total) 병합하기
brf_words <- left_join(brf_words, total_words)
head(brf_words)
# A tibble: 6 x 4
#  doc    word            n total
#  <chr>  <chr>       <int> <int>
#1 doc486 china          12   321
#2 doc488 cambodia       11   342
#3 doc488 cooperation    10   342
#4 doc488 president      10   342
#5 doc486 premier         9   321
#6 doc488 moon            9   342


# 문서별 단어 빈도(TF) 계산하기
brf_words_tf <- brf_words %>% dplyr::group_by(doc) %>%
                  dplyr::mutate(rank = row_number(), 
                                termfreq = n/total)
head(brf_words_tf)
# A tibble: 6 x 6
# Groups:   doc [2]
#  doc    word            n total  rank termfreq
#  <chr>  <chr>       <int> <int> <int>    <dbl>
#1 doc486 china          12   321     1   0.0374
#2 doc488 cambodia       11   342     1   0.0322
#3 doc488 cooperation    10   342     2   0.0292
#4 doc488 president      10   342     3   0.0292
#5 doc486 premier         9   321     2   0.0280
#6 doc488 moon            9   342     4   0.0263


# TF, IDF, TF-IDF 값 계산하기
brf_words_tfidf <- brf_words %>% bind_tf_idf(word, doc, n)
head(brf_words_tfidf)
# A tibble: 6 x 7
#  doc    word            n total     tf   idf tf_idf
#  <chr>  <chr>       <int> <int>  <dbl> <dbl>  <dbl>
#1 doc486 china          12   321 0.0374 0.405 0.0152
#2 doc488 cambodia       11   342 0.0322 1.10  0.0353
#3 doc488 cooperation    10   342 0.0292 0.405 0.0119
#4 doc488 president      10   342 0.0292 0     0     
#5 doc486 premier         9   321 0.0280 1.10  0.0308
#6 doc488 moon            9   342 0.0263 0     0     


# 데이트 세트에서 total 속성을 제거하고, TF-IDF 값의 역순으로 정렬하기
brf_words_tfidf %>%
  select(-total, doc_name = doc, term_name = word, term_freq = n) %>%
  arrange(desc(tf_idf))
# A tibble: 545 x 6
#  doc_name term_name term_freq     tf   idf tf_idf
#  <chr>    <chr>         <int>  <dbl> <dbl>  <dbl>
#1 doc488   cambodia         11 0.0322 1.10  0.0353
#2 doc487   abe               6 0.0311 1.10  0.0342
#3 doc487   japan             6 0.0311 1.10  0.0342
#4 doc486   premier           9 0.0280 1.10  0.0308
#5 doc487   issue             4 0.0207 1.10  0.0228
#6 doc486   li                5 0.0156 1.10  0.0171
#7 doc487   export            3 0.0155 1.10  0.0171
#8 doc488   mou               5 0.0146 1.10  0.0161
#9 doc488   project           5 0.0146 1.10  0.0161
#10 doc486   china            12 0.0374 0.405 0.0152
# ... with 535 more rows


# 문서별 TF-IDF 값이 높은 상위 10개의 단어 막대 그래프 그리기
brf_words_tfidf %>% arrange(desc(tf_idf)) %>%
  mutate(word = factor(word, levels = rev(unique(word)))) %>%
  group_by(doc) %>% top_n(10) %>% ungroup() %>%
  ggplot(aes(word, tf_idf, fill = doc)) +
  geom_col(show.legend = FALSE) +
  labs(x = NULL, y = "tf-idf") +
  facet_wrap(~doc, ncol = 3, scales = "free") +
  coord_flip()


# 데이터셋(brf_words_tfidf)에서 고유한 단어 추출하기
brf_tfidf_dfm <- data.frame(word = unique(brf_words_tfidf$word))
head(brf_tfidf_dfm)
#         word
#1       china
#2    cambodia
#3 cooperation
#4   president
#5     premier
#6        moon

nrow(brf_tfidf_dfm)
#[1] 443


# 데이터셋(brf_tfidf_dfm)와 문서(486)의 속성(n, total, tf, idf, tf_idf) 병합하기
brf_doc486 <- brf_words_tfidf[brf_words_tfidf$doc == "doc486", ] %>%
  select(word, doc486_freq = n, doc486_tot_freq = total,
         doc486_tf = tf, doc486_idf = idf, doc486_tfidf = tf_idf)
brf_tfidf_dfm <- left_join(brf_tfidf_dfm, brf_doc486)
head(brf_tfidf_dfm)
#         word doc486_freq doc486_tot_freq  doc486_tf doc486_idf doc486_tfidf
#1       china          12             321 0.03738318  0.4054651  0.015157574
#2    cambodia          NA              NA         NA         NA           NA
#3 cooperation           4             321 0.01246106  0.4054651  0.005052525
#4   president           8             321 0.02492212  0.0000000  0.000000000
#5     premier           9             321 0.02803738  1.0986123  0.030802214
#6        moon           7             321 0.02180685  0.0000000  0.000000000


# 데이터셋(brf_tfidf_dfm)와 문서(487)의 속성(n, total, tf, idf, tf_idf) 병합하기
brf_doc487 <- brf_words_tfidf[brf_words_tfidf$doc == "doc487", ] %>%
  select(word, doc487_freq = n, doc487_tot_freq = total,
         doc487_tf = tf, doc487_idf = idf, doc487_tfidf = tf_idf)
brf_tfidf_dfm <- left_join(brf_tfidf_dfm, brf_doc487)
head(brf_tfidf_dfm[,c(1, 7:11)])
#         word doc487_freq doc487_tot_freq  doc487_tf doc487_idf doc487_tfidf
#1       china           2             193 0.01036269  0.4054651  0.004201711
#2    cambodia          NA              NA         NA         NA           NA
#3 cooperation          NA              NA         NA         NA           NA
#4   president           5             193 0.02590674  0.0000000  0.000000000
#5     premier          NA              NA         NA         NA           NA
#6        moon           5             193 0.02590674  0.0000000  0.000000000


# 데이터셋(brf_tfidf_dfm)와 문서(488)의 속성(n, total, tf, idf, tf_idf) 병합하기
brf_doc488 <- brf_words_tfidf[brf_words_tfidf$doc == "doc488", ] %>%
  select(word, doc488_freq = n, doc488_tot_freq = total,
         doc488_tf = tf, doc488_idf = idf, doc488_tfidf = tf_idf)
brf_tfidf_dfm <- left_join(brf_tfidf_dfm, brf_doc488)
head(brf_tfidf_dfm[, c(1, 12:16)])
#         word doc488_freq doc488_tot_freq  doc488_tf doc488_idf doc488_tfidf
#1       china          NA              NA         NA         NA           NA
#2    cambodia          11             342 0.03216374  1.0986123   0.03533548
#3 cooperation          10             342 0.02923977  0.4054651   0.01185570
#4   president          10             342 0.02923977  0.0000000   0.00000000
#5     premier          NA              NA         NA         NA           NA
#6        moon           9             342 0.02631579  0.0000000   0.00000000


# 데이트 세트(brf_tfidf_dfm)에서 NA값 제거하기
brf_tfidf_dfm[is.na(brf_tfidf_dfm$doc486_freq), "doc486_freq"] <- c(0)
brf_tfidf_dfm[is.na(brf_tfidf_dfm$doc486_tot_freq), "doc486_tot_freq"] <- c(0)
brf_tfidf_dfm[is.na(brf_tfidf_dfm$doc486_tf), "doc486_tf"] <- c(0)
brf_tfidf_dfm[is.na(brf_tfidf_dfm$doc486_idf), "doc486_idf"] <- c(0)
brf_tfidf_dfm[is.na(brf_tfidf_dfm$doc486_tfidf), "doc486_tfidf"] <- c(0)
brf_tfidf_dfm[is.na(brf_tfidf_dfm$doc487_freq), "doc487_freq"] <- c(0)
brf_tfidf_dfm[is.na(brf_tfidf_dfm$doc487_tot_freq), "doc487_tot_freq"] <- c(0)
brf_tfidf_dfm[is.na(brf_tfidf_dfm$doc487_tf), "doc487_tf"] <- c(0)
brf_tfidf_dfm[is.na(brf_tfidf_dfm$doc487_idf), "doc487_idf"] <- c(0)
brf_tfidf_dfm[is.na(brf_tfidf_dfm$doc487_tfidf), "doc487_tfidf"] <- c(0)
brf_tfidf_dfm[is.na(brf_tfidf_dfm$doc488_freq), "doc488_freq"] <- c(0)
brf_tfidf_dfm[is.na(brf_tfidf_dfm$doc488_tot_freq), "doc488_tot_freq"] <- c(0)
brf_tfidf_dfm[is.na(brf_tfidf_dfm$doc488_tf), "doc488_tf"] <- c(0)
brf_tfidf_dfm[is.na(brf_tfidf_dfm$doc488_idf), "doc488_idf"] <- c(0)
brf_tfidf_dfm[is.na(brf_tfidf_dfm$doc488_tfidf), "doc488_tfidf"] <- c(0)
nrow(brf_tfidf_dfm[!complete.cases(brf_tfidf_dfm),])
#[1] 0


# 문서별 TF-IDF 값을 선별하여 단어문서행렬(TDM)으로 변환하기
brf_tdm <- brf_tfidf_dfm %>% select(doc486_tfidf, doc487_tfidf, doc488_tfidf)
rownames(brf_tdm) <- c(brf_tfidf_dfm$word)
colnames(brf_tdm) <- c("doc486", "doc487", "doc488")
head(brf_tdm)
#                 doc486      doc487     doc488
#china       0.015157574 0.004201711 0.00000000
#cambodia    0.000000000 0.000000000 0.03533548
#cooperation 0.005052525 0.000000000 0.01185570
#president   0.000000000 0.000000000 0.00000000
#premier     0.030802214 0.000000000 0.00000000
#moon        0.000000000 0.000000000 0.00000000
dim(brf_tdm)
#[1] 443 3


# 문서별 TF-IDF 값을 선별하여 문서단어행렬(DTM)으로 변환하기
brf_dtm <- brf_tfidf_dfm %>% select(doc486_tfidf, doc487_tfidf, doc488_tfidf) %>% t()
colnames(brf_dtm) <- c(brf_tfidf_dfm$word)
rownames(brf_dtm) <- c("doc486", "doc487", "doc488")
head(brf_dtm[, 1:5])
#             china   cambodia cooperation president    premier
#doc486 0.015157574 0.00000000 0.005052525         0 0.03080221
#doc487 0.004201711 0.00000000 0.000000000         0 0.00000000
#doc488 0.000000000 0.03533548 0.011855705         0 0.00000000


# 코사인 유사도(Cosine similarity)를 이용한 문서 간 유사도 비교하기
cosine(as.matrix(brf_tdm))
#           doc486     doc487     doc488
#doc486 1.00000000 0.02863053 0.03898765
#doc487 0.02863053 1.00000000 0.05382177
#doc488 0.03898765 0.05382177 1.00000000


# 코사인 거리(Cosine distance)를 이용한 문서 간 유사도 비교하기
as.matrix(dist(brf_dtm, method = "cosine"))
#          doc486    doc487    doc488
#doc486 0.0000000 0.9713695 0.9610123
#doc487 0.9713695 0.0000000 0.9461782
#doc488 0.9610123 0.9461782 0.0000000


