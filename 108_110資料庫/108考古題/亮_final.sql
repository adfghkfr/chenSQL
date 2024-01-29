/*
108學年度第一學期 臺北大學統計系與碩士班 資料庫應用與商業智慧分析 課程 期末考試 老師：陳祥輝 (HsiangHui.Chen@gmail.com)

學生學號：410678031	
學生姓名：吳品俞
電腦名稱：1MF10-38

注意事項：
1.請先將此檔案更改名稱為 : final+學號：，例如：final123456789.sql，旁聽者請填寫 final旁聽陳祥輝.sql
2.以下請用CH07範例資料庫，除非有特別指定
3.輸出屬性名稱前若是有 * 代表是 別名 或 衍生 屬性
4.請盡量達成使命, 請依循步驟讓你(妳)的語法是可以執行的。
5.不可執行的程式以0分計，可執行的程式才有可能部份會全部的分數，若是多個資料表必須完成join後才有部份分數。
6.給分標準，會因為每一題的重心不同，會有所差異
7.難易度僅供參考，會因個人而異
8.考試時間  18：10－21：00
*/

use ch07範例資料庫;

/*01【難易度 : ★☆☆☆☆】10%
由於公司年度要舉辦旅遊, 必須幫男, 女員工分別分配住宿房號, 男女分群各自依據年齡遞增排序來分群
由於本公司男生較多，所以分配三間，女生較少，所以分配兩間如下 : 
男生房號為 : A1, A2, A3
女生房號為 : B1, B2
[輸出](員工編號, 姓名, 性別, 年齡, *房號)
[排序]請先依據 性別 遞增，再依 年齡 遞增
[提示]使用ranking function中的ntile
*/
--【Solution】
select 員工編號, 姓名, 性別
	 , datediff(year, e.出生日期, getdate()) as 年齡 
	 , 'A' + cast(ntile(3) over (order by datediff(year, e.出生日期, getdate()) asc) as varchar) as 房號
from 員工 as e
where e.性別= '男'
union
select 員工編號, 姓名, 性別
	 , datediff(year, e.出生日期, getdate()) as 年齡 
	 , 'B' + cast(ntile(2) over (order by datediff(year, e.出生日期, getdate()) asc) as varchar) as 房號
from 員工 as e
where e.性別= '女'
order by e.性別 asc, 年齡 asc
go




/*02【難易度 : ★★☆☆☆】10%
如果我們公司員工的職務分為三層，從上而下稱之為上層、中層與基層
請撰寫一個預存程序名為 spEmp+學號 
[輸出](上層員工編號, 上層員工姓名, 中層員工編號, 中層員工姓名, 基層員工編號, 基層員工姓名)
[參數]@name : 上層員工姓名
[說明]
1.可以輸入某特定的 上層員工姓名 查詢所屬下兩層的員工資料(有可能會是NULL)
2.可以不輸入參數值，就是查詢所有員工所屬下兩層的員工資料(有可能會是NULL)
*/

create or alter proc spEmp410878050
@name varchar(10)= null
as
select e3.員工編號, e3.姓名, e2.員工編號, e2.姓名, e1.員工編號, e1.姓名
from 員工 as e1
	 left join 員工 as e2 on e1.主管= e2.員工編號
	 left join 員工 as e3 on e2.主管= e3.員工編號
where @name is null or e3.姓名= @name 

exec spEmp410878050 陳祥輝
exec spEmp410878050


/*03【難易度 : ★☆☆☆☆】10%
請查詢2005年所有員工承接訂單的相關資訊，沒有承接到任何訂單的員工也要出現
[輸出](員工編號, 姓名, *承接訂單數量, *總金額, *總毛利)
[排序]依據 員工編號 遞增
[必要]使用 CTE(Common Table Expression) 的寫法
*/
--【Solution】
;with
cte_2005年訂單
as
(
select o.訂單編號, o.員工編號
				from 訂單 as o
				where year(o.訂貨日期)=2005
)


select e.員工編號, e.姓名
	 , count(o.訂單編號) as 承接訂單數量
	 , isnull(sum(od.實際單價* od.數量), 0) as 總金額
	 , isnull(sum((od.實際單價- p.平均成本)* od.數量 ), 0) as 總毛利
from 員工 as e	
	left join cte_2005年訂單 as o on e.員工編號= o.員工編號
	left join 訂單明細 as od on o.訂單編號= od.訂單編號
	left join 產品資料 as p on od.產品編號= p.產品編號
group by e.員工編號, e.姓名
order by e.員工編號
go




/*04【難易度 : ★☆☆☆☆】10%
請依據以下狀態來計算, 查看每一種狀態的產品數
[輸出](*狀態, *產品數)
[狀態說明]
庫存量<=0                    '零庫存'
0<庫存量<=安全存量/3         '庫存量嚴重不足'
安全存量/3<庫存量<=安全存量  '庫存量不足'
安全存量<庫存量<=安全存量*3  '庫存量充足'
安全存量*3<庫存量            '庫存量過剩'
*/
select case
			when 庫存量<=0          then     '零庫存'
			when 庫存量<=安全存量/3  then    '庫存量嚴重不足'
			when 庫存量<=安全存量		then	'庫存量不足'
			when 庫存量<=安全存量*3  then		'庫存量充足'
			else   '庫存量過剩' 
		end as 狀態
	 , count(case
			when 庫存量<=0          then     '零庫存'
			when 庫存量<=安全存量/3  then    '庫存量嚴重不足'
			when 庫存量<=安全存量		then	'庫存量不足'
			when 庫存量<=安全存量*3  then		'庫存量充足'
			else   '庫存量過剩' 
		end) as 產品數
