# 복습_우지윤74_0303

# creditlimit에 대한 조건 10,000원 초과만 추출!
select customerName, customerNumber from customers
	where creditlimit > 10000;

#고객 중에 country USA만 뽑는다면?
select * from customers
	where country ='USA';

#고객 중에 country USA 아닌 경우 뽑는다면?
select * from customers
	where country !='USA';

#날짜를 조정해서 원하는 데이터 추출
#주문이 2003-01-01 ~ 2003-02-01 추출 
select * from orders
	where orderdate between '2003-01-01' and '2023-02-01'
	order by 2 ; # ㅐorderdate 기준 정렬

# 커스터머 이름 중에서 La 이름이 들어가는 사람만 추출!
select customername from customers
	where customername like '%La%';

## join을 같이 진행해 보자!
## customer salesRepEmployeeNumber -> 해당 고객이 주문할 때 접촉한 직원 넘버
select * from customers;  #위의 있는 컬럼과 붙인다.

select * from employees; # employeeNumber

#중복이 있는지 체크하려면? 임직원 필드의 값이 중복이 있는지 없는지 체크해 보자!
select count(employeeNumber) from employees;
select count(distinct employeeNumber) from employees;
# -- 중복 제거 확인하니 없다.

select count(employeeNumber) from employees
	group by employeeNumber
	having count(employeenumber) >1;

select count(*) from customers;
## where salesRepEmployeeNumber is null; 
## 22명이 Null , 122명 전체, 100명이 Null이 아닌 사람

select count(customerNumber) from customers
	group by customerNumber
	having count(customerNumber) >1;

## 고객중에 sales 직원이 없는 경우가 있었다.
select * from customers;

# 다양한 조인을 했을 때 어떤 식으로 진행이 되었을까?
select count(*) from customers c 
	left join employees e 
	on e.employeeNumber = c.salesRepEmployeeNumber;
# 122개가 존재한다.

# left outer join 시
select count(*) from customers c 
	left outer join employees e 
	on e.employeeNumber = c.salesRepEmployeeNumber;
# 122 개가 존재한다.

# inner join 
select count(*) from customers c 
	inner join employees e 
	on e.employeeNumber = c.salesRepEmployeeNumber;
# 100개가 존재

## 반대로 조인하는 경우는?
## employees 를 메인으로 

# 왜 데이터값이 달라졌는지?

select count(*) from employees e  
	left join customers c 
	on e.employeeNumber = c.salesRepEmployeeNumber
	where c.salesRepEmployeeNumber is null;
#108개 존재

select * from employees e  
	left outer join customers c 
	on e.employeeNumber = c.salesRepEmployeeNumber
	where e.employeenumber = '1165';
# 108개 존재

select * from employees e  
	inner join customers c 
	on e.employeeNumber = c.salesRepEmployeeNumber
	where e.employeenumber = '1165';
# 100개 존재

## 3개 이상 테이블을 Join 하는 경우!

# 주문테이블은 총 326개
select count(distinct ordernumber) from orders;

#customers customersNumber 
#order customerNumber 두 개를 Join
select  c.customernumber, c.city, c.country, o.orderNumber, o.orderdate
	from customers c
	left outer join orders o 
	on c.customernumber = o.customernumber;

# 122개
# 326개 

select count(o.ordernumber) from customers c
	left outer join orders o 
	on c.customernumber = o.customernumber
	group by c.customernumber;

select  count(o.ordernumber) from customers c
	left outer join orders o 
	on c.customernumber = o.customernumber
	group by c.customernumber;

select count(c.customernumber) from customers c
	left outer join orders o 
	on c.customernumber = o.customernumber
	group by o.ordernumber
	having count(c.customernumber)>1;

select  o.ordernumber, count(c.customernumber) from customers c
	left outer join orders o 
	on c.customernumber = o.customernumber
	group by o.ordernumber;

# null값으로 인해서 문제가 발생했다.
# customernumber, customername, salesRepEmployeeNumber, orderNumber, orderDate, email
select c.customernumber, c.customername, c.salesRepEmployeeNumber, o.orderNumber, o.orderDate, ey.email from customers c 
	left outer join orders o 
	on c.customernumber = o.customernumber
	left outer join employees ey
	on c.salesRepEmployeeNumber = ey.employeeNumber
	where o.ordernumber is not null;

#실주문은 326개가 나와야 한다.
select count(*) from customers c 
	left outer join orders o 
	on c.customernumber = o.customernumber
	where o.ordernumber is not null;
##left outer join employees ey
##on c.salesRepEmployeeNumber = ey.employeeNumber
## where o.ordernumber is not null;

## 서브쿼리 자체로 작업을해서 where 먼저 정리하고 넣으는 벙법도 있다. 효율적으로 코드를 작성하는 경우는
# 실제 순 주문에 대한 고객 주문 테이블 join 완성
select * from employees;

# 24명의 범인은 ordernumber 없는 사람이다.
select * from employees;
