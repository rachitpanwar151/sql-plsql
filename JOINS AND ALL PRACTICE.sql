select first_name,department_id from employees order by first_name asc,department_id desc
;
select instr(first_name,'a') ,first_name from employees 
where lower(first_name) = 'adam'
order by first_name;

select * from employees where instr(first_name,'h',length(first_name))=6;
select * from employees where first_name like '%h'; 

select first_name,salary from employees where instr(salary,'0',1)=length(salary)-3;

select first_name ,salary ,substr(first_name,1,instr(salary,'0',1))-1 from employees;
where length(substr(first_name,1,instr(salary,'0',1))-1)=2;
select salary,last_name from employees where ;
select * from employees where first_name like '%a%';

select substr(salary,1,instr(salary,'0',1))-1,last_name from employees where
length(substr(salary,1,instr(salary,'0',1))-1)>=3;
select * from employees where (length(salary)-length(replace(salary,'0',''))>=2) and
length(replace (salary,'0',''))=3;


select * from employees where (length(Salary)-length(replace(salary,'0',''))>=2) and length(replace(salary,'0',''))=3;

select * from employees where (length(first_name)-length(replace(first_name,'a',''))=4);

select first_name,length(first_Name)-length(replace(first_name,'n','')) from employees;;
select substr(salary,1,instr(salary,'0',1))-1 from employees;
select first_name||last_name,length(first_name||last_name) - length(replace(first_name||last_name,'n','')) as count_n from employees;

select rpad(first_name,5,' ')|| ' ' ||
lpad(last_name,5,' ')||' is ' || rpad( salary,5,' ') ||' and have experience ' ||  trunc(to_char(sysdate-hire_date)/365) "Report " 
from employees order by trunc(to_char(sysdate-hire_date)/365) desc;



select count(*),sum(case when to_char(hire_date,'rrrr')='2001' then 1 else 0
end ) "2001",
sum(case when to_char(hire_date ,'RRRR')='2002' then 1 else 0 end) "2002",
sum(case when to_char(hire_date,'RRRR')='2003' then 1 else 0 end) "2003",
sum(case when to_char(hire_Date,'RRRR')='2004' then 1 else 0 end)"2004"
from employees;

select count(*) from employees group by department_id;

select job_id,sum(case department_id when 20 then salary else null end) "Dept 20",
sum(case department_id when 50 then salary else null end )"Dept 50",
sum(case department_id when 80 then salary else null end) "Dept 80",
sum(case department_id when 90 then salary else null end) "Dept 90"
,sum( salary) from employees group by job_id;

SELECT location_id, street_address, city, state_province,
country_name
FROM locations
NATURAL JOIN countries;
select * from countries;
select * from locations;


select ceil(7.8) ,ceil(7.1) ,ceil(8) from dual ;
select floor(7.8) , trunc(7.3) from dual;


select department_id ,job_id ,  sum(salary) , listagg(first_name || ' '||last_name ,' | ') name_included
                   --       within group (order by first_name) 
from employees
group by department_id , job_id
order by department_id --desc nulls last
;
select department_id,sum(salary),listagg(first_name || ' ' || last_name || ' sal='||salary,' | ') name_includeed 
from employees group by department_id order by name_includeed;


WAQ that produces the output in 3 columns weight,kg and grams.
Take a prompt from user to enter the weight and distribute the weight in 3 respective column?
select &Weight WG,'WG/1000'  kg from dual;

SELECT &WEIGTH WG , &WEIGTH/1000||' '|| 'KG' KG,TRUNC(trunc(substr(&&weight/1000,instr(&&weight/1000,'.',1,1)),3))||' '||'gram' as gm from duaL;
SET DEFINE O

select ((length(substr(salary,1,instr(salary,'0',1))))
-(length(substr(salary,instr(salary,'0',1))+1))) "highest zero"
from employees ;

select (length(replace(salary,'0',''))) from employees order by salary;
select SALARY,length(substr(salary,1,instr(salary,'0',1)-1))-length(replace(salary,'0','')) from employees;

SELECT SALARY,LENGTH(SALARY)-LENGTH(REPLACE (SALARY,'0','')) FROM EMPLOYEES;

