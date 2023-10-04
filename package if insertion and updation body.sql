CREATE OR REPLACE PACKAGE BODY xxintg_v_and_u_data_emp AS

/*****************************************************************
UPDATE PROCEDURE 
*****************************************************************/

    PROCEDURE update_data (
        p_employee_id    IN employees.employee_id%TYPE,
        p_first_name     IN employees.first_name%TYPE,
        p_last_name      IN employees.last_name%TYPE,
        p_email          IN employees.email%TYPE,
        p_phone_number   IN employees.phone_number%TYPE,
        p_hire_date      IN employees.hire_date%TYPE,
        p_job_id         IN jobs.job_id%TYPE,
        p_salary         IN employees.salary%TYPE,
        p_commission_pct IN employees.commission_pct%TYPE,
        p_manager_id     IN employees.manager_id%TYPE,
        p_department_id  IN departments.department_id%TYPE
    ) AS
    BEGIN
        UPDATE employees
        SET
            first_name = nvl(p_first_name, first_name),
            last_name = nvl(p_last_name, last_name),
            email = nvl(p_email, email),
            phone_number = nvl(p_phone_number, phone_number),
            salary = nvl(p_salary, salary),
            job_id = nvl(p_job_id, job_id),
            commission_pct = nvl(p_commission_pct, commission_pct),
            manager_id = nvl(p_manager_id, manager_id),
            department_id = nvl(p_department_id, department_id)
        WHERE
            employee_id = p_employee_id;

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Error while updating data'
                                 || sqlcode
                                 || '-'
                                 || sqlerrm);
    END update_data;

