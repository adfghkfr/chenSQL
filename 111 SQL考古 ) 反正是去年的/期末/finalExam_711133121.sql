/*
【開課科系】臺北大學統計系所
【授課老師】陳祥輝
【email】HsiangHui.Chen@gmail.com

111學年度第二學期 資料庫應用與商業智慧分析 課程 期末考試 老師：陳祥輝

學生學號：711133121
學生姓名：陳琬淇
電腦名稱：1MF08-42

注意事項：
1.請先將此檔案更改名稱為 : finalExam_+學號：，例如：finalExam_12345678.sql
2.切勿複製上課程式進行修改，一旦發現視同作弊論，會倒扣該題分數
3.每一題只能有一個答案，切勿將過程留在考題上，否則只會以第一個來評分
4.以下請用CH07範例資料庫，除非有特別指定
5.輸出屬性名稱前若是有 * 代表是 別名 或 衍生 屬性
6.請盡量達成使命, 請依循步驟讓你(妳)的語法是可以執行的。
7.不可執行的程式以0分計，可執行的程式才有可能部份會全部的分數，若是多個資料表必須完成join後才有部份分數。
8.給分標準，會因為每一題的重點不同，會有所差異
9.難易度僅供參考，會因個人而異
10.手機請收起來
11.不可以使用ChatGPT
*/

use CH07範例資料庫;

/*01【難易度 : ★☆☆☆☆】10%
請各別找出男、女員工，年齡大於等於該性別的平均年齡資料
[輸出](性別, 員工編號, 姓名, *年齡, *平均年齡)
[排序]性別遞增、年齡遞減
*/
--【Solution】
select distinct 性別, 員工編號, 姓名
	 , datediff(year, e.出生日期, getdate()) as 年齡
	 , (select avg(datediff(year, e.出生日期, getdate()))
		from 員工 as e
		where e.性別 = '男') as 平均年齡
from 員工 as e
where e.性別 = '男'
  and datediff(year, e.出生日期, getdate()) >= (select avg(datediff(year, e.出生日期, getdate()))
												from 員工 as e
												where e.性別 = '男')
union
select distinct 性別, 員工編號, 姓名
	 , datediff(year, e.出生日期, getdate()) as 年齡
	 , (select avg(datediff(year, e.出生日期, getdate()))
		from 員工 as e
		where e.性別 = '女') as 平均年齡
from 員工 as e
where e.性別 = '女'
  and datediff(year, e.出生日期, getdate()) >= (select avg(datediff(year, e.出生日期, getdate()))
												from 員工 as e
												where e.性別 = '女')
order by 性別 asc, 年齡 desc
go

/*02【難易度 : ★☆☆☆☆】10%
請查詢每一筆訂單的相關資料
[輸出](訂單編號, 訂貨日期, *總金額, *產品明細)
[排序]訂單編號 遞增排序
[輸出範例]

訂單編號		訂貨日期		總金額	產品明細
94010104	2005-01-10	616		蘋果汁|汽水
94010105	2005-01-11	650		蘆筍汁|烏龍茶
94010201	2005-03-12	1205	蘋果汁|烏龍茶|咖啡
...

[提示]
產品明細 : 可以使用 string_agg() 函數，請自行上網查詢
*/
--【Solution】
select o.訂單編號, 訂貨日期
	 , sum(od.實際單價*od.數量) as 總金額
	 , string_agg(產品名稱,'|') as 產品明細
from 訂單 as o, 訂單明細 as od, 產品資料 as p, 產品類別 as pd
where o.訂單編號 = od.訂單編號
  and od.產品編號 = p.產品編號
  and p.類別編號 = pd.類別編號
group by o.訂單編號, 訂貨日期
go


/*03【難易度 : ★☆☆☆☆】10%
請列出 銷售數量 最高的前五名(同名要並列出來)，並給予排名，銷售數量最高的為第1名
[輸出](類別編號, 類別名稱, 產品編號, 產品名稱, *銷售數量, *排名)
[說明]
1.排名函數使用 rank()
*/
--【Solution】
select 類別編號, 類別名稱, 產品編號, 產品名稱, 銷售數量, d.r as 排名
from(
select p.類別編號, 類別名稱, p.產品編號, 產品名稱
	 , o.數量 as 銷售數量
	 , rank() over (order by o.數量 desc) as r
from 產品類別 as pd, 產品資料 as p, 訂單明細 as o
where pd.類別編號 = p.類別編號
  and p.產品編號 = o.產品編號
) as d
where r <= 5
go

