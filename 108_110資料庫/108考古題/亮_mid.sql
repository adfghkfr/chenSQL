/*
108�Ǧ~�ײĤ@�Ǵ� �O�_�j�ǲέp�t�B�έp��s�� ��Ʈw���λP�ӷ~���z���R �ҵ{ �����Ҹ� �Ѯv�G������

�ǥ;Ǹ��G410878050
�ǥͩm�W�G���G��
�q���W�١G 

�`�N�ƶ��G
1.�Х��N���ɮק��W�٬� : mid+�Ǹ��G�A�Ҧp�GmidA12345678.sql�A��ť�̽ж�g mid��ť������.sql
2.�H�U�Х�CH07�d�Ҹ�Ʈw�A���D���S�O���w
3.��X�ݩʦW�٫e�Y�O�� * �N��O �O�W �� �l�� �ݩ�
4.�кɶq�F���ϩR, �Ш̴`�B�J���A(�p)���y�k�O�i�H���檺�C
5.���i���檺�{���H0���p�A�i���檺�{���~���i�ೡ���|���������ơA�Y�O�h�Ӹ�ƪ�������join��~���������ơC
6.�����зǡA�|�]���C�@�D�����ߤ��P�A�|���Үt��
7.�����׶ȨѰѦҡA�|�]�ӤH�Ӳ�
8.�Ҹծɶ�  15�G15��17�G45
*/

use CH07�d�Ҹ�Ʈw

/*01�i������ : �����������j10%
�ЦC�X �U�@�u�� �جP�W��A�����̾ڨt�ήɶ��ӧP�_
[��X](���u�s��, �m�W, �ʧO, �X�ͤ��, *�ثe��ڦ~��, *�U�u�u�O)
[�Ƨ�]�Х��̾� �ʧO ���W�A�A�� �ثe��ڦ~�� ����
[����]�ثe��ڦ~�֡B�U�u�u�O ���O�H���榹�{����ѭp
*/
--�iSolution�j

select e.���u�s��, e.�m�W, e.�ʧO, e.�X�ͤ��
	 , datediff(year, e.�X�ͤ��, getdate()) as �ثe��ڦ~��
	 , datepart(qq, dateadd(qq, 1, getdate())) as �U�u�u�O
from ���u as e
where  datepart(qq, e.�X�ͤ��)= datepart(qq, dateadd(qq, 1, getdate()))
order by e.�ʧO asc, �ثe��ڦ~�� desc
go


/*02�i������ : �����������j10%
�ЦC�X�ڭ̤��q���F �̪F�B�Ὤ�B���� ���~�A�|�������Ǧa�Ϫ��Ȥ�
[��X](*����, �Ȥ�s��, *�Ȥ�W��)
[�Ƨ�]���� ���W
[����]
1.���� �O���Ȥ�a�}���e�T�Ӧr�A�Ҧp �x�_��
2.�Ȥ�W�� �N�O�Ȥ᪺���q�W��
*/
select distinct left(c.�a�}, 3) as ����
	 , c.�Ȥ�s��
	 , c.���q�W�� as �Ȥ�W��
from �Ȥ� as c
where left(c.�a�}, 2) not in ('�̪F','�Ὤ','����')
order by ���� asc
go



/*03�i������ : �����������j10%
�Ьd�ߩҦ����~���w�s�q�A�æC�X���ӦA�ɳf�����~���
�z����󬰮w�s�q < �w���s�q��95%
[��X](���~�s��, ���~�W��, �w�s�q, �w���s�q, *�ɳf�ƶq, *�ɳf���B)
[�Ƨ�]�̾� ���~�s�� ���W
[����]�ɳf�ƶq �P �ɳf���B ���n�p�Ʀ�ơA�p���|�ˤ��J����Ʀ��
[����]
1.�ɳf�ƶq���Ӭ� �w���s�q*1.5 �� �w�s�q, �åB�ȿ�X�ܾ�Ʀ��
2.�ɳf���B�� �ɳf�ƶq * ��������
*/
--�iSolution�j
select pd.���~�s��, pd.���~�W��, pd.�w�s�q, pd.�w���s�q
	 , cast(pd.�w���s�q*1.5- pd.�w�s�q as numeric(5, 0)) as �ɳf�ƶq
	 , cast((pd.�w���s�q*1.5- pd.�w�s�q) as numeric(5, 0))* pd.�������� as �ɳf���B