/*******************************************************************************
 INSERT PROCEDURE 
*********************************************************************************/
    PROCEDURE insert_data (
        p_employee_id    IN employees.employee_id%TYPE,
        p_first_name     IN employees.first_name%TYPE,
        p_last_name      IN employees.last_name%TYPE,
        p_email          IN employees.email%TYPE,
        p_phone_number   IN employees.phone_number%TYPE,
        p_hire_date      IN employees.hire_date%TYPE,
        p_job_id         IN jobs.job_id%TYPE,
        p_salary         IN employees.salary%TYPE,
        p_commission_pct IN employees.commission_pct%TYPE,
        p_manager_id     IN employees.manager_id%TYPE,
        p_department_id  IN departments.department_id%TYPE
    ) AS
    BEGIN
        INSERT INTO employees VALUES (
            p_employee_id,
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

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('error while loading data'
                                 || sqlcode
                                 || '-'
                                 || sqlerrm);
            dbms_output.put_line(dbms_utility.format_error_backtrace());
    END insert_data;


/*********************************************************************************
VALIDATE INSERT DATA
**********************************************************************************/
    PROCEDURE validate_insertdata (
        p_employee_id    IN employees.employee_id%TYPE,
        p_first_name     IN employees.first_name%TYPE,
        p_last_name      IN employees.last_name%TYPE,
        p_email          IN employees.email%TYPE,
        p_phone_number   IN employees.phone_number%TYPE,
        p_hire_date      IN employees.hire_date%TYPE,
        p_job_id         IN jobs.job_id%TYPE,
        p_salary         IN employees.salary%TYPE,
        p_commission_pct IN employees.commission_pct%TYPE,
        p_manager_id     IN employees.manager_id%TYPE,
        p_department_id  IN departments.department_id%TYPE,
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2
    ) AS
    BEGIN
        p_status := 'v';   
   --EMPLOYEE_ID VALIDATION.  
        dbms_output.put_line('VALIDATING INSERTED DATA 1');
        IF p_employee_id IS NULL THEN
            p_status := 'e';
            p_error := p_error || 'employee_id cant be null';
        ELSE
            IF p_employee_id < 0 THEN
                p_status := 'e';
                p_error := p_error || ' employee_id should be greater than zero';
            ELSIF length(p_employee_id) > 6 THEN
                p_status := 'e';
                p_error := p_error || ' employee_id should be greater than zero';
            ELSE
                SELECT
                    COUNT(*)
                INTO gn_count
                FROM
                    employees
                WHERE
                    employee_id = p_employee_id;

                IF gn_count > 0 THEN
                    p_status := 'e';
                    p_error := p_error || 'you cant take duplicate value in employee_id';
                END IF;

            END IF;
        END IF;

/*********************************************
first_name validation.
*************************************************/
        IF p_first_name IS NULL THEN
            p_status := 'e';
            p_error := p_error || 'first_name cant be null';
        ELSIF length(p_first_name) > 20 THEN
            p_status := 'e';
            p_error := p_error || 'length of first_name cant be greater than 20';
        END IF;
/*******************************************************
last_name validation.
*************************************************************/

        IF p_last_name IS NULL THEN
            p_status := 'e';
            p_error := p_error || 'last_name cant be null';
        ELSIF length(p_first_name) > 20 THEN
            p_status := 'e';
            p_error := p_error || 'length of last_name cant be greater than 20';
        END IF;

/**********************************************
email validation.        
*****************************************************/
        IF p_email IS NULL THEN
            p_status := 'e';
            p_error := p_error || 'email cant be null';
        ELSE
            IF instr(p_email, '@') = 0 OR instr(p_email, 'com') = 0 THEN
                p_status := 'e';
                p_error := p_error || 'INVALID EMAIL.';
            ELSE
                SELECT
                    COUNT(*)
                INTO gn_count
                FROM
                    employees
                WHERE
                    email = p_email;

                IF gn_count > 1 THEN
                    p_status := 'e';
                    p_error := p_error || 'EMAIL REPETED.';
                END IF;

            END IF;
        END IF;

/*************************************************************
phone number validation.
********************************************************************/
        IF p_phone_number IS NULL THEN
            p_status := 'e';
            p_error := p_error || 'phone number can not be null';
        ELSIF length(p_phone_number) > 10 THEN
            p_status := 'e';
            p_error := p_error || 'phone number can not be grater then 10';
        ELSE
            SELECT
                COUNT(*)
            INTO gn_count
            FROM
                employees
            WHERE
                phone_number = p_phone_number;

            IF gn_count > 0 THEN
                p_status := 'e';
                p_error := p_error || 'you cant take duplicate value in phone_number';
            END IF;

        END IF;

/**********************************************
hire_date validation.
*************************************************/
        IF p_hire_date IS NULL THEN
            p_status := 'e';
            p_error := p_error || 'hire_date can not be null';
        ELSIF p_hire_date > sysdate THEN
            p_status := 'e';
            p_error := p_error || 'hire_date can not be null';
        END IF;

/*************************************************************
job_id validation.
********************************************************************/
        IF p_job_id IS NULL THEN
            p_status := 'e';
            p_error := p_error || 'job_id can not be null';
        ELSE
            SELECT
                COUNT(*)
            INTO gn_count
            FROM
                jobs
            WHERE
                p_job_id = job_id;

            IF gn_count = 0 THEN
                p_status := 'e';
                p_error := p_error || 'atleast one employee should be there in job';
            END IF;

        END IF;
/**********************************************
salary validation.
*************************************************/
        IF p_salary < 10000 THEN
            p_status := 'e';
            p_error := p_error || 'minimum salary is 10000.';
        ELSIF length(p_salary) > 8 THEN
            p_status := 'e';
            p_error := p_error || 'salary range exceed';
        END IF;
/********************************************************
commission validation.
**********************************************************/
        IF p_commission_pct < 0 THEN
            p_status := 'e';
            p_error := p_error || 'commission can not be in negative.';
        ELSIF p_commission_pct > 50 THEN
            p_status := 'e';
            p_error := p_error || 'commission limit exceed.';
        END IF;
/**************************************************************
manager_id validation.
******************************************************************/

        IF length(p_manager_id) > 3 THEN
            p_status := 'e';
            p_error := p_error || 'length of manager_id is exceed.';
        ELSE
            SELECT
                COUNT(*)
            INTO gn_count
            FROM
                employees
            WHERE
                p_manager_id = employee_id;

            IF gn_count > 1 THEN
                p_status := 'e';
                p_error := p_error || 'manager employee_id should be 1.';
            END IF;

        END IF;
--department_id validation.
        IF length(p_department_id) > 3 THEN
            p_status := 'e';
            p_error := p_error || 'length of department_id is exceed.';
        ELSE
            SELECT
                COUNT(*)
            INTO gn_count
            FROM
                departments
            WHERE
                department_id = p_department_id;

            IF gn_count = 0 THEN
                p_status := 'e';
                p_error := p_error || 'atlest one employee should be there in department.';
            END IF;

        END IF;

        IF ( p_status = 'v' ) THEN
            insert_data(p_employee_id, p_first_name, p_last_name, p_email, p_phone_number,
                       p_hire_date, p_job_id, p_salary, p_commission_pct, p_manager_id,
                       p_department_id);
        END IF;

    END validate_insertdata;



/****************************************************************************
UPDATE VALIDATIONS
*******************************************************************************/

    PROCEDURE validate_updatedata (
        p_employee_id    IN employees.employee_id%TYPE,
        p_first_name     IN employees.first_name%TYPE,
        p_last_name      IN employees.last_name%TYPE,
        p_email          IN employees.email%TYPE,
        p_phone_number   IN employees.phone_number%TYPE,
        p_hire_date      IN employees.hire_date%TYPE,
        p_job_id         IN jobs.job_id%TYPE,
        p_salary         IN employees.salary%TYPE,
        p_commission_pct IN employees.commission_pct%TYPE,
        p_manager_id     IN employees.manager_id%TYPE,
        p_department_id  IN departments.department_id%TYPE,
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2
    ) AS
    BEGIN
        p_status := 'v';
--EMAIL UPDATE VALIDATION.
        IF instr(p_email, '@') = 0 OR instr(p_email, 'com') = 0 THEN
            p_status := 'e';
            p_error := p_error || 'INVALID EMAIL.';
        ELSE
            SELECT
                COUNT(*)
            INTO gn_count
            FROM
                employees
            WHERE
                email = p_email;

            IF gn_count > 1 THEN
                p_status := 'e';
                p_error := p_error || 'EMAIL REPETED.';
            END IF;

        END IF;
--PHONE UPDATE VALIDATION.
        IF length(p_phone_number) > 10 THEN
            p_status := 'e';
            p_error := p_error || 'phone number can not be grater then 10';
        ELSE
            SELECT
                COUNT(*)
            INTO gn_count
            FROM
                employees
            WHERE
                phone_number = p_phone_number;

            IF gn_count > 0 THEN
                p_status := 'e';
                p_error := p_error || 'you cant take duplicate value in phone_number';
            END IF;

        END IF;


 --JOB_ID VALIDATION.                  
        SELECT
            COUNT(*)
        INTO gn_count
        FROM
            jobs
        WHERE
            p_job_id = job_id;

        IF gn_count = 0 THEN
            p_status := 'e';
            p_error := p_error || 'atleast one employee should be there in job';
        END IF;   

--SALARY UPDATE VALIDATION
        IF p_salary < 10000 THEN
            p_status := 'e';
            p_error := p_error || 'minimum salary is 10000.';
        ELSIF length(p_salary) > 8 THEN
            p_status := 'e';
            p_error := p_error || 'salary range exceed';
        END IF; 

--COMMISSION PCT UPDATE VALIDATION.
        IF p_commission_pct < 0 THEN
            p_status := 'e';
            p_error := p_error || 'commission can not be in negative.';
        ELSIF p_commission_pct > 0.5 THEN
            p_status := 'e';
            p_error := p_error || 'commission limit exceed.';
        END IF;

----MANAGER_ID UPDATE VALIDATION.
        IF length(p_manager_id) > 3 THEN
            p_status := 'e';
            p_error := p_error || 'length of manager_id is exceed.';
        ELSE
            SELECT
                COUNT(*)
            INTO gn_count
            FROM
                employees
            WHERE
                p_manager_id = employee_id;

            IF gn_count > 1 THEN
                p_status := 'e';
                p_error := p_error || 'manager employee_id should be 1.';
            END IF;

        END IF;

----department_id validation.
        IF length(p_department_id) > 3 THEN
            p_status := 'e';
            p_error := p_error || 'length of department_id is exceed.';
        ELSE
            SELECT
                COUNT(*)
            INTO gn_count
            FROM
                departments
            WHERE
                department_id = p_department_id;

            IF gn_count = 0 THEN
                p_status := 'e';
                p_error := p_error || 'atlest one employee should be there in department.';
            END IF;

        END IF;

        IF ( p_status = 'v' ) THEN
            update_data(p_employee_id, p_first_name, p_last_name, p_email, p_phone_number,
                       p_hire_date, p_job_id, p_salary, p_commission_pct, p_manager_id,
                       p_department_id);
        END IF;

    END validate_updatedata;

/*********************************************************
main procedure
**********************************************************/

    PROCEDURE mainn (
        p_employee_id    IN employees.employee_id%TYPE,
        p_first_name     IN employees.first_name%TYPE,
        p_last_name      IN employees.last_name%TYPE,
        p_email          IN employees.email%TYPE,
        p_phone_number   IN employees.phone_number%TYPE,
        p_hire_date      IN employees.hire_date%TYPE,
        p_job_id         IN jobs.job_id%TYPE,
        p_salary         IN employees.salary%TYPE,
        p_commission_pct IN employees.commission_pct%TYPE,
        p_manager_id     IN employees.manager_id%TYPE,
        p_department_id  IN departments.department_id%TYPE,
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2
    ) AS
    BEGIN
        SELECT
            COUNT(*)
        INTO gn_count
        FROM
            employees
        WHERE
            p_employee_id = employee_id;

        IF gn_count = 0 THEN
            validate_insertdata(p_employee_id, p_first_name, p_last_name, p_email, p_phone_number,
                               p_hire_date, p_job_id, p_salary, p_commission_pct, p_manager_id,
                               p_department_id, p_status, p_error);

        ELSE
            validate_updatedata(p_employee_id, p_first_name, p_last_name, p_email, p_phone_number,
                               p_hire_date, p_job_id, p_salary, p_commission_pct, p_manager_id,
                               p_department_id, p_status, p_error);
        END IF;

    END mainn;

END xxintg_v_and_u_data_emp;


-----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------calling--------------------------------------------------------------
DECLARE
    lc_status VARCHAR2(200);
    lc_error  VARCHAR2(200);
BEGIN
    xxintg_v_and_u_data_emp.mainn(238, 'ROACHIT', 'pan', 'abc.sigh@gmail.com', '4321564890',
                                 sysdate, 'AD_PRES', 12324, 0.4, 100,
                                 20, lc_status, lc_error);

    dbms_output.put_line(lc_status
                         || '-'
                         || nvl(lc_error, 'sucess'));
END;


------------------------END=------------------------------------------------------------
SELECT
    *
FROM
    employees;

SELECT
    *
FROM
    user_sequences;