select max(salary),MAX(length(salary)-length(replace(salary,'0',''))) 
gm from employees where (length(salary)-length(replace(Salary,'0','')))=3;

SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE DEPARTMENT_ID>60 AND DEPARTMENT_ID <100;

select max(salary) from employees;



select max(length(salary)-length(replace(salary,'0',''))) as  
"maximum no of zeroes" ,max(salary) as "salary with greatest no of zeroes "from employees 
where (length(salary)-length(replace(Salary,'0','')))=(select max(length(salary)-length(replace(salary,'0',''))) from employees) ;

select length(salary) - length(replace(salary,0,'')) l , max(salary) s from employees group by (length(salary) - length(replace(salary,0,''))) 
order by l desc fetch first row only;

select max(length(salary)-length(replace(salary,'0',''))) from employees ;
select * from employees where salary
select salary from employees 
group by salary having max;

select max(salary) from employees where (length(salary)-length(replace(Salary,'0','')))=4;

select replace(salary,'0','') from employees;

SELECT &WEIGHT,&WEIGHT/1000 KG ,TRUNC(SUBSTR(&WEIGHT/1000,INSTR(&WEIGHT/1000,'.',1),3)) AS GM FROM DUAL;

select salary , max(instr(salary,'0',1)+1) from employees group by salary;
SELECT FIRST_NAME||' '||LAST_NAME AS "FULLNAME",
SUBSTR(FIRST_NAME||' '||LAST_NAME,1,INSTR(FIRST_NAME||' '||LAST_NAME,' ',1)-1)FROM EMPLOYEES;


select case when count(first_name)=count(distinct firsT_name) then first_name 
else first_name end
from employees group by first_name order by first_name;
;

select first_name,count(first_name) from employees 
group by first_name having count(first_name)<=1;
select * from employees order by first_name;

select first_name,count(first_name) from employees group by first_name having count(first_name) <=1;

select distinct first_name from employees;

create table somildb (id number ,first_name varchar2(20)
                     );
                     alter table somildb
                     modify first_name number(10);
                     
                     insert into somildb values(12,12);
                     select * from somildb;
                     drop table somildb;
                    
SELECT MAX(SALARY),CASE WHEN MAX(SALARY)=COUNT(*) THEN COUNT(MAX(SALARY))
else end
FROM EMPLOYEES
GROUP BY SALARY;

select distinct department_id,first_name,last_name  from employees ;
select  first_name ,last_name,department_id from employees 
group by first_name ,last_name,department_id;

select (case when first_name = count(first_name) then firsT_name
when last_name=count(last_name) then last_name
when department_id =count(department_id) then department_id end) 
from employees;
select first_name,last_name,listagg(first_name||' ' ||last_name,'|') within group(order by department_id)
from employees
group by department_id;
select * from  user_objects where user ='Lex';

SELECT  * FROM EMPLOYEES ORDER BY SALARY DESC;
HAVING MAX(SALARY)=COUNT(FIRST_NAME);
MAX(SALARY)=(SELECT MAX(SALARY) FROM EMPLOYEES) ;


SELECT EMP.LAST_NAME,EMP.JOB_ID,EMP.HIRE_DATE,EMP.EMPLOYEE_ID FROM EMPLOYEES EMP;

SELECT DISTINCT EMP.* FROM EMPLOYEES EMP;

SELECT EMP.EMPLOYEE_ID "EMP_ID",EMP.LAST_NAME "NAME",EMP.JOB_ID "JOB_OID" 
FROM EMPLOYEES EMP;

SELECT EMP.*,EMP.JOB_ID  FROM EMPLOYEES EMP; 
SELECT EMP.EMPLOYEE_ID || ', ' || EMP.FIRST_NAME||', '|| EMP.LAST_NAME||', '||EMP.EMAIL||', '||EMP.PHONE_NUMBER
||', '||EMP.JOB_ID||', '||EMP.MANAGER_ID ||', '||EMP.HIRE_DATE||', '||EMP.SALARY|| EMP.COMMISSION_PCT||', '||DEPARTMENT_ID "THE OUTPUT" 
FROM EMPLOYEES EMP;

SELECT EMP.LAST_NAME,EMP.SALARY FROM EMPLOYEES EMP WHERE EMP.SALARY>12000;

SELECT EMP.LAST_NAME ,EMP.DEPARTMENT_ID FROM EMPLOYEES EMP 
WHERE EMPLOYEE_ID=176;

SELECT EMP.* FROM EMPLOYEES EMP ORDER BY EMP.SALARY DESC;

SELECT * FROM EMPLOYEES WHERE SALARY NOT BETWEEN 5000 AND 12000;
SELECT EMP.LAST_NAME,EMP.JOB_ID,EMP.HIRE_DATE FROM EMPLOYEES EMP
WHERE UPPER(EMP.LAST_NAME) IN ('MATOS','TAYLOR') ORDER BY EMP.HIRE_DATE;


SELECT EMP.LAST_NAME ,EMP.DEPARTMENT_ID FROM EMPLOYEES EMP WHERE DEPARTMENT_ID IN (20,50);


SELECT EMP.LAST_NAME,EMP.SALARY FROM EMPLOYEES EMP
 WHERE EMP.SALARY BETWEEN 5000 AND 12000;
 
 
SELECT EMP.LAST_NAME,EMP.HIRE_DATE FROM EMPLOYEES EMP
WHERE TO_CHAR(HIRE_DATE,'RRRR') = '2005';


SELECT EMP.LAST_NAME,EMP.JOB_ID FROM EMPLOYEES EMP
WHERE MANAGER_ID IS NULL;


SELECT EMP.LAST_NAME,EMP.SALARY,EMP.COMMISSION_PCT FROM EMPLOYEES EMP
WHERE EMP.COMMISSION_PCT IS NOT NULL ORDER BY EMP.SALARY, EMP.COMMISSION_PCT;


SELECT EMP.LAST_NAME ,EMP.SALARY FROM EMPLOYEES EMP 
WHERE EMP.SALARY>&LIMIT_SALARY;


SELECT EMP.LAST_NAME FROM EMPLOYEES EMP WHERE UPPER(EMP.LAST_NAME) LIKE '__A%';


SELECT EMP.EMPLOYEE_ID,EMP.LAST_NAME,EMP.SALARY,EMP.DEPARTMENT_ID FROM EMPLOYEES EMP
WHERE EMPLOYEE_ID=&EMPLOYYE_ID;

SELECT EMP.LAST_NAME 
FROM EMPLOYEES EMP WHERE UPPER(EMP.LAST_NAME) LIKE '__A%';

SELECT EMP.* FROM EMPLOYEES EMP WHERE UPPER(EMP.LAST_NAME) LIKE '%A%' AND UPPER(EMP.LAST_NAME) LIKE '%E%';
UPPER(EMP.LAST_NAME)


SELECT EMP.LAST_NAME,EMP.JOB_ID,EMP.SALARY FROM EMPLOYEES EMP
WHERE EMP.SALARY!=2500 AND EMP.SALARY!=3500 AND EMP.SALARY!=7000;

SELECT EMP.LAST_NAME ,EMP.COMMISSION_PCT,EMP.SALARY FROM EMPLOYEES EMP
WHERE EMP.COMMISSION_PCT=0.20;


SELECT EMP.EMPLOYEE_ID,EMP.LAST_NAME,EMP.SALARY,(EMP.SALARY*1.55) NEW_SALARY
FROM EMPLOYEES EMP;

SELECT EMP.EMPLOYEE_ID,EMP.SALARY,EMP.SALARY,((EMP.SALARY*1.55)-EMP.SALARY) "SUB_SALARY"
FROM EMPLOYEES EMP;


SELECT INITCAP(EMP.LAST_NAME ),LENGTH(EMP.LAST_NAME) 
FROM EMPLOYEES EMP
WHERE UPPER(EMP.LAST_NAME) LIKE 'J%' OR 
UPPER(EMP.LAST_NAME) LIKE 'A%' OR \
UPPER(EMP.LAST_NAME) LIKE 'M%';


