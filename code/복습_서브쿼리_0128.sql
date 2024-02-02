# 복습_우지윤74_0128

select * from buy;
## 서브 쿼리 (subquery)
## 쿼리 안에 쿼리가 들어간 상태
## 조인을 하지 않은 상태에서도 테이블과 일치하는 행을 찾을 수 있고, join을 통해서도 또 할 수 있다.

## 효율적인 쿼리를 짤 때 이런 것들 응용하여 사용하는데
## 서브쿼리의 특징
## 1. 소괄호 안에 들어갑니다. ()
## 메인 쿼리 실행 전에 한 번만 실행이 된다.
## 비교 연산자에 서브쿼리 사용하려는 경우는 서브쿼리 오른쪽에 써야한다. 

## 서브쿼리도 어디에 들어가냐에 따라 다르게 사용할 수 있다.
## where 문에 들어갈 수 있다.
## select 문에 들어갈 수 있다.
## from 문에도 들어갈 수 있다.

## 단일행 서브쿼리 -> 하나의 값이 나올 예정
## 다중 서브쿼리  -> 여러 개의 값이 나올 예정 

## where절에서 사용하는 쿼리는 중첩서브쿼리 라고 부른다.
## where 안에 들어가는 내용이다보니 비교 연산자등과 함께 사용할 수 있다.
## 서브쿼리를 통해서 반환되는 결과가 단일, 다중에 따라서 문법도 달라질 예정이다.

select * from member
where mem_id ='APN';

select * from member
where mem_id = (select mem_id from member where mem_id = 'APN');

## 단일값과 다중값
select * from member
where mem_id = (select mem_id from member); # = 같다 라는 건 두 개의 값이 하나씩 동일하게 매핑 되어야 하는데 -> 여러 값이 생기니깐 문제가 발생 ( = 단일값)

select mem_id from member; #다중값 

## 다중값을 사용하게 된다면
select * from member
where mem_id in  (select mem_id from member); # in 은 다중값을 사용할 때 사용하는 문법

# = 단일값을 비교한다 1:1매칭
# in 다중값을 비교한다 다중매칭

# 단일값으로 서브쿼리를 만들어 보자!
select * from member
where mem_id = (select mem_id from member where mem_number = 4 and height >163);

# 새로운 테이블을 가지고 서브쿼리를 이용해서 값을 출력할 수 있지 않을까? ( 단일값 )

select * from buy
where price > 500;

# 새로운 테이블로 member 테이블을 서브쿼리로 출력해 보자!

select * from member
where mem_id = (select mem_id from buy where price >500);

select * from member
where mem_number = 4 and height >163;

## 다중행을 만들어 보기!
## 다중행 연산자 
## in : 서브쿼리 결과에 존재하는 값에 같은 조건 검색
## any : 서브쿼리 결과에 존재하는 어느 하나의 값이라도 만족하는 조건 검색 
## exists : 서브쿼리가 결과 만족하는 값이 존재하는 여부 확인
## all : 서브쿼리 겨로가에 존재하는 모든 값 만족하는 조건 검색
## not 을 붙이면 반대의 개념이 된다.

## 다중값
select * from member
where mem_id in (select mem_id from member);

## 다중값을 만들어 보자!
select * from member
where mem_id not in (select mem_id from member where height > 163);
# not 을 붙이면 그 외에 값으로 출력이 된다.

## 다중값도 다른 테이블과 같이 진행해 보자!
select * from member
where mem_id in (select mem_id from buy where price>30); # 중복된 값이 나왔어도 결국 member는 3개의 유니크한 값으로 출력이 되었다.

## join을 이용해서 서브쿼리를 만들어 보자! where 단일값
select * from member as m
	left outer join buy b
    on m.mem_id = b.mem_id
    where mem_name = (select mem_name from member where height =168); # member
    
select * from member as m
	left outer join buy b
    on m.mem_id = b.mem_id
    where m.mem_id = (select mem_id from buy where mem_id = 'GRL');    
    
select * from member as m
	left outer join buy b
    on m.mem_id = b.mem_id
    where b.mem_id = (select mem_id from buy where mem_id = 'GRL');    

## 위에는 소녀시대만 진행해서 하나의 값이 있는 결과만 나옴
## 이번에는 다양한 값이 있는 APN 출력되어서 서브쿼리 결과 확인

select * from member as m
	left outer join buy b
    on m.mem_id = b.mem_id
    where m.mem_id = (select mem_id from buy where price = 15 and amount =2);    

# 아래 쿼리는 APN 하나를 출력
## 출력값이 2개인데 둘다 APN 이더라도 단일값은 하나의 값이 나와야 해서 에러가 난다.

select * from member as m
	left outer join buy b
    on m.mem_id = b.mem_id 
    where m.mem_id = (select mem_id from buy where price = 15 and amount < 4);

## 조인을 한 상태로 다중값을 서브쿼리로 만들면 어떤 값이 나올까?
select * from member as m
	left outer join buy b
    on m.mem_id = b.mem_id 
    where m.mem_id in (select mem_id from buy where price = 15);

select * from member as m
	left outer join buy b
    on m.mem_id = b.mem_id 
    where b.mem_id in (select mem_id from buy where price = 15);

## left outer join 위치를 바꿔서 동일하게 서브쿼리를 진행!

select * from buy as b
	left outer join member m
    on m.mem_id = b.mem_id 
    where b.mem_id in (select mem_id from buy where price = 15);

#없는 값을 넣게 되면?
## 데이터 값이 없다고 나온다.
select * from buy as b
	left outer join member m
    on m.mem_id = b.mem_id 
	where b.mem_id in (select mem_id from member where height = 167);
