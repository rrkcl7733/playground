
# 감성분석을 위한 환경 설정
packages <- c("tm", "tidyverse", "stringr", "readr", "DT", "dplyr", "SentimentAnalysis")
load_pkgs(packages)


# 말뭉치 읽어오기
article.text.location <- paste(getwd(), "/tm/articles/corpus", sep = "")
atc.corpus <- VCorpus(DirSource(article.text.location),
                      readerControl = list(language = 'lat'))
summary(atc.corpus)
#         Length Class             Mode
#8024.txt 2      PlainTextDocument list
#8032.txt 2      PlainTextDocument list
#8035.txt 2      PlainTextDocument list


# 말뭉치의 구성 및 내용 확인하기
summary(atc.corpus[[1]]$content)
#Length     Class      Mode 
#     1 character character

(atc.corpus[[1]]$content)[[1]]
#[1] "신종 바이러스 감염증 번째 확진자 발생했습니 중국 여행객 방문 재인 귀국자 때문 정부 연휴 기간 긴장 시간 대응 체계 가동 있습니 질병 관리 본부장 국립 중앙 의료원 장에 전화 격려 당부 말씀 드렸습니 정부 지자체 단위 필요 노력 국민 정부 필요 조치 과도 불안 당부 드립"

summary(atc.corpus[[2]]$content)
#Length     Class      Mode 
#     1 character character 

(atc.corpus[[2]]$content)[[1]]
#[1] "문재인 대통령 오후 청와대 영빈관 준장 진급 장군 상징 삼정 환담 가졌습니 문재인 대통령 환담 모두 발언 과거 대장 진급 자와 일부 중장진급 수치 방식 대통령 삼정 우리 정부 장성 진급 대통령 무관 선택 노력 명예 뿌듯 때문 대통령 축하 말했습니 통수권자 대통령 준장 진급 삼정 문재인 정부 시도 군인 장성 진급 의미 문재인 대통령 생각 시작됐습니 문재인 대통령 사관생도 학군 후보생 시절 장교 계급장 마음가짐 자세 가슴 초심 만한 비결 진급 격려했습니 문재인 대통령 오늘 삼정 수여식 장군 진급 자분 대한민국 축하 축하 가족 해당 가족 헌신 희생 자리 진급 자분 오늘 가족 참석자 박수 받았습니 문재인 대통령 안보 우리 사회 소중 통솔하 수장 장군 우리 사회 시각 국가 대한민국 비전 가져달라고 당부했습니 환담 문재인 대통령 장군 진급 혁신 포용 공정 평화 자주국방 다섯 가지 비전 강조했습니 문재인 대통령 대한민국 나라 혁신 무기 체계 전략 전술 군사 관리 국방 개혁 대한민국 혁신 말했습니 문재인 대통령 군내 양성평등 실현 장병 복지 개선 포용적 부분 입대 보직 인사 휴가 때문 공정 지적했습니 문재인 대통령 도발 강력 국방력 평화 평화 중심 주체 강조했습니 문재인 대통령 마지막 우리 국방 전시작 전권 우리 환수 여러 자주국방 전작 실현 주역 말했습니 문재인 대통령 환담 마무리 발언 정경 국방부 장관 부탁했습니 정경 장관 평화 국민 신뢰 미래 준비 다짐했습니 오늘 삼정 수여식 행사 참석자 행사장 입구 신종 코로나 바이러스 감염증 관련 체온 체크 소독 입장했습니"

summary(atc.corpus[[3]]$content)
#Length     Class      Mode 
#     1 character character 

