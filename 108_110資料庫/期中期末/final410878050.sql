	/*
110�Ǧ~�ײĤ@�Ǵ� �O�_�j�ǲέp�t(��) �i��Ʈw���λP�ӷ~���z���R�j �ҵ{ �����Ҹ� �Ѯv�G������

�ǥ;Ǹ��G410878050	
�ǥͩm�W�G���G��

�`�N�ƶ��G
1.�Х��N���ɮק��W�٬� : final+�Ǹ��G�A�Ҧp�Gfinal12345678.sql
2.���Žƻs�W�ҵ{���i��ק�A�@���o�{���P�@���סA�|�˦����D����
3.�C�@�D�u�঳�@�ӵ��סA���űN�L�{�d�b���D�W�A�_�h�u�|�H�Ĥ@�Өӵ���
4.�H�U�Х�CH07�d�Ҹ�Ʈw�A���D���S�O���w
5.��X�ݩʦW�٫e�Y�O�� * �N��O �O�W �� �l�� �ݩ�
6.�кɶq�F���ϩR, �Ш̴`�B�J���A(�p)���y�k�O�i�H���檺�C
7.���i���檺�{���H0���p�A�i���檺�{���~���i�ೡ���|���������ơA�Y�O�h�Ӹ�ƪ�������join��~���������ơC
8.�����зǡA�|�]���C�@�D�����I���P�A�|���Үt��
9.�����׶ȨѰѦҡA�|�]�ӤH�Ӳ�
10.�Ҧ��w�s�{�ǬҨϥ� create or alter proc ...
*/

use CH07�d�Ҹ�Ʈw;

/*01�i������ : �����������j10%
�Ч�X���X�����q���ơA�o�S���q����Ӫ����
[��X](�q��s��, �q�f���, *�ӿ���u�m�W)
[�Ƨ�]�q��s�����W
*/
select o.�q��s��, �q�f���, e.�m�W as �ӿ���u�m�W
from �q�� as o
	left join �q����� as od on o.�q��s��= od.�q��s��
	left join ���u as e on  o.���u�s��= e.���u�s��
where od.�q��s�� is null
go


/*02�i������ : �����������j10%
�Ьd�ߴ��g�q�ʹL �Q�s�� �M �@�� �ⶵ���~(��̬Ҧ��q�ʹL) ���h�֮a�Ȥ��
[��X](*�Ȥ��)
[����]
1. (1)��X�q�ʹL �Q�s��, (2)��X�q�ʹL �@�� ���Ȥ���
2. �N�H�W��̧Q�� intersect ��X�涰�A�N�O��̬Ҧ��q�ʹL���Ȥ���
3. �N�H�W�� intersect ���l�d�ߡA�p�ⵧ��
*/

select c.�Ȥ�s��
from ���~��� as p, �q����� as od, �q�� as  o, �Ȥ� as c
where p.���~�s��= od.���~�s��
	 and od.�q��s��= o.�q��s��
	 and o.�Ȥ�s��= c.�Ȥ�s��
	 and p.���~�W��= '�Q�s��'
intersect
select c.�Ȥ�s��
from ���~��� as p, �q����� as od, �q�� as  o, �Ȥ� as c
where p.���~�s��= od.���~�s��
	 and od.�q��s��= o.�q��s��
	 and o.�Ȥ�s��= c.�Ȥ�s��
	 and p.���~�W��= '�@��'
go



/*03�i������ : �����������j10%
�Ыإߤ@�ӹw�s�{�ǡisp+�Ǹ�_exam03�j�A�i�H��J�_�B���~�� �P �_�B���~��Ӭd�߭��u���
[��X](���u�s��, �m�W, �X�ͤ��, ���Τ��, *�~��, *�~��)
[�Ѽ�]
@�_�~��, @���~��, @�_�~��, @���~��
[�Ѽƿ�J���������]
1.��J�_�B���~�� : �_�~�� <= �~�� and �~�� <= ���~��
2.�u��J�_�~�� : �~�� >= �_�~��
3.�u��J���~�� : �~�� <= ���~��
4.�_�B���~�ֳ��S����J : ����

1.��J�_�B���~�� : �_�~�� <= �~�� and �~�� <= ���~��
2.�u��J�_�~�� : �~�� >= �_�~��
3.�u��J���~�� : �~�� <= ���~��
4.�_�B���~�곣�S����J : ����

[����]
1. �~�ֻP�~�ꤣ�κ��A�u�n�褸�~�۴�Y�i
2. �~�ֻP�~�����@�ӱ��󦨥ߧY�i
*/
--�iSolution�j
create or alter proc sp410878050_exam03
@�_�~�� int=null,  @���~�� int=null, @�_�~�� int=null,  @���~�� int=null
as
select ���u�s��, �m�W, �X�ͤ��, ���Τ��
	 , datediff(year, e.�X�ͤ��, getdate()) as �~��
	 , datediff(year, e.���Τ��, getdate()) as �~��
