/*
110�Ǧ~�ײĤ@�Ǵ� �O�_�j�ǲέp�t(��) �i��Ʈw���λP�ӷ~���z���R�j �ҵ{ �����Ҹ� �Ѯv�G������

�ǥ;Ǹ��G
�ǥͩm�W�G

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
select o.�q��s��, �q�f���,e.�m�W as �ӿ���u�m�W
from �q�� as o 
	left join �q����� as od on o.�q��s��=od.�q��s��
	left join ���u as e on e.���u�s��=o.���u�s��

where ���~�s�� is null

go

/*02�i������ : �����������j10%
�Ьd�ߴ��g�q�ʹL �Q�s�� �M �@�� �ⶵ���~(��̬Ҧ��q�ʹL) ���h�֮a�Ȥ��
[��X](*�Ȥ��)
[����]
1. (1)��X�q�ʹL �Q�s��, (2)��X�q�ʹL �@�� ���Ȥ���
2. �N�H�W��̧Q�� intersect ��X�涰�A�N�O��̬Ҧ��q�ʹL���Ȥ���
3. �N�H�W�� intersect ���l�d�ߡA�p�ⵧ��
*/

select count(k.���q�W��) as �Ȥ��
from 
(
select ���q�W��
from �Ȥ� as c,�q�� as o,�q����� as od,���~��� as p
where c.�Ȥ�s��=o.�Ȥ�s��
  and o.�q��s��=od.�q��s��
  and od.���~�s��=p.���~�s��
  and ���~�W��='�Q�s��'

intersect

select ���q�W��
from �Ȥ� as c,�q�� as o,�q����� as od,���~��� as p
where c.�Ȥ�s��=o.�Ȥ�s��
  and o.�q��s��=od.�q��s��
  and od.���~�s��=p.���~�s��
  and ���~�W��='�@��'
) as k

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

--�iDoc Solution�j
create or alter proc sp711033119_exam03
@�_�~�� int=null, @���~�� int=null, @�_�~�� int=null, @���~�� int=null
as
select ���u�s��, �m�W,�X�ͤ��, ���Τ��
     , datediff(year,e.�X�ͤ��,getdate()) as �~��
	 , datediff(year,e.���Τ��,getdate()) as �~��
from ���u as e
where (@�_�~�� is null or @�_�~�� <= datediff(year,e.�X�ͤ��,getdate()))
  and (@���~�� is null or datediff(year,e.�X�ͤ��,getdate()) <= @���~��)
  or  (@�_�~�� is null or @�_�~�� <= datediff(year,e.���Τ��,getdate()))
  and (@���~�� is null or datediff(year,e.���Τ��,getdate()) <= @���~��)

go