from ���~��� as pd 
where pd.�w�s�q< pd.�w���s�q*0.95
order by pd.���~�s�� asc
go



/*04�i������ : �����������j10%
�Ьd�߭q�椤���`�����(�����p�U)
[��X](�q��s��, ���u�s��, �q�f���, �X�f���, �w�p��f���, ��ڨ�f���)
[����]
�ҿת����`��ơA�O���w�X�f(�X�f��� is not null)�W�L(�j��)30�ѡA���o�S����f(��ڨ�f��� is null)
[����]null���P�_����ϥ� = null or != null�A�n�ϥ� is null or is not null �P�_
*/
select o.�q��s��, o.���u�s��, o.�q�f���, o.�X�f���, o.�w�p��f���, o.��ڨ�f���
from �q�� as o
where o.�X�f��� is not null 
	 and o.��ڨ�f��� is null
go



/*05�i������ : �����������j10%
�Ьd�߫Ȥ�a�}�N���O XX��XX�� �o���������
[��X](�Ȥ�s��, ���q�W��, �a�})
[�Ƨ�]�a�}����, �Ȥ�s�����W
*/
select c.�Ȥ�s��, c.���q�W��, c.�a�}
from �Ȥ� as c
where c.�a�} like '%__��__��%'
order by �a�} desc, �Ȥ�s�� asc
go




/*06�i������ : �����������j10%
�Ьd�ߥ����q���k���u�A�����ǤH���~�֤j�󵥩�55���Υ�¾�~��j�󵥩�25�~
[��X](���u�s��, �m�W, �ʧO, *�~��, *�~��)
[�Ƨ�]�ʧO ���W, �~�� ����
*/
select e.���u�s��, e.�m�W, e.�ʧO 
	 , datediff(year, e.�X�ͤ��, getdate()) as �~��
	 , datediff(year, e.���Τ��, getdate()) as �~��
from ���u as e
where e.�ʧO= '�k'
	 and (datediff(year, e.�X�ͤ��, getdate())>=55
	 or datediff(year, e.���Τ��, getdate())>=25)
order by �ʧO asc, �~�� desc
go



/*07�i������ : �����������j10%
�вM�d �w�s���� �j�󵥩� 2000�A�ӥB�w�s�q �j�󵥩� �w���s�q��1.5�����o�ǲ��~�A
�b�o�ǲ��~���w�s�������A�C�X�̰����e�T�����~���(�Y���P�W�n�æC)
[��X](���~�s��, ���~�W��, ���O�W��, ��������, �w�s�q, �w���s�q , *�w�s����)
[����] 
�w�s���� = �w�s�q * ��������
*/
select top 3 with ties pd.���~�s��, pd.���~�W��, ca.���O�W��, pd.��������, pd.�w�s�q, pd.�w���s�q
	 , pd.�w�s�q* pd.�������� as �w�s����
from ���~��� as pd, ���~���O as ca
where pd.���O�s��= ca.���O�s��
	 and pd.�w�s�q* pd.��������>= 2000
	 and pd.�w�s�q>= pd.�w���s�q* 1.5
order by �w�s���� desc
go



					   
/*08�i������ : �����������j10%
�вM�d�����q���Ǳq����X�����~���w�s����
[��X](���O�W��, ���~�s��, ���~�W��, �w�s�q, ��������, *�w�s����)
[�Ƨ�]���O�W�� ���W, ���~�s�� ���W
[����]
�w�s���� = �w�s�q * ��������
*/
select distinct ca.���O�W��, pd.���~�s��, pd.���~�W��, pd.�w�s�q, pd.��������
	 , pd.�w�s�q * pd.�������� as �w�s����
from ���~��� as pd, ���~���O as ca, �q����� as od
where pd.���O�s��= ca.���O�s�� 
	 and od.���~�s�� != pd.���~�s�� -- ����
order by ���O�W�� asc, ���~�s�� asc
go

