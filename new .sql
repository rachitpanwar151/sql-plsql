SELECT
    *
FROM
    employees emp
WHERE
    first_name LIKE '__t%';

SELECT
    *
FROM
    employees emp
WHERE
    emp.salary BETWEEN 5000 AND 15000
    AND ( emp.department_id = 50
          OR emp.department_id = 60 )
    AND length(emp.last_name) = 4;

SELECT
    *
FROM
    employees emp
WHERE
    emp.salary BETWEEN 5000 AND 15000
    AND emp.department_id IN ( 50, 60 )
    AND length(emp.last_name) = 4;

SELECT
    *
FROM
    employees emp
WHERE
    emp.salary BETWEEN 5000 AND 15000
    AND emp.department_id = 50
    OR emp.department_id = 60
    AND length(emp.last_name) = 4;

SELECT
    *
FROM
    employees emp
WHERE
    emp.salary BETWEEN 5000 AND 15000
    OR emp.department_id = 50
    OR emp.department_id = 60
    AND length(emp.last_name) = 4;

SELECT
    *
FROM
    employees
WHERE
    salary BETWEEN 5000 AND 15000
    OR department_id IN ( 50, 60 )
    AND length(last_name) = 4;

SELECT
    *
FROM
    employees
WHERE
    salary BETWEEN 5000 AND 15000
    AND department_id IN ( 50, 60 )
    AND length(last_name) = 4;

SELECT
    *
FROM
    employees
WHERE
    salary IN ( 5000, 15000 )
    AND department_id IN ( 50, 60 );

SELECT
    *
FROM
    employees
WHERE
    commission_pct IS NULL
    AND lower(job_id) LIKE 'p%';

SELECT
    *
FROM
    employees
WHERE
    lower(first_name) LIKE 's%';

SELECT
    *
FROM
    employees
WHERE
    first_name LIKE lower('s%');

SELECT
    months_between('01-SEP-95', '11-JAN-94')
FROM
    dual;

SELECT
    current_date
FROM
    dual;	XEPDB1
SELECT last_name, hire_date
FROM employees
WHERE hire_date < '01-FEB-08';
SELECT EMPLOYEE_ID , FIRST_Name
      from employees where 1=1 and first_name IN('King' , 'Smith');
SELECT EMPLOYEE_ID , FIRST_Name
      from employees where 1=1 and first_name IN('KING' , 'SMITH');	
SELECT EMPLOYEE_ID , FIRST_Name,ascii(first_name) 
      from employees where 1=1 and first_name between 'KING' and 'SMITH';	
SELECT EMPLOYEE_ID , FIRST_Name,ascii(first_name) 
      from employees where 1=1 and first_name between 'king' and 'smith';	
SELECT ASCII('A') FROM DUAL;	
SELECT ASCII('K') FROM DUAL;	
SELECT ASCII('S') FROM DUAL;	
SELECT ASCII('a') FROM EMPLOYEES;
SELECT DISTINCT *FROM EMPLOYEES WHERE 1=1 AND SALARY BETWEEN 3000 AND 5000;	
SELECT *FROM EMPLOYEES WHERE 1=1 AND SALARY BETWEEN 3000 AND 5000;	
SELECT *FROM EMPLOYEES WHERE SALARY BETWEEN 3000 AND 5000;	
SELECT DISTINCT FIRST_NAME, SALARY FROM EMPLOYEES ORDER BY FIRST_NAME;	
SELECT DISTINCT FIRST_NAME, SALARY FROM EMPLOYEES;
SELECT DISTINCT DEPARTMENT_ID FROM EMPLOYEES;	
SELECT SALARY FROM EMPLOYEES WHERE JOB_ID
   IN('IT_PROG','FI_ACCOUNT','ST_CLERK','SA_REP','AC_ACCOUNT');	
SELECT * FROM EMPLOYEES;	
SELECT SALARY*NVL(COMMISSION_PCT,1) MONTHLY_SALARY, 12*SALARY*NVL(COMMISSION_PCT,1) YEARLY_SALARY FROM EMPLOYEES;	
SELECT SALARY*COMMISSION_PCT MONTHLY_SALARY, 12*COMMISSION_PCT*COMMISSION_PCT YEARLY_SALARY FROM EMPLOYEES;	
SELECT FIRST_NAME, SALARY,COMMISSION_PCT FROM EMPLOYEES WHERE COMMISSION_PCT IS  NULL;	
SELECT FIRST_NAME, SALARY,COMMISSION_PCT FROM EMPLOYEES WHERE COMMISSION_PCT IS NOT NULL;	XEP
SELECT FIRST_NAME,SALARY , COMMISSION_PCT FROM EMPLOYEES;	
 BEGIN
   FOR  I IN 1..20 LOOP
   IF(I=2) THEN
   DBMS_OUTPUT.PUT_LINE(I);
   END IF;
   END LOOP;
   END;	
  DECLARE
  I NUMBER ;
  BEGIN 
  FOR I IN 1..5 LOOP
  DBMS_OUTPUT.PUT_LINE(I);
  END LOOP;
  END;
  DECLARE
  N NUMBER ;
  BEGIN
  DBMS_OUTPUT.PUT_LINE(N);
  FOR I IN 1..10 LOOP
  N :=2*I;
  DBMS_OUTPUT.PUT_LINE(N);
  END LOOP;
  END;	
