use ch07範例資料庫;

/*01【難易度 : ★★☆☆☆】10%
請列出 實際服務年資 滿15年且未滿27年 的員工資料
[輸出](員工編號, 姓名, 性別, 任用日期, *實際服務年資)
[排序]實際服務年資 遞減
[說明]實際服務年資 以 任用日期 至此程式執行當天計
*/

--【Solution】

select 員工編號, 姓名, 性別, 任用日期
		, datediff(year, e.任用日期,getdate()) as 實際服務年資
from 員工 as e
where datediff(year, e.任用日期,getdate()) >=15 and datediff(year, e.任用日期,getdate()) <27
order by 實際服務年資 asc
go

--【Otehr Solution】
select 員工編號, 姓名, 性別, 任用日期, datediff(day,任用日期,getdate())/365 as 實際服務年資
from 員工
where datediff(day,任用日期,getdate())/365 < 27 and datediff(day,任用日期,getdate())/365 >=15
order by datediff(day,任用日期,getdate())/365 desc
go

/*02【難易度 : ★☆☆☆☆】10%
請列出我們公司除了 屏東、花蓮、台中 之外，每一個縣市地區有幾個客戶
[輸出](*縣市, *地區, *客戶數)
[排序]縣市 遞增, 地區 遞增
[說明]
1.縣市 是指客戶地址的前三個字，例如 台北市
2.地區 是指客戶地址的4-6個字，例如 中山區
*/

--【Solution】

select  left(c.地址, 3) as 縣市, 
		substring(c.地址,4,3) as 地區, 
		count(substring(c.地址,1,6)) as 客戶數
from 客戶 as c
where left(c.地址, 2) not in ('屏東','花蓮','台中')
group by left(c.地址, 3), substring(c.地址,4,3) 
order by 縣市 asc, 地區 desc
go


/*03【難易度 : ★★☆☆☆】10%
請列出 庫存成本 最高的前五名(同名要並列出來)，並給予排名，庫存成本最高的為第1名
[輸出](類別編號, 類別名稱, 產品編號, 產品名稱, 庫存量, 平均成本, *庫存成本, *排名)
[說明]
1.排名函數使用 rank()
2.庫存成本 為 庫存量 * 平均成本
*/

--【Solution】
 select top 5
		 p.類別編號, ca.類別名稱, p.產品編號, p.產品名稱, p.庫存量, p.平均成本
		, p.庫存量*p.平均成本  as 庫存成本
		,rank() over (order by p.庫存量*p.平均成本 desc ) as 排名
 from 產品資料 as p, 產品類別 as ca
 where p.類別編號 = ca.類別編號
go


/*04【難易度 : ★★☆☆☆】10%
請查詢歷年累計中，哪一個客戶訂購 果汁 類的產品數量最多
[輸出](客戶編號, *客戶名稱, 地址, 類別名稱, *訂購產品總數量)
[說明]
如果有相同訂購數量，要並列出來
*/
--【Solution】
select top 5 with ties c.客戶編號
			,公司名稱 as 客戶名稱
			, 地址, 類別名稱
			 , sum(數量) as 訂購產品總數量
from 客戶 as c, 訂單 as o, 訂單明細 as od, 產品資料 as p, 產品類別 as ca
where c.客戶編號 = o.客戶編號
		and o.訂單編號 = od.訂單編號
		and od.產品編號 = p.產品編號
		and p.類別編號 =ca.類別編號
		and ca.類別名稱 = '果汁'
group by c.客戶編號, 公司名稱,地址, 類別名稱
order by 訂購產品總數量 desc
go

/*
使用Group By子句的時候，一定要記住下面的一些規則：
（1）不能Group By非標量基元類型的列，
		  如不能Group By text，image或bit類型的列
（2）Select指定的每一列都應該出現在Group By子句中，
		   除非對這一列使用了彙總函式；
（3）不能Group By在表中不存在的列；
（4）進行分組前可以使用Where子句消除不滿足條件的行；
（5）使用Group By子句返回的組沒有特定的順序，
		  可以使用Order By子句指定次序。
*/

/*05【難易度 : ★★★☆☆】10%
請列出每一年的產品暢銷排行榜
[輸出](*年度, 類別名稱, 產品名稱, *銷售數量, *銷售排名, *備註說明)
[說明]
銷售排名 : 依據銷售數量，最高者為第1名 (使用 dense_rank())
備註 請依據名次來給定 備註說明
銷售排名 1-3 名 : 極暢銷
銷售排名 4-6 名 : 暢銷
其他            : 空白
*/

--【Solution】
select year(o.訂貨日期) as 年度
	, 類別名稱, 產品名稱
	, sum(od.數量) as 銷售數量
	, dense_rank() over (partition by year(o.訂貨日期) order by sum(od.數量) desc) as 銷售排名
	,case
	when dense_rank() over (partition by year(o.訂貨日期) order by sum(od.數量) desc) <=3 then '極度暢銷'
	 when dense_rank() over (partition by year(o.訂貨日期) order by sum(od.數量) desc) <=6 then '暢銷'
	else ''
	end as 備註說明
