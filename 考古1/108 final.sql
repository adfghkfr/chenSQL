/*
108�Ǧ~�ײĤ@�Ǵ� �O�_�j�ǲέp�t�P�Ӥh�Z ��Ʈw���λP�ӷ~���z���R �ҵ{ �����Ҹ� �Ѯv�G������ (HsiangHui.Chen@gmail.com)

�ǥ;Ǹ��G410678031	
�ǥͩm�W�G�d�~�\
�q���W�١G1MF10-38

�`�N�ƶ��G
1.�Х��N���ɮק��W�٬� : final+�Ǹ��G�A�Ҧp�Gfinal123456789.sql�A��ť�̽ж�g final��ť������.sql
2.�H�U�Х�CH07�d�Ҹ�Ʈw�A���D���S�O���w
3.��X�ݩʦW�٫e�Y�O�� * �N��O �O�W �� �l�� �ݩ�
4.�кɶq�F���ϩR, �Ш̴`�B�J���A(�p)���y�k�O�i�H���檺�C
5.���i���檺�{���H0���p�A�i���檺�{���~���i�ೡ���|���������ơA�Y�O�h�Ӹ�ƪ�������join��~���������ơC
6.�����зǡA�|�]���C�@�D�����ߤ��P�A�|���Үt��
7.�����׶ȨѰѦҡA�|�]�ӤH�Ӳ�
8.�Ҹծɶ�  18�G10��21�G00
*/

use ch07�d�Ҹ�Ʈw;

/*01�i������ : �����������j10%
�ѩ󤽥q�~�׭n�|��ȹC, �������k, �k���u���O���t��J�и�, �k�k���s�U�ۨ̾ڦ~�ֻ��W�ƧǨӤ��s
�ѩ󥻤��q�k�͸��h�A�ҥH���t�T���A�k�͸��֡A�ҥH���t�ⶡ�p�U : 
�k�ͩи��� : A1, A2, A3
�k�ͩи��� : B1, B2
[��X](���u�s��, �m�W, �ʧO, �~��, *�и�)
[�Ƨ�]�Х��̾� �ʧO ���W�A�A�� �~�� ���W
[����]�ϥ�ranking function����ntile
*/

--�iMy Solution�j
select ���u�s��, �m�W, �ʧO
			,datediff(year, e.�X�ͤ��, getdate()) as  �~��
			, 'B' + cast(ntile(2) over (order by datediff(year, e.�X�ͤ��, getdate()) asc) as varchar)   as �и�
from ���u as e
where e.�ʧO = '�k'
union
select ���u�s��, �m�W, �ʧO
			,datediff(year, e.�X�ͤ��, getdate()) as  �~��
			, 'A' + cast(ntile(3) over (order by datediff(year, e.�X�ͤ��, getdate()) asc) as varchar)  as �и�
from ���u as e
where e.�ʧO = '�k'
order by  �ʧO asc, �~�� desc
go


--�iDoc Solution�j
select ���u�s��, �m�W, �ʧO, datediff(year, �X�ͤ��, getdate()) as �~��
     , ntile(3) over(order by datediff(year, �X�ͤ��, getdate())) as �и�
from ���u
where �ʧO='�k'
union
select ���u�s��, �m�W, �ʧO, datediff(year, �X�ͤ��, getdate()) as �~��
     , ntile(2) over(order by datediff(year, �X�ͤ��, getdate())) as �и�
from ���u
where �ʧO='�k'

/*02�i������ : �����������j10%
�p�G�ڭ̤��q���u��¾�Ȥ����T�h�A�q�W�ӤU�٤����W�h�B���h�P��h
�м��g�@�ӹw�s�{�ǦW�� spEmp+�Ǹ� 
[��X](�W�h���u�s��, �W�h���u�m�W, ���h���u�s��, ���h���u�m�W, ��h���u�s��, ��h���u�m�W)
[�Ѽ�]@name : �W�h���u�m�W
[����]
1.�i�H��J�Y�S�w�� �W�h���u�m�W �d�ߩ��ݤU��h�����u���(���i��|�ONULL)
2.�i�H����J�ѼƭȡA�N�O�d�ߩҦ����u���ݤU��h�����u���(���i��|�ONULL)
*/

--�iMy Solution�j
create or alter proc spEmp711133120
as
select �W�h.���u�s�� as �W�h���u�s�� , �W�h.�m�W as �W�h���u�m�W
		, ���h.���u�s�� as ���h���u�s�� , ���h.�m�W as ���h���u�m�W
		, ��h.���u�s�� as ��h���u�s��, ��h.�m�W as ��h���u�m�W
