# 복습_우지윤74_0218 <다양한 함수>

select * from member;

## 자료형 변환
## phone 컬럼을 두 개 합쳐야 하는 경우!
select phone1, phone2 from member;

## 두 개를 합치는 경우
select phone1 + phone2 from member;

# 2 개를 문자열 + 문자열 더해야 하는 경우 
select cast(phone1 as char(5)) + cast(phone2 as char(10)) from member;

#concat 함수를 사용해서 두 개를 붙이자! + 가 아닌 문자열 concat 함수 사용하기 문자열
select concat(cast(phone1 as char(5)), cast(phone2 as char(20))) from member;

# null 값이 존재
# 어떻게 해결하면 될까?
# isnull 
# ifnull 

# 내가 원하는 na 값을 이렇게 바꿀 수 있다.
select ifnull(phone1, '02') from member;

select * from member;

## 문자열 다루는 함수 중 lower, upper
select lower(mem_id), mem_id from member;

## 문자열 오른쪽 왼쪽 공백제거
## trim , rtrim ltrim
select ltrim('    abc');
select rtrim('abc     ')  ;

## 문자열 함수 중 substring(시작, 끝) 지정된 범위의 문자열을 반환하는 것
select * from member;
select substring(mem_name,3,6) from member;

## replace 특정 문자를 다른 문자로 대체하는 함수 
## replace(특정 문자, 바꿀 문자)
select replace(addr, '서울', '서울특별시') from member;

## 문자열 데이터 중 시계열 데이터

select debut_date from member;

#특정 연도, 월, 일을 추출하는 경우
#날짜 계산해야 하는 경우
#특정 날짜를 포맷을 바꾸는 경우

select debut_date
		, year(debut_date)
        , month(debut_date)
        , day(debut_date)
        from member;
 
# 날짜 포맷 변경할 때
# date_format
select date_format(debut_date, '%Y%m%d') from member;

# %Y , %y는 다르고 원하는 데이터 포맷을 추출할 수 있다.
select date_format(debut_date, '%y%m%d') from member;

## 데이터 검증에 필요한 count 진행!
select count(*) 
		, count(phone1)  from member; # 특정 값을 count 할 때 null 값이 제외되고 카운팅이 된다.

# 구매한 데이터 기준으로 볼 때 
# 중복된 값이 많이 존재한다. 
# 중복을 제외한 실 구매 mem_id를 원하는 경우?
select * from buy;

select mem_id ,count(*) from buy
group by(mem_id);

select count(mem_id) from buy;
select count(distinct(mem_id)) from buy; # 중복값이 발생하면 문제가 될 수 있다. 카운팅해야 한다.

select * from classicmodels.payments;

select count(customerNumber) from classicmodels.payments;
select count(distinct customerNumber) from classicmodels.payments;

select count(customerNumber) from classicmodels.payments
group by customerNumber
having count(customerNumber)>1;
#group by 를 이용해서 데이터 검증할 때 간단하게 확인

select * from classicmodels.payments;
select * from classicmodels.customers;

select customerNumber,count(orderNumber) from orders
group by customerNumber;

select count(*) from orders
where customerNumber = '124';

select * from customers as c
	left outer join orders as o 
    on c.customerNumber = o.customerNumber;
    ##where c.customerNumber = '124';

# 주문한 고객의 주문 번호와 현재 상태를 알고 싶다.

#중복이 발생하는가?
select count(productCode) from orderdetails;
select count(distinct productCode) from orderdetails;

select * from orderdetails;

select count(productCode) from orderdetails;
select count(distinct productCode) from orderdetails;

select * from orders;

select * from customers as c
	left outer join orders as o 
    on c.customerNumber = o.customerNumber
    left outer join orderdetails as ot
    on ot.orderNumber = o.orderNumber;
    
## 필수과제 
## 데이터 검증의 이슈를 직접 확인해서 이 데이터를 join 한 것이 맞는지 틀린지를 확인해야 한다!