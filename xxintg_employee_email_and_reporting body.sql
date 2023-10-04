CREATE OR REPLACE PACKAGE BODY xxintg_employee_email_and_reporting 
AS
GN_EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE;
/*******************************************************************************************
DEFINING AND DECLARING PROCEURE LOADDATE FOR INSETING THE DATA IN BASE TABLE
*********************************************************************************************/
    PROCEDURE loaddata (
        p_employee_id    IN employees.employee_id%TYPE,
        p_first_name     IN employees.first_name%TYPE,
        p_last_name      IN employees.last_name%TYPE,
        p_email          IN employees.email%TYPE,
        p_phone_number   IN employees.phone_number%TYPE,
        p_hire_date      IN employees.hire_date%TYPE,
        p_job_id         IN employees.job_id%TYPE,
        p_salary         IN employees.salary%TYPE,
        p_commission_pct IN employees.commission_pct%TYPE,
        p_manager_id     IN employees.manager_id%TYPE,
        p_department_id  IN employees.department_id%TYPE
,
LC_STATUS OUT VARCHAR2,LC_ERROR OUT VARCHAR2) AS
    BEGIN
  GN_EMP_ID:=  EMPLOYEES_SEQ.NEXTVAL;
        INSERT INTO employees VALUES (
            GN_EMP_ID,
            p_first_name,
            p_last_name,
            p_email,
            p_phone_number,
            p_hire_date,
            p_job_id,
            p_salary,
            p_commission_pct,
            p_manager_id,
            p_department_id
        );
LC_STATUS:='V';
EXCEPTION WHEN OTHERS THEN
LC_STATUS:='E';
LC_ERROR:=SQLCODE||'-'||SQLERRM;
DBMS_OUTPUT.PUT_LINE('DATA CANNOT INSERTED '||SQLCODE||'-'||SQLERRM);
    END loaddata;

    PROCEDURE validatedata (      
        p_employee_id    IN employees.employee_id%TYPE,
        p_first_name     IN employees.first_name%TYPE,
        p_last_name      IN employees.last_name%TYPE,
        p_email          IN employees.email%TYPE,
        p_phone_number   IN employees.phone_number%TYPE,
        p_hire_date      IN employees.hire_date%TYPE,
        p_job_id         IN employees.job_id%TYPE,
        p_salary         IN employees.salary%TYPE,
        p_commission_pct IN employees.commission_pct%TYPE,
        p_manager_id     IN employees.manager_id%TYPE,
        p_department_id  IN employees.department_id%TYPE,
                p_STATUS out VARCHAR2, p_error  out VARCHAR2
    ) AS
       
        ln_count  NUMBER;
     
    BEGIN
p_STATUS:='V';

---------employee id validation
begin
            SELECT
                COUNT(*)
            INTO ln_count
            FROM
                employees
            WHERE
                employee_id = p_employee_id;

            IF ln_count > 0 THEN
            dbms_output.put_line('1');
              p_status := 'E';
               p_error := p_error || '  EMPLOYEE ID ALREADY EXIST PLEASE ENTER UNIQUE EMPLOYEE ID';
            END IF;
end;

------------first name validation
        IF p_first_name IS NULL THEN
            p_status := 'E';
            p_error := p_error || ' first_name cannot be null';
        ELSE
            IF length(p_first_name) > 15 THEN
                dbms_output.put_line('2');
                p_status := 'E';
                p_error :=p_error || ' FIRST NAME CANNNOT HAVE MORE THAN 15 CHARACTER';
            END IF;
        END IF;

------------------LAST NAME VALIDATION
        IF p_last_name IS NULL THEN
            p_status := 'E';
            p_error := p_error || ' LAST NAME CANNOT BE NULL';
        ELSE
            IF length(p_last_name) > 15 THEN
            dbms_output.put_line('3');
                p_status := 'E';
                p_error := p_error || ' LAST NAME CANNOT HAVE MORE THAN 15 CHARACTER';
            END IF;
        END IF;

-----------EMAIL VALIDATION
        IF p_email IS NULL THEN
        
            p_status := 'E';
            p_error :=p_error || ' EMAIL CANNOT BE NULL';
        ELSE
            IF instr(p_email, '@') = 1 and instr(p_email, '.COM') = 1 THEN
        dbms_output.put_line('4');
                p_status := 'E';
                p_error := p_error || ' INVALID EMAIL';
            END IF;
        END IF;


---PHONE NUMBER VALIDATION

        IF p_phone_number IS NULL THEN
            p_status := 'E';
            p_error := p_error || ' PHONE NUMBER CANNOT BE NULL';
        ELSE
            IF length(p_phone_number) <> 10 THEN
 dbms_output.put_line('5');
                p_status := 'E';
                p_error := p_error || ' PHONE NUMBER MUST HAVE 10 DIGITS ONLY';
            END IF;
        END IF;


--HIRE DATE VALIDATION

        IF p_hire_date IS NULL THEN
            p_status := 'E';
        ELSE
            IF p_hire_date > sysdate THEN
dbms_output.put_line('6');
                p_status := 'E';
                p_error :=p_error || ' HIRE DATE CANNOT BE GREATER THEN SYSDATE';
            END IF;
        END IF;
 

---------JOB ID VALIDATION 
        IF p_job_id IS NULL THEN
            p_status := 'E';
            p_error := p_error || '  JOB ID CANNOT BE NULL';
        ELSE
            SELECT
                COUNT(*)
            INTO ln_count
            FROM
                jobs
            WHERE
                job_id = p_job_id;

            IF ln_count <> 1 THEN
dbms_output.put_line('7');
                p_status := 'E';
                p_error := p_error || ' JOB_ID DOESNT EXIST';
            END IF;

        END IF;

        IF p_salary < 5000 THEN
