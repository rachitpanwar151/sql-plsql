---IMP QUESTIONS


Q--COUNT MANAGER ID  OF VARIOUS MANAGER

SELECT MANAGER_ID ,COUNT(EMPLOYEE_ID) FROM EMPLOYEES GROUP BY MANAGER_ID ORDER BY 1 ;

Q-- COUNT EMPLOYEES AND WRITE MANAGER NAME

SELECT M.MANAGER_ID,COUNT(E.EMPLOYEE_ID), E.FIRST_NAME FROM EMPLOYEES E, EMPLOYEES M WHERE E.EMPLOYEE_ID=M.MANAGER_ID GROUP BY   M.MANAGER_ID, E.FIRST_NAME   ORDER BY M.MANAGER_ID;


Q--WRITE MANAGER OF MANAGER

SELECT E.FIRST_NAME,M.FIRST_NAME,R.FIRST_NAME FROM EMPLOYEES E ,EMPLOYEES M,EMPLOYEES R WHERE E.EMPLOYEE_ID=M.MANAGER_ID AND R.EMPLOYEE_ID = E.MANAGER_ID ORDER BY 1;

Q-- WAQ TO SHOW LI  WORD IN FIRST_NAME WITHOUT USING LIKE OR INSTR OPERATOR


SELECT FIRST_NAME FROM EMPLOYEEs WHERE INSTR(lower(FIrST_NAME),'li',1)!=0;
select first_name from employees where lower(first_name) like 'li%'or lower(first_name) like '%li%' or lower(first_name) like '%li';

select first_name from employees where substr(lower(first_name),instr(first_name,'li',1),2 )='li';

SELECT REPLACE('XYZ FGH XYZ', 'X', 'm') from dual;


SELECT trim(replace(first_name,'li ',' '))  from employees;


select first_name from employees where replace(first_name,'li',' ')>0;

select first_name ,substr(first_name,1,1) from employees;

  SELECT lpad(1000+200.55,14,'*') FROM dual
  
  show user;
  
  select * from user_cons_columns where lower(table_name)='departments';
  
  select * from user_cons_columns;
  
  select * from all_cons_columns;
  
  select * from all_cons_columns where lower(table_name)='departments';
  
  select * from user_tab_cols;
  
  select * from all_tab_cols;
  
  SELECT * FROM ALL_OBJECTS;
  
  SELECT *FROM USER_OBJECTS;
  
  select * from v$nls_parameters;
  
  select hire_date,count(*) from employees group by hire_date;
  
  select count( distinct (hire_date)) from employees;
    
  --16 record with same hiredate
  
  SELECT FIRST_NAME,COUNT(*) FROM EMPLOYEES GROUP BY FIRST_NAME;
  
  select emp.first_name,e.hire_date 
  from employees emp, employees e
  where emp.hire_date=e.hire_date and emp.employee_id<>e.employee_id;
  
  SELECT HIRE_DATE,FIRST_NAME  FROM EMPLOYEES GROUP BY HIRE_DATE , FIRST_NAME;
  
   select hire_date from employees;
    
  SELECT e.hire_date,e.employee_id
FROM Employees e, Employees e1
WHERE to_char(e.hire_Date,'dd-mm-rrrr') = to_char(e1.hire_date,'dd-mm-rrrr')
AND e.Employee_id != e1.Employee_id group by e.hire_date,e.employee_id order by 1;

  select emp.employee_id,e.hire_date 
  from employees emp, employees e
  where emp.hire_date=e.hire_date and emp.employee_id<>e.employee_id;
  
    SELECT e.employee_id,e.first_name,e1.first_name,e1.hire_date
