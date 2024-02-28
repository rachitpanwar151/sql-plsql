Q1 - --WAQ TO PRINT FIRST NAME WITH ALIAS NAME WORKER_NAME AND SECOND COLOUMN IS IN UPPER AND CONCAT FIRST AND LAST NAME--
 select EMP.first_name "WORKS_NAME",
 UPPER(EMP.FIRST_NAME) "UPPER NAME",
 CONCAT(CONCAT(EMP.FIRST_NAME,' ') ,
 UPPER(EMP.LAST_NAME)) "FULL NAME" 
 FROM EMPLOYEES EMP;
 
 Q2  --WAQ TO PRINT  WITH UNIQUE DEPARTMENT_ID--
 SELECT DISTINCT EMP.DEPARTMENT_ID "DEPT ID" FROM EMPLOYEES EMP;
 
 Q3 --WAQ TO REMOVE WIDE SPACE IN RIGHT SIDE OF JOB_ID--
 SELECT SUBSTR(EMP.FIRST_NAME,1,1) || '.' || UPPER(EMP.LAST_NAME) || '@GMAIL.COM' "GMAIL ID"  FROM EMPLOYEES EMP;
 
 Q4 --WAQ TO REMOVE WIDE SPACE FROM LEFT SIDE  OF PHONE NUMBER--
 SELECT RTRIM(EMP.JOB_ID) "REMOVE SPACE" FROM EMPLOYEES EMP;
 
 Q5 --WAQ TO REPLACE 'a' WITH 'A' in first name--
 SELECT REPLACE(EMP.FIRST_NAME,'a','A') "NEW NAME" FROM EMPLOYEES EMP;
 
 Q6 --WAQ ORDER BY FIRST_NAME WITH ASC AND JOB_ID IS DESC
 SELECT EMP.FIRST_NAME "NAME",EMP.JOB_ID "ID" 
 FROM EMPLOYEES EMP ORDER BY EMP.FIRST_NAME ASC , EMP.JOB_ID DESC;
 

Q7 --WAQ TO FETCH ALL RECORD LAST_NAME ENDING WITH 'N' OR SALARY EITHER GREATER THAN 5000,COMMISSION_PCT IS EXITS--
SELECT EMP.* FROM EMPLOYEES EMP 
WHERE LOWER(SUBSTR(EMP.LAST_NAME,-1)) =LOWER ('N') 
OR EMP.SALARY>5000 
AND EMP.COMMISSION_PCT IS NOT NULL;

Q8 -- PRINT ALL EMPLOYEED WHERE EMPLOYEE_ID IS EVEN
SELECT EMP.EMPLOYEE_ID "EVEN EMP",LAST_NAME 
FROM EMPLOYEES EMP 
WHERE MOD(EMP.EMPLOYEE_ID,2)=0 
ORDER BY EMP.EMPLOYEE_ID;

Q9 --WAQ TO FETCH ALL DATA OF DEPARTMENT ID 80 AND 90 AND DISPLAY SALARY LOWEST TO HIGHER AND HIDE FIRST 5 ROWS
SELECT EMP.LAST_NAME, EMP.DEPARTMENT_ID ,EMP.SALARY 
FROM EMPLOYEES EMP 
WHERE EMP.DEPARTMENT_ID IN ('80','90') 
ORDER BY EMP.SALARY ASC 
OFFSET 5 ROWS ;




SELECT EMP.EMPLOYEE_ID "EVEN EMP",LAST_NAME 
FROM EMPLOYEES EMP 
WHERE SUBSTR(EMP.EMPLOYEE_ID,-1)IN (0,2,4,6,8)
ORDER BY EMP.EMPLOYEE_ID;

select first_name ,length(first_name) ,length(last_name), nullif(length(first_name),length(last_name)) from employees ;

QUESTION --IF DEPARTMENT ID IS 10 THEN ADD SAME HIKE IN SALARY PRINT WITH ALISA NAME NEW SALARY--
select last_name,(case when salary>5000 then salary+21012
when salary>8000 then salary+2000
when salary >10000 then salary+2131
else salary
end) qulaified_salary from employees

QUESTION -- IF DEPARTMENT ID IS IN BETWEEN 1 -40 THEN HIKE 10% AND BETWEEN 41-60 THEN 20% AND BETWEEN 61-80 THEN 30% ELSE 40% --
select (case 
when salary>10000 then salary +2000
when salary >5000 then salary+100
else salary
end) appliledsalary
from employees;




select emp.first_name, emp.last_name ,emp.salary ,emp.department_id,
(case when department_id =department_id then (1+department_id/100)*salary
else emp.salary
end) New_salary
from employees emp;
SELECT emp.first_name ,emp.last_name ,
(case when emp.department_id between 1 and 40 then 1.10*emp.salary
when emp.department_id between 41 and 60 then 1.2*salary
when  emp.department_id between 61 and 80 then 1.3 *emp.salary
else 1.4 * emp.salary
end) Hike_salary
from employees emp;

