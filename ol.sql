DECLARE
    my_string VARCHAR2(200);
BEGIN
    my_string := 'hEllo ORACLE world';
    dbms_output.put_line(my_string);
END;

DECLARE
    my_string     VARCHAR2(100);
    my_number     NUMBER;
    my_date       DATE;
    my_exp_number NUMBER := 0;
    my_result     NUMBER;
BEGIN
    my_string := ' HELLO ORACLE WORLD';
    dbms_output.put_line('MY STRING IS :-' || my_string);
    my_number := 100;
    dbms_output.put_line(my_number);
    my_date := sysdate;
    dbms_output.put_line('MY DATE IS' || my_date);
    dbms_output.put_line('MY RESULT IS START:-');
    my_result := my_number / my_exp_number;
    dbms_output.put_line('MY RESULT IS' || my_result);
    dbms_output.put_line('MY_RESULT IS END:-');
END;

DECLARE
    my_string     VARCHAR2(100);
    my_number     NUMBER;
    my_date       DATE;
    my_exp_number NUMBER := 0;
    my_result     NUMBER;
BEGIN
    my_string := ' HELLO ORACLE WORLD';
    dbms_output.put_line('MY STRING IS :-' || my_string);
    my_number := 100;
    dbms_output.put_line(my_number);
    my_date := sysdate;
    dbms_output.put_line('MY DATE IS' || my_date);
    dbms_output.put_line('MY RESULT IS START:-');
    my_result := my_number / my_exp_number;
    dbms_output.put_line('MY RESULT IS' || my_result);
    dbms_output.put_line('MY_RESULT IS END:-');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('MY EXCEPTION');
END;



SELECT SUBSTR('SALARY',0,INDTR('SALARY',0))>0 FROM EMPLOYEES;


DECLARE
NUM1 NUMBER;
NUM2 NUMBER;
RES NUMBER;
BEGIN
NUM1 :=10;
NUM2 :=20;
RES :=NUM1+NUM2;
DBMS_OUTPUT.PUT_LINE('RESULT IS '||RES);
END;


 DECLARE
 N NUMBER :=10;
 T VARHCAR2(200) DEFAULT 'T';
 K VARHCAR2(100) NOTNNULL :='E';
 C CONSTANT NUMBER := 2;
 K CONSTANT BOOLEAN := FALSE;
 BEGIN
 DBMS_OUTPUT.PUT_LINE(N);
 T:= 'R';
 DBMS_OUTPUT.PUT_LINE(' T IS '||T);
-- K:= NULL  --NUL VALUE ASSIGNMENT

dbms_output.put_line(k);
end;
  
  DECLARE
  I NUMBER ;
  BEGIN 
  FOR I IN 1..5 LOOP
  DBMS_OUTPUT.PUT_LINE(I);
  END LOOP;
  END;
  
  declare 
k boolean :=True;
begin
dbms_output.put_line(k);
end;
  
  
  DECLARE
  N NUMBER ;
  BEGIN
  DBMS_OUTPUT.PUT_LINE(N);
  FOR I IN 1..10 LOOP
  N :=2*I;
  DBMS_OUTPUT.PUT_LINE(N);
  END LOOP;
  END;
  
  
   BEGIN
   FOR  I IN 1..20 LOOP
   IF(I=2) THEN
   DBMS_OUTPUT.PUT_LINE(I);
   END IF;
   END LOOP;
   END;
   
   
   SELECT FIRST_NAME,SALARY , COMMISSION_PCT FROM EMPLOYEES ;
   
   SELECT FIRST_NAME, SALARY,COMMISSION_PCT FROM EMPLOYEES WHERE COMMISSION_PCT IS NOT NULL;
   
   
   SELECT FIRST_NAME, SALARY,COMMISSION_PCT FROM EMPLOYEES WHERE COMMISSION_PCT IS  NULL;
   
   SELECT SALARY*NVL(COMMISSION_PCT,1) MONTHLY_SALARY, 12*SALARY*NVL(COMMISSION_PCT,1) YEARLY_SALARY FROM EMPLOYEES;
   
   SELECT * FROM EMPLOYEES;  
   
   SELECT SALARY FROM EMPLOYEES WHERE JOB_ID
   IN('IT_PROG','FI_ACCOUNT','ST_CLERK','SA_REP','AC_ACCOUNT');
   
   
   SELECT DISTINCT DEPARTMENT_ID FROM EMPLOYEES;
   
      SELECT DISTINCT FIRST_NAME, SALARY FROM EMPLOYEES ORDER BY FIRST_NAME;
      
      
      SELECT ASCII('a') FROM DUAL;
      SELECT ASCII('S') FROM DUAL;
      SELECT ASCII('K') FROM DUAL;
      SELECT ASCII('A') FROM DUAL;
      
      SELECT EMPLOYEE_ID , FIRST_Name,ascii(first_name) 
      from employees where 1=1 and first_name between 'KING' and 'SMITH';
      
       SELECT last_name, hire_date
