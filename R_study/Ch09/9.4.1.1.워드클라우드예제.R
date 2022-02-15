
# 워드 클라우드 분석을 위한 환경 설정
load_pkgs <- function(pkgs) {
  # 신규 패키지 설치
  new_pkgs <- pkgs[!(pkgs %in% installed.packages()[, "Package"])]
  if (length(new_pkgs))
     install.packages(new_pkgs, dependencies = TRUE)
  # 기존 패키지 library 불러오기
  sapply(pkgs, require, character.only = TRUE)
}

# 패키지 불러오기
packages <- c("tm", "tidyverse", "stringr", "wordcloud")
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
#Length     Class      Mode 
#     9 character character 


(brf.corpus[[1]]$content)[[1]]
#[1] "president moon jaein premier li keqiang people republic china held meeting attended dinner chengdu china evening local time leaders indepth discussions issues mutual concern including ways promote substantive bilateral cooperation areas economy trade environment culture"


summary(brf.corpus[[2]]$content)
#Length     Class      Mode 
#     8 character character 


(brf.corpus[[2]]$content)[[1]]
#[1] " sidelines korea japan china summit chengdu china president moon jaein japanese prime minister shinzo abe held summit minutes today local time"


summary(brf.corpus[[3]]$content)
#Length     Class      Mode 
#    14 character character


(brf.corpus[[3]]$content)[[1]]
#[1] "president moon jaein met prime minister hun sen kingdom cambodia cheong wa dae today indepth discussions promote substantive bilateral cooperation "


# 말뭉치의 문서단어행렬(DTM) 구축하기
dtm <- DocumentTermMatrix(brf.corpus)
dtm
#<<DocumentTermMatrix (documents: 3, terms: 437)>>
#Non-/sparse entries: 539/772
#Sparsity           : 59%
#Maximal term length: 16
#Weighting          : term frequency (tf)


# corpus_dfm() 함수를 이용해 말뭉치의 단어 빈도 생성 및 시각화
corpus.dfm <- corpus_dfm(brf.corpus)
NROW(corpus.dfm)
#[1] 437

head(corpus.dfm)
#         term num
#1   president  23
#2        moon  21
#3       korea  19
#4       china  14
#5 cooperation  14
#6   countries  14

theme_set(theme_bw(base_family = "AppleGothic"))
ggplot(corpus.dfm %>% filter(num > 10), aes(reorder(term, num), num)) +
  geom_bar(stat = "identity", width = 0.5, fill = "tomato2") +
  coord_flip() +
  theme(axis.text.x = element_text(angle = 65, vjust = 0.6))


# 대통령 브리팅 자료를 이용한 워드 클라우드 수행하기
wordcloud(words = corpus.dfm$term, freq = corpus.dfm$num,
          min.freq = 1, random.order = F, colors = brewer.pal(8, 'Dark2'))