SELECT EMP.EMPLOYEE_ID,EMP.FIRST_NAME,EMP.LAST_NAME,EMP.SALARY,EMP.SALARY+emp.SALARY*(DEPARTMENT_ID/100) NEWSALARY 
FROM EMPLOYEES EMP;

select emp.employee_id,emp.first_name,emp.last_name,
emp.salary,
(emp.salary*(nvl(emp.department_id,0)/100))+emp.salary new_salary 
from employees emp;

select nvl(null,0)/100+2 from dual;

QUESTION -- IF MAKE COLOUMN EVEN EMPLOYEE ID AND MAKE COLUMN ID ODD EPLOYEES ID--

SELECT EMP.FIRST_NAME ,EMP.LAST_NAME ,EMP.EMPLOYEE_ID ,(CASE  WHEN MOD(EMPLOYEE_ID,2)=0 THEN 'EVEN'
ELSE 'ODD'
END) "EVEN EMP ID "
FROM EMPLOYEES EMP;

SELECT EMP.FIRST_NAME ,EMP.LAST_NAME ,EMP.EMPLOYEE_ID "EVEN EMP ID",EMP.EMPLOYEE_ID "ODD EMP ID"
(CASE WHEN MOD(EMPLOYEE_ID,2)=0 THEN 'EVEN'
WHEN MOD(EMPLOYEE_ID,2)!=0 THEN 'ODD'
END) "EMP ODD EVEN ID"
FROM EMPLOYEES EMP;

SELECT EMP.FIRST_NAME ,EMP.LAST_NAME ,EMP.EMPLOYEE_ID "EVEN EMP ID",EMP.EMPLOYEE_ID "ODD EMP ID" FROM EMPLOYEES  EMP WHERE MOD(EMPLOYEE_ID ,2)=0;


Q1

SELECT EMP.FIRST_NAME ,emp.salary,emp.commission_pct,
(CASE WHEN (EMP.SALARY<3000 or emp.commission_pct between 0.1 and 0.4) then salary*2
else emp.salary
end) "New salary" 
from employees emp;

Q2

select emp.first_name,emp.last_name,emp.commission_pct,emp.salary,
(case when (emp.salary between 3000 and  5000 or emp.commission_pct >0.2)  then emp.salary*0.50
else emp.salary
end)  "New Salary"
from employees emp;

Q3

select emp.first_name,emp.last_name,emp.commission_pct,emp.salary,
(case when (emp.salary between 5000 and 8000 or commission_pct between 0.1 and 0.4 ) then salary*1.2
else salary
end) "New Salary"
from employees emp;

Q4
select emp.first_name,emp.last_name,emp.commission_pct,emp.salary,
(case when (emp.salary >8000 or commission_pct is not null ) then salary
when commission_pct is null then salary * 3
else salary
end) "New Salary"
from employees emp;





select emp.first_name,emp.last_name,emp.commission_pct,emp.salary,
(CASE WHEN (EMP.SALARY<3000 or emp.commission_pct between 0.1 and 0.4) then salary*2
when (emp.salary between 3000 and  5000 or emp.commission_pct >0.2)  then emp.salary*0.50
when (emp.salary between 5000 and 8000 or commission_pct between 0.1 and 0.4 ) then salary*1.2
when (emp.salary >8000 or commission_pct is not null ) then salary
when nvl(commission_pct,0) is not null then salary * 3
else salary
end) "NEW SALARY" 
from employees emp;





Q5
select emp.first_name,emp.last_name,emp.commission_pct,emp.salary,emp.job_id
from employees emp where department_id between 10 and 50 or department_id >50 order by emp.salary order by job_id;

SELECT EMP.* FROM EMPLOYEES EMP ORDER BY CASE WHEN EMP.DEPARTMENT_ID BETWEEN 10 AND 50 THEN EMP.SALARY ELSE EMP.department_id END;


select emp.department_id,emp.commission_pct ,nvl(emp.commission_pct ,0)+emp.salary "Commission Salary",emp.salary*2 "New Salary"  
from employees emp 
where emp.department_id between 10 and 40  ; 

select *
from employees 
where (case when department_id between 10 and 50 then salary 
else job_id 
end );
select first_name,last_name ,department_id ,salary from employees order by (case when department_id between 10 and 50 then  salary when department_id > 50 then  department_id end);



 select emp.department_id,nvl2(commission_pct, salary+(salary*commission_pct),salary*2) "NEW SALARY" from employees emp where emp.department_id between 10 and 40;
 
 
select emp.department_id,emp.commission_pct ,nvl(emp.commission_pct ,0)+emp.salary "Commission Salary",emp.salary*2 "New Salary"  
from employees emp 
where emp.department_id between 10 and 40  ; 
