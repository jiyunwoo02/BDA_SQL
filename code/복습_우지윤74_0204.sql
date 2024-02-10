# 복습_우지윤74_0204

Select * from member;
select * from buy;

select * from member as m
	left outer join buy b
    on m.mem_id = b.mem_id 
    where m.mem_id not in (select mem_id from buy where price = 15);

## any
## 다중행 서브쿼리
## 서브쿼리 결과값이 여러개여도 일치하는 모든 행을 메인 주 쿼리에서 실행하여 검색한 것을 반환
select * from member as m
	where mem_id = any( 
		select mem_id from buy where price = 15);

select * from member as m
where mem_id in ('GRL','APN');
# any 부등호를 다르게 설정하면 다르게 표현이 된다.

#  < any 서브쿼리 결과의 최솟값 
select * from member as m
	where mem_id < any( 
		select mem_id from buy where price = 15);

#  > any 서브쿼리 결과의 최댓값
select * from member as m
	where mem_id > any( 
		select mem_id from buy where price = 15);
    
## any 값은 서브쿼리 결과값이 여러개여도 일치하는 모든 행을 메인 주 쿼리에서 실행하여 검색한 것을 반환
## < 최솟값, > 최댓값 

# exists 문
# 조건의 결괏값이 있는지 없는지를 확인해 1행이라도 있으면 TRUE, 없으면 FLASE를 반환
# whrere exists 문 사용하면 -> 서브쿼리 결괏값이 1행이라도 있으면 TRUE 메인 주 쿼리 실행, 그 메인 쿼리에 작성된 전체 데이터를 검색하는 것

select * from member as m
	where exists ( 
		select mem_id from buy where price = 15);

select * from member as m
	where not exists ( 
		select mem_id from buy where price = 15);

##서브쿼리가 where 절이 아니라 from 문 안에 서브쿼리가 들어가는 경우
##inline view 인라인뷰 용어 사용 

## inner join으로 비교해 보자!
select m.mem_name, m.mem_id, b.price, b.prod_name from member m
inner join buy b
on m.mem_id = b.mem_id
where price > 50;

## from 절에 서브쿼리를 넣게 되면 ?
select m.mem_name, m.mem_id, b.price, b.prod_name from member m
inner join (select price, prod_name, mem_id from buy  where price >50)
as b on b.mem_id = m.mem_id;

## Select 문에 서브쿼리 사용
## 스칼라 서브쿼리 (scalar subquery) 
## 반드시 1개의 행을 반환해야 한다. 
## 집계함수들이랑 같이 사용하는 경우도 있다. 

## 스칼라 서브쿼리 작성시 정확한 다른 테이블간의 where 통해 join 하지 않으면 하나의 값으로 다 매핑될 수 있다.
## 그러나 두 개 테이블을 사용할 때 where 안에 두 테이블의 pk를 지정하고 값을 출력하면 하나의 값으로 매핑되어 반환된다.

select mem_name
	, (select mem_id from buy b where b.mem_id = m.mem_id and b.price>500) as over_price_mem_id ## 두 개 테이블 pk 지정
    , (select prod_name from buy where prod_name = '에어팟') ## buy 테이블에서 그냥 에어팟만 가지고 온 것
    , '에어팟2' ## 그냥 에어팟 문자열 데이터 넣은 것 
    , (select prod_name from buy b where b.mem_id = m.mem_id and prod_name ='에어팟') as '에어팟' ## 같은 에어팟이지만 두 개 테이블 위치 지정한 에어팟
    from member m;

#기존에 배웠던 group by를 이용해서 인라인뷰를 만들어 보자!
select * from member; #addr, member_name을 붙이고 싶다!

#에이핑크, 블랙핑크, 소녀시대, 마마무 4개가 반환
select b.mem_id
	, sum(b.price)
    , sum(b.amount)
    from buy b
	group by b.mem_id;

# member buy 조인 해야 한다!
#select m.mem_name, m.mem_id, b.price, b.prod_name from member m
#inner join (select price, prod_name, mem_id from buy  where price >50)
#as b on b.mem_id = m.mem_id;

select m.addr, m.mem_name, c.price_sum, c.amount_sum, c.mem_id
from member m 
inner join ( select b.mem_id
					, sum(b.price) as price_sum
                    , sum(b.amount) as amount_sum
                    from buy b 
                    group by mem_id) as c on m.mem_id = c.mem_id;
                    
select * from classicmodels.customers;
select * from classicmodels.orders