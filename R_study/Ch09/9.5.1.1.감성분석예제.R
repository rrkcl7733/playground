
# 감성분석을 위한 환경 설정
packages <- c("tm", "tidyverse", "stringr", "plyr")
load_pkgs(packages)


# 영어의 긍정⋅부정 단어 읽어오기
pos.text.location <- paste(getwd(), "/data/dictionary/en/positive-words.txt", sep = "")
pos.words <- scan(pos.text.location, what = "character",comment.char = ";")
#Read 2006 items

str(pos.words)
#chr [1:2006] "a+" "abound" "abounds" "abundance" "abundant" "accessable" ...

neg.text.location <- paste(getwd(), "/data/dictionary/en/negative-words.txt", sep = "")
neg.words <- scan(neg.text.location, what = "character",comment.char = ";")
#Read 4783 items

str(neg.words)
#chr [1:4783] "2-faced" "2-faces" "abnormal" "abolish" "abominable" "abominably" ...


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
#Length Class          Mode
#     9 character character

(brf.corpus[[1]]$content)[[1]]
#[1] "president moon jaein premier li keqiang people republic china held meeting attended dinner chengdu china evening local time leaders indepth discussions issues mutual concern including ways promote substantive bilateral cooperation areas economy trade environment culture"

summary(brf.corpus[[2]]$content)
#Length Class     Mode
#     8 character character

(brf.corpus[[2]]$content)[[1]]
#[1] " sidelines korea japan china summit chengdu china president moon jaein japanese prime minister shinzo abe held summit minutes today local time"

summary(brf.corpus[[3]]$content)
#Length Class Mode
#    14 character character

(brf.corpus[[3]]$content)[[1]]
#[1] "president moon jaein met prime minister hun sen kingdom cambodia cheong wa dae today indepth discussions promote substantive bilateral cooperation "


# corpus_dfm() 함수를 이용해 말뭉치의 단어 빈도 생성하기
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


# 문장에서 사용된 단어의 긍정⋅부정 여부에 따른 감정을 점수화하는 함수 생성하기
score_sentiment <- function(sentences, pos.words,
                            neg.words, .progress = 'none') {
  require(plyr)
  require(stringr)
  scores <- laply(sentences, function(sentence,
                                      pos.words, neg.words) {
    pos.matches <- match(sentence, pos.words)
    neg.matches <- match(sentence, neg.words)
    pos.matches <- !is.na(pos.matches)
    neg.matches <- !is.na(neg.matches)
    score <- sum(pos.matches) - sum(neg.matches)
    return(score)
  }, pos.words, neg.words, .progress = .progress)
  
  scores.df <- data.frame(score = scores, text = sentences)
  return(scores.df)
}


# 대통령 브리핑 자료로 감성분석 수행하기
brf.snt <- score_sentiment(corpus.dfm$term, pos.words, neg.words, .progress = 'text')
dim(brf.snt)
#[1] 437 2

head(brf.snt)
#  score        text
#1     0   president
#2     0        moon
#3     0       korea
#4     0       china
#5     0 cooperation
#6     0   countries

table(brf.snt$score)
#-1   0  1
# 6 394 37


# 감성분석 결과에 color 속성 추가하기
brf.snt$color[brf.snt$score >= 1] = "blue"
brf.snt$color[brf.snt$score == 0] = "green"
brf.snt$color[brf.snt$score <0 ] = "red"
head(brf.snt)
#  score        text color
#1     0   president green
#2     0        moon green
#3     0       korea green
#4     0       china green
#5     0 cooperation green
#6     0   countries green


# 감성분석 결과에 remark 속성 추가하기
brf.snt$remark[brf.snt$score >= 1] = "긍정"
brf.snt$remark[brf.snt$score == 0] = "중립"
brf.snt$remark[brf.snt$score < 0] = "부정"
head(brf.snt)
#  score        text color remark
#1     0   president green   중립
#2     0        moon green   중립
#3     0       korea green   중립
#4     0       china green   중립
#5     0 cooperation green   중립
#6     0   countries green   중립


# 감성분석 결과 파이 그래프 그리기
brf.snt.freq <- table(brf.snt$remark)
brf.snt.freq
#긍정 부정 중립
#  37    6  394

pct <- round(brf.snt.freq/sum(brf.snt.freq)*100, 2)
lab <- paste(names(brf.snt.freq), "\n", pct, "%")
pie(brf.snt.freq, col = c("blue", "red", "green"), cex = 0.8, labels = lab)