(atc.corpus[[3]]$content)[[1]]
#[1] "오늘 회의 신종 코로나 바이러스 감염증 대책 종합적 점검 논의 하기 소집 시도지사 화상 연결 참석 감사 감염 확산 민생 경제 영향 최소화 하기 중앙정부 지자체 소통 협력 화해 오늘 중국 우한 고립 우리 교민 귀국 시작 실제 도착 내일 협조 항공 승무원 우리 국민 어디 국민 생명 안전 국가 당연 책무 현지 교민 가운데 감염증 확진자 의심 환자 파악 교민 중국 정부 협의 검역 증상 경우 임시 항공편 탑승 귀국 일정 기간 외부 격리 별도 시설 생활 검사 귀국 교민 안전 완벽 차단 지역사회 감염 예방 하기 조치 정부 임시 생활 시설 운영 지역 주민 불안 이해 대책 걱정 하시 정부 관리 이해 협조 당부 불안 약속 드립 중국 교민 중국당국 협력 나가겠습니 국민 안전 타협 상황 대비 필요 조치 예방조치 만큼 강력 정부 지자체 대응 역량 최대한 감염 방지 총력 시행 우한 지역 입국자 전수조사 진행 경과 결과 투명 연락 자진 당부 증상 확진 환자 접촉 모니터링 관리 체계 강화 필요 지역의료 기관 진료 신고 체계 점검 확산 대비 지역별 선별 진료소 격리 병상 확충 필요 인력과 물품 확보 속도 중국 나라 확진 환자 발생 때문 바이러스 유입 경로 다양 경우 대비 공항 항만 검역 강화 조치 강구 우리 바이러스 과도 불안감 막연 공포 단호 정부 정확 정보 신속 제공 국민 일상 생활 위축 불필요 오해 억측 필요 정보 투명 신속 국민 시각 상세 공개 하기 가짜 뉴스 엄정 대응 강조 우수 방역 체계 신뢰 작동 하기 확산 신종 감염 범국가적 역량 불신 불안 조장 가짜 뉴스 생산 유포 방역 방해 국민 안전 저해 중대 범죄행위 관계 부처 표현 자유 가짜 뉴스 각별 경각심 단호 대처 언론 역할 중요 신종 코로나 극복 정치권 문제 정쟁 자제 주시 요청 우려 부분 과도 경제 심리 위축 불안감 때문 정상적 경제 활동 영향 경제부총리 중심 부처 경제 상황 관리 기해 당부 국내외 금융시장 불안 수출 투자 소비 우리 경제 영향 종합적 점검 대책 필요 지역경제 관광 숙박 서비스업종 어려움 지자체 지역별 업종 파급효과 행정적 재정적 지원 필요 부분 신속 충분 규모 지원 대책 마련 해주 중국 신종 상황 진정 현지 진출 우리 기업 어려움 예상 관계기관 현지 기업 경제 단체 소통 채널 최소화 적극 지원 국민 여러분 당부 드리겠습니 신종 코로나 우리 자신 무기 공포 혐오 신뢰 협력 우리 세계 최고 수준 방역 역량 과거 사례 축적 경험 정부 최선 국민 지역사회 협력 극복 있습니 정부 지자체 정부 국민 개개인 예방 행동 수칙 우리 신종 피해 최소화 우리 국민 성숙 역량 정부 최선 다하겠습니"


# corpus_dfm() 함수를 이용해 말뭉치의 단어 빈도 생성하기
corpus.dfm <- corpus_dfm(atc.corpus)
NROW(corpus.dfm)
#[1] 86

head(corpus.dfm)
#        term num
#1     대통령  16
#2     문재인  13
#3 코로나일구   7
#4     지자체   5
#5     감염증   4
#6   대한민국   4


# 한국어 긍정과 부정 단어사전 읽어오기
sentiword.dict.location <- paste(getwd(), "/data/dictionary/kr/SentiWord_Dict.txt", sep = "")
senti_words_kr <- read_delim(sentiword.dict.location, delim = '\t',
                             col_names = c("term", "score"))
head(senti_words_kr)
# A tibble: 6 x 2
#  term  score
#  <chr> <dbl>
#1 (-;       1
#2 (;_;)    -1
#3 (^^)      1
#4 (^-^)     1
#5 (^^*      1
#6 (^_^)     1
        
dim(senti_words_kr)
#[1] 14855 2     


# 한국어 감성사전에 단어 등록하기
senti_words_kr <- rbind(senti_words_kr,
                        data.frame(term = c("확진자", "코로나일구", "감염증"),
                                   score = c(-1, -1, -1)))
