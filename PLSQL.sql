select * from all_objects where lower(object_name) like 'user%con%';

select * from employees;

select * from user_constraints;
SELECT DISTINCT SALARY FROM EMPLOYEES;
SELECT DISTINCT * FROM employees A
WHERE (SELECT COUNT(DISTINCT SALARY) FROM EMPLOYEES B
       WHERE A.SALARY<=B.SALARY)=57;
       
SELECT * FROM EMPLOYEES A,EMPLOYEES B
HAVING COUNT(A.sALARY)<

;

select * from employees EMP ,DEPARTMENTS D
WHERE EMP.DEPARTMENT_ID=D.DEPARTMENT_ID;


create or replace procedure dept(dept_name in varchar2,
                                                  deptid  out  number)
is 

begin
select  department_id into deptid  from departments
where lower(department_name )=lower(dept.dept_name);
exception when others then
printf('error');
end ;

declare
dept_name varchar2(200);
deptid number;
begin
dept('administration',deptid);
printf(deptid);
end;

select * from departments;

create or replace procedure count_date(INPUT in number,
                                        JAN OUT VARCHAR2
                                        ,MON OUT VARCHAR2)
is 
begin
FOR I IN 1..12 LOOP
IF I IN (1,3,5,7,8,10,12) THEN 
SELECT TO_cHAR(LAST_dAY(ADD_MONTHS(TRUNC(SYSDATE,'YEAR'),INPUT-1)),'DD'),
       TO_cHAR(LAST_dAY(ADD_MONTHS(TRUNC(SYSDATE,'YEAR'),INPUT-1)),'MONTH') INTO JAN,MON 
FROM DUAL;
ELSIF INPUT=2 THEN
SELECT TO_cHAR(LAST_dAY(ADD_MONTHS(TRUNC(SYSDATE,'YEAR'),INPUT-1)),'DD'),
       TO_cHAR(LAST_dAY(ADD_MONTHS(TRUNC(SYSDATE,'YEAR'),INPUT-1)),'MONTH')INTO JAN,MON 
FROM DUAL;
ELSIF INPUT IN (4,6,9,11) THEN 
SELECT TO_cHAR(LAST_dAY(ADD_MONTHS(TRUNC(SYSDATE,'YEAR'),INPUT-1)),'DD'),
       TO_cHAR(LAST_dAY(ADD_MONTHS(TRUNC(SYSDATE,'YEAR'),INPUT-1)),'MONTH') INTO JAN ,MON
FROM DUAL;
END IF;

END LOOP;
EXCEPTION WHEN OTHERS THEN
PRINTF('ERROR'||SQLCODE||SQLERRM);
END;


DECLARE 
INPUT NUMBER;
JAN VARCHAR2(200);
MON VARCHAR2(200);
BEGIN
count_date(6,JAN,MON);
PRINTF(JAN||' '||MON);
END;

SELECT TO_cHAR(SYSDATE,'MONTH'),1 FROM DUAL;