from ���u as ��h
		left join  ���u as ���h on ��h.�D�� = ���h.���u�s��
		left join  ���u as �W�h on ���h.�D�� = �W�h.���u�s��
go

exec spEmp711133120

--�iDoc Solution�j
create or alter proc spEmp410678052
@name varchar(max)=null
as
select e1.���u�s��, e1.�m�W, e2.���u�s��, e2.�m�W, e3.���u�s��, e3.�m�W
from ���u as e1 left join ���u as e2 
on e1.���u�s��=e2.�D��
left join ���u as e3
on e2.���u�s��=e3.�D��
where e1.�m�W = @name or @name is null
go

exec spEmp410678052 �J�X��
exec spEmp410678052


/*03�i������ : �����������j10%
�Ьd��2005�~�Ҧ����u�ӱ��q�檺������T�A�S���ӱ������q�檺���u�]�n�X�{
[��X](���u�s��, �m�W, *�ӱ��q��ƶq, *�`���B, *�`��Q)
[�Ƨ�]�̾� ���u�s�� ���W
[���n]�ϥ� CTE(Common Table Expression) ���g�k
*/

--�iMy Solution�j

select e.���u�s��, �m�W
	, count(distinct o.�q��s��) as �ӱ��q��ƶq
	, sum(od.��ڳ��*od.�ƶq) as �`���B
	, sum((od.��ڳ��- p.��������)*od.�ƶq) as �`��Q
from ���u as e
	left join �q�� as o on e.���u�s��=o.���u�s��
	left join �q����� as od on o.�q��s��=od.�q��s��
	left join ���~��� as p on od.���~�s�� = p.���~�s��
where year(o.�q�f��� ) = 2005 
	or  year(o.�q�f��� )  is null
group by  e.���u�s��, �m�W, year(o.�q�f���) 
order by e.���u�s�� desc
go



--�iDoc Solution�j
;with
cte_�ӱ��q��ƶq
as (select ���u�s��, count(1) as �ӱ��q��ƶq
from  �q��
group by ���u�s��)
,
cte_�`���B�M�`��Q
as (select ���u�s��, sum(��ڳ��*�ƶq) as �`���B, sum((��ڳ��-��������)*�ƶq) as �`��Q
from �q�� as o left join �q����� as od on o.�q��s��=od.�q��s�� left join ���~��� as p on od.���~�s��=p.���~�s��
group by ���u�s��
)
select *
from ���u as e left join cte_�ӱ��q��ƶq as o on e.���u�s��=o.���u�s��
               left join cte_�`���B�M�`��Q as od on e.���u�s��=od.���u�s��
go


/*04�i������ : �����������j10%
�Ш̾ڥH�U���A�ӭp��, �d�ݨC�@�ت��A�����~��
[��X](*���A, *���~��)
[���A����]
�w�s�q<=0                    '�s�w�s'
0<�w�s�q<=�w���s�q/3         '�w�s�q�Y������'
�w���s�q/3<�w�s�q<=�w���s�q  '�w�s�q����'
�w���s�q<�w�s�q<=�w���s�q*3  '�w�s�q�R��'
�w���s�q*3<�w�s�q            '�w�s�q�L��'
*/

--�iMy Solution 1�j 
select  *, count(1) as �ƶq
from
(select case 
			when �w�s�q <=0 then '�s�w�s'
			when (�w���s�q/3 < �w�s�q) and (�w�s�q  <= �w���s�q) then  '�w�s�q����'
			when (�w���s�q/3<�w�s�q) and (�w�s�q<= �w���s�q) then  '�w�s�q����'
			when (�w���s�q<�w�s�q) and (�w�s�q <= �w���s�q*3) then  '�w�s�q�R��'
			when  �w���s�q*3 < �w�s�q then '�w�s�q�L��'
			end as ���A
		 -- , ���~��
from ���~��� as p  ) as e
group by ���A
go

--�iMy Solution 2�j 
select case 
			when �w�s�q <=0 then '�s�w�s'
			when (�w���s�q/3 < �w�s�q) and (�w�s�q  <= �w���s�q) then  '�w�s�q����'
			when (�w���s�q/3<�w�s�q) and (�w�s�q<= �w���s�q) then  '�w�s�q����'
			when (�w���s�q<�w�s�q) and (�w�s�q <= �w���s�q*3) then  '�w�s�q�R��'
			when  �w���s�q*3 < �w�s�q then '�w�s�q�L��'
			end as ���A
		  , count(1) as ���~��
