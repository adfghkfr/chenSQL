use CH03範例資料庫; -- statement

use CH07範例資料庫
go

-- 結果的輸出
select 100+20, 30-60, 3*50, 10/5, 19.0/5, 19*1.0/5
go

-- 加入 column name
select 100+20    as 加法
            ,30-60            減法
			,3*50              乘法
			,19/5              [除法(一)]
			,19.0/5           "除法(二)"
			,19*1.0/5       [除法(三)]
go

-- 四捨五入
select round(84.94, 2)
          , round(84.94, 1)
		  -- , round(99.95, 1)
	      , round(84.94, 0)
	      , round(84.94,-1)  --整數2位
go

--天花板函數取大 -- 無條件進位
select ceiling(59.3)
          , ceiling(59.8)
          , ceiling(-59.3)
          , ceiling(-59.8)
go

--地板函數取小 -- 無條件不進位
select floor(59.3)
          , floor(59.8)
          , floor(-59.3)
          , floor(-59.8)
go

--開平方根(square root)
select sqrt(16)
          , sqrt(floor(16.556))
		  , sqrt(16.556)
go

--平方
select square(3)
          , square(11.25)
go

--絕對值
select abs(-69)
go

--次方
select power(2,3)
go


/*
https://docs.microsoft.com/zh-tw/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-2019

-- CAST Syntax:  
CAST ( expression AS data_type [ ( length ) ] )  

-- CONVERT Syntax:  
CONVERT ( data_type [ ( length ) ] , expression [ , style ] )  
*/

select '祥輝老師今年' + 18 + '歲多一點點'
--【錯誤訊息】
--訊息 245，層級 16，狀態 1，行 117
--將 varchar 值 '祥輝老師今年' 轉換成資料類型 int 時，轉換失敗。
go

-- The CAST() function converts a value (of any type) into a specified datatype.
-- 因為錯誤訊息，選擇將數值型的 18 轉換成 verchar，以得到一個字串的結果
select '祥輝老師今年' + cast(18 as varchar) + '歲多一點點' -- SELECT CAST(25.65 AS int)

-- The CONVERT() function converts a value (of any type) into a specified datatype
select '祥輝老師今年' + convert(varchar, 18) + '歲多一點點'
go

select 99.95
     , cast(99.95 as numeric(5, 2))  -- 99.5 99.5
     , round(cast(99.95 as numeric(5, 2)), 1) -- 100.00
	 , round(cast(99.95 as numeric(5, 2)), 2) -- 99.95
go

select 99.95
     , cast(99.95 as numeric(4, 1))
go

--常用的日期函數 getdate() / dateadd() / datediff() / eomonth()
select getdate()          as 今天日期
     , year(getdate())    as 西元年
     , month(getdate())   as 月
     , day(getdate())     as 日
     -- , quarter(getdate()) 
     , (month(getdate())+2)/3         as 季別1
     , ceiling(month(getdate())/3.0)  as 季別2
go


/*
1 2 3 4 5 6 7 8 9 10 11 12
----- ----- ----- --------
  1     2     3       4

3 4 5 6 7 8 9 10 11 12 13 14
----- ----- ------- --------
*/

select '2023/01/31'
     , datepart(quarter, '2023/01/31') -- 1
     , datepart(quarter, getdate()) -- 4 (2023年10月是第四季)
go

select '2023/01/31'
     , dateadd(month, 1, '2023/01/31') -- 2023-02-28
     , dateadd(month, -1, '2023/01/31') -- 2022-12-31
go

select datediff(year, '2022/12/31', '2023/01/31') -- 1
     , datediff(month, '2022/10/31', '2023/01/31') -- 3
go

-- 這個月的最後一天
select eomonth(getdate())

--請問下個月的第一天日期為何?
select getdate()
          , eomonth(getdate())
	      , dateadd(day, 1, eomonth(getdate()))



