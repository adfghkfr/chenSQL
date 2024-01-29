use ch07�d�Ҹ�Ʈw;

/*01�i������ : �����������j10%
�ЦC�X ��ڪA�Ȧ~�� ��15�~�B����27�~ �����u���
[��X](���u�s��, �m�W, �ʧO, ���Τ��, *��ڪA�Ȧ~��)
[�Ƨ�]��ڪA�Ȧ~�� ����
[����]��ڪA�Ȧ~�� �H ���Τ�� �ܦ��{�������ѭp
*/

--�iSolution�j

select ���u�s��, �m�W, �ʧO, ���Τ��
		, datediff(year, e.���Τ��,getdate()) as ��ڪA�Ȧ~��
from ���u as e
where datediff(year, e.���Τ��,getdate()) >=15 and datediff(year, e.���Τ��,getdate()) <27
order by ��ڪA�Ȧ~�� asc
go

--�iOtehr Solution�j
select ���u�s��, �m�W, �ʧO, ���Τ��, datediff(day,���Τ��,getdate())/365 as ��ڪA�Ȧ~��
from ���u
where datediff(day,���Τ��,getdate())/365 < 27 and datediff(day,���Τ��,getdate())/365 >=15
order by datediff(day,���Τ��,getdate())/365 desc
go

/*02�i������ : �����������j10%
�ЦC�X�ڭ̤��q���F �̪F�B�Ὤ�B�x�� ���~�A�C�@�ӿ����a�Ϧ��X�ӫȤ�
[��X](*����, *�a��, *�Ȥ��)
[�Ƨ�]���� ���W, �a�� ���W
[����]
1.���� �O���Ȥ�a�}���e�T�Ӧr�A�Ҧp �x�_��
2.�a�� �O���Ȥ�a�}��4-6�Ӧr�A�Ҧp ���s��
*/

--�iSolution�j

select  left(c.�a�}, 3) as ����, 
		substring(c.�a�},4,3) as �a��, 
		count(substring(c.�a�},1,6)) as �Ȥ��
from �Ȥ� as c
where left(c.�a�}, 2) not in ('�̪F','�Ὤ','�x��')
group by left(c.�a�}, 3), substring(c.�a�},4,3) 
order by ���� asc, �a�� desc
go


/*03�i������ : �����������j10%
�ЦC�X �w�s���� �̰����e���W(�P�W�n�æC�X��)�A�õ����ƦW�A�w�s�����̰�������1�W
[��X](���O�s��, ���O�W��, ���~�s��, ���~�W��, �w�s�q, ��������, *�w�s����, *�ƦW)
[����]
1.�ƦW��ƨϥ� rank()
2.�w�s���� �� �w�s�q * ��������
*/

--�iSolution�j
 select top 5
		 p.���O�s��, ca.���O�W��, p.���~�s��, p.���~�W��, p.�w�s�q, p.��������
		, p.�w�s�q*p.��������  as �w�s����
		,rank() over (order by p.�w�s�q*p.�������� desc ) as �ƦW
 from ���~��� as p, ���~���O as ca
 where p.���O�s�� = ca.���O�s��
go


/*04�i������ : �����������j10%
�Ьd�߾��~�֭p���A���@�ӫȤ�q�� �G�� �������~�ƶq�̦h
[��X](�Ȥ�s��, *�Ȥ�W��, �a�}, ���O�W��, *�q�ʲ��~�`�ƶq)
[����]
�p�G���ۦP�q�ʼƶq�A�n�æC�X��
*/
--�iSolution�j
select top 5 with ties c.�Ȥ�s��
			,���q�W�� as �Ȥ�W��
			, �a�}, ���O�W��
			 , sum(�ƶq) as �q�ʲ��~�`�ƶq
from �Ȥ� as c, �q�� as o, �q����� as od, ���~��� as p, ���~���O as ca
where c.�Ȥ�s�� = o.�Ȥ�s��
		and o.�q��s�� = od.�q��s��
		and od.���~�s�� = p.���~�s��
		and p.���O�s�� =ca.���O�s��
		and ca.���O�W�� = '�G��'
group by c.�Ȥ�s��, ���q�W��,�a�}, ���O�W��
order by �q�ʲ��~�`�ƶq desc
go

