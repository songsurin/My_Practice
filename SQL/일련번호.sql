delete from c_emp;
create sequence c_emp_seq
start with 1
increment by 1;

select c_emp_seq.nextval from dual; --���� ��ȣ/MYSQL�� auto_increment�� ���� ���

select c_emp_seq.currval from dual; --���� ��ȣ

insert into c_emp values(c_emp_seq.nextval, 'kim', 1000,'02-123-4567',10);

-- �������� �̿�
delete from c_emp;
select max(id)+1 from c_emp;
select nvl(max(id)+1, 1) from c_emp;
insert into c_emp values
((select nvl(max(id)+1,1) from c_emp) , 'park', 3000, '02-123-4567', 10);
insert into c_emp values
((select nvl(max(id)+1,1) from c_emp) , 'kim', 3000, '02-123-4567', 10);
insert into c_emp values
((select nvl(max(id)+1,1) from c_emp) , 'song', 3000, '02-123-4567', 10);


create sequence emp_seq
start with 300
increment by 1
maxvalue 999;

insert into c_emp (id, name, dept_id) values (emp_seq.nextval, 'kim', 10);

select * from c_emp;