--�i���檺�����j���O!! �n���w�s�{�Ǥ��Ǹ�������
--�d�ߩҦ����u
exec sp711033119_exam03
--�d�ߦ~��>=65 �� �~��>=25�����u
exec sp711033119_exam03 @�_�~��=65, @�_�~��=25 
--�d�ߦ~�֤���65-68���� �� �~�ꤶ�� 25-28 ����
exec sp711033119_exam03 @�_�~��=65, @���~��=68, @�_�~��=25, @���~��=28
--�d�ߦ~��<=50 �� �~�� <=25
exec sp711033119_exam03 @���~��=50, @���~��=25
go


/*04�i������ : �����������j10%
�м��g�@�ӹw�s�{�� �isp+�Ǹ�_exam04�j �i�H�d�߬Y�@�~�A�q���P��L�����~
�A���@�����O�����~�Ƴ̦h�A�P�W�n�æC
[��X](���O�s��, ���O�W��, *�~��, *������X�����~��)
[�Ѽ�]@year
*/
  


create or alter proc sp711033119_exam04
@year int=null
as
select p.���O�s��, ���O�W��, @year as �~��, count(p.���~�W��) as  ������X�����~��
from ���~��� as p, ���~���O as ca
where p.���O�s��=ca.���O�s��
and p.���~�s�� not in (select od.���~�s��
                        from �q�� as o, �q����� as od
                        where o.�q��s��=od.�q��s��
                          and year(o.�q�f���)=@year)
Group by p.���O�s��, ���O�W��
order by ������X�����~�� desc
go

--�i���檺�����j���O!! �n���w�s�{�Ǥ��Ǹ�������
exec sp711033119_exam04 2005
exec sp711033119_exam04 2006


/*05�i������ : �����������j10%
�ЦC�X��ĳ��� �j�󵥩� �Ҧ����~��������ĳ��� �����~���
[��X](���O�s��, ���O�W��, ���~�s��, ���~�W��, ��ĳ���, *�Ҧ����~��������ĳ���)
*/


select p.���O�s��, ���O�W��, ���~�s��, ���~�W��, ��ĳ���
     , (select sum(p.��ĳ���)/count(p.��ĳ���)
		from ���~��� as p) as �Ҧ����~��������ĳ���
from ���~��� as p,���~���O as ca
where p.���O�s��=ca.���O�s��
and ��ĳ��� >= (select sum(p.��ĳ���)/count(p.��ĳ���)
				 from ���~��� as p) 
go

/*06�i������ : �����������j10%  ok
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

--�iDoc Solution�j
USE CH11�d�Ҹ�Ʈw

select * into #���u���y��71133120
from ���u���y��
where 0=1
go

USE CH07�d�Ҹ�Ʈw
select * from #���u���y��71133120
insert into #���u���y��71133120 (���u�s��, �~��, ����)
select e.���u�s��, 2023, null 
from ���u  as e
where datediff(year,e.�X�ͤ��,getdate())>=50
go

update p
set ���� = case
              when 20 <=year(getdate()) - year(e.���Τ��) and year(getdate()) - year(e.���Τ��) < 25 then 10000
              when 25<=year(getdate()) - year(e.���Τ��) and year(getdate()) - year(e.���Τ��) < 30 then 20000
              when year(getdate()) - year(e.���Τ��) >= 30 then 30000
			  else 5000
           end 
from ���u as e,  #���u���y��71133120 as p
where e.���u�s��=p.���u�s��
  and p.�~��=2023
go

--�i�d�ߵ��G�j���O!! �n���Ȧs��ƪ��Ǹ�������
select * from #���u���y��71133120
go


/*07�i������ : �����������j20%
�Ш̾ڨk�B�k���}�A�̾ڥX�ͤ�����W�Ƨ�
[��X](���u�s��, �m�W, �ʧO, �X�ͤ��, *�e�@�쪺�X�ͤ��, *��@�쪺�X�ͤ��)
[�Ƨ�]�ʧO���W, �X�ͤ�����W
[����]�i�H�ϥ�self-join + outer join�A���u��ƪ��t��Ө���
[����]�Шϥ�CTE�Ӽ��g���D
*/


;with 
cte_�k���u
as
(
select * from ���u as e
where ���u�s�� in(
select e.���u�s��
from ���u as e
where e.�ʧO='�k')

)
,
cte_�k���u
as
(
select * from ���u as e
where ���u�s�� in(
select e.���u�s��
from ���u as e
where e.�ʧO='�k')

)

select e.���u�s��, e.�m�W, e.�ʧO, e.�X�ͤ�� --, *�e�@�쪺�X�ͤ��, *��@�쪺�X�ͤ��
from cte_�k���u e
      left join cte_�k���u o on e.���u�s��=o.���u�s��
	order by e.�X�ͤ��
go




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
create or alter proc sp711033119_exam08
as
create table book
(
���y�s�� char(6) ,
���y�W�� char(6) ,
�@�� char(6) ,
�X���� char(6) ,
�ʶR��� char(6) ,
�ɾ\���� char(6) ,
�O�_�ɥX char(6) 
)

alter table book
  alter column ���y�s�� char(6)  not null
alter table book
  alter column ���y�W�� char(6)  not null
alter table book
  alter column �@�� char(6)  not null
alter table book
  alter column �X���� char(6)  not null
alter table book
  alter column �ʶR��� char(6)  not null

alter table book
  alter column �ɾ\���� char(6)  not null
alter table book
  alter column �O�_�ɥX char(6)  not null
alter table book
  add primary key (���y�s��)



create table DEPNAME
(
��O�N��     char(6) ,
��O�W�� char(6) 

)
alter table DEPNAME
  alter column ��O�N�� char(6)  not null
alter table DEPNAME
  add primary key (��O�N��)



create table student 
(
�Ǹ� char(10)      ,  
��O�N�� char(6) foreign key references DEPNAME(��O�N��),
�m�W     char(6) ,
�ʧO     char(6) ,
�~��     char(6) ,
�Z��     char(6) ,
�q��     char(10) ,
�a�}     char(20) 
)
alter table student
  alter column �Ǹ� char(10)  not null
alter table student
  alter column ��O�N�� char(6)  not null
alter table student
  add primary key (�Ǹ�)




create table loan
(
�Ǹ� char(10)     foreign key references student(�Ǹ�),
���y�s�� char(6) references book(���y�s��),
�ɾ\��� char(10),
�k�٤��     char(6) 

)
alter table loan
  alter column �Ǹ� char(10)  not null
alter table loan
  alter column ���y�s�� char(6)  not null
 alter table loan
  alter column �ɾ\��� char(10)  not null
alter table loan
  add primary key (�Ǹ�, ���y�s��, �ɾ\���)

go




drop table if exists book
drop table if exists DEPNAME
drop table if exists student
drop table if exists loan




go

--�i���檺�����j���O!! �n���w�s�{�Ǥ��Ǹ�������
exec sp711033119_exam08
go

----------!----------!----------!----------!----------!----------!----------!----------!----------!----------
/*
�o�Ǵ��Ʊ�j�a���ব�򺡺��A�խY�������ڭӤH�b�оǤW�������ĳ
�i��U��d���A�������������C�J����
�P�¦U��o�Ǵ����t�X�P�V�O�A���֦U��s�~�ּ֡A�ƨƦp�N
*/