DECLARE
NUM1 NUMBER;
NUM2 NUMBER;
RES NUMBER;
BEGIN
NUM1 :=10;
NUM2 :=20;
RES :=NUM1+NUM2;
DBMS_OUTPUT.PUT_LINE('RESULT IS '||RES);
END;	XEPDB1	1677820799018	SQL	1	0.09
DECLARE 
MY_STRING VARCHAR2(100);
MY_NUMBER NUMBER;
MY_DATE DATE;
MY_EXP_NUMBER NUMBER :=0;
MY_RESULT NUMBER;
BEGIN
MY_STRING:= ' HELLO ORACLE WORLD';
DBMS_OUTPUT.PUT_LINE('MY STRING IS :-'||MY_STRING);
MY_NUMBER:=100;
DBMS_OUTPUT.PUT_LINE(MY_NUMBER);
MY_DATE:=SYSDATE;
DBMS_OUTPUT.PUT_LINE('MY DATE IS'||MY_DATE);
DBMS_OUTPUT.PUT_LINE('MY RESULT IS START:-');
MY_RESULT:=MY_NUMBER/MY_EXP_NUMBER;
DBMS_OUTPUT.PUT_LINE('MY RESULT IS'||MY_RESULT);
DBMS_OUTPUT.PUT_LINE('MY_RESULT IS END:-');
EXCEPTION
WHEN OTHERS

THEN
DBMS_OUTPUT.PUT_LINE('MY EXCEPTION');
END;	
DECLARE
my_string varchaR2(200);
BEGIN
my_string:='hEllo ORACLE world';
dbms_output.put_line(my_string);
end;	
select * from employees where SUBSTR(last_name, -1) = 'n';
SELECT employee_id, CONCAT(first_name, last_name) NAME,
job_id, LENGTH (last_name),
INSTR(last_name, 'a') "Contains 'a'?"
FROM employees
WHERE SUBSTR(job_id, 4) = 'REP';	
sELECT employee_id, last_name, department_id
FROM employees
WHERE LOWER(last_name) = 'higgins';	
SELECT employee_id, last_name, department_id
FROM employees
WHERE last_name = 'higgins';	
SELECT 'The job id for '||UPPER(last_name)||' is '
||LOWER(job_id) AS "EMPLOYEE DETAILS"
FROM employees;
SELECT employee_id, last_name, salary
FROM employees
WHERE employee_id = &employee_num;
select e.department_id,e.first_name, e1.first_name  "collegue name" from employees e , employees e1 where e.department_id=e1.department_id and e.employee_id!=e1.employee_id group by e.department_id,e.first_name,e1.first_name order by 1	;
select e.department_id,e.first_name, e1.first_name  "collegue name" from employees e , employees e1 where e.department_id=e1.department_id group by e.department_id,e.first_name,e1.first_name order by 1	;
select e.department_id,count(*),e.first_name||' '||last_name from employees e group by e.department_id,e.first_name||' '||last_name order by 1;
select e.department_id,count(*),e.first_name from employees e group by e.department_id,e.first_name;	
select e.department_id,count(*) from employees e group by e.department_id;	
select e.employee_id, e1.first_name from employees e, employees e1 where e.employee_id=e.employee_id group by e.employee_id, e1.first_name;	
select * from employees order by employee_id offset 5 rows  fetch next 10 rows  with ties;	
select * from employees fetch first 10 rows only;	
select * from employees order by employee_id offset 5 rows fetch next 10 rows  with ties;
select * from employees order by employee_id offset 5 rows fetch next 10 rows only;
select * from employees order by 3 offset 5 rows fetch next 10 rows only;	
select *from employees;	
select distinct job_id from employees;	
select first_name||' '||last_name  full_name , salary*12 as "annual salary" from employees;
select first_name||' '||last_name  "full name" from employees;	
select distinct manager_id from employees;	
select first_name,last_name,department_id, count(1) from employees group by department_id,first_name,last_name;	
select first_name,last_name,department_id from employees;	
select first_name,last_name,manager_id , count(manager_id) from employees group by manager_id,first_name,last_name;	
select to_char('243437805','l99g99g99g999') from dual;	
select e.manager_id,count(1) from employees e group by manager_id;
select count(e.employee_id) from employees e, employees e1 where e.employee_id=e1.manager_id;	
select g.grade,e.salary,g.min_salary,g.max_salary from employees e, grade g where salary between g.min_salary and g.max_salary;	
select * from jobs;
select  e.salary,g.min_salary,g.max_salary from employees e, grade g where salary between g.min_salary and g.max_salary;	
select j.job_id, e.salary from employees e, jobs j where salary between min_salary and max_salary;	
select e1.first_name||' '||e1.last_name, e.manager_id,e.hire_date ,e.first_name,e.hire_date
from employees e,employees e1 
where  e.employee_id=e1.manager_id  and e.hire_date<e1.hire_date;	
select e1.first_name||' '||e1.last_name, e.manager_id,e.hire_date ,e.first_name
from employees e,employees e1 
where  e.employee_id=e1.manager_id  order by e.first_name;	
select e1.first_name||' '||e1.last_name, e.manager_id,e.hire_date ,e.first_name
from employees e,employees e1 
where  e.employee_id=e1.manager_id
select e.first_name||' '||e.last_name, e.manager_id,e.hire_date 
from employees e,employees e1 
where  e.employee_id=e1.manager_id
select e.first_name||' '||e.last_name, e.manager_id,e.hire_date 
from employees e,employees e1 
where  e.employee_id(+)=e1.manager_id
SELECT
    e.first_name,
    e.manager_id,
    e.hire_date
FROM
    employees e,
    employees e1
WHERE
    e.employee_id (+) = e1.manager_id;

SELECT
    e.first_name,
    e.manager_id,
    e.hire_date
FROM
    employees e,
    employees e1
WHERE
    e.employee_id = e1.manager_id;

SELECT
    *
FROM
    all_objects
WHERE
    object_name LIKE upper('%grade%');

SELECT
    *
FROM
    all_objects
WHERE
    object_name LIKE upper('job%');

SELECT
    *
FROM
    all_objects
WHERE
    object_name LIKE upper('job_g%');

SELECT
    *
FROM
    all_objects
WHERE
    object_name LIKE upper('job_grad%
');

SELECT
    *
FROM
    all_objects
WHERE
    object_name LIKE upper('job_grades');

SELECT
    ee.first_name,
    ee.last_name,
    e.manager_id,
    ee.first_name
    || ' '
       || e.last_name manager_name
FROM
    employees e,
    employees ee
WHERE
    ee.employee_id (+) = e.manager_id;

SELECT
    e.first_name,
    e.last_name,
    e.manager_id,
    e.first_name
    || ' '
       || e.last_name manager_name
FROM
    employees e,
    employees ee
WHERE
    e.manager_id = e.employee_id;

SELECT
    e.first_name,
    ee.salary,
    e.manager_id
FROM
    employees e,
    employees ee
WHERE
    e.manager_id = ee.employee_id (+);

SELECT
    e.first_name
FROM
    employees e,
    employees ee
WHERE
    e.manager_id = ee.employee_id;

SELECT
    *
FROM
    employees e,
    employees e1
WHERE
    e.manager_id = e1.employee_id (+);

SELECT
    *
FROM
    employees e,
    employees e1
WHERE
    e.manager_id = e1.manager_id;

SELECT
    emp.first_name,
    emp.salary,
    j.job_id,
    j.department_id,
    j.start_date,
    j.end_date
FROM
    employees   emp,
    job_history j
WHERE
    emp.employee_id = j.employee_id (+)
ORDER BY
    emp.employee_id;

SELECT
    emp.first_name,
    emp.salary,
    j.job_id,
    j.department_id,
    j.start_date,
    j.end_date
FROM
    employees   emp,
    job_history j
WHERE
    emp.employee_id (+) = j.employee_id;

SELECT
    emp.first_name,
    emp.salary,
    j.job_id,
    j.department_id
FROM
    employees   emp,
    job_history j
WHERE
    emp.job_id (+) = j.job_id;

SELECT
    *
FROM
    jobs;

SELECT
    *
FROM
    departments;

SELECT
    *
FROM
    employees
WHERE
    job_id IS NULL;

SELECT
    emp.first_name || ' '
                      || last_name,
    emp.department_id,
    dpt.department_name,
    emp.salary,
    emp.job_id
FROM
    employees   emp,
    departments dpt
WHERE
    emp.department_id = dpt.department_id (+)
ORDER BY
    employee_id;

SELECT
    *
FROM
    all_objects;
    
    