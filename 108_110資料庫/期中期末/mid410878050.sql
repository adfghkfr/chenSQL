/*
110�Ǧ~�ײĤ@�Ǵ� ��Ʈw���λP�ӷ~���z���R �ҵ{ �����Ҹ� �Ѯv�G������

�ǥ;Ǹ��G410878050
�ǥͩm�W�G���G��
�q���W�١G1MF08-18

�`�N�ƶ��G
1.�Х��N���ɮק��W�٬� : mid+�Ǹ��G�A�Ҧp�GmidA12345678.sql
2.���Žƻs�W�ҵ{���i��ק�A�@���o�{���P�@���סA�|�˦����D����
3.�C�@�D�u�঳�@�ӵ��סA���űN�L�{�d�b���D�W�A�_�h�u�|�H�Ĥ@�Өӵ���
4.�H�U�Х�CH07�d�Ҹ�Ʈw�A���D���S�O���w
5.��X�ݩʦW�٫e�Y�O�� * �N��O �O�W �� �l�� �ݩ�
6.�кɶq�F���ϩR, �Ш̴`�B�J���A(�p)���y�k�O�i�H���檺�C
7.���i���檺�{���H0���p�A�i���檺�{���~���i�ೡ���|���������ơA�Y�O�h�Ӹ�ƪ�������join��~���������ơC
8.�����зǡA�|�]���C�@�D�����I���P�A�|���Үt��
9.�����׶ȨѰѦҡA�|�]�ӤH�Ӳ�
10.���o�ϥΦۤv�����q�A����Ц��_��
*/

use ch07�d�Ҹ�Ʈw;

/*01�i������ : �����������j10%
�ЦC�X ��ڪA�Ȧ~�� ��15�~�B����27�~ �����u���
[��X](���u�s��, �m�W, �ʧO, ���Τ��, *��ڪA�Ȧ~��)
[�Ƨ�]��ڪA�Ȧ~�� ����
[����]��ڪA�Ȧ~�� �H ���Τ�� �ܦ��{�������ѭp
*/
--�iSolution�j
select e.���u�s��, e.�m�W, e.�ʧO, e.���Τ��
	 , datediff(year, e.���Τ��, getdate()) as ��ڪA�Ȧ~��
from ���u as e
where datediff(year, e.���Τ��, getdate())>= 15
	 and datediff(year, e.���Τ��, getdate())< 27
order by ��ڪA�Ȧ~�� desc
go



/*02�i������ : �����������j10%
�ЦC�X�ڭ̤��q���F �̪F�B�Ὤ�B�x�� ���~�A�C�@�ӿ����a�Ϧ��X�ӫȤ�
[��X](*����, *�a��, *�Ȥ��)
[�Ƨ�]���� ���W, �a�ϻ��W
[����]
1.���� �O���Ȥ�a�}���e�T�Ӧr�A�Ҧp �x�_��
2.�a�� �O���Ȥ�a�}��4-6�Ӧr�A�Ҧp ���s��
*/
--�iSolution�j
select left(c.�a�}, 3) as ����
	 , substring(c.�a�}, 4, 3) as �a��
	 , count(c.���q�W��) as �Ȥ��
from �Ȥ� as c
where left(c.�a�}, 2) not in ('�̪F','�Ὤ','�x��')
group by left(c.�a�}, 3), substring(c.�a�}, 4, 3)
order by ���� asc, �a�� asc
go


/*03�i������ : �����������j10%
�ЦC�X �w�s���� �̰����e���W(�P�W�n�æC�X��)�A�õ����ƦW�A�w�s�����̰�������1�W
[��X](���O�s��, ���O�W��, ���~�s��, ���~�W��, �w�s�q, ��������, *�w�s����, *�ƦW)
[����]
1.�ƦW��ƨϥ� rank()
2.�w�s���� �� �w�s�q * ��������
*/
--�iSolution�j 
select top 5 ca.���O�s��, ca.���O�W��, pd.���~�s��, pd.���~�W��, pd.�w�s�q, pd.��������
	 , pd.�w�s�q*pd.�������� as �w�s����
	 , rank() over (order by pd.�w�s�q*pd.�������� desc) as �ƦW

from ���~���O as ca, ���~��� as pd
where pd.���O�s��= ca.���O�s��
go



/*04�i������ : �����������j10%
�Ьd�߾��~�֭p���A���@�ӫȤ�q�� �G�� �������~�ƶq�̦h
[��X](�Ȥ�s��, *�Ȥ�W��, �a�}, ���O�W��, *�q�ʲ��~�`�ƶq)
[����]
�p�G���ۦP�q�ʼƶq�A�n�æC�X��
*/
--�iSolution�j
select top 1 c.�Ȥ�s��, c.���q�W�� as �Ȥ�W��, c.�a�}, ca.���O�W��
	 , count(o.�q��s��) as �q�ʲ��~�`�ƶq
from �Ȥ� as c, �q�� as o, �q����� as od, ���~��� as pd, ���~���O as ca
where c.�Ȥ�s��= o.�Ȥ�s��
	 and o.�q��s��= od.�q��s��
	 and od.���~�s��= pd.���~�s��
	 and pd.���O�s��= ca.���O�s��
	 and ca.���O�W��= '�G��'
group by c.�Ȥ�s��, c.���q�W��, c.�a�}, ca.���O�W��
order by �q�ʲ��~�`�ƶq desc
go




