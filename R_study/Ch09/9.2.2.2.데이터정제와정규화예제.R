
# tm_map() 함수에 적용되는 사전 처리 함수 확인하기
library(tm)
getTransformations()
#[1] "removeNumbers"     "removePunctuation" "removeWords"       "stemDocument"      "stripWhitespace"  


# 수집된 대통령 브리핑 자료 읽어오기
briefing.text.location <- paste(getwd(), "/tm/briefings/txt", sep = "")
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
#[1] "President Moon Jae-in and Premier Li Keqiang of the People’s Republic of China held a meeting and attended a dinner in Chengdu, China, from 6:30 to 8:55 this evening (local time). The two leaders had in-depth discussions on issues of mutual concern, including ways to promote substantive bilateral cooperation in such areas as the economy, trade, the environment and culture."

summary(brf.corpus[[2]]$content)
#Length     Class      Mode 
#     8 character character 

(brf.corpus[[2]]$content)[[1]]
#[1] "On the sidelines of the 8th Korea-Japan-China Summit in Chengdu, China, President Moon Jae-in and Japanese Prime Minister Shinzo Abe held a summit for 45 minutes from 2:00 p.m. today (local time)."

summary(brf.corpus[[3]]$content)
#Length     Class      Mode 
#    14 character character 

(brf.corpus[[3]]$content)[[1]]
#[1] "President Moon Jae-in met with Prime Minister Hun Sen of the Kingdom of Cambodia at Cheong Wa Dae from 4:30 p.m. to 5:15 p.m. today. They had in-depth discussions on how to promote substantive bilateral cooperation. "


# 정규표현식을 이용한 일정한 패턴의 단어 찾기
pattern1 <- gregexpr("[[:alpha:]]+\\-", (brf.corpus[[2]]$content)[[1]])
pattern1
#[[1]]
#[1] 29 35 88
#attr(,"match.length")
#[1] 6 6 4
#attr(,"index.type")
#[1] "chars"
#attr(,"useBytes")
#[1] TRUE

regmatches((brf.corpus[[2]]$content)[[1]], pattern1)
#[[1]]
#[1] "Korea-" "Japan-" "Jae-"  

pattern2 <- gregexpr("[[:alpha:]]+(ing)", (brf.corpus[[1]]$content)[[1]])
regmatches((brf.corpus[[1]]$content)[[1]], pattern2)
#[[1]]
#[1] "meeting"   "evening"   "including"


# 특정 패턴 단어 제거하기(’s, Korea-Japan-China ⇨ Korea Japan China)
library(stringr)
brf.corpus <- tm_map(brf.corpus,
                     content_transformer(str_replace_all),
                     pattern = "Korea-Japan-China",
                     replacement = "Korea Japan China")
(brf.corpus[[2]]$content)[[1]]
#[1] "On the sidelines of the 8th Korea Japan China Summit in Chengdu, China, President Moon Jae-in and Japanese Prime Minister Shinzo Abe held a summit for 45 minutes from 2:00 p.m. today (local time)."

brf.corpus <- tm_map(brf.corpus,
                     content_transformer(str_replace_all),
                     pattern = "\\’s",
                     replacement = "")
(brf.corpus[[1]]$content)[[1]]
#[1] "President Moon Jae-in and Premier Li Keqiang of the People Republic of China held a meeting and attended a dinner in Chengdu, China, from 6:30 to 8:55 this evening (local time). The two leaders had in-depth discussions on issues of mutual concern, including ways to promote substantive bilateral cooperation in such areas as the economy, trade, the environment and culture."


# 말뭉치에서 숫자 표현 제거하기
brf.corpus <- tm_map(brf.corpus, removeNumbers)
(brf.corpus[[2]]$content)[[1]]
#[1] "On the sidelines of the th Korea Japan China Summit in Chengdu, China, President Moon Jae-in and Japanese Prime Minister Shinzo Abe held a summit for  minutes from : p.m. today (local time)."


# 말뭉치에서 대문자를 소문자로 치환하기
brf.corpus <- tm_map(brf.corpus, content_transformer(tolower))
(brf.corpus[[2]]$content)[[1]]
#[1] "on the sidelines of the th korea japan china summit in chengdu, china, president moon jae-in and japanese prime minister shinzo abe held a summit for  minutes from : p.m. today (local time)."


# 말뭉치에서 문장부호 및 특수문자 제거하기
brf.corpus <- tm_map(brf.corpus, removePunctuation)
(brf.corpus[[2]]$content)[[1]]
#[1] "on the sidelines of the th korea japan china summit in chengdu china president moon jaein and japanese prime minister shinzo abe held a summit for  minutes from  pm today local time"


# 말뭉치에서 불용단어 제거하기(tm 패키지의 “en” 불용단어 목록에는 총 174개 존재).
stopwords("en")
#[1] "i" "me" "my" "myself" "we"
#[6] "our" "ours" "ourselves" "you" "your"
#...
#[171] "so" "than" "too" "very"

brf.corpus <- tm_map(brf.corpus, removeWords, stopwords("en"))
(brf.corpus[[2]]$content)[[1]]
#[1] "  sidelines   th korea japan china summit  chengdu china president moon jaein  japanese prime minister shinzo abe held  summit   minutes   pm today local time"