--【字串(string)函數】
select left('abcdefghijk',3)                       --從字串的左邊取3個字
     , right('abcdefghijk',6)                      --從字串的右邊取6個字
     , substring('abcdefghijk',2,5)                --從字串中的第2個字開始取5個字
     , lower('abcdEFGHIJK')                        --轉換成小寫
     , upper('abcdEFGHIJK')                        --轉換成大寫
     , len('這是abcd')                             --計算字串的長度length(字數)
     , charindex('abc','abcdefghijkabcdefghijk')   --找'abc'在字串'abcdefghijkabcdefghijk'第一次出現的位置
     , charindex('abc','abcdefghijkabcdefghijk',2) --找'abc'在字串'abcdefghijkabcdefghijk'中，從第2個字後面第一次出現的位置
     , charindex('abb','abcdefghijkabcdefghijk')   --找不到會回傳0
     , replace('abcdefcdg','cd','xxxxx')           --將'cd'用'x'取代
     , replace('abcdefcdg','cd','')                --將'cd'用空字串取代，也就是將'cd'去掉
     , replicate('abc',5)                          --'abc'重複5次
go

/*
請將今天日期(2023/10/17)轉換成 民國112年010月017日 星期二
*/

select getdate()
     , year(getdate())-1911  -- 112
     , month(getdate()) --10
     , day(getdate()) --17
     , datepart(weekday, getdate()) --3
go

select getdate()
     , '民國'+cast(year(getdate())-1911 as varchar)+'年'
     , cast(month(getdate()) as varchar) + '月'
     , cast(day(getdate()) as varchar) + '日'
     , datepart(weekday, getdate())
go

--【蹲到牆角邊想一想】如何補0
select '000'+'3' -- 0003
     , '000'+'12' --- 00012

-- 從右邊開始切三個數字出來
select right('000'+'3', 3) -- 003
     , right('000'+'12', 3) -- 012
go

select getdate()
     , '民國'+cast(year(getdate())-1911 as varchar)+'年'
     + right('000'+cast(month(getdate()) as varchar), 3) + '月'
     + right('000'+cast(day(getdate()) as varchar), 3) + '日'
     , datepart(weekday, getdate())
go

--【蹲到牆角邊想一想】如何轉換星期
select getdate()
          , datepart(weekday, getdate())
          , case datepart(weekday, getdate())
		          when 1 then '日'
				  when 2 then '一'
				  when 3 then '二'
				  when 4 then '三'
				  when 5 then '四'
				  when 6 then '五'
				  when 7 then '六'
			end

select '日一二三四五六'
          , substring( '日一二三四五六', 3, 1) -- 二
		  , substring( '日一二三四五六', datepart(weekday, getdate()), 1)
go


select getdate()
     , '民國'+cast(year(getdate())-1911 as varchar)+'年'
     + right('000'+cast(month(getdate()) as varchar), 3) + '月'
     + right('000'+cast(day(getdate()) as varchar), 3) + '日'
	 + ' '
     + '星期' + substring( '日一二三四五六', datepart(weekday, getdate()), 1)
go

--【使用 format() 函數處理補 0 問題】
select format(3, '00')

select getdate()
     , format(3, '000')
     , '民國'+cast(year(getdate())-1911 as varchar) + '年'
     + format(month(getdate()), '0##月')
     + format(day(getdate()), '0##日')
     + ' 星期'+substring('日一二三四五六', datepart(weekday, getdate()), 1)
go

/*
請查詢本季壽星的基本資料
[輸出](員工編號, *員工姓名, 性別, 出生日期, *民國出生日期)
*/
--step 1 : 找出資料表
select *
from 員工 as e
go

--step 2 : 篩選條件(變矮)
select *
from 員工 as e
where datepart(quarter, getdate()) = datepart(quarter, e.出生日期)
go

select 員工編號, 姓名 as 員工姓名, 性別, 出生日期
          , ??? as 民國出生日期
from 員工 as e
where datepart(quarter, getdate()) = datepart(quarter, e.出生日期)
go

--step 3 : 填入資料行(變瘦)
select 員工編號, 姓名 as 員工姓名, 性別, 出生日期
     , ??? as 民國出生日期
from 員工 as e
where datepart(quarter, getdate()) = datepart(quarter, e.出生日期)
go

select 員工編號, 姓名 as 員工姓名, 性別, 出生日期
     , '民國'+cast(year(出生日期)-1911 as varchar) + '年'
     + format(month(出生日期), '0##月')
     + format(day(出生日期), '0##日')
     + ' 星期'+substring('日一二三四五六', datepart(weekday, 出生日期), 1) as 民國出生日期
from 員工 as e
where datepart(quarter, getdate()) = datepart(quarter, e.出生日期)
go




