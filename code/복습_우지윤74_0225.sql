# 복습_우지윤74_0225

select * from orders;
select * from orderdetails;
select * from customers;

## 주문 테이블을 통해서 join과 함께 다른 컬럼을 계산해 보자!
select * from orders; # 오더넘버, 주문날짜, 요청, 배송 배송상태
select * from orderdetails; # 가격과, 수량, 상품코드

#수량 * 단가 = 총매출액 
# quantityOrdered ,priceEach
# 실제 배송이 다 된 

select sum(bb.total_sales) from (select o.ordernumber
	,(od.quantityOrdered * od.priceEach) as total_sales
	from orders as o
	left outer join orderdetails as od
	on o.ordernumber = od.ordernumber) bb; # 9604190
    #where status != 'Shipped') bb; # 배송이 다 된 상태의 매출 
    
    
select o.ordernumber ,(od.quantityOrdered * od.priceEach) as total_sales
	from orders as o
	left outer join orderdetails as od
	on o.ordernumber = od.ordernumber
    where status = 'Shipped';
# 전체 매출은 '8865094.64' 
# 매출로 잡히지 않은 건 '739095.97'
# '9604190.61'

#group by 를 통해서 요약 값을 확인해 보자!
#전체 매출액을 oderdate에 따라서 확인해 보자!

select o.orderdate
	, sum(od.quantityOrdered * od.priceEach) as total_sales
	from orders as o
	left outer join orderdetails as od
	on o.ordernumber = od.ordernumber
	group by o.orderdate
	order by 1; # 테이블의 첫번째 컬럼 기준으로 정렬, 첫번째 열 기준으로 오름차순 정렬

## 날짜 컬럼이 들어가니 연도별, 월별 
## 월별로 매출을 뽑고 싶다.
select substring(o.orderdate, 1,7)
	, sum(od.quantityOrdered * od.priceEach) as total_sales
	from orders as o
	left outer join orderdetails as od
	on o.ordernumber = od.ordernumber
	group by substring(o.orderdate, 1,7)
	order by 1;

# 연도별 매출 뽑기 가능
select  sum(bb.total_sales) from (select substring(o.orderdate, 1,4)
	, sum(od.quantityOrdered * od.priceEach) as total_sales
	from orders as o
	left outer join orderdetails as od
	on o.ordernumber = od.ordernumber
	group by substring(o.orderdate, 1,4)
	order by 1)bb;
## 연도별로 묶은 게 실제 전체 Sum 과 맞는지 데이터 값 비교 진행

## 주문과 고객의 관계를 이용해서 데이터 살펴보기!
select * from orders;

# 전체 순 주문자 수 구하기 
# 실제 주문한 사람이 중복값이 있는지 체크하기!

select count(customernumber)
	, customernumber 
    from orders
group by customernumber
having count(customerNumber) >1;

# 중복을 제거한 순 주문자의 수
select count(distinct customerNumber) 
	from orders; # 98
    
#중복제거 비교 
select count(customerNumber)
	from orders; # 326

#월별기준으로 잡는다 구매자수, 주문건수를 비교하기!
# 자수, 건수 집계로 수를 계산 
select substr(orderdate, 1,7) mm
	, count(distinct ordernumber) as od
	, count(distinct customernumber) as cus
	from orders
	group by substr(orderdate, 1,7)
	order by 1;

# 고객 한명당 얼마나 금액을 지불하는지에 대한 AMV 값을 계산해 보자!
# 한 사람의 고객이 얼마나 주문당 얼마나 많은 비용을 지불하는가?

select * from orders; # customer
select * from orderdetails; # ordersum 

# 인당의 주문 금액이 얼마인지 계산하기 위해서는 
# 전체 주문액 / 실 주문자수 나누면 amv 값을 산출 할 수 있다.

select substring(o.orderdate, 1,7)
	, sum(od.quantityOrdered * od.priceEach) as total_sales
    , sum(od.quantityOrdered * od.priceEach) / count(distinct o.customernumber) as amv
	from orders as o
	left outer join orderdetails as od
	on o.ordernumber = od.ordernumber
	group by substring(o.orderdate, 1,7);

 select substring(o.orderdate, 1,7) as mm
	, sum(od.quantityOrdered * od.priceEach) as total_sales
    , sum(od.quantityOrdered * od.priceEach) / count(distinct o.customernumber) as amv
	from orders as o
	left outer join orderdetails as od
	on o.ordernumber = od.ordernumber
	group by substring(o.orderdate, 1,7);
    
## 주문수로 나누면 1주문당의 매출 금액이 나올 수 있다.
## 직접 진행해 보시면 좋을 것 같습니다.

select * from orders;
select * from orderdetails;

# cutomer 정보를 추가로 확인하고 싶다!
select * from customers;

## 주문한 사람의 사는 나라가 어디인지를 같이 확인해 보자!

select  o.orderdate
	, o.ordernumber
	, od.quantityOrdered * od.priceEach as total_sales
    , o.customernumber
    , c.country
	from orders as o
	left outer join orderdetails as od
	on o.ordernumber = od.ordernumber
    left outer join customers as c
    on o.customernumber = c.customerNumber;
    
## 국가별로 매출을 Sum해서 가장 높은매출을 가지고 있는 나라는 어디인가?
 
select bb.coun 
	,sum(bb.total_sales)
    from(select o.orderdate as od
	, o.ordernumber as onum
	, od.quantityOrdered * od.priceEach as total_sales
    , o.customernumber as cn
    , c.country as coun
	from orders as o
	left outer join orderdetails as od
	on o.ordernumber = od.ordernumber
    left outer join customers as c
    on o.customernumber = c.customerNumber) bb
    group by bb.coun
    order by 2 desc;

select  o.orderdate as od
	, o.ordernumber as onum
	, od.quantityOrdered * od.priceEach as total_sales
    , o.customernumber as cn
    , c.country as coun
	from orders as o
	left outer join orderdetails as od
	on o.ordernumber = od.ordernumber
    left outer join customers as c
    on o.customernumber = c.customerNumber
    
#select * from orders
#where status !='Shipped'