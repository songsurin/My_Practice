USE bookstore;
-- 총 주문량 조회 (ORDERS)
SELECT COUNT(orderid) '총 주문량' FROM orders;
-- NULL을 포함하여 COUNT를 하여 컬럼 비교 (CUSTOMER)
SELECT COUNT(*) 'NULL값 포함', COUNT(phone) 'NULL값 제외' FROM customer;
-- 평균 구매 가격을 조회 (ORDER, BOOK)
SELECT AVG(O.saleprice) '평균 구매 가격', AVG(B.price) '평균 가격' FROM orders O, book B;
-- 총 주문량과 평균 판매가
SELECT COUNT(*) '총 주문량', AVG(saleprice) '평균 구매 가격(NULL 제외)', AVG(IFNULL(saleprice,0)) '평균 구매 가격(NULL 포함)' FROM orders;
-- 고객이 주문한 도서의 총 판매액, 평균, 최저가, 최고가 구하고 판매된 도서의 종류 개수 조회
SELECT SUM(saleprice) '총 판매액', AVG(saleprice) '평균 판매 가격', 
	   MIN(saleprice) '최저가', MAX(saleprice) '최고가', 
       C.username '고객', COUNT(DISTINCT B.bookid) 
       FROM orders O, book B, customer C
       WHERE C.custid=O.custid
       AND O.bookid=B.bookid
       GROUP BY username;

-- GROUP BY/ 고객별로 주문한 도서의 총 수량과 총 판매액
SELECT C.username '고객', COUNT(O.bookid) '주문 도서 수량',
	SUM(O.saleprice) '주문 도서 총 금액' FROM orders O, customer C
    WHERE C.custid=O.custid
    GROUP BY C.username;
-- 고객이 주문한 도서의 총 판매액, 평균, 최소, 최대
SELECT C.username '고객', SUM(O.saleprice) '총 판매액', AVG(O.saleprice) '평균 판매액',
	MIN(O.saleprice) '최소 판매액', MAX(O.saleprice) '최대 판매액'
	FROM orders O, customer C
    WHERE C.custid=O.custid
    GROUP BY C.username;
-- custid, bookid 기준으로 그룹분석을 해서 saleprice 총합
SELECT custid '고객 아이디', bookid '책 아이디', SUM(saleprice) '총 판매 금액'
	FROM orders
    GROUP BY custid, bookid;
-- 구매 고객 가격이 8000원 이상 도서의 주문 수량을 구하는데 2권이상 주문한 고객의 이름, 수량, 판매금 조회
SELECT C.username '고객', COUNT(*) '주문 수량', SUM(O.saleprice) '총 주문 금액'
	FROM orders O
    LEFT JOIN customer C
    ON O.custid=C.custid
    WHERE O.saleprice>=8000 
    GROUP BY O.custid
    HAVING COUNT(*)>=2;
    
-- 집합 연산 UNION
-- 도서 주문에서 고객주소가 서울인 고객의 이름, 전화번호 출력
SELECT username, phone FROM customer
	WHERE address LIKE '%서울%';
-- 도서 주문에서 주소가 대한민국인 고객 이름, 전화번호 출력 (전화번호 없는 경우 '전화 없음' 표시)
SELECT username '고객', IFNULL(phone, '전화 없음') '전화번호' FROM customer
	WHERE address LIKE '%서울%' OR address LIKE '%대한민국%';
    
-- IN
-- 주문 테이블 40000원 이상 주문한 고객의 이름, 주소와 책 제목을 조회
SELECT custid FROM orders
	WHERE saleprice>=40000;
-- 주문 테이블에서 25000원 이상 주문한 고객의 이름, 주소, 책 제목 조회
SELECT C.username, C.address, B.bookname
	FROM customer C, book B
    WHERE C.custid IN (SELECT custid FROM orders WHERE saleprice>=25000);
    
-- 숫자 집계 함수
SELECT GREATEST(29, -100, 34, 8, 25);
SELECT GREATEST("windows.com", "microsoft.com", "apple.com");

-- ceiling
SELECT CEILING(30.25); -- 정수로 반환/무조건 올림
SELECT ROUND(30.75, 1); -- 원하는 자리에서 반올림

-- 평균 도서 가격
SELECT CEILING(SUM(price)/COUNT(price)) 평균1,
	   SUM(price)/COUNT(price) 평균2 FROM book;
       
-- 주문한 연도별 가격과 평균가격
SELECT YEAR(orderdate) 년도, SUM(saleprice) 합계, 
	CEILING(AVG(saleprice)) 평균 FROM orders
	GROUP BY YEAR(orderdate);

-- JOIN 활용하여 '이름' 그룹분석/고객의 전체 주문 횟수, 합계&평균&최소&최대 구매액 조회
SELECT C.username 이름, COUNT(O.orderid) 주문량, SUM(O.saleprice) '주문 금액 합계', 
	   CEILING(AVG(O.saleprice)) '주문 도서 평균 가격', 
       MIN(O.saleprice) '주문 도서 최소 금액', MAX(O.saleprice) '주문 도서 최대 금액'
       FROM customer C
       INNER JOIN orders O
       ON C.custid=O.custid
       GROUP BY C.username;

-- orders 테이블에서 주문금액의 합계, 평균, 최소, 분산, 표준편차 구하기
SELECT SUM(saleprice) 합계, AVG(saleprice) 평균, MIN(saleprice) 최소,
	   FORMAT(VARIANCE(saleprice),1) 분산, FORMAT(STD(saleprice),1) 표준편차
       FROM orders;
