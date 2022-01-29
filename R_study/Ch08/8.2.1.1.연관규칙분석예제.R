
# arules 패키지와 Epub 데이터 읽어오기
library(arules)
data("Epub")
summary(Epub)
#transactions as itemMatrix in sparse format with
#15729 rows (elements/itemsets/transactions) and
#936 columns (items) and a density of 0.001758755 
#
#most frequent items:
#  doc_11d doc_813 doc_4c6 doc_955 doc_698 (Other) 
#      356     329     288     282     245   24393 
#
#element (itemset/transaction) length distribution:
#  sizes
#    1     2     3     4     5     6     7     8     9    10    11    12    13    14    15    16    17 
#11615  2189   854   409   198   121    93    50    42    34    26    12    10    10     6     8     6 
#18    19    20    21    22    23    24    25    26    27    28    30    34    36    38    41    43 
# 5     8     2     2     3     2     3     4     5     1     1     1     2     1     2     1     1 
#52    58 
# 1     1 
#
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#1.000   1.000   1.000   1.646   2.000  58.000 
#
#includes extended item information - examples:
#  labels
#1 doc_11d
#2 doc_13d
#3 doc_14c
#
#includes extended transaction information - examples:
#      transactionID           TimeStamp
#10792  session_4795 2003-01-02 10:59:00
#10793  session_4797 2003-01-02 21:46:01
#10794  session_479a 2003-01-03 00:50:38


# inspect() 함수로 거래 데이터 10개만 출력하기
inspect(Epub[1:10])
#     items                    transactionID TimeStamp          
#[1]  {doc_154}                session_4795  2003-01-02 10:59:00
#[2]  {doc_3d6}                session_4797  2003-01-02 21:46:01
#[3]  {doc_16f}                session_479a  2003-01-03 00:50:38
#[4]  {doc_11d,doc_1a7,doc_f4} session_47b7  2003-01-03 08:55:50
#[5]  {doc_83}                 session_47bb  2003-01-03 11:27:44
#[6]  {doc_11d}                session_47c2  2003-01-04 00:18:04
#[7]  {doc_368}                session_47cb  2003-01-04 04:40:57
#[8]  {doc_11d,doc_192}        session_47d8  2003-01-04 09:00:01
#[9]  {doc_364}                session_47e2  2003-01-05 02:48:36
#[10] {doc_ec}                 session_47e7  2003-01-05 05:58:48


# itemFrequency() 함수를 이용해 10개 품목(Item)이 차지하는 비율 확인하기
itemFrequency(Epub[, 1:10])
#     doc_11d      doc_13d      doc_14c      doc_14e      doc_150      doc_151      doc_153      doc_154 
#0.0226333524 0.0009536525 0.0024794965 0.0017801513 0.0015894208 0.0007629220 0.0006357683 0.0013351135 
#     doc_155      doc_156 
#0.0010808062 0.0031152648 


# itemFrequency() 함수를 이용해 지지도(Support) 1% 이상의 품목에 대해 막대 그래프 그리기
itemFrequencyPlot(Epub, support = 0.01,
                  main = "Item frequency plot above support 1%")


# itemFrequency() 함수를 이용해 지지도(Support) 상위 20개 품목에 대해 막대 그래프 그리기
itemFrequencyPlot(Epub, topN = 20, main = "support top 20 items")


# 최소지지도 기준을 0.001로 연관규칙분석 수행하기
Epub.rules <- apriori(data = Epub,
                      parameter = list(support = 0.001, confidence = 0.20, minlen = 2))
#Apriori
#
#Parameter specification:
# confidence minval smax arem  aval originalSupport maxtime support minlen maxlen target   ext
#        0.2    0.1    1 none FALSE            TRUE       5   0.001      2     10  rules FALSE
#
#Algorithmic control:
# filter tree heap memopt load sort verbose
#    0.1 TRUE TRUE  FALSE TRUE    2    TRUE
#
#Absolute minimum support count: 15 
#
#set item appearances ...[0 item(s)] done [0.00s].
#set transactions ...[936 item(s), 15729 transaction(s)] done [0.01s].
#sorting and recoding items ... [481 item(s)] done [0.00s].
#creating transaction tree ... done [0.00s].
#checking subsets of size 1 2 3 done [0.00s].
#writing ... [65 rule(s)] done [0.00s].
#creating S4 object  ... done [0.00s].


# 연관규칙분석 결과 요약하기
summary(Epub.rules)
#set of 65 rules
#
#rule length distribution (lhs + rhs):sizes
# 2  3 
#62  3 
#
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#2.000   2.000   2.000   2.046   2.000   3.000 
#
#summary of quality measures:
#   support           confidence          lift            count      
#Min.   :0.001017   Min.   :0.2048   Min.   : 11.19   Min.   :16.00  
#1st Qu.:0.001081   1st Qu.:0.2388   1st Qu.: 34.02   1st Qu.:17.00  
#Median :0.001208   Median :0.2874   Median : 59.47   Median :19.00  
#Mean   :0.001435   Mean   :0.3571   Mean   :105.16   Mean   :22.57  
#3rd Qu.:0.001526   3rd Qu.:0.3696   3rd Qu.:100.71   3rd Qu.:24.00  
#Max.   :0.004069   Max.   :0.8947   Max.   :454.75   Max.   :64.00  
#
#mining info:
# data ntransactions support confidence
# Epub         15729   0.001        0.2


# 향상도(Lift)를 기준으로 상위 10개 연관규칙을 정렬해 확인하기
inspect(sort(Epub.rules, by = "lift")[1:10])
#     lhs                  rhs       support     confidence lift     count
#[1]  {doc_6e7,doc_6e8} => {doc_6e9} 0.001080806 0.8095238  454.7500 17   
#[2]  {doc_6e7,doc_6e9} => {doc_6e8} 0.001080806 0.8500000  417.8016 17   
#[3]  {doc_6e8,doc_6e9} => {doc_6e7} 0.001080806 0.8947368  402.0947 17   
#[4]  {doc_6e9}         => {doc_6e8} 0.001207960 0.6785714  333.5391 19   
#[5]  {doc_6e8}         => {doc_6e9} 0.001207960 0.5937500  333.5391 19   
#[6]  {doc_6e9}         => {doc_6e7} 0.001271537 0.7142857  321.0000 20   
#[7]  {doc_6e7}         => {doc_6e9} 0.001271537 0.5714286  321.0000 20   
#[8]  {doc_506}         => {doc_507} 0.001207960 0.6551724  303.0943 19   
#[9]  {doc_507}         => {doc_506} 0.001207960 0.5588235  303.0943 19   
#[10] {doc_6e8}         => {doc_6e7} 0.001335113 0.6562500  294.9187 21   


# 도출된 연관규칙의 지지도(Support), 신뢰도(Confidence), 향상도(Lift)간의 산점도
library(arulesViz)
plot(Epub.rules)


# 연관규칙 1~10번째(10개 규칙) 만 선별해서 연관규칙 그래프 시각화하기
plot(Epub.rules[1:10], method = "graph", control = list(type = "items"),
     vertex.label.cex = 0.7, edge.arrow.size = 0.3, edge.arrow.width = 2)


