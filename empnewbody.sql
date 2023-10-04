CREATE OR REPLACE PACKAGE BODY xx_emp_more AS

    PROCEDURE update_emp (
        p_employee_id       IN employees.employee_id%TYPE,
        p_first_name        IN employees.first_name%TYPE,
        p_last_name         IN employees.last_name%TYPE,
        p_email             IN employees.email%TYPE,
        p_phone_number      IN employees.phone_number%TYPE,
        p_hire_date         IN employees.hire_date%TYPE,
        p_job_title         IN jobs.job_title%TYPE,
        p_salary            IN employees.salary%TYPE,
        p_commission_pct    IN employees.commission_pct%TYPE,
        p_manager_id        IN employees.manager_id%TYPE,
        p_department_name   IN departments.department_name%TYPE,
        p_loc_name          IN locations.location_id%TYPE,
        p_dept_manager_name IN employees.employee_id%TYPE,
        p_status            OUT VARCHAR2,
        p_error             OUT VARCHAR2
    ) AS
        lc_job_id  VARCHAR2(30);
        ln_dept_id NUMBER;
    BEGIN
        dbms_output.put_line('updatING EMPLOYEES');
        IF p_job_title IS NOT NULL THEN
            SELECT
                job_id
            INTO lc_job_id
            FROM
                jobs
            WHERE
                job_title = p_job_title;

            IF p_department_name IS NOT NULL THEN
                SELECT
                    department_id
                INTO ln_dept_id
                FROM
                    departments
                WHERE
                    department_name = p_department_name;

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
    END update_emp;
       
    ----------------------------insert procedure defination------------------------------------------
    PROCEDURE insert_emp (p_employee_id       IN employees.employee_id%TYPE,
        p_first_name        IN employees.first_name%TYPE,
        p_last_name         IN employees.last_name%TYPE,
        p_email             IN employees.email%TYPE,
        p_phone_number      IN employees.phone_number%TYPE,
        p_hire_date         IN employees.hire_date%TYPE,
        p_job_title         IN jobs.job_title%TYPE,
        p_salary            IN employees.salary%TYPE,
        p_commission_pct    IN employees.commission_pct%TYPE,
--        p_manager_id        IN employees.manager_id%TYPE,
        p_department_name   IN departments.department_name%TYPE,
        p_status            OUT VARCHAR2,
        p_error             OUT VARCHAR2,
        p_loc_name          in locations.location_id%TYPE,
        p_dept_manager_name in employees.employee_id%TYPE
   ) AS
        lc_job_id  VARCHAR2(30);
        ln_dept_id NUMBER;
    BEGIN
        dbms_output.put_line('inserting data ');
        BEGIN
            SELECT
                job_id
            INTO lc_job_id
            FROM
                jobs
            WHERE
                job_title = p_job_title;

        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('job id  doesnt exist'
                                     || sqlcode
                                     || '-'
                                     || sqlerrm);
        END;

        BEGIN
            SELECT
                department_id
            INTO ln_dept_id
            FROM
                departments
            WHERE
                department_name = p_department_name;

        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line(' dept id  doesnt exist'
                                     || sqlcode
                                     || '-'
                                     || sqlerrm);
        END;
BEGIN
SELECT EMPLOYEE_ID INTO LN_MANAGER_ID FROM EMPLOYEES WHERE UPPER(FIRST_NAME)=UPPER(P_DEPT_MANAGER_NAME);
END;
INSERT INTO employees VALUES (
            p_employee_id,
            p_first_name,
            p_last_name,
            p_email,
            p_phone_number,
            p_hire_date,
            lc_job_id,
            p_salary,
            p_commission_pct,
            LN_manager_id,
            ln_dept_id
        );

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('DATA COULD NOT BE INSERTED '||sqlcode
                                 || '-'
                                 || sqlerrm);
END insert_emp;

