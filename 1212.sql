--step 1. ���Ҧ���ƪ� (cross join)
--step 2. �i��join (inner join)
--step 3. �z�����(�ܸG)
--step 4. ��J��Ʀ�(�ܽG)
--step 5. �Ƨ�
--step 6. distinct ��(�B) top <n> [percent][with ties]

-- raw data (��l���)��
-----------------------
-- aggragate (�J�`���)�� 

--step 1. ���Ҧ���ƪ� (cross join)
--step 2. �i��join (inner join)
--step 3. �z�����(�ܸG), �w�� raw data �z��
--step 4. group by , �P�ɶ�J��Ʀ�(�ܽG)
--step 5. having �z�����w�� aggregate function
--step 6. �Ƨ�
--step 7. distinct ��(�B) top <n> [percent][wit ties]


use CH07�d�Ҹ�Ʈw;

/*group by ... having ...
aggregate funciton(�J�`�禡) : 
https://docs.microsoft.com/zh-tw/sql/t-sql/functions/aggregate-functions-transact-sql?view=sql-server-ver15
sum() : �[�`
avg() : ����
count() : �p��
min() : �̤p��
max() : �̤j��

�P�_�O�_��null����� isnull()
https://msdn.microsoft.com/en-us/library/ms184325.aspx
*/

/*
�Ш̾� �ʧO �p��H�U���
[��X](�ʧO, *�H��, *�����~��, *�̤p�~��, *�̤j�~��)
[�Ƨ�]�ʧO���W
*/
select * from ���u as e

select e.�ʧO
	  ,count(*) as �H��1 -- �ɶq���n��
	  ,count(e.���u�s��) as �H��2 -- �ϥ�PK,�]��PK���|��NULL,�ҥH�C�@�����|+1
	  ,count(e.�D��) as �H��3 --�ϥΫDPK ,�]���DPK���i�঳NULL,�ҥH���|�C�@����+1
     , count(1) as �H��4          -- �]�� 1 ���ONull�A�ҥH�C�@�����|�[1
     , count('abc') as �H��5      -- �]�� 'abc' ���ONull�A�ҥH�C�@�����|�[1
	  ,avg(datediff(year,e.�X�ͤ��,getdate())) as �����~��
	  ,min(datediff(year,e.�X�ͤ��,getdate())) as �̤p�~��
	  ,max(datediff(year,e.�X�ͤ��,getdate())) as �̤j�~��
from ���u as e
group by e.�ʧO
order by e.�ʧO asc


/*
�Эp��Ȥ�, �̾ڿ����p��q���`���B�P�`��Q
[��X](*����, *�~��, *�`���B, *�`��Q)
[�Ƨ�]�������W
*/
*/
select left(c.�a�}, 3) as ���� , year(o.�q�f���) as �~��
     , sum(od.��ڳ��*od.�ƶq) as �`���B
     , sum((od.��ڳ��-p.��������)*od.�ƶq) as �`��Q
from �Ȥ� as c, �q�� as o, �q����� as od, ���~��� as p
where c.�Ȥ�s��=o.�Ȥ�s��
  and o.�q��s��=od.�q��s��
  and od.���~�s��=p.���~�s��
group by left(c.�a�}, 3), year(o.�q�f���)
order by ���� asc
go

/*RFM�ҫ�
1.R : �̪�@�����O(Recency)�����
2.F : ���O�W�v(Frequency)          
3.M : ���O���B(Monetary))
http://wiki.mbalib.com/zh-tw/RFM�ҫ�

�~�ȸg�z�n�}�l��z�Ҧ����Ȥ��ơA�ҥH�и�T�H�������d�X�C�@��Ȥ�P�ڭ̩��Ӫ����p
[��X](�Ȥ�s��, ���q�W��, *�Ĥ@�����Ӥ��, *�̪�@�����Ӥ��, *���Ӧ���, *�`���B)
[�Ƨ�]�Ȥ�s�� ���W
*/
select * from �q�� as o

