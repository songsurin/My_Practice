-- 1. ��������
create table c_emp(
id number(5) constraint c_emp_id_pk primary key,
name varchar2(25) ,
salary number(7,2) constraint c_emp_salary_ck
 check(salary between 100 and 1000),
phone varchar2(15) ,
dept_id number(7) constraint c_emp_dept_id_fk
 references dept(deptno)
);

select constraint_name from user_constraints;
select * from user_constraints where table_name='C_EMP'; --�빮�ڷ� ����

--�������� �߰�
alter table c_emp add constraint c_emp_name_un unique(name);
alter table c_emp modify name varchar2(25) not null;

--�������� ����
alter table c_emp drop constraint c_emp_name_un;

--primary key
--���������� �������� ���� ���̺�
create table c_emp (
id number,
name varchar2(25),
salary number,
phone varchar2(15),
dept_id number
);
insert into c_emp (id,name) values (1,'��ö��'); 
insert into c_emp (id,name) values (1,'���ö'); 
delete from c_emp;
select * from c_emp;
--primary key �������� �߰�
alter table c_emp add primary key(id);
--primary key �������� ����
alter table c_emp drop primary key;
--�������� �̸� ����
alter table c_emp add constraint c_emp_id_pk primary key(id);
--����ڰ� ���� �������� ��ȸ
select * from user_constraints where table_name='C_EMP';
insert into c_emp (id,name) values (1,'��ö��'); 
insert into c_emp (id,name) values (1,'���ö');

--���̺� ����
drop table c_emp;
--�������� �̸� �߰�
create table c_emp (
id number primary key,
name varchar2(25),
salary number,
phone varchar2(15),
dept_id number
);
select * from user_constraints where table_name='C_EMP';
insert into c_emp (id,name) values (1,'��ö��'); 
insert into c_emp (id,name) values (1,'���ö'); 

--2. check ��������
drop table c_emp;
create table c_emp (
id number(5) ,
name varchar2(25),
salary number(7,2) constraint c_emp_salary_ck
 check(salary between 100 and 1000),
phone varchar2(15),
dept_id number(7)
);
insert into c_emp (id,name,salary) values (1,'kim',500);
insert into c_emp (id,name,salary) values (2,'park',1500);

--3. Foreign key ��������(�ܷ�Ű, �ٸ� ���̺��� PK�� ����)
--���̺� ����
drop table c_emp;
--�������� �߰�
create table c_emp (
id number primary key,
name varchar2(25),
salary number,
phone varchar2(15),
dept_id number,
foreign key(dept_id) references dept(deptno)
);
insert into c_emp (id,name,dept_id) values (1,'kim',10);
insert into c_emp (id,name,dept_id) values (2,'park',20);
--���� �߻�
insert into c_emp (id,name,dept_id) values (3,'park',50); --dept_id�� ���� ����

--4. unique ��������
-- primary key : unique(�ߺ��ȵ�) + not null(�ʼ��Է�)  
-- ���̺� ����
drop table c_emp;
create table c_emp (
id number,
name varchar2(25),
salary number,
phone varchar2(15),
dept_id number,
constraint c_emp_name_un unique(name)--�ߺ� �Ұ�, null ����
);
insert into c_emp (id,name) values (1,'kim');
--���� �߻�
insert into c_emp (id,name) values (2,'kim'); --���� �� �ԷºҰ�
select * from user_constraints where table_name='C_EMP';
insert into c_emp (id) values (3); -- null �Է� ����
insert into c_emp (id) values (4);
select * from c_emp;
--�������� ����
--alter table ���̺� drop constraint ���������̸�
alter table c_emp drop constraint c_emp_name_un;

insert into c_emp (name) values ('kim');
insert into c_emp (name) values ('kim');
insert into c_emp (name) values ('kim');
select * from c_emp;