FROM employees
WHERE hire_date < '01-FEB-08';

SELECT CURRENT_DATE FROM DUAL;

SELECT MONTHS_BETWEEN ('01-SEP-95','11-JAN-94') FROM DUAL;

SeLECT TO_char(MONTHS_BETWEEN( 'JANUARY', 'OCTOBER'))frOM DUAL;

set serveroutput on 

set SERVEROUTPUT on size 30000;

DECLARE 
N NUMBER :=10;
B NUMBER :=20;
BEGIN
DBMS_OUTPUT.PUT_LINE('SUM IS '||(N+B));
END;


select * from user_source;


CREATE OR REPLACE PACKAGE my_cal AS
    FUNCTION add (
        p_n1 IN NUMBER,
        p_n2 IN NUMBER
    ) RETURN NUMBER;     FUNCTION sub (
        p_n1 IN NUMBER,
        p_n2 IN NUMBER
    ) RETURN NUMBER; END my_cal; CREATE OR REPLACE PACKAGE BODY my_cal
AS FUNCTION add (
        p_n1 IN NUMBER,
        p_n2 IN NUMBER
    ) RETURN NUMBER
IS 
ln_sum number;
BEGIN 
ln_sum :=p_n1 + p_n2;
return ln_sum;
END add; 
FUNCTION sub (
        p_n1 IN NUMBER,
        p_n2 IN NUMBER
    ) RETURN NUMBER
IS 
ln_sub number;
BEGIN 
ln_sub :=p_n1 - p_n2;
return ln_sub;
END sub;
END my_cal;


  BEGIN 
  FOR I IN 1..5 LOOP
  FOR J IN 1..I LOOP
  DBMS_OUTPUT.PUT_LINE('*');
  END LOOP;
  DBMS_OUTPUT.NEW_LINE(' ');
  END LOOP;
  END;
 
 DECLARE
 N VARCHAR2(100):='';
 BEGIN
 FOR I IN 1..5 LOOP
 FOR J IN 1..I LOOP
-- N:=N||'*'||' ';
 DBMS.OUTPUT_PUT('*');
 END LOOP;
 END LOOP;
 END;
 
 
declare 
str varchar2(100);
rev varchar2(200);
begin
str:='rachit';
rev:=substr(str,instr(str,-1),1);
dbms_output.put_line('reverse is'||rev);
end;

declare
n number:=123;
rev number:=0;
rem number;
begin
for i in 1..3 loop
rem:=mod(n,10);
rev:=rev*10+rem;
n:=n/10;
end loop;
dbms_output.put_line('reverse is '||rev);
end;

declare
n number;
f number;
begin




DECLARE
num NUMBER;
rev NUMBER;
BEGIN

num =1234;
rev:=0;

WHILE num>0 LOOP

rev:=(rev*10) + mod(num,10);
num:=(num/10);
END LOOP;
DBMS_OUTPUT.PUT_LINE('Reverse of the number is: ' || rev);
END;


--reverse string

declare
name varchar2(100):= 'rachit';
begin
for i in 1..length(name)loop
dbms_output.put_line(substr(name,-i,1));
end loop;
end;

select lpad(salary,15,'*') from employees;

select rpad(salary,15,'*') from employees;

select lpad(salary,15,'*') ,rpad(salary,15,'*') from employees;


select * from employees emp where substr(lower(emp.first_name),-1) = 'n';

select emp.* from employees emp where length(lower(emp.first_name))=5 and substr(lower(emp.first_name),1,1)='a';

select instr(lower(first_name),'s'),first_name from employees where instr(lower(first_name),'s')=1 ;

