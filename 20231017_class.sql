use CH03�d�Ҹ�Ʈw; -- statement

use CH07�d�Ҹ�Ʈw
go

-- ���G����X
select 100+20, 30-60, 3*50, 10/5, 19.0/5, 19*1.0/5
go

-- �[�J column name
select 100+20    as �[�k
            ,30-60            ��k
			,3*50              ���k
			,19/5              [���k(�@)]
			,19.0/5           "���k(�G)"
			,19*1.0/5       [���k(�T)]
go

-- �|�ˤ��J
select round(84.94, 2)
          , round(84.94, 1)
		  -- , round(99.95, 1)
	      , round(84.94, 0)
	      , round(84.94,-1)  --���2��
go

--�Ѫ�O��ƨ��j -- �L����i��
select ceiling(59.3)
          , ceiling(59.8)
          , ceiling(-59.3)
          , ceiling(-59.8)
go

--�a�O��ƨ��p -- �L���󤣶i��
select floor(59.3)
          , floor(59.8)
          , floor(-59.3)
          , floor(-59.8)
go

--�}�����(square root)
select sqrt(16)
          , sqrt(floor(16.556))
		  , sqrt(16.556)
go

--����
select square(3)
          , square(11.25)
go

--�����
select abs(-69)
go

--����
select power(2,3)
go


/*
https://docs.microsoft.com/zh-tw/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-2019

-- CAST Syntax:  
CAST ( expression AS data_type [ ( length ) ] )  

-- CONVERT Syntax:  
CONVERT ( data_type [ ( length ) ] , expression [ , style ] )  
*/

select '�����Ѯv���~' + 18 + '���h�@�I�I'
--�i���~�T���j
--�T�� 245�A�h�� 16�A���A 1�A�� 117
--�N varchar �� '�����Ѯv���~' �ഫ��������� int �ɡA�ഫ���ѡC
go

-- The CAST() function converts a value (of any type) into a specified datatype.
-- �]�����~�T���A��ܱN�ƭȫ��� 18 �ഫ�� verchar�A�H�o��@�Ӧr�ꪺ���G
select '�����Ѯv���~' + cast(18 as varchar) + '���h�@�I�I' -- SELECT CAST(25.65 AS int)

-- The CONVERT() function converts a value (of any type) into a specified datatype
select '�����Ѯv���~' + convert(varchar, 18) + '���h�@�I�I'
go

select 99.95
     , cast(99.95 as numeric(5, 2))  -- 99.5 99.5
     , round(cast(99.95 as numeric(5, 2)), 1) -- 100.00
	 , round(cast(99.95 as numeric(5, 2)), 2) -- 99.95
go

select 99.95
     , cast(99.95 as numeric(4, 1))
go

