-- 1126 복습과제_우지윤74

select * from member;
select * from buy;

-- select 사용하는 서브쿼리 
-- select 문을 가지고 하나의 요구조건을 만들어서 내가 원하는 데이터를 추출할 수 있다.

-- 쿼리를 너무 효율적이지 못하게 작성하면 쿼리만 도는데 몇 분이 ( 데이터추출 ) 작업이 안 된다.
-- 쿼리 자체를 효율적으로 짜야하고, 서브쿼리나 조인 등이나 할 때 저번에 배운 개념의 작동원리를 잘 이해하면 효율적인 쿼리를 짤 수 있다.

-- 내가 원하느 데이터를 추출하는데 내가 원하는 요구조건이 있다. 
-- 내가 원하는 요구조건등을 모두 다 검색하게 만들면 비효율이 발생할 수 있다. 
-- EX) 예를 들어 하나씩 인덱스를 다 찾아봐서 그 인덱스 중에 값을 비교해서 출력을 한다.
-- 데이터가 100만 개 라고 하면 100만 개를 다 봐서 내가 원하는 요구조건이랑 맞으면 select 가지고 온다.

-- 어떤 하나의 내가 원하는 테이블만 미리 만들어서 쿼리문에 알려주면 전체를 다 볼필요 없이 
-- 일단 1차적으로 내가 원하는 테이블 내에서만 검색해서 찾아라!

-- 예시데이터로 서브쿼리를 만들자!

select * from member;

-- 에이핑크의 키 이상인 경우의 멤버를 추출하는 것 
select mem_id,mem_name, height 
from member where height > 164;

-- 내가 원하는 요구조건 에이핑크 키보다 더 큰 멤버들만 추출하고 싶다.
select mem_id, mem_name, height 
from member where height > (select height from member where mem_name ='에이핑크');

-- where 조건 안에서 select 내가 원하는 테이블들만 가지고 와서 비교하여 출력하게 되는 경우 
-- 서브쿼리의 경우는 조인과 함께 많이 사용한다.
-- 내가 원하는 테이블들을 결합하여서 작동하는데, 내가 원하는 테이블을 그냥 전체 다 가지고 오게되면 무거워진다.
-- 서브쿼리 형태로 내가 원한는 테이블 형태를 따로 정리해서 1차로 같이 조인하거나 
-- 또는 where 조건 비교 등을 하면 더 효율적으로 작동이 되고 쿼리가 돌아간다. 


-- 소녀시대가 서울 addr 소녀시대와 같은 addr인 멤버의 아이디와 네임을 출력해 보자!
select mem_id, mem_name,addr 
from member where addr = (select addr from member where mem_name ='소녀시대');

select * from member;

-- 소녀시대의 phone1 와 동일한 멤버 아이디와 네임을 서브쿼리로 출력해 보자!
select mem_id, mem_name, phone1, phone2 from member 
where phone1 = (select phone1 from member where mem_name = '소녀시대');

-- 서브쿼리가 만약 두 개의 테이블로 구조가 되었다면?
select mem_id, mem_name, phone1 
from member where phone1 = (select phone1 from member where mem_name = '소녀시대');

-- select의 여러가지 문법

-- select
-- from
-- where
-- group by
-- having
-- order by
-- limit
	
-- 위의 내용이 query 순서인데, 위의 순서는 지켜야 한다.

-- order by 정렬이다, 내림차순, 오름차순 개념으로 정렬할 것이고, 정렬에 대한 기준이 1개인가 2개인도 정할 수 있다.
select * from member;
-- 날짜 순으로 데이터를 정렬하고 싶다!
select * from member 
order by debut_date;
-- 내림차순 오름차순, 디폴트가 오름차순이니깐 asc 내림차순 DESC

select * from member 
order by debut_date DESC;

-- 구분 에러가 나는 경우를 한 번 보자!

select * from member 
where addr = '서울' 
order by debut_date; 
-- where 절 앞에 orderby사용하면 문법에러 발생
-- select * from member order by debut_date where addr = '서울'; 

-- 내림차순 오름차순 2개 이상으로 지정a

select * from member 
where addr='서울' 
order by debut_date DESC, height ASC; -- 두 개이상의 컬럼을 조건 기준으로 만들 때 두 개를 나눠서 사용하기

select * from member 
where addr='서울' 
order by height DESC, debut_date ASC; -- 앞 뒤 순서에 따라 즉 가장 먼저 쓴 컬럼이 기준이 된다.

-- limit 출력하는 개수를 제한한다.
-- limit 시작, 개수 e.g ) limit 1,3 1번부터 시작해서 3개 출력
select * from member limit 3;

select mem_id
	, mem_name 
    from member 
    where addr = '서울'
    order by debut_date Desc
    limit 1;
	
select * from member;
select * from member limit 1,3;

-- 중복제거 distinct 
-- 속성 값의 중복을 제거하는 경우

-- addr 중복제거 하기
select * from member;

select distinct addr from member;

-- 중복제거에 옆의 다른 속성 붙으면 어떻게 될까?

select distinct addr 
	, debut_date
    from member;

select distinct addr
	, phone1
    from member;
    
-- 중복 제거를해도 만약 옆에 붙는 새로운 속성에서 중복이 아닌 유니크한 값이 되면 
-- 이 부분이 풀려서 출력이 되고 , 추가한 속성도 같이 중복이라면 중복이 제거 되어서 출력된다.

-- gruop by절
-- group by 그룹을 묶어버린다. 
-- -> 내가 원하는 데이터에서 어떤 그룹을 만들어서 해당 그룹의 통계치 ( 합계, 평균, 중위값, 카운팅 등등 ) 보려고 한다.

-- 요약 통계치만 데이터를 보여주고 싶은 경우 테이블이 여러가지로 나눠져 있으면 
-- 미리 그룹바이로 만들어서 테이블 만들고 해당 테이블에서 다른 테이블과 조인해서 작업을 하는 경우 ! 

select * from buy;

-- 통계치 보는 함수 sum, avg, min, max, count , count(distinct) 중복제거 행의 개수 

-- 어떤 컬럼을 기준으로 묶어서 요약을 볼 것인가? mem_id 

select mem_id , sum(amount) from buy group by mem_id;

select mem_id , sum(amount), AVG(price) from buy group by mem_id;

-- 통계치로 묶지 않은 속성이 들어가면?
select mem_id , sum(amount), AVG(price), prod_name from buy group by mem_id;

-- groupby 묶을 경우는 수치형 데이터를 기준으로 요약통계치를 낼 수 있는 경우가 대부분

select mem_id , sum(amount), AVG(price), count(prod_name) from buy group by mem_id;

-- 통계치 문법을 사용하지 않고 그냥 컬럼만 사용했다.
select mem_id , amount, price, prod_name from buy group by mem_id;

select * from member;
-- groupby 사용하지 않고 max, min 사용 가능

select max(debut_date) from member; 

select min(debut_date) from member;

-- 그냥 count 사용하면 중복 포함됩니다. count( distinct ) 
select count(addr) from member; -- 중복 포함된 카운

select count(distinct addr) from member; -- 중복 제거된 카운트

select (price*amount) from buy;

select mem_id, sum(price*amount) from buy
group by mem_id;
-- groupby 표현할 수 있다.
-- 컬럼끼리 서로 다이렉트로 곱해서 새로운 컬럼을 만들 수 있다.