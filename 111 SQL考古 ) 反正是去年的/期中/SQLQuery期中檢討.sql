/*
【開課科系】臺北大學統計系所
【授課老師】陳祥輝
【email】HsiangHui.Chen@gmail.com

111學年度第二學期 資料庫應用與商業智慧分析 課程 期中考試 老師：陳祥輝

學生學號：711133121
學生姓名：陳琬淇
電腦名稱：1MF08-42

注意事項：
1.請先將此檔案更改名稱為 : midExam+學號：，例如：midExam12345678.sql
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

use ch07範例資料庫;

/*01【難易度 : ★☆☆☆☆】10%
請列出居住在 台北市、台中市、高雄市 的客戶，曾向本公司訂購過哪些不同的產品種類
[輸出](*居住縣市, 類別名稱, 產品名稱)
[排序]居住縣市 遞增, 類別名稱 遞減
[說明]
居住縣市 就是 地址前三個字
*/
--【Solution】
select distinct left(c.地址, 3) as 居住縣市, 類別名稱, 產品名稱
from 客戶 as c, 訂單 as o, 訂單明細 as od, 產品資料 as p, 產品類別 as pd
where c.客戶編號 = o.客戶編號
  and o.訂單編號 = od.訂單編號
  and od.產品編號 = p.產品編號
  and p.類別編號 = pd.類別編號
  and left(c.地址, 3) in ('台北市', '台中市', '高雄市')
order by 居住縣市 asc, 類別名稱 desc
go

/*02【難易度 : ★★★☆☆】10%
請列出本公司員工年齡最大的前2名以及最小的前2名，但是同年齡必須都列出
[輸出](員工編號, 姓名, 出生日期, *年齡)
[說明]
年齡 : 粗估即可，不必精算
[提示]
1.可以使用union
2.可以使用子查詢
3.可以使用rank() over ()
*/
--【Solution】
--【解一】
select 員工編號, 姓名, 出生日期
	 , datediff(year, e.出生日期, getdate()) as 年齡
from (select top 2 with ties 員工編號, 姓名, 出生日期
	  , datediff(year, e.出生日期, getdate()) as 年齡
	  from 員工 as e
	  order by 年齡 desc) as e
union
select 員工編號, 姓名, 出生日期
	 , datediff(year, e.出生日期, getdate()) as 年齡
from (select top 2 with ties 員工編號, 姓名, 出生日期
	  , datediff(year, e.出生日期, getdate()) as 年齡
	  from 員工 as e
	  order by 年齡 asc) as e
order by 年齡 desc
go
--【解二】
select 員工編號, 姓名, 出生日期
	 , datediff(year, e.出生日期, getdate()) as 年齡
from (select 員工編號, 姓名, 出生日期
	  , datediff(year, e.出生日期, getdate()) as 年齡
	  , rank() over (order by datediff(year, e.出生日期, getdate()) asc) as r1
      from 員工 as e) as e
where r1 <= 2
union
select 員工編號, 姓名, 出生日期
	 , datediff(year, e.出生日期, getdate()) as 年齡
from (select 員工編號, 姓名, 出生日期
	  , datediff(year, e.出生日期, getdate()) as 年齡
	  , rank() over (order by datediff(year, e.出生日期, getdate()) desc) as r2
      from 員工 as e) as e
where r2 <= 2
order by 年齡 desc
go

/*03【難易度 : ★★☆☆☆】10%
由於本公司近年來營運不好，必須進行人事調整
請產生一份報表資料
在本公司的年資大於(包含)25年以上，且2006年沒有承接任何訂單的資料
[輸出](員工編號, 姓名, 任用日期, *年資)
[排序]依據年資遞減排序, 員工編號遞增排序
[說明]
年資, 就是任用日期至今日的年數，必須精算到日期
*/
--【Solution】
select 員工編號, 姓名, 任用日期
	 , datediff(day, e.任用日期, getdate())/365 as 年資
	 --, datediff(year, e.任用日期, getdate()) - iif(month(getdate()) > month(e.任用日期)
	 --	 or month(getdate()) = month(e.任用日期) and day(getdate()) >= day(e.任用日期), 0, 1) as 年資
from 員工 as e
where e.員工編號 not in (select distinct o.員工編號
						 from 訂單 as o
						 where year(o.訂貨日期) = 2006)
  and datediff(year, e.任用日期, getdate()) - iif(month(getdate()) > month(e.任用日期)
	    or month(getdate()) = month(e.任用日期) and day(getdate()) >= day(e.任用日期), 0, 1) >= 25 
