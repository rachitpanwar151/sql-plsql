
------------------------BODY-----------------------------------------------------


CREATE OR REPLACE PACKAGE BODY xx_intgreal AS

    PROCEDURE validatee(
        p_emp_id    IN NUMBER,
        p_fname      IN VARCHAR2,
        p_lname      IN VARCHAR2,
        p_email      IN VARCHAR2,
        p_phno     IN  VARCHAR2,
        p_hiredate   IN DATE,
        p_job_id     IN VARCHAR2,
        p_salary     IN NUMBER,
        p_com_oct    IN NUMBER,
        p_manager_id IN NUMBER,
        p_dept_id    IN NUMBER,
        p_status     OUT VARCHAR2,
        p_error      OUT VARCHAR2
    ) AS
    BEGIN
    DBMS_OUTPUT.PUT_LINE(1);
      P_STATUS:='V';
      BEGIN
      IF p_emp_id IS NULL THEN
            p_status := 'E';
            p_error := p_error || 'employee_id cant be null';
        END IF;
    END;

BEGIN
    IF p_fname IS NULL THEN
        p_status := 'E';
        p_error := p_error || 'FIRST_NAME CANT BE NULL';
    END IF;
END;

BEGIN
    IF p_email IS NULL THEN
        p_status := 'E';
        p_error := p_error || 'EMAIL CANT BE NULL';
    END IF;
END;

BEGIN
    IF length(p_phno) > 10 THEN
        p_status := 'E';
        p_error := p_error || 'LENGTH OF PHONE NUMBER CANT BE GREATER THAN 10 ';
    ELSE
        IF length(P_phno) < 10 THEN
            p_statuS := 'E';
            p_error := p_error || 'LENGTH OOF PHONE NUMBER CANT BE LESS THEN 10';
        END IF;
    END IF;
END;
BEGIN
IF P_HIREDATE IS NULL
THEN
P_STATUS:='E';
P_ERROR:=P_ERROR||'HIRE DATE CANNOT BE NULL';
END IF;
END;
BEGIN
IF P_JOB_ID IS NULL
THEN
P_STATUS:='E';
P_ERROR:=P_ERROR||'JOB ID CANT BE NULL';
END IF;
END;
BEGIN
IF LENGTH(P_SALARY)>6 
THEN
P_STATUS:='E';
P_ERROR:=P_ERROR||'LENGTH OF SALARY CANT BE GREATER THAN 6';
--ELSE IF LENGTH(P_SALARY)<6
--THEN
--P_STATUS:='E';
--P_ERROR:=P_ERROR||'LENGTH OF SALARY CANT BE LESS THAN 6';
--END IF;
END IF;
END;
BEGIN
IF P_COM_OCT<0
THEN
p_status := 'E';

p_error := p_error || 'COMMISSION OCT CANT BE LASS THAN 0';

end IF;

end;

BEGIN
    IF length(p_manager_id) > 6 THEN
        p_status := 'E';
        p_error := p_error || 'LANGTH OF MANAGER ID CANNNOT BE GREATER THAN 6';
    END IF;
END;

BEGIN
    IF length(p_dept_id) > 4 THEN
        p_status := 'E';
        p_error := p_error || ' LENGTH OF DEPARTMENT ID NOT GREATER THEN 4';
    END IF;
END;

BEGIN
    IF p_lname IS NULL THEN
        p_status := 'E';
        p_error := p_error || 'last_name cant be null';
    ELSE
        IF length(p_lname) > 20 THEN
            p_status := 'E';
            p_error := p_error || 'last name should be have max 20 character';
        END IF;
    END IF;
    end;
EXCEPTION
    WHEN OTHERS THEN
        p_status := 'E';
        p_error := p_error
                   || sqlcode
                   || sqlerrm;
                   END validatee;
