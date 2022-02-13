
# 수집된 대통령 연설문 자료 읽어오기
library(KoNLP)
library(tm)
article.text.location <- paste(getwd(), "/tm/articles/txt", sep = "")
atc.corpus <- VCorpus(DirSource(article.text.location),
                      readerControl = list(language = 'lat'))
summary(atc.corpus)
#         Length Class             Mode
#8024.txt 2      PlainTextDocument list
#8032.txt 2      PlainTextDocument list
#8035.txt 2      PlainTextDocument list


# 말뭉치의 구성 및 내용 확인하기
summary(atc.corpus[[1]]$content)
#Length Class     Mode
#     4 character character

(atc.corpus[[1]]$content)[[1]]
#[1] "신종 코로나 바이러스 감염증 3번째 확진자가 발생했습니다."

summary(atc.corpus[[2]]$content)
#Length Class     Mode
#    14 character character

(atc.corpus[[2]]$content)[[1]]
#[1] "문재인 대통령은 29일 오후 2시부터 3시 20분까지 청와대 영빈관에서 준장 진급자 77명에게 장군의 상징인 삼정검을 직접 수여하고, 환담을 가졌습니다. "

summary(atc.corpus[[3]]$content)
#Length Class     Mode
#    20 character character

(atc.corpus[[3]]$content)[[1]]
#[1] "오늘 회의는 신종 코로나바이러스 감염증에 대한 대책들을 종합적으로 점검하고 논의하기 위해 소집했습니다. 시?도지사님들도 화상 연결로 참석했습니다. 감사합니다."


# 정규표현식을 이용한 일정한 패턴의 단어 찾기
pattern1 <- gregexpr("[[:alpha:]]+\\?", (atc.corpus[[3]]$content)[[1]])
pattern1
#[[1]]
#[1] 59
#attr(,"match.length")
#[1] 2

regmatches((atc.corpus[[3]]$content)[[1]], pattern1)
#[[1]]
#[1] "시?"

pattern2 <- gregexpr("대통령은+[[:space:]]", (atc.corpus[[2]]$content)[[1]])
pattern2
#[[1]]
#[1] 5
#attr(,"match.length")
#[1] 5

regmatches((atc.corpus[[2]]$content)[[1]], pattern2)
#[[1]]
#[1] "대통령은 "


# 데이터 전처리 함수 생성하기
preprocess_corpus_kor <- function(corpus) {
  require(tm)
  require(stringr)
  # 숫자 표현 삭제
  corpus <- tm_map(corpus, removeNumbers)
  # 문장부호 및 구두점 제거
  corpus <- tm_map(corpus, removePunctuation)
  # 특정패턴문자 변경하기
  corpus <- tm_map(corpus, content_transformer(str_replace_all),
                   pattern = "\\?", replacement = "")
  corpus <- tm_map(corpus, content_transformer(str_replace_all),
                   pattern = "“", replacement = "")
  corpus <- tm_map(corpus, content_transformer(str_replace_all),
                   pattern = "”", replacement = "")
  corpus <- tm_map(corpus, content_transformer(str_replace_all),
                   pattern = "문+[[:space:]]", replacement = "문재인 ")
  corpus <- tm_map(corpus, content_transformer(str_replace_all),
                   pattern = "대통령의+[[:space:]]", replacement = "대통령 ")
  # 공란 처리
  corpus <- tm_map(corpus, stripWhitespace)
  return(corpus)
}


# preprocess_corpus_kor() 함수를 이용해 데이터 전처리 수행하기
corpus <- preprocess_corpus_kor(atc.corpus)
summary(corpus)
#         Length Class             Mode
#8024.txt 2      PlainTextDocument list
#8032.txt 2      PlainTextDocument list
#8035.txt 2      PlainTextDocument list

(corpus[[1]]$content)[[1]]
#[1] "신종 코로나 바이러스 감염증 번째 확진자가 발생했습니다"

(corpus[[2]]$content)[[1]]
#[1] "문재인 대통령은 일 오후 시부터 시 분까지 청와대 영빈관에서 준장 진급자 명에게 장군의 상징인 삼정검을 직접 수여하고 환담을 가졌습니다 "

