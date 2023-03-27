-- waq to find all the employee where name having vowels in it


select * from employees  where lower(first_name)like '%a%' or lower(first_name)like'%e%' or lower(first_name)like '%i%' or lower(first_name)like '%o%' or lower(first_name)like '%u%';


--or


select * from employees
where 1=1 and instr(first_name,'a')<>0
or
instr(first_name,'e')<>0
or
instr(first_name,'i')<>0
or instr(first_name,'0')<>0
or
instr(first_name,'o')<>0
or instr(first_name,'u')<>0;


select to_char(syadate,'rrrr') from dual;

select to_char(sysdate,'rrrr') from dual where mod(to_number(to_char(sysdate,'rrrr')),4)=0;


select first_name,to_char(hire_date,'rrrr') from employees where mod(to_number(to_char(hire_date,'rrrr')),4)=0;

select emp.first_name name,emp.hire_date "leap year" from employees emp where mod(to_char(emp.hire_date,'rrrr'),4)=0;



select emp.hire_date,to_char(emp.hire_date,'rrrr'),count(*) from employees emp group by emp.hire_date;


select emp.hire_date,to_char(emp.hire_date,'RRRR'), count(*) from employees emp group by emp.hire_date;


select substr(first_name,1,1) from employees;

select  substr(first_name,1,1),sum(salary), count(1) from employees  group by substr(first_name,1,1) order by substr(first_name,1,1);

select min(first_name) from employees;

select emp.first_name, sum(emp.salary)"Sum of salary" from employees emp where lower(first_name) like 'a%' group by emp.first_name;



select to_char(emp.hire_date,'RRRR'),to_char(hire_date,'MON'), COUNT(*) from employees emp
group by to_char(emp.hire_date,'RRRR'),to_char(EMP.hire_date,'MON') ;


select to_char(emp.hire_date,'RRRR'),to_char(hire_date,'mm'), count(*) from employees emp group by to_char(emp.hire_date,'rrrr'),to_char(emp.hire_date,'mm');


SELECT   EMP.DEPARTMENT_ID, EMP.MANAGER_ID , COUNT(SALARY), COUNT(*) FROM EMPLOYEES EMP GROUP BY EMP.DEPARTMENT_ID,EMP.MANAGER_ID  ORDER BY 1;


SELECT * FROM REGIONS;
SELECT * FROM EMPLOYEES ;
SELECT * FROM JOB_HISTORY;
SELECT *FROM V$NLS_PARAMETERS;
SELECT * FROM ALL_OBJECTS WHERE OBJECT_TYPE='TABLE';
SELECT *FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE';
SELECT * FROM COUNTRIES;
SELECT *FROM LOCATIONS;
SELECT * FROM DEPARTMENTS;
SELECT *FROM JOBS;
SELECT * FROM 'EMP TEST';
SHOW USER;

DESC EMPLOYEES;
DESCRIBE EMPLOYEES;

DESCRIBE TABLE EMPLOYEES;
DESC TABLE EMPLOYEES;

DESCRIBE HR.EMPLOYEES;
DESC HR.EMPLOYEES;

SELECT * FROM REGIONS;
SELECT COUNT(*) FROM REGIONS;

SELECT REGION_NAME FROM REGIONS;

SELECT country_name, country_id, region_id FROM countries;
SELECT city, location_id,
NVL(state_province,'DELHI'), country_id
FROM locations;

SELECT START_DATE,END_DATE , (END_DATE-START_DATE+1) TOTAL_WORKING_DAYS, (END_DATE-START_DATE+1)*8 TOTAL_HOURS_WORKED FROM JOB_HISTORY;

SELECT Q{ PLUREL'S'} FROM DUAL;


SELECT Q'[ PLUREL'S']'  FROM DUAL;

SELECT ' THE JON IS OF ' || ' ' ||    JOB_ID ||' ' ||  'IS:--'|| JOB_TITLE FROM JOBS; 

SELECT country_name,REGION_ID
FROM countries
WHERE region_id=3;


SELECT last_name, first_name,JOB_ID
FROM employees
WHERE job_id='SA_REP';

SELECT last_name, salary
FROM employees
WHERE salary/10 = department_id*10;

