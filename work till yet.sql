SELECT
    *
FROM
    employees
WHERE
        department_id = 30
    AND job_id = upper('pu_clerk')
ORDER BY
    salary,
    job_id;

SELECT
    *
FROM
    employees
WHERE
        department_id = 30
    AND job_id = upper('pu_clerk');

SELECT
    *
FROM
    employees
WHERE
        department_id = 30
    AND job_id = 'pu_clerk';

SELECT
    SUM(salary),
    AVG(salary)
FROM
    employees
GROUP BY
    department_id;

SELECT
    department_id,
    SUM(salary),
    AVG(salary)
FROM
    employees
GROUP BY
    department_id;

SELECT
    to_char(hire_date, 'rrrr')
FROM
    employees;

SELECT
    COUNT(hire_date)
FROM
    employees;

SELECT
    AVG(salary)
FROM
    employees;	
select trunc(avg(salary)) from employees	
select count( distinct department_id) from employees;	
select count(1) from employees;	
select count(employee_id) from employees where department_id=90;	
select count(manager_id) from employees;	
select count(employee_id) from employees;	
select count(*) from employees;	XEPDB1	1676958790967	SQL	1	0.012
select min(salary) from employees;	XEPDB1	1676958280023	SQL	1	0.005
select max(salary) from employees;	XEPDB1	1676958203794	SQL	1	0.006
select sum(salary) from employees where department_id=90;	XEPDB1	1676958125137	SQL	1	0.082
select sum(salary) from employees;	
select * from employees;	
SELECT RPAD(LAST_NAME,8,' ') , LPAD(' ',(SALARY/1000)+1,'*') FROM EMPLOYEES   ORDER BY SALARY  DESC;
SELECT RPAD(LAST_NAME,8,' ') , LPAD(' ',(SALARY/1000)+1,'*') FROM EMPLOYEES   ORDER BY SALARY  ASC;	
SELECT RPAD(LAST_NAME,8,' ') , RPAD(' ',(SALARY/1000)+1,'*') FROM EMPLOYEES   ORDER BY SALARY;	
SELECT RPAD(LAST_NAME,8,' ') , LPAD(' ',(SALARY/1000)+1,'*') FROM EMPLOYEES   ORDER BY SALARY;	
SELECT RPAD(LAST_NAME,8,' ') , REPLACE(SALARY,'*') FROM EMPLOYEES   ORDER BY SALARY;	
SELECT LAST_NAME , REPLACE(SALARY,'*') FROM EMPLOYEES WHERE LENGTH(LAST_NAME)=8  ORDER BY SALARY;	
select last_name , lpad(salary,'15','$') as "SALARY" from employees;	XEPDB1	1676887603517	SQL	1	0.01
select last_name ,round(months_between(sysdate,hire_date)) months_worked from employees order by months_between(sysdate,hire_date);	XEPDB1	1676887426396	SQL	1	0.018
select last_name ,round(months_between(sysdate,hire_date)) months_worked from employees order by hire_date;	XEPDB1	1676887355195	SQL	1	0.016
select last_name ,round(months_between(sysdate,hire_date)) months_worked from employees;	XEPDB1	1676887263018	SQL	1	0.016
select last_name ,(months_between(sysdate,hire_date)) months_worked from employees;	XEPDB1	1676887253696	SQL	1	0.014
select last_name ,trunc(months_between(sysdate,hire_date)) months_worked from employees;	XEPDB1	1676887217661	SQL	1	0.011
select last_name ,months_between(sysdate,hire_date) months_worked from employees;	XEPDB1	1676887197514	SQL	1	0.013
select last_name, length(last_name)  from employees where lower(last_name) like '&b%';	XEPDB1	1676886968228	SQL	1	0.009
select last_name from employees where lower(last_name) like '&b%';	XEPDB1	1676886740849	SQL	1	0.008
select last_name from employees where last_name like '&b%';	XEPDB1	1676886722858	SQL	1	0.007
select initcap(last_name) , length(last_name) from employees where last_name like 'A%' or last_name like 'J%' or last_name like 'M%';	XEPDB1	1676886146870	SQL	1	0.016
select initcap(last_name) , length(last_name) from employees where last_name like 'A' or last_name like 'J' or last_name like 'M';	XEPDB1	1676886115062	SQL	1	0.012
select employee_id,last_name, salary ,(salary*.155)+salary "Newsalary",((salary*.155)+salary)-salary "incresre" from employees;	XEPDB1	1676885622126	SQL	1	0.009
select employee_id,last_name, salary ,((salary*.155)+salary)-salary "Newsalary" from employees;	XEPDB1	1676885594649	SQL	1	0.017
select employee_id,last_name, salary ,salary-((salary*.155)+salary) "Newsalary" from employees;	XEPDB1	1676885576500	SQL	1	0.012
select employee_id,last_name, salary ,(salary*.155)+salary "Newsalary" from employees;	XEPDB1	1676885541383	SQL	1	0.01
select employee_id,last_name, salary , salary*.15+salary "Newsalary" from employees;	XEPDB1	1676885500416	SQL	1	0.012
select employee_id,last_name, salary , salary*.15+salary "newsalary" from employees;	XEPDB1	1676885484326	SQL	1	0.035
select sysdate "Date" from dual;	XEPDB1	1676885413776	SQL	1	0.004
select sysdate "date" from dual;	XEPDB1	1676885389705	SQL	1	0.006
select sysdate from dual;	XEPDB1	1676885239197	SQL	1	0.009
select last_name, salary , commission_pct from employees where commission_pct=0.2;	XEPDB1	1676885135037	SQL	1	0.009
select last_name, salary , commission_pct from employees where commission_pct=20;	XEPDB1	1676885102116	SQL	1	0.006
select last_name, salary , commission_pct from employees where commission_pct>20;	XEPDB1	1676885089219	SQL	1	0.037
 desc employees;	XEPDB1	1676884636704	SQL	1	0.5