select c.�Ȥ�s��,c.���q�W�� 
	  ,min(o.�q�f���) as �Ĥ@�����Ӥ��
	  ,max(o.�q�f���) as �̪�@�����Ӥ��
	  ,count(o.�q��s��) as [���Ӧ���(���~)]
	  ,count(distinct o.�q��s��) as [���Ӧ���(���T)]
	  ,sum(od.��ڳ��*od.�ƶq) as �`���B
from �Ȥ� as c
	join �q�� as o on c.�Ȥ�s��=o.�Ȥ�s��
	join �q����� as od on o.�q��s�� = od.�q��s��
group by c.�Ȥ�s�� , c.���q�W��
order by c.�Ȥ�s�� asc

--�i�����H�W���~��]�j
select *
from �Ȥ� as c
     join �q�� as o on c.�Ȥ�s��=o.�Ȥ�s��
order by c.�Ȥ�s��
go

select *
from �Ȥ� as c
     join �q�� as o on c.�Ȥ�s��=o.�Ȥ�s��
     join �q����� as od on o.�q��s��=od.�q��s��
order by c.�Ȥ�s��
go

--�i�p�G�H�W�ĥ�outer join�A�H�Ȥᬰ�D�j
select c.�Ȥ�s��, c.���q�W��
     , min(o.�q�f���) as �Ĥ@�����Ӥ��
     , max(o.�q�f���) as �̪�@�����Ӥ��
     , count(o.�q��s��) as [���Ӧ���(���~)]
     , count(distinct o.�q��s��) as [���Ӧ���(���T)]
     , sum(od.��ڳ��*od.�ƶq) as �`���B
from �Ȥ� as c
     left join �q�� as o on c.�Ȥ�s��=o.�Ȥ�s��
     left join �q����� as od on o.�q��s��=od.�q��s��
group by c.�Ȥ�s��, c.���q�W��
order by c.�Ȥ�s�� asc
go


/*
�Эp����x�_��, �x�_��, �̪F��, �x�����Ȥ�󥻤��q�q���`���B�p�󵥩�1000�H�U�����
[��X](�Ȥ�s��, ���q�W��, *�Ҧb����, *�`���B)
[�Ƨ�]�`���B ����
[����]outer join
*/
select c.�Ȥ�s��, ���q�W��, left(c.�a�}, 3) as �Ҧb����
     , sum(od.��ڳ��*od.�ƶq) as �`���B1
     , isnull(sum(od.��ڳ��*od.�ƶq),0) as �`���B2 -- �B�znull�Ȭ�0
from �Ȥ� as c
     left join �q�� as o on c.�Ȥ�s��=o.�Ȥ�s��
     left join �q����� as od on o.�q��s��=od.�q��s��
where left(c.�a�}, 3) in ('�x�_��', '�x�_��', '�̪F��', '�x����')
group by c.�Ȥ�s��, ���q�W��, left(c.�a�}, 3)
having isnull(sum(od.��ڳ��*od.�ƶq), 0) <= 1000
-- HAVING �l�y�Ω�L�o���ի᪺�ƾڡA�Y�b��ƾڶi��E�X�p���A�z��X�ŦX���󪺲�
-- ���@�Ω���ա]GROUP BY�^�����G�ŧO�A�Ω�L�o���թλE�X�᪺���G
-- HAVING �i�H�ϥλE�X��ơA�]�����O�b�ƾڳQ�E�X������
-- WHERE �����ˬd���O�ӧO�O���A���i�H�ϥλE�X��ơA�p SUM()�BAVG() ��
order by �`���B1 desc
go



/*
SQL�y�� �q�`�i�H�����T�j��
DDL(Data Definition Language) : create / alter / drop
DML(Data Manipulation Languge) : select / insert / update / delete
DCL(Data Control Languge) : grant / revoke / deny
*/