--�`�Ϊ������� getdate() / dateadd() / datediff() / eomonth()
select getdate()          as ���Ѥ��
     , year(getdate())    as �褸�~
     , month(getdate())   as ��
     , day(getdate())     as ��
     -- , quarter(getdate()) 
     , (month(getdate())+2)/3         as �u�O1
     , ceiling(month(getdate())/3.0)  as �u�O2
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
     , datepart(quarter, getdate()) -- 4 (2023�~10��O�ĥ|�u)
go

select '2023/01/31'
     , dateadd(month, 1, '2023/01/31') -- 2023-02-28
     , dateadd(month, -1, '2023/01/31') -- 2022-12-31
go

select datediff(year, '2022/12/31', '2023/01/31') -- 1
     , datediff(month, '2022/10/31', '2023/01/31') -- 3
go

-- �o�Ӥ몺�̫�@��
select eomonth(getdate())

--�аݤU�Ӥ몺�Ĥ@�Ѥ������?
select getdate()
          , eomonth(getdate())
	      , dateadd(day, 1, eomonth(getdate()))



--�i�r��(string)��ơj
select left('abcdefghijk',3)                       --�q�r�ꪺ�����3�Ӧr
     , right('abcdefghijk',6)                      --�q�r�ꪺ�k���6�Ӧr
     , substring('abcdefghijk',2,5)                --�q�r�ꤤ����2�Ӧr�}�l��5�Ӧr
     , lower('abcdEFGHIJK')                        --�ഫ���p�g
     , upper('abcdEFGHIJK')                        --�ഫ���j�g
     , len('�o�Oabcd')                             --�p��r�ꪺ����length(�r��)
     , charindex('abc','abcdefghijkabcdefghijk')   --��'abc'�b�r��'abcdefghijkabcdefghijk'�Ĥ@���X�{����m
     , charindex('abc','abcdefghijkabcdefghijk',2) --��'abc'�b�r��'abcdefghijkabcdefghijk'���A�q��2�Ӧr�᭱�Ĥ@���X�{����m
     , charindex('abb','abcdefghijkabcdefghijk')   --�䤣��|�^��0
     , replace('abcdefcdg','cd','xxxxx')           --�N'cd'��'x'���N
     , replace('abcdefcdg','cd','')                --�N'cd'�ΪŦr����N�A�]�N�O�N'cd'�h��
     , replicate('abc',5)                          --'abc'����5��
go

/*
�бN���Ѥ��(2023/10/17)�ഫ�� ����112�~010��017�� �P���G
*/

select getdate()
     , year(getdate())-1911  -- 112
     , month(getdate()) --10
     , day(getdate()) --17
     , datepart(weekday, getdate()) --3
go

select getdate()
     , '����'+cast(year(getdate())-1911 as varchar)+'�~'
     , cast(month(getdate()) as varchar) + '��'
     , cast(day(getdate()) as varchar) + '��'
     , datepart(weekday, getdate())
go

--�i�ۨ�����Q�@�Q�j�p���0
select '000'+'3' -- 0003
     , '000'+'12' --- 00012

-- �q�k��}�l���T�ӼƦr�X��
select right('000'+'3', 3) -- 003
     , right('000'+'12', 3) -- 012
go

select getdate()
     , '����'+cast(year(getdate())-1911 as varchar)+'�~'
     + right('000'+cast(month(getdate()) as varchar), 3) + '��'
     + right('000'+cast(day(getdate()) as varchar), 3) + '��'
     , datepart(weekday, getdate())
go

--�i�ۨ�����Q�@�Q�j�p���ഫ�P��
select getdate()
          , datepart(weekday, getdate())
          , case datepart(weekday, getdate())
		          when 1 then '��'
				  when 2 then '�@'
				  when 3 then '�G'
				  when 4 then '�T'
				  when 5 then '�|'
				  when 6 then '��'
				  when 7 then '��'
			end

select '��@�G�T�|����'
          , substring( '��@�G�T�|����', 3, 1) -- �G
		  , substring( '��@�G�T�|����', datepart(weekday, getdate()), 1)
go


select getdate()
     , '����'+cast(year(getdate())-1911 as varchar)+'�~'
     + right('000'+cast(month(getdate()) as varchar), 3) + '��'
     + right('000'+cast(day(getdate()) as varchar), 3) + '��'
	 + ' '
     + '�P��' + substring( '��@�G�T�|����', datepart(weekday, getdate()), 1)
go

--�i�ϥ� format() ��ƳB�z�� 0 ���D�j
select format(3, '00')

select getdate()
     , format(3, '000')
     , '����'+cast(year(getdate())-1911 as varchar) + '�~'
     + format(month(getdate()), '0##��')
     + format(day(getdate()), '0##��')
     + ' �P��'+substring('��@�G�T�|����', datepart(weekday, getdate()), 1)
go

/*
�Ьd�ߥ��u�جP���򥻸��
[��X](���u�s��, *���u�m�W, �ʧO, �X�ͤ��, *����X�ͤ��)
*/
--step 1 : ��X��ƪ�
select *
from ���u as e
go

--step 2 : �z�����(�ܸG)
select *
from ���u as e
where datepart(quarter, getdate()) = datepart(quarter, e.�X�ͤ��)
go

select ���u�s��, �m�W as ���u�m�W, �ʧO, �X�ͤ��
          , ??? as ����X�ͤ��
from ���u as e
where datepart(quarter, getdate()) = datepart(quarter, e.�X�ͤ��)
go

--step 3 : ��J��Ʀ�(�ܽG)
select ���u�s��, �m�W as ���u�m�W, �ʧO, �X�ͤ��
     , ??? as ����X�ͤ��
from ���u as e
where datepart(quarter, getdate()) = datepart(quarter, e.�X�ͤ��)
go

select ���u�s��, �m�W as ���u�m�W, �ʧO, �X�ͤ��
     , '����'+cast(year(�X�ͤ��)-1911 as varchar) + '�~'
     + format(month(�X�ͤ��), '0##��')
     + format(day(�X�ͤ��), '0##��')
     + ' �P��'+substring('��@�G�T�|����', datepart(weekday, �X�ͤ��), 1) as ����X�ͤ��
from ���u as e
where datepart(quarter, getdate()) = datepart(quarter, e.�X�ͤ��)
go




