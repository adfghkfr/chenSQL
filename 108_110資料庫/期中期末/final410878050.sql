	/*
110學年度第一學期 臺北大學統計系(所) 【資料庫應用與商業智慧分析】 課程 期末考試 老師：陳祥輝

學生學號：410878050	
學生姓名：黃亮臻

注意事項：
1.請先將此檔案更改名稱為 : final+學號：，例如：final12345678.sql
2.切勿複製上課程式進行修改，一旦發現視同作弊論，會倒扣該題分數
3.每一題只能有一個答案，切勿將過程留在考題上，否則只會以第一個來評分
4.以下請用CH07範例資料庫，除非有特別指定
5.輸出屬性名稱前若是有 * 代表是 別名 或 衍生 屬性
6.請盡量達成使命, 請依循步驟讓你(妳)的語法是可以執行的。
7.不可執行的程式以0分計，可執行的程式才有可能部份會全部的分數，若是多個資料表必須完成join後才有部份分數。
8.給分標準，會因為每一題的重點不同，會有所差異
9.難易度僅供參考，會因個人而異
10.所有預存程序皆使用 create or alter proc ...
*/

use CH07範例資料庫;

/*01【難易度 : ★☆☆☆☆】10%
請找出哪幾筆有訂單資料，卻沒有訂單明細的資料
[輸出](訂單編號, 訂貨日期, *承辦員工姓名)
[排序]訂單編號遞增
*/
select o.訂單編號, 訂貨日期, e.姓名 as 承辦員工姓名
from 訂單 as o
	left join 訂單明細 as od on o.訂單編號= od.訂單編號
	left join 員工 as e on  o.員工編號= e.員工編號
where od.訂單編號 is null
go


/*02【難易度 : ★☆☆☆☆】10%
請查詢曾經訂購過 烏龍茶 和 咖啡 兩項產品(兩者皆有訂購過) 有多少家客戶數
[輸出](*客戶數)
[提示]
1. (1)找出訂購過 烏龍茶, (2)找出訂購過 咖啡 的客戶資料
2. 將以上兩者利用 intersect 找出交集，就是兩者皆有訂購過的客戶資料
3. 將以上的 intersect 當成子查詢，計算筆數
*/

select c.客戶編號
from 產品資料 as p, 訂單明細 as od, 訂單 as  o, 客戶 as c
where p.產品編號= od.產品編號
	 and od.訂單編號= o.訂單編號
	 and o.客戶編號= c.客戶編號
	 and p.產品名稱= '烏龍茶'
intersect
select c.客戶編號
from 產品資料 as p, 訂單明細 as od, 訂單 as  o, 客戶 as c
where p.產品編號= od.產品編號
	 and od.訂單編號= o.訂單編號
	 and o.客戶編號= c.客戶編號
	 and p.產品名稱= '咖啡'
go



/*03【難易度 : ★★☆☆☆】10%
請建立一個預存程序【sp+學號_exam03】，可以輸入起、迄年齡 與 起、迄年資來查詢員工資料
[輸出](員工編號, 姓名, 出生日期, 任用日期, *年齡, *年資)
[參數]
@起年齡, @迄年齡, @起年資, @迄年資
[參數輸入的限制條件]
1.輸入起、迄年齡 : 起年齡 <= 年齡 and 年齡 <= 迄年齡
2.只輸入起年齡 : 年齡 >= 起年齡
3.只輸入迄年齡 : 年齡 <= 迄年齡
4.起、迄年齡都沒有輸入 : 全部

1.輸入起、迄年資 : 起年資 <= 年資 and 年資 <= 迄年資
2.只輸入起年資 : 年資 >= 起年資
3.只輸入迄年資 : 年資 <= 迄年資
4.起、迄年資都沒有輸入 : 全部

[說明]
1. 年齡與年資不用精算，只要西元年相減即可
2. 年齡與年資任何一個條件成立即可
*/
--【Solution】
create or alter proc sp410878050_exam03
@起年齡 int=null,  @迄年齡 int=null, @起年資 int=null,  @迄年資 int=null
as
select 員工編號, 姓名, 出生日期, 任用日期
	 , datediff(year, e.出生日期, getdate()) as 年齡
	 , datediff(year, e.任用日期, getdate()) as 年資
from 員工 as e
where ((@起年齡 is null or datediff(year, e.出生日期, getdate()) >= @起年齡)
  and (@迄年齡 is null or datediff(year, e.出生日期, getdate()) <= @迄年齡))
  or 
  ((@起年資 is null or datediff(year, e.任用日期, getdate()) >= @起年資)
  and (@迄年資 is null or datediff(year, e.任用日期, getdate()) <= @迄年資))

go


--【執行的部份】切記!! 要更改預存程序中學號的部份
--查詢所有員工
exec sp410878050_exam03

--查詢年齡>=65 或 年資>=25的員工
exec sp410878050_exam03 @起年齡=65, @起年資=25 

--查詢年齡介於65-68之間 或 年資介於 25-28 之間
exec sp410878050_exam03 @起年齡=65, @迄年齡=68, @起年資=25, @迄年資=28

--查詢年齡<=50 或 年資 <=25
exec sp410878050_exam03 @迄年齡=50, @迄年資=25
go


/*04【難易度 : ★★☆☆☆】10%
請撰寫一個預存程序 【sp+學號_exam04】 可以查詢某一年，從未銷售過的產品，哪一個類別的產品數最多，同名要並列
[輸出](類別編號, 類別名稱, *年度, *未曾售出的產品數)
[參數]@year
*/

create or alter proc sp410878050_exam04
@year int
as
select ca.類別編號, 類別名稱, 年度=@year, 產品名稱 as 未曾售出的產品數
from 產品類別 as ca
	inner join 產品資料 as p on ca.類別編號= p.類別編號
	left join (select distinct od.產品編號, o.訂單編號, year(o.訂貨日期) as 年度
                from 訂單 as o, 訂單明細 as od
                where o.訂單編號=od.訂單編號
                  and year(o.訂貨日期)=@year) as od on p.產品編號=od.產品編號
where od.產品編號 is null
go

--【執行的部份】切記!! 要更改預存程序中學號的部份
exec sp410878050_exam04 2005
exec sp410878050_exam04 2006




/*05【難易度 : ★☆☆☆☆】10%
請列出建議單價 大於等於 所有產品的平均建議單價 的產品資料
[輸出](類別編號, 類別名稱, 產品編號, 產品名稱, 建議單價, *所有產品的平均建議單價)
*/
select ca.類別編號, 類別名稱, 產品編號, 產品名稱, 建議單價
	  , (select avg(p.建議單價) from 產品資料 as p) as 所有產品的平均建議單價
from 產品資料 as p, 產品類別 as ca
where ca.類別編號= p.類別編號
	 and p.建議單價>= (select avg(p.建議單價) from 產品資料 as p)
go



/*06【難易度 : ★★☆☆☆】10%
本公司為了發放敬老津貼，請依據以下步驟來進行
1. 將 CH11範例資料庫 中的 [員工獎勵金] 資料表copy結構(切記只有結構不要資料) 至 私有暫存資料表, 資料表名稱為 #員工獎勵金+學號
2. 從 [員工] 資料表中挑選年齡大於等於50歲的員工加入 #員工獎勵金+學號 資料表內，[年度]資料行請填入執行當天的年度
   不用計算年齡是否足年, 直接年度相減即可
3. 請依據以下條件更新 [獎金] 
   * 年資大於等於30 : 30000
   * 年資大於等於25, 小於30 : 20000
   * 年資大於等於20, 小於25 : 10000
   * 其他 :  5000
*/
drop table if exists #員工獎勵金410878050

select* into #員工獎勵金410878050
from CH11範例資料庫.dbo.員工獎勵金
where 1=3

insert into #員工獎勵金410878050  (員工編號, 年度, 獎金)
select e.員工編號, year(getdate()), null
from 員工 as e
where datediff(year, e.出生日期, getdate())>= 50
go

update #員工獎勵金410878050
set 獎金= case
			when datediff(year, e.任用日期, getdate())>= 30 then 30000
			when datediff(year, e.任用日期, getdate())>= 25 then 20000
			when datediff(year, e.任用日期, getdate())>= 20 then 10000
			else 5000
			end
from 員工 as e, #員工獎勵金410878050 as p
where e.員工編號= p.員工編號
go


--【查詢結果】切記!! 要更改暫存資料表中學號的部份
select* from #員工獎勵金410878050
go


/*07【難易度 : ★★★★☆】20%
請依據男、女分開，依據出生日期遞增排序，算出每一位與下一位的年齡差距
[輸出](員工編號, 姓名, 性別, 出生日期, *前一位的出生日期, *後一位的出生日期)
[排序]性別遞增, 出生日期遞增
[提醒]可以使用self-join + outer join，員工資料表扮演兩個角色
[限制]請使用CTE來撰寫此題
*/
select e1.員工編號, e1.姓名, e1.性別, e1.出生日期, e2.出生日期 as 前一位的出生日期, e3.出生日期 as 後一位的出生日期
from 員工 as e1
	left join (前一位出生的員工) as e2 on e1.出生日期= e2.出生日期
	left join (後一位出生的員工) as e3 on e1.出生日期= e3.出生日期

where e1.性別= '男'
order by e1.出生日期
union
select e1.員工編號, e1.姓名, e1.性別, e1.出生日期, e2.出生日期 as 前一位的出生日期, e3.出生日期 as 後一位的出生日期
from 員工 as e1
	left join (前一位出生的員工) as e2 on e1.出生日期= e2.出生日期
	left join (後一位出生的員工) as e3 on e1.出生日期= e3.出生日期

where e1.性別= '女'
order by e1.出生日期
go


--後一位序號
select e1.員工編號, e1.姓名, e1.性別, e1.出生日期, e2.出生日期
	, row_number() over (order by e1.出生日期 asc)  as 序號 
	, iif(row_number() over (order by e1.出生日期 asc)=7, 1, row_number() over (order by e1.出生日期 asc)+ 1 )as 後一位序號 
from 員工 as e1
	left join 員工 as e2 on e1.出生日期= e2.出生日期
where e1.性別= '男'
order by e1.出生日期




/*08【難易度 : ★★★☆☆】20%
1.請先將 exam08DB 資料庫附加至你(妳)的MS SQL SERVER
2.可以依據Exam08_ER_Model.jpg或以下說明，將資料一一轉至相對應的資料表內
  【BOOK】【DEPNAME】【LOAN】【STUDENT】
3.請使用alter table方式建立所有的primar key & foreign key
4.將以上 step2, step3 的步驟寫成預存程序 【sp+學號_exam08】，並且要可以重複執行才算成功

[資料表的規格]可以參考 Exam08_ER_Model.jpg
[book]
primary key : 書籍編號

[depname]
primary key : 科別代號

[student]
primary key : 學號
foreign key 科別代號 參考 depname 資料表

[loan]
primary key : 學號 + 書籍編號 + 借閱日期
foreign key 學號 參考 student 資料表
foreign key 書籍編號 參考 book 資料表

*/
--記得切換資料庫
use exam08DB


create or alter proc sp_drop
as
drop table if exists book
drop table if exists student
drop table if exists depname
drop table if exists loan
go


create or alter proc sp_create
as
create table book
(
書籍編號 char(30) not null, 
書籍名稱 nvarchar(50),
作者     nvarchar(20),
出版商   nvarchar(20),
購買日期 date,
借閱次數 char(5),
是否借出 tinyint,
)

create table depname
(
科別代號     char(6) not null,
科別名稱  nvarchar(100)  not null,
)

create table student
(
學號 char(8) not null,
姓名 nvarchar(10),
性別 tinyint,
科別代號 char(6), 
年級 tinyint,
班級 char(3)  ,
電話 char(8),
地址 nvarchar(50),
)

create table loan
(
學號 char(8) not null,
書籍編號 char(30) not null,
借閱日期 date not null,
歸還日期 date,
)

alter table book
	add primary key (書籍編號)

alter table depname
	add primary key (科別代號)

alter table student
	add primary key (學號), 
	foreign key (科別代號) references depname(科別代號)

alter table loan
	add primary key (學號, 書籍編號, 借閱日期), 
	foreign key (學號) references student (學號), 
	foreign key (書籍編號) references book (書籍編號)

go


create or alter proc sp410878050_exam08
as
exec sp_drop
exec sp_create


--【執行的部份】切記!! 要更改預存程序中學號的部份


exec sp410878050_exam08
go

----------!----------!----------!----------!----------!----------!----------!----------!----------!----------
/*
這學期希望大家都能收獲滿滿，倘若有任何對我個人在教學上有任何建議
可於下方留言，此部份完全不列入評分
感謝各位這學期的配合與努力，祝福各位新年快樂，事事如意
*/






