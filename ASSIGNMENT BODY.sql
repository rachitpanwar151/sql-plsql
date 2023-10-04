CREATE OR REPLACE PACKAGE BODY xxintg_emp_update_insert_rp AS
    PROCEDURE update_emp_table (
     p_employee_id    IN employees.employee_id%TYPE,
        p_first_name     IN employees.first_name%TYPE,
        p_last_name      IN employees.last_name%TYPE,
        p_email          IN employees.email%TYPE,
        p_phone_number   IN employees.phone_number%TYPE,
        p_hire_date      IN employees.hire_date%TYPE,
        p_job_TITLE         IN jobs.job_TITLE%TYPE,
        p_salary         IN employees.salary%TYPE,
        p_commission_pct IN employees.commission_pct%TYPE,
        p_manager_id     IN employees.manager_id%TYPE,
        p_department_name  IN departments.department_name%TYPE,
        p_loc_name IN locations.city%type,
--        p_dept_manager_name IN employees.first_name%type,
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2
    ) AS 
        lc_job_id  VARCHAR2(30);
        ln_dept_id NUMBER;
    BEGIN
        dbms_output.put_line('update');
        IF p_job_title IS NOT NULL THEN
              SELECT
                job_id
            INTO lc_job_id
            FROM
                jobs
            WHERE
                upper(job_title) = upper(p_job_title);

            IF p_department_name IS NOT NULL THEN
                SELECT
                    department_id
                INTO ln_dept_id
                FROM
                    departments
                WHERE
                    upper(department_name) = upper(p_department_name);

                UPDATE employees
                SET
                    last_name = nvl(p_last_name, last_name),
                    email = nvl(p_email, email),
                    phone_number = nvl(p_phone_number, phone_number),
                    salary = nvl(p_salary, salary),
                    job_id = nvl(lc_job_id, job_id),
                     commission_pct = nvl(p_commission_pct, commission_pct),
                    manager_id = nvl(p_manager_id, manager_id),
                    department_id = nvl(ln_dept_id, department_id)
                WHERE
                    employee_id = p_employee_id;

            END IF;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Error while updating data'
                                 || sqlcode
                                 || '-'
                                 || sqlerrm);
    END update_emp_TABLE;

    PROCEDURE insert_emp (
     p_employee_id    IN employees.employee_id%TYPE,
        p_first_name     IN employees.first_name%TYPE,
        p_last_name      IN employees.last_name%TYPE,
        p_email          IN employees.email%TYPE,
        p_phone_number   IN employees.phone_number%TYPE,
        p_hire_date      IN employees.hire_date%TYPE,
        p_job_ID        IN jobs.job_ID%TYPE,
        p_salary         IN employees.salary%TYPE,
        p_commission_pct IN employees.commission_pct%TYPE,
        p_manager_id     IN employees.manager_id%TYPE,
        p_department_ID IN departments.department_ID%TYPE,
        p_loc_name IN locations.city%type,
--        p_dept_manager_name IN employees.first_name%type,
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2
    ) AS 
        lc_job_id  VARCHAR2(30);
        ln_dept_id NUMBER;
    BEGIN
    
        INSERT INTO employees VALUES (
            EMPLOYEES_SEQ.NEXTVAL,
            p_first_name,
            p_last_name,
            p_email,
            p_phone_number,
            p_hire_date,
            p_job_ID,
            p_salary,
            p_commission_pct,
            p_manager_id,
            p_department_ID
        );

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlcode
                                 || '-'
                                 || sqlerrm);
    END insert_emp;

    PROCEDURE validate_insertt (
 p_employee_id    IN employees.employee_id%TYPE,
        p_first_name     IN employees.first_name%TYPE,
        p_last_name      IN employees.last_name%TYPE,
        p_email          IN employees.email%TYPE,
        p_phone_number   IN employees.phone_number%TYPE,
        p_hire_date      IN employees.hire_date%TYPE,
        p_job_TITLE         IN jobs.job_TITLE%TYPE,
        p_salary         IN employees.salary%TYPE,
        p_commission_pct IN employees.commission_pct%TYPE,
        p_manager_id     IN employees.manager_id%TYPE,
        p_department_name  IN departments.department_name%TYPE,
        p_loc_name IN locations.city%type,
        P_DEPTS_ID OUT DEPARTMENTS.DEPARTMENT_ID%TYPE,
P_JOBS_ID OUT JOBS.JOB_ID%TYPE,

--        p_dept_manager_name IN employees.first_name%type,
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2
    ) AS
        ln_count NUMBER;
    BEGIN
        dbms_output.put_line('insert validate');
        p_status := 'V';   
   --EMPLOYEE_ID VALIDATION.  
        dbms_output.put_line('VALIDATING INSERTED DATA 1');