(corpus[[3]]$content)[[1]]
#[1] "오늘 회의는 신종 코로나바이러스 감염증에 대한 대책들을 종합적으로 점검하고 논의하기 위해 소집했습니다 시도지사님들도 화상 연결로 참석했습니다 감사합니다"


# 말뭉치에서 명사를 추출하여 문서로 저장하기
require(stringr)
require(KoNLP)
idx <- c(8024, 8032, 8035)
for (i in 1:length(corpus)) {
  doc <- corpus[[i]]$content
  none <- sapply(doc, extractNoun, USE.NAMES = F)
  # 2자 이상인 한글 단어만을 선택하기
  tran <- sapply(none,
                   function(x) {
                     Filter(function(y) { nchar(y) >= 2 && is.hangul(y) }
                           , x) })
  # 문서의 문장별로 2자 이상인 한글 단어만을 선택하여 문장으로 변환하기
  doc.none <- unlist(tran)
  # 문서의 단락들을 병합하기
  doc.none.doc <- NULL
  for (j in 1:length(doc.none)) {
     doc.none.doc <- paste(doc.none.doc, doc.none[j], sep = " ")
  }

  # 파일명 설정
  f.name <- idx[i]
  f.name <- paste(f.name, ".txt", sep = "")
  # tm/articles/corpus/8024.txt, 8032.txt, 8035.txt 저장하기
  write.table(doc.none.doc,
              file.path("tm/articles/corpus", f.name),
              row.names = FALSE,
              col.names = FALSE)
}


# 명사 추출된 말뭉치 읽어오기
require(tm)
require(stringr)
article.text.location <- paste(getwd(), "/tm/articles/corpus", sep = "")
atc.corpus <- VCorpus(DirSource(article.text.location),
                      readerControl = list(language = 'lat'))
summary(atc.corpus)
#         Length Class             Mode
#8024.txt 2      PlainTextDocument list
#8032.txt 2      PlainTextDocument list
#8035.txt 2      PlainTextDocument list


# 말뭉치 구성 및 내용 확인하기
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


# 대통령 연설문(8024.txt) 데이터 정규화 작업 수행하기
doc8024 <- readLines(file.path("tm/articles/corpus", "8024.txt"))
summary(doc8024)
#Length     Class      Mode 
#     1 character character 

doc8024
#[1] "신종 바이러스 감염증 번째 확진자 발생했습니 중국 여행객 방문 재인 귀국자 때문 정부 연휴 기간 긴장 시간 대응 체계 가동 있습니 질병 관리 본부장 국립 중앙 의료원 장에 전화 격려 당부 말씀 드렸습니 정부 지자체 단위 필요 노력 국민 정부 필요 조치 과도 불안 당부 드립"

doc8024 <- str_replace_all(doc8024,
                           pattern = "신종+[[:space:]]+바이러스",
                           replacement = "코로나일구")
doc8024 <- str_replace_all(doc8024,
                           pattern = "질병+[[:space:]]+관리+[[:space:]]+본부장",
                           replacement = "질병관리본부장")
doc8024 <- str_replace_all(doc8024,
                           pattern = "국립+[[:space:]]+중앙+[[:space:]]+의료원+[[:space:]]+장에",
                           replacement = "국립중앙의료원장")
write.table(doc8024, file.path("tm/articles/corpus", "8024.txt"),
            row.names = FALSE, col.names = FALSE)


# 대통령 연설문(8032.txt) 데이터 정규화 작업 수행하기
doc8032 <- readLines(file.path("tm/articles/corpus", "8032.txt"))
summary(doc8032)
#Length     Class      Mode 
#     1 character character 