select od.���~�s�� , pd.���~�s��
	 , iif(od.���~�s�� != pd.���~�s��, 1, 0)
from ���~��� as pd, ���~���O as ca, �q����� as od
go

--���T
select ca.���O�W��, pd.���~�s��, pd.���~�W��, pd.�w�s�q, pd.��������
	 , pd.�w�s�q * pd.�������� as �w�s����
from ���~��� as pd left join �q����� as od 
		on pd.���~�s��= od.���~�s��, ���~���O as ca
where pd.���O�s��= ca.���O�s��
	 and od.���~�s�� is null
go


/*08�i������ : �����������j10%
�Ьd�ߧڭ̤��q���Ȥ᳣���G�b���Ǥ��P������
[��X](����)
[�Ƨ�]�������W
[����]
�����O���a�}���e�T�Ӧr
*/
select left(c.�a�}, 3) as ����
from �Ȥ� as c
group by left(c.�a�}, 3)
order by ���� asc
go

select distinct left(c.�a�}, 3) as ����
from �Ȥ� as c
order by ���� asc
go


/*09�i������ : �����������j10%
�нL�d�����q�Ҧ����~���w�s�q�j�󵥩�w���s�q���o�ǲ��~���w�s���A
[��X](���O�W��, ���~�s��, ���~�W��, �w�s�q, �w���s�q, *�w�s���A)
[�Ƨ�]���O�W�� ���W, ���~�s�� ���W
[����]
�w�s���A ����
�p�G�w�s�q�p�󵥩�w���s�q��1.5���N��� '�w�s�q���`��'
�_�h�N��� '�w�s�q�L�q��'
*/

select ca.���O�W��, pd.���~�s��, pd.���~�W��, pd.�w�s�q, pd.�w���s�q
	, iif(pd.�w�s�q<= pd.�w���s�q*1.5, '�w�s�q���`��', '�w�s�q�L�q��') as �w�s���A
from ���~��� as pd, ���~���O as ca
where pd.���O�s��= ca.���O�s��
	 and pd.�w�s�q>= pd.�w���s�q
order by ���O�W�� asc, ���~�s�� asc
go





/*10�i������ : �����������j10%
�ѩ� �B�u�P���� ��a�����Ӫ����~�����A�X�G�O���ثe����������20%(���|�ˤ��J����ƦA�i����򪺭p��)
�иպ�æC�X�H�U�����, �s���������������|�ˤ��J��, �h���p�Ʀ��
[��X](�����ӦW��, ���O�W��, ���~�s��, ���~�W��, ��������, �w�s�q, �w���s�q, *�i�f�q, *�s���w�s�q, *�s����������)
[�Ƨ�]���O�W�� ���W, ���~�s�� ���W
[����]
�i�f�q : �p�G�w�s�q�p��w���s�q�N�i�f1000�A�_�h�N�i�f500
�s���w�s�q : �w�s�q + �i�f�q
�s���������� : (�쥻���w�s����+�i�f����)/�s���w�s�q
*/

select s.�����ӦW��, ca.���O�W��, pd.���~�s��, pd.���~�W��, pd.��������, pd.�w�s�q, pd.�w���s�q
	 , iif(pd.�w�s�q< pd.�w���s�q, 1000, 500) as �i�f�q
	 , pd.�w�s�q+ iif(pd.�w�s�q< pd.�w���s�q, 1000, 500) as �s���w�s�q
	 , cast((pd.�w�s�q* pd.��������+ iif(pd.�w�s�q< pd.�w���s�q, 1000, 500)* round(pd.��������* 1.2, 0))
	 / (pd.�w�s�q+ iif(pd.�w�s�q< pd.�w���s�q, 1000, 500)) as numeric(5, 0)) as �s����������	 
from ������ as s, ���~��� as pd, ���~���O as ca 
where s.�����ӽs��= pd.�����ӽs��
	 and pd.���O�s��= ca.���O�s��
	 and s.�����ӦW�� in ('�B�u', '����')
order by ca.���O�W�� asc, pd.���~�s�� asc
go



/*�`�N
1. �u���n�ݤӧֳs��
2. �D�جݲM�� where������n�Χ���
3. �[�k�B��O�o�n�A��
*/