/*********************************************
first_name validation.
*************************************************/
        IF p_first_name IS NULL THEN
            p_status := 'E';
            p_error := p_error || 'first_name cant be null';
        ELSIF length(p_first_name) > 20 THEN
            p_status := 'E';
            p_error := p_error || 'length of first_name cant be greater than 20';
        END IF;
/*******************************************************
last_name validation.
*************************************************************/

        IF p_last_name IS NULL THEN
            p_status := 'E';
            p_error := p_error || 'last_name cant be null';
        ELSIF length(p_last_name) > 20 THEN
            p_status := 'E';
            p_error := p_error || 'length of last_name cant be greater than 20';
        END IF;

/**********************************************
email validation.        
*****************************************************/
        IF p_email IS NULL THEN
            p_status := 'E';
            p_error := p_error || 'email cant be null';
        ELSE
            IF
                instr(p_email, '@') = 0
                AND instr(p_email, '.com') = 0
            THEN
                p_status := 'E';
                p_error := p_error || 'INVALID EMAIL.';
            ELSE
                SELECT
                    COUNT(*)
                INTO ln_count
                FROM
                    employees
                WHERE
                    email = p_email;

                IF ln_count > 0 THEN
                    p_status := 'E';
                    p_error := p_error || 'EMAIL REPEATED.';
                END IF;

            END IF;
        END IF;

/*************************************************************
phone number validation.
********************************************************************/
        IF p_phone_number IS NULL THEN
            p_status := 'E';
            p_error := p_error || 'phone number can not be null';
        ELSIF length(p_phone_number) <> 10 THEN
            p_status := 'E';
            p_error := p_error || 'phone number can not be LESSER OR grEater then 10 CHARACTER';
        ELSE
            SELECT
                COUNT(*)
            INTO ln_count
            FROM
                employees
            WHERE
                phone_number = p_phone_number;

            IF ln_count > 0 THEN
                p_status := 'E';
                p_error := p_error || ' phone_number ALREADY EXISTS';
            END IF;

        END IF;

/**********************************************
hire_date validation.
*************************************************/
        IF p_hire_date IS NULL THEN
            p_status := 'E';
            p_error := p_error || 'hire_date can not be null';
        ELSIF p_hire_date > sysdate THEN
            p_status := 'E';
            p_error := p_error || 'hire_date CANNOT BE GREATER THAN SYSDATE';
        END IF;

/*************************************************************
job_id validation.
********************************************************************/
        IF p_job_title IS NULL THEN
            p_status := 'E';
            p_error := p_error || 'job_id can not be null';
        ELSE
        BEGIN
        SELECT
                JOB_ID 
            INTO P_JOBS_ID
            FROM
                jobs
            WHERE
                lower(job_title) = lower(p_job_title);
EXCEPTION  WHEN OTHERS THEN
P_STATUS:='E';
P_ERROR:=P_ERROR||' JOB ID DOESNT EXIST';
END;
        END IF;
