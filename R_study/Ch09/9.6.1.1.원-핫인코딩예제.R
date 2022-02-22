
# 원-핫 인코딩을 위한 환경 설정
packages <- c("tm", "tidyverse", "stringr", "dplyr")
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


# 말뭉치의 문서단어행렬(DTM) 구축하기
mtx.ctrl <- list(language = "english",
                 removeNumbers = FALSE,
                 removePunctuation = FALSE,
                 stopwords = FALSE,
                 stemming = FALSE,
                 wordLengths = c(2, Inf))
dtm <- DocumentTermMatrix(brf.corpus, control = mtx.ctrl)
dtm
#<<DocumentTermMatrix (documents: 3, terms: 443)>>
#Non-/sparse entries: 545/784
#Sparsity           : 59%
#Maximal term length: 16
#Weighting          : term frequency (tf)


# 생성된 DTM을 행렬로 변환하여 출력하기
dtm.mtx <- as.matrix(dtm)
dtm.mtx[, 1:6]
#         Terms
#Docs      abducted abe abundant achieved active actively
#  486.txt        0   0        0        1      0        2
#  487.txt        1   6        0        0      0        0
#  488.txt        0   0        1        0      3        0


# 원-핫 인코딩 형식으로 변환하기
dtm.mtx[dtm.mtx >= 1] <- 1
rownames(dtm.mtx) <- c("doc486", "doc487", "doc488")
dtm.mtx[, 1:6]
#        Terms
#Docs     abducted abe abundant achieved active actively
#  doc486        0   0        0        1      0        1
#  doc487        1   1        0        0      0        0
#  doc488        0   0        1        0      1        0
dim(dtm.mtx)
#[1] 3 443

