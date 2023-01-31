CREATE DATABASE bookstore;
USE bookstore;
CREATE TABLE book (
	book_ID INT PRIMARY KEY,
    book_NAME VARCHAR(40),
    publisher VARCHAR(40),
    price INT
    );
CREATE TABLE customer (
	cust_ID INT PRIMARY KEY,
    user_NAME VARCHAR(20),
    address VARCHAR(50),
    phone VARCHAR(20)
    );
CREATE TABLE orders (
	order_ID INT AUTO_INCREMENT PRIMARY KEY,
    cust_ID INT,
    book_ID INT,
    saleprice INT,
    orderdate DATE,
    FOREIGN KEY (cust_ID) REFERENCES customer(cust_ID), -- FOREIGN: 참조 키
    FOREIGN KEY (book_ID) REFERENCES book(book_ID)
    );
    
INSERT INTO book VALUES(1,'철학의 역사','정론사',7500);
INSERT INTO book VALUES(2,'3D 모델링 시작하기','한비사',15000);
INSERT INTO book VALUES(3,'SQL 이해','새미디어',22000);
INSERT INTO book VALUES(4,'텐서플로우 시작','새미디어',35000);
INSERT INTO book VALUES(5,'인공지능 개론','정론사',8000);
INSERT INTO book VALUES(6,'파이썬 고급','정론사',8000);
INSERT INTO book VALUES(7,'객체지향 Java','튜링사',20000);
INSERT INTO book VALUES(8,'C++ 중급','튜링사',18000);
INSERT INTO book VALUES(9,'Secure 코딩','정보사',7500);
INSERT INTO book VALUES(10,'Machine learning 이해','새미디어',32000);

INSERT INTO customer VALUES(1,'박지성','영국 맨체스터','010-1234-1010');
INSERT INTO customer VALUES(2,'김연아','대한민국 서울','010-1223-3456');
INSERT INTO customer VALUES(3,'장미란','대한민국 강원도','010-4878-1901');
INSERT INTO customer VALUES(4,'추신수','대한민국 부산','010-8000-8765');
INSERT INTO customer VALUES(5,'박세리','대한민국 대전',NULL);

INSERT INTO orders VALUES(NULL,1,1,7500,STR_TO_DATE('2021-02-01','%Y-%m-%d'));
INSERT INTO orders VALUES(NULL,1,3,44000,STR_TO_DATE('2021-02-03','%Y-%m-%d'));
INSERT INTO orders VALUES(NULL,2,5,8000,STR_TO_DATE('2021-02-03','%Y-%m-%d'));
INSERT INTO orders VALUES(NULL,3,6,8000,STR_TO_DATE('2021-02-04','%Y-%m-%d'));
INSERT INTO orders VALUES(NULL,4,7,20000,STR_TO_DATE('2021-02-05','%Y-%m-%d'));
INSERT INTO orders VALUES(NULL,1,2,15000,STR_TO_DATE('2021-02-07','%Y-%m-%d'));
INSERT INTO orders VALUES(NULL,4,8,18000,STR_TO_DATE('2021-02-07','%Y-%m-%d'));
INSERT INTO orders VALUES(NULL,3,10,32000,STR_TO_DATE('2021-02-08','%Y-%m-%d'));
INSERT INTO orders VALUES(NULL,2,10,32000,STR_TO_DATE('2021-02-09','%Y-%m-%d'));
INSERT INTO orders VALUES(NULL,3,8,18000,STR_TO_DATE('2021-02-10','%Y-%m-%d'));

-- 2. 집계
-- order 도시판매건수를 구하는 쿼리
SELECT COUNT(*) FROM orders;
-- 고객이 주문한 도서의 총 판매액을 구하는 쿼리
SELECT SUM(saleprice) FROM orders;
-- 고객이 주문한 도서의 총 판매액을 '총매출'로
SELECT SUM(saleprice) '총 매출' FROM orders;
-- 고객이 주문한 도서의 총 판매액 평균을 구하고 '매출평균'으로
SELECT AVG(saleprice) '매출 평균' FROM orders;
-- 고객이 주문한 도서의 총 판매액, 평균값, 최저가, 최고가
--              Total, Average, Minimum, Maximum
SELECT SUM(saleprice) Total, AVG(saleprice) Average, MIN(saleprice) Minimum, MAX(saleprice) Maximum FROM orders;