/**********************************************
salary validation.
*************************************************/
        IF p_salary < 10000 THEN
            p_status := 'E';
            p_error := p_error || 'minimum salary is 10000.';
        ELSIF length(p_salary) > 8 THEN
            p_status := 'E';
            p_error := p_error || 'salary range exceedS';
        END IF;
/********************************************************
commission validation.
**********************************************************/
        IF p_commission_pct < 0 THEN
            p_status := 'E';
            p_error := p_error || 'commission can not be in negative.';
        ELSIF p_commission_pct > 1 THEN
            p_status := 'E';
            p_error := p_error || 'commission limit exceed.';
        END IF;
/**************************************************************
manager_id validation.
******************************************************************/
            SELECT
                COUNT(*)
            INTO ln_count
            FROM
                employees
            WHERE
                employee_id = p_manager_id;

            IF ln_count > 1 THEN
                p_status := 'E';
                p_error := p_error || 'manager ID SHOULD BE employee';
            END IF;

--department_id validation.
    SELECT
                COUNT(*)
            INTO ln_count
            FROM
                departments
            WHERE
                UPPER(department_name) =UPPER( p_department_name);

            IF ln_count = 0 THEN
            
             name_to_id_in_dept.MAINN(DEPARTMENTS_SEQ.NEXTVAL,p_department_name,P_MANAGER_ID,P_LOC_NAME,P_ERROR,P_STATUS);
IF P_STATUS='V'
THEN
SELECT DEPARTMENT_ID INTO P_DEPTS_ID FROM DEPARTMENTS WHERE UPPER(DEPARTMENT_NAME)=UPPER(p_department_name);
ELSE
P_STATUS:='E';
P_ERROR:=P_ERROR||' ERROR WHILE CREATING DEPARTMENT';
            END IF;
--
--        END IF;
END IF;
    END validate_insertt;

    PROCEDURE main_PCKG   ( p_employee_id    IN employees.employee_id%TYPE,
        p_first_name     IN employees.first_name%TYPE,
        p_last_name      IN employees.last_name%TYPE,
        p_email          IN employees.email%TYPE,
        p_phone_number   IN employees.phone_number%TYPE,
        p_hire_date      IN employees.hire_date%TYPE,
        p_job_TITLE         IN jobs.job_TITLE%TYPE,
        p_salary         IN employees.salary%TYPE,
        p_commission_pct IN employees.commission_pct%TYPE,
        p_manager_id     IN employees.manager_id%TYPE,
        p_department_name  IN departments.department_name%TYPE,
        p_loc_name IN locations.city%type,
--        p_dept_manager_ID IN employees.first_name%type,
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2
    )AS
    LN_DEPTID DEPARTMENTS.DEPARTMENT_ID%TYPE;
    LN_JOBID JOBS.JOB_ID%TYPE;
  BEGIN
  
   IF P_EMPLOYEE_ID IS NULL THEN
   validate_insertt( p_employee_id  ,
        p_first_name     ,
        p_last_name      ,
        p_email          ,
        p_phone_number   ,
        p_hire_date      ,
        p_job_TITLE      ,
        p_salary         ,
        p_commission_pct ,
        p_manager_id     ,
        p_department_name  ,
        p_loc_name ,LN_DEPTID,
        LN_JOBID,
--        p_dept_manager_ID ,
        p_status,
        p_error 
    );

    IF p_status = 'V' THEN
        insert_emp ( p_employee_id  ,
        p_first_name     ,
        p_last_name      ,
        p_email          ,
        p_phone_number   ,
        p_hire_date      ,
        LN_jobID      ,
        p_salary         ,
        p_commission_pct ,
        p_manager_id     ,
        LN_DEPTID  ,
        p_loc_name ,
--        p_dept_manager_ID ,
        p_status,
        p_error 
    );
        COMMIT;
    END IF;
    END IF;

    END ;
END xxintg_emp_update_insert_rp;
    

 