--CH09 insert/update/delete
/*insert���|�ث��A
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

use CH09�d�Ҹ�Ʈw

--�s�W��Ʈɭn�S�O�`�N�A����insert�|���|�y�� PK ���Ъ����D
--�������ĳ���g�k�A�]�����ǬO�̾ڸ�Ʈw�������ǡA�U�@���ǲ��ʴN�|�X���D
insert into ���~���
values (13, 7, 'S0005', '���~�п�', 300, 250, 300,150)
go

insert into ���~��� (���~�s��, ���O�s��, �����ӽs��, ���~�W��, ��ĳ���, ��������, �w�s�q, �w���s�q)
values (14, 8, 'S0005', '�Ťs�g��@��', 35, 25, 500,200)
go

--�Y�O���Ncolumn name���C�X�Avalues�������ǭn�̾ڸ�column name
insert into ���~��� (���~�s��, ���~�W��, ���O�s��, �����ӽs��, ��ĳ���, ��������, �w�s�q, �w���s�q)
values (15, '�Ťs�g��@��', 8, 'S0005', 35, 25, 500,200)
go

--�Y�O��ƪ��]�w�w�]�ȡA�i�H��default�Ӫ��
insert into ���~��� (���~�s��, ���O�s��, �����ӽs��, ���~�W��, ��ĳ���, ��������, �w�s�q, �w���s�q)
values (16, 7, 'S0005', '������s', 850, 650, default, default)
go

--�γo�ӽm��
--�S���Ȫ�column�i�H���μg�X��
insert into ���~��� (���~�s��, ���O�s��, �����ӽs��, ���~�W��, ��ĳ���, ��������)
values (16, 7, 'S0005', '������s', 850, 650)
go

--�@���s�W�h�����
insert into ���~��� (���~�s��, ���O�s��, �����ӽs��, ���~�W��, ��ĳ���, ��������, �w�s�q, �w���s�q)
values (26, 8, 'S0004', '�����@�Y�@��', 50, 35, 100, default) ,
       (27, 7, 'S0001', '�³���s', 85, 65, default, default) ,
       (28, 7, 'S0005', '�Ͱ�s', 45, 35, 500, 150)
go

--values���]�i�H�ϥΨ��
insert into �q�� (�q��s��, ���u�s��, �Ȥ�s��, �q�f���, �w�p��f���, �I�ڤ覡, ��f�覡)
values ('98090201', 7, 'C0012', '2009/09/28', dateadd( day, 7, '2009/09/28' ), '�䲼', '�ֻ�')
go

--�s�W���s�W����ƪ�(�q��)�A�A�s�W�l��ƪ�(�q�����)
insert into �q�� (�q��s��, ���u�s��, �Ȥ�s��, �q�f���, �w�p��f���, �I�ڤ覡, ��f�覡)
values ('98120101', 7, 'C0005', '2009/12/01', '2009/12/10', '�䲼', '�ֻ�')
go

insert into �q����� (�q��s��, ���~�s��, ��ڳ��, �ƶq)
values ('98120101', 13, 270, 100) , 
       ('98120101', 14,  30, 150) , 
       ('98120101', 16,  50,  60)
go



/*
(2)
�q��L��ƪ�D���ƨӷs�W
insert [into] �w�g�s�b����ƪ� [(columns)]
select ... from ...

���

�D��X��ơA�g�J�@�ӷs����ƪ�(�ƥ�����s�b)
select * into ���s�b����ƪ�
from ...
where ...
...
*/
select * from T�k���u
go


--�i���I�jT�k���u ��ƪ����ƥ��s�b
insert into T�k���u
select e.���u�s��, e.�m�W, e.¾��, e.�ʧO
from ���u as e
where e.�ʧO='�k'
go

--�i���I�jT�k���u ��ƪ�ƥ�����s�b

drop table if exists T�k���u

select e.���u�s��, e.�m�W, e.¾��, e.�ʧO into T�k���u
from ���u as e
where e.�ʧO='�k'
go


drop table if exists T�C���Ȥ�

select c.�Ȥ�s��, ���q�W��, left(c.�a�}, 3) as �Ҧb����
     , sum(od.��ڳ��*od.�ƶq) as �`���B1
     , isnull(sum(od.��ڳ��*od.�ƶq),0) as �`���B2 into T�C���Ȥ�
from �Ȥ� as c
     left join �q�� as o on c.�Ȥ�s��=o.�Ȥ�s��
     left join �q����� as od on o.�q��s��=od.�q��s��
where left(c.�a�}, 3) in ('�x�_��', '�x�_��', '�̪F��', '�x����')
group by c.�Ȥ�s��, ���q�W��, left(c.�a�}, 3)
having isnull(sum(od.��ڳ��*od.�ƶq), 0) <= 1000
order by �`���B1 desc
go

select * from T�C���Ȥ�
go

--�s�b�w�Ф��i�H���檺�٤����i�{���j(program)
--�w�g����_�Ӫ��{���٤����i�{�ǡj(process)
--�C�@�� Process �|���W�@�L�G�� �iPID�j
--�bSQL SERVER�O�ĥ� �iSPID�j (Session Process ID)
--�u�n�ݨ� session �N��w�g�s�u���\�B�n�J����

exec sp_who2

--�Ȧs��ƪ��x�s�� �i��Ʈw�j\�i�t�θ�Ʈw�j\�itempdb�j\�i�Ȧs��ƪ�j
-- #tablename : �p��(private)���Ȧs��ƪ�A�u���۫ت�session�i�H�ϥΡAsession�_�u�N�۰ʳQ�R��
--##tablename : ����(public)���Ȧs��ƪ�A�Ҧ���session���i�H�ϥΡA��Ʈw�A�ȭ��s�ҰʴN�۰ʳQ�R��

--�iprivate�j
select e.���u�s��, e.�m�W, e.¾��, e.�ʧO into #�k���u
from ���u as e
where e.�ʧO='�k'
go

select * from #�k���u

--�ipublic�j
select e.���u�s��, e.�m�W, e.¾��, e.�ʧO into ##�k���u
from ���u as e
where e.�ʧO='�k'
go































