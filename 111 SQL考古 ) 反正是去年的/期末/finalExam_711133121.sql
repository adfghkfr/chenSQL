/*
�i�}�Ҭ�t�j�O�_�j�ǲέp�t��
�i�½ҦѮv�j������
�iemail�jHsiangHui.Chen@gmail.com

111�Ǧ~�ײĤG�Ǵ� ��Ʈw���λP�ӷ~���z���R �ҵ{ �����Ҹ� �Ѯv�G������

�ǥ;Ǹ��G711133121
�ǥͩm�W�G���{�N
�q���W�١G1MF08-42

�`�N�ƶ��G
1.�Х��N���ɮק��W�٬� : finalExam_+�Ǹ��G�A�Ҧp�GfinalExam_12345678.sql
2.���Žƻs�W�ҵ{���i��ק�A�@���o�{���P�@���סA�|�˦����D����
3.�C�@�D�u�঳�@�ӵ��סA���űN�L�{�d�b���D�W�A�_�h�u�|�H�Ĥ@�Өӵ���
4.�H�U�Х�CH07�d�Ҹ�Ʈw�A���D���S�O���w
5.��X�ݩʦW�٫e�Y�O�� * �N��O �O�W �� �l�� �ݩ�
6.�кɶq�F���ϩR, �Ш̴`�B�J���A(�p)���y�k�O�i�H���檺�C
7.���i���檺�{���H0���p�A�i���檺�{���~���i�ೡ���|���������ơA�Y�O�h�Ӹ�ƪ�������join��~���������ơC
8.�����зǡA�|�]���C�@�D�����I���P�A�|���Үt��
9.�����׶ȨѰѦҡA�|�]�ӤH�Ӳ�
10.����Ц��_��
11.���i�H�ϥ�ChatGPT
*/

use CH07�d�Ҹ�Ʈw;

/*01�i������ : �����������j10%
�ЦU�O��X�k�B�k���u�A�~�֤j�󵥩�өʧO�������~�ָ��
[��X](�ʧO, ���u�s��, �m�W, *�~��, *�����~��)
[�Ƨ�]�ʧO���W�B�~�ֻ���
*/
--�iSolution�j
select distinct �ʧO, ���u�s��, �m�W
	 , datediff(year, e.�X�ͤ��, getdate()) as �~��
	 , (select avg(datediff(year, e.�X�ͤ��, getdate()))
		from ���u as e
		where e.�ʧO = '�k') as �����~��
from ���u as e
where e.�ʧO = '�k'
  and datediff(year, e.�X�ͤ��, getdate()) >= (select avg(datediff(year, e.�X�ͤ��, getdate()))
												from ���u as e
												where e.�ʧO = '�k')
union
select distinct �ʧO, ���u�s��, �m�W
	 , datediff(year, e.�X�ͤ��, getdate()) as �~��
	 , (select avg(datediff(year, e.�X�ͤ��, getdate()))
		from ���u as e
		where e.�ʧO = '�k') as �����~��
from ���u as e
where e.�ʧO = '�k'
  and datediff(year, e.�X�ͤ��, getdate()) >= (select avg(datediff(year, e.�X�ͤ��, getdate()))
												from ���u as e
												where e.�ʧO = '�k')
order by �ʧO asc, �~�� desc
go

/*02�i������ : �����������j10%
�Ьd�ߨC�@���q�檺�������
[��X](�q��s��, �q�f���, *�`���B, *���~����)
[�Ƨ�]�q��s�� ���W�Ƨ�
[��X�d��]

�q��s��		�q�f���		�`���B	���~����
94010104	2005-01-10	616		ī�G��|�T��
94010105	2005-01-11	650		Ī����|�Q�s��
94010201	2005-03-12	1205	ī�G��|�Q�s��|�@��
...

[����]
���~���� : �i�H�ϥ� string_agg() ��ơA�Цۦ�W���d��
*/
--�iSolution�j
select o.�q��s��, �q�f���
	 , sum(od.��ڳ��*od.�ƶq) as �`���B
	 , string_agg(���~�W��,'|') as ���~����
from �q�� as o, �q����� as od, ���~��� as p, ���~���O as pd
where o.�q��s�� = od.�q��s��
  and od.���~�s�� = p.���~�s��
  and p.���O�s�� = pd.���O�s��
group by o.�q��s��, �q�f���
go


/*03�i������ : �����������j10%
�ЦC�X �P��ƶq �̰����e���W(�P�W�n�æC�X��)�A�õ����ƦW�A�P��ƶq�̰�������1�W
[��X](���O�s��, ���O�W��, ���~�s��, ���~�W��, *�P��ƶq, *�ƦW)
[����]
1.�ƦW��ƨϥ� rank()
*/
--�iSolution�j
select ���O�s��, ���O�W��, ���~�s��, ���~�W��, �P��ƶq, d.r as �ƦW
from(
select p.���O�s��, ���O�W��, p.���~�s��, ���~�W��
	 , o.�ƶq as �P��ƶq
	 , rank() over (order by o.�ƶq desc) as r
from ���~���O as pd, ���~��� as p, �q����� as o
where pd.���O�s�� = p.���O�s��
  and p.���~�s�� = o.���~�s��
) as d
where r <= 5
go

/*04�i������ : �����������j10%
�Ш̾ڦ~��A�έp�����q���u ��L�B��`�B�ݰh �T�ظ�������u�H��
[��X](*���, *�H��)
[�Ƨ�]�̾ڤH�ƻ���Ƨ�
[����]�̾ڦ~�ꪺ��������H�U�T�� : 
1.��L : �~��p��15�~
2.��` : �~��j�󵥩�15�~, �B�p��30�~
3.�ݰh : �~��j�󵥩�30�~
*/
--�iSolution�j
select ee.��� , count(1) as �H��
from(
select e.���u�s��
	 , case
		when datediff(year, e.���Τ��, getdate())<=15 then '��L'
		when datediff(year, e.���Τ��, getdate())<=30 then '��`'
		else '�ݰh'
	   end as ���
from ���u as e
) as ee
group by ee.���
go

/*05�i������ : �����������j10%
�ѩ�ɶ������ܡA�H�����i�X�A�C�~���n�Эp�⥻���q�k�B�k���u�~�֪����G���p
[��X](*�~�ְ϶�, �m�O, *�H��)
[�Ƨ�]�~�ְ϶� ���W, �ʧO ���W
[����]
�~�� : �ʦ��Y�i�A���κ��
�~�ְ϶� : 
0-9��
10-19��
20-29��
....
*/
--�iSolution�j
select �~�ְ϶�, �ʧO
	 , count(1) as �H��
from(
select e.���u�s��, e.�ʧO, e.�X�ͤ��
	 , datediff(year, e.�X�ͤ��, getdate()) as �~��
	 , cast((datediff(year, e.�X�ͤ��, getdate())/10)*10 as varchar)+'-'
	   +cast((datediff(year, e.�X�ͤ��, getdate())/10)*10+10 as varchar)+'��' as �~�ְ϶�
from ���u as e)as eee
group by �~�ְ϶�, �ʧO
order by �~�ְ϶� asc, �ʧO asc
go

/*06�i������ : �����������j10%
���q����n�F���`�O�S�O��!! ������Ʈw�P�ɦ��ܦh�H�ϥΡA�|�y�����ݵ��ݵ��ݡA���F�קK���ݮ��O�ɶ�
�A�Ӧp�󼶼g�H�U�� SQL �y�k?
����Q�n 2005 �~�P��̦n�����~���
[��X](p.���~�s��, p.���~�W��, c.���O�W��)
[����]dirty read
*/
--�iSolution�j
set transaction isolation level read uncommitted;

select pp.���~�s��, pp.���~�W��, pp.���O�W��
from(
select p.���~�s��, p.���~�W��, pd.���O�W��
	 , rank() over (order by od.�ƶq desc) as r
from �q�� as o, �q����� as od, ���~��� as p, ���~���O as pd
where o.�q��s�� = od.�q��s��
  and od.���~�s�� = p.���~�s��
  and p.���O�s�� = pd.���O�s��
  and year(o.�q�f���) = 2005
) as pp
where r <= 1
go

--�H�U07�B08�i�H�O���D�W�ߵL�����D�ءA�D�s���D

/*07�i������ : �����������j80/20�k�h 10%
�̾�80/20�k�h�A�ϥ�SQL�Ӭd�߾P���`���B�^�m�ײ֭p��80%�A�����ǲ��~? 
[��X](���~�W��, *�^�m�ײ֭p)
[�Ƨ�]�^�m�ײ֭p ���W
[����]�I��80%���e(�t)�����~�A���᪺���~�������
*/
--�iSolution�j
select ���~�W��
	 , sum(��ڳ��*�ƶq)*1.0/(select sum(��ڳ��*�ƶq)*1.0
								from �q����� as od) as �^�m�ײ֭p
from �q����� as o, ���~��� as p
where o.���~�s�� = p.���~�s��
group by ���~�W��
order by �^�m�ײ֭p desc
go



/*08�i������ : �����������j80/20�k�h 10%
�̾ڥH�W07�D�������A���n��ܥX�Ҧ����~�A���Excel�ϯä��R�s�@80/20�k�h�����ҡA
���D�u�nú��Excel�ɮקY�i�A�ɦW�� finalExam08_�Ǹ�.xlsx
[����]�H�U��T����
1. �мХܼ��D�� 80/20�k�h--�m�W
2. X���� : ���~�W��
3. Y���� : (�D�n�b)�P����B
[����]
�i�H���إߤ@���˵���(view)�A���ѵ�Excel��ƨϥ�
[�Ѧҵe��]
http://10.137.110.61:8088/Images/80-20�k�h.JPG
*/
--�iSolution�j





go


/*09�i������ : �����������j20%
1.���N D�ǥ͹Ϯѭɾ\���.txt �ɮ׶פJ CH07�d�Ҹ�Ʈw
2.�ƥ��N�Ӹ�ƪ�i�楿�W�ƫ�A�N�Ҧ���Ƽg�J��������ƪ��C
3.�Ыظm�@�Ӹ�Ʈw�Ϫ�(ERD)�A��ʳ]�w�C�@�Ӹ�ƪ�Primary Key�A�ëإߩ��������p
4.��Ӧs��ER Model�� finalExam09_�Ǹ�.jpg�A�@��ú��A������P���D�s��
*/
--�iSolution�j





go


----------!----------!----------!----------!----------!----------!----------!----------!----------!----------
/*
�ڦ��ܭn��..........
�i�л��j




*/







