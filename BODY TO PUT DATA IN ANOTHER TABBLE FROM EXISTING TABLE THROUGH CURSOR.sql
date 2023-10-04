CREATE OR REPLACE PACKAGE BODY EMPLOYEE_BACKUP_INSERTION
AS
PROCEDURE BACKUP
AS
CURSOR C1
IS 
SELECT * FROM EMPLOYEES;
BEGIN
FOR R1 IN C1 
LOOP
INSERT INTO EMPLOYEE_BACKUP VALUES( R1.EMPLOYEE_ID,
R1.FIRST_NAME
,R1.LAST_NAME
,R1.EMAIL
,R1.PHONE_NUMBER
,R1.HIRE_DATE,
R1.JOB_ID,
R1.SALARY,
R1.COMMISSION_PCT
,R1.MANAGER_ID,
R1.DEPARTMENT_ID);
END LOOP;
EXCEPTION WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(SQLCODE||' '||SQLERRM);
END ;
PROCEDURE MAIN_BACKUP
AS
BEGIN
BACKUP;
END MAIN_BACKUP;
END  EMPLOYEE_BACKUP_INSERTION;


--CALLING--

BEGIN
EMPLOYEE_BACKUP_INSERTION.MAIN_BACKUP;
END;

SELECT * FROM EMPLOYEE_BACKUP;
DROP TABLE EMPLOYEE_BACKUP;