doc8032
#[1] "문재인 대통령 오후 청와대 영빈관 준장 진급 장군 상징 삼정 환담 가졌습니 문재인 대통령 환담 모두 발언 과거 대장 진급 자와 일부 중장진급 수치 방식 대통령 삼정 우리 정부 장성 진급 대통령 무관 선택 노력 명예 뿌듯 때문 대통령 축하 말했습니 통수권자 대통령 준장 진급 삼정 문재인 정부 시도 군인 장성 진급 의미 문재인 대통령 생각 시작됐습니 문재인 대통령 사관생도 학군 후보생 시절 장교 계급장 마음가짐 자세 가슴 초심 만한 비결 진급 격려했습니 문재인 대통령 오늘 삼정 수여식 장군 진급 자분 대한민국 축하 축하 가족 해당 가족 헌신 희생 자리 진급 자분 오늘 가족 참석자 박수 받았습니 문재인 대통령 안보 우리 사회 소중 통솔하 수장 장군 우리 사회 시각 국가 대한민국 비전 가져달라고 당부했습니 환담 문재인 대통령 장군 진급 혁신 포용 공정 평화 자주국방 다섯 가지 비전 강조했습니 문재인 대통령 대한민국 나라 혁신 무기 체계 전략 전술 군사 관리 국방 개혁 대한민국 혁신 말했습니 문재인 대통령 군내 양성평등 실현 장병 복지 개선 포용적 부분 입대 보직 인사 휴가 때문 공정 지적했습니 문재인 대통령 도발 강력 국방력 평화 평화 중심 주체 강조했습니 문재인 대통령 마지막 우리 국방 전시작 전권 우리 환수 여러 자주국방 전작 실현 주역 말했습니 문재인 대통령 환담 마무리 발언 정경 국방부 장관 부탁했습니 정경 장관 평화 국민 신뢰 미래 준비 다짐했습니 오늘 삼정 수여식 행사 참석자 행사장 입구 신종 코로나 바이러스 감염증 관련 체온 체크 소독 입장했습니"

doc8032 <- str_replace_all(doc8032,
                           pattern = "전시작+[[:space:]]+전권",
                           replacement = "전시작전권")
doc8032 <- str_replace_all(doc8032,
                           pattern = "[[:space:]]+전작+[[:space:]]",
                           replacement = " 전시작전권 ")
doc8032 <- str_replace_all(doc8032,
                           pattern = "신종+[[:space:]]+코로나+[[:space:]]+바이러스",
                           replacement = " 코로나일구 ")
write.table(doc8032, file.path("tm/articles/corpus", "8032.txt"),
            row.names = FALSE, col.names = FALSE)


# 대통령 연설문(8035.txt) 데이터 정규화 작업 수행하기
doc8035 <- readLines(file.path("tm/articles/corpus", "8035.txt"))
summary(doc8035)
#Length Class     Mode
#     1 character character

doc8035
#[1] "오늘 회의 신종 코로나 바이러스 감염증 대책 종합적 점검 논의 하기 소집 시도지사 화상 연결 참석 감사 감염 확산 민생 경제 영향 최소화 하기 중앙정부 지자체 소통 협력 화해 오늘 중국 우한 고립 우리 교민 귀국 시작 실제 도착 내일 협조 항공 승무원 우리 국민 어디 국민 생명 안전 국가 당연 책무 현지 교민 가운데 감염증 확진자 의심 환자 파악 교민 중국 정부 협의 검역 증상 경우 임시 항공편 탑승 귀국 일정 기간 외부 격리 별도 시설 생활 검사 귀국 교민 안전 완벽 차단 지역사회 감염 예방 하기 조치 정부 임시 생활 시설 운영 지역 주민 불안 이해 대책 걱정 하시 정부 관리 이해 협조 당부 불안 약속 드립 중국 교민 중국당국 협력 나가겠습니 국민 안전 타협 상황 대비 필요 조치 예방조치 만큼 강력 정부 지자체 대응 역량 최대한 감염 방지 총력 시행 우한 지역 입국자 전수조사 진행 경과 결과 투명 연락 자진 당부 증상 확진 환자 접촉 모니터링 관리 체계 강화 필요 지역의료 기관 진료 신고 체계 점검 확산 대비 지역별 선별 진료소 격리 병상 확충 필요 인력과 물품 확보 속도 중국 나라 확진 환자 발생 때문 바이러스 유입 경로 다양 경우 대비 공항 항만 검역 강화 조치 강구 우리 바이러스 과도 불안감 막연 공포 단호 정부 정확 정보 신속 제공 국민 일상 생활 위축 불필요 오해 억측 필요 정보 투명 신속 국민 시각 상세 공개 하기 가짜 뉴스 엄정 대응 강조 우수 방역 체계 신뢰 작동 하기 확산 신종 감염 범국가적 역량 불신 불안 조장 가짜 뉴스 생산 유포 방역 방해 국민 안전 저해 중대 범죄행위 관계 부처 표현 자유 가짜 뉴스 각별 경각심 단호 대처 언론 역할 중요 신종 코로나 극복 정치권 문제 정쟁 자제 주시 요청 우려 부분 과도 경제 심리 위축 불안감 때문 정상적 경제 활동 영향 경제부총리 중심 부처 경제 상황 관리 기해 당부 국내외 금융시장 불안 수출 투자 소비 우리 경제 영향 종합적 점검 대책 필요 지역경제 관광 숙박 서비스업종 어려움 지자체 지역별 업종 파급효과 행정적 재정적 지원 필요 부분 신속 충분 규모 지원 대책 마련 해주 중국 신종 상황 진정 현지 진출 우리 기업 어려움 예상 관계기관 현지 기업 경제 단체 소통 채널 최소화 적극 지원 국민 여러분 당부 드리겠습니 신종 코로나 우리 자신 무기 공포 혐오 신뢰 협력 우리 세계 최고 수준 방역 역량 과거 사례 축적 경험 정부 최선 국민 지역사회 협력 극복 있습니 정부 지자체 정부 국민 개개인 예방 행동 수칙 우리 신종 피해 최소화 우리 국민 성숙 역량 정부 최선 다하겠습니"