/*05�i������ : �����������j10%
�ЦC�X�C�@�~�����~�Z�P�Ʀ�]
[��X](*�~��, ���O�W��, ���~�W��, *�P��ƶq, *�P��ƦW, *�Ƶ�����)
[����]
�P��ƦW : �̾ھP��ƶq�A�̰��̬���1�W (�ϥ� dense_rank())
�Ƶ� �Ш̾ڦW���ӵ��w �Ƶ�����
�P��ƦW 1-3 �W : ���Z�P
�P��ƦW 4-6 �W : �Z�P
��L            : �ť�
*/
--�iSolution�j
select year(o.�q�f���) as �~��, ca.���O�W��, pd.���~�W��
	 , count(od.�q��s��) as �P��ƶq
	 , dense_rank() over (partition by year(o.�q�f���) order by count(od.�q��s��) desc) as �P��ƦW
	 --, case dense_rank() over (partition by year(o.�q�f���) order by count(od.�q��s��) desc)
	--	when  <=3 then '���Z�P'
	--	when  >=3 then '�Z�P'
	--	else ''
	--		end as �Ƶ�����
	 ,iif(dense_rank() over (partition by year(o.�q�f���) order by count(od.�q��s��) desc) <= 3, '���Z�P', '�Z�P') as �Ƶ�����
from �q�� as o, �q����� as od, ���~��� as pd, ���~���O as ca
where o.�q��s��= od.�q��s��
	 and od.���~�s��= pd.���~�s��
	 and pd.���O�s��= ca.���O�s��
group by year(o.�q�f���), ca.���O�W��, pd.���~�W��
order by �~��, �P��ƦW
go





/*06�i������ : �����������j10%
�Эp��C�@�Ө����Ӵ��ѵ��ڭ̤��q�U���X�ؤ��P�����O�B���~���ؼ�
[��X](�����ӽs��, �����ӦW��, *���P���~���O��, , *���P���~��)
[�Ƨ�]�����ӽs�� ���W
*/
--�iSolution�j
select pd.�����ӽs��, s.�����ӦW�� 
	 , count(distinct pd.���O�s��) as ���P���~���O��
	 , count(distinct pd.���~�s��) as ���P���~��
from ������ as s, ���~��� as pd, ���~���O as ca
where pd.�����ӽs��= s.�����ӽs��
	 and pd.���O�s��= ca.���O�s��
group by pd.�����ӽs��, s.�����ӦW�� 
order by �����ӽs��
go



/*07�i������ : �����������j10%
�Ьd�߾P��� �x���� ���Ȥ���A���@�����~���Q��(�P���Q)�̰��A�P�W�n�æC
[��X](���~�s��, ���~�W��, *�P���Q)
*/
--�iSolution�j
select pd.���~�s��, pd.���~�W��
	 , sum((od.��ڳ��-pd.��������)* od.�ƶq) as �P���Q

from �Ȥ� as c, �q�� as o, �q����� as od, ���~��� as pd
where c.�Ȥ�s��= o.�Ȥ�s��
	 and o.�q��s��= od.�q��s��
	 and od.���~�s��= pd.���~�s��
	 and left(c.�a�}, 3)= '�x����'
group by pd.���~�s��, pd.���~�W��
order by �P���Q desc
go

/*08�i������ : �����������j10%
�Ьd�� �~�ȤH�� ���`�~�Z
[��X](*�`�~�Z)
[����]
�u�n���u�� ¾�� �� �~�Ȭ��� ���H���z��X��
�p��Ҧ��~�ȤH���ӱ��q�檺�`���B�A�Y�� �`�~�Z
*/
--�iSolution�j
select sum(od.��ڳ��* od.�ƶq) as �`�~�Z
from ���u as e, �q�� as o, �q����� as od
where e.���u�s��= o.���u�s��
	 and o.�q��s��= od.�q��s��
	 and e.¾�� like '%�~��%'
go

/*
select e.���u�s��, e.�m�W
	 , sum(od.��ڳ��* od.�ƶq) as �`�~�Z
from ���u as e, �q�� as o, �q����� as od
where e.���u�s��= o.���u�s��
	 and o.�q��s��= od.�q��s��
	 and e.¾�� like '%�~��%'
group by e.���u�s��, e.�m�W
go
*/


--�i�ƦX�D�j------------------------------

/*09�i������ : �����������j20%
�Ш̾ڥH�U���B�J�������D
1. �N�Ҫ��� diabetes.csv �פJ�A(�p)�ۤv�� CH07�d�Ҹ�Ʈw, ��ƪ�W�٬� diabetes (0%)
2. �п�X�Ҧ������A�A�s�W�@�� �~�ְ϶� ����� (10%)
[��X](�h��, ��}, ����, �ֽ��p��, �خq��, BMI, �}���f�Шt�\��, �~��, ���G, *�~�ְ϶�)
[����]�~�ְ϶��� 0+, 10+, 20+, 30+, 40+, ..........
3. ���F�Q�ݦ���ƶ����~�֤��G�A�Эp��C�@�Ӧ~�ְ϶����H�� (10%)
[��X](*�~�ְ϶�, *�H��)
*/
--�iSolution�j
--09-1
--�H�u�ާ@�A���μg�X��

--09-2
select*
	 , substring(cast(d.�~�� as varchar), 1, 1) + '0+' as �~�ְ϶�
from diabetes as d
go


--09-3
select substring(cast(d.�~�� as varchar), 1, 1) + '0+' as �~�ְ϶�
	 , count(d.�~��) as �H��
from diabetes as d
group by substring(cast(d.�~�� as varchar), 1, 1) + '0+'
go






