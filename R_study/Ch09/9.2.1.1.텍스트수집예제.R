
# 브리핑 텍스트(.txt) 파일을 읽어 들여서 말뭉치(Corpus) 생성하기
library(tm)
briefing.text.location <- paste(getwd(), "/tm/briefings/txt", sep = "")
brf.txt.corpus <- VCorpus(DirSource(briefing.text.location),
                          readerControl = list(language = 'lat'))
summary(brf.txt.corpus)
#        Length Class             Mode
#486.txt 2      PlainTextDocument list
#487.txt 2      PlainTextDocument list
#488.txt 2      PlainTextDocument list


# 브리핑 텍스트(.txt) 파일의 첫 번째 문서의 내용 확인하기
brf.txt.corpus[[1]]$content
#[1] "President Moon Jae-in and Premier Li Keqiang of the People’s Republic of China held a meeting and attended a dinner in Chengdu, China, from 6:30 to 8:55 this evening (local time). The two leaders had in-depth discussions on issues of mutual concern, including ways to promote substantive bilateral cooperation in such areas as the economy, trade, the environment and culture."                                                                                                                                                                                             
#[2] "Premier Li began by saying that the relationship between the two countries has achieved rapid progress in terms of the economy and cultural and people-to-people exchanges. He went on to say that China considers its ties with Korea to be very important. He expressed the hope that bilateral relations would continue to advance, saying that this would carry great significance for the entire world. Moreover, he highly praised the development of bilateral ties by saying that the China-Korea cooperation mechanism had suffered a setback but is now on the right track."
# ... 
#[9] "In reply, President Moon remarked “When we met in December 2017, you said, ‘Winter Solstice is the day heralding that winter is about to end and spring is about to arrive.’ Yesterday was Winter Solstice. Going forward, I hope that our two countries’ relations can enter spring based upon the past 28 years of cooperation. "   


# 브리핑 텍스트(.txt) 파일의 첫 번째 문서의 메타 데이터 확인하기
brf.txt.corpus[[1]]$meta
#author : character(0)
#datetimestamp : 2020-02-04 02:18:23
#description : character(0)
#heading : character(0)
#id : 486.txt
#language : lat
#origin : character(0)

meta(brf.txt.corpus[[1]], tag = 'author') <- 'K. D. Jang'
brf.txt.corpus[[1]]$meta
#author : K. D. Jang
#datetimestamp : 2020-02-04 02:18:23
#description : character(0)
#heading : character(0)
#id : 486.txt
#language : lat
#origin : character(0)


# 브리핑 텍스트(.txt) 파일의 첫 번째 문서에 들어 있는 2개의 단락 출력하기
briefing486 <- Corpus(VectorSource(brf.txt.corpus[[1]]$content))
briefing486
#<<SimpleCorpus>>
#Metadata: corpus specific: 1, document level (indexed): 0
#Content: documents: 9

inspect(briefing486[1:2])
#<<SimpleCorpus>>
#Metadata: corpus specific: 1, document level (indexed): 0
#Content: documents: 2
#
#[1] On the sidelines of the 8th Korea-Japan-China ... 이하 생략
#[2] In regard to Japan<e2>\u0080 export control measures, ... 이하 생략


# 읽어 들이는 형식 확인하기
getReaders()
# [1] "readDataframe"           "readDOC"                 "readPDF"                
# [4] "readPlain"               "readRCV1"                "readRCV1asPlain"        
# [7] "readReut21578XML"        "readReut21578XMLasPlain" "readTagged"             
#[10] "readXML" 


# 브리핑 워드(.doc) 파일을 읽어 들여서 말뭉치(Corpus) 생성하기
library(antiword)
library(tm)
word.location <- paste(getwd(), "/tm/briefings/doc", sep = "")
word.briefing.corpus <- Corpus(DirSource(word.location),
                               readerControl = list(reader = readDOC, language = 'lat'))
summary(word.briefing.corpus)
#            Length Class             Mode
#486Word.doc 2      PlainTextDocument list
#487Word.doc 2      PlainTextDocument list
#488Word.doc 2      PlainTextDocument list


# 브리핑 워드(.doc) 파일의 첫 번째 문서에 들어 있는 1개의 단락 출력하기
briefing486 <- Corpus(VectorSource(word.briefing.corpus[[1]]$content))
briefing486
#<<SimpleCorpus>>
#Metadata:  corpus specific: 1, document level (indexed): 0
#Content:  documents: 1

inspect(briefing486[1])
#<<SimpleCorpus>>
#Metadata: corpus specific: 1, document level (indexed): 0
#Content: documents: 1
#[1] \r\nPresident Moon Jae-in and Premier Li Keqiang of the People's Republic of\r\nChina held
#a meeting and attended a dinner in Chengdu, China, from 6:30 to\r\n8:55 this evening (local time).
#The two leaders had in-depth discussions on\r\nissues of mutual concern, including ways to promote
#substantive bilateral\r\ncooperation in such areas as the economy, trade, the environment
#and\r\nculture.
#... 이하 생략


# 브리핑 PDF(.pdf) 파일을 읽어 들여서 말뭉치(Corpus) 생성하기
library(pdftools)
library(tm)
pdf.location <- paste(getwd(), "/tm/briefings/pdf", sep = "")
pdf.briefing.corpus <- Corpus(DirSource(pdf.location),
                              readerControl = list(reader = readPDF, language = 'lat'))
summary(pdf.briefing.corpus)
#           Length Class             Mode
#486PDF.pdf 2      PlainTextDocument list
#487PDF.pdf 2      PlainTextDocument list
#488PDF.pdf 2      PlainTextDocument list


# 브리핑 PDF(.pdf) 파일의 첫 번째 문서에 들어 있는 2개의 단락 출력하기
briefing486 <- Corpus(VectorSource(pdf.briefing.corpus[[1]]$content))
briefing486
#<<SimpleCorpus>>
#Metadata: corpus specific: 1, document level (indexed): 0
#Content: documents: 2

inspect(briefing486[1:2])
#<<SimpleCorpus>>
#Metadata: corpus specific: 1, document level (indexed): 0
#Content: documents: 2
#[1] President Moon Jae-in and Premier Li Keqiang of ... 이하 생략
#[2] the global economy a strong driving force. In reply, ... 이하 생략