/*
�ϥ�Group By�l�y���ɭԡA�@�w�n�O��U�����@�ǳW�h�G
�]1�^����Group By�D�жq���������C�A
		  �p����Group By text�Aimage��bit�������C
�]2�^Select���w���C�@�C�����ӥX�{�bGroup By�l�y���A
		   ���D��o�@�C�ϥΤF�J�`�禡�F
�]3�^����Group By�b�����s�b���C�F
�]4�^�i����իe�i�H�ϥ�Where�l�y�������������󪺦�F
�]5�^�ϥ�Group By�l�y��^���ըS���S�w�����ǡA
		  �i�H�ϥ�Order By�l�y���w���ǡC
*/

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
select year(o.�q�f���) as �~��
	, ���O�W��, ���~�W��
	, sum(od.�ƶq) as �P��ƶq
	, dense_rank() over (partition by year(o.�q�f���) order by sum(od.�ƶq) desc) as �P��ƦW
	,case
	when dense_rank() over (partition by year(o.�q�f���) order by sum(od.�ƶq) desc) <=3 then '���׺Z�P'
	 when dense_rank() over (partition by year(o.�q�f���) order by sum(od.�ƶq) desc) <=6 then '�Z�P'
	else ''
	end as �Ƶ�����
from �q�� as o, �q����� as od, ���~��� as p, ���~���O as ca
where o.�q��s�� = od.�q��s��
	and od.���~�s�� = p.���~�s��
	and p.���O�s�� = ca.���O�s��
group by year(o.�q�f���),���O�W��,���~�W��
go

/*06�i������ : �����������j10%
�Эp��C�@�Ө����Ӵ��ѵ��ڭ̤��q�U���X�ؤ��P�����O�B���~���ؼ�
[��X](�����ӽs��, �����ӦW��, *���P���~���O�� , *���P���~��)
[�Ƨ�]�����ӽs�� ���W
*/

--�iSolution 1�j

select s.�����ӽs��, s.�����ӦW��
		,count(distinct p.���O�s��)   as ���P���~���O�� 
		,count(distinct p.���~�W��)  as ���P���~��
from ������ as s,  ���~��� as p,  ���~���O as ca
where s.�����ӽs�� =p.�����ӽs��
		and p.���O�s�� =ca.���O�s��
group by s.�����ӽs��, s.�����ӦW��
order by s.�����ӽs�� asc
go

--�iSolution 2�j
select s.�����ӽs��, s.�����ӦW��
		,count(distinct p.���O�s��)   as ���P���~���O�� 
		,count(distinct p.���~�W��)  as ���P���~��
from ������ as s
	 join ���~��� as p on s.�����ӽs�� =p.�����ӽs��
	 join ���~���O as ca on  p.���O�s�� =ca.���O�s��
group by s.�����ӽs��, s.�����ӦW��
order by s.�����ӽs�� asc
go


/*07�i������ : �����������j10%
�Ьd�߾P��� �x���� ���Ȥ���A���@�����~���Q��(�P���Q)�̰��A�P�W�n�æC
[��X](���~�s��, ���~�W��, *�P���Q)
*/

--�iSolution�j
 select top 1 with ties p.���~�s��, p. ���~�W��
		,  sum(od.�ƶq* (od.��ڳ�� - p.��������)) as �P���Q
 from �Ȥ� as c, �q�� as o, �q����� as od, ���~��� as p
 where c.�Ȥ�s�� = o.�Ȥ�s�� 
	and o.�q��s�� = od.�q��s��
	and od.���~�s�� = p.���~�s��
	and left(c.�a�},3) = '�x����'
group by p.���~�s��, p. ���~�W��
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
select sum(od.��ڳ��*od.�ƶq) as �`�~�Z
from  ���u as e, �q�� as o, �q����� as od
 where e.���u�s�� = o.���u�s��
	and o.�q��s�� = od.�q��s��
	and e.¾�� like '%�~��%'
go

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
select �h��, ��}, ����, �ֽ��p��, �خq��, BMI, �}���f�Шt�\��, �~��, ���G
     , cast(�~��/10 as varchar)+'0+' as �~�ְ϶�
from diabetes
go

--09-3
select cast(�~��/10 as varchar)+'0+' as �~�ְ϶�, count(1) as �H��
from diabetes
group by cast(�~��/10 as varchar)+'0+'
go



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
			,datediff(year,e.�X�ͤ��,getdate()) as �~��
			 ,'A' + cast(ntile(3) over (order by year(getdate())-year(e.�X�ͤ��) asc) as varchar) as �и�
from ���u as e
where e.�ʧO = '�k'
union
select ���u�s��, �m�W, �ʧO
			,datediff(year,e.�X�ͤ��,getdate()) as �~��
			 ,'B' + cast(ntile(2) over (order by year(getdate())-year(e.�X�ͤ��) asc) as varchar) as �и�
 from ���u as e
 where e.�ʧO = '�k'