-- 책 가격이 22,000 미만인 도서 검색
SELECT book_NAME, price FROM book
	WHERE price < 22000;
-- 가격이 10,000보다 크고 20,000보다 작은 도서 검색(and)
SELECT book_NAME, price FROM book
	WHERE price > 10000 AND price < 20000;
-- 가격이 10,000보다 크고 20,000보다 작은 도서 검색(btween)
SELECT book_NAME, price FROM book
	WHERE price BETWEEN 10000 AND 20000;
-- 주문 일자가 2021/02/01~2021/02/07 사이에 주문 내역
SELECT * FROM orders
	WHERE orderdate BETWEEN '2021-02-01' AND '2021-02-07';
-- 도서번호가 3,4,5,6인 주문 목록 출력
SELECT * FROM orders
	WHERE book_ID BETWEEN 3 AND 6;
SELECT * FROM orders
	WHERE book_ID IN (3,4,5,6);

-- book price 가 NULL인 레코드 추가
INSERT INTO book VALUES (11,'SQL 기본 다지기','MS출판사',NULL);
-- 11번의 PRICE를 1000원을 올려서 출력
SELECT price+1000 FROM book WHERE book_ID=11; -- NULL값과 계산되지 않음
-- price 컬럼의 집계함수를 실행 sum, count, count(price)
SELECT SUM(price), COUNT(*), COUNT(price) FROM book;
SELECT SUM(price), COUNT(*), COUNT(price) FROM book WHERE book_ID < 11;
SELECT SUM(price), COUNT(*), AVG(price) FROM book; -- NULL값은 AVG 구할 때 적용 안됨
-- book에서 NULL인 레코드를 출력하는 쿼리
SELECT * FROM book WHERE price IS NULL;
-- customer에서 이름, 전화번호가 포함된 고객목록 조회, 전화번호가 없으면 '연락처 없음'으로 표시
SELECT user_NAME AS '이름', IFNULL(phone, '연락처 없음') '전화번호' FROM customer;

-- 박씨 성 고객 출력
SELECT user_NAME FROM customer
	WHERE user_NAME LIKE '박%';
-- 이름의 2번째 글자가 '지'인 고객 출력
SELECT user_NAME FROM customer
	WHERE user_NAME LIKE '_지%';
-- '철학의 역사'를 출간한 출판사 검색
SELECT publisher FROM book
	WHERE book_NAME='철학의 역사';
-- 도서 이름에 '파이썬'이 포함된 도서의 출판사 검색
SELECT book_NAME, publisher FROM book
	WHERE book_NAME LIKE '%파이썬%';
-- '썬'이라는 글자가 포함된 도서 중 가격이 20,000원 이상인 도서
SELECT * FROM book WHERE book_NAME LIKE '%썬%' AND price >= 20000;
-- 출판사 이름이 '정론사' 또는 '새미디어'인 도서 검색
SELECT book_NAME, publisher FROM book
	WHERE publisher='정론사' OR publisher='새미디어';
    
/* order by */
-- 도서 이름 순으로 검색
SELECT * FROM book
	ORDER BY book_NAME;
-- 도서 가격순으로 검색하고 가격이 같으면 이름순
SELECT * FROM book
	ORDER BY price, book_NAME;
-- 도서 가격의 내림차순으로 검색하고 가격이 같으면 출판사 이름 오름차순
SELECT * FROM book
	ORDER BY price DESC, publisher;
-- 주문일자 내림차순 정렬
SELECT * FROM orders
	ORDER BY orderdate DESC;
-- 책이름 중 '썬' 포함된 도서의 가격이 20,000원 미만인 도서 출판사 이름 오름차순
SELECT * FROM book WHERE book_NAME LIKE '%썬%' AND price < 20000
	ORDER BY publisher;
-- 판매가격이 1000원 초과인 책 id 내림차순 출력
SELECT * FROM book WHERE price > 20000
	ORDER BY book_ID DESC;