select * from employees where length(salary)=4 and salary like '%0';


  select round((sysdate-hire_date))/7 week, round(sysdate-hire_date) days from employees ;
  
  select trunc('01-jan-23','year') from dual;
  select emp.* from employees emp where length(emp.salary)=4 and emp.salary like '%0';
   
   
   
   SELECT employee_id, hire_date,
ROUND(hire_date, 'MONTH'), TRUNC(hire_date, 'MONTH')
FROM employees
WHERE hire_date LIKE '%04';
  
  select emp.* from employees emp where lower(instr(emp.first_name),'e',1)=3;  
  
  select * from employees emp where lower(instr(emp.first_name,'e',1))=3;
  select  first_name,instr(first_name,3)='e' from
employees;

SELECT
    emp.*
FROM
    employees emp
WHERE
    instr((emp.first_name), 'e', 3) = 0;
    
    SELECT last_name,
TO_CHAR(hire_date, 'fmDD Month YYYY')
AS HIREDATE
FROM employees;

SELECT last_name,
TO_CHAR(hire_date,
'fmDdspth "of" Month YYYY fmHH:MI:SS AM')
HIREDATE
FROM employees;
  
  
  SELECT last_name, TO_CHAR(salary, '$9999,999.00') SALARY
FROM employees
WHERE last_name = 'Ernst';

SELECT TO_CHAR(salary, '$99,999.00') SALARY
FROM employees
WHERE lower(last_name) like 's%';


update employees set salary= salarY + to_number('100.00','9G99d99') where LOWER(last_name)= 'PERKINS';

SELECT SALARY FROM EMPLOYEES WHERE LAST_NAME = 'PERKINS';

SELECT *
FROM employees
WHERE hire_date = TO_DATE('May 24, 2007', 'MON DD, YYYY');

SELECT last_name, salary, NVL(commission_pct, 0),
(salary*12) + (salary*12*NVL(commission_pct, 0)) AN_SAL
FROM employees;


SELECT NVL(EMP.EMPLOYEE_ID,100) FROM EMPLOYEES EMP;

SELECT EMPLOYEE_ID FROM EMPLOYEES;

SELECT * FROM EMPLOYEES

SELECT NVL(DEPARTMENT_ID ,1001) FROM EMPLOYEES;

SELECT last_name, salary, commission_pct,
NVL2(commission_pct,
'SAL+COMM', 'SAL') income
FROM employees WHERE department_id IN (50, 80);

SELECT first_name, LENGTH(first_name) "expr1",
last_name, LENGTH(last_name) "expr2",
NULLIF(LENGTH(first_name), LENGTH(last_name)) result
FROM employees;


SELECT last_name, employee_id,COMMISSION_PCT,MANAGER_ID,
COALESCE(TO_CHAR(commission_pct),TO_CHAR(manager_id),
'NULL')
FROM employees;



CREATE OR REPLACE PACKAGE my_cal AS
    FUNCTION add (
        p_n1 IN NUMBER,
        p_n2 IN NUMBER
    ) RETURN NUMBER;     FUNCTION sub (
        p_n1 IN NUMBER,
        p_n2 IN NUMBER
    ) RETURN NUMBER; END my_cal; CREATE OR REPLACE PACKAGE BODY my_cal
AS FUNCTION add (
        p_n1 IN NUMBER,
        p_n2 IN NUMBER
    ) RETURN NUMBER
IS 
ln_sum number;
BEGIN 
ln_sum :=p_n1 + p_n2;
return ln_sum;
END add; 
FUNCTION sub (
        p_n1 IN NUMBER,
        p_n2 IN NUMBER
    ) RETURN NUMBER
IS 
ln_sub number;
BEGIN 
ln_sub :=p_n1 - p_n2;
return ln_sub;
END sub;
END my_cal;

CREATE OR REPLACE PROCEDURE my_test_prc1 (
    p_num1 IN NUMBER,
    p_num2 IN NUMBER
    --p_sum out number,
   -- p_sub out number
) 
  --RETURN NUMBER 
  IS
    ln_sum NUMBER;
    p_sum number;
    p_sub number;
BEGIN
    ln_sum := p_num1 + p_num2;
    p_sum := ln_sum;
    p_sub := p_num1 - p_num2;
    dbms_output.put_line(p_sum);
     dbms_output.put_line(p_sub);
    --RETURN ln_sum;