/*04【難易度 : ★☆☆☆☆】10%
請依據年資，統計本公司員工 資淺、資深、待退 三種資歷的員工人數
[輸出](*資歷, *人數)
[排序]依據人數遞減排序
[說明]依據年資的資歷分為以下三種 : 
1.資淺 : 年資小於15年
2.資深 : 年資大於等於15年, 且小於30年
3.待退 : 年資大於等於30年
*/
--【Solution】
select ee.資歷 , count(1) as 人數
from(
select e.員工編號
	 , case
		when datediff(year, e.任用日期, getdate())<=15 then '資淺'
		when datediff(year, e.任用日期, getdate())<=30 then '資深'
		else '待退'
	   end as 資歷
from 員工 as e
) as ee
group by ee.資歷
go

/*05【難易度 : ★☆☆☆☆】10%
由於時間的改變，人員的進出，每年都要請計算本公司男、女員工年齡的分佈狀況
[輸出](*年齡區間, 姓別, *人數)
[排序]年齡區間 遞增, 性別 遞增
[說明]
年齡 : 粗估即可，不用精算
年齡區間 : 
0-9歲
10-19歲
20-29歲
....
*/
--【Solution】
select 年齡區間, 性別
	 , count(1) as 人數
from(
select e.員工編號, e.性別, e.出生日期
	 , datediff(year, e.出生日期, getdate()) as 年齡
	 , cast((datediff(year, e.出生日期, getdate())/10)*10 as varchar)+'-'
	   +cast((datediff(year, e.出生日期, getdate())/10)*10+10 as varchar)+'歲' as 年齡區間
from 員工 as e)as eee
group by 年齡區間, 性別
order by 年齡區間 asc, 性別 asc
go

/*06【難易度 : ★☆☆☆☆】10%
公司老闆要東西總是特別趕!! 偏偏資料庫同時有很多人使用，會造成等待等待等待，為了避免等待浪費時間
你該如何撰寫以下的 SQL 語法?
老闆想要 2005 年銷售最好的產品資料
[輸出](p.產品編號, p.產品名稱, c.類別名稱)
[提示]dirty read
*/
--【Solution】
set transaction isolation level read uncommitted;

select pp.產品編號, pp.產品名稱, pp.類別名稱
from(
select p.產品編號, p.產品名稱, pd.類別名稱
	 , rank() over (order by od.數量 desc) as r
from 訂單 as o, 訂單明細 as od, 產品資料 as p, 產品類別 as pd
where o.訂單編號 = od.訂單編號
  and od.產品編號 = p.產品編號
  and p.類別編號 = pd.類別編號
  and year(o.訂貨日期) = 2005
) as pp
where r <= 1
go

--以下07、08可以是兩題獨立無關的題目，非連鎖題

/*07【難易度 : ★★★☆☆】80/20法則 10%
依據80/20法則，使用SQL來查詢銷售總金額貢獻度累計至80%，有哪些產品? 
[輸出](產品名稱, *貢獻度累計)
[排序]貢獻度累計 遞增
[說明]截至80%之前(含)的產品，之後的產品不用顯示
*/
--【Solution】
select 產品名稱
	 , sum(實際單價*數量)*1.0/(select sum(實際單價*數量)*1.0
								from 訂單明細 as od) as 貢獻度累計
from 訂單明細 as o, 產品資料 as p
where o.產品編號 = p.產品編號
group by 產品名稱
order by 貢獻度累計 desc
go



/*08【難易度 : ★☆☆☆☆】80/20法則 10%
依據以上07題的說明，但要顯示出所有產品，改用Excel樞紐分析製作80/20法則來驗證，
此題只要繳交Excel檔案即可，檔名為 finalExam08_學號.xlsx
[說明]以下資訊必備
1. 請標示標題為 80/20法則--姓名
2. X標籤 : 產品名稱
3. Y標籤 : (主要軸)銷售金額
[提示]
可以先建立一個檢視表(view)，提供給Excel資料使用
[參考畫面]
http://10.137.110.61:8088/Images/80-20法則.JPG
*/
--【Solution】





go


/*09【難易度 : ★★★☆☆】20%
1.先將 D學生圖書借閱資料.txt 檔案匯入 CH07範例資料庫
2.事先將該資料表進行正規化後，將所有資料寫入對應的資料表內。
3.請建置一個資料庫圖表(ERD)，手動設定每一個資料表的Primary Key，並建立彼此的關聯
4.拍照存檔ER Model成 finalExam09_學號.jpg，一併繳交，未交視同此題零分
*/
--【Solution】





go


----------!----------!----------!----------!----------!----------!----------!----------!----------!----------
/*
我有話要說..........
【請說】




*/







