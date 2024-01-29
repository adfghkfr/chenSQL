--step 1. 找到所有資料表 (cross join)
--step 2. 進行join (inner join)
--step 3. 篩選條件(變矮)
--step 4. 填入資料行(變瘦)
--step 5. 排序
--step 6. distinct 或(且) top <n> [percent][with ties]

-- raw data (原始資料)↑
-----------------------
-- aggragate (彙總資料)↓ 

--step 1. 找到所有資料表 (cross join)
--step 2. 進行join (inner join)
--step 3. 篩選條件(變矮), 針對 raw data 篩選
--step 4. group by , 同時填入資料行(變瘦)
--step 5. having 篩選條件針對 aggregate function
--step 6. 排序
--step 7. distinct 或(且) top <n> [percent][wit ties]


use CH07範例資料庫;

/*group by ... having ...
aggregate funciton(彙總函式) : 
https://docs.microsoft.com/zh-tw/sql/t-sql/functions/aggregate-functions-transact-sql?view=sql-server-ver15
sum() : 加總
avg() : 平均
count() : 計數
min() : 最小值
max() : 最大值

判斷是否為null的函數 isnull()
https://msdn.microsoft.com/en-us/library/ms184325.aspx
*/

/*
請依據 性別 計算以下資料
[輸出](性別, *人數, *平均年齡, *最小年齡, *最大年齡)
[排序]性別遞增
*/
select * from 員工 as e

select e.性別
	  ,count(*) as 人數1 -- 盡量不要用
	  ,count(e.員工編號) as 人數2 -- 使用PK,因為PK不會有NULL,所以每一筆都會+1
	  ,count(e.主管) as 人數3 --使用非PK ,因為非PK有可能有NULL,所以不會每一筆都+1
     , count(1) as 人數4          -- 因為 1 不是Null，所以每一筆都會加1
     , count('abc') as 人數5      -- 因為 'abc' 不是Null，所以每一筆都會加1
	  ,avg(datediff(year,e.出生日期,getdate())) as 平均年齡
	  ,min(datediff(year,e.出生日期,getdate())) as 最小年齡
	  ,max(datediff(year,e.出生日期,getdate())) as 最大年齡
from 員工 as e
group by e.性別
order by e.性別 asc


/*
請計算客戶, 依據縣市計算訂單總金額與總毛利
[輸出](*縣市, *年度, *總金額, *總毛利)
[排序]縣市遞增
*/
*/
select left(c.地址, 3) as 縣市 , year(o.訂貨日期) as 年度
     , sum(od.實際單價*od.數量) as 總金額
     , sum((od.實際單價-p.平均成本)*od.數量) as 總毛利
from 客戶 as c, 訂單 as o, 訂單明細 as od, 產品資料 as p
where c.客戶編號=o.客戶編號
  and o.訂單編號=od.訂單編號
  and od.產品編號=p.產品編號
group by left(c.地址, 3), year(o.訂貨日期)
order by 縣市 asc
go

/*RFM模型
1.R : 最近一次消費(Recency)的日期
2.F : 消費頻率(Frequency)          
3.M : 消費金額(Monetary))
http://wiki.mbalib.com/zh-tw/RFM模型

業務經理要開始整理所有的客戶資料，所以請資訊人員幫忙查出每一位客戶與我們往來的情況
[輸出](客戶編號, 公司名稱, *第一次往來日期, *最近一次往來日期, *往來次數, *總金額)
[排序]客戶編號 遞增
*/
select * from 訂單 as o

select c.客戶編號,c.公司名稱 
	  ,min(o.訂貨日期) as 第一次往來日期
	  ,max(o.訂貨日期) as 最近一次往來日期
	  ,count(o.訂單編號) as [往來次數(錯誤)]
	  ,count(distinct o.訂單編號) as [往來次數(正確)]
	  ,sum(od.實際單價*od.數量) as 總金額
from 客戶 as c
	join 訂單 as o on c.客戶編號=o.客戶編號
	join 訂單明細 as od on o.訂單編號 = od.訂單編號