doc8035 <- str_replace_all(doc8035,
                           pattern = "신종+[[:space:]]+코로나+[[:space:]]+바이러스",
                           replacement = " 코로나일구 ")
doc8035 <- str_replace_all(doc8035,
                           pattern = "[[:space:]]+바이러스+[[:space:]]",
                           replacement = " 코로나일구 ")
doc8035 <- str_replace_all(doc8035,
                           pattern = "[[:space:]]+코로나+[[:space:]]",
                           replacement = " 코로나일구 ")
write.table(doc8035, file.path("tm/articles/corpus", "8035.txt"),
            row.names = FALSE, col.names = FALSE)


# 데이터 전처리된 말뭉치 읽어오기
require(tm)
require(stringr)
article.text.location <- paste(getwd(), "/tm/articles/corpus", sep = "")
atc.corpus <- VCorpus(DirSource(article.text.location),
                      readerControl = list(language = 'lat'))
summary(atc.corpus)
#         Length Class             Mode
#8024.txt 2      PlainTextDocument list
#8032.txt 2      PlainTextDocument list
#8035.txt 2      PlainTextDocument list

(atc.corpus[[1]]$content)[[1]]
#[1] "신종 바이러스 감염증 번째 확진자 발생했습니 중국 여행객 방문 재인 귀국자 때문 정부 연휴 기간 긴장 시간 대응 체계 가동 있습니 질병 관리 본부장 국립 중앙 의료원 장에 전화 격려 당부 말씀 드렸습니 정부 지자체 단위 필요 노력 국민 정부 필요 조치 과도 불안 당부 드립"

(atc.corpus[[2]]$content)[[1]]
#[1] "문재인 대통령 오후 청와대 영빈관 준장 진급 장군 상징 삼정 환담 가졌습니 문재인 대통령 환담 모두 발언 과거 대장 진급 자와 일부 중장진급 수치 방식 대통령 삼정 우리 정부 장성 진급 대통령 무관 선택 노력 명예 뿌듯 때문 대통령 축하 말했습니 통수권자 대통령 준장 진급 삼정 문재인 정부 시도 군인 장성 진급 의미 문재인 대통령 생각 시작됐습니 문재인 대통령 사관생도 학군 후보생 시절 장교 계급장 마음가짐 자세 가슴 초심 만한 비결 진급 격려했습니 문재인 대통령 오늘 삼정 수여식 장군 진급 자분 대한민국 축하 축하 가족 해당 가족 헌신 희생 자리 진급 자분 오늘 가족 참석자 박수 받았습니 문재인 대통령 안보 우리 사회 소중 통솔하 수장 장군 우리 사회 시각 국가 대한민국 비전 가져달라고 당부했습니 환담 문재인 대통령 장군 진급 혁신 포용 공정 평화 자주국방 다섯 가지 비전 강조했습니 문재인 대통령 대한민국 나라 혁신 무기 체계 전략 전술 군사 관리 국방 개혁 대한민국 혁신 말했습니 문재인 대통령 군내 양성평등 실현 장병 복지 개선 포용적 부분 입대 보직 인사 휴가 때문 공정 지적했습니 문재인 대통령 도발 강력 국방력 평화 평화 중심 주체 강조했습니 문재인 대통령 마지막 우리 국방 전시작 전권 우리 환수 여러 자주국방 전작 실현 주역 말했습니 문재인 대통령 환담 마무리 발언 정경 국방부 장관 부탁했습니 정경 장관 평화 국민 신뢰 미래 준비 다짐했습니 오늘 삼정 수여식 행사 참석자 행사장 입구 신종 코로나 바이러스 감염증 관련 체온 체크 소독 입장했습니"

