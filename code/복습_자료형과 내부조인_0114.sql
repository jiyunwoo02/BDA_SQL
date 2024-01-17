# 복습_우지윤74_0114

select * from bda_sql3;
select * from bda_sql2;

## delete 삭제하기!
delete from bda_sql2;

## 지우는 것도 추가적으로 조건을 걸어서 지울 수 있다.
## 테이블 전체가 아니라 홍길동만 지우자

delete from bda_sql3
where mem_name = '홍길동';

# 이름이 정길동 지우는데 23세인 친구만 지워라
select *  from bda_sql3
where mem_name like '%길동'
and age = '23';

## 정길동만 날라감
select * from bda_sql3;

## SQL의 다양한 문법을 배우기!
## 자료형
## 정수, 문자, 실수, 날짜 ,자료형 변환, 변수 등 
## 자료형은 필수적으로 꼭 알고 있어야 한다.
## 자료형 내에도 다양한 범위와 형식이 있다.
## 데이터가 적재되고 쌓이는 값들을 데이터 형식으로 잘 지정해서 효율적으로 저장해야 한다!

## 정수형 int 바이트 수 숫자 범위들
## Tinyint   1  범위 : - 3자리수 +3자리수 등
## smallint 2 범위 : - 5자리수 +5자리수
## int 4 범위 : - 억단위 + 억단위
## bigint 8 범위 : +-조, 경단위 

create table bda_sql6(
	tinyint_col tinyint,
    small_col smallint,
    int_col int,
    bigint_col bigint);
    
select * from bda_sql6;

insert into bda_sql6 values(123,12345, 12345678, 1234567891011); 

# 범위를 넘어가는 경우
insert into bda_sql6 values(123, 12345, 12345678, 1234567891011231231231231231);

## 0 부터 시작하게 지정: unsigned
create table bda_sql8(
tinyint_col tinyint unsigned);
-- 0부터 시작한다 라는 조건은 unsigned  

select * from bda_sql8;
insert into bda_sql8 values(123);

##문자형
## 데이터 형식
## char(개수) 바이트 수 1~255
## varchar(개수) 바이트 수 1~16383

## char(3) 3개 글자 "고정길이" 문자 char(10) 10개는 확보가 되고, 그 안에서 2개 오건 3개가 들어오건 나머지는 낭비하면서 데이터를 쌓는다.
## varchar(10) 10개 글자 "가변형" 만약 varchar(10) 데이터가 3개가 들어오거나 4개가 들어오면 해당 길이만큼만 사용한다.

create table bda_sql10(
mem_id varchar(10));

select * from bda_sql10;

insert into bda_sql10 values('안녕하세요');

## 대량의 리뷰 데이터 타입 등은
## Text Text, longText

## Blob형식 동영상 등 
## Blob, LongBlob

## 실수형
## Float  바이트 수 4 소수점 아래 7자리까지 표현
## Double 바이트 수 8 소주점 아래 15자리까지 표현

## 날짜형
## Date 날짜만 저장 YYYY-MM-DD 형식 사용 
## Time 시간만 저장 HH:MM:SS 형식 사용
## Datetime YYYY-MM-DD HH:MM:SS 

## 변수 만들기
## set @변수이름 = 변수의 값;
## select @변수이름 ;

set @limit_amount = 3;
select @limit_amount;
select * from buy; 

select * from buy
where amount > @limit_amount;

select * from buy
where amount > 3;

## 자료형 변환 
## 자료 형변환: 직접 우리가 명시적인 변환으로 해서 직접 변환하는 것, 자연스럽게 변환되는 암시적 변환

# 함수 이용해서 변환
select sum(price) from buy;

# 문자열로 바꿔야 한다.
# cast 함수 convert 함수를 사용
# 사용하는 방법은 바꿀 컬럼을 감싸서 문법을 적는다

select cast(sum(price) as char(10)) as '문자로 바뀐 값' from buy;

select convert(sum(price), char(10)) as '문자로 바꾼 값' from buy;

select cast(mem_id as float) from buy;

## 기본적으로 데이터 형식에 맞는 자료형으로 꼭 변환을 해주셔야 합니다.
## 숫자나 문자의 구분은 확실하게 
## 회원번호 20201234 문자인가 숫자인가? 

## datetime 
select cast('2024/01/14' as date);
select cast('2024@01@14' as date);
select cast('2024-01-14' as date);
select cast('2024%01%14' as date);

select * from buy;

select num
	,concat(cast(price as char) , 'X', cast(amount as char) , '=') as '가격 x 수량'
    , price*amount '구매액'
    from buy;
    
select cast(price as char) 
from buy;

## join 
## inner join 내부 조인
select * from buy;
select * from member;

# 어떤 컬럼이 pk를 잡을 수 있는가? 조인될 조건은 무엇인가?
# mem_id 
## 문법적으로 작용시
## select <컬럼>
## from <조인할 첫 테이블>
## inner join <조인할 두 번째 테이블>
## on <조인될 조건>
## 추가 검색이나 정렬 등 where 

select * 
from buy
inner join member
on buy.mem_id = member.mem_id
where buy.mem_id ='BLK';

## 내가 원하는 컬럼만 뽑기! 
select buy.mem_id, mem_number, addr, price
from buy
inner join member
on buy.mem_id = member.mem_id
where buy.mem_id ='BLK';
#mem_id 는 두 개 테이블에 존재하는데 어떤 놈을 가지고와?
#겹치는 테이블 내에 컬럼은 에러를 발생한다 따라서 지정을 정확히 해야 한다!

select * from buy;
select * from member;

## 문법의 불문율 깔끔하게 정리하는 것

select b.mem_id
	, m.mem_number
	, m.addr
	, b.price
	from buy as b
		inner join member as m
		on b.mem_id = m.mem_id
	where b.mem_id ='BLK';