END my_test_prc1; SELECT
    *
FROM
    all_objects
WHERE
    object_name = 'MY_TEST_PRC'; SELECT
    MY_TEST(30, 30 )
FROM
    dual;
DECLARE 
p_sum number;
p_sub number;
n1 number;
n2 number;
BEGIN
n1:=10;
n2:=20;
my_test_prc1 (n1,n2);
--dbms_output.put_line(p_sum);
--dbms_output.put_line(p_sub);
END;

CREATE OR REPLACE PROCEDURE my_test_prc (
    p_num1 IN NUMBER,
    p_num2 IN NUMBER,
    p_sum out number,
    p_sub out number
) 
  --RETURN NUMBER 
  IS
    ln_sum NUMBER;
BEGIN
    ln_sum := p_num1 + p_num2;
    p_sum := ln_sum;
    p_sub := p_num1 - p_num2;
    --RETURN ln_sum;
END my_test_prc; SELECT
    *
FROM
    all_objects
WHERE
    object_name = 'MY_TEST_PRC'; SELECT
    MY_TEST(30, 30 )
FROM
    dual;
DECLARE 
p_sum number;
p_sub number;
n1 number;
n2 number;
BEGIN
n1:=10;
n2:=20;
my_test_prc (n1,n2 ,p_sum ,p_sub);
dbms_output.put_line(p_sum);
dbms_output.put_line(p_sub);
END;


CREATE OR REPLACE FUNCTION my_test (
    p_num1 IN NUMBER,
    p_num2 IN NUMBER
) RETURN NUMBER IS
    ln_sum NUMBER;
BEGIN
    ln_sum := p_num1 + p_num2;
    RETURN ln_sum;
END my_test; SELECT
    *
FROM
    all_objects
WHERE
    object_name = 'MY_TEST'; SELECT
    my_test(30, 30)
FROM
    dual;



<< outer >> DECLARE
    n NUMBER := 10;
BEGIN
    dbms_output.put_line('parent block');
    dbms_output.put_line(n);<< inner >> DECLARE
        n NUMBER := 20;
    BEGIN
        dbms_output.put_line('child block');
        dbms_output.put_line(n);
        dbms_output.put_line(outer.n);
    END;     dbms_output.put_line('parent block 1');
    dbms_output.put_line(n);
END;



DECLARE
    n NUMBER := 10;
BEGIN
    dbms_output.put_line('parent block');
    dbms_output.put_line(n);
    DECLARE
        n NUMBER := 20;
    BEGIN
        dbms_output.put_line('child block');
        dbms_output.put_line(n);
        dbms_output.put_line(n);
    END;     dbms_output.put_line('parent block 1');
    dbms_output.put_line(n);
END;

declare 
n number :=&value; -- to get user input
begin
dbms_output.put_line(n);
end;

SET SERVEROUTPUT ON SIZE 200000; declare 
k boolean := FALSE;
begin
IF k then 
dbms_output.put_line('RESULT');
else 
dbms_output.put_line('NO RESULT');
end if; 
end;

DECLARE 
n NUMBER; -- NULL ASSIGNMENT 
t varchar2(100) := 'My Test';
r varchar2(100) := 'My Test1';
y varchar2(100) := 'My Test2';
BEGIN
  for i in 1..5  
  loop
     for j in 1..2
     loop
     dbms_output.put_line('for value of i '||i ||' value of j '||j);
     end loop;
  end loop;
END;


DECLARE 
n NUMBER; -- NULL ASSIGNMENT 
t varchar2(100) := 'My Test';
r varchar2(100) := 'My Test1';
y varchar2(100) := 'My Test2';
BEGIN
if t ='My Test1'
then 
   dbms_output.put_line('Welcome1');
elsif  t ='My Test11' then 
   dbms_output.put_line('Welcome2');
elsif  y ='My Test2' then 
dbms_output.put_line('Welcome3');
   else 
    dbms_output.put_line('Welcome4');
end if; END;


DECLARE 
n NUMBER; -- NULL ASSIGNMENT 
t varchar2(100) := 'My Test';
r varchar2(100) := 'My Test1';
BEGIN
if t ='My Test'
then 
   if r = 'My Test21'
   then 
   dbms_output.put_line('Welcome1');
   end if;
   dbms_output.put_line('Welcome2');