(atc.corpus[[3]]$content)[[1]]
#[1] "오늘 회의 신종 코로나 바이러스 감염증 대책 종합적 점검 논의 하기 소집 시도지사 화상 연결 참석 감사 감염 확산 민생 경제 영향 최소화 하기 중앙정부 지자체 소통 협력 화해 오늘 중국 우한 고립 우리 교민 귀국 시작 실제 도착 내일 협조 항공 승무원 우리 국민 어디 국민 생명 안전 국가 당연 책무 현지 교민 가운데 감염증 확진자 의심 환자 파악 교민 중국 정부 협의 검역 증상 경우 임시 항공편 탑승 귀국 일정 기간 외부 격리 별도 시설 생활 검사 귀국 교민 안전 완벽 차단 지역사회 감염 예방 하기 조치 정부 임시 생활 시설 운영 지역 주민 불안 이해 대책 걱정 하시 정부 관리 이해 협조 당부 불안 약속 드립 중국 교민 중국당국 협력 나가겠습니 국민 안전 타협 상황 대비 필요 조치 예방조치 만큼 강력 정부 지자체 대응 역량 최대한 감염 방지 총력 시행 우한 지역 입국자 전수조사 진행 경과 결과 투명 연락 자진 당부 증상 확진 환자 접촉 모니터링 관리 체계 강화 필요 지역의료 기관 진료 신고 체계 점검 확산 대비 지역별 선별 진료소 격리 병상 확충 필요 인력과 물품 확보 속도 중국 나라 확진 환자 발생 때문 바이러스 유입 경로 다양 경우 대비 공항 항만 검역 강화 조치 강구 우리 바이러스 과도 불안감 막연 공포 단호 정부 정확 정보 신속 제공 국민 일상 생활 위축 불필요 오해 억측 필요 정보 투명 신속 국민 시각 상세 공개 하기 가짜 뉴스 엄정 대응 강조 우수 방역 체계 신뢰 작동 하기 확산 신종 감염 범국가적 역량 불신 불안 조장 가짜 뉴스 생산 유포 방역 방해 국민 안전 저해 중대 범죄행위 관계 부처 표현 자유 가짜 뉴스 각별 경각심 단호 대처 언론 역할 중요 신종 코로나 극복 정치권 문제 정쟁 자제 주시 요청 우려 부분 과도 경제 심리 위축 불안감 때문 정상적 경제 활동 영향 경제부총리 중심 부처 경제 상황 관리 기해 당부 국내외 금융시장 불안 수출 투자 소비 우리 경제 영향 종합적 점검 대책 필요 지역경제 관광 숙박 서비스업종 어려움 지자체 지역별 업종 파급효과 행정적 재정적 지원 필요 부분 신속 충분 규모 지원 대책 마련 해주 중국 신종 상황 진정 현지 진출 우리 기업 어려움 예상 관계기관 현지 기업 경제 단체 소통 채널 최소화 적극 지원 국민 여러분 당부 드리겠습니 신종 코로나 우리 자신 무기 공포 혐오 신뢰 협력 우리 세계 최고 수준 방역 역량 과거 사례 축적 경험 정부 최선 국민 지역사회 협력 극복 있습니 정부 지자체 정부 국민 개개인 예방 행동 수칙 우리 신종 피해 최소화 우리 국민 성숙 역량 정부 최선 다하겠습니"


# corpus_dfm() 함수를 이용해 말뭉치의 단어 빈도 생성 및 시각화
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

library(tidyverse)
theme_set(theme_bw(base_family = "AppleGothic"))
ggplot(corpus.dfm %>% filter(num > 2), aes(reorder(term, num), num)) +
  geom_bar(stat = "identity", width = 0.5, fill = "tomato2") +
  coord_flip() +
  theme(axis.text.x = element_text(angle = 65, vjust = 0.6))