select * from departments;	XEPDB1	1676884614397	SQL	1	0.026
desc departments;	XEPDB1	1676884584374	SQL	1	0.703
desc department;	XEPDB1	1676884531642	SQL	1	1.413
select to_char(sysdate,'DDspth "of" month ')||
','||to_char(sysdate,'rrrr')  as "date" from dual;	XEPDB1	1676878109706	SQL	1	0.004
select * from employees where( 1=1 and &&column > 2000 or &&column<10000);	XEPDB1	1676875231726	SQL	1	0.015
select * from employees where( 1=1 and &column > 2000 or &column<10000);	XEPDB1	1676875194755	SQL	2	0.022
select substr('sumita',instr('sumita','u',1,1), instr('sumita','i',1,1)-instr('sumita','u',1,1) )from dual;	XEPDB1	1676872912267	SQL	1	0.007
select substr('sumita',instr('sumita','u',1,1)), instr('sumita','i',1,1)-instr('sumita','u',1,1 )from dual;	XEPDB1	1676872829219	SQL	1	0.011
SELECT TRUNC(SYSDATE,'month') FROM DUAL;	XEPDB1	1676870403012	SQL	1	0.004
 describe table employees;	XEPDB1	1676817754585	SQL	2	0.221
SELECT department_id
FROM employees;	XEPDB1	1676817478953	SQL	1	0.029
SELECT last_name ||': 1 Month salary = '||salary Monthly
FROM employees;	XEPDB1	1676816438148	SQL	1	0.053
SELECT last_name ||' is a '||job_id
AS "Employee Details"
FROM employees;	XEPDB1	1676816412387	SQL	1	0.014
SELECT last_name||job_id AS "Employees"
FROM employees;	XEPDB1	1676816250088	SQL	1	0.032
SELECT last_name "Name" , salary*12 "Annual Salary"
FROM employees;	XEPDB1	1676816125040	SQL	1	0.016
select 3/2 from dual;	XEPDB1	1676812472203	SQL	1	0.007
select to_char(trunc(sysdate,'day')) from dual;	XEPDB1	1676629512901	SQL	1	0.005
select *from employees where employee_id is not null offset 10 rows  fetch next
     5 rows only;	XEPDB1	1676615376691	SQL	1	0.017
select *from employees where employee_id is not null offset 10 rows;	XEPDB1	1676615345122	SQL	1	0.016
select * from employees where department_id between 80 and 90;	XEPDB1	1676612880891	SQL	1	0.018
select * from employees order by salary;	XEPDB1	1676611932369	SQL	1	0.046
 alter table intelloger add constraints empid primary key(eid);	XEPDB1	1676547409528	SQL	1	0.044
 alter table intelloger drop constraints SYS_C008408;	XEPDB1	1676547128300	SQL	1	0.095
create table company(employee_id number,pureadd varchar2(30),mail varchar2(20))	XEPDB1	1676544655624	SQL	2	0.008
 drop table intelloger	XEPDB1	1676544617486	SQL	1	0.886
desc employees;	XEPDB1	1676539927288	SQL	1	1.23
insert into rp_t values ( 'rachit',12);
 insert into rp_t('robin',19);
 insert into rp_('rahul',10);	XEPDB1	1676527806443	Script	1	0.127
 drop table rachitpanwar	XEPDB1	1676525722157	SQL	1	0.43
select * from USER_CONS_COLUMNS WHERE TABLE_NAME ='RACHITPANWAR'	
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='RACHITPANWAR'	
alter table  RACHITPANWAR DROP CONSTRAINTS SYS_C008356
alter table  RACHITPANWAR DROP CONSTRAINTS SYS_C008355	
   alter table  RACHITPANWAR ENABLE CONSTRAINTS SYS_C008355
  alter table  RACHITPANWAR ENABLE CONSTRAINTS SYS_C008354	
 alter table  RACHITPANWAR ENABLE CONSTRAINTS SYS_C008352	
 alter table  RACHITPANWAR ENABLE CONSTRAINTS SYS_C008356	