end if; END;

--DECLARE 
--n NUMBER; -- NULL ASSIGNMENT 
BEGIN
--dbms_output.put_line(n);
FOR i in 1..10 loop
if (i = 2) then 
dbms_output.put_line(i);
else 
dbms_output.put_line('not two :- '||i);
end if;
--dbms_output.put_line(i);
--n := 2*i;
--dbms_output.put_line(n);
end loop;
--dbms_output.put_line(i);
END;

select substr('rachit.panwar@gmail.com',1,instr('rachit.panwar@gmail.com','.',1)-1) first_name ,instr('rachit.panwar@gmail.com','.',1)-instr('rachit.panwar@gmail.com','@',1) last_name, substr('rachit.panwar@gmail.com',instr('rachit.panwar@gmail.com','@',1)) domain_name from dual;


SELECT last_name, job_id, salary,
CASE job_id WHEN 'IT_PROG' THEN 1.10*salary
WHEN 'ST_CLERK' THEN 1.15*salary
WHEN 'SA_REP' THEN 1.20*salary
ELSE salary END "REVISED_SALARY"
FROM employees;

SELECT last_name,salary,
(CASE WHEN salary<5000 THEN 'Low'
WHEN salary<10000 THEN 'Medium'
WHEN salary<20000 THEN 'Good'
ELSE 'Excellent'
END) qualified_salary
FROM employees;

select first_name,salary, case when department_id=10 then salary+(salary*.1)
when department_id=20 then salary+(salary*.15)
when department_id =30 then salary+(salary*.20)
else salary+(salary*.25)
end "New salary"
from employees;



select emp.first_name,emp.salary, case when emp.department_id=10 then emp.salary+(emp.salary*.1)
when emp.department_id=20 then emp.salary+(emp.salary*.15)
when emp.department_id =30 then emp.salary+(emp.salary*.20)
else emp.salary+(emp.salary*.25)  
end "New salary"
from employees emp;

SELECT AVG(salary), MAX(salary),
MIN(salary), SUM(salary)
FROM employees
WHERE job_id LIKE '%REP%';

SELECT AVG(salary), MAX(salary),
MIN(salary), SUM(salary)
FROM employees;

SELECT MIN(hire_date), MAX(hire_date)
FROM employees;

SELECT COUNT(*)
FROM employees
WHERE EMPLOYEE_ID=90;

SELECT COUNT(commission_pct)
FROM employees
WHERE department_id = 50;

SELECT COUNT(DISTINCT department_id)
FROM employees;

SELECT * FROM EMOLOYEES WHERE TO_CHAR(HIRE_DATE,'RRRR')%4==0;

SELECT FIRST_NAME||' '||LAST_NAME FROM EMPLOYEES WHERE LENGTH(FIRST_NAME)=5 AND UPPER(FIRST_NAME) LIKE 'S%';
SELECT FIRST_NAME||' '||LAST_NAME, HIRE_DATE FROM EMPLOYEES WHERE lower(TO_CHAR(HIRE_DATE,'MONTH')) LIKE '_e%'; 
select first_name||' '||last_name from employees where length(first_name)=5 and lower(last_name) like '__n%';

select first_name||' '||last_name, salary from employees where lower(first_name) like '%ll%';


select last_day(sysdate)-sysdate from dual;

select round(sysdate,'rrrr') from dual;

select  employee_id,last_name , job_id, hire_date start_date from employees;

select distinct job_id from employees;

select department_id,count(*),avg(salary) from employees group by department_id , first_name ;

SELECT AVG(salary)
FROM employees
GROUP BY department_id;

SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id
ORDER BY department_id, AVG(salary);

SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id
having avg(salary)>8000;

SELECT  department_id, AVG(salary)


FROM employees
GROUP BY department_id;


set serveroutput on;
declare 
t varchar2(15):='rachoit';
c varchar2 (10);
begin
c:='robin';
dbms_output.put_line(t);
dbms_output.put_line(c);
end;



declare
v_salary number(8);
begin
select salary into v_salary from employees where employee_id=100;
dbms_output.put_line(v_salary);
end;