from 訂單 as o, 訂單明細 as od, 產品資料 as p, 產品類別 as ca
where o.訂單編號 = od.訂單編號
	and od.產品編號 = p.產品編號
	and p.類別編號 = ca.類別編號
group by year(o.訂貨日期),類別名稱,產品名稱
go

/*06【難易度 : ☆☆☆☆☆】10%
請計算每一個供應商提供給我們公司各有幾種不同的類別、產品項目數
[輸出](供應商編號, 供應商名稱, *不同產品類別數 , *不同產品數)
[排序]供應商編號 遞增
*/

--【Solution 1】

select s.供應商編號, s.供應商名稱
		,count(distinct p.類別編號)   as 不同產品類別數 
		,count(distinct p.產品名稱)  as 不同產品數
from 供應商 as s,  產品資料 as p,  產品類別 as ca
where s.供應商編號 =p.供應商編號
		and p.類別編號 =ca.類別編號
group by s.供應商編號, s.供應商名稱
order by s.供應商編號 asc
go

--【Solution 2】
select s.供應商編號, s.供應商名稱
		,count(distinct p.類別編號)   as 不同產品類別數 
		,count(distinct p.產品名稱)  as 不同產品數
from 供應商 as s
	 join 產品資料 as p on s.供應商編號 =p.供應商編號
	 join 產品類別 as ca on  p.類別編號 =ca.類別編號
group by s.供應商編號, s.供應商名稱
order by s.供應商編號 asc
go


/*07【難易度 : ★☆☆☆☆】10%
請查詢銷售至 台中市 的客戶當中，哪一項產品的利潤(銷售毛利)最高，同名要並列
[輸出](產品編號, 產品名稱, *銷售毛利)
*/

--【Solution】
 select top 1 with ties p.產品編號, p. 產品名稱
		,  sum(od.數量* (od.實際單價 - p.平均成本)) as 銷售毛利
 from 客戶 as c, 訂單 as o, 訂單明細 as od, 產品資料 as p
 where c.客戶編號 = o.客戶編號 
	and o.訂單編號 = od.訂單編號
	and od.產品編號 = p.產品編號
	and left(c.地址,3) = '台中市'
group by p.產品編號, p. 產品名稱
order by 銷售毛利 desc
go


/*08【難易度 : ☆☆☆☆☆】10%
請查詢 業務人員 的總業績
[輸出](*總業績)
[說明]
只要員工的 職稱 為 業務相關 的人員篩選出來
計算所有業務人員承接訂單的總金額，即為 總業績
*/
--【Solution】
select sum(od.實際單價*od.數量) as 總業績
from  員工 as e, 訂單 as o, 訂單明細 as od
 where e.員工編號 = o.員工編號
	and o.訂單編號 = od.訂單編號
	and e.職稱 like '%業務%'
go

--【複合題】------------------------------

/*09【難易度 : ★★★☆☆】20%
請依據以下的步驟完成此題
1. 將所附的 diabetes.csv 匯入你(妳)自己的 CH07範例資料庫, 資料表名稱為 diabetes (0%)
2. 請輸出所有的欄位，再新增一個 年齡區間 的欄位 (10%)
[輸出](懷孕, 血糖, 血壓, 皮膚厚度, 胰島素, BMI, 糖尿病譜系功能, 年齡, 結果, *年齡區間)
[說明]年齡區間為 0+, 10+, 20+, 30+, 40+, ..........
3. 為了想看此資料集的年齡分佈，請計算每一個年齡區間的人數 (10%)
[輸出](*年齡區間, *人數)
*/
--【Solution】
--09-1
--人工操作，不用寫出來

--09-2
select 懷孕, 血糖, 血壓, 皮膚厚度, 胰島素, BMI, 糖尿病譜系功能, 年齡, 結果
     , cast(年齡/10 as varchar)+'0+' as 年齡區間
from diabetes
go

--09-3
select cast(年齡/10 as varchar)+'0+' as 年齡區間, count(1) as 人數
from diabetes
group by cast(年齡/10 as varchar)+'0+'
go



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
			,datediff(year,e.出生日期,getdate()) as 年齡
			 ,'A' + cast(ntile(3) over (order by year(getdate())-year(e.出生日期) asc) as varchar) as 房號
from 員工 as e
where e.性別 = '男'
union
select 員工編號, 姓名, 性別
			,datediff(year,e.出生日期,getdate()) as 年齡
			 ,'B' + cast(ntile(2) over (order by year(getdate())-year(e.出生日期) asc) as varchar) as 房號
 from 員工 as e
 where e.性別 = '女'