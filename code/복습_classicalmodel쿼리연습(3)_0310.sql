# 복습_우지윤74_0310

select * from customers;
select * from products;
select * from employees;
select * from productlines;
select * from orderdetails;
select * from orders;

##Q1.오더 테이블 중 커스터머 넘버가 121,145,278,363 인 사람들의 오더번호와 오더날짜, status? 
select orderNumber, status, orderDate from orders
	where customerNumber in (121, 145, 278, 363);

## 다중 값을 확인하려면 in 을 넣어야 한다.
-- select orderNumber, orderDate, status, customerNumber from orders
-- where customerNumber = '121, 145, 278, 363';

select* from orders
where customerNumber = '121';
select* from orders
where customerNumber = '145';
select* from orders
where customerNumber = '278';
select* from orders
where customerNumber = '363';

##Q2. Q1의 고객의 customerName, Phone, country, crdeitLimit 은?
select orderNumber, orderDate, status
from orders where customerNumber in (121, 145, 278, 363);

select customerName, phone, country, creditlimit, o.customerNumber, o.orderNumber from orders o 
	left join customers c on o.customerNumber=c.customerNumber
    where o.customerNumber in (121, 145, 278, 363);

select customerNumber, phone, country, creditLimit from customers
	where customerNumber in (select customerNumber from orders
		where customerNumber in (121,145,278,363));

select * from customers;

select customerNumber from orders
where customerNumber in (121,145,278,363);

##Q3 Q2의 고객들의 prodcut_code는? select * from orderdetails; 여기서 가지고 와야 함
select customerName, phone, country, creditlimit, o.customerNumber, o.orderNumber from orders o 
	left join customers c on o.customerNumber=c.customerNumber
    where o.customerNumber in (121, 145, 278, 363);
    
select o.customerNumber, od.productCode from orders o 
	left join orderdetails od on o.orderNumber=od.orderNumber
    where customerNumber in (121, 145, 278, 363);
 
select * from orders;
select * from orderdetails;
    
select c.country ,od.productCode from orders as o
left outer join customers as c
on o.customerNumber = c.customerNumber
left outer join orderdetails as od
on o.orderNumber = od.orderNumber
where o.customerNumber in('121', '145', '278', '363');

select od.productCode from orders o
left join customers c
on c.customerNumber = o.customerNumber
left join orderdetails od
on od.orderNumber = o.orderNumber
where o.customerNumber in (121, 145, 278, 363);

select * from customers;
select * from customers;
select* from products;

## Q4 product name Ford 상품들의 구매한 고객들 평균 creditLimit은 어떻게 될까?
select * from products; #product name, product_code
select * from orders;  #ornumber _ customernumber
select * from orderdetails; # or number, pr_code
select * from customers; # customer의 creditlimit 존재한다.

# product name Ford, c.customernumber, o.ordernumber, od.productCode
select distinct avg (c.creditLimit) from customers c 
left  join orders o 
on c.customernumber = o.customerNumber
left  join orderdetails od
on od.orderNumber = o.ordernumber
left join ( select p.productcode from products p
where p.productName like '%ford%') as pp
on pp.productcode = od.productcode;

select avg(creditLimit)
from customers as c
left outer join orders as o
on c.customernumber = o.customerNumber
left outer join orderdetails as od
on od.orderNumber = o.orderNumber
left outer join products as p
on p.productCode = od.productCode
where p.productName like '%Ford%';

select avg(c.creditlimit) as avg_credit from customers as c
left outer join orders as o
on c.customerNumber = o.customerNumber
left outer join orderdetails as od
on o.ordernumber = od.ordernumber
left outer join products as p
on od.productcode = p.productCode
where productName like '%Ford%';

select * from customers;
select * from orders;

##Q5 주문이 shipped (order status shipped 이 아닌 사람들 ) 의 country 카운팅? (나라별로 어떻게 카운팅 되는지? )
select c.country, count(c.country) from customers as c
left join orders as o
on c.customerNumber = o.customerNumber
where o.status !='Shipped'
group by c.country;