PROCEDURE LOADDATA(
        p_emp_id    IN NUMBER,
        p_fname      IN VARCHAR2,
        p_lname      IN VARCHAR2,
        p_email      IN VARCHAR2,
        p_phno       IN VARCHAR2,
        p_hiredate   IN DATE,
        p_job_id     IN VARCHAR2,
        p_salary     IN NUMBER,
        p_com_oct    IN NUMBER,
        p_manager_id IN NUMBER,
        p_dept_id    IN NUMBER,
        p_status     OUT VARCHAR2,
        p_error      OUT VARCHAR2
   )
   AS
   BEGIN
   IF P_STATUS='E'
   THEN
   P_ERROR:=P_ERROR||'DATA CANT INSERT ';
   ELSE 

   INSERT INTO  EMPLOYEES VALUES( p_emp_id , p_fname , p_lname , p_email ,p_phno,
        p_hiredate   ,
        p_job_id     ,
        p_salary     ,
        p_com_oct    ,
        p_manager_id ,
        p_dept_id      );
   COMMIT;
   END IF;
   
   EXCEPTION  WHEN OTHERS THEN 
   P_STATUS:='E';
   P_ERROR:=P_ERROR||SQLCODE||SQLERRM;
   
   
   END LOADDATA;
--   DESC EMPLOYEES;
PROCEDURE mainn (
    p_emp_id    IN NUMBER,
    p_fname      IN VARCHAR2,
    p_lname      IN VARCHAR2,
    p_email      IN VARCHAR2,
    p_phno      in  VARCHAR2,
    p_hiredate   IN DATE,
    p_job_id     IN VARCHAR2,
    p_salary     IN NUMBER,
    p_com_oct    IN NUMBER,
    p_manager_id IN NUMBER,
    p_dept_id    IN NUMBER,
    p_status     OUT VARCHAR2,
    p_error      OUT VARCHAR2
)
AS
BEGIN
validatee (
        p_emp_id    ,
        p_fname      ,
        p_lname      ,
        p_email      ,
        p_phno       ,
        p_hiredate   ,
        p_job_id     ,
        p_salary     ,
        p_com_oct    ,
        p_manager_id ,
        p_dept_id    ,
        p_status     ,
        p_error  
    );
    IF P_STATUS='V'THEN
    loaddata(
        p_emp_id    ,
        p_fname      ,
        p_lname      ,
        p_email      ,
        p_phno       ,
        p_hiredate  ,
        p_job_id   ,
        p_salary    ,
        p_com_oct    ,
        p_manager_id ,
        p_dept_id   ,
        p_status     ,
        p_error      
   );
    END IF;
    EXCEPTION
    WHEN OTHERS THEN 
    P_STATUS:='E';
    P_ERROR:=P_ERROR||SQLCODE||SQLERRM;
     
END MAINN;
END XX_INTGREAL;



------------------------------------Calling-------------------------------
--p_emp_id    IN NUMBER,
--    p_fname      IN VARCHAR2,
--    p_lname      IN VARCHAR2,
--    p_email      IN VARCHAR2,
--    p_phno      in  VARCHAR2,
--    p_hiredate   IN DATE,
--    p_job_id     IN VARCHAR2,
--    p_salary     IN NUMBER,
--    p_com_oct    IN NUMBER,
--    p_manager_id IN NUMBER,
--    p_dept_id    IN NUMBER,
--    p_status     OUT VARCHAR2,
--    p_error      OUT VARCHAR2
--)
DECLARE 
LC_STATUS VARCHAR2(2);
LC_ERROR_MESSAGE VARCHAR2(2000);

begin
XX_INTGREAL.mainn(207,'RACHIT','PANWAR','RLOGER','123.456908',TO_DATE('05-JUN-23'),'AD_VP',19500,0.1,100,110,LC_STATUS,LC_ERROR_MESSAGE);
DBMS_OUTPUT.PUT_LINE(LC_STATUS|| ' -'|| LC_ERROR_MESSAGE);
end;

 
SELECT * FROM EMPLOYEES; 
 