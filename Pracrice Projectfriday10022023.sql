Q1-
Write a query to list the names (first and last) of those employees whose first name has only five characters and starts with 'S'.

SELECT EMP.FIRST_NAME || ' ' || EMP.LAST_NAME "NAME" FROM EMPLOYEES EMP WHERE LENGTH(EMP.FIRST_NAME) =5 AND  UPPER(EMP.FIRST_NAME) LIKE 'S%';

Q2-
Write a query to list the names (first and last) of those employees whose first name has only five characters and last name have third alphabet ends with 'n'.
SELECT EMP.FIRST_NAME ,EMP.LAST_NAME FROM EMPLOYEES EMP WHERE LENGTH(FIRST_NAME )=5 AND UPPER(EMP.LAST_NAME) LIKE '%S__';
Q3-
Write a query to list the names (first and last), hire date of those employees who joined in the month of which second character is 'e'.
SELECT EMP.FIRST_NAME ,EMP.LAST_NAME ,EMP.HIRE_DATE ,TO_CHAR(HIRE_dATE,'MONTH') "HIRED MONTHS" FROM EMPLOYEES EMP WHERE (TO_CHAR(HIRE_DATE,'MONTH')) LIKE ('__N%'); 

Q4-
Write a query to list the names (first and last), salary of those employees whose salary is four digit number ending with Zero.
SELECT EMP.FIRST_NAME,EMP.LAST_NAME ,EMP.SALARY FROM EMPLOYEES EMP WHERE LENGTH(EMP.SALARY )=4 AND SALARY LIKE '___0%'; 
 
Q5-
Write a query to list the names (first and last), salary of those employees whose names having a character set 'll' together.
SELECT EMP.FIRST_NAME,EMP.LAST_NAME,EMP.SALARY FROM EMPLOYEES EMP WHERE EMP.SALARY LIKE '11%';

Q6-
Write a Oracle SQL statement to get the first date of the current month.
SELECT TRUNC(SYSDATE,'MONTH') FROM DUAL;
Q7-
Write a Oracle SQL statement to get the last date of the current month.
SELECT LAST_DAY(SYSDATE) FROM DUAL;
Q8-
Write a Oracle SQL statement to determine how many days are left in the current month.
SELECT LAST_DAY(SYSDATE)-SYSDATE FROM DUAL;
Q9-
Write a Oracle SQL statement to get the first and last day of the current year.
SELECT TRUNC(SYSDATE,'YEAR'),LAST_DAY(TRUNC(SYSDATE,'YEAR')) FROM DUAL;

Q10-
Write a Oracle SQL statement to get the number of days in current month.
SELECT (SYSDATE)-TRUNC(SYSDATE,'MONTH') FROM DUAL;

Q11-
Write a Oracle SQL statement to get the start date and end date of each month in current year from current month.
select sysdate,ADD_MONTHS(TRUNC(sysdate,'YEAR'),1),round(sysdate,'month'),last_day(sysdate),add_months(sysdate,1) from dual;

SELECT SYSDATE "TODAY DATE",
trunc(sysdate,'year') "Current Year",
last_day(trunc(sysdate,'year')) "Last Date",
to_char(add_months(to_date('01/01/1000', 'DD/MM/RRRR'), ind.l-1), 'MONTH') as month_descr,ind.l as month_ind from dual descr,
       (select l from (select level l  from dual connect by level <= 12)) ind;
       
       
       
to_char(to_date('01/01/1000','DD/MM/RRRR'),ind.1-1),'MONTH'),
ind.1 
from dual descr ,(select 1 from (select level 1 from dual connect by level <=12) ;

select to_char(add_months(to_date('01/01/1000', 'DD/MM/RRRR'), ind.l-1), 'MONTH') as month_descr,
       ind.l as month_ind
  from dual descr,
       (select l
          from (select level l 
                  from dual 
                connect by level <= 12
               )
       ) ind
order by 2;
select trunc(sysdate,1) from dual;
SELECT TRUNC(SYSDATE , 'MONTH') , LAST_DAY(SYSDATE) FROM DUAL;
select to_char(to_date('15-aug-1947','dd-mon-yyyy'),'month')
                                         from dual;
spool C:\Users\somil\OneDrive\Desktop\SQL.csv.txt

select round(sysdate,'DY') from dual;

topic -coalese

select coalesce(commission_pct,manager_id,department_id) from employees;
select * from employees;

select last_day(sysdate) - trunc(sysdate,'MONTH') from dual;
select (sysdate-hire_date) from employees;