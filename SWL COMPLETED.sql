SELECT
    &&job_id
    &&job_idCOUNT
    count&&JOB_ID)
FROM
    employees
GROUP BY
    &&job_id;
 
 SELECT CASE 
 DISTINCT(&COL_NAME) 
 THEN 'UNIQUE'
 ELSE 
 'NOT UNIQUE'
 END
 FROM EMPLOYEES;
 
 SELECT COUNT (*) FROM EMPLOYEES;
 
 SELECT COUNT(DEPARTMENT_ID)FROM EMPLOYEES
 
 SELECT COUNT(DISTINCT DEPARTMENT_ID)FROM EMPLOYEES;
 
 SELECT CASE WHEN COUNT(*) = COUNT( DISTINCT 
 
select case when count(distinct(&&column))=count(&&column) then 'Unique' else 'Not Unique' end "Unique Column or Not" from EMPLOYEES; 


SELECT FIRST_NAME ,COUNT(*) FROM EMPLOYEES GROUP BY EMPLOYEE_ID HAVING COUNT(*)>1;

SELECT EMPLOYEE_ID,COUNT(*) FROM EMPLOYEES GROUP BY EMPLOYEE_ID HAVING COUNT(*)>1;


select decode(count(distinct &col1_name),count(*),'unique','non-unique') from &tablename;

SELECT LAST_NAME||'EARnS' ||SALARY ||' MONTHLY BUT WBANTS'|| SALARY*3 "DREAM SALARIES" FROM EMPLOYEES;

SELECT LAST_NAME,HIRE_DATE,TO_CHAR(ADD_MONTHS(HIRE_DATE,6)) SALARY_REVIEW FROM EMPLOYEES;

SELECT LAST_NAME , NVL(TO_CHAR(COMMISSION_PCT), 'NO COMMISSION') COMM FROM EMPLOYEES;

SELECT FIRST_NAME ,COUNT(*) FROM EMPLOYEES GROUP BY FIRST_NAME HAVING COUNT(*)>1;

SELECT EMPLOYEE_ID,COUNT(*) FROM EMPLOYEES GROUP BY EMPLOYEE_ID HAVING COUNT(*)>1;

SELECT FLOOR(7.8),FLOOR(7.1),FLOOR(7) FROM DUAL;

SELECT TRUNC(7.8) FROM DUAL;

SELECT CEIL(8.8) FROM DUAL;
SELECT CEIL(8.1) FROM DUAL;

select listagg(first_name,' , ') within group (order by first_name) 
from employees;

SELECT LISTAGG('FIRST_NAME',' , ') WITHIN GROUP(ORDER BY FIRST_NAME) FROM EMPLOYEES;

SELECT FIRST_NAME FROM EMPLOYEES ORDER BY FIRST_NAME;

SELECT LISTAGG(FIRST_NAME,' , ') WITHIN GROUP(ORDER BY FIRST_NAME) FROM EMPLOYEES;

SELECT DEPARTMENT_id,LISTAGG(FIRST_NAME,' , ') WITHIN GROUP(ORDER BY FIRST_NAME) FROM EMPLOYEES group by department_id;

select department_id, sum(salary),listagg(first_name||'-'||last_name,'|') within group(order by first_name) from employees group by department_id;


select department_id,job_id,
sum(salary),count(*)
,listagg(first_name||'-'||last_name,'|') within group(order by first_name) from employees group by department_id ,job_id;

select nlsparameter from dual;

select v$nls_parameters from employees;

select to_char(sysdate,'mm-dd-rrrr') from dual;

select to_char(sydaate,add_months(sysdate,3))from dual;

select to_char(sysdate,'day') like monday from dual;

select 999/10 from dual;

select to_char(999)/10 from dual;

select to_char('999')/10 from dual;

select to_char(sysdate,'ddth') from dual;
select to_char(sysdate,'ddspth') from dual;
SELECT last_name,
TO_CHAR(hire_date, 'fmDD Month YYYY')
AS HIREDATE
FROM employees;

SELECT COUNT (DISTINCT MANAGER_ID) "NUMBER OF MANAGER" FROM EMPLOYEES;

SELECT MANAGER_ID, MIN(SALARY)FROM EMKPLOYEES WHERE MANAGER_ID IS NOT NULL  GROUP BY MANAGER_ID;
SELECT EXTRACT( DAY FROM SYSDATE) FROM DUAL;
SELECT  COUNT(1) "TOTAL",SUM(DECODE(TO_CHAR(HIRE_DATE,'RRRR'),2005,1,0)) "2005",
SUM(DECODE(TO_CHAR(HIRE_DATE,'RRRR'),2006,1,0)) "2006",
SUM(DECODE(TO_CHAR(HIRE_DATE,'RRRR'),2007,1,0)) "2007"
from employees;

select SUM(DECODE(TO_CHAR(HIRE_DATE,'RRRR'),2005,1,0)) "2005" from employees;

SELECT EXTRACT(DATE FORM DUAL) FROM EMPLOYEES 

SELECT EXTRACT(MONTH FROM "2017-06-15") FROM DUAL;

SELECT JOB_ID "JOB",SUM(DECODE(DEPARTMENT_ID,20,SALARY)) "DEPT_20",
SUM(DECODE(DEPARTMENT_id,50,salary)) "dept_50",
sum(decode(department_id,80,salary)) "dept_80",
sum(decode(department_id,90,salary)) "dept_90" from employees;

select job_id "job" ,sum(case when department_id=20 then salary else 'null')
,sum(when department_id = 50 then salary else 'null'),sum(when department_id =80
then salary else 'null'), sum(case when department_id=90 then salary else 'null') from employees;

select job_id, sum(case when department_id='20' then salary else (null) end) "dept 20",
sum(case when department_id='50' then salary else (null) end) "dept 50" ,
sum(case when department_id='80' then salary else (null) end) "dept 80" ,
sum(case when department_id='90' then salary else (null) end) "dept 90",sum(salary) from employees group by job_id;

select job_id "job" ,department_id,case when department_id in (20,80,50,90)
then
salary
end
from employees;

SELECT JOB_ID, SALARY "TOTAL",DEPARTMENT_ID FROM EMPLOYEES WHERE DEPARTMENT_ID IN(20,50,80,90) ;

select * from all_objectS where object_name like 'DEPT%' ;

select * from all_objectS where object_name like 'DEPT%' AND OBJECT_TYPE ='TABLE';

select * from all_objects where lower(object_name) ='departments';

SELECT * FROM EMPLOYEES;
SELECT * FROM department;
select * from all_objects where object_name like lower('u%');

SELECT * from user_cons_columns where table_name='department';

select * from user_cons_columns where lower(table_name)='departments';

select * from user_cons_columns where lower(table_name)='employees';

select employee_id , salary, first_name||' '||last_name from  employees ;

select EMP.employee_id ,EMP.salary, first_name||' '||last_name,DEPARTMENT_ID from  employees emp,departmentS dept
where emp.DEPARTMENT_ID=dept.DEPARTMENT_ID;--AMBIGIOUS

select EMP.employee_id ,EMP.salary, first_name||' '||last_name, DEPT.DEPARTMENT_ID from  employees emp,departmentS dept
where emp.DEPARTMENT_ID=DEPARTMENT_ID;--AMBIGIOUS

select EMP.employee_id ,EMP.salary, first_name||' '||last_name, DEPT.DEPARTMENT_ID from  employees emp,departmentS dept;

select EMP.employee_id ,EMP.salary, first_name||' '||last_name, DEPT.DEPARTMENT_ID from  employees emp,departmentS dept ORDER BY EMPLOYEE_ID;

select EMP.employee_id ,EMP.salary, first_name||' '||last_name, DEPT.DEPARTMENT_ID from  employees emp,departmentS dept,JOBS JB
where emp.DEPARTMENT_ID=DEPT.DEPARTMENT_ID ORDER BY EMPLOYEE_ID;

SELECT * FROM JOBS;

SELECT * FROM EMPLOYEES;

SELECT 107*27 FROM DUAL;

SELECT EMPLOYEE_ID, SALARY,FIRST_NAME||' '||LAST_NAME,JB.JOB_TITLE,JB.JOB_ID FROM EMPLOYEES EMP, DEPARTMENTS DP, JOBS JB
WHERE EMP.DEPARTMENT_ID=DP.DEPARTMENT_ID AND JB.JOB_ID=EMP.JOB_ID;

SELECT EMPLOYEE_ID, SALARY,FIRST_NAME||' '||LAST_NAME,JB.JOB_TITLE,JB.JOB_ID FROM EMPLOYEES EMP, DEPARTMENTS DP, JOBS JB
WHERE EMP.DEPARTMENT_ID=DP.DEPARTMENT_ID AND JB.JOB_ID=EMP.JOB_ID AND EMP.DEPARTMENT_ID IN (10,20); 

CREATE TABLE EMPP(
EMPLOYEE_ID NUMBER UNIQUE,
DEPARTMENT_ID VARCHAR(20),
NAME VARCHAR(20),
SALARY VARCHAR(20)
);

CREATE TABLE EMP1(

DEPARTMENT_ID VARCHAR(20),
NAME VARCHAR(20)

INSERT INTO EMPP VALUES(1,10,'A',2000);
INSERT INTO EMPP VALUES(2,20,'B',4000);
INSERT INTO EMPP VALUES(3,30,'C',5000);
INSERT INTO EMPP VALUES(4,40,'D',29000);
COMMIT
INSERT INTO EMP1 VALUES ( 10,'A');

INSERT INTO EMP1 VALUES ( 20,'B');

INSERT INTO EMP1 VALUES ( 30,'C');

INSERT INTO EMP1 VALUES ( 40,'D');

COMMIT;

INSERT INTO EMP1 VALUES ( 10,'Z');

COMMIT;
SELECT * FROM EMPP E,EMP1 E1 WHERE E.DEPARTMENT_ID=E1.DEPARTMENT_ID;

SELECT * FROM EMPP E,EMP1 E1 WHERE E.DEPARTMENT_ID=E1.DEPARTMENT_ID ORDER BY EMPLOYEE_ID;

COMMIT;

SELECT * FROM LOCATIONS;

SELECT FIRST_NAME,LAST_NAME,SALARY,J.JOB_ID,JOB_TITLE FROM EMPLOYEES E,JOBS J WHERE E.JOB_ID=J.JOB_ID

SELECT FIRST_NAME,LAST_NAME,SALARY,JOB FROM EMPLOYEES;

--SELECT *FROM EMPLOYEES;
SELECT *FROM JOBS;
SELECT *FROM DEPARTMENTS;
--SELECT * FROM JOBS;
SELECT * FROM LOCATIONS;
SELECT * FROM REGIONS;

SELECT * FROM ALL_OBJECTS WHERE OWNER ='HR'; 

SELECT * FROM ALL_OBJECTS;

SELECT * FROM USER_CONS_COLUMNS;

SELECT FIRST_NAME ,JOB_ID,D.DEPARTMENT_ID,L.LOCATION_ID,C.COUNTRY_ID,R.REGION_ID,D.MANAGER_ID,L.CITY,C.COUNTRY_NAME,R.REGION_NAME FROM EMPLOYEES E,DEPARTMENTS D,LOCATIONS L,COUNTRIES C,REGIONS R WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID AND 
D.LOCATION_ID=L.LOCATION_ID AND L.COUNTRY_ID=C.COUNTRY_ID AND C.REGION_ID=R.REGION_ID

SELECT FIRST_NAME||' '||LAST_NAME,HIRE_DATE,ROWNUM,ROWID,LENGTH(FIRST_NAME||' '||LAST_NAME) FROM EMPLOYEES WHERE FIRST_NAME LIKE 'A%' ORDER BY LAST_NAME;
 
SELECT FIRST_NAME ,E.JOB_ID,D.DEPARTMENT_ID,HIRE_DATE,D.MANAGER_ID,L.LOCATION_ID L,C.COUNTRY_ID,R.REGION_ID,J.JOB_TITLE,D.MANAGER_ID,L.CITY,C.COUNTRY_NAME,R.REGION_NAME FROM EMPLOYEES E,DEPARTMENTS D,LOCATIONS L,COUNTRIES C,JOBS J,REGIONS R WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID AND 
D.LOCATION_ID=L.LOCATION_ID AND L.COUNTRY_ID=C.COUNTRY_ID AND C.REGION_ID=R.REGION_ID AND J.JOB_ID=E.JOB_ID

SELECT DISTINCT(JOB_ID) FROM JOBS;

 SELECT * FROM JOB_HISTORY;
 
 select* from employees;
 select count(department_id) from employees group by department_id;
 
 select job_id,count(department_id),count(employee_id) from employees group by department_id,job_id;
 
 select count(department_id) from employees  group by department_id;
 
 select count(department_id),department_name from departments group by department_id;
 
 --select * from employees emp, department dpt where emp.department_id= dept.department_id;
 
 select job_id,department_id,count(department_id),count(job_id) from employees  group by job_id,department_id;
 
 select emp.department_id,emp.job_id,jb.job_title,count(department_id) from  employees emp, jobs jb where emp.job_id=jb.job_id group by emp.department_id;
 
 


select emp.department_id,d.department_name,count(*) from employees emp,departments d where emp.department_id=d.department_id group by emp.department_id,d.department_name;

select dp.department_name,count(*) from employees emp,departments dp where emp.department_id=dp.department_id group by dp.department_name;


select * from employees,jobs;

select * from employees emp,departments dept where emp.department_id=dept.department_id; 

select emp.* from employees emp,departments dept where emp.department_id=dept.department_id;
 

select emp.department_id,emp.job_id,js.job_title,COUNT(DEPARTMENT_ID) from employees emp,jobs js where emp.job_id=js.job_id GROUP BY DEPARTMENT_ID;


SELECT DEPT.DEPARTMENT_ID,DEPT.DEPARTMENT_NAME,EMP.JOB_ID,J.JOB_TITLE,COUNT(EMP.JOB_ID) "NO. OF JOBS"
FROM EMPLOYEES EMP,DEPARTMENTS DEPT,JOBS J
WHERE EMP.DEPARTMENT_ID=DEPT.DEPARTMENT_ID AND EMP.JOB_ID=J.JOB_ID
GROUP BY DEPT.DEPARTMENT_ID,DEPT.DEPARTMENT_NAME,EMP.JOB_IDselect emp.department_id,emp.job_id,count(*) from employees emp group by emp.department_id,emp.job_id order by emp.department_id,emp.job_id; 
,J.JOB_TITLE
ORDER BY EMP.DEPARTMENT_ID;

SELECT DEPT.DEPARTMENT_ID,DEPT.DEPARTMENT_NAME,EMP.JOB_ID,J.JOB_TITLE,COUNT(EMP.JOB_ID) "NO. OF JOBS"
FROM EMPLOYEES EMP,DEPARTMENTS DEPT,JOBS J
WHERE EMP.DEPARTMENT_ID=DEPT.DEPARTMENT_ID AND EMP.JOB_ID=J.JOB_ID
GROUP BY DEPT.DEPARTMENT_ID,DEPT.DEPARTMENT_NAME,EMP.JOB_ID,J.JOB_TITLE
ORDER BY DEPT.DEPARTMENT_ID;

-- select job_id,hire_date,department_id,count(department_id),count(to_char(hire_date,'rrrr')) from employees  group by department_id;
 
 
 select emp.department_id,j.job_id,j.job_title,COUNT(EMP.DEPARTMENT_ID),count(to_char(hire_date,'rrrr'))
 from employees emp,jobs j where emp.job_ID=J.JOB_ID
 group by EMP.DEPARTMENT_ID,emp.hire_date 
 order by emp.hire_date; 



SELECT EMP.DEPARTMENT_ID,J.JOB_ID,J.JOB_TITLE,COUNT(J.JOB_ID) FROM EMPLOYEES EMP,JOBS J WHERE EMP.JOB_ID=J.JOB_ID GROUP BY(JOB_ID);

SELECT DEPT.DEPARTMENT_ID,EMP.JOB_ID,J.JOB_TITLE,COUNT(EMP.JOB_ID)
FROM EMPLOYEES EMP,DEPARTMENTS DEPT,JOBS J
WHERE EMP.DEPARTMENT_ID=DEPT.DEPARTMENT_ID AND EMP.JOB_ID=J.JOB_ID
GROUP BY DEPT.DEPARTMENT_ID,EMP.JOB_ID,J.JOB_TITLE
ORDER BY EMP.DEPARTMENT_ID;


select job_id,department_id,count(job_id) from employees  group by job_id,department_idSELECT * FROM table 
 
 select department_id , location_id from departments;
 
sELECT DEPT.DEPARTMENT_ID,EMP.JOB_ID,J.JOB_TITLE,COUNT(to_char(hire_date,'rrrr'))
FROM EMPLOYEES EMP,DEPARTMENTS DEPT,JOBS J
WHERE EMP.DEPARTMENT_ID=DEPT.DEPARTMENT_ID AND EMP.JOB_ID=J.JOB_ID and emp.hire_date=j.
GROUP BY DEPT.DEPARTMENT_ID,EMP.hire_date,J.JOB_TITLE
ORDER BY EMP.DEPARTMENT_ID;

SELECT last_name, hire_date, salary
FROM employees;

select 

select * from all_objects where object_name like upper('d%') and object_type =upper('table');

select * from user_cons_columns;

SELECT * FROM USER_CONS_COLUMNS where object_type=upper('table') and object_name like upper'd%';

select * from user_cons_columns;

select * from departments;
select * from employees;
select *from jobs;
select * from locations;

--use of join
select first_name||'  '||last_name , salary,emp.department_id ,dpt.department_name from employees emp,departments dpt where emp.department_id=dpt.department_id;

select first_name||' '||last_name ,emp.department_id,dpt.department_name,jb.job_id,jb.job_title from employees emp,jobs jb,departments dpt where emp.department_id=dpt.department_id and jb.job_id=emp.job_id;

SELECT FIRST_NAME ,E.JOB_ID,D.DEPARTMENT_ID,HIRE_DATE,D.MANAGER_ID,L.LOCATION_ID L,C.COUNTRY_ID,R.REGION_ID,J.JOB_TITLE,D.MANAGER_ID,L.CITY,C.COUNTRY_NAME,R.REGION_NAME FROM EMPLOYEES E,DEPARTMENTS D,LOCATIONS L,COUNTRIES C,JOBS J,REGIONS R WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID AND 
D.LOCATION_ID=L.LOCATION_ID AND L.COUNTRY_ID=C.COUNTRY_ID AND C.REGION_ID=R.REGION_ID AND J.JOB_ID=E.JOB_ID;

select dpt.department_name , count(emp.department_id) from departments dpt, employees emp where dpt.department_id=emp.department_id  group by department_name;

select dpt.department_name,emp.department_id,jb.job_id,count(JB.job_id) from jobs jb,employees emp, departments dpt  where emp.department_id=dpt.department_id AND EMP.JOB_ID=JB.JOB_ID group by dpt.department_name,emp.department_id,JB.JOB_ID ORDER BY EMP.DEPARTMENT_ID;

SELECT COUNT(1),DEPARTMENT_ID , JOB_ID, TO_CHAR(HIRE_DATE,'RRRR') FROM EMPLOYEES GROUP BY DEPARTMENT_ID,JOB_ID, TO_CHAR(HIRE_DATE,'RRRR') ORDER BY DEPARTMENT_ID,TO_CHAR(HIRE_DATE,'RRRR';

SELECT DEPARTMENT_ID , COUNT(1) FROM EMPLOYEES GROUP BY DEPARTMENT_ID ;

SELECT DPT.DEPARTMENT_NAME ,DPT.DEPARTMENT_ID,CCOUNT(TO_CHAR(EMP.HIRE_DATE,'RRRR')),JB.JOB_ID,COUNT(JOB_ID),JB.JOB_TITLE FROM EMPLOYEES EMP, DEPARTMENTS DPT ,JOBS JB WHERE EMP.DEPARTMENT_ID=DPT.DEPARTMENT_ID GROUP BY DPT.DEPARTMENT_NAME , DPT.DEPARTMENT_ID,JB.JOB_TITLE ORDER BY DPT.DEPARTMENT_ID;

SELECT INSTR('AMITABH','A',1,1) FROM
dual;

SELECT
    employee_id,
    to_char(hire_date, 'MONTH') month_hired
FROM
    employees
WHERE
    last_name = 'Higgins';

SELECT
    to_char(sysdate, 'HH24:MI:SS PM')
FROM
    dual;

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
    emp.department_id = dpt.department_id
ORDER BY
    employee_id;

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
    emp.department_id (+) = dpt.department_id
ORDER BY
    employee_id;
--FOR ERROR:---

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
    emp.department_id (+) = dpt.department_id (+)
ORDER BY
    employee_id;

SELECT
    *
FROM
    employees
WHERE
    job_id IS NULL;

SELECT
    *
FROM
    departments;

SELECT
    *
FROM
    departments
WHERE
    location_id IS NULL;

SELECT
    *
FROM
    regions;

SELECT
    *
FROM
    jobs;

SELECT
    *
FROM
    job_history;

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
    emp.employee_id (+) = j.employee_id
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
    emp.employee_id = j.employee_id (+)
ORDER BY
    emp.employee_id;

SELECT
    emp.first_name,
    emp.salary,
    j.job_id,
    j.department_id
FROM
    employees   emp,
    job_history j
WHERE
    emp.employee_id = j.employee_id (+);

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
    emp.department_id != dpt.department_id
ORDER BY
    employee_id;

SELECT
    *
FROM
    employees e,
    employees e1
WHERE
    e.manager_id = e1.employee_id;

SELECT
    *
FROM
    employees e,
    employees e1
WHERE
    e.manager_id (+) = e1.employee_id;

SELECT
    *
FROM
    employees e,
    employees e1
WHERE
    e.manager_id = e1.employee_id (+);

SELECT
    ee.first_name,
    ee.last_name,
    e.manager_id,
    ee.first_name
    || ' '
       || ee.last_name manager_name
FROM
    employees e,
    employees ee
WHERE
    ee.employee_id (+) = e.manager_id;

SELECT
    *
FROM
    all_objects
WHERE
    object_name LIKE upper('j%');



SELECT
    *
FROM
    jobs;

SELECT
    e1.first_name
    || ' '
       || e1.last_name,
    e.manager_id,
    e.hire_date,
    e.first_name,
    e1.hire_date
FROM
    employees e,
    employees e1
WHERE
        e.employee_id = e1.manager_id
    AND e.hire_date < e1.hire_date;
    
    
    select * from employees;
    select * from jobs;
    
    select j.job_id, e.salary,j.min_salary,j.max_salary from employees e, jobs j where salary between j.min_salary and j.max_salary;
    
    
    create table grade
    (
    grade varchar(10),
    min_salary number
    ,
    max_salary number
    );
    insert into grade values('a',1000,6000);
    
    insert into grade values('b',6001,12000);
    
    insert into grade values('c',12001,18000);
    
    insert into grade values('d',18001,24000);
    
select g.grade,e.salary,g.min_salary,g.max_salary from employees e, grade g where salary between g.min_salary and g.max_salary;
    
select * from jobs;


select emp.employee_id,emp.first_name||' '||emp.last_name FULL_NAME,emp.salary,job.job_title from employees emp
      ,jobs job where 1=1 and emp.job_id=job.job_id and emp.salary between job.min_salary and job.max_salary
order by 1;
SELECT
    to_char('243437805', 'l99g99g99g999')
FROM
    dual;

SELECT
    e.manager_id,
    COUNT(1)
FROM
    employees e
GROUP BY
    manager_id;

SELECT
    e.manager_id,
    COUNT(*),
    ee.first_name
    || ' '
       || ee.last_name manager_name
FROM
    employees e,
    employees ee
WHERE
    ee.employee_id (+) = e.manager_id
GROUP BY
    e.manager_id,
    ee.first_name
    || ' '
       || ee.last_name;

SELECT
    first_name || ' '
                  || last_name,
    to_char(hire_date, 'day')
FROM
    employees; 
    
    select department_id, count(1) from employees group by department_id;
    
    select first_name ,department_id , count(1) from employees group by department_id, first_name;
    
    select distinct manager_id from employees;
 
 select first_name||' '||last_name  full_name , salary*12 as "annual salary" from employees;
 
 select distinct job_id from employees;
 
 select *from employees ;
 select employee_id , first_name from employees order by employee_id offset 10 rows fetch next 5 rows only;
 select * from employees order by employee_id offset 5 rows fetch next 10 rows only;
 
 select * from employees fetch first 10 rows only;
select * from employees  offset 5 rows fetch next 10 rows only;
 
select * from employees order by employee_id offset 5 rows  fetch next 10 rows  with ties;

SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE employee_id = &employee_num ;

select e.department_id,count(*) from employees e group by e.department_id;


select e.department_id,count(*),e.first_name||' '||last_name from employees e group by e.department_id,e.first_name||' '||last_name order by 1;


--self join question
-self join question

select e.department_id,e.first_name, e1.first_name  "collegue name" from employees e , employees e1 where e.department_id=e1.department_id and e.employee_id!=e1.employee_id group by e.department_id,e.first_name,e1.first_name order by 1


ACCEPT col_name PROMPT 'Please specify the column name:‘
SELECT
    &&col_name
FROM
    employees
ORDER BY
    &col_name;

DEFINE employee_num = 200

SELECT
    employee_id,
    last_name,
    salary,
    department_id
FROM
    employees
WHERE
    employee_id = &employee_num;

UNDEFINE employee_num;

SET VERIFY ON

SELECT
    employee_id,
    last_name,
    salary
FROM
    employees
WHERE
    employee_id = &employee_num;

SELECT
    'The job id for '
    || upper(last_name)
       || ' is '
          || lower(job_id) AS "EMPLOYEE DETAILS"
FROM
    employees;

SELECT
    employee_id,
    last_name,
    department_id
FROM
    employees
WHERE
    last_name = 'higgins';

SELECT
    employee_id,
    last_name,
    department_id
FROM
    employees
WHERE
    lower(last_name) = 'higgins';

SELECT
    employee_id,
    upper(last_name),
    department_id
FROM
    employees
WHERE
    initcap(last_name) = 'Higgins';

SELECT
    employee_id,
    concat(first_name, last_name) name,
    job_id,
    length(last_name),
    instr(last_name, 'a')         "Contains 'a'?"
FROM
    employees
WHERE
    substr(job_id, 4) = 'REP';

SELECT
    *
FROM
    employees
WHERE
    substr(last_name, - 1, 1) = 'n';

SELECT
    *
FROM
    employees
WHERE
    substr(last_name, - 1) = 'n';

SELECT
    last_name,
    hire_date
FROM
    employees
WHERE
    hire_date < '01-FEB-08';
    
    
    
    --sub queries
    
    select  e.first_name, (select e1.department_name from departments e1 where e1.department_id=e.department_id) department_nameof_person
       from employees e; 
select max(salary) from employees;

select * from employees where salary=24000;


select emp.* from employees emp where emp.salary=(select max(e.salary) from employees e);

select emp.* from employees emp where emp.salary=(select min(e.salary) from employees e);

select emp.* from employees emp where emp.salary=(select avg(e.salary) from employees e);

select hire_date from employees;

select (avg(to_char(hire_date,'rrrr'))) from employees;

select emp.* from employees emp where to_char(emp.hire_date,'rrrr')=(select avg(to_char(e.hire_date,'rrrr')) from employees e);

select e.*,(select ee.salary from employees ee ) 
from employees e ;

select to_char(1890.55,'$0g000d00') from dual;

select to_char(1890.55,'$9,999v99') from dual;

select to_char(1890.55,'$99,999d99') from dual;

select to_char(1890.55,'$99g999d99') from dual;

select * from departments;

select * from locations;
select d.department_id from departments d where d.department_name='Payroll';

 select l.* from locations l where l.city='Roma';
 
 select d.department_id from departments d where d.location_id=1700;
 
select department_id,sum(salary) from employees e group by department_id having sum(salary) > (select max(salary) from employees);
select max(salary) from employees;

select * from employees e  where e.department_id in (select  d.department_id from departments d where d.location_id)= (select l.location_id from location l where l.location_id ='Roma');

select  department_id, sum(salary)from employees group by department_id having sum(salary)>max(salary);

select department_id, count(*) from employees group by department_id;

select * from employees where department_id=50;

select department_id from employees group by department_id having count(employee_id);
select * from employees where department_id=(select department_id from employees group by department_id having count(employee_id)=(select max(count(*) from employees group by department_id));
select e.* from employees e  where e.department_id = (select  d.department_id from departments d where d.location_id= (select l.location_id from locations l where upper(l.location_id) =1800));
  
 select * from employees where salary>(select salary from employees where last_name='Abel');
 
 select * from employees;
 select * from departments;

select * from locations;
select * from regions;
select * from countries;

SELECT  C.COUNTRY_NAME,MAX(E.SALARY) FROM EMPLOYEES E ,
DEPARTMENTS D, LOCATIONS L, COUNTRIES C WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID 
AND D.LOCATION_ID=L.LOCATION_ID AND L.COUNTRY_ID = C.COUNTRY_ID GROUP BY C.COUNTRY_NAME;


 
 
 select employee_id , first_name from employees e where exists (select department_id  from  departments ee where e.department_id=ee.department_id);
 
 select * from  locations where lower(city) = 'toronto' ;
 select * from locations;
 select * from departments;
 select department_id from locations where location_id in select location_id in (select location_id from departmetns where department_id in select departments_id from employees));
 
 
 select a.full_name,a.final_salary  from  (select e.first_name||' '||e.last_name Full_name, e.salary+ (e.salary*0.1) final_salary from employees e) a ;
 
 
 select e.*,d.department_name ,max.max_sal
 from employees e , departments d,(select ee.department_id ,max(ee.salary)  max_sal from employees ee group by ee.department_id) maxx 
 where e.department_id=maxx.department_id and d.department_id=e.department_id;
 
 
 select emp.*,case when department_id =10 then(select department_name from departments d where emp.department_id=d.deaprtment_id)
 when department_id =20 then(select city from locations l ,departments d where l.location_id=d.location_id)
else (select country_name from departments d,locations l,countries c where c.country_id=l.country_id and l.location_id= c.location_id and d.department_id=e.department_id and d.department_id=e.deaprtment_id)
                 newdata from employees e;

select emp.*, (case when emp.department_id =10 then (select department_name from departments dpt where emp.department_id = dpt.department_id)
                 when emp.department_id =20 then (select city from locations l,departments dpt where l.location_id = dpt.location_id)
                 else (select country_name from departments dpt, locations l ,countries c where c.country_id = l.country_id and l.location_id = dpt.location_id and dpt.department_id = emp.department_id)
                 end) "New Data" from employees emp;


    select * from employees where department_id in (select department_id from employees group by  department_id  having count(employee_id) in (select max(count(*)) from employees group by department_id));
    
    select * from jobs j where 1=1 and exists (select job_id from employees e where e.job_id= j.job_id);
    select * from employees e where 1=1 and exists (select job_id from jobs j where e.job_id= j.job_id);
    
    select e.department_id ,e.first_name from employees e where e.department_id in (select d.department_id from departments d where d.department_id=e.department_id);
    
    
    --assigned department
    select d.department_name from departments d where exists (select 1 from employees e where e.department_id=d.department_id);
    
    select first_name from employees where employee_id in (select employee_id from job_history);
    
    select e.first_name from employees e where  exists (select employee_id from job_history j where e.employee_id=j.employee_id);
    
    select job_id ,job_title from jobs j where exists (select job_id from employees e where e.job_id=j.job_id);
    
     
    select e.salary , e.first_name,e.department_id,e.job_id,(select d.department_name from departments d where d.department_id=e.department_id) from employees e;
    
    select d.department_id ,d.department_name,(select listagg(e.first_name,' | ')  from employees e where d.department_id=e.department_id ) employee_names from departments d;
    
        select e.first_name,e.employee_id,e.department_id,e.salary,(select listagg(d.department_name) from  departments d where e.department_id=d.department_id) from employees e);
    
    select e.first_name,e.employee_id,e.department_id,e.salary,(select listagg(d.department_name) from  department d where e.department_id=(select max(salary) from meployees where e.department_id = d.department_id)) from employees e);
    
    
    --country wise max(sal)
    
    select * from employees;
    select * from departments;
    select * from locations;
    select * from countries
    
    
    select  c.country_id,max(e.salary) from employees e ,departments d,locations l,countries c where e.department_id=d.department_id and d.location_id=l.location_id and l.country_id=c.country_id group by c.country_id;
    
    