from ���u as e
where ((@�_�~�� is null or datediff(year, e.�X�ͤ��, getdate()) >= @�_�~��)
  and (@���~�� is null or datediff(year, e.�X�ͤ��, getdate()) <= @���~��))
  or 
  ((@�_�~�� is null or datediff(year, e.���Τ��, getdate()) >= @�_�~��)
  and (@���~�� is null or datediff(year, e.���Τ��, getdate()) <= @���~��))

go


--�i���檺�����j���O!! �n���w�s�{�Ǥ��Ǹ�������
--�d�ߩҦ����u
exec sp410878050_exam03

--�d�ߦ~��>=65 �� �~��>=25�����u
exec sp410878050_exam03 @�_�~��=65, @�_�~��=25 

--�d�ߦ~�֤���65-68���� �� �~�ꤶ�� 25-28 ����
exec sp410878050_exam03 @�_�~��=65, @���~��=68, @�_�~��=25, @���~��=28

--�d�ߦ~��<=50 �� �~�� <=25
exec sp410878050_exam03 @���~��=50, @���~��=25
go


/*04�i������ : �����������j10%
�м��g�@�ӹw�s�{�� �isp+�Ǹ�_exam04�j �i�H�d�߬Y�@�~�A�q���P��L�����~�A���@�����O�����~�Ƴ̦h�A�P�W�n�æC
[��X](���O�s��, ���O�W��, *�~��, *������X�����~��)
[�Ѽ�]@year
*/

create or alter proc sp410878050_exam04
@year int
as
select ca.���O�s��, ���O�W��, �~��=@year, ���~�W�� as ������X�����~��
from ���~���O as ca
	inner join ���~��� as p on ca.���O�s��= p.���O�s��
	left join (select distinct od.���~�s��, o.�q��s��, year(o.�q�f���) as �~��
                from �q�� as o, �q����� as od
                where o.�q��s��=od.�q��s��
                  and year(o.�q�f���)=@year) as od on p.���~�s��=od.���~�s��
where od.���~�s�� is null
go

--�i���檺�����j���O!! �n���w�s�{�Ǥ��Ǹ�������
exec sp410878050_exam04 2005
exec sp410878050_exam04 2006




/*05�i������ : �����������j10%
�ЦC�X��ĳ��� �j�󵥩� �Ҧ����~��������ĳ��� �����~���
[��X](���O�s��, ���O�W��, ���~�s��, ���~�W��, ��ĳ���, *�Ҧ����~��������ĳ���)
*/
select ca.���O�s��, ���O�W��, ���~�s��, ���~�W��, ��ĳ���
	  , (select avg(p.��ĳ���) from ���~��� as p) as �Ҧ����~��������ĳ���
from ���~��� as p, ���~���O as ca
where ca.���O�s��= p.���O�s��
	 and p.��ĳ���>= (select avg(p.��ĳ���) from ���~��� as p)
go



/*06�i������ : �����������j10%
�����q���F�o��q�Ѭz�K�A�Ш̾ڥH�U�B�J�Ӷi��
1. �N CH11�d�Ҹ�Ʈw ���� [���u���y��] ��ƪ�copy���c(���O�u�����c���n���) �� �p���Ȧs��ƪ�, ��ƪ�W�٬� #���u���y��+�Ǹ�
2. �q [���u] ��ƪ��D��~�֤j�󵥩�50�������u�[�J #���u���y��+�Ǹ� ��ƪ��A[�~��]��Ʀ�ж�J�����Ѫ��~��
   ���έp��~�֬O�_���~, �����~�׬۴�Y�i
3. �Ш̾ڥH�U�����s [����] 
   * �~��j�󵥩�30 : 30000
   * �~��j�󵥩�25, �p��30 : 20000
   * �~��j�󵥩�20, �p��25 : 10000
   * ��L :  5000
*/
drop table if exists #���u���y��410878050

select* into #���u���y��410878050
from CH11�d�Ҹ�Ʈw.dbo.���u���y��
where 1=3

insert into #���u���y��410878050  (���u�s��, �~��, ����)
select e.���u�s��, year(getdate()), null
from ���u as e
where datediff(year, e.�X�ͤ��, getdate())>= 50
go

update #���u���y��410878050
set ����= case
			when datediff(year, e.���Τ��, getdate())>= 30 then 30000
			when datediff(year, e.���Τ��, getdate())>= 25 then 20000
			when datediff(year, e.���Τ��, getdate())>= 20 then 10000
			else 5000
			end
from ���u as e, #���u���y��410878050 as p
where e.���u�s��= p.���u�s��
go


--�i�d�ߵ��G�j���O!! �n���Ȧs��ƪ��Ǹ�������
select* from #���u���y��410878050
go


/*07�i������ : �����������j20%
�Ш̾ڨk�B�k���}�A�̾ڥX�ͤ�����W�ƧǡA��X�C�@��P�U�@�쪺�~�֮t�Z
[��X](���u�s��, �m�W, �ʧO, �X�ͤ��, *�e�@�쪺�X�ͤ��, *��@�쪺�X�ͤ��)
[�Ƨ�]�ʧO���W, �X�ͤ�����W
[����]�i�H�ϥ�self-join + outer join�A���u��ƪ��t��Ө���
[����]�Шϥ�CTE�Ӽ��g���D
*/
select e1.���u�s��, e1.�m�W, e1.�ʧO, e1.�X�ͤ��, e2.�X�ͤ�� as �e�@�쪺�X�ͤ��, e3.�X�ͤ�� as ��@�쪺�X�ͤ��
from ���u as e1
	left join (�e�@��X�ͪ����u) as e2 on e1.�X�ͤ��= e2.�X�ͤ��
	left join (��@��X�ͪ����u) as e3 on e1.�X�ͤ��= e3.�X�ͤ��

where e1.�ʧO= '�k'
order by e1.�X�ͤ��
union
select e1.���u�s��, e1.�m�W, e1.�ʧO, e1.�X�ͤ��, e2.�X�ͤ�� as �e�@�쪺�X�ͤ��, e3.�X�ͤ�� as ��@�쪺�X�ͤ��
from ���u as e1
	left join (�e�@��X�ͪ����u) as e2 on e1.�X�ͤ��= e2.�X�ͤ��
	left join (��@��X�ͪ����u) as e3 on e1.�X�ͤ��= e3.�X�ͤ��

where e1.�ʧO= '�k'
order by e1.�X�ͤ��
go


--��@��Ǹ�
select e1.���u�s��, e1.�m�W, e1.�ʧO, e1.�X�ͤ��, e2.�X�ͤ��
	, row_number() over (order by e1.�X�ͤ�� asc)  as �Ǹ� 
	, iif(row_number() over (order by e1.�X�ͤ�� asc)=7, 1, row_number() over (order by e1.�X�ͤ�� asc)+ 1 )as ��@��Ǹ� 
from ���u as e1
	left join ���u as e2 on e1.�X�ͤ��= e2.�X�ͤ��
where e1.�ʧO= '�k'
order by e1.�X�ͤ��




/*08�i������ : �����������j20%
1.�Х��N exam08DB ��Ʈw���[�ܧA(�p)��MS SQL SERVER
2.�i�H�̾�Exam08_ER_Model.jpg�ΥH�U�����A�N��Ƥ@�@��ܬ۹�������ƪ�
  �iBOOK�j�iDEPNAME�j�iLOAN�j�iSTUDENT�j
3.�Шϥ�alter table�覡�إߩҦ���primar key & foreign key
4.�N�H�W step2, step3 ���B�J�g���w�s�{�� �isp+�Ǹ�_exam08�j�A�åB�n�i�H���ư���~�⦨�\

[��ƪ��W��]�i�H�Ѧ� Exam08_ER_Model.jpg
[book]
primary key : ���y�s��

[depname]
primary key : ��O�N��

[student]
primary key : �Ǹ�
foreign key ��O�N�� �Ѧ� depname ��ƪ�

[loan]
primary key : �Ǹ� + ���y�s�� + �ɾ\���
foreign key �Ǹ� �Ѧ� student ��ƪ�
foreign key ���y�s�� �Ѧ� book ��ƪ�

*/
--�O�o������Ʈw
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
���y�s�� char(30) not null, 
���y�W�� nvarchar(50),
�@��     nvarchar(20),
�X����   nvarchar(20),
�ʶR��� date,
�ɾ\���� char(5),
�O�_�ɥX tinyint,
)

create table depname
(
��O�N��     char(6) not null,
��O�W��  nvarchar(100)  not null,
)

create table student
(
�Ǹ� char(8) not null,
�m�W nvarchar(10),
�ʧO tinyint,
��O�N�� char(6), 
�~�� tinyint,
�Z�� char(3)  ,
�q�� char(8),
�a�} nvarchar(50),
)

create table loan
(
�Ǹ� char(8) not null,
���y�s�� char(30) not null,
�ɾ\��� date not null,
�k�٤�� date,
)

alter table book
	add primary key (���y�s��)

alter table depname
	add primary key (��O�N��)

alter table student
	add primary key (�Ǹ�), 
	foreign key (��O�N��) references depname(��O�N��)

alter table loan
	add primary key (�Ǹ�, ���y�s��, �ɾ\���), 
	foreign key (�Ǹ�) references student (�Ǹ�), 
	foreign key (���y�s��) references book (���y�s��)

go


create or alter proc sp410878050_exam08
as
exec sp_drop
exec sp_create


--�i���檺�����j���O!! �n���w�s�{�Ǥ��Ǹ�������


exec sp410878050_exam08
go

----------!----------!----------!----------!----------!----------!----------!----------!----------!----------
/*
�o�Ǵ��Ʊ�j�a���ব�򺡺��A�խY�������ڭӤH�b�оǤW�������ĳ
�i��U��d���A�������������C�J����
�P�¦U��o�Ǵ����t�X�P�V�O�A���֦U��s�~�ּ֡A�ƨƦp�N
*/