FROM Employees e, Employees e1
WHERE to_char(e.hire_Date,'dd-mm-rrrr') = to_char(e1.hire_date,'dd-mm-rrrr')
AND e.Employee_id != e1.Employee_id group by e.first_name,e1.first_name,e.employee_id,e1.hire_date order by e.first_name;

  select* from user_tab_cols;
  
  select * from all_objects where OBJECT_TYPE='TABLE'  order by created desc;
  
  
  --21  PROPNT NO OF EMPLOYEES HIRE EACH YEAR
  
  SELECT TO_CHAR(HIRE_DATE,'RRRR'),COUNT(*) FROM EMPLOYEES GROUP BY TO_CHAR(HIRE_DATE,'RRRR');
  
  
  --22 PRINT NO OF EMPLOYEE HAVING SMAE JOB_ID
  
  SELECT E.JOB_ID,COUNT(*) FROM EMPLOYEES E,EMPLOYEES E1 WHERE E.JOB_ID=E1.JOB_ID AND E.EMPLOYEE_ID!= E1.EMPLOYEE_ID GROUP BY E.JOB_ID;
  
  --23 ORINT NO OF EMP WORKING IN DIFF DEPT
  
  SELECT DISTINCT E.DEPARTMENT_ID, COUNT(*) FROM EMPLOYEES E GROUP BY E.DEPARTMENT_ID ;
  
  
  --24 PRINT EMPNAME,SALARY,DEPT,JOB_ID AND JOBN TITLE FOR EVERY EMPLOYEE
 SELECT * FROM DEPARTMENTS;
 SELECT * FROM JOBS;
  SELECT E.FIRST_NAME,E.SALARY,D.DEPARTMENT_NAME,J.JOB_TITLE,E.JOB_ID FROM EMPLOYEES E, JOBS J , DEPARTMENTS D WHERE  E.DEPARTMENT_ID=D.DEPARTMENT_ID AND E.JOB_ID=J.JOB_ID;
  
  
  --25 SECOUND HIGHEST SALARY
  SELECT SALARY FROM EMPLOYEES  ORDER BY  SALARY DESC OFFSET 1 ROW FETCH NEXT 1 ROW ONLY ;
  
  --26 DUPLICATE ROWN IN FIRST_NAME
  
  SELECT E.FIRST_NAME FROM EMPLOYEES E, EMPLOYEES E1 WHERE E.FIRST_NAME=E1.FIRST_NAME AND E.EMPLOYEE_ID!=E1.EMPLOYEE_ID;
  
  --27 FETCH ANNUAL SALARY WHOSE MOTHLY SALART IS GIVE IN TBL
  SELECT SALARY*12 FROM EMPLOYEES WHERE SALARY IS NOT NULL;
  
  --28 FETCH FIRST RECORD OF EMPLOYEE TABLE ONLY USING WHERE CLAURSE
  
  SELECT * FROM EMPLOYEES;
  
  SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID=100;
  
  --29 FETCH LAST RECORD ON EMPLOYEE
  
  SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID=107;
  
  select rpad(round(12345678982939495.99),10,'*')from dual;
  
  
  --30 first 10  fetch with where clause
    
  select * from employees where employee_id<110;
  
  --31 fetch recodrd first_name third letter is a without using instr and like
  select * from employees where substr(lower(first_name) ,3,1)='a'; 
  
--32 name hire_date salary fo employees who joined un 2005 and salary >10000
select hire_date,salary from employees where to_char(hire_date,'rrrr')=2005 and salary>10000;

--33 mame who first name start with letter a without using substr,instr,ascii,replace,like
    select first_name from employees where lower(lpad( first_name,1))='a';
    
    
    
    --first_day and lasr day
    
    
--34 display salary and count no of 0 in salary

select salary ,length(salary),replace(salary,'0',' '), sub_str(salary,  from employees;

--35phonr nu,nbrt ka first part nikalo and than us show karo ciuntry code say

select phone_number from employees;

select substr( phone_number,1,instr(phone_number,'.',1)-1) country_code from employees;

--36 fetch country name and cound the total pjone numbrefir that country in eployee table

select * from countries;
select * from regions;
select * from locations;
select * from employees;
select * from departments;
select c.country_name , substr(e.phone_number,1,instr(e.phone_number,'.',1)-1) from  employees e, countries c, locations l, departments d  where e.manager_id=d.manager_id and d.location_id=l.location_id and  l.country_id=c.country_id;

--subquery set
select last_name from employees where department_id=90
;

select last_name,hire_date from employees 

select e.last_name , e.hire_date from employees e  where department_id in( select department_id from employees d where  e.department_id=d.department_id and e.employee_id != d.employee_id);


--2 

SELECT EMPLOYEE_ID,LAST_NAME,SALARY FROM EMPLOYEES WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES);

--3

SELECT EMPLOYEE_ID,LAST_NAME FROM EMPLOYEES WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE UPPER(LAST_NAME) LIKE 'U%' OR UPPER(LAST_NAME) LIKE '%U' OR UPPER(LAST_NAME) LIKE '%U%');

--4
select * from employees;
select * from locations;
select * from countries;
select * from regions;
select * from jobs;
--select e.last_name , e.department_id,e.job_id from employees  e where  e.job_id in ( select job_id from jobs j where j.job_id in( select job_id from regions r where r.region_id in (select r.region_id from countries c where c.country_id in (select l.country_id from locations l where l.location_id=1700))));

select emp.last_name, emp.department_id,emp.job_id from employees emp where emp.department_id in (select dpt.department_id from departments dpt where dpt.location_id =1700);
--5


select e.last_name , e.salary from employees e where e.manager_id in (select ee.employee_id  from employees ee where ee.last_name='King');

--6  

 select department_id ,last_name,job_id from employees  e where e.department_id in (select d.department_id from departments d where d.department_name='Executive');
 
 --7
 
 select last_name from employees where salary>(select max(salary) from employees where department_id=60);
 
 --8
   
SELECT EMPLOYEE_ID,LAST_NAME,salary FROM EMPLOYEES WHERE salary> (SELECT avg(salary) FROM EMPLOYEES WHERE UPPER(LAST_NAME) LIKE 'U%' OR UPPER(LAST_NAME) LIKE '%U' OR UPPER(LAST_NAME) LIKE '%U%' ); 
