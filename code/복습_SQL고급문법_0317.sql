# 복습_우지윤74_0317

select * from customers;

## if 문법을 통해서 파생변수 만들어 보기!
## if 어떤 조건 만족하면 어떤 값으로 변경 아니면 다른 값 
## if (조건문, 해당 조건에 만족하면 어떤 값, 조건에 만족하지 못하면 어떤 값)

select * from orderdetails;
select if(quantityordered >=30, 'H','L') as cls_qo,ordernumber, 
	productcode 
    from orderdetails;
# 쉽게 파생변수 만들 수 있다.

#ifnull null값이면 어떤 값으로 대체하겠다.
#ifnull(null있는 기준 컬럼, null값을 대체할 값)

select  Customernumber
		, ifnull(addressLine2, 'No Addr')
	from customers;
    
#rank partion 함수
#rank 순위를 잡는 함수 
## rank()함수는 특정 집합 파티션 내에서 각행에 고유한 순위를 할당한다. partition과 같이 사용해서 기준을 정해서 rank등을 만들 수도 있다.
## 예를 들어 매출이 3개행이 100 ,100 100 -> 모두다 1등( 100이 가장 높은 값이면 ), 99 (4등)

## rank함수가 over(partiton by) 같이 사용한다.
## over(partiton by .. ) 세트를 파티션으로 나누는 개념 어떤 컬럼을 기준으로 잡고, 그 기준별로 다른 컬럼의 값을 내림차순, 오름차순이나 기타 정렬하는 경우 사용
## rank, over 합치면 -> 어떤 특정 기준 컬럼을 잡고, 다른 컬럼의 값을 기준으로 -> rank 순위를 잡을 수 있다.

## 고객들의 주문 횟수와 전체 주문 중에서 순위를 조회하는 것 ( 순위를 만드는 것 )
# rank함수를 이용해서 더 들어가 보면 고객이 -> 주문한 날짜를 순위로 잡고 몇 개 주문했는지도 확인할 수 있다. ( 날짜기준으로 봤을 때 rank로 순위를 잡아보자! )

select customernumber
	 , orderdate
     , rank() over(partition by customerNumber order by orderDate asc) as odrank
     from orders
     where customernumber = '114';
     
select customernumber
	 , orderdate
     , rank() over(partition by customerNumber order by orderDate desc) as odrank
     from orders
     where customernumber = '114';

## case when 사용하여 로직으로 파생변수 만들 수 있다.
## case when 여러가지 조건에 따른 값들을 만들 수 있다.

## 주문수량 * 각각의 주문금액 = 전체 주문금액 , 이 금액의 기준에 따라서 어떤 값의 기준을 만들 수 있다.
## 10,000원 이상이면 VIP, 10,000원 미만 5,000원 이상이면 Specail 등등.. 값에 기준에 따라 파생변수를 새롭게 만들 수 있다.

## case를 넣고
## when 조건에 따른 조건식1 then '특정값1'
## when 조건에 따른 조건식2 then '특정값2'
## else '특정값3'
## end as '알리아스지정'

select ordernumber
	, sum(quantityOrdered * priceEach) as ttamount
    , case
		when sum(quantityOrdered * priceEach) > 30000 then 'VIP'
        when sum(quantityOrdered * priceEach) > 20000 then 'SPECIAL' 
        when sum(quantityOrdered * priceEach) > 10000 then 'NORMAL'  
        else 'Cus'
	end as cus_cls
from orderdetails
group by ordernumber;

## with 절을 이용해서 쿼리 만들기
## 공통으로 사용할 테이블을 하나 만드는 것 
## 기존에 있는 테이블에서 내가 공통으로 필요하는 경우가 생긴다. 

## 고객의 주문 건을 이용해서 여러 테이블 만들어야 한다.
## 이런 경우 고객의 주문 건을 계속 사용해서 join을 해야 하는데 그럼 join할 때마다 새롭게 계속 테이블 가공해서 만들어야 한다.
## 이런 경우는 with 절을 이용해서 내가 계속 사용해야 하는 그 테이블을 만들어 두고 편하게 작업하는 경우

## 커스터머가 주문한 주문 수를 집계 해논 테이블 없다.
## 커스터머가 몇 개 주문했는지 이 집계 테이블을 하나 만들어서 계속 사용하고 싶다.

## with 절을 이용해서 쉽게 만들 수 있다.
## with 내가 만들 테이블의 이름을 넣고 (요구조건 쿼리 )
with customerorders as (select customernumber
	, count(*) as ordercount
     from orders
     group by customernumber 
     )
select c.customernumber 
	, c.customername
	, c.phone
    , customerorders.ordercount
    , o.orderdate
    , od.productcode
    , p.productname
    , (od.quantityOrdered * od.priceEach) as ttamount
    , case
		when od.quantityOrdered * od.priceEach > 5000 then 'VVIP'
        when od.quantityOrdered * od.priceEach > 3000 then 'VIP' 
        when od.quantityOrdered * od.priceEach > 2000 then 'Special'   
        else 'cus'
	end as cus_cls
 from customers as c
join customerorders 
	on c.customernumber = customerorders.customernumber
join orders o 
	on c.customernumber = o.customerNumber
join orderdetails od
	on o.ordernumber = od.ordernumber
join products p
	on od.productCode = p.productcode;