SELECT employee_id, job_id, last_name, first_name
FROM employees
WHERE last_name=first_name;

SELECT last_name
FROM employees
WHERE last_name < 'King';

SELECT *
FROM jobs
WHERE job_id LIKE 'SA_%';

SELECT *
FROM jobs
WHERE job_id LIKE 'SA\_%' ESCAPE '\';
select user_tabs_cons from employees;

select salary ,trunc(salary/1000),rpad(' ',trunc(salary/1000)+1,'*') from employees;


select salary,trunc(salary/1000), substr('****************************************************************************************************************************',1,trunc(salary/1000)) from employees;


select salary,trunc(salary/1000), substr('*****************************************************',1,trunc(salary/1000)) from employees;


select sum(salary) from employees;

select max(salary) from employees; 
select count(department_id), count(*) from employees;
select sum(salary) from employees where department_id =90;
select max (salary)from employees where department_id =90;

 select * from employees where commission_pct is not null;
 select nvl( commission_pct,0) from employees ;
 
 select nvl(commission_pct,0) from employees;--where commission_pct is not null;
 
 select phone_number,instr(phone_number,'.') pos_of_1_dot,substr(phone_number,1,instr(phone_number,'.')-1) regional_code,
 instr(phone_number,'.',1,2) pos_of_second_dot,
 substr(phone_number,instr(phone_number,'.')+1,8) country_code
 , instr( substr(phone_number,instr(phone_number,'.')+1,8),1,4-1) pos_of
 from employees;
 
 
 select instr('rachit.panwar@gmail.com','.',1)  from dual;
 
 select instr('rachit.panwar@gmail.com','@',1)  from dual;
 
 select substr('rachit.panwar@gmail.com',instr('rachit.panwar@gmail.com','.',1)+1 frp, dia;
 
 
 -- mail say first_name last_name and domain_name niklna sikho
 select substr('rachit.panwar@gmail.com',1,instr('rachit.panwar@gmail.com','.',1)-1) first_name,
 substr('rachit.panwar@gmail.com',instr('rachit.panwar@gmail.com','.',1,1)+1,
 instr('rachit.panwar@gmail.com','@',1,1)-1-instr('rachit.panwar@gmail.com','.',1,1)) last_name,
 substr('rachit.panwar@gmail.com',instr('rachit.panwar@gmail.com','@',1,1)+1) domain_name from dual; 
 
 select trim( 0 from '00123400') from dual;
 
 
 select trim ( '*' from '**122333**') from dual;
 
 desc departments;
 
 select * from departments;
 
 desc employees;
 
 select employee_id,last_name , job_id,hire_date  start_date from employees;
 
 select distinct job_id from employees;
 
 select employee_id emp#,first_name employee, job_id job,hire_date from employees;
 select first_name||' ,'||job_id from employees;
 
 select employee_id||' ,'||first_name||' ,'||last_name||','||','||email||phone_number||','||job_id||',,'||hire_date||salary||',,'||department_id the_output from employees;
 
 select last_name , salary from employees where salary>12000;
 select last_name,department_id from employees where employee_id=176;
 select last_name , salary from employees where salary in (5000,12000);
 select last_name,job_id,hire_date from employees where lower(last_name) like 'matos' or lower(last_name) like 'taylor';
 
 select last_name ,department_id from employees where  department_id in(20,50);
 
 select last_name employee ,salary monthly_salary from employees where salary between 5000 and 12000 and department_id in(20,50);
 
 select last_name,hire_date from employees where to_char(hire_date,'rr')='06';
 
 select last_name , job_id from employees where manager_id is null;
 select last_name,salary,commission_pct from employees where commission_pct is not null;
 
 
 select last_name , salary from employees where salary>&salary;
 
 select * from employees where salary>&salary;
 
 select employee_id,last_name,salary,department_id from employees where &manager_id=manager_id order by last_name;
 
 select last_name from employees where last_name like '__a%';
 
 select last_name from employees where last_name like '%a%' and last_name like '%e%';
 
 select last_name ,job_id,salary from employees where salary!=2500 or salary!=7000 and job_id in('SA_REP','ST_CLERK'); 
 
 select last_name employee , salary monthly_salary, commission_pct from employees where commission_pct=0.2;
 
  select sysdate as "date" from dual;
  
  select employee_id , last_name ,salary,salary*.15 from employees;
  select employee_id, last_name,salary,salary+(salary*.15) new_salary , ((salary*.15))-salary salary_inc from employees;
  
  select initcap(first_name ), length(last_name) from employees where upper(last_name) like 'J' or upper(last_name) like 'A'  or upper(last_name) like 'M';
  select last_name,to_number(months_between(sysdate,hire_date)/12) from employees;
  
  select first_name from employees where  instr(first_name,'e',-2)=1;
  select lpad(salary ,15,'$') from employees;
  select first_name , trunc(salary/1000),rpad(' ',trunc(salary/1000)+1,'*') from employees where length(last_name)=8;
  
  select first_name||' '||LAST_NAME||'earns'||to_char(salary,'L999G999D99')||'monthly burt want '||to_CHAR(SALARY*3,'L999G999D99')  DREAM_SALARIES FROM EMPLOYEES;
  select first_name from employees where instr(first_name,'e',-2,1)=length(first_name)-1;
  SELECT TO_CHAR(ADD_MONTHS(SYSDATE,6),'MM') FROM DUAL;
  SELECT LAST_NAME , HIRE_DATE , T0_CHAR(ADD_MONTHS(HIRE_DATE,6),'DDSPTH') FROM EMPLOYEES;
  
  SELECT LAST_NAME, HIRE_DATE, TO_CHAR(NEXT_DAY(ADD_MONTHS(HIRE_DATE,6),'MONDAY'),'DDSPTH'),TO_CHAR(TO_CHAR(NEXT_DAY(ADD_MONTHS(HIRE_DATE,6),'MONDAY')||', THE','DDSPTH'||'OF'||',RRRR'),||', ||'YEAR')  FROM EMPLOYEES;
  
  SELECT LAST_NAME,HIRE_DATE,TO_CHAR(TO_CHAR(NEXT_DAY(ADD_MONTHS(HIRE_DATE,6),'MONDAY')||', THE','DDSPTH'||'OF'||',RRRR'),||', ||'YEAR') FROM EMPLOYEES;
  select emp.last_name, emp.hire_date, to_char(hire_date,'fmDay'||','||'fmddspth'||','||'fmRRRR') from employees emp;
  
  SELECT LAST_NAME , NVL(TO_cHAR(COMMISSION_PCT),'NO COMMISSION') COMM FROM EMPLOYEES ;
  
  SELECT JOB_ID, DECODE(JOB_ID,'AD_PRES','A','ST_MAN','B','IT_PROG','C','SA_REP','D','ST_CLERK','E','0') FROM EMPLOYEES;
  
  SELECT last_name, hire_date,TO_CHAR(hire_date, 'DAY') DAY, to_char(hire_date,'d'),to_char(hire_date,'day')
FROM employees
ORDER BY TO_CHAR(hire_date, 'd');

SELECT SUM(SALARY), MIN(SALARY),MAX(SALARY), ROUND(AVG(SALARY),2) FROM EMPLOYEES;

SELECT TO_CHAR(HIRE_DATE,'CC') FROM EMPLOYEES;

SELECT JOB_ID, SUM(SALARY), MIN(SALARY),MAX(SALARY), ROUND(AVG(SALARY),2) FROM EMPLOYEES GROUP BY JOB_ID;
SELECT JOB_ID,COUNT(JOB_ID) FROM EMPLOYEES GROUP BY JOB_ID;

SELECT &JOB_ID,COUNT(*) FROM EMPLOYEES WHERE &JOB_ID=JOB_ID;

SELECT * FROM DEPARTMENTS 

CREATE TABLE ETEST( EMPID NUMBER, NAME VARCHAR2(40), 
SALARY  VARCHAR2(20),JOB_ID VARCHAR2(20), DEPT_ID VARCHAR2(30) );
 INSERT INTO ETEST VALUES( 1,'A',5000,'JB1',101);
 
 INSERT INTO ETEST VALUES( 2,'B',6000,'JB2',102);
 INSERT INTO ETEST VALUES( 3,'C',7000,'JB3',103);
 INSERT INTO ETEST VALUES( 4,'D',8000,'JB4',104);
 DROP TABLE ETEST;
 CREATE TABLE DEP(
   DEPT_ID VARCHAR2(30),NAM VARCHAR2(20));
   
   INSERT INTO DEP
   VALUES (101,'CS');
   
   
   INSERT INTO DEP
   VALUES (102,'ME');
   
   
   INSERT INTO DEP
   VALUES(101,'BCA');
   INSERT INTO DEP
   VALUES (103,'EE');
   
   INSERT INTO DEP
   VALUES (104,'MCA');
   DROP TABLE DEP;
   CREATE TABLE JB(JOB_ID VARCHAR2(20),JOB_NAME VARCHAR2(20));
   
   INSERT INTO JB VALUES('JB1','MANAGER');
   
   INSERT INTO JB VALUES('JB2','ST_CLAEK');
   
   
   INSERT INTO JB VALUES('JB3','IT_PROG');
   
   INSERT INTO JB VALUES('JB4','CP');
   
   DROP TABLE JB;
   COMMIT;
   SELECT * FROM JB;
   SELECT * FROM ETEST;
   SELECT *FROM DEP;
   
   ROLLBACK;
   
   SELECT EMPID,E.NAME,E.SALARY,D.DEPT_ID,D.NAM FROM ETEST E,DEP D WHERE E.DEPT_ID=D.DEPT_ID;
   
    SELECT EMPID,E.NAME,E.SALARY,D.DEPT_ID,D.NAM FROM ETEST E,DEP D;  -- CROSS JOIN
    
      SELECT EMPID,E.NAME,E.SALARY,D.DEPT_ID,D.NAM FROM ETEST E,DEP D WHERE E.DEPT_ID=D.DEPT_ID AND E.DEPT_ID=101;
      SELECT EMPID,E.NAME,E.SALARY,D.DEPT_ID,D.NAM FROM ETEST E,DEP D WHERE( E.DEPT_ID=D.DEPT_ID OR E.DEPT_ID=101); 

      SELECT EMPID,E.NAME,E.SALARY,D.DEPT_ID,D.NAM FROM ETEST E,DEP D 
      WHERE( E.DEPT_ID=D.DEPT_ID OR D.DEPT_ID=101);
      
      SELECT * FROM ETEST;
      SELECT * FROM DEP;
      
      
      select * from employees;
      select * from departments;
      
       select emp.first_name,d.department_id from employees emp, departments d where emp.department_id=d.department_id;
      
       select emp.*,d.department_id from employees emp, departments d where emp.department_id=d.department_id;
      
        
       select emp.*,d.department_id from employees emp, departments d where d.department_id(+)=emp.department_id;
       select emp.*,d.department_id from employees emp, departments d where emp.department_id=d.department_id(+);
       
       select * from departments;
       
       select *from locations;
       
       
       select  * from employees emp, departments d where emp.department_id(+)=d.department_id;
       
       
       select  * from employees emp, departments d where emp.department_id(+)=d.department_id; 
       
       select emp.first_name,d.department_id,j.job_id from employees emp, departments d , jobs j where emp.department_id= d.department_id and emp.job_id=j.job_id;
       
       select emp.first_name,d.department_id,l.location_id from employees emp, departments d , locations l where emp.department_id= d.department_id and d.location_id=l.location_id;
       
           select * from job_history  order by employee_id;
           
           select emp.employee_id,emp.hire_date,j.* from employees emp, job_history j where emp.job_id=j.job_id order by emp.employee_id;
           
            select department_id,count(*) from employees group by department_id;
              
              select * from departments;
              select * from employees;
              select * from jobs;
            select emp.department_id,count(*), d.department_name,j.job_title from employees emp, departments d , jobs j where emp.department_id= d.department_id  and emp.job_id=j.job_id group by emp.department_id,d.department_name;
             
              select emp.job_id,count(*),d.department_id,d.department_name, j.job_title from employees emp,departments d, jobs j where emp.department_id=d.department_id  and emp.job_id=j.job_id group by emp.job_id,d.department_id,d.department_name, j.job_title;
              
              begin 
              dbms_output.put_line('hello world');
              end;
              
              declare
              mystr varchar2(20);
              begin
              mystr:='hello oracle world';
              dbms_output.put_line(mystr);
              end;
              
              declare  
              n varchar(20);
              m number;
              begin
              n:= 10;
              m:=20;
              dbms_output.put_line('sum is '||(n+m));
              end;
              
              declare
              n number:=10;
              begin 
              for i in 1..20 loop
              dbms_output.put_line(i);
              end loop;
              end;
              
              select first_name from employees;
              
               select first_name from employees where substr(lower(first_name),1, length(first_name))='a';
               
               begin
               for i in 1..5 loop
               for j in 1..i loop
               dbms_output.put_line('*');
               end loop;
               dbms_output.put_line(' ');
               end loop;
               end;
               
               select * from employees;
         select manager_id ,min(salary) from employees where manager_id is not null group by manager_id, salary having salary>6000 order by salary; 
         
         select  count(*), case when to_char(hire_date,'rrrr')=2005 then cont(*) 
         when to_char(hire_date'rrrr')=2006 then count(*) when to_char(hire_date,'rrrr')='2007' then count(*) from employees;
         
         
         select to_char(hire_date,'rrrr'), first_name,employee_id  from employees group by  to_char(hire_date,'rrrr'),first_name,employee_id order by to_char(hire_date,'rrrr'); 
         select trim(replace(first_name,' ','li')) from employees;
          
         
         select distinct first_name from employees where substr(first_name,1,1)in('a','e','i','o','u') and substr(first_name,-1,1)in('a','e','i','o','u');
         
          select  e.first_name,m.first_name
          from employees e , employees m
          where e.employee_id=m.manager_id;
          
          
          select *from departments;
          
          select * from user_cons_columns where lower(table_name)='departments';
           
           select * from user_constraints where lower(table_name)='departments';
           
            SELECT * FROM EMPLOYEES;
          SELECT * FROM JOBS;
          SELECT *FROM DEPARTMENTS;
          
          SELECT * FROM ALL_OBJECTS WHERE OBJECT_TYPE='TABLE';
          
          SELECT * FROM JOB_HISTORY;
          
          SELECT M.FIRST_NAME,E.MANAGER_ID , COUNT(E.MANAGER_ID) FROM EMPLOYEES E,EMPLOYEES M WHERE E.EMPLOYEE_ID = M.MANAGER_ID  GROUP BY M.FIRST_NAME,E.MANAGER_ID ORDER BY 1;
          
          
          SELECT MANAGER_ID , COUNT(EMPLOYEE_ID) FROM EMPLOYEES GROUP BY MANAGER_ID ORDER BY 1;
          
          SELECT E.MANAGER_ID, COUNT(E.EMPLOYEE_ID)   MANAGERS_COUNT,M.FIRST_NAME  MANAGER_NAME FROM EMPLOYEES E , EMPLOYEES M WHERE E.MANAGER_ID=M.EMPLOYEE_ID GROUP BY E.MANAGER_ID,M.FIRST_NAME  ORDER BY 1;
          
            SELECT *FROM EMPLOYEES;
            
            -- COUNT EMPLOYEE  FROM MANAGER ANBD WRITE MANAGER NAME AS WELL
             SELECT E.MANAGER_ID, COUNT(E.EMPLOYEE_ID)   MANAGERS_COUNT,M.FIRST_NAME  MANAGER_NAME FROM EMPLOYEES E , EMPLOYEES M WHERE E.MANAGER_ID=M.EMPLOYEE_ID GROUP BY E.MANAGER_ID,M.FIRST_NAME  ORDER BY 1;
        
         -- MANAGER NAME OF  MANAGER NAME
         
         
         SELECT E.FIRST_NAME,M.FIRST_NAME,R.FIRST_NAME
         FROM EMPLOYEES E,EMPLOYEES M, EMPLOYEES R
         WHERE
         E.MANAGER_ID=M.EMPLOYEE_ID
         AND M.MANAGER_ID=R.EMPLOYEE_ID
         ;
         
         
         
            
            
            