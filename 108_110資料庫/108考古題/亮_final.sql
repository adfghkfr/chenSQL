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
--�iSolution�j
select ���u�s��, �m�W, �ʧO
	 , datediff(year, e.�X�ͤ��, getdate()) as �~�� 
	 , 'A' + cast(ntile(3) over (order by datediff(year, e.�X�ͤ��, getdate()) asc) as varchar) as �и�
from ���u as e
where e.�ʧO= '�k'
union
select ���u�s��, �m�W, �ʧO
	 , datediff(year, e.�X�ͤ��, getdate()) as �~�� 
	 , 'B' + cast(ntile(2) over (order by datediff(year, e.�X�ͤ��, getdate()) asc) as varchar) as �и�
from ���u as e
where e.�ʧO= '�k'
order by e.�ʧO asc, �~�� asc
go




/*02�i������ : �����������j10%
�p�G�ڭ̤��q���u��¾�Ȥ����T�h�A�q�W�ӤU�٤����W�h�B���h�P��h
�м��g�@�ӹw�s�{�ǦW�� spEmp+�Ǹ� 
[��X](�W�h���u�s��, �W�h���u�m�W, ���h���u�s��, ���h���u�m�W, ��h���u�s��, ��h���u�m�W)
[�Ѽ�]@name : �W�h���u�m�W
[����]
1.�i�H��J�Y�S�w�� �W�h���u�m�W �d�ߩ��ݤU��h�����u���(���i��|�ONULL)
2.�i�H����J�ѼƭȡA�N�O�d�ߩҦ����u���ݤU��h�����u���(���i��|�ONULL)
*/

create or alter proc spEmp410878050
@name varchar(10)= null
as
select e3.���u�s��, e3.�m�W, e2.���u�s��, e2.�m�W, e1.���u�s��, e1.�m�W
from ���u as e1
	 left join ���u as e2 on e1.�D��= e2.���u�s��
	 left join ���u as e3 on e2.�D��= e3.���u�s��
where @name is null or e3.�m�W= @name 

exec spEmp410878050 ������
exec spEmp410878050


/*03�i������ : �����������j10%
�Ьd��2005�~�Ҧ����u�ӱ��q�檺������T�A�S���ӱ������q�檺���u�]�n�X�{
[��X](���u�s��, �m�W, *�ӱ��q��ƶq, *�`���B, *�`��Q)
[�Ƨ�]�̾� ���u�s�� ���W
[���n]�ϥ� CTE(Common Table Expression) ���g�k
*/
--�iSolution�j
;with
cte_2005�~�q��
as
(
select o.�q��s��, o.���u�s��
				from �q�� as o
				where year(o.�q�f���)=2005
)


select e.���u�s��, e.�m�W
	 , count(o.�q��s��) as �ӱ��q��ƶq
	 , isnull(sum(od.��ڳ��* od.�ƶq), 0) as �`���B
	 , isnull(sum((od.��ڳ��- p.��������)* od.�ƶq ), 0) as �`��Q
from ���u as e	
	left join cte_2005�~�q�� as o on e.���u�s��= o.���u�s��
	left join �q����� as od on o.�q��s��= od.�q��s��
	left join ���~��� as p on od.���~�s��= p.���~�s��
group by e.���u�s��, e.�m�W
order by e.���u�s��
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
select case
			when �w�s�q<=0          then     '�s�w�s'
			when �w�s�q<=�w���s�q/3  then    '�w�s�q�Y������'
			when �w�s�q<=�w���s�q		then	'�w�s�q����'
			when �w�s�q<=�w���s�q*3  then		'�w�s�q�R��'
			else   '�w�s�q�L��' 
		end as ���A
	 , count(case
			when �w�s�q<=0          then     '�s�w�s'
			when �w�s�q<=�w���s�q/3  then    '�w�s�q�Y������'
			when �w�s�q<=�w���s�q		then	'�w�s�q����'
			when �w�s�q<=�w���s�q*3  then		'�w�s�q�R��'
			else   '�w�s�q�L��' 
		end) as ���~��
from ���~��� as p
group by case
			when �w�s�q<=0          then     '�s�w�s'
			when �w�s�q<=�w���s�q/3  then    '�w�s�q�Y������'
			when �w�s�q<=�w���s�q		then	'�w�s�q����'
			when �w�s�q<=�w���s�q*3  then		'�w�s�q�R��'
			else   '�w�s�q�L��' 
		end 
go




/*05�i������ : �����������j10%
�Ш�U�إߤ@�Ө�ƦW�� fn+�Ǹ�, ��\��N�O�^�ǤU�@�ӷs�������ӽs��
[��X���G]���ӷ|�O 'S0006'
*/

/*
;with
cte_last
as
(
select right(max(p.�����ӽs��), 4)+1
from ������ as p 
)
select 'S'+ right('000'+ cast(cte_last as varchar), 4) 
*/


select 'S'+ right('000'+ cast((select right(max(p.�����ӽs��), 4)+1
						from ������ as p) as varchar), 4) 




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

--�H�U�O�d�ߵ��G

drop table if exists [���u���y��410878050]

select* into [���u���y��410878050]
from CH11�d�Ҹ�Ʈw.dbo.���u���y��
where 1=3

insert into [���u���y��410878050]  (���u�s��, �~��, ����)
select e.���u�s��, year(getdate()), null
from ���u as e
where datediff(year, e.���Τ��, getdate())>= 15
go

update [���u���y��410878050]
set ����= case
			when datediff(year, e.���Τ��, getdate())<20 then 10000
			when datediff(year, e.���Τ��, getdate())<25 then 20000
			else 30000
			end
from ���u as e, ���u���y��410878050 as p
where e.���u�s��= p.���u�s��

select* from [���u���y��410878050] 


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

--2. �a�������h�妳���X��






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
select*
from sys.tables






--�H�U�O����
