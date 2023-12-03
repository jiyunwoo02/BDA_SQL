-- 복습_우지윤74_1119

DROP DATABASE IF EXISTS market_db; -- 만약 market_db가 존재하면 우선 삭제한다.
CREATE DATABASE market_db;

USE market_db;
CREATE TABLE member -- 회원 테이블
( mem_id  		CHAR(8) NOT NULL PRIMARY KEY, -- 사용자 아이디(PK)
  mem_name    	VARCHAR(10) NOT NULL, -- 이름
  mem_number    INT NOT NULL,  -- 인원수
  addr	  		CHAR(2) NOT NULL, -- 지역(경기,서울,경남 식으로 2글자만입력)
  phone1		CHAR(3), -- 연락처의 국번(02, 031, 055 등)
  phone2		CHAR(8), -- 연락처의 나머지 전화번호(하이픈제외)
  height    	SMALLINT,  -- 평균 키
  debut_date	DATE  -- 데뷔 일자
);

CREATE TABLE buy -- 구매 테이블
(  num 		INT AUTO_INCREMENT NOT NULL PRIMARY KEY, -- 순번(PK)
   mem_id  	CHAR(8) NOT NULL, -- 아이디(FK)
   prod_name 	CHAR(6) NOT NULL, --  제품이름
   group_name 	CHAR(4)  , -- 분류
   price     	INT  NOT NULL, -- 가격
   amount    	SMALLINT  NOT NULL, -- 수량
   FOREIGN KEY (mem_id) REFERENCES member(mem_id)
);

-- 테이블의 멤버에 값 삽입하자
INSERT INTO member VALUES('TWC', '트와이스', 9, '서울', '02', '11111111', 167, '2015.10.19');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남', '055', '22222222', 163, '2016.08.08');
INSERT INTO member VALUES('WMN', '여자친구', 6, '경기', '031', '33333333', 166, '2015.01.15');
INSERT INTO member VALUES('OMY', '오마이걸', 7, '서울', NULL, NULL, 160, '2015.04.21');
INSERT INTO member VALUES('GRL', '소녀시대', 8, '서울', '02', '44444444', 168, '2007.08.02');
INSERT INTO member VALUES('ITZ', '잇지', 5, '경남', NULL, NULL, 167, '2019.02.12');
INSERT INTO member VALUES('RED', '레드벨벳', 4, '경북', '054', '55555555', 161, '2014.08.01');
INSERT INTO member VALUES('APN', '에이핑크', 6, '경기', '031', '77777777', 164, '2011.02.10');
INSERT INTO member VALUES('SPC', '우주소녀', 13, '서울', '02', '88888888', 162, '2016.02.25');
INSERT INTO member VALUES('MMU', '마마무', 4, '전남', '061', '99999999', 165, '2014.06.19');

INSERT INTO buy VALUES(NULL, 'BLK', '지갑', NULL, 30, 2);
INSERT INTO buy VALUES(NULL, 'BLK', '맥북프로', '디지털', 1000, 1);
INSERT INTO buy VALUES(NULL, 'APN', '아이폰', '디지털', 200, 1);
INSERT INTO buy VALUES(NULL, 'MMU', '아이폰', '디지털', 200, 5);
INSERT INTO buy VALUES(NULL, 'BLK', '청바지', '패션', 50, 3);
INSERT INTO buy VALUES(NULL, 'MMU', '에어팟', '디지털', 80, 10);
INSERT INTO buy VALUES(NULL, 'GRL', '혼공SQL', '서적', 15, 5);
INSERT INTO buy VALUES(NULL, 'APN', '혼공SQL', '서적', 15, 2);
INSERT INTO buy VALUES(NULL, 'APN', '청바지', '패션', 50, 1);
INSERT INTO buy VALUES(NULL, 'MMU', '지갑', NULL, 30, 1);
INSERT INTO buy VALUES(NULL, 'APN', '혼공SQL', '서적', 15, 1);
INSERT INTO buy VALUES(NULL, 'MMU', '지갑', NULL, 30, 4);

SELECT * FROM member;
SELECT * FROM buy;

-- select 문
-- sql 문법 구조
-- select 열 이름 from 테이블의 이름 where 조건식 group by 열 이름 having 조건식, order_by 열이름 limit 몇 개까지 출력될지!
-- select 문을 같이 배운다! from where 데이터를 찾는 정도를 배울 예정 

-- select 열이름만 가지고 오는 문법 -> 얘만 사용하면 열이름 속성의 튜플값만 가지고 온다.
select * from member;
select mem_id,mem_name from member;

select mem_name, mem_id,phone1 from member;  -- 열 자체의 값의 순서를 바꿀 수 있다.
select * from market_db.member;

-- select 열이름 from 테이블 이름 where 조건식

select * from member where mem_name = '에이핑크';

select mem_id, addr,mem_name from member where mem_name = '에이핑크';

select mem_id, addr,mem_name from member where mem_name = '마마무';

-- addr 기준으로 조건식을 걸면
select mem_id, addr,mem_name from member where addr = '전남';

-- where 조건에서 연산자를 사용하자! 관계연산자, 논리연산자
-- 관계연산자는 대소비교의 개념으로 > < >=  <= = 등이 있다.
-- 문자열은 '' 따옴표로 넣어야 된다. 숫자는 그냥 적어도 된다.

-- 키가 165이상인 경우의 데이터만 추출하는 것!
select * from member where height >= 165;

-- 여러 연산자를 같이 섞어서 해보기!
-- 논리연산자 and, or 조건 등이 있다. 
-- and조건을 이용하자!

-- 키가 165이상이고 멤버수가 6명 이상인 경우
-- and 둘 다 참이어야 한다.
select * from member where height >= 165 and mem_number >=6;

-- or 조건 또는 
select * from member where height >=165 or mem_number >=6;

-- in 조건문 조건식에서 여러 값이 있을 때 그 값이 있는지 없는지
select * from member where addr in ('서울','경기'); 

-- LIKE 문법 
-- 문자열의 일부 검색해서 내가 원하는 문자열이 있는 값을 출력한다. 
-- 신제품_abc_ddf 신제품이라는 값만 출력을 해서 보고싶다 라고 하면 like 문을 이용해서 신제품을 적고 출력
-- like '원하는값%'그 뒤는 어떤 값이어도 괜찮다.
-- '신제품%'
select * from member where mem_name like '%무';

select * from member where mem_name like '__무';

select * from member where mem_name like '__핑크';

-- where 조건절에 들어갈 문법을 배웠다.