dbms_output.put_line('8');
            p_status := 'E';
            p_error := p_error || ' SALARY SHOULD BE GREATER THAN 5000';
        END IF;

        IF p_commission_pct NOT BETWEEN 0 AND 1 THEN
            dbms_output.put_line('9');
            p_status := 'E';
            p_error := p_error || ' COMMISSION PCT CANNOT BE GREATER THAN 1 AND LESS THAN 0';
        END IF;
        
dbms_output.put_line(P_STATUS||'-'||P_ERROR);
        --------MANAGER ID  VALIDATION


        IF p_manager_id IS NULL THEN
            p_status := 'E';
            p_error := p_error || ' MANAGER ID CANNOT BE NULL';
        ELSE
            SELECT
                count(*)
            INTO ln_count
            FROM
                employees
            WHERE
                employee_id = p_manager_id;

            IF ln_count <> 1 THEN
            dbms_output.put_line('10');
                p_status := 'E';
                p_error := p_error || ' MANAGER SHOULD BE AN EMPLOYEE';
            END IF;

        END IF;
        
dbms_output.put_line(P_STATUS||'-'||P_ERROR);
        -----------------DEPARTMENT ID VALIDATION

        IF p_department_id IS NULL THEN

dbms_output.put_line('11');
p_status := 'E';
            p_error := p_error || ' DEPARTMENT_ID IS NULL';
        END IF;

dbms_output.put_line(P_STATUS||'-'||P_ERROR);
EXCEPTION WHEN OTHERS THEN
p_STATUS:='E';
p_ERROR:=' VALIDATION CANNOT OCCUR'||SQLCODE||'-'||SQLERRM;
    END validatedata;
    PROCEDURE mainnn (
        p_employee_id    IN employees.employee_id%TYPE,
        p_first_name     IN employees.first_name%TYPE,
        p_last_name      IN employees.last_name%TYPE,
        p_email          IN employees.email%TYPE,
        p_phone_number   IN employees.phone_number%TYPE,
        p_hire_date      IN employees.hire_date%TYPE,
        p_job_id         IN employees.job_id%TYPE,
        p_salary         IN employees.salary%TYPE,
        p_commission_pct IN employees.commission_pct%TYPE,
        p_manager_id     IN employees.manager_id%TYPE,
        p_department_id  IN employees.department_id%TYPE
    ) AS
    LC_STATUS VARCHAR2(3000);
    LC_ERROR VARCHAR2(7000);
    
    BEGIN
        dbms_output.put_line(rpad('p_employee_id ',15) || p_employee_id);
        dbms_output.put_line(rpad('p_first_name  ',15) || p_first_name);
        dbms_output.put_line(rpad('p_last_name  ',15) || p_last_name);
        dbms_output.put_line(rpad('p_email  ' ,15)|| p_email);
        dbms_output.put_line(rpad('p_phone_number  ',15) ||p_phone_number);
        dbms_output.put_line(rpad('p_hire_date  ',15) || p_hire_date);
        dbms_output.put_line(rpad('p_hire_date ' ,15)|| p_hire_date);
        dbms_output.put_line(rpad('p_job_id  ' ,15)|| p_job_id);
        dbms_output.put_line(RPAD('p_salary  ',15) || p_salary);
        dbms_output.put_line(RPAD('p_commission_pct  ',15) || p_commission_pct);
        dbms_output.put_line(RPAD('p_manager_id  ',15) || p_manager_id);
        dbms_output.put_line(RPAD('p_department_id  ' ,15)|| p_department_id);
        
                IF P_EMPLOYEE_ID IS NULL THEN
                VALIDATEDATA(
        p_employee_id    ,
        p_first_name     ,
        p_last_name      ,
        p_email          ,
        p_phone_number   ,
        p_hire_date      ,
        p_job_id         ,
        p_salary         ,
        p_commission_pct ,
        p_manager_id    ,
        p_department_id , lc_STATUS
        , lc_ERROR);
       
        IF LC_STATUS='V' THEN
       DBMS_OUTPUT.PUT_LINE('VALIDATE SUCCESSFULLY');
       loaddata(P_EMPLOYEE_ID, p_first_name, p_last_name, p_email, p_phone_number,
                p_hire_date, p_job_id, p_salary, p_commission_pct, p_manager_id,
                p_department_id,LC_STATUS,LC_ERROR);
                 IF LC_STATUS='V'
                 THEN
                 DBMS_OUTPUT.PUT_LINE('INSERT SUCCESSFULLY');
                END IF ;
END IF;
END IF;


----------------------REPORT----------------------------------------------

   dbms_output.put_line(rpad('p_employee_id ',15) ||rpad('p_first_name  ',15)||RPAD('p_last_name  ',15) || rpad('p_email  ' ,15)||
    rpad('p_phone_number  ',15) ||rpad('p_hire_date  ',15) ||rpad('p_job_id  ' ,15)||RPAD('p_salary  ',15) ||
    RPAD('p_commission_pct  ',15) ||RPAD('p_manager_id  ',15) ||RPAD('p_department_id  ' ,15));
 DBMS_OUTPUT.PUT_LINE(rpad(GN_EMP_ID ,15) ||
 rpad(p_first_name ,15)||RPAD(p_last_name,15) || 
 rpad(p_email,15)||
    rpad(p_phone_number,15) ||
    rpad(p_hire_date,15) ||
    rpad(p_job_id,15)||
    RPAD(p_salary,15) ||
    RPAD(p_commission_pct,15)||
    RPAD(p_manager_id , 15) ||
    rpad(p_department_id, 15 ));
    EXCEPTION WHEN
    OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('EROR OCCURED'||SQLCODE||'-'||SQLERRM);
        end    mainnn;
    end  xxintg_employee_email_and_reporting;