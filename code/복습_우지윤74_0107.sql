## 240107 SQL 문법기초반
## 복습_우지윤74_0107

select * from buy;

#내가 원하는 컬럼을 가지고 온다!
select num, mem_id
  from buy;
  
# 내가 원하는 컬럼에서 조건을 걸어 원하는 값을 가지고 온다!
select * from buy
where price > 200;
  
# 원하는 조건을 여러개 추가해 보자!
# 2 개 이상의 조건을 걸게 된다.
select * from buy
where price > 80
and amount>2; 

# 조건을 여러 개 추가하기
select * from buy
where price >50 
and amount >2;
-- and group_name ='디지털'

select num from buy
where price > 50
or amount >2;
-- gruop_name ='디지털';

select * from buy;
## and , or의 차이로 인해 행의 개수가 달라지고, 이러면 join 잘못하면 더블링 되거나 중복되는 값들이 발생할 수 있다!

## groupby 이용하여 집계함수 사용하기!
## sum, avg, min, max, count, count(distinct): 유니크 카운트 (중복값제거)
## 집계함수라는 것 groupby 하게 되면 -> 결과값은 집계함수 값으로 나온다.
## 기존테이블과 달라진다.

# groupby 사용해야 집계함수 이요할 수 있다.
select mem_id, sum(price) from buy
group by mem_id;

## 여러 개 추가하자!
# groupby 통해 기준 컬럼을 정하고 -> 해당 컬럼으로 다른 컬럼들의 집계함수를 만든다!
select * from buy;

select mem_id 
	, sum(price)
    , sum(amount)
    , count(mem_id) # 중복을 제거하지 않음
    , count(distinct(mem_id)) # 중복 제거!
from buy 
group by mem_id;

# groupby 2개 이상 해보기!
select mem_id
	, prod_name
    , sum(price)
    , sum(amount)
from buy
group by mem_id, prod_name;

## groupby 다르게 적기!
select 
	prod_name
    , mem_id
    , sum(price)
    , sum(amount)
from buy
group by prod_name, mem_id;

## 변수를 추가해서 진행
select mem_id as user_id # as를 써서 컬럼명 변경
	, sum(price * amount) '총 구매 금액'  #as를 쓰지 않고도 바로 변경할 컬렴을 사용할 수 있다! # 컬럼명은 꼭 문자와 숫자를 같이 사용하고, 문자만 사용하지 마세요!
   from buy
    group by mem_id;
    
-- groupby를 하지 않아도 전체 집계함수를 원하는 경우
select sum(price) from buy;
select avg(amount) from buy;

## count 중복이랑 중복되지 않은 것
# count는 널값을 제외하고 카운트한다.
select count(*) from buy;
select count(group_name) from buy;

select * from buy;

## groupby를 통해서 조건을 또 걸 수 있다.
select mem_id
	, sum(price*amount) as '총 구매 액'
    from buy
    group by mem_id
    having sum(price*amount) > 1000;
## 총 구매금액이 1,000 은 넘었으면 한다!

## groupby 는 where 절이 아니라 having 절을 사용해야 한다.
## groupby의 조건은 having 절과 함께 사용

select mem_id
	, sum(price*amount) as total
    from buy
    group by mem_id
    having total > 1000
    order by total desc; # desc 내림차순, asc 오름차순

## insert ,delete , create table 
## create table: 테이블 생성
## 예를 들어 buy 테이블을 가지고 학습한다 -> create table buy 같은 테이블을 하나를 더 만든다.
## insert란? buy 테이블 들어가 있는 값을 우리도 넣는다. alter

## 테이블 하나 만들기!
create table bda_sql (mem_id int, mem_name char(5), age int);

select * from bda_sql;

## insert 문으로 값을 넣기!
insert into bda_sql values (1, '홍길동' ,20);
select * from bda_sql;

## 두 개 값만 넣어보기
insert into bda_sql values (2, '박길동'); #매치가 안 되니 매치를 해서 값을 추가해야 한다. ERROR

## 매치를 통해 두 개의 값만 넣어보자! -> 나머지 값들은 NULL 로 채워진다!
insert into bda_sql(mem_id, mem_name) values(2,'박길동');

select * from bda_sql;

## auto_increment 
## 특정 열을 추가할 때 자동으로 index를 만들어서 추가해 주는 것!
## 멤버 id가 숫자형으로 1,2,3,4, 증가하는데 계속 insert 사용해야 하는데
## insert auto_increment 사용하면 자동으로 다음 번에는 3 이면 -> 4가 값에 입력 된다.

create table bda_sql2(
	mem_id int auto_increment primary key,
    mem_name char(5),
    age int);
    
select * from bda_sql2;

insert into bda_sql2 values(null, '홍길동',20);
insert into bda_sql2 values(null, '박길동',21);
insert into bda_sql2 values(null, '정길동',23);

## insert 할 때 mem_id 1000부터 시작하고 싶다.
alter table bda_sql2 auto_increment = 1000; #  auto 값을 바꿀 때 사용하는 문법

insert into bda_sql2 values(null, '이길동',25);

select * from bda_sql2;

## insert 문을 이용해서 하나씩 데이터의 값을 넣었다.
## 기존 테이블의 값을 이용해서 바로 새로운 테이블을 만들 수 있다.
## insert로 값을 계속 넣었는데, 이번에는 바로 테이블의 있는 값을 넣기!

create table bda_sql3(
	mem_id int auto_increment primary key,
    mem_name char(5),
    age int);
    
select * from bda_sql3;

## bda_sql3에 bda_sql2 테이블 값 넣는다
insert into bda_sql3 select mem_id, mem_name, age from bda_sql2;
    
select * from bda_sql3;

select mem_id, mem_name, age from bda_sql2;

select mem_name, avg(age) from bda_sql2
group by mem_name;

##1. 필수과제 create table 만들기 1개 전체 출력값
## 내용은 자유롭게 하셔도 됩니다! 
## 최소 컬럼은 4개 이상 만들어 주시고! ( 계산 가능한 숫자형 컬럼도 2개 이상 만들어 주세요! )
## 2. 동일하게 파생변수 숫자형 컬럼들끼리 * 해서 출력 2개
## 3. 조건을 걸어서 where 조건으로 값을 출력 2개
## 4. groupby 를 통해 집계함수 출력 2개
## 5. groupby 의 having 절을 이용해서 출력 2개

## 각 번호당 출력수는 2개 이상으로 해주세요! 
## sql 출력하는 문법이 9개 