SELECT EMP.LAST_NAME,EMP.SALARY ,ROUND((SYSDATE-HIRE_DATE)/365) 
FROM EMPLOYEES EMP;

SELECT EMP.LAST_NAME ,EMP.SALARY FROM EMPLOYEES EMP;

SELECT EMP.LAST_NAME ,LPAD(EMP.SALARY,10,'$') FROM EMPLOYEES EMP;

SELECT EMP.LAST_NAME||' ' || RPAD(' ',SALARY/1000,'*') FROM EMPLOYEES EMP;


SELECT EMP.LAST_NAME,TRUNC((SYSDATE-EMP.HIRE_DATE)/7) TENURE FROM EMPLOYEES EMP 
WHERE DEPARTMENT_ID=90
ORDER BY TENURE DESC;


SELECT  RPAD(EMP.FIRST_NAME,5,' ')||' '||RPAD(EMP.LAST_NAME,5,' ') ||' '|| RPAD(EMP.SALARY,5,' ') ||' MONTHLY '|| 'BUT WANTS ' ||3*EMP.SALARY
FROM EMPLOYEES EMP;


SELECT EMP.LAST_NAME,EMP.HIRE_DATE, 
TO_CHAR(NEXT_DAY(ADD_MONTHS(HIRE_DATE,6),'MONDAY'),'FMDAY,"THE" DDSPTH "OF" MONTH,YEAR') 
FROM EMPLOYEES EMP;
SELECT last_name, hire_date,
 TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date, 6),'MONDAY'),
 'fmDay, "the" Ddspth "of" Month, YYYY') REVIEW
FROM employees;


SELECT EMP.HIRE_DATE,EMP.LAST_NAME,TO_CHAR(HIRE_DATE,'DAY') FROM EMPLOYEES EMP;

SELECT SYSDATE-1 FROM DUAL;

SELECT EMP.HIRE_DATE,EMP.LAST_NAME,TO_CHAR(HIRE_DATE,'DAY') FROM EMPLOYEES EMP
ORDER BY TO_CHAR(HIRE_DATE-1,'D');
SELECT EMP.LAST_NAME,NVL(TO_CHAR(COMMISSION_PCT),'NO COMMISSION_PCT') FROM EMPLOYEES EMP;

SELECT LAST_NAME,CASE JOB_ID WHEN 'AD_PRES' THEN 'A'
                   WHEN 'ST_PRES' THEN 'B'
				   WHEN 'IT_PROG' THEN 'C'
				   WHEN 'SA_REP' THEN 'D'
				   WHEN 'ST_CLERK' THEN 'E'
        ELSE 'NONE OF THESE ABOVE 0' END
FROM EMPLOYEES; 


SELECT * FROM ALL_OBJECTS WHERE UPPER(OBJECT_NAME)='DEPARTMENTS';
SELECT * FROM ALL_OBJECTS;
SELECT * FROM DEPARTMENTS;

SELECT * FROM ALL_OBJECTS WHERE UPPER(OBJECT_TYPE) LIKE '%USER\_CONS\_COLUMNS%' ESCAPE '\';

USER_CONS_CONSTRINTS
USER_CONS_COLUMNS
USER_OBJECTS
USER_TAB_COLUMNS
SELECT * FROM ALL_OBJECTS WHERE UPPER(OBJECT_NAME) LIKE 'DEPT%' AND UPPER(OBJECT_TYPE) LIKE 'TABLE%';
SELECT * FROM ALL_OBJECTS WHERE UPPER (OBJECT_NAME )LIKE 'EMPLO%' AND UPPER(OBJECT_TYPE) LIKE 'TABLE%';
SELECT * FROM ALL_OBJECTS WHERE OBJECT_NAME LIKE 'EMP%';
SELECT * FROM USER_CONS_COLUMNS WHERE UPPER(TABLE_NAME)='DEPARTMENTS' ;
AND UPPER(OBJECTS_TYPE)='DEPT%';

SELECT * FROM ALL_OBJECTS WHERE UPPER(OBJECT_NAME) LIKE 'USER\_CONS%' ESCAPE '\';