from ���~��� as p
group by case 
			when �w�s�q <=0 then '�s�w�s'
			when (�w���s�q/3 < �w�s�q) and (�w�s�q  <= �w���s�q) then  '�w�s�q����'
			when (�w���s�q/3<�w�s�q) and (�w�s�q<= �w���s�q) then  '�w�s�q����'
			when (�w���s�q<�w�s�q) and (�w�s�q <= �w���s�q*3) then  '�w�s�q�R��'
			when  �w���s�q*3 < �w�s�q then '�w�s�q�L��'
			end
go


/*05�i������ : �����������j10%
�Ш�U�إߤ@�Ө�ƦW�� fn+�Ǹ�, ��\��N�O�^�ǤU�@�ӷs�������ӽs��
[��X���G]���ӷ|�O 'S0006'
*/


/*06�i������ : �����������j10%
�Ш̾ڥH�U�B�J�Ӷi��
1. �N CH11�d�Ҹ�Ʈw ���� [���u���y��] ��ƪ�copy���c(���O�u�����c���n���) �� CH07�d�Ҹ�Ʈw, ��ƪ�W�٬� [���u���y��+�Ǹ�]
   �ХH�Ҧb CH07�d�Ҹ�Ʈw ���D����g�y�k
2. �q [���u] ��ƪ��D��~�꺡15�~(�t)�����u�[�J [���u���y��] ��ƪ��A[�~��] ��Ʀ�ж�J�����Ѫ��~��
   ���έp��~��O�_���~, �����~�׬۴�Y�i
3. �Ш̾ڥH�U�����s [����] 
   * �~��j�󵥩�15, �p��20 : 10000
   * �~��j�󵥩�20, �p��25 : 20000
   * �~��j�󵥩�25 : 30000
[����]update...set ���i�H�ϥ� CASE ... END
*/

--�iMy Solution�j

use CH11�d�Ҹ�Ʈw
select b.���u�s��, b.�~��, b.���� into CH07�d�Ҹ�Ʈw.dbo.���u���y��711133120
from ���u���y�� as b
where 1=0
go

use CH07�d�Ҹ�Ʈw
insert into ���u���y��711133120 (���u�s��)
select e.���u�s��
from ���u as e
where datediff(year,e.���Τ��, getdate()) >= 15
go


update ���u���y��711133120 
set �~��= year(getdate())
   , ���� = (case
when (datediff(year,e.���Τ��, getdate())>=15) and (datediff(year,e.���Τ��, getdate()) <20)  then 10000
when  (datediff(year,e.���Τ��, getdate())>=20) and (datediff(year,e.���Τ��, getdate()) <25)  then 20000
when (datediff(year,e.���Τ��, getdate())>=25)  then  30000
end)
from ���u as e
where e.���u�s�� =  ���u���y��711133120 .���u�s��
go



select e.���u�s��, datediff(year,e.���Τ��, getdate()) as �~��
from ���u as e
where datediff(year,e.���Τ��, getdate()) >= 15
go

--�H�U�O�d�ߵ��G


/*07�i������ : �����������j20% ��ƶפJ�B��ƾ�z�P�������
HeartWithNum.csv �ɮץ]�t14���ݩʡC
�ؼ��ݩ� "�ʯߵw�Ʃʤ�Ŧ�f" �O���w�̤��s�b��Ŧ�f�����СC
������ƭȱq0 (���`) �� 4 (1,2,3,4���ݩ󤣥��`)
�J�Q�����ƾڮw�����綰����²��a���հϤ���Ŧ�f���s�b(��1,2,3,4)�M���s�b(��0)

�Х��N HeartWithNum.csv �ɮ׷Q��k�פJ CH07�d�Ҹ�Ʈw��
�פJ��A�`�Nheader�W�٤��i�H�t���޸�

[��X](*�O�_��Ŧ�f, *�O�_�a�������h��, *�H��)
[�Ƨ�]�O�_��Ŧ�f ���W, �O�_�a�������h�� ���W
[����]
�ʯߵw�Ʃʤ�Ŧ�f : ���ӥX�{ 
   �s�b(��1,2,3,4) 
   ���s�b(��0)
�a�������h�� : 
   ���` : value 3.0
   �T�w�ʳ� : value 6.0
   �i�f�ʳ� : value 7.0

��ƥi�ण����A�ҥH��ĳ���d�߸�ƪ�
1. �ʯߵw�Ʃʤ�Ŧ�f�����X��
2. �a�������h�妳���X��
�H�W��̦U�O���d�ߤ]�i�����j�n���g�X��(�S�g�|�����A�g�X�Ӥ�����)
*/
--1. �ʯߵw�Ʃʤ�Ŧ�f�����X��

--�iMy Solution�j

--  All
select *
from HeartWithNum as h

-- �ʯߵw�Ʃʤ�Ŧ�f�����X�� (0,1,2,3,4)
select distinct �ʯߵw�Ʃʤ�Ŧ�f
from HeartWithNum as h

-- �a�������h�妳���X�� (Null, 3, ,6 ,7)
select distinct �a�������h��
from HeartWithNum as h

--  Answer
select*, count(1) as �ƶq
from 
(select case
when �ʯߵw�Ʃʤ�Ŧ�f =0 then '���s�b'
else '�s�b'
end as �O�_��Ŧ�f
,case
when �a�������h�� = 3 then '���`'
when �a�������h�� = 6 then '�T�w�ʳ�'
when �a�������h�� = 7 then '�i�f�ʳ�'
when �a�������h�� is null then 'null'
end as �O�_�a�������h��
from HeartWithNum as h) as a
group by �O�_��Ŧ�f, �O�_�a�������h��
order by �O�_��Ŧ�f asc, �O�_�a�������h�� desc
go


--�iDoc Solution�j
select distinct �ʯߵw�Ʃʤ�Ŧ�f
from HeartWithNum

--2. �a�������h�妳���X��
select distinct �a�������h��
from HeartWithNum


select �O�_��Ŧ�f, �O�_�a�������h��, count(1) as �H��
from(
select *
     , iif(�ʯߵw�Ʃʤ�Ŧ�f=0,'���s�b','�s�b') as �O�_��Ŧ�f
	 , case 
			when �a�������h��='3.0' then '���`'
			when �a�������h��='6.0' then '�T�w�ʳ�'
			when �a�������h��='7.0' then '�i�f�ʳ�'
			else '�S�����'
	   end as �O�_�a�������h��
from HeartWithNum) as a
group by �O�_��Ŧ�f, �O�_�a�������h��
order by �O�_��Ŧ�f, �O�_�a�������h��


/*08�i������ : �����������j20%
�м��g�@�ӹw�s�{�ǦW�٬� spBackUp+�Ǹ� 
�N CH07�d�Ҹ�Ʈw��(���Fsysdiagrams���~) �Ҧ�����ƪ�P��Ƥ��e�@�@�ۼg�� tempDB �� public�Ȯɸ�ƪ�
���O!! �ӹw�s�{�ǥ����i�H���ư���~�⦨�\
���藍�i�H�ϥΤ�ʤ@�Ӥ@��select ... into ##table ...
�]���A�����D�Ӹ�Ʈw����ɤS�|�s�W��ƪ�(�ʺA��)
[����]
1.�i�H�ϥΨt���˵��� sys.tables �ʺA�d�o�Ӹ�Ʈw�������Ǹ�ƪ�
2.�ϥ�cursor���覡�@�Ӥ@�Ӹ�ƪ� select ... into ##table ...
3.select * from sys.tables                       --�i�H�d��Ӹ�Ʈw�����Ǹ�ƪ�A�����ư�sysdiagrams
4.select object_id('tempdb.dbo.##�Ȥ�','table')  --�P�_�Ȧs��ƪ�O�_�s�b
*/

Declare @table varchar(max)
DECLARE tb CURSOR FOR
select name
from sys.tables
where name<>'sysdiagrams';
open tb 
FETCH NEXT FROM tb
INTO @table
declare @select varchar(max)
WHILE @@FETCH_STATUS = 0
BEGIN
	set @select = 'select * into tempdb.dbo.' + @table + ' from ' + @table
    exec(@select)
	FETCH NEXT FROM tb INTO @table
END
CLOSE tb;
DEALLOCATE tb;



select * into tempdb.dbo.���u
from ���u

declare @den nvarchar(100) = ''
declare @from nvarchar(100) = ''
declare @name nvarchar(100) = ''
declare @a nvarchar(100) = ''
declare @end int=0
declare @start int=0
declare @cnter int=-1
select  @name = @name +iif(@name='','' ,',' )+s.name
from sys.tables as s
print @name


STRING_SPLIT ( string , separator [ , enable_ordinal ] ) 





