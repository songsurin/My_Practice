create or replace view emp_v
as
 select empno, ename, job, sal, deptno
 from emp;
select * from emp_v;

drop view emp_v;

-- �� ���� �� ����
create or replace view test_v
as
 select empno, ename, e.deptno, dname
 from emp e, dept d
 where e.deptno=d.deptno;
-- ������ ��� ���̺�ó�� ��� ����
select * from test_v;
-- ���̺�, �� ��� Ȯ��
select * from tab;
-- ���� ���� ���� Ȯ�� (������ ����)
select * from user_views;

