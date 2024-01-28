# 복습_우지윤74_0121

select * from member;
select * from buy;

select m.mem_id, m.addr, b.price from member m -- 메인 테이블 
	inner join buy b -- 옆에 붙이는 두 번째 테이블 
    on m.mem_id = b.mem_id;


select m.mem_id, m.addr, b.price from buy b -- 메인 테이블 
	inner join member m -- 옆에 붙이는 두 번째 테이블 
    on m.mem_id = b.mem_id;

## inner join의 경우는 교집합을 가지고 오는 것 

## inner join을 통해서 중복값을 제거하는 경우! distinct 사용하면 된다.
select distinct m.mem_id
	, m.mem_name
    , b. price
    from buy b
    inner join member m
    on b.mem_id = m.mem_id
    order by m.mem_id;
    
## 중복제거시 데이터베이스 내에 도메인을 잘 이해하지 못하고 컬럼을 추가하고 중복제거를 하게 되면 -> 잘못된 데이터 집계가 될 수 있다.

## 데이터베이스 검증하는 과정 중에서 중복값이 포함되어 있나 잘못된 경우를 간단하게 보는 방법!
# 중복된 값이 들어가 있는지 확인하는 가장 간단한 케이스는 pk의 값이 두 개 이상으로 묶여 있는지 확인해 보기! 
# 데이터 적재가 잘못되어있는지 케이스 확인
select mem_id,count(*) from member
group by mem_id
having count(*)>2;

## 중복된 값이 존재하는 지를 고유한 Mem_id를 가지고 체크해 보자! 
## mem_id groupby를 해서 중복된 값이 없다면 1로 모두 다 계산이 되는데, 중복된 값이 있으면 2로 집계되니 그 값이 있는지 확인하는 것!

## 외부조인
## left outer , right outer, full outer 
# inner 조인과 같게 문법은 동일하고 다만 inner 값에 (left, right ,full)  outer join 두 번째 테이블

select * from member;
select distinct mem_id from buy;
select * from buy;

select * from member m
	left outer join buy b
    on b.mem_id = m.mem_id
    where m.mem_id is not null;
## left outer join은 왼쪽이 기준이라서 모든 member 다 나온다. 
## buy에 있는 두 개 이상의 mem_id와 join 하다보니 여러 개의 값이 생기고, 추가로 buy 없는 값들은 null이 되어서 나온다.

select * from member m
	left outer join buy b
    on b.mem_id = m.mem_id
    where b.mem_id is not null;
    
## where 절에 m.mem_id와 b.mem_id의 차이가 존재하는데 이것이 존재하는 이유를 꼭 잘 이해해야 합니다.

select m.mem_id ,b.mem_id from member m
	left outer join buy b
    on b.mem_id = m.mem_id;
    # where m.mem_id is not null;
    
## join을 할 때도 꼭 신중하게 테이블, 데이터 도메인관계를 잘 이해해야 합니다!

## right outer join 
## left
## left outer join의 기준 테이블 모두 다 나와야 하는 member 
select * from member m
	left outer join buy b
    on b.mem_id = m.mem_id;
    
select * from buy;
## right outer join 
## right outer join의 기준 테이블은 모두 나와야 하는 데 buy
select * from member m
	right outer join buy b
    on b.mem_id = m.mem_id;

select * from buy b
	right outer join member m
    on b.mem_id = m.mem_id;
    
## 기준점에 대한 테이블을 자칫 잘못해서 잡게 되면 join한 테이블이 중복이나, 더블링의 잘못된 집계가 될 수 있다.

## mysql full outer join이 지원이 되지 않는다. 
select * from buy b
	full outer join member m # full outer join은 안 됩니다!
    on b.mem_id = m.mem_id;
    
## union , union all 절을 사용해서 full outer를 표현할 수 있다.
## union절은 모든 테이블의 값들을 하나로 합쳐버린다.

## union을 하게 되면 중복을 제거하고! 합치게 된다.

select * from buy;
select * from member;

select mem_id,price from buy
union 
select mem_id,mem_name from member;

## 중복을 포함하여 합치게 된다.

select mem_id,price from buy
union all
select mem_id,mem_name from member;

## union 절을 사용할 때는 위 아래로 두 개가 붙여진다고 생각하면 -> 같은 컬럼을 순서대로 사용해서 두 개를 합쳐야 한다.

##cartesian product 전체를 다 하나씩 곱해서 모든 경우의 수를 만드는 것
## cross join 

select * from buy
	cross join member;
    
# self join 
# 자기 스스로를 join 하는 경우 다른 테이블로 join 하는 것이 아니라 내가 나를 join해서 테이블을 새롭게 만든다.

# 직원, 직원의 상관 # 연락처
# 영업임원, 대표, 1234
# 대표, null, 0000
# 마케팅임원, 대표, 4567
# 마케팅팀장, 마케팅임원, 4567-1

## selft join 예시로 만들기
create table emp_table (emp char(4), manager char(4), phone varchar(8));
insert into emp_table values('대표',null, '0000');
insert into emp_table values('영업이사','대표', '1111');
insert into emp_table values('관리이사','대표', '2222');
insert into emp_table values('인사이사','대표', '3333');
insert into emp_table values('영업팀장','영업이사', '1111-1');
insert into emp_table values('관리팀장','관리이사', '2222-1');
insert into emp_table values('인사팀장','인사이사', '3333-1');
insert into emp_table values('인사팀원','인사팀장', '3333-1-1');

select * from emp_table;

## self join 
select a.emp '직원', b.emp '직속상관', b.phone from emp_table a
	inner join emp_table b
    on a.manager = b.emp;