alter table  RACHITPANWAR DISABLE CONSTRAINTS SYS_C008351	
alter table  RACHITPANWAR DISABLE CONSTRAINTS SYS_C008350
 alter table  RACHITPANWAR DISABLE CONSTRAINTS SYS_C008357	
 alter table  RACHITPANWAR DISABLE CONSTRAINTS SYS_C008354
 CREATE  TABLE RACHITPANWAR ( NAME  VARCHAR2(20) NOT NULL,ADDRESS VARCHAR2(10) NOT NULL, PHNO NUMBER UNIQUE, EMAIL VARCHAR(20) UNIQUE , EID  NUMBER NOT NULL UNIQUE, AGE NUMBER NOT NULL UNIQUE, ID  NUMBER PRIMARY KEY ,DEPT VARCHAR(5),HIREDATE NUMBER,DESIGNATION VARCHAR2(10))	XEPDB1	1676459432601	SQL	1	0.038
CREATE TABLE DUMB(NAME VARCHAR2(10), ID NUMBER)	4
SELECT * FROM DELL	
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = UPPER('RP')	
SELECT * FROM RP;
SELECT USER CONSTRAINT FROM RP;	
CREATE TABLE RP(ID NUMBER NOT NULL,NAME VARCHAR2(20))	
 create table orac
(
id number unique not null,
name varchar2(50),
address varchar2(100) default '55 chandan nagar dehradun'
)	
ALTER TABLE RACHITDB MODIFY  LASTNAME NUMBER	

select to_char(sysdate+9,'rrrr') from employees;

select avg(salary) from employees where 1=1;

select department_id,max(salary) from employees group by department_id;

select *from employees where department_id=10;

select sum(salary),department_id from employees group by department_id;

select sum(salary), department_id from employees ;

select department_id ,sum(salary)
from employees
where 1=1
group by department_id having sum(salary)>10000; 

select department_id ,sum(salary) , max(salary),min(salary),avg(salary),count(salary) from employees where last_name like '%n' group by department_id  having sum(salary)>10000;
select * from employees;

select sum(commission_pct) , count(commission_pct) , avg(commission_pct)from employees;

select department_id ,sum(salary) , max(salary),min(salary),avg(salary),count(salary) from employees where first_name like '%n' group by department_id  having sum(salary)>10000; 

select max(hire_date) from employees;
select min(hire_date) from employees;

select max(salary) from employees group by department_id; 

select MAX(max(salary)) from employees group by department_id;
SELECT  COUNT(* ) FROM EMPLOYEES;
SELECT  COUNT(1 ) FROM EMPLOYEES;
SELECT  COUNT('TEST' ) FROM EMPLOYEES;
SELECT  COUNT(1 ) FROM EMPLOYEES;
SELECT  COUNT(DISTINCT(JOB_ID) ) FROM EMPLOYEES;

SELECT * FROM EMPLOYEES;
SELECT JOB_ID,MAX(SALARY) FROM EMPLOYEES  WHERE JOB_ID LIKE '%/_AC%' ESCAPE '/' GROUP BY JOB_ID;

SELECT FIRST_NAME FROM EMPLOYEES WHERE FIRST_NAME LIKE '%e';

SELECT *  FROM EMPLOYEES   WHERE SUBSTR(FIRST_NAME,-1) = 'e'; 

select * from employees where instr(first_name ,'e',-1)= 'e';

select department_id,avg(salary)from employees where 1=1 group by department_id having (count(employee_id)>10);

select job_id,min(salary) from employees where 1=1 group by job_id having min(salary)>4000;

select count(employee_id), avg(salary) from employees where department_id=80

select sum(salary+nvl(commission_pct,0)) as "salary" from employees where department_id=60;

select min(salary), manager_id from employees group by manager_id;

select job_id,count(employee_id) from employees  group by job_id;

select count(nvl(employee_id,0)) from employees;

select department_id,count(nvl(employee_id,0)) from employees where to_char(hire_date,'rrrr')=2002 group by department_id ;

select department_id,count(nvl(employee_id,0)) from employees where to_char(hire_date,'mon')= 'aug' group by department_id;

select department_id,max(salary),min(salary), max(salary)-min(salary) difference from employees  group by department_id   ;

select * from user_tab_columns where lower(column_name) ='department_id';

create table rR(
id varchar(5),ID2 VARCHAR(2) )

ALTER TABLE rR ADD ID3 VARCHAR(4);

ALTER TABLE rR ADD CONSTRAINT UNIQUE(id);

SELECT * FROM rR;