from 產品資料 as p
group by case
			when 庫存量<=0          then     '零庫存'
			when 庫存量<=安全存量/3  then    '庫存量嚴重不足'
			when 庫存量<=安全存量		then	'庫存量不足'
			when 庫存量<=安全存量*3  then		'庫存量充足'
			else   '庫存量過剩' 
		end 
go




/*05【難易度 : ★☆☆☆☆】10%
請協助建立一個函數名為 fn+學號, 其功能就是回傳下一個新的供應商編號
[輸出結果]應該會是 'S0006'
*/

/*
;with
cte_last
as
(
select right(max(p.供應商編號), 4)+1
from 供應商 as p 
)
select 'S'+ right('000'+ cast(cte_last as varchar), 4) 
*/


select 'S'+ right('000'+ cast((select right(max(p.供應商編號), 4)+1
						from 供應商 as p) as varchar), 4) 




/*06【難易度 : ★★☆☆☆】10%
請依據以下步驟來進行
1. 將 CH11範例資料庫 中的 [員工獎勵金] 資料表copy結構(切記只有結構不要資料) 至 CH07範例資料庫, 資料表名稱為 [員工獎勵金+學號]
   請以所在 CH07範例資料庫 為主來轉寫語法
2. 從 [員工] 資料表中挑選年資滿15年(含)的員工加入 [員工獎勵金] 資料表內，[年度] 資料行請填入執行當天的年度
   不用計算年資是否足年, 直接年度相減即可
3. 請依據以下條件更新 [獎金] 
   * 年資大於等於15, 小於20 : 10000
   * 年資大於等於20, 小於25 : 20000
   * 年資大於等於25 : 30000
[提示]update...set 中可以使用 CASE ... END
*/

--以下是查詢結果

drop table if exists [員工獎勵金410878050]

select* into [員工獎勵金410878050]
from CH11範例資料庫.dbo.員工獎勵金
where 1=3

insert into [員工獎勵金410878050]  (員工編號, 年度, 獎金)
select e.員工編號, year(getdate()), null
from 員工 as e
where datediff(year, e.任用日期, getdate())>= 15
go

update [員工獎勵金410878050]
set 獎金= case
			when datediff(year, e.任用日期, getdate())<20 then 10000
			when datediff(year, e.任用日期, getdate())<25 then 20000
			else 30000
			end
from 員工 as e, 員工獎勵金410878050 as p
where e.員工編號= p.員工編號

select* from [員工獎勵金410878050] 


/*07【難易度 : ★★☆☆☆】20% 資料匯入、資料整理與探索資料
HeartWithNum.csv 檔案包含14個屬性。
目標屬性 "動脈硬化性心臟病" 是指患者中存在心臟病的指標。
它的整數值從0 (正常) 到 4 (1,2,3,4皆屬於不正常)
克利夫蘭數據庫的實驗集中於簡單地嘗試區分心臟病的存在(值1,2,3,4)和不存在(值0)

請先將 HeartWithNum.csv 檔案想辦法匯入 CH07範例資料庫內
匯入後，注意header名稱不可以含有引號

[輸出](*是否心臟病, *是否地中海型貧血, *人數)
[排序]是否心臟病 遞增, 是否地中海型貧血 遞增
[說明]
動脈硬化性心臟病 : 應該出現 
   存在(值1,2,3,4) 
   不存在(值0)
地中海型貧血 : 
   正常 : value 3.0
   固定缺陷 : value 6.0
   可逆缺陷 : value 7.0

資料可能不完整，所以建議先查詢資料的
1. 動脈硬化性心臟病有哪幾類
2. 地中海型貧血有哪幾類
以上兩者各別的查詢也【必須】要先寫出來(沒寫會扣分，寫出來不給分)
*/
--1. 動脈硬化性心臟病有哪幾類

--2. 地中海型貧血有哪幾類






/*08【難易度 : ★★★★☆】20%
請撰寫一個預存程序名稱為 spBackUp+學號 
將 CH07範例資料庫內(除了sysdiagrams之外) 所有的資料表與資料內容一一抄寫至 tempDB 的 public暫時資料表
切記!! 該預存程序必須可以重複執行才算成功
絕對不可以使用手動一個一個select ... into ##table ...
因為你不知道該資料庫內何時又會新增資料表(動態的)
[提示]
1.可以使用系統檢視表 sys.tables 動態查得該資料庫內有哪些資料表
2.使用cursor的方式一個一個資料表 select ... into ##table ...
3.select * from sys.tables                       --可以查到該資料庫有哪些資料表，必須排除sysdiagrams
4.select object_id('tempdb.dbo.##客戶','table')  --判斷暫存資料表是否存在
*/
select*
from sys.tables






--以下是執行