SELECT * FROM ALL_TAB_COLUMNS WHERE UPPER(OBJECT_NAME)LIKE 'EMPLOYEES%';
SELECT * FROM DEPARTMENTS;


SELECT EMPLOYEE_ID,EMP.FIRST_NAME||' ' || EMP.LAST_NAME,EMP.SALARY,DEP.DEPARTMENT_ID,DEPARTMENT_NAME 
FROM EMPLOYEES EMP ,DEPARTMENTS DEP
WHERE 1=1 ORDER BY EMPLOYEE_ID;
SELECT * FROM DEPARTMENTS;
SELECT JOB_ID FROM EMPLOYEES;
SELECT * FROM JOBS;
SELECT EMP.EMPLOYEE_ID,EMP.FIRST_NAME|| ' '|| EMP.LAST_NAME, EMP.SALARY,EMP.JOB_ID,J.JOB_TITLE 
FROM EMPLOYEES EMP, DEPARTMENTS DEP,JOBS J
WHERE EMP.DEPARTMENT_ID=DEP.DEPARTMENT_ID AND EMP.JOB_ID=J.JOB_ID AND EMP.DEPARTMENT_ID IN (10,20);


CREATE TABLE EMP1( EMPLOYEE_ID NUMBER,
                    FULL_NAME VARCHAR2(200),
                    DEPARTMENT_ID NUMBER,
                    SALARY NUMBER
                    );
                    
CREATE TABLE EMP2( DEPARTMENT_ID NUMBER,
                   NAME VARCHAR(20)
                   );
                   
INSERT INTO EMP1 VALUES( 1,'A',10,100);
INSERT INTO EMP1 VALUES( 2,'B',20,200);
INSERT INTO EMP1 VALUES( 3,'C',30,300);
INSERT INTO EMP1 VALUES( 4,'D',40,400);
COMMIT;
SELECT * FROM EMP1;
INSERT INTO EMP2 VALUES( 10,'A');
INSERT INTO EMP2 VALUES( 20,'B');
INSERT INTO EMP2 VALUES( 30,'C');
INSERT INTO EMP2 VALUES( 40,'D');
SELECT * FROM EMP2;
DELETE FROM EMP2 WHERE DEPARTMENT_ID=40;
COMMIT;


SELECT E1.EMPLOYEE_ID,E1.FULL_NAME,E1.DEPARTMENT_ID,E2.DEPARTMENT_ID 
FROM EMP1 E1,EMP2 E2
WHERE E1.DEPARTMENT_ID=E2.DEPARTMENT_ID;

SELECT * FROM LOCATIONS;
SELECT * FROM DEPARTMENTS;
SELECT * FROM DEPARTMENTS DEP,LOCATIONS LOC 
WHERE DEP.LOCATION_ID=LOC.LOCATION_ID;


SELECT * FROM JOBS;
SELECT * FROM DEPARTMENTS;
SELECT * FROM LOCATIONS;
SELECT * FROM COUNTRIES;
SELECT * FROM REGIONS;

SELECT EMP.EMPLOYEE_ID,EMP.FIRST_NAME,EMP.LAST_NAME,
       J.JOB_ID,J.JOB_TITLE,
       DEPT.DEPARTMENT_ID,DEPT.DEPARTMENT_NAME,
       LOC.LOCATION_ID ||' '|| LOC.STREET_ADDRESS||' ' ||' ' ||LOC.CITY||' ' ||LOC.STATE_PROVINCE||' '||LOC.POSTAL_CODE "ADDRESS_LOCATION",
       C.COUNTRY_ID,
       R.REGION_NAME
       FROM EMPLOYEES EMP,
            JOBS J,
            DEPARTMENTS DEPT ,
            LOCATIONS LOC,
            COUNTRIES C,
            REGIONS R
       WHERE EMP.JOB_ID=J.JOB_ID AND 
       DEPT.LOCATION_ID=LOC.LOCATION_ID AND 
       EMP.DEPARTMENT_ID=DEPT.DEPARTMENT_ID AND 
       LOC.COUNTRY_ID=C.COUNTRY_ID AND
       C.REGION_ID=R.REGION_ID
       ;
       

