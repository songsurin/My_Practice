create or replace view emp_v
as
 select empno, ename, job, sal, deptno
 from emp;
select * from emp_v;

drop view emp_v;

-- 뷰 생성 및 변경
create or replace view test_v
as
 select empno, ename, e.deptno, dname
 from emp e, dept d
 where e.deptno=d.deptno;
-- 생성된 뷰는 테이블처럼 사용 가능
select * from test_v;
-- 테이블, 뷰 목록 확인
select * from tab;
-- 뷰의 세부 정보 확인 (데이터 사전)
select * from user_views;