declare 
fname varchar2(20);
v_sal number(10);
begin
select salary, first_name into v_sal,fname from employees where employee_id=100;
dbms_output.put_line(fname||' has salary ' ||v_sal);
end;

select count(last_day(sysdate)) from dual;

select  (to_char(last_day(sysdate),'dd')) from dual;
select round(sysdate,'rrrr') from dual;


select  (to_char(last_day(sysdate),'dd-mm-rrrr')) from dual;

select first_name||' '||last_name ,salary from employees where salary like '%0';

declare
n constant number :=10;
begin
dbms_output.put_line(n);
--n := 11;
--dbms_output.put_line(n);
end; 

declare
n number;
begin
n:=30;
if(mod(n,2)=0)
then
dbms_output.put_line('even'||n);
end if;
dbms_output.put_line(' end of program');
end;


declare
n number;
b number;
sum number;
begin
n:=30;
b:=40;
sum:=n+b;
if(sum<50)
then
dbms_output.put_line('not greater than 50 '||sum);
else
dbms_output.put_line(' greater than 50 '||sum);
end if;
end;


declare
n number ;
begin
n := 50;
if mod(n,2)=0
then
dbms_output.put_line('even number'||n);
else
dbms_output.put_line('odd number'||n);
end if;
end;



declare
yr number;
begin
yr:=2023;
if(yr/4)=0 and (yr/100)=0 and (yr/400)=0
then
dbms_output.put_line('year is leap year'||yr);
else
dbms_output.put_line('not leap year'||yr);
end if ;
--end if;
--end if;
end

declare
n number:=8;
begin
if(mod(n,2)=0 and mod(n,5)=0)
then
dbms_output.put_line('no is div by 2 and 5');
else
dbms_output.put_line('not divisible');
end if;
dbms_output.put_line('end of progra');
end;


declare
n number:=8;
begin
if mod(n,2)=0
then
if mod(n,5)=0
then
dbms_output.put_line('no id divisible by 2 abd 5');
else
dbms_output.put_line(' no is divisible by 2 only');
end if ;
else dbms_output.put_line('no not divisible by 2 or 5');
end if;
end;


 
declare
n
number := 8;

BEGIN
    IF MOD(n, 2) = 0 THEN
        IF MOD(n, 5) = 0 THEN
            dbms_output.put_line('no id divisible by 2 abd 5');
        ELSE
            dbms_output.put_line(' no is divisible by 2 only');
        END IF;

    ELSE
        dbms_output.put_line('no not divisible by 2 or 5');
    END IF;
END;




--check id no is div by 2 or 5 ot not divisible

declare
n
number := 5;

BEGIN
    IF (
        MOD(n, 2) = 0
        AND MOD(n, 5) = 0
    ) THEN
        dbms_output.put_line('no is divisible by 2 and 5');
    ELSE
        IF (
            MOD(n, 2) = 0
            AND MOD  (n, 5) != 0
        ) THEN
            dbms_output.put_line(' no is only divisible by 2');
        ELSE 
            IF (
                MOD(n, 2) != 0
                AND MOD(n, 5) = 0
            ) THEN
                dbms_output.put_line(' no is only divisuble by 5');
            END IF;
        END IF;
    END IF;
    
END;
.


declare 
n number := 10;

 

begin
if (mod(n,2)=0 and mod(n,5)=0)
then 
dbms_output.put_line('divided by 2 and 5');
elsif mod(n,2) = 0 then
  dbms_output.put_line('divided by 2 only');
  elsif mod(n,5) = 0 then
  dbms_output.put_line('divided by 5 only');
  else
    dbms_output.put_line('not divided by 5 only');

 end if;
end;


declare
n number:= 10;
begin 
if mod(n,2)=0 ;
and
mod(n,5)=0 then
dbms.output.put_line(n ||''|| num divided by 2 only);

else if( mod(n,2)!=0) 
dbms.output.put_line(n ||''|| num divided by 5 only);
end if;
end;



declare
n number := 2000;
begin
if (n>1000 and n<2000)
then
dbms_output.put_line('a');
         else 
         if (n>2001 and n<3000)
then
dbms_output.put_line('b');
else if (n>3001 and n<4000)
then
dbms_output.put_line('c');
else if( n>4001 and n<5000)
then
dbms_output.put_line('d');
else
dbms_output.put_line('e');
end if;
end if;
end if;
end if;
end;