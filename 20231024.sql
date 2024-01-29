-- 找出資料表
select *
from 員工 as e
where (left(e.地址, 3) = '台北市' or left(e.地址, 3) = '桃園縣')
GO

select *
from 員工 as e
where left(e.地址, 3) in ('台北市', '桃園縣') 
  and month(e.出生日期) in (7, 8, 9, 10, 11, 12)
order by 居住縣市 asc, 年齡 desc -- 先按照居住縣市遞增，再按年齡遞減
GO

-- 2.
select *
from 訂單 as c
-- 注意：最後一個月的話年份會加一


--IIF: if loop
-- 只要業務的訂貨日期在26前算本月，在26後算下個月
-- 請查詢2006年每一筆訂單業績的歸屬年份與月份
-- 邏輯：26前後都要加月份，26前加0，26後加1

-- step1:找出資料表
select *
from 訂單 as o
where year(o.訂貨日期) = 2006

select 訂單編號, 員工編號, 訂貨日期
     , iff(day(o.訂貨日期) <= 26, 0, 1) as [欲加月份數(0或1)]
     -- 增加訂貨日期月份：dateadd()
     -- , dateadd(month, ?, o.訂貨日期) as 位移後的日期 （?就是欲加月份數）
     , dateadd(month, iff(day(o.訂貨日期) <= 26, 0, 1), o.訂貨日期) as 位移後的日期
from 訂單 as o
where year(o.訂貨日期) = 2006
go


-- my practice
-- select 裡面的事情事同時發生的
select 訂單編號, 員工編號, 訂貨日期
     -- 計算加的月份是0還是1
     , iif(day(o.訂貨日期) <= 26, 0, 1) as 欲加月份數
     -- 要算歸屬年份跟月份，先求出新的業績歸屬日期
     , dateadd(month, iif(day(o.訂貨日期) <= 26, 0, 1), o.訂貨日期) as 位移後日期
     , year(dateadd(month, iif(day(o.訂貨日期) <= 26, 0, 1), o.訂貨日期)) as 業績歸屬年份
     , month(dateadd(month, iif(day(o.訂貨日期) <= 26, 0, 1), o.訂貨日期)) as 業績歸屬月份
from 訂單 as o
where year(o.訂貨日期) = 2006
go


-- 查詢本公司有哪些不同的職稱
select distinct e.職稱
from 員工 as e
GO

--
-- 別名不能用在where條件裡面
select *
from 員工 as e
where datediff(year, e.出生日期, getdate()) >= 50
order by 性別 asc, 年齡 desc

-- 請例出本公司年齡最大的前五位
select 員工編號, 姓名, 性別, 職稱
     --, datediff(year, e.出生日期, getdate()) as 年齡
     , year(getdate()) - year(e.出生日期)
from 員工 as e
order by 年齡 desc

-- 同名並列
select top 5 with ties 員工編號, 姓名, 性別, 職稱
     --, datediff(year, e.出生日期, getdate()) as 年齡
     , year(getdate()) - year(e.出生日期)
from 員工 as e
order by 年齡 desc
go

-- 取前百分之
select top 5 percent with ties 員工編號, 姓名, 性別, 職稱
     --, datediff(year, e.出生日期, getdate()) as 年齡
     , year(getdate()) - year(e.出生日期)
from 員工 as e
order by 年齡 desc


----- LIKE 語法
select *
from 客戶 as c
where c.地址 like '__縣%'
GO

select *
from 客戶 as c
where c.地址 like '_%段%' -- 保證段不會是第一個字
GO

select *
from 客戶 as c
where c.地址 like '%[二五]段%' 

select *
from 客戶 as c
where c.地址 like '%[^二五]段%' -- 要有段而且不是二五段
GO

select *
from 客戶 as c
where c.地址 not like '%[二五]段%' -- 跟上面不同，沒有段也可以
GO


select left(c.地址, 3) as 縣市 
     -- 計算每個縣市出現的數量
     , count(left(c.地址, 3)) as 縣市出現的數量
from 客戶 as c

-- like 自訂跳脫字元
-- 資料庫內有特殊字元的時候可以使用
select *
from 客戶 as c
where c.地址 like '%\%%' escape '\'

-- 次序/滑動視窗函數


