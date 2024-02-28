select round(sysdate) from dual;

select trunc(round(sysdate)) from dual;
select first_name,last_name ,salary,job_id from employees order by null;

select add_months(sysdate,2) from dual;
select to_Char(sysdate,'DD-MON-RRRR HH24:MI:SS') "present Date and Time"from dual;

ALTER SESSION SET nls_date_format='DD-MON-YYYY ';

select sysdate from dual;

select hire_date ,last_name from employees;

select to_char(Sysdate,'') from dual;

select last_name from employees where next_day(hire_date) = 'Monday';

SELECT TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date, 6), 'Monday'),
'fmDay, Month ddth, YYYY')
FROM employees
ORDER BY hire_date;

select to_char(next_day(add_months(hire_date,6),'Monday'),'day,month ddth ,yyyy')
from employees;

select * from employees where ;

select * from employees where trim((to_char(hire_date,'day'))) like 'Monday';

select EMP.EMPLOYEE_ID,EMP.last_name ,TO_CHAR(HIRE_DATE,'Month') "HIRE MONTHS" 
from employees EMP 
order by to_char(hire_date,'MM');

SELECT UPPER(TO_CHAR(HIRE_DATE,'MONTH')) FROM EMPLOYEES EMPRDER BY TO_CHAR(EMP.HIRE_DATE,'MM') ;

[11:48] Mamta Bhatt
select * from employees emp order by (to_char(emp.hire_date,'MM'));

[11:48] Shubham Kumar Jha
select emp.* , to_char(hire_date,'mm') "new_month" from employees emp order by to_char(hire_date,'mm');


select last_name,to_char(hire_date,'Month DD YYYY') from employees; where (to_char(hire_date,'Month DD YYYY'));

select emp.last_name, upper(to_char(hire_date,'Day' )) from employees  emp order by to_char(hire_date,'Day');



select hire_date,last_name from employees where to_char(next_day(hire_Date,'month-dd-yyyy'))  'March';



Q-Write a quesry to fetch employee hire in leap yearJselect last_name, HIRE_DATE FROM EMPLOYEES WHERE MOD(to_char(hire_date,'RRRR'),4)=0;


Q-Write a Oracle SQL query to display employee id, name, department no, salary of the employees. 
The output first based on the employee name in ascending order, 
for unique name department will come in ascending order, 
and for same name and department the highest salary will come first.


SELECT EMP.EMPLOYEE_ID, EMP.FIRST_NAME || ' ' || EMP.LAST_NAME "FULL NAME",
EMP.DEPARTMENT_ID,EMP.SALARY 
FROM EMPLOYEES EMP  ORDER BY 2,3,4; 
(CASE WHEN "FULL NAME"  THEN ORDER BY FIRST_NAME ASC
WHEN DISTINCT "FULL NAME" THEN ORDER BY DEPARTMENT_ID ASC  ELSE END);
SELECT * FROM EMPLOYEES;

Q-Write a Oracle SQL query to display the name and their annual salary. The result should contain those employees first who earning the highest salary.

select emp.first_name,to_char(salary*12,'0,00,000') Annual from employees emp order by Annual desc  ;

Q-Display the employee name and annual salary for all employees.
SELECT CONCAT(CONCAT(EMP.FIRST_NAME ,' '),EMP.LAST_NAME) "EMPLOYEE NAME" ,EMP.SALARY,TRIM(TO_CHAR(SALARY*12,'00,00,000')) "ANNUAL SALARY" FROM EMPLOYEES EMP;

Q-Employees who have joined the company before 07-JUN-2002 or after 03-FEB-2008.
select emp.first_name,emp.hire_date from employees emp where EMP.hire_date >'07-JUN-2002' AND HIRE_DATE<'03-FEB-2008';

Q-Display the current date as <date>th <Month> <Day> <Year>
SELECT SYSDATE(

Q-Find the date for nearest Monday after current date
SELECT NEXT_DAY(SYSDATE,2) FROM DUAL;

Q-Display the date three months Before the current date.
SELECT ADD_MONTHS(SYSDATE,-3) FROM DUAL;

Q-Display the jobs which are unique to department 10.
SELECT DISTINCT EMP.JOB_ID FROM EMPLOYEES EMP WHERE EMP.DEPARTMENT_ID =10; 

Q-Display those employees whose salary is more than 5000 after giving 20%
SELECT EMP.SALARY*1.2 "SALARY" ,EMP.LAST_NAME FROM EMPLOYEES EMP WHERE  (EMP.SALARY*1.2)>5000   ;

Q-Find out the top 5 earners of company?
SELECT * FROM EMPLOYEES ORDER BY SALARY DESC;

Q-Query to dispaly whose salary is ODD value
SELECT EMP.FIRST_NAME ,EMP.SALARY,EMP.LAST_NAME FROM EMPLOYEES EMP WHERE MOD(SUBSTR(SALARY,1,INSTR(SALARY,'0',1,1)-1),2)!=0;

Q-print all employee#ontains "A" without using substr and like
SELECT EMP.* FROM EMPLOYEES EMP WHERE instr(lower(FIRST_NAME),'a',1)>0; 

Q-employee whose 10% of salary is equal to the year of hiredate?

Q-employee who has joined before 15th of the month.


select emp.first_name||' '|| emp.last_name ||' hire on '|| (to_char(emp.hire_date, 'DD "of" MON RRRR'))|| ' with_salary ' ||to_char( emp.salary,'l99999d99')|| ')s working on department '||' '|| department_id from employees emp;





[14:12] Govind Singh
select * from v$nlS_parameters where parameter ='NLS_DATE_FORMAT';

SELECT TO_CHAR(SALARY,'L999999G99D00') FROM EMPLOYEES;

DESC EMPLOYEES

Q-Empoyee <fisrt_name last_name> hire on <date> of THIS <month> <YEAR> WITH SALAR <SALARY $,> AND HE IS WORKING ON DEPARTMET <DEPARTMENT ID >



SELECT initcap('The employee' || rpad(emp.first_name,5,' ')|| ' ' || rpad(emp.last_name,5,' ') || ' is hired on ' || 
to_char(emp.hire_date,'dd') || ' of this ' || rpad(replace(to_char(emp.hire_date,'MON RRRR'),'-',' '),10,' ') || 
' with ' || TRIM(rpad(to_char(emp.salary,'L999G99'),7,' ')) || ' and He is working on deparment ' || rpad(emp.department_id,10,' '))  "Report of Employee" from employees emp;



select 'The employee '||emp.first_name||' '||emp.last_name||' '||to_char(emp.hire_date,' "hired on date -" dd "of month -" mon "of year -" yyyy')
||' '||'with salary' ||to_char(emp.salary,'l99g99g99g999d00')
||' and working on department with ID - '||emp.department_id
from employees emp;


SELECT INITCAP('THIS EMPLOYEE '||RPAD(EMP.FIRST_NAME,10,' ')||' '||RPAD(EMP.LAST_NAME,10,' ')||' HIRE ON '||
TO_CHAR(EMP.HIRE_DATE,'DDTH')||' OF THIS '||RPAD(REPLACE(TO_CHAR(EMP.HIRE_DATE,'MON-RRRR'),'-',' '),10,' ')||
' WITH SALARY '||TRIM(RPAD(TO_CHAR(EMP.SALARY,'L999,999.00'),7,' '))||
' AND HE IS WORKING ON DEPARTMENT '||RPAD(EMP.DEPARTMENT_ID,10,' '))JFROM EMPLOYEES EMP;


select max(salary) from employees;

select emp.first_name from employees emp where replace(emp.first_name,'A','#') != emp.first_name;