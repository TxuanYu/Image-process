Question : 
---

令V={20,85,150,255}與U={0,100,155,250}是連結性的灰階值集合。<br>
分別對Adj1_1.bmp 和Adj1_2.bmp計算4-adjacency和8-adjacency。<br>
找出並標示連通元件後：<br>
* 對Adj1_1.bmp<br>
  * 對於V集合的定義下: <br>
    使用labeling of connected component技術，將不相同的連通元件標記上不相同之label，並使用不同灰階強度值(單通道)來表示不同的label。<br>
  * 對於U集合的定義下:<br>
	  將U集合內之連通元件用強度值0表示。<br>
* 對Adj1_2.bmp<br>
	重複第一題之動作，並改採用不同顏色(三通道)去表示不同的label 。<br>

## Answer : 
執行problem1.m

第5行 problem = problem_1 表第一小題
problem = problem_2 表第二小題

成果展現於answer.pdf
