/*
�i�}�Ҭ�t�j�O�_�j�ǲέp�t��
�i�½ҦѮv�j������
�iemail�jHsiangHui.Chen@gmail.com

111�Ǧ~�ײĤG�Ǵ� ��Ʈw���λP�ӷ~���z���R �ҵ{ �����Ҹ� �Ѯv�G������

�ǥ;Ǹ��G711133121
�ǥͩm�W�G���{�N
�q���W�١G1MF08-42

�`�N�ƶ��G
1.�Х��N���ɮק��W�٬� : midExam+�Ǹ��G�A�Ҧp�GmidExam12345678.sql
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

use ch07�d�Ҹ�Ʈw;

/*01�i������ : �����������j10%
�ЦC�X�~��b �x�_���B�x�����B������ ���Ȥ�A���V�����q�q�ʹL���Ǥ��P�����~����
[��X](*�~����, ���O�W��, ���~�W��)
[�Ƨ�]�~���� ���W, ���O�W�� ����
[����]
�~���� �N�O �a�}�e�T�Ӧr
*/
--�iSolution�j
select distinct left(c.�a�}, 3) as �~����, ���O�W��, ���~�W��
from �Ȥ� as c, �q�� as o, �q����� as od, ���~��� as p, ���~���O as pd
where c.�Ȥ�s�� = o.�Ȥ�s��
  and o.�q��s�� = od.�q��s��
  and od.���~�s�� = p.���~�s��
  and p.���O�s�� = pd.���O�s��
  and left(c.�a�}, 3) in ('�x�_��', '�x����', '������')
order by �~���� asc, ���O�W�� desc
go

/*02�i������ : �����������j10%
�ЦC�X�����q���u�~�ֳ̤j���e2�W�H�γ̤p���e2�W�A���O�P�~�֥������C�X
[��X](���u�s��, �m�W, �X�ͤ��, *�~��)
[����]
�~�� : �ʦ��Y�i�A�������
[����]
1.�i�H�ϥ�union
2.�i�H�ϥΤl�d��
3.�i�H�ϥ�rank() over ()
*/
--�iSolution�j
--�i�Ѥ@�j
select ���u�s��, �m�W, �X�ͤ��
	 , datediff(year, e.�X�ͤ��, getdate()) as �~��
from (select top 2 with ties ���u�s��, �m�W, �X�ͤ��
	  , datediff(year, e.�X�ͤ��, getdate()) as �~��
	  from ���u as e
	  order by �~�� desc) as e
union
select ���u�s��, �m�W, �X�ͤ��
	 , datediff(year, e.�X�ͤ��, getdate()) as �~��
from (select top 2 with ties ���u�s��, �m�W, �X�ͤ��
	  , datediff(year, e.�X�ͤ��, getdate()) as �~��
	  from ���u as e
	  order by �~�� asc) as e
order by �~�� desc
go
--�i�ѤG�j
select ���u�s��, �m�W, �X�ͤ��
	 , datediff(year, e.�X�ͤ��, getdate()) as �~��
from (select ���u�s��, �m�W, �X�ͤ��
	  , datediff(year, e.�X�ͤ��, getdate()) as �~��
	  , rank() over (order by datediff(year, e.�X�ͤ��, getdate()) asc) as r1
      from ���u as e) as e
where r1 <= 2
union
select ���u�s��, �m�W, �X�ͤ��
	 , datediff(year, e.�X�ͤ��, getdate()) as �~��
from (select ���u�s��, �m�W, �X�ͤ��
	  , datediff(year, e.�X�ͤ��, getdate()) as �~��
	  , rank() over (order by datediff(year, e.�X�ͤ��, getdate()) desc) as r2
      from ���u as e) as e
where r2 <= 2
order by �~�� desc
go

/*03�i������ : �����������j10%
�ѩ󥻤��q��~����B���n�A�����i��H�ƽվ�
�в��ͤ@��������
�b�����q���~��j��(�]�t)25�~�H�W�A�B2006�~�S���ӱ�����q�檺���
[��X](���u�s��, �m�W, ���Τ��, *�~��)
[�Ƨ�]�̾ڦ~�껼��Ƨ�, ���u�s�����W�Ƨ�
[����]
�~��, �N�O���Τ���ܤ��骺�~�ơA����������
*/
--�iSolution�j
select ���u�s��, �m�W, ���Τ��
	 , datediff(day, e.���Τ��, getdate())/365 as �~��
	 --, datediff(year, e.���Τ��, getdate()) - iif(month(getdate()) > month(e.���Τ��)
	 --	 or month(getdate()) = month(e.���Τ��) and day(getdate()) >= day(e.���Τ��), 0, 1) as �~��
from ���u as e
where e.���u�s�� not in (select distinct o.���u�s��
						 from �q�� as o
						 where year(o.�q�f���) = 2006)
  and datediff(year, e.���Τ��, getdate()) - iif(month(getdate()) > month(e.���Τ��)
	    or month(getdate()) = month(e.���Τ��) and day(getdate()) >= day(e.���Τ��), 0, 1) >= 25 