tail(senti_words_kr)
# A tibble: 6 x 2
#  term       score
#  <chr>      <dbl>
#1 내팽개치다    -2
#2 횡령          -2
#3 불안증        -2
#4 확진자        -1
#5 코로나일구    -1
#6 감염증        -1


# 한국어 감성사전에서 중복 단어 제거하기
x <- duplicated(senti_words_kr$term)
senti_words_kr[x, ]
# A tibble: 3 x 2
#  term       score
#  <chr>      <dbl>
#1 버릇없이      -2
#2 울컥하다      -1
#3 적극적이다     1

senti_words_kr <- senti_words_kr[!x, ]
nrow(senti_words_kr)
#[1] 14855


# 한국어 감성사전의 단어 당 긍정 및 부정에 관한 가중치 설정하기
senti_dict_wt <- SentimentDictionaryWeighted(words = senti_words_kr$term,
                                             scores = senti_words_kr$score)


# 새로운 감성사전 만들기
senti_dict_kr <- SentimentDictionary(senti_dict_wt$words[senti_dict_wt$scores >= 0],
                                     senti_dict_wt$words[senti_dict_wt$scores < 0])
str(senti_dict_kr)
#List of 2
#$ positiveWords : chr [1:5025] "(-;" "(^^)" "(^-^)" "(^^*" ...
#$ negativeWords : chr [1:9831] "(;_;)" "(^_^;" "(-_-)" "(T_T)" ...
#- attr(*, "class") = chr "SentimentDictionaryBinary"

summary(senti_dict_kr)
#Dictionary type:  binary (positive / negative)
#Total entries:    14856
#Positive entries: 5025 (33.82%)
#Negative entries: 9831 (66.18%)


# 대통령 연설문 자료로 감성분석 수행하기
sentiment_word_res <- analyzeSentiment(as.character(corpus.dfm$term),
                                       language = "korean",
                                       rules = list("KoreanSentiment" = list(ruleSentiment, senti_dict_kr)),
                                       removeStopwords = F,
                                       stemming = F,
                                       removeNumbers = F)
sentiment_word_kr <- data.frame(word = corpus.dfm$term,
                                num = corpus.dfm$num,
                                sentiment = sentiment_word_res$KoreanSentiment)
head(sentiment_word_kr)
#        word num sentiment
#1     대통령  16         0
#2     문재인  13         0
#3 코로나일구   7        -1
#4     지자체   5         0
#5     감염증   4        -1
#6   대한민국   4         0

table(sentiment_word_kr$sentiment)
#-1  0
# 5 81


# 감성분석 결과에 remark 속성 추가하기
sentiment_word_kr <- sentiment_word_kr %>%
  mutate(remark = if_else(sentiment > 0, "긍정",
                      ifelse(sentiment == 0, "중립", "부정"))) %>%
  select(remark, everything())
head(sentiment_word_kr)
# remark       word num sentiment
#1  중립     대통령  16         0
#2  중립     문재인  13         0
#3  부정 코로나일구   7        -1
#4  중립     지자체   5         0
#5  부정     감염증   4        -1
#6  중립   대한민국   4         0


# 감성분석 결과 파이 그래프 그리기
sentiment.freq <- table(sentiment_word_kr$remark)
sentiment.freq
#부정 중립
#   5   81

pct <- round(sentiment.freq/sum(sentiment.freq)*100, 2)
lab <- paste(names(sentiment.freq), "\n", pct, "%")
pie(sentiment.freq, col = c("red", "green"), cex = 0.8, labels = lab)


# 감성분석 결과 긍정과 중립 단어 빈도 역순의 막대 그래프 그리기
top_article_words <- sentiment_word_kr %>%
  group_by(sentiment) %>%
  top_n(10, num) %>%
  ungroup() %>%
  mutate(word = reorder(word, num))
ggplot(top_article_words, aes(word, num, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free") +
  coord_flip() +
  labs(x = "", y = "")