SELECT * FROM ALL_OBJECTS WHERE  OBJECT_NAME LIKE 'REG%';
       
       SELECT * FROM JOB_HISTORY;
SELECT EMPLOYEE_ID,COUNT('J.END_DATE') FROM EMPLOYEES E ,JOB_HISTORY J  WHERE E.EMPLOYEE_ID=J.EMPLOYEE_ID GROUP BY J.EMPLOYEE_ID;
       
       
       
SELECT EMP.*,EMP.DEPARTMENT_ID,DEPT.DEPARTMENT_NAME 
FROM  EMPLOYEES EMP, DEPARTMENTS DEPT
WHERE EMP.DEPARTMENT_ID=DEPT.DEPARTMENT_ID;
--ORDER BY DEPARTMENT_ID;

SELECT EMP.* FROM EMPLOYEES EMP,DEPARTMENTS DEPT
WHERE EMP.DEPARTMENT_ID=DEPT.DEPARTMENT_ID;
SELECT EMP.JOB_ID FROM EMPLOYEES EMP;
SELECT * FROM DEPARTMENTS;
SELECT COUNT(*),EMP.JOB_ID,DEPT.DEPARTMENT_ID,DEPT.DEPARTMENT_NAME,J.JOB_TITLE FROM EMPLOYEES EMP ,DEPARTMENTS DEPT,JOBS J
WHERE EMP.DEPARTMENT_ID=DEPT.DEPARTMENT_ID
AND EMP.JOB_ID=J.JOB_ID
GROUP BY EMP.JOB_ID,DEPT.DEPARTMENT_ID,DEPT.DEPARTMENT_NAME,J.JOB_TITLE
ORDER BY EMP.DEPTARMENT_ID;

SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID =10;

SELECT DEPT.DEPARTMENT_ID,DEPT.DEPARTMENT_NAME,EMP.JOB_ID,J.JOB_TITLE,COUNT(EMP.JOB_ID) "NO. OF JOBS"
FROM EMPLOYEES EMP,DEPARTMENTS DEPT,JOBS J
WHERE EMP.DEPARTMENT_ID=DEPT.DEPARTMENT_ID AND EMP.JOB_ID=J.JOB_ID
GROUP BY DEPT.DEPARTMENT_ID,DEPT.DEPARTMENT_NAME,EMP.JOB_ID,J.JOB_TITLE
ORDER BY EMP.DEPARTMENT_ID;

SELECT DEPT.DEPARTMENT_ID ,EMP.JOB_ID,J.JOB_TITLE,TO_CHAR(EMP.HIRE_DATE,'RRRR') "YEAR",COUNT(*) "NO. OF EMP"
FROM EMPLOYEES EMP ,DEPARTMENTS DEPT,JOBS J
WHERE EMP.DEPARTMENT_ID=DEPT.DEPARTMENT_ID
AND EMP.JOB_ID=J.JOB_ID
AND DEPT.DEPARTMENT_ID = 50
AND EMP.JOB_ID='ST_CLERK'
GROUP BY DEPT.DEPARTMENT_ID,EMP.JOB_ID,TO_CHAR(EMP.HIRE_DATE,'RRRR'),J.JOB_TITLE 
ORDER BY 4;
SELECT DEPT.DEPARTMENT_ID,EMP.JOB_ID ,DEPT.JOB_TITLE ;

SELECT TRIM(TRAILING 'W' FROM 'ELHLOWORLDH') FROM DUAL;
SELECT TRIM (TRAILING 'B' FROM REPLACE('SHUBHAMB','B','')) FROM DUAL;
SELECT REPLACE('SOMIL','M','J') FROM DUAL;

SELECT DEPARTMENT_ID , TO_CHAR(HIRE_DATE,'RRRR') , JOB_ID FROM EMPLOYEES WHERE DEPARTMENT_ID = 50 
ORDER BY 2 , 3
;

select d.department_id as department_id;
,d.department_name as department_name
,j.job_id as job
,j.job_title as job_title
,to_char(hire_date,'RRRR') as year 
,count(*) as total
from 
employees e
,jobs j
,departments d
where e.job_id = j.job_id 
and e.department_id = d.department_id
group by d.department_id,j.job_id
,to_char(hire_date,'RRRR')
,j.job_title
,d.department_name order by department_id;