------------------------------validate insert values------------------------------------------
    procedure validate_insert (
        p_employee_id       IN employees.employee_id%TYPE,
        p_first_name        IN employees.first_name%TYPE,
        p_last_name         IN employees.last_name%TYPE,
        p_email             IN employees.email%TYPE,
        p_phone_number      IN employees.phone_number%TYPE,
        p_hire_date         IN employees.hire_date%TYPE,
        p_job_title         IN jobs.job_title%TYPE,
        p_salary            IN employees.salary%TYPE,
        p_commission_pct    IN employees.commission_pct%TYPE,
--        p_manager_id        IN employees.manager_id%TYPE,
        p_department_name   IN departments.department_name%TYPE,
        p_status            OUT VARCHAR2,
        p_error             OUT VARCHAR2,
        p_loc_name          in locations.location_id%TYPE,
        p_dept_manager_name in employees.employee_id%TYPE
    ) AS
    P_LOCATION_NAME locations.city%type;
    ln_department_id departments.department_id%type;
        ln_count NUMBER;
        LN_LOC_ID locations.location_id%type;
        LN_MANAGER_ID employees.employee_id%type;
    BEGIN
        dbms_output.put_line('insert validate');
        p_status := 'V';   
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
            SELECT
                COUNT(*)
            INTO ln_count
            FROM
                jobs
            WHERE
                lower(job_title) = lower(p_job_title);

            IF ln_count = 0 THEN
                p_status := 'E';
                p_error := p_error || 'JOB TITLE MUST EXISTS IN JOB TABLE';
            END IF;

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
--
--        IF length(p_manager_id) > 3 THEN
--            p_status := 'E';
--            p_error := p_error || 'length of manager_id is exceed.';
--        ELSE
--            SELECT
--                COUNT(*)
--            INTO ln_count
--            FROM
--                employees
--            WHERE
--                employee_id = p_manager_id;
--
--            IF ln_count <1 THEN
--                p_status := 'E';
--                p_error := p_error || 'A manager  SHOULD BE employee';
--            END IF;
--
--        END IF;
--department_id validation.
        BEGIN
            SELECT
                department_id
            INTO ln_department_id
            FROM
                departments
            WHERE
                upper(department_name) = upper(p_department_name);

        EXCEPTION
            WHEN others THEN
                BEGIN
                    SELECT
                        location_id
                    INTO ln_loc_id
                    FROM
                        locations
                    WHERE
                        lower(city) = lower(p_location_name);

                EXCEPTION
                    WHEN OTHERS THEN
                        dbms_output.put_line('location doesnt exist');
                END;

                SELECT
                    employee_id
                INTO ln_manager_id
                FROM
                    employees
                WHERE
                    upper(first_name) = upper(p_dept_manager_name);
                    begin
name_to_id_in_dept.mainn(DEPARTMENTS_SEQ.nextval, p_department_name, ln_manager_id, ln_loc_id, p_status,
                            p_error); 
                            exception when others then 
dbms_output.put_line(sqlcode||'-'||sqlcode);
end;
        END;

        IF p_status = 'V' THEN
            insert_emp(p_employee_id, p_first_name, p_last_name, p_email, p_phone_number,
                      p_hire_date, p_job_title, p_salary, p_commission_pct, 
                      p_department_name,P_STATUS,P_ERROR,LN_LOC_NAME,LN_DEPT_MANAGER_NAME);
        END IF;

    END validate_insert;
                        
                        
/***************************PROCEDURE MAIN*************************************************/
    PROCEDURE mainn (
        p_employee_id       IN employees.employee_id%TYPE,
        p_first_name        IN employees.first_name%TYPE,
        p_last_name         IN employees.last_name%TYPE,
        p_email             IN employees.email%TYPE,
        p_phone_number      IN employees.phone_number%TYPE,
        p_hire_date         IN employees.hire_date%TYPE,
        p_job_title         IN jobs.job_title%TYPE,
        p_salary            IN employees.salary%TYPE,
        p_commission_pct    IN employees.commission_pct%TYPE,
--        p_manager_id        IN employees.manager_id%TYPE,
      p_department_name   IN departments.department_name%TYPE,
        p_status            OUT VARCHAR2,
        p_error             OUT VARCHAR2,
        p_loc_name          in locations.location_id%TYPE,
        p_dept_manager_name in employees.employee_id%TYPE)
        AS
BEGIN
IF P_employee_id IS  NULL then
validate_insert( p_employee_id ,
    p_first_name       ,
    p_last_name        ,
    p_email            ,
    p_phone_number     ,
    p_hire_date        ,
    p_job_title        ,
    p_salary           ,
   p_commission_pct   ,
--    p_manager_id       ,
    p_department_name  ,
    p_status           ,
    p_error            ,
    p_loc_name         ,
    p_dept_manager_name 
);
ELSE
update_EMP(
    p_employee_id  ,
    p_first_name   ,
    p_last_name    ,
    p_email        ,
    p_phone_number ,
    p_hire_date    ,
    p_job_title    ,
    p_salary       ,
    p_commission_pct ,
    p_manager_id     ,
    p_department_name,
    p_loc_name       ,
    p_dept_manager_name,
    p_status           ,
    p_error            
);
END IF;
EXCEPTION WHEN OTHERS THEN
dbms_output.put_line('error occured '||sqlcode||'-'||sqlerrm);

    end mainn;
    
end xx_emp_more;





-----------------------------calling---------------------------------------------

deCLARE
lc_status varchar2(20);
LC_ERROR VARCHAR2(3000);
begin
xx_emp_more.MAINN( 207,'DPNSHU','SHUKLA','DS@G.COM',7896098765,'97-JUN-04','AC_ACCOUNT',19500,0.1,'Administration','Roma',LC_STATUS,LC_ERROR);
DBMS_OUTPUT.pUT_LINE(LC_STATUS||'-'||LC_ERROR);
end;

SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM LOCATIONS;