order by �~�� desc, ���u�s�� asc
go

/*04�i������ : �����������j10%
�ЦC�X ������, �B�Ŷ�, ����ģ �o�T��D�ަ����X�쪽�ݪ����ݡA�L�צ��S�����ݡA���n�C�X��
[��X](*�W�q�s��, *�W�q�m�W, *���ݽs��, *���ݩm�W)
[����]outer join
*/
--�iSolution�j
select �W�q.���u�s�� as �W�q�s��, �W�q.�m�W as �W�q�m�W
	 , ����.���u�s�� as ���ݽs��, ����.�m�W as ���ݩm�W
from ���u as �W�q
	 left join ���u as ���� on �W�q.���u�s�� = ����.�D��
where �W�q.�m�W in ('������', '�B�Ŷ�', '����ģ')
go

/*05�i������ : �����������j10%
�ЦC�X���ǭq��A�P�ⲣ�~�� ��ڳ�� �C�� ���~��ƪ� ��ĳ��� �E�� �H�U(�t)
[��X](���u�s��,  *���u�m�W, �Ȥ�s��, *�Ȥ�W��, 
       �q��s��, ���~�W��, ��ĳ���, ��ڳ��, *���)
[�Ƨ�]���u�s�� ���W, �A�̫Ȥ�s�� ���W
[����]
1.��� �N�O�Ӳ��~���F�X��A���ܤp�ƥH�U 2 ��A�Ҧp : 0.83
*/
--�iSolution�j
select e.���u�s��,  e.�m�W as ���u�m�W, c.�Ȥ�s��, c.���q�W�� as �Ȥ�W��
	 , o.�q��s��, ���~�W��, ��ĳ���, ��ڳ��
	 , cast(cast(��ڳ�� as numeric(4, 2))/cast(��ĳ��� as numeric(4, 2))as numeric(4,2)) as ���
	 --cast(��ڳ��*1.0/��ĳ��� as numeric(4,2)) as ���
from ���u as e, �q�� as o, �q����� as od, ���~��� as p, �Ȥ� as c
where e.���u�s�� = o.���u�s��
  and o.�q��s�� = od.�q��s��
  and od.���~�s�� = p.���~�s��
  and c.�Ȥ�s�� = o.�Ȥ�s��
  and ��ڳ�� <= ��ĳ��� * 0.9
order by e.���u�s�� asc, c.�Ȥ�s�� asc
go

/*06�i������ : �����������j10%
�Ьd��2005�~���q��A�����ǲ��~�Ӧ~�׳����P��X�h�A�o�ǲ��~�O�Ӧۭ��Ǩ�����
[��X](�����ӽs��, �����ӦW��)
[�Ƨ�]�����ӽs�����W
*/
--�iSolution�j
select distinct ca.�����ӽs��, �����ӦW��
from ������ as ca
	 left join ���~��� as p on p.�����ӽs�� = ca.�����ӽs��
where p.���~�s�� not in (select p.���~�s��
						 from �q�� as o, �q����� as od, ���~��� as p
						 where o.�q��s�� = od.�q��s��
						   and od.���~�s�� = p.���~�s��
						   and year(o.�q�f���) = 2005)
go

/*07�i������ : �����������j10%
�Ш̾� ���O�s�� �U�� ���}�ƦW�A�̾� ��ĳ��� ���C�ƦW�A��ĳ��� ���̬��� 1 �W
[��X](���O�s��, ���O�W��, ���~�s��, ���~�W��, ��ĳ���, *����ƦW)
[����]
1.����ƦW �O�� ��ĳ����̶Q������ 1 �W
2.����ƦW����X�榡�����O '��001�W', '��002�W', '��003�W', ...
*/
--�iSolution�j
select p.���O�s��, ���O�W��, ���~�s��, ���~�W��, ��ĳ���
	 , '��'+right('00'+cast(rank() over (partition by p.���O�s�� order by ��ĳ��� desc)as varchar), 3)+'�W' as ����ƦW
	 --format(rank() over (partition by p.���O�s�� order by ��ĳ��� desc), '��0##�W') as ����ƦW
from ���~��� as p, ���~���O as pd
where p.���O�s�� = pd.���O�s��
go





---�������������i�H�U8, 9 ���D�ȥ��NSSMS���e��(�]�t���G)��Ӧs�ɤ@�֤W�ǡA�S���W�ǵ��G�A���D��10���j������������





/*08�i������ : �����������j15%
�Ш̾ڥH�U���B�J�������D
1. �N diabetes.csv(�}���f��ƶ�) �פJ�A(�p)�ۤv�� CH07�d�Ҹ�Ʈw, 
   ��ƪ�W�٬� diabetes (0%)
2. ���F�l�� 50���H�W(�]�t)�S���w�}���f �������I�s�A
   �ЬD��X"���G"�O����(0)"��}"����, ����(�j�󵥩�)"���G"������(1)�w�̪�����"��}"�A
   �o�Ǳڸs��������� (10%)
[��X](�~��, ��}, ����, BMI, ���G, *�w�}���f�H��������})
[�Ƨ�]�~�ֻ���Ƨ�, ��}����Ƨ�
[����]
1.�w�}���f�H��������} : �N�O"���G"������(1)������"��}"
2.�w�}���f�H��������}�A�������p�ƥH�U2�� (�Ҧp 141.26)
3.��ƶפJ : �iCH07�d�Ҹ�Ʈw�j���k��\�i�u�@�j\�i�ϥζפJ�@���ɮסj
  ���O�b�פJ�L�{���A�n�`�N�H�U��쪺��ƫ��A

  �h�� : tinyint
  ��} : tinyint
  ���� : tinyint
  �ֽ��p�� : tinyint
  �خq�� : smallint
  BMI : numeric(10, 2)
  �}���f�Шt�\�� : numeric(10, 2)
  �~�� : tinyint
  ���G : bit
�i�Ѧҵ��G�jhttp://10.137.110.61:8080/Images/diabetesResult.JPG
*/
--�iSolution�j
select �~��, ��}, ����, BMI, ���G
	 , (select cast(avg(cast(d.��} as numeric(5,2))) as numeric(5,2))
		from diabetes as d
		where d.���G = '1') as �w�}���f�H��������}
	 --(select cast(avg(d.��}*1.0)as numeric(5,2))
	 -- from diabetes as d
	 -- where d.���G = '1') as �w�}���f�H��������}
from diabetes as d
where �~�� >= 50
  and d.���G = '0'
  and ��} > (select cast(avg(cast(d.��} as numeric(5,2))) as numeric(5,2))
				from diabetes as d
				where d.���G = '1')
order by �~�� desc, ��} desc
go

/*9�i������ : �����������j15%
�Ш̾ڥH�U���B�J�������D
1. �N stock.csv(�ѥ�������), company.csv(���q���) �פJ�A(�p)�ۤv�� CH07�d�Ҹ�Ʈw, 
   ��ƪ�W�٤��O�� stock, company (0%)�C
2. ���F�d�ݨC��ѻ������T�A
   �ЬD��X�H�U����� (10%)
[��X](������, �Ѳ����X, *���q�W��, �}�L��, ���L��, �վ㦬�L��, �̰���, �̧C��, *��ǻ�, *���T)
[�Ƨ�]�̾ڥ���������, �Ѳ����X���W
[����]
1.��ǻ� : �O���e�@�ѥ���骺 �վ�᦬�L��
2.���T :�@(���馬�L���а�ǻ�)/��ǻ� : �u���ܤp�ƥH�U4��
3.��ƶפJ : �iCH07�d�Ҹ�Ʈw�j���k��\�i�u�@�j\�i�ϥζפJ�@���ɮסj
  ���O�b�פJ�L�{���A�n�`�N�H�U��쪺��ƫ��A

   �icompany�j
   ���q�N�� : varchar(10)
   ���q²�� : nvarchar(50)

   �istock�j
   �Ѳ����X : varchar(10)
   ������ : date
   �}�L�� : numeric(10, 2)
   �̰��� : numeric(10, 2)
   �̧C�� : numeric(10, 2)
   ���L�� : numeric(10, 2)
   �վ㦬�L�� : numeric(10, 2)
   ����q : int
[����]
��ǻ� : �i�H�ϥ� lag(..., ..., ...) over (partition by ... order by ...) �ۦ��s�ϥΤ覡
�i�ѻ��Ѧҡjhttp://10.137.110.61:8080/Images/stock�ѻ��ϥ�.JPG
�i�Ѧҵ��G�jhttp://10.137.110.61:8080/Images/stockResult.JPG
*/
select ������, �Ѳ����X, ���q²�� as ���q�W��, �}�L��, ���L��
	 , �վ㦬�L��, �̰���, �̧C��
	 , lag(�վ㦬�L��, 1, 0) over (partition by ���q²�� order by ������)
	 --lag(�վ㦬�L��, 1, Null) over (partition by �Ѳ����X order by ������)as ��ǻ�
	 , cast(isnull((���L��-(lag(�վ㦬�L��, 1, 0) over (partition by ���q²�� order by ������)))
			/nullif((lag(�վ㦬�L��, 1, 0) over (partition by ���q²�� order by ������)),0), 0)as numeric(6, 4))
			as ���T
	 --cast((���L��-(lag(�վ㦬�L��, 1, Null) over (partition by ���q²�� order by ������)))/(lag(�վ㦬�L��, 1, Null)
		 --over (partition by ���q²�� order by ������)) as numeric (6, 4)) as ���T
from stock as s, company as co
where s.�Ѳ����X = co.���q�N�� 
order by ������ desc, �Ѳ����X asc
go
--�i�e���W�ǰѦҵ��G�jhttp://10.137.110.61:8080/Images/ú��d��.JPG