SELECT * FROM JOB_HISTORY;
SELECT COUNT(*) FROM JOB_HISTORY GROUP BY EMPLOYEE_ID;
SELECT COUNT(*),J.EMPLOYEE_ID,EMP.FIRST_NAME 
FROM JOB_HISTORY J,EMPLOYEES EMP
WHERE J.EMPLOYEE_ID=EMP.EMPLOYEE_ID
GROUP BY J.EMPLOYEE_ID,EMP.FIRST_NAME;



SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='EMPLOYEES';
SELECT * FROM EMPLOYEES;
SELECT COUNT(*) FROM DEPARTMENTS;

SELECT COUNT(*) FROM EMPLOYEES EMP, DEPARTMENTS DEPT;
SELECT (106*27)FROM DUAL;

--WHERE EMP.DEPARTMENT_ID=DEPT.DEPARTMENT_ID;
SELECT * FROM TABS;
SELECT * FROM ALL_OBJECTS WHERE LOWER(OBJECT_NAME)='dual'and lower(object_type)='table';
select * from  user_cons_columns where lower(column_name)='job_id'; 
select * from jobs;



select * from job_history;

select emp.employee_id
       ,emp.first_name
       ,emp.department_id
       from employees emp,
       jobs jb,
       job_history jb_hist
       where 
       emp.department_id=jb_hist.department_id
    and jb.job_id=jb_hist.job_id
    group by emp.employee_id emp.first_nameemp.department_id;
   --and emp.job_id=jb_hist.job_id;
   select * from employees;
   select * from departments;
   select * from jobs;
   select * from job_history;
   
   
   select emp.employee_id
   ,emp.first_name||' ' ||emp.last_name
   ,jb.job_title
   ,jb_hist.start_date
   ,jb_hist.end_date
   ,round((end_date-start_date)/365) "Years"
   from employees emp 
   ,jobs jb
   ,job_history jb_hist
   where 
   emp.job_id=jb.job_id
   and emp.employee_id=jb_hist.employee_id
   ;
select * from jobs;
select * from departments;
select * from countries;
select * from job_history;
   
select emp.employee_id
      ,emp.first_name||' ' ||emp.last_name "Employee Name"
      ,emp.department_id
      ,emp.job_id
      ,emp.salary
      ,dept.department_name
      from employees emp
      , departments dept
      , job_history jb_hist
      where emp.department_id!=dept.department_id
      and emp.department_id=jb_hist.department_id
      order by emp.employee_id;
      --group by
      
      SELECT * FROM TABS;
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;

SELECT EMP.EMPLOYEE_ID,EMP.FIRST_NAME,MANG.FIRST_NAME "MANAGER NAME",EMP.MANAGER_ID 
FROM EMPLOYEES EMP,EMPLOYEES MANG
WHERE EMP.MANAGER_ID=MANG.EMPLOYEE_ID(+)
ORDER BY EMPLOYEE_ID NULLS FIRST;

SELECT * FROM ALL_OBJECTS 
WHERE OBJECT_NAME LIKE '%GRADE%' ;; 
SELECT * FROM JOB_HISTORY;
SELECT * FROM DEPARTMENTS;
SELECT * FROM JOBS;

SELECT * FROM EMPLOYEES E, EMPLOYEES M 
WHERE M.MANAGER_ID=E.EMPLOYEE_ID(+)
AND E.HIRE_DATE>M.HIRE_DATE;


SELECT E.EMPLOYEE_ID,E.FIRST_NAME ,
       E.HIRE_DATE "EMP HIRE_DATE",
       M.HIRE_DATE "MANA HIRE_DATE"
       ,M.FIRST_NAME "MANAGER_NAME"
       FROM EMPLOYEES E,EMPLOYEES M
WHERE M.MANAGER_ID(+)=E.EMPLOYEE_ID
AND E.HIRE_DATE>M.HIRE_DATE
ORDER BY E.EMPLOYEE_ID;
SELECT * FROM JOBS;


SELECT EMP.FIRST_NAME,JB.JOB_ID,EMP.SALARY,JB.JOB_TITLE FROM EMPLOYEES EMP,JOBS JB
WHERE 1=1
AND EMP.SALARY BETWEEN  JB.MIN_SALARY AND JB.MAX_SALARY
ORDER BY SALARY;

SELECT  * FROM JOBS;
CREATE TABLE GRAD(GRADE VARCHAR(20)
                 ,MIN_SALARY NUMBER
                 ,MAX_SALARY NUMBER
                 );
INSERT INTO GRAD VALUES('A',1000,6000);
INSERT INTO GRAD VALUES('B',6001,12000);
INSERT INTO GRAD VALUES('C',12001,18000);
INSERT INTO GRAD VALUES('D',18001,24000);
COMMIT;
SELECT * FROM GRAD;
DELETE FROM GRAD WHERE GRADE ='B';


SELECT EMP.FIRST_NAME,EMP.SALARY,G.GRADE FROM EMPLOYEES EMP,GRAD G
WHERE EMP.SALARY BETWEEN G.MIN_SALARY AND G.MAX_SALARY
ORDER BY EMP.FIRST_NAME;


SELECT EMP.FIRST_NAME,EMP.SALARY,JB.JOB_ID FROM EMPLOYEES EMP,JOBS JB
WHERE EMP.SALARY BETWEEN JB.MIN_SALARY AND JB.MAX_sALARY
ORDER BY EMP.FIRST_NAME;


SELECT M.MANAGER_ID ,COUNT(*) FROM EMPLOYEES E,EMPLOYEES M
WHERE M.MANAGER_ID=E.EMPLOYEE_ID
GROUP BY M.MANAGER_ID
ORDER BY 1;

SELECT E.FIRST_NAME "MANAGER_NAME",E.MANAGER_ID,COUNT(*) FROM EMPLOYEES E ,EMPLOYEES M
WHERE M.MANAGER_ID=E.EMPLOYEE_ID
GROUP BY E.FIRST_NAME,E.MANAGER_ID
ORDER BY 2;

SELECT M.MANAGER_ID,COUNT(*) FROM EMPLOYEES E, EMPLOYEES M
WHERE M.MANAGER_ID=E.EMPLOYEE_ID
AND ;


Q1-
SELECT L.LOCATION_ID,L.STREET_ADDRESS,L.CITY,L.STATE_PROVINCE
       ,C.COUNTRY_NAME
       FROM LOCATIONS L
       ,COUNTRIES C,EMPLOYEES E
       WHERE 
       L.COUNTRY_ID=C.COUNTRY_ID;
       
Q2-
SELECT * FROM DEPARTMENTS;
SELECT E.LAST_NAME
      ,D.DEPARTMENT_ID
      ,D.DEPARTMENT_NAME
      FROM EMPLOYEES E
          ,DEPARTMENTS D
      WHERE D.DEPARTMENT_ID=E.DEPARTMENT_ID; 

Q3-
SELECT E.LAST_NAME 
      ,E.JOB_ID
      ,E.DEPARTMENT_ID
      ,D.DEPARTMENT_NAME
      ,L.CITY
      FROM EMPLOYEES E
      ,DEPARTMENTS D
      ,LOCATIONS L
      WHERE D.DEPARTMENT_ID=E.DEPARTMENT_ID
      AND UPPER(L.CITY)='TORONTO';
      
Q4-
SELECT E.FIRST_NAME "EMPLOYEE" 
               ,E.EMPLOYEE_ID
                ,M.FIRST_NAME "MANAGER NAME"
                ,M.EMPLOYEE_ID
               ,M.MANAGER_ID 
              
               FROM EMPLOYEES E 
               , EMPLOYEES M
               WHERE 
               E.MANAGER_ID=M.EMPLOYEE_ID
               ORDER BY E.EMPLOYEE_ID;
               
Q5-

SELECT *  FROM EMPLOYEES E,EMPLOYEES M
WHERE E.MANAGER_ID=M.EMPLOYEE_ID
ORDER BY E.FIRST_NAME NULLS FIRST;