select first_name from employees where instr(first_name,'e')=3;\

 select  nvl(department_id,0),count(to_char(hire_date,'rrrr')) total_hire_people  from employees where to_char(hire_date,'rrrr')=2001 group by department_id;
 
 select nvl(department_id,0) from employees group by department_id;
 
select emp.department_id dept_id , case when to_char(emp.hire_date,'RRRR')=2005 then count(emp.hire_date)
end "2005", 
case when (to_char(emp.hire_date,'RRRR')=2006) then count(emp.hire_date) end "2006"
  from employees emp group by emp.department_id ;

select department_id,
case when to_char (HIRE_DATE,'rrrr')='2001'
then 2001 else 0 end hire_emp_2001
,case when to_char (HIRE_DATE,'rrrr')='2002'
then 2002 else 0 end hire_emp_2002 from employees --where to_char(hire_date,'rrrr')in (2001,2002,2003,2004,2005)\
group by department_id, to_char(HIRE_DATE,'rrrr')
order by department_id;



select JOB_ID,case when JOB_ID when 'ST_CLERK' then 'GROUP_A'  ELSE NULL  END GROUP_A,
CASE JOB_ID WHEN 'AC_MGR' THEN 'GROUP B'
ELSE NULL END GROUP_B FROM EMPLOYEES;

SELECT DEPARTMENT_ID,SUM(CASE WHEN TO_CHAR (HIRE_DATE,'RRRR')='2001' THEN 1 ELSE 0 END) HIRE_2001
, SUM(CASE WHEN TO_CHAR (HIRE_DATE,'RRRR') ='2002' THEN 1 ELSE 0 END) HIRE_2002,
 SUM(CASE WHEN TO_CHAR (HIRE_DATE,'RRRR') ='2003' THEN 1 ELSE 0 END)  HIRE_2003
FROM EMPLOYEES 
GROUP BY DEPARTMENT_ID
ORDER BY 1;

SELECT COUNT(EMPLOYEE_ID) FROM EMPLOYEES GROUP BY EMPLOYEE_ID; 

SELECT MAX(SALARY) MAXIMUM,MIN(SALARY) MINIMUM,SUM(SALARY) SUM ,ROUND(AVG(SALARY)) AVERAGE FROM EMPLOYEES ;

SELECT  JOB_ID,MAX(SALARY),MIN(SALARY), SUM(SALARY), AVG(SALARY) FROM EMPLOYEES  GROUP BY JOB_ID;

SELECT JOB_ID, COUNT(JOB_ID) FROM EMPLOYEES GROUP BY JOB_ID;

SELECT &&JOB_ID, COUNT(&&JOB_ID) FROM EMPLOYEES GROUP BY &&JOB_ID;

SELECT COUNT( DISTINCT(MANAGER_ID)) FROM EMPLOYEES;

SELECT MAX(SALARY)-MIN(SALARY) DIFFERENCE FROM EMPLOYEES;

SEKECT COUNT(DISTINCT ( MANAGER_ID)),MIN(SALARY) FROM EMPLOYEES GROUP BY MANAGER_ID HAVING MIN(SALARY)<6000;  


file:/C:/Users/rachi/SWL COMPLETED.sql	XEPDB1	1677753221294	Script	14	0.0
SELECT last_name, hire_date
FROM employees
WHERE hire_date < '01-FEB-08';	XEPDB1	1677738391356	SQL	1	0.019
select * from employees where SUBSTR(last_name, -1, 1) = 'n';	XEPDB1	1677737408300	SQL	3	0.008
select * from employees where SUBSTR(last_name, -1) = 'n';	XEPDB1	1677737402785	SQL	1	0.01
SELECT employee_id, CONCAT(first_name, last_name) NAME,
job_id, LENGTH (last_name),
INSTR(last_name, 'a') "Contains 'a'?"
FROM employees
WHERE SUBSTR(job_id, 4) = 'REP';	XEPDB1	1677736560238	SQL	1	0.007
SELECT employee_id, UPPER(last_name), department_id
FROM employees
WHERE INITCAP(last_name) = 'Higgins';	XEPDB1	1677736187696	SQL	1	0.01
sELECT employee_id, last_name, department_id
FROM employees
WHERE LOWER(last_name) = 'higgins';	XEPDB1	1677736122698	SQL	1	0.008
SELECT employee_id, last_name, department_id
FROM employees
WHERE last_name = 'higgins';	XEPDB1	1677736100719	SQL	1	0.005
SELECT 'The job id for '||UPPER(last_name)||' is '
||LOWER(job_id) AS "EMPLOYEE DETAILS"
FROM employees;	XEPDB1	1677736042244	SQL	1	0.017
SELECT employee_id, last_name, salary
FROM employees
WHERE employee_id = &employee_num;	XEPDB1	1677735471622	SQL	1	0.006
SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE employee_id = &employee_num;	XEPDB1	1677735302166	SQL	2	0.051
select e.department_id,e.first_name, e1.first_name  "collegue name" from employees e , employees e1 where e.department_id=e1.department_id and e.employee_id!=e1.employee_id group by e.department_id,e.first_name,e1.first_name order by 1	XEPDB1	1677652688537	SQL	1	0.077
select e.department_id,e.first_name, e1.first_name  "collegue name" from employees e , employees e1 where e.department_id=e1.department_id group by e.department_id,e.first_name,e1.first_name order by 1	XEPDB1	1677652535240	SQL	1	0.084
select e.department_id,count(*),e.first_name||' '||last_name from employees e group by e.department_id,e.first_name||' '||last_name order by 1;	XEPDB1	1677651720062	SQL	1	0.016
select e.department_id,count(*),e.first_name||' '||last_name from employees e group by e.department_id,e.first_name||' '||last_name;	XEPDB1	1677651706918	SQL	1	0.031
select e.department_id,count(*),e.first_name from employees e group by e.department_id,e.first_name;	XEPDB1	1677651561423	SQL	4	0.006
select e.department_id,count(*) from employees e group by e.department_id;	XEPDB1	1677651536558	SQL	4	0.004
select e.employee_id, e1.first_name from employees e, employees e1 where e.employee_id=e.employee_id group by e.employee_id, e1.first_name;	XEPDB1	1677651173242	SQL	1	0.021
select e.employee_id, e1.first_name from employees e, employees e1 where e.employee_id=e.employee_id;	XEPDB1	1677651123229	SQL	1	0.041
select * from employees order by employee_id offset 5 rows  fetch next 10 rows  with ties;	XEPDB1	1677650550205	SQL	1	0.158
select * from employees fetch first 10 rows only;	XEPDB1	1677648940728	SQL	1	0.014
select * from employees order by employee_id offset 5 rows fetch next 10 rows  with ties;	XEPDB1	1677648883834	SQL	1	0.017
select * from employees order by employee_id offset 5 rows fetch next 10 rows only;	XEPDB1	1677648647964	SQL	3	0.006
select * from employees  offset 5 rows fetch next 10 rows only;	XEPDB1	1677648602742	SQL	2	0.014
select * from employees order by 3 offset 5 rows fetch next 10 rows only;	XEPDB1	1677648569569	SQL	1	0.122
select employee_id , first_name from employees order by employee_id offset 10 rows fetch next 5 rows only;	XEPDB1	1677648497322	SQL	1	0.032
select *from employees;	XEPDB1	1677648301101	SQL	1	0.119
select distinct job_id from employees;	XEPDB1	1677646575485	SQL	1	0.231
select first_name||' '||last_name  full_name , salary*12 as "annual salary" from employees;	XEPDB1	1677644527607	SQL	1	0.012
select first_name||' '||last_name  "full name" , salary*12 as "annual salary" from employees;	XEPDB1	1677644515174	SQL	1	0.028
select first_name||' '||last_name  "full name" , salary*12 as "salary" from employees;	XEPDB1	1677644503267	SQL	1	0.012
select first_name||' '||last_name  "full name" from employees;	XEPDB1	1677644366068	SQL	1	0.108
select distinct manager_id from employees;	XEPDB1	1677587915357	SQL	1	0.011
select department_id, count(1) from employees group by department_id;	XEPDB1	1677587851500	SQL	3	0.003
select first_name ,department_id , count(1) from employees group by department_id, first_name;	XEPDB1	1677587847113	SQL	2	0.009
select department_id, count(1),first_name,last_name from employees group by department_id,first_name,last_name;	XEPDB1	1677587759374	SQL	1	0.015
select first_name,last_name,department_id, count(1) from employees group by department_id,first_name,last_name;	XEPDB1	1677587719657	SQL	2	0.004
select first_name,last_name,department_id from employees;	XEPDB1	1677587581350	SQL	1	0.026
select first_name,last_name,department_id, count(manager_id) from employees group by department_id,first_name,last_name;	XEPDB1	1677587520194	SQL	1	0.029
select first_name,last_name,manager_id , count(manager_id) from employees group by manager_id,first_name,last_name;	XEPDB1	1677587486657	SQL	1	0.05
select first_name||' '||last_name ,to_char(hire_date,'day') from employees;	XEPDB1	1677587107675	SQL	1	0.01
select to_char('243437805','l99g99g99g999') from dual;	XEPDB1	1677586848514	SQL	1	0.003
select  e.manager_id,count(*),ee.first_name|| ' '|| ee.last_name manager_name
FROM employees e,employees ee WHERE ee.employee_id (+) = e.manager_id group by e.manager_id,ee.first_name||' '|| ee.last_name;	XEPDB1	1677586696924	SQL	1	0.048
select e.manager_id,count(1) from employees e group by manager_id;	XEPDB1	1677586627032	SQL	2	0.003
select count(e.employee_id) from employees e, employees e1 where e.employee_id=e1.manager_id;	XEPDB1	1677586065423	SQL	1	0.039
select g.grade,e.salary,g.min_salary,g.max_salary from employees e, grade g where salary between g.min_salary and g.max_salary;	XEPDB1	1677585355640	SQL	3	0.01
select * from jobs;	XEPDB1	1677583263390	SQL	4	0.002
select j.job_id, e.salary,j.min_salary,j.max_salary from employees e, jobs j where salary between j.min_salary and j.max_salary;	XEPDB1	1677583207286	SQL	2	0.005
select  e.salary,g.min_salary,g.max_salary from employees e, grade g where salary between g.min_salary and g.max_salary;	XEPDB1	1677583127851	SQL	1	0.016
select j.job_id, e.salary from employees e, jobs j where salary between j.min_salary and j.max_salary;	XEPDB1	1677582583215	SQL	1	0.006
select j.job_id, e.salary from employees e, jobs j where salary between min_salary and max_salary;	XEPDB1	1677582535159	SQL	2	0.005
select j.job_id from employees e, jobs j where salary between min_salary and max_salary;	XEPDB1	1677582379665	SQL	1	0.007
select e.job_id from employees e, jobs j where salary between min_salary and max_salary;	XEPDB1	1677582365485	SQL	1	0.009
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
    AND e.hire_date < e1.hire_date;	XEPDB1	1677581995695	SQL	1	0.014
