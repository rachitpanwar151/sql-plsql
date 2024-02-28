select * from employees;

select count(commission_pct ) from employees;

select commission_pct from employees where commission_pct is null;

select sum(commission_pct)/35 from employees where commission_pct is not null;

select avg(commission_pct) from employees ;
select sum(commission_pct ) from employees;

select min(hire_Date) from employees;
select * from employees order by hire_date desc;


select * from employees where year(hire_date)=2008;
select department_id,sum(salary) from employees where department_id =90 group by department_Id;

select max(hire_date) from employees;

SELECT MAX(MAX(SALARY))  FROM EMPLOYEES GROUP BY DEPARTMENT_ID;


Q-
WAQ TO GET TH EMAX SALARY OF AN EMPLOYEE WORKING AS ACCOUNTANT 


SELECT JOB_ID,MAX(EMP.SALARY) FROM EMPLOYEES  EMP 
WHERE UPPER(EMP.JOB_ID) LIKE '%ACCOUNT' GROUP BY EMP.JOB_ID;


SELECT *FROM EMPLOYEES;

SELECT * FROM EMPLOYEES 
WHERE
UPPER(SUBSTR(FIRST_NAME,LENGTH(FIRST_NAME)-1,1)) ='E';


SELECT DEPARTMENT_ID,AVG(SALARY) FROM EMPLOYEES 
GROUP BY DEPARTMENT_ID HAVING COUNT(DEPARTMENT_ID)<10; 

SELECT SUBSTR(FIRST_NAME,LENGTH(FIRST_NAME),1) FROM EMPLOYEES;
SELECT SUBSTR('SOMIL',LENGTH('SOMIL')) FROM DUAL;
SELECT SUBSTR('SOMIL',-1,1) FROM DUAL;

SELECT SUM(SALARY+NVL(COMMISSION_PCT,0)) 
FROM EMPLOYEES WHERE DEPARTMENT_ID=60 GROUP BY DEPARTMENT_ID;

SELECT SUM(SALARY+COMMISSION_PCT) FROM EMPLOYEES WHERE DEPARTMENT_ID=60;
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID=80;

SELECT DEPARTMENT_ID ,JOB_ID FROM EMPLOYEES GROUP BY DEPARTMENT_ID,JOB_ID; 

SELECT MANAGER_ID,MIN(SALARY) FROM EMPLOYEES  GROUP BY MANAGER_ID ;

SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME='EMPLOYEES';
SELECT * FROM USER_OBJECTS;
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='EMPLOYEES';
SELECT JOB_ID,MIN(SALARY) FROM EMPLOYEES  GROUP BY JOB_ID HAVING MIN(SALARY)>4000;

SELECT DEPARTMENT_ID,AVG(EMP.SALARY) FROM EMPLOYEES EMP WHERE EMP.DEPARTMENT_ID =80 GROUP BY DEPARTMENT_ID;


SELECT COUNT(EMPLOYEE_ID) ,DEPARTMENT_ID 
FROM EMPLOYEES WHERE TO_CHAR(HIRE_DATE,'RRRR')='2002'
TO_CHAR(HIRE_DATE,'MONTH')='AUGUST')
GROUP BY DEPARTMENT_ID;

SELECT EMP.DEPARTMENT_ID,MAX(EMP.SALARY),MIN(EMP.SALARY),
MAX(EMP.SALARY)-MIN(EMP.SALARY)
FROM EMPLOYEES EMP GROUP BY DEPARTMENT_ID;





SELECT * FROM USER_TAB_COLUMNS WHERE UPPER(COLUMN_NAME)='DEPARTMENT_ID';





SELECT * FROM USER_CONS_COLUMNS WHERE UPPER(TABLE_NAME)='EMPLOYEE_ID';

SELECT * FROM USER_CONS_COLUMNS WHERE UPPER(COLUMN_NAME)='DEPARTMENT_ID';

SELECT * FROM EMPLOYEES WHERE UPPER(FIRST_NAME) LIKE '__E%';

SELECT * FROM EMPLOYEES WHERE INSTR(FIRST_NAME,'e',1)=3;

SELECT (INSTR('SOMILMM','M',1) FROM DUAL;

SELECT INSTR('MOELELE','E',3) FROM DUAL WHERE INSTR('MOELELE','E',3)=3;

SELECT DEPARTMENT_ID ,CASE WHEN TO_CHAR(HIRE_DATE,'RRRR')=2005 
THEN COUNT(TO_CHAR(HIRE_DATE,'RRRR'))
ELSE ('0')
END
FROM EMPLOYEES;


SELECT DEPARTMENT_ID ,COUNT(MANAGER_ID) "2004",COUNT(MANAGER_ID) "2005" FROM EMPLOYEES 
WHERE TO_cHAR(HIRE_DATE,'RRRR') =2004 OR
TO_CHAR(HIRE_DATE,'RRRR')=2005
GROUP BY DEPARTMENT_ID ORDER BY DEPARTMENT_ID;

select department_id,count(employee_id) "2001" from employees where to_char(hire_date,'rrrr')=2001 group by department_id ;

SELECT    to_char(hire_date, 'RRRR') "Hire_Year",    
COUNT(to_char(hire_date, 'RRRR')) "Employees_Hire"FROM



SELECT  to_char(hire_date, 'RRRR') "Hire_Year",  
COUNT(to_char(hire_date, 'RRRR')) "Employees_Hire"FROM 
employees GROUP BY to_char(hire_date, 'RRRR') HAVING to_char(hire_date, 'RRRR') IN ( '2002', '2005', '2004','2008' );    
employees
GROUP BY    
to_char(hire_date, 'RRRR')HAVING    to_char(hire_date, 'RRRR') IN ( '2002', '2005', '2004','2008' );


select emp.department_id dept_id ,
case when to_char(emp.hire_date,'RRRR')=2005 then count(emp.hire_date) end "2005", 
case when (to_char(emp.hire_date,'RRRR')=2006) then count(emp.hire_date) end "2006"
from employees emp group by emp.department_id,
order by department_id;

select department_id,
case when to_char(hire_date,'RRRR')=2002 then count(*) else 0 end  "2002_hire_emp",
case when to_char(hire_date,'RRRR')=2003 then count(*) else 0 end "2003 Hire_emp",
case when to_char(hire_date,'RRRR')=2004 then count(*) else 0 end "2004 hire_emp",
case when to_char(hire_date,'RRRR') =2005 then count(*) else 0 end "2005_hire_emp"
from employees group by department_id,to_Char(hire_date,'RRRR')
order by department_id;

select sum(salary) sum_add from employees ; 



select department_id,hire_Date,case when to_char(hire_date,'RRRR')='2001'
                              then 1 else 0 end hire_2001,
                              case when  to_char(hire_Date,'RRRR') ='2002'
                              then 1 else 0 end hire_2002
                              from employees;