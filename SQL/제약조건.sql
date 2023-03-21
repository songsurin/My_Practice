-- 1. 제약조건
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
select * from user_constraints where table_name='C_EMP'; --대문자로 적기

--제약조건 추가
alter table c_emp add constraint c_emp_name_un unique(name);
alter table c_emp modify name varchar2(25) not null;

--제약조건 삭제
alter table c_emp drop constraint c_emp_name_un;

--primary key
--제약조건이 설정되지 않은 테이블
create table c_emp (
id number,
name varchar2(25),
salary number,
phone varchar2(15),
dept_id number
);
insert into c_emp (id,name) values (1,'김철수'); 
insert into c_emp (id,name) values (1,'김기철'); 
delete from c_emp;
select * from c_emp;
--primary key 제약조건 추가
alter table c_emp add primary key(id);
--primary key 제약조건 삭제
alter table c_emp drop primary key;
--제약조건 이름 지정
alter table c_emp add constraint c_emp_id_pk primary key(id);
--사용자가 만든 제약조건 조회
select * from user_constraints where table_name='C_EMP';
insert into c_emp (id,name) values (1,'김철수'); 
insert into c_emp (id,name) values (1,'김기철');

--테이블 제거
drop table c_emp;
--제약조건 이름 추가
create table c_emp (
id number primary key,
name varchar2(25),
salary number,
phone varchar2(15),
dept_id number
);
select * from user_constraints where table_name='C_EMP';
insert into c_emp (id,name) values (1,'김철수'); 
insert into c_emp (id,name) values (1,'김기철'); 

--2. check 제약조건
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

--3. Foreign key 제약조건(외래키, 다른 테이블의 PK를 참조)
--테이블 제거
drop table c_emp;
--제약조건 추가
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
--에러 발생
insert into c_emp (id,name,dept_id) values (3,'park',50); --dept_id에 없는 숫자

--4. unique 제약조건
-- primary key : unique(중복안됨) + not null(필수입력)  
-- 테이블 제거
drop table c_emp;
create table c_emp (
id number,
name varchar2(25),
salary number,
phone varchar2(15),
dept_id number,
constraint c_emp_name_un unique(name)--중복 불가, null 가능
);
insert into c_emp (id,name) values (1,'kim');
--에러 발생
insert into c_emp (id,name) values (2,'kim'); --같은 값 입력불가
select * from user_constraints where table_name='C_EMP';
insert into c_emp (id) values (3); -- null 입력 가능
insert into c_emp (id) values (4);
select * from c_emp;
--제약조건 삭제
--alter table 테이블 drop constraint 제약조건이름
alter table c_emp drop constraint c_emp_name_un;

insert into c_emp (name) values ('kim');
insert into c_emp (name) values ('kim');
insert into c_emp (name) values ('kim');
select * from c_emp;