# 말뭉치에서 불용단어 제거하기(tm 패키지의 “SMART” 불용단어 목록에는 총 571개 존재)
stopwords("SMART")
#[1] "a" "a's" "able" "about"
#...
#[569] "yourselves" "z" "zero"

brf.corpus <- tm_map(brf.corpus, removeWords, stopwords("SMART"))
(brf.corpus[[2]]$content)[[1]]
#[1] "  sidelines    korea japan china summit  chengdu china president moon jaein  japanese prime minister shinzo abe held  summit   minutes   pm today local time"


# 말뭉치에서 불용단어 제거하기(tm 패키지의 “en” 불용단어 목록에 “pm” 단어 추가)
j.stopword <- c(stopwords('en'), 'pm')
brf.corpus <- tm_map(brf.corpus, removeWords, j.stopword)
(brf.corpus[[2]]$content)[[1]]
#[1] "  sidelines    korea japan china summit  chengdu china president moon jaein  japanese prime minister shinzo abe held  summit   minutes    today local time"


# 어근 동일화(Stemming) 처리 수행하기
test <- stemDocument(c('updated', 'update', 'updating'))
test
#[1] "updat" "updat" "updat"

test <- stemCompletion(test, dictionary = c('updated', 'update', 'updating'))
test
#updat updat updat
#"update" "update" "update"

library(quanteda)
word.text <- NA
for (i in 1:length(brf.corpus)) {
  word.text <- c(word.text, as.character(brf.corpus[[i]]$content))
}
word.text
dictionary.brf <- tokens(word.text)
dictionary.brf <- as.character(dictionary.brf)
str(dictionary.brf)
#chr [1:913] "president" "moon" "jaein" "premier" "li" "keqiang" "people" ...

doc1.stem <- stemDocument(dictionary.brf)
doc1.stemcpl <- stemCompletion(doc1.stem, dictionary = dictionary.brf, type = 'first')
head(doc1.stemcpl)
#    presid        moon       jaein     premier          li     keqiang 
#"president"      "moon"     "jaein"   "premier"        "li"   "keqiang" 


# 말뭉치에서 공란 처리하기
brf.corpus <- tm_map(brf.corpus, stripWhitespace)
(brf.corpus[[2]]$content)[[1]]
#[1] " sidelines korea japan china summit chengdu china president moon jaein japanese prime minister shinzo abe held summit minutes today local time"


# 데이터 전처리 함수 생성하기
preprocess_corpus <- function(corpus) {
  require(tm)
  require(stringr)
  # 특수 패턴 문자 변경하기
  corpus <- tm_map(corpus, content_transformer(str_replace_all),
                   pattern = "Korea-Japan-China", replacement ="Korea Japan China")
  corpus <- tm_map(corpus, content_transformer(str_replace_all),
                   pattern = "\\’s", replacement = "")
  corpus <- tm_map(corpus, content_transformer(str_replace_all),
                   pattern = "“", replacement = "")
  corpus <- tm_map(corpus, content_transformer(str_replace_all),
                   pattern = "”", replacement = "")
  corpus <- tm_map(corpus, content_transformer(str_replace_all),
                   pattern = "‘", replacement = "")
  corpus <- tm_map(corpus, content_transformer(str_replace_all),
                   pattern = "’", replacement = "")
  # 숫자 표현 삭제
  corpus <- tm_map(corpus, removeNumbers)
  # 대문자를 소문자로 치환
  corpus <- tm_map(corpus, content_transformer(tolower))
  # 문장부호 및 구두점 제거
  corpus <- tm_map(corpus, removePunctuation)
  # 불용단어 제거
  j.stopword <- c(stopwords('en'), 'pm')
  corpus <- tm_map(corpus, removeWords, j.stopword)
  corpus <- tm_map(corpus, removeWords, stopwords("SMART"))
  # 공란 처리
  corpus <- tm_map(corpus, stripWhitespace)
  # 처리결과값 반환
  return(corpus)
}


# preprocess_corpus() 함수를 이용해 데이터 전처리 수행하기
corpus <- preprocess_corpus(brf.corpus)
summary(corpus)
#        Length Class             Mode
#486.txt 2      PlainTextDocument list
#487.txt 2      PlainTextDocument list
#488.txt 2      PlainTextDocument list

(corpus[[2]]$content)[[1]]
#[1] " sidelines korea japan china summit chengdu china president moon jaein japanese prime minister shinzo abe held summit minutes today local time"


# 전처리된 말뭉치 객체를 저장하기
writeCorpus(corpus, path = "tm/briefings/corpus")


# 데이터 전처리된 말뭉치를 단어 빈도 역순의 데이터프레임 형식으로 변환하는 함수 만들기
corpus_dfm <- function(corpus) {
  require(tm)
  require(tidyverse)
  doc_tdm <- TermDocumentMatrix(corpus)
  doc_mtx <- as.matrix(doc_tdm)
  doc_term_freq <- rowSums(doc_mtx)
  doc_word_freqs <- data.frame(term = names(doc_term_freq),
                               num = doc_term_freq) %>% arrange(desc(num))
  return(doc_word_freqs)
}


# corpus_dfm() 함수를 이용해 단어 빈도가 높은 단어 확인하기
corpus.dfm <- corpus_dfm(corpus)
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


