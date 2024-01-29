-- sql server

-- 常用日期函數 

-- 日期
select getdate()  as 今天日期
     , year(getdate())  as 西元年 -- 取得年份 
     , month(getdate()) as 月
     , day(getdate())
     -- , quater(getdate()) 沒有此函數
     -- 欲求季度資料的話，可以用以下方式：
     , (month(getdate())+2)/3 as 季度1
     , ceiling(month(getdate())/3.0) as 季度2
GO

-- datepart
select '2023/01/31'
    , datepart(quarter, '2023/01/31') -- 1
    , datepart(quarter, getdate()) -- 4 (2023.10月是第四季)
GO

-- dateadd()
select '2023/01/31'
     , dateadd(month, 1, '2023/01/31')  -- 2023-02-28
     , dateadd(month, -1, '2023/01/31') -- 2022-12-31
GO

-- datediff()
select '2023/01/31'
     , datediff()
GO

-- eomonth()
-- 這個月的最後一天
select eomonth(getdate())
GO


-- 下個月的第一天
select dateadd(day, 1, eomonth(getdate())) -- 先取得這個月的最後一天，再加一天
GO
-- 思路方式
select getdate()
    , eomonth(getdate())
    , dateadd(day, 1, eomonth(getdate()))
GO


-- 請將今天日期轉換2023.10.17
select getdate()
     , year(getdate()) - 1911 -- 轉成民國
     , month(getdate())
     , day(getdate()) 
     , datepart(weekday, getdate()) -- 1:星期日, 2:星期一, 3:星期二, 4:星期三, 5:星期四, 6:星期五, 7:星期六
GO
select getdate()
     , '民國' + cast(year(getdate()) as varchar) - 1911 + '年' -- 轉成民國
     , cast(month(getdate()) as varchar) + '月'
     , cast(day(getdate()) as varchar) + '日'
     , datepart(weekday, getdate()) -- 1:星期日, 2:星期一, 3:星期二, 4:星期三, 5:星期四, 6:星期五, 7:星期六
GO
-- 如何補零？
-- 月份最多會有三個0，日期也是
select '000' + '3'
     , '000' + '12'
     , right('000' + '3', 3)
     , right('000' + '12', 3)
GO
select getdate()
     , '民國' + cast(year(getdate()) as varchar) - 1911 + '年' -- 轉成民國
     , right('000' + cast(month(getdate()) as varchar), 3) + '月'
     , right('000' + cast(day(getdate()) as varchar), 3) + '日'
     , datepart(weekday, getdate()) -- 1:星期日, 2:星期一, 3:星期二, 4:星期三, 5:星期四, 6:星期五, 7:星期六
GO

-- 也可以使用 format 來補零
select format(3, '000')
select getdate()
     , '民國' + cast(year(getdate()) as varchar) - 1911 + '年' -- 轉成民國
     , format(month(getdate()) + '0##月')
     , format(day(getdate()) + '0##日')
     , datepart(weekday, getdate()) -- 1:星期日, 2:星期一, 3:星期二, 4:星期三, 5:星期四, 6:星期五, 7:星期六
GO


-- 如何改變星期幾變成中文？
select getdate()
     , datepart(weekday, getdate()) -- 1:星期日, 2:星期一, 3:星期二, 4:星期三, 5:星期四, 6:星期五, 7:星期六
     , case datepart(weekday, getdate())
          when 1 then '日'
          when 2 then '一'
          when 3 then '二'
          when 4 then '三'
          when 5 then '四'
          when 6 then '五'
          when 7 then '六'
       end
GO


select '日一二三日五六'
      , substring('日一二三日五六', 3, 1)
      , substring('日一二三日五六', datepart(weekday, getdate()), 1)
GO


select format(3, '000')
select getdate()
     , '民國' + cast(year(getdate()) as varchar) - 1911 + '年' -- 轉成民國
     + format(month(getdate()) + '0##月')
     + format(day(getdate()) + '0##日')
     + ' '
     + '星期' + substring('日一二三日五六', datepart(weekday, getdate()), 1) -- 1:星期日, 2:星期一, 3:星期二, 4:星期三, 5:星期四, 6:星期五, 7:星期六
GO

-- 考試記得切換資料庫
-- 使用CH07資料庫
use CHO7範例資料庫

select * 
from 員工 as e

-- 請查詢本季壽星的基本資料
-- step1. 找出資料表
select * 
from 員工 as e
-- step2. 篩選條件（變矮）
select * 
from 員工 as e
where datepart(quarter, getdate()) = datepart(quarter, e.出生日期)
GO
-- step3. 填入資料欄（變瘦）
select 員工編號, 姓名
from 員工 as e
where datepart(quarter, getdate()) = datepart(quarter, e.出生日期)
GO

-- attach .mdf file in database
create database testdb
on
( name = 'testdb'
  , filename = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\testdb.mdf'
)