select e1.first_name||' '||e1.last_name, e.manager_id,e.hire_date ,e.first_name,e.hire_date 
from employees e,employees e1 
where  e.employee_id=e1.manager_id  and e.hire_date<e1.hire_date;	XEPDB1	1677581786759	SQL	1	0.01
select e1.first_name||' '||e1.last_name, e.manager_id,e.hire_date ,e.first_name,e.hire_date
from employees e,employees e1 
where  e.employee_id=e1.manager_id  and e.hire_date<e1.hire_date;	XEPDB1	1677581184113	SQL	2	0.006
select e1.first_name||' '||e1.last_name, e.manager_id,e.hire_date ,e.first_name
from employees e,employees e1 
where  e.employee_id=e1.manager_id  and e.hire_date<e1.hire_date;	XEPDB1	1677580952970	SQL	1	0.03
select e1.first_name||' '||e1.last_name, e.manager_id,e.hire_date ,e.first_name
from employees e,employees e1 
where  e.employee_id=e1.manager_id  order by e.first_name;	XEPDB1	1677580751180	SQL	1	0.033
select e1.first_name||' '||e1.last_name, e.manager_id,e.hire_date ,e.first_name
from employees e,employees e1 
where  e.employee_id=e1.manager_id	XEPDB1	1677580720590	SQL	1	0.039
select e1.first_name||' '||e1.last_name, e.manager_id,e.hire_date 
from employees e,employees e1 
where  e.employee_id=e1.manager_id	XEPDB1	1677580698700	SQL	1	0.02
select e.first_name||' '||e.last_name, e.manager_id,e.hire_date 
from employees e,employees e1 
where  e.employee_id=e1.manager_id	XEPDB1	1677580445461	SQL	1	0.016
select e.first_name||' '||e.last_name, e.manager_id,e.hire_date 
from employees e,employees e1 
where  e.employee_id(+)=e1.manager_id	XEPDB1	1677580417853	SQL	1	0.033
select e.first_name, e.manager_id,e.hire_date 
from employees e,employees e1 
where  e.employee_id(+)=e1.manager_id	XEPDB1	1677580353412	SQL	1	0.012
select e.first_name, e.manager_id,e.hire_date from employees e,employees e1 where  e.employee_id=e1.manager_id	XEPDB1	1677580307346	SQL	1	0.036
select * from all_objects where object_name like upper('j%');	XEPDB1	1677579733042	SQL	1	0.231
select * from all_objects where object_name like upper('%grade%');	XEPDB1	1677579722105	SQL	1	0.295
select * from all_objects where object_name like upper('job%');	XEPDB1	1677579699909	SQL	2	0.214
select * from all_objects where object_name like upper('job_g%');	XEPDB1	1677579693931	SQL	1	0.167
select * from all_objects where object_name like upper('job_grad%
');	XEPDB1	1677579685256	SQL	1	0.165
select * from all_objects where object_name like upper('job_grades');	XEPDB1	1677579677320	SQL	1	0.208
select * from all_cons_columns where table_name like upper('job%');	XEPDB1	1677579627734	SQL	1	0.397
select ee.first_name,ee.last_name,e.manager_id,ee.first_name||' '||ee.last_name manager_name
from employees e, employees ee where ee.employee_id(+)=e.manager_id;	XEPDB1	1677579301057	SQL	1	0.103
select ee.first_name,ee.last_name,e.manager_id,ee.first_name||' '||e.last_name manager_name
from employees e, employees ee where ee.employee_id(+)=e.manager_id;	XEPDB1	1677579234638	SQL	1	0.029
select ee.first_name,ee.last_name,e.manager_id,ee.first_name||' '||e.last_name manager_name
from employees e, employees ee where e.manager_id =ee.employee_id;	XEPDB1	1677579153484	SQL	1	0.053
select e.first_name,e.last_name,e.manager_id,e.first_name||' '||e.last_name manager_name
from employees e, employees ee where e.manager_id =e.employee_id;	XEPDB1	1677579076366	SQL	1	0.011
select e.first_name||' '||e.last_name,ee.salary,e.manager_id from employees e, employees ee where e.manager_id =ee.employee_id(+);	XEPDB1	1677578520521	SQL	1	0.012
select e.first_name,ee.salary,e.manager_id from employees e, employees ee where e.manager_id =ee.employee_id(+);	XEPDB1	1677578028599	SQL	1	0.039
select e.first_name,ee.salary from employees e, employees ee where e.manager_id =ee.employee_id(+);	XEPDB1	1677578012253	SQL	1	0.018
select e.first_name,ee.salary from employees e, employees ee where e.manager_id =ee.employee_id;	XEPDB1	1677577991250	SQL	1	0.054
select e.first_name from employees e, employees ee where e.manager_id =ee.employee_id;	XEPDB1	1677577930637	SQL	1	0.055
SELECT * FROM EMPLOYEES  E, EMPLOYEES E1 WHERE E.MANAGER_ID=E1.employee_id(+);	XEPDB1	1677576781086	SQL	1	0.019
SELECT * FROM EMPLOYEES  E, EMPLOYEES E1 WHERE E.MANAGER_ID(+)=E1.employee_id;	XEPDB1	1677576764310	SQL	1	0.027
SELECT * FROM EMPLOYEES  E, EMPLOYEES E1 WHERE E.MANAGER_ID=E1.employee_id;
SELECT * FROM EMPLOYEES  E, EMPLOYEES E1 WHERE E.MANAGER_ID=E1.MANAGER_id;	
SELECT EMP.FIRST_NAME||' '||LAST_NAME , EMP.DEPARTMENT_ID, DPT.DEPARTMENT_NAME,EMP.SALARY,EMP.JOB_ID FROM EMPLOYEES EMP, DEPARTMENTS DPT WHERE EMP.DEPARTMENT_ID!=DPT.DEPARTMENT_ID ORDER BY EMPLOYEE_ID;
SELECT EMP.FIRST_NAME,EMP.SALARY,J.JOB_ID, J.DEPARTMENT_ID, J.START_DATE,J.END_DATE FROM EMPLOYEES EMP,JOB_HISTORY  J WHERE EMP.EMPLOYEE_ID(+)=J.EMPLOYEE_ID  ORDER BY EMP.EMPLOYEE_ID;
SELECT EMP.FIRST_NAME,EMP.SALARY,J.JOB_ID, J.DEPARTMENT_ID, J.START_DATE,J.END_DATE FROM EMPLOYEES EMP,JOB_HISTORY  J WHERE EMP.EMPLOYEE_ID=J.EMPLOYEE_ID(+)  ORDER BY EMP.EMPLOYEE_ID;
SELECT EMP.FIRST_NAME,EMP.SALARY,J.JOB_ID, J.DEPARTMENT_ID, J.START_DATE,J.END_DATE FROM EMPLOYEES EMP,JOB_HISTORY J WHERE EMP.EMPLOYEE_ID(+)=J.EMPLOYEE_ID  ORDER BY EMP.EMPLOYEE_ID;
SELECT EMP.FIRST_NAME,EMP.SALARY,J.JOB_ID, J.DEPARTMENT_ID, J.START_DATE,J.END_DATE FROM EMPLOYEES EMP,JOB_HISTORY J WHERE EMP.EMPLOYEE_ID(+)=J.EMPLOYEE_ID;	
SELECT EMP.FIRST_NAME,EMP.SALARY,J.JOB_ID, J.DEPARTMENT_ID FROM EMPLOYEES EMP,JOB_HISTORY J WHERE EMP.EMPLOYEE_ID=J.EMPLOYEE_ID(+);	
SELECT EMP.FIRST_NAME,EMP.SALARY,J.JOB_ID, J.DEPARTMENT_ID FROM EMPLOYEES EMP,JOB_HISTORY J WHERE EMP.EMPLOYEE_ID(+)=J.EMPLOYEE_ID;
SELECT EMP.FIRST_NAME,EMP.SALARY,J.JOB_ID, J.DEPARTMENT_ID FROM EMPLOYEES EMP,JOB_HISTORY J WHERE EMP.JOB_ID(+)=J.JOB_ID;	
SELECT EMP.FIRST_NAME , J.JOB_ID FROM EMPLOYEES EMP,JOBS J WHERE EMP.JOB_ID=J.JOB_ID;	
SELECT * FROM JOBS;	
SELECT * FROM REGIONS;	
SELECT * FROM DEPARTMENTS WHERE LOCATION_ID IS NULL;	
SELECT * FROM DEPARTMENTS;	
SELECT * FROM EMPLOYEES WHERE JOB_ID IS NULL;	
SELECT EMP.FIRST_NAME||' '||LAST_NAME , EMP.DEPARTMENT_ID, DPT.DEPARTMENT_NAME,EMP.SALARY,EMP.JOB_ID FROM EMPLOYEES EMP, DEPARTMENTS DPT WHERE EMP.DEPARTMENT_ID(+)=DPT.DEPARTMENT_ID ORDER BY EMPLOYEE_ID;	XEPDB1	1677569132350	SQL	2	0.008
SELECT EMP.FIRST_NAME||' '||LAST_NAME , EMP.DEPARTMENT_ID, DPT.DEPARTMENT_NAME,EMP.SALARY,EMP.JOB_ID FROM EMPLOYEES EMP, DEPARTMENTS DPT WHERE EMP.DEPARTMENT_ID=DPT.DEPARTMENT_ID(+) ORDER BY EMPLOYEE_ID;
    
    
    SELECT *FROM DEPARTMENTS ;
    SELECT * FROM EMPLOYEES;
    SELECT *FROM JOBS;
    SELECT * FROM JOB_HISTORY;
    SELECT *FROM REGIONS;
    SELECT * FROM LOCATIONS;
    SELECT * FROM COUNTRIES;
    S
    
    SELECT L.LOCATION_ID,L.STREET_ADDRESS,L.CITY,L.STATE_PROVINCE,C.COUNTRY_NAME FROM LOCATIONS L, COUNTRIES C WHERE L.COUNTRY_ID=L.COUNTRY_ID;
    
    SELECT E.LAST_NAME,D.DEPARTMENT_ID,D.DEPARTMENT_NAME FROM EMPLOYEES E, DEPARTMENTS D WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID ;
    
    SELECT E.LAST_NAME,E.JOB_ID,E.DEPARTMENT_ID,D.DEPARTMENT_NAME FROM EMPLOYEES E, DEPARTMENTS D , LOCATIONs L WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID and D.location_id=L.location_id AND L.CITY='Toronto' ;
    
    SELECT E.LAST_NAME,E.EMPLOYEE_ID EMP#,M.LAST_NAME,M.EMPLOYEE_ID MGR# FROM EMPLOYEES E, EMPLOYEES M WHERE E.MANAGER_ID=M.EMPLOYEE_ID  ;
    
    SELECT E.FIRST_NAME EMPLOYEE , E.EMPLOYEE_ID , M.FIRST_NAME MANAGER , M.EMPLOYEE_ID MGR# FROM EMPLOYEES E,EMPLOYEES M WHERE E.MANAGER_ID=M.EMPLOYEE_ID;
    
    SELECT E.LAST_NAME, E.DEPARTMENT_ID,E1.LAST_NAME COLLEAGUE FROM EMPLOYEES E, EMPLOYEES E1 WHERE E.DEPARTMENT_ID=E1.DEPARTMENT_ID AND E.EMPLOYEE_ID!=E1.EMPLOYEE_ID;
    
    DESC JOB_GRADES;
    
    DESC GRADES;
    
    DESC GRADE;
    SELECT * FROM GRADE;
    INSERT INTO GRADE VALUES('D',18001,24000);
    
    SELECT E.FIRST_NAME,E.JOB_ID,
   D.DEPARTMENT_NAME,E.SALARY,G.GRADE 
    FROM EMPLOYEES E,GRADE G , DEPARTMENTS D
    WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID(+)
    AND E.SALARY BETWEEN G.MIN_SALARY AND G.MAX_SALARY;
    
    select first_name,hire_date from employees where last_name='Davies';
    
    SELECT e.LAST_NAME , e.hirE_DATE FROM EMPLOYEES e, employees m WHERE e.hire_date>m.hire_date and m.last_name='Davies';
    
    select m.first_name,m.hire_date,e.first_name,e.hire_date from employees e, employees m where e.manager_id=m.employee_id and e.hire_date>m.hire_date;
    
     select * from user_objects where OBJECT_TYPE='TABLE'  order by created desc;
     
     select * from user_CONSTRAINTS where TABLE_name='INV_EMPLOYEES'; 
     
     FK_INV_EMPLOYEES_MANAGER
     select *from user_cons_columns
     where constraint_name='SYS_C009705';
     
  select * from employees;  
  
  
  declare
  b varchar2(50);
  a number;
  begin
  b :='hi rachit';
  A  :=10;
  dbms_output.put_line('b' );
  dbms_output.put_line(A);
  end;
       