group by c.客戶編號 , c.公司名稱
order by c.客戶編號 asc

--【探索以上錯誤原因】
select *
from 客戶 as c
     join 訂單 as o on c.客戶編號=o.客戶編號
order by c.客戶編號
go

select *
from 客戶 as c
     join 訂單 as o on c.客戶編號=o.客戶編號
     join 訂單明細 as od on o.訂單編號=od.訂單編號
order by c.客戶編號
go

--【如果以上採用outer join，以客戶為主】
select c.客戶編號, c.公司名稱
     , min(o.訂貨日期) as 第一次往來日期
     , max(o.訂貨日期) as 最近一次往來日期
     , count(o.訂單編號) as [往來次數(錯誤)]
     , count(distinct o.訂單編號) as [往來次數(正確)]
     , sum(od.實際單價*od.數量) as 總金額
from 客戶 as c
     left join 訂單 as o on c.客戶編號=o.客戶編號
     left join 訂單明細 as od on o.訂單編號=od.訂單編號
group by c.客戶編號, c.公司名稱
order by c.客戶編號 asc
go


/*
請計算位於台北市, 台北縣, 屏東縣, 台中市客戶於本公司訂單總金額小於等於1000以下的資料
[輸出](客戶編號, 公司名稱, *所在縣市, *總金額)
[排序]總金額 遞減
[限制]outer join
*/
select c.客戶編號, 公司名稱, left(c.地址, 3) as 所在縣市
     , sum(od.實際單價*od.數量) as 總金額1
     , isnull(sum(od.實際單價*od.數量),0) as 總金額2 -- 處理null值為0
from 客戶 as c
     left join 訂單 as o on c.客戶編號=o.客戶編號
     left join 訂單明細 as od on o.訂單編號=od.訂單編號
where left(c.地址, 3) in ('台北市', '台北縣', '屏東縣', '台中市')
group by c.客戶編號, 公司名稱, left(c.地址, 3)
having isnull(sum(od.實際單價*od.數量), 0) <= 1000
-- HAVING 子句用於過濾分組後的數據，即在對數據進行聚合計算後再篩選出符合條件的組
-- 它作用於分組（GROUP BY）的結果級別，用於過濾分組或聚合後的結果
-- HAVING 可以使用聚合函數，因為它是在數據被聚合後應用
-- WHERE 條件檢查的是個別記錄，不可以使用聚合函數，如 SUM()、AVG() 等
order by 總金額1 desc
go



/*
SQL語言 通常可以分為三大類
DDL(Data Definition Language) : create / alter / drop
DML(Data Manipulation Languge) : select / insert / update / delete
DCL(Data Control Languge) : grant / revoke / deny
*/

--CH09 insert/update/delete
/*insert的四種型態
(1)
insert [into] tableName [(columns)]
values ()
(2)
insert [into] tableName [(columns)]
select ... from ...
(3)
insert [into] tableName [(columns)]
exec StoredProcedure
(4)
insert [into] tableName [(columns)]
exec (@sqlStr)
*/

use CH09範例資料庫

--新增資料時要特別注意，重覆insert會不會造成 PK 重覆的問題
--比較不建議的寫法，因為順序是依據資料庫內的順序，萬一順序異動就會出問題
insert into 產品資料
values (13, 7, 'S0005', '陳年紹興', 300, 250, 300,150)
go

insert into 產品資料 (產品編號, 類別編號, 供應商編號, 產品名稱, 建議單價, 平均成本, 庫存量, 安全存量)
values (14, 8, 'S0005', '藍山經典咖啡', 35, 25, 500,200)
go

--若是有將column name都列出，values內的順序要依據該column name
insert into 產品資料 (產品編號, 產品名稱, 類別編號, 供應商編號, 建議單價, 平均成本, 庫存量, 安全存量)
values (15, '藍山經典咖啡', 8, 'S0005', 35, 25, 500,200)
go

--若是資料表有設定預設值，可以用default來表示
insert into 產品資料 (產品編號, 類別編號, 供應商編號, 產品名稱, 建議單價, 平均成本, 庫存量, 安全存量)
values (16, 7, 'S0005', '紅葡萄酒', 850, 650, default, default)
go

--用這個練習
--沒有值的column可以不用寫出來
insert into 產品資料 (產品編號, 類別編號, 供應商編號, 產品名稱, 建議單價, 平均成本)
values (16, 7, 'S0005', '紅葡萄酒', 850, 650)
go

--一次新增多筆資料
insert into 產品資料 (產品編號, 類別編號, 供應商編號, 產品名稱, 建議單價, 平均成本, 庫存量, 安全存量)
values (26, 8, 'S0004', '雙倍濃縮咖啡', 50, 35, 100, default) ,
       (27, 7, 'S0001', '黑麥啤酒', 85, 65, default, default) ,
       (28, 7, 'S0005', '生啤酒', 45, 35, 500, 150)
go

--values內也可以使用函數
insert into 訂單 (訂單編號, 員工編號, 客戶編號, 訂貨日期, 預計到貨日期, 付款方式, 交貨方式)
values ('98090201', 7, 'C0012', '2009/09/28', dateadd( day, 7, '2009/09/28' ), '支票', '快遞')
go

--新增先新增父資料表(訂單)，再新增子資料表(訂單明細)
insert into 訂單 (訂單編號, 員工編號, 客戶編號, 訂貨日期, 預計到貨日期, 付款方式, 交貨方式)
values ('98120101', 7, 'C0005', '2009/12/01', '2009/12/10', '支票', '快遞')
go

insert into 訂單明細 (訂單編號, 產品編號, 實際單價, 數量)
values ('98120101', 13, 270, 100) , 
       ('98120101', 14,  30, 150) , 
       ('98120101', 16,  50,  60)
go



/*
(2)
從其他資料表挑選資料來新增
insert [into] 已經存在的資料表 [(columns)]
select ... from ...

比較

挑選出資料，寫入一個新的資料表(事先不能存在)
select * into 不存在的資料表
from ...
where ...
...
*/
select * from T男員工
go


--【重點】T男員工 資料表必須事先存在
insert into T男員工
select e.員工編號, e.姓名, e.職稱, e.性別
from 員工 as e
where e.性別='男'
go

--【重點】T女員工 資料表事先不能存在

drop table if exists T女員工

select e.員工編號, e.姓名, e.職稱, e.性別 into T女員工
from 員工 as e
where e.性別='女'
go


drop table if exists T低消客戶

select c.客戶編號, 公司名稱, left(c.地址, 3) as 所在縣市
     , sum(od.實際單價*od.數量) as 總金額1
     , isnull(sum(od.實際單價*od.數量),0) as 總金額2 into T低消客戶
from 客戶 as c
     left join 訂單 as o on c.客戶編號=o.客戶編號
     left join 訂單明細 as od on o.訂單編號=od.訂單編號
where left(c.地址, 3) in ('台北市', '台北縣', '屏東縣', '台中市')
group by c.客戶編號, 公司名稱, left(c.地址, 3)
having isnull(sum(od.實際單價*od.數量), 0) <= 1000
order by 總金額1 desc
go

select * from T低消客戶
go

--存在硬碟內可以執行的稱之為【程式】(program)
--已經執行起來的程式稱之為【程序】(process)
--每一個 Process 會有獨一無二的 【PID】
--在SQL SERVER是採用 【SPID】 (Session Process ID)
--只要看到 session 代表已經連線成功且登入完成

exec sp_who2

--暫存資料表儲存於 【資料庫】\【系統資料庫】\【tempdb】\【暫存資料表】
-- #tablename : 私有(private)的暫存資料表，只有自建的session可以使用，session斷線就自動被刪除
--##tablename : 公有(public)的暫存資料表，所有的session都可以使用，資料庫服務重新啟動就自動被刪除

--【private】
select e.員工編號, e.姓名, e.職稱, e.性別 into #女員工
from 員工 as e
where e.性別='女'
go

select * from #女員工

--【public】
select e.員工編號, e.姓名, e.職稱, e.性別 into ##女員工
from 員工 as e
where e.性別='女'
go