order by 年資 desc, 員工編號 asc
go

/*04【難易度 : ★☆☆☆☆】10%
請列出 陳祥輝, 劉嘉雯, 陳森耀 這三位主管有哪幾位直屬的部屬，無論有沒有部屬，都要列出來
[輸出](*上司編號, *上司姓名, *部屬編號, *部屬姓名)
[限制]outer join
*/
--【Solution】
select 上司.員工編號 as 上司編號, 上司.姓名 as 上司姓名
	 , 部屬.員工編號 as 部屬編號, 部屬.姓名 as 部屬姓名
from 員工 as 上司
	 left join 員工 as 部屬 on 上司.員工編號 = 部屬.主管
where 上司.姓名 in ('陳祥輝', '劉嘉雯', '陳森耀')
go

/*05【難易度 : ★☆☆☆☆】10%
請列出哪些訂單，銷售產品的 實際單價 低於 產品資料的 建議單價 九折 以下(含)
[輸出](員工編號,  *員工姓名, 客戶編號, *客戶名稱, 
       訂單編號, 產品名稱, 建議單價, 實際單價, *折數)
[排序]員工編號 遞增, 再依客戶編號 遞增
[說明]
1.折數 就是該產品打了幾折，取至小數以下 2 位，例如 : 0.83
*/
--【Solution】
select e.員工編號,  e.姓名 as 員工姓名, c.客戶編號, c.公司名稱 as 客戶名稱
	 , o.訂單編號, 產品名稱, 建議單價, 實際單價
	 , cast(cast(實際單價 as numeric(4, 2))/cast(建議單價 as numeric(4, 2))as numeric(4,2)) as 折數
	 --cast(實際單價*1.0/建議單價 as numeric(4,2)) as 折數
from 員工 as e, 訂單 as o, 訂單明細 as od, 產品資料 as p, 客戶 as c
where e.員工編號 = o.員工編號
  and o.訂單編號 = od.訂單編號
  and od.產品編號 = p.產品編號
  and c.客戶編號 = o.客戶編號
  and 實際單價 <= 建議單價 * 0.9
order by e.員工編號 asc, c.客戶編號 asc
go

/*06【難易度 : ★☆☆☆☆】10%
請查詢2005年的訂單，有哪些產品該年度都未銷售出去，這些產品是來自哪些供應商
[輸出](供應商編號, 供應商名稱)
[排序]供應商編號遞增
*/
--【Solution】
select distinct ca.供應商編號, 供應商名稱
from 供應商 as ca
	 left join 產品資料 as p on p.供應商編號 = ca.供應商編號
where p.產品編號 not in (select p.產品編號
						 from 訂單 as o, 訂單明細 as od, 產品資料 as p
						 where o.訂單編號 = od.訂單編號
						   and od.產品編號 = p.產品編號
						   and year(o.訂貨日期) = 2005)
go

/*07【難易度 : ★☆☆☆☆】10%
請依據 類別編號 各自 分開排名，依據 建議單價 高低排名，建議單價 高者為第 1 名
[輸出](類別編號, 類別名稱, 產品編號, 產品名稱, 建議單價, *單價排名)
[說明]
1.單價排名 是指 建議單價最貴的為第 1 名
2.單價排名的輸出格式必須是 '第001名', '第002名', '第003名', ...
*/
--【Solution】
select p.類別編號, 類別名稱, 產品編號, 產品名稱, 建議單價
	 , '第'+right('00'+cast(rank() over (partition by p.類別編號 order by 建議單價 desc)as varchar), 3)+'名' as 單價排名
	 --format(rank() over (partition by p.類別編號 order by 建議單價 desc), '第0##名') as 單價排名
from 產品資料 as p, 產品類別 as pd
where p.類別編號 = pd.類別編號
go





---★★★★★★【以下8, 9 兩題務必將SSMS全畫面(包含結果)拍照存檔一併上傳，沒有上傳結果，該題扣10分】★★★★★★





/*08【難易度 : ★★☆☆☆】15%
請依據以下的步驟完成此題
1. 將 diabetes.csv(糖尿病資料集) 匯入你(妳)自己的 CH07範例資料庫, 
   資料表名稱為 diabetes (0%)
2. 為了追蹤 50歲以上(包含)沒有患糖尿病 的高風險群，
   請挑選出"結果"是陰性(0)"血糖"指數, 高於(大於等於)"結果"為陽性(1)患者的平均"血糖"，
   這些族群的相關資料 (10%)
[輸出](年齡, 血糖, 血壓, BMI, 結果, *患糖尿病人的平均血糖)
[排序]年齡遞減排序, 血糖遞減排序
[說明]
1.患糖尿病人的平均血糖 : 就是"結果"為陽性(1)的平均"血糖"
2.患糖尿病人的平均血糖，必須取小數以下2位 (例如 141.26)
3.資料匯入 : 【CH07範例資料庫】按右鍵\【工作】\【使用匯入一般檔案】
  但是在匯入過程中，要注意以下欄位的資料型態

  懷孕 : tinyint
  血糖 : tinyint
  血壓 : tinyint
  皮膚厚度 : tinyint
  胰島素 : smallint
  BMI : numeric(10, 2)
  糖尿病譜系功能 : numeric(10, 2)
  年齡 : tinyint
  結果 : bit
【參考結果】http://10.137.110.61:8080/Images/diabetesResult.JPG
*/
--【Solution】
select 年齡, 血糖, 血壓, BMI, 結果
	 , (select cast(avg(cast(d.血糖 as numeric(5,2))) as numeric(5,2))
		from diabetes as d
		where d.結果 = '1') as 患糖尿病人的平均血糖
	 --(select cast(avg(d.血糖*1.0)as numeric(5,2))
	 -- from diabetes as d
	 -- where d.結果 = '1') as 患糖尿病人的平均血糖
from diabetes as d
where 年齡 >= 50
  and d.結果 = '0'
  and 血糖 > (select cast(avg(cast(d.血糖 as numeric(5,2))) as numeric(5,2))
				from diabetes as d
				where d.結果 = '1')
order by 年齡 desc, 血糖 desc
go

/*9【難易度 : ★★★☆☆】15%
請依據以下的步驟完成此題
1. 將 stock.csv(股市交易資料), company.csv(公司資料) 匯入你(妳)自己的 CH07範例資料庫, 
   資料表名稱分別為 stock, company (0%)。
2. 為了查看每日股價的漲幅，
   請挑選出以下的資料 (10%)
[輸出](交易日期, 股票號碼, *公司名稱, 開盤價, 收盤價, 調整收盤價, 最高價, 最低價, *基準價, *漲幅)
[排序]依據交易日期遞減, 股票號碼遞增
[說明]
1.基準價 : 是指前一天交易日的 調整後收盤價
2.漲幅 :　(今日收盤價－基準價)/基準價 : 只取至小數以下4位
3.資料匯入 : 【CH07範例資料庫】按右鍵\【工作】\【使用匯入一般檔案】
  但是在匯入過程中，要注意以下欄位的資料型態

   【company】
   公司代號 : varchar(10)
   公司簡稱 : nvarchar(50)

   【stock】
   股票號碼 : varchar(10)
   交易日期 : date
   開盤價 : numeric(10, 2)
   最高價 : numeric(10, 2)
   最低價 : numeric(10, 2)
   收盤價 : numeric(10, 2)
   調整收盤價 : numeric(10, 2)
   交易量 : int
[提示]
基準價 : 可以使用 lag(..., ..., ...) over (partition by ... order by ...) 自行研究使用方式
【解說參考】http://10.137.110.61:8080/Images/stock解說使用.JPG
【參考結果】http://10.137.110.61:8080/Images/stockResult.JPG
*/
select 交易日期, 股票號碼, 公司簡稱 as 公司名稱, 開盤價, 收盤價
	 , 調整收盤價, 最高價, 最低價
	 , lag(調整收盤價, 1, 0) over (partition by 公司簡稱 order by 交易日期)
	 --lag(調整收盤價, 1, Null) over (partition by 股票號碼 order by 交易日期)as 基準價
	 , cast(isnull((收盤價-(lag(調整收盤價, 1, 0) over (partition by 公司簡稱 order by 交易日期)))
			/nullif((lag(調整收盤價, 1, 0) over (partition by 公司簡稱 order by 交易日期)),0), 0)as numeric(6, 4))
			as 漲幅
	 --cast((收盤價-(lag(調整收盤價, 1, Null) over (partition by 公司簡稱 order by 交易日期)))/(lag(調整收盤價, 1, Null)
		 --over (partition by 公司簡稱 order by 交易日期)) as numeric (6, 4)) as 漲幅
from stock as s, company as co
where s.股票號碼 = co.公司代號 
order by 交易日期 desc, 股票號碼 asc
go
--【畫面上傳參考結果】http://10.137.110.61:8080/Images/繳交範例.JPG
