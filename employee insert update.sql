

----------------------------------satarting of procedure for updation and validation IN EMPLOYEE TABLE------------------------------------------------------------




CREATE OR REPLACE PACKAGE proce AS

/************************************************************************************************************************************************************

package to validatee_insert and validate_update the data


WHO                          VERSION                             WHEN                                           WHY              
RACHIT PANWAR                1.0.0                               30-JUNE-2023                          TO MAKE A PROCEDURE SPEC FOR VALIDATION AND UPDATION


**************************************************************************************************************************************************************/
    PROCEDURE validate_insert (
        p_emp_id   IN employees.employee_id%TYPE,
        p_fname in    employees.first_name%TYPE,
        p_lname  in  employees.last_name%TYPE,
        p_email   in employees.email%TYPE,
        p_phno   in  employees.phone_number%TYPE,
        p_hdate   in employees.hire_date%TYPE,
        p_job_id  in jobs.job_id%TYPE,
        p_salary in  employees.salary%TYPE,
        p_comm_pct in employees.commission_pct%TYPE,
        p_mgr_id  in employees.manager_id%TYPE,
        p_dept_id in departments.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    );

    PROCEDURE validate_update (
        p_emp_id   IN employees.employee_id%TYPE,
        p_fname    employees.first_name%TYPE,
        p_lname    employees.last_name%TYPE,
        p_email    employees.email%TYPE,
        p_phno     employees.phone_number%TYPE,
        p_hdate    employees.hire_date%TYPE,
        p_job_id   jobs.job_id%TYPE,
        p_salary   employees.salary%TYPE,
        p_comm_pct employees.commission_pct%TYPE,
        p_mgr_id   employees.manager_id%TYPE,
        p_dept_id  departments.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    );

    PROCEDURE load_data_insert (
        p_emp_id   IN employees.employee_id%TYPE,
        p_fname  in  employees.first_name%TYPE,
        p_lname   in employees.last_name%TYPE,
        p_email  in  employees.email%TYPE,
        p_phno   in  employees.phone_number%TYPE,
        p_hdate   in employees.hire_date%TYPE,
        p_job_id  in jobs.job_id%TYPE,
        p_salary  in employees.salary%TYPE,
        p_comm_pct in employees.commission_pct%TYPE,
        p_mgr_id  in  employees.manager_id%TYPE,
        p_dept_id  in departments.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    );

    PROCEDURE load_data_updte (
        p_emp_id   IN employees.employee_id%TYPE,
        p_fname   in employees.first_name%TYPE,
        p_lname   in employees.last_name%TYPE,
        p_email   in employees.email%TYPE,
        p_phno    in employees.phone_number%TYPE,
        p_hdate   in employees.hire_date%TYPE,
        p_job_id  in jobs.job_id%TYPE,
        p_salary  in employees.salary%TYPE,
        p_comm_pct in employees.commission_pct%TYPE,
        p_mgr_id  in employees.manager_id%TYPE,
        p_dept_id in departments.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    );

    PROCEDURE main (
        p_emp_id   IN employees.employee_id%TYPE,
        p_fname  in  employees.first_name%TYPE,
        p_lname   in employees.last_name%TYPE,
        p_email   in employees.email%TYPE,
        p_phno   in  employees.phone_number%TYPE,
        p_hdate   in employees.hire_date%TYPE,
        p_job_id in  jobs.job_id%TYPE,
        p_salary  in employees.salary%TYPE,
        p_comm_pct in employees.commission_pct%TYPE,
        p_mgr_id  in  employees.manager_id%TYPE,
        p_dept_id in departments.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    );

END proce;
----------------------------------------------------------end------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY proce AS
/************************************************************************************************************************************************************

package body to validatee_insert and validate_update the data FROM EMPLOYEES

WHO                          VERSION                             WHEN                                           WHY              
RACHIT PANWAR                1.0.0                               30-JUNE-2023                          TO MAKE A PROCEDURE SPEC FOR VALIDATION AND UPDATION

************************************************************************************************************************************************************/


    gn_count    NUMBER := 0;
    gn_hiredate DATE;

/***************************************************************************************************************************************

PROCEDURE TO VALIDATE OUR INSERTED VALUES

****************************************************************************************************************************************/
    PROCEDURE validate_insert (
        p_emp_id   IN employees.employee_id%TYPE,
        p_fname    IN employees.first_name%TYPE,
        p_lname    IN employees.last_name%TYPE,
        p_email    IN employees.email%TYPE,
        p_phno     IN employees.phone_number%TYPE,
        p_hdate    IN employees.hire_date%TYPE,
        p_job_id   IN jobs.job_id%TYPE,
        p_salary   IN employees.salary%TYPE,
        p_comm_pct IN employees.commission_pct%TYPE,
        p_mgr_id   IN employees.manager_id%TYPE,
        p_dept_id  IN departments.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    ) AS
    BEGIN
        p_status := 'V';
        BEGIN
            IF p_emp_id IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'employee_id cant be null';
            ELSE
                IF p_emp_id < 0 THEN
                    p_status := 'e';
                    p_error := p_error || ' employee_id should be greater than zero';
                ELSE
                    SELECT
                        COUNT(*)
                    INTO gn_count
                    FROM
                        employees
                    WHERE
                        employee_id = p_emp_id;

                    IF gn_count > 0 THEN
                        p_status := 'e';
                        p_error := p_error || 'duplicate value you cant take duplicate value';
                    END IF;

                END IF;
            END IF;

        END;

        BEGIN
            IF length(p_fname) > 20 THEN
                p_status := 'e';
                p_error := p_error || 'length of first_name cant be greater than 20';
            ELSE
                IF p_fname IS NULL THEN
                    p_status := 'e';
                    p_error := p_error || 'name cant be null';
                END IF;
            END IF;
        END;

        BEGIN
            IF length(p_lname) > 20 THEN
                p_status := 'e';
                p_error := p_error || 'lemgth of last name cant be greater than 20';
            ELSE
                IF p_lname IS NULL THEN
                    p_status := 'e';
                    p_error := p_error || 'last name cant be null';
                END IF;
            END IF;
        END;

        BEGIN
            IF p_email IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'email cant be null';
            ELSE
                IF instr(p_email, '.') = 1 THEN
                    p_status := 'e';
                    p_error := p_error || 'email should have only 1 dot';
                END IF;
            END IF;
        END;

        BEGIN
            IF p_phno IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'phone number cannot be null';
            ELSE
                IF length(p_phno) > 10 THEN
                    p_status := 'e';
                    p_error := p_error || ' length of phno cant be greater than 10';
                END IF;
            END IF;
        END;

        BEGIN
            IF p_hdate IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'hire date cant be null';
            END IF;
        END;

        BEGIN
            IF p_job_id IS NULL THEN
                p_status := 'e';
                p_error := p_error || ' job id cannot be null';
            END IF;
        END;

        BEGIN
            IF p_salary IS NULL THEN
                p_status := 'e';
                p_error := p_error || ' SALARY CANNOT BE NULL';
            ELSE
                IF p_salary < 5000 THEN
                    p_status := 'E';
                    p_error := p_error || ' SALARY CANNOT BE LESS THEN 5000';
                END IF;
            END IF;
        END;

        BEGIN
            IF p_comm_pct < 0 THEN
                p_status := 'E';
                p_error := p_error || 'COMMISSION PCT CANNOT BE NEGATIVVE';
            END IF;
        END;

        BEGIN
            IF p_mgr_id < 0 THEN
                p_status := 'E';
                p_error := p_error || 'manager id CANNOT BE NEGATIVVE';
            END IF;
        END;

        BEGIN
            IF p_dept_id IS NULL THEN
                p_status := 'E';
                p_error := p_error || 'department is  CANNOT BE Null';
            END IF;
        END;

    END validate_insert;         

/**************************************************************************************************************************************************

PROCEDURE  TO VALIDARE OUR UPDATED VALUE

*************************************************************************************************************************************************/

    PROCEDURE validate_update (
        p_emp_id   IN employees.employee_id%TYPE,
        p_fname   in employees.first_name%TYPE,
        p_lname  in  employees.last_name%TYPE,
        p_email  in  employees.email%TYPE,
        p_phno   in  employees.phone_number%TYPE,
        p_hdate   in employees.hire_date%TYPE,
        p_job_id in  jobs.job_id%TYPE,
        p_salary  in employees.salary%TYPE,
        p_comm_pct in employees.commission_pct%TYPE,
        p_mgr_id  in employees.manager_id%TYPE,
        p_dept_id  in departments.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    ) AS
    BEGIN
        BEGIN
            IF p_emp_id IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'employee_id cant be null';
            ELSE
                IF p_emp_id < 0 THEN
                    p_status := 'e';
                    p_error := p_error || ' employee_id should be greater than zero';
                ELSE
                    SELECT
                        COUNT(*)
                    INTO gn_count
                    FROM
                        employees
                    WHERE
                        employee_id = p_emp_id;

                    IF gn_count > 0 THEN
                        p_status := 'e';
                        p_error := p_error || 'duplicate value you cant take duplicate value';
                    END IF;

                END IF;
            END IF;
        END;

        BEGIN
            IF length(p_fname) > 20 THEN
                p_status := 'e';
                p_error := p_error || 'length of first_name cant be greater than 20';
            ELSE
                IF p_fname IS NULL THEN
                    p_status := 'e';
                    p_error := p_error || 'name cant be null';
                END IF;
            END IF;

        END;

        BEGIN
            IF length(p_lname) > 20 THEN
                p_status := 'e';
                p_error := p_error || 'lemgth of last name cant be greater than 20';
            ELSE
                IF p_lname IS NULL THEN
                    p_status := 'e';
                    p_error := p_error || 'last name cant be null';
                END IF;
            END IF;
        END;

        BEGIN
            IF p_email IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'email cant be null';
            ELSE
                IF instr(p_email, '.') = 1 THEN
                    p_status := 'e';
                    p_error := p_error || 'email should have only 1 dot';
                END IF;
            END IF;
        END;

        BEGIN
            IF p_phno IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'phone number cannot be null';
            ELSE
                IF length(p_phno) > 10 THEN
                    p_status := 'e';
                    p_error := p_error || ' length of phno cant be greater than 10';
                END IF;
            END IF;
        END;

        BEGIN
            SELECT
                COUNT(1)
            INTO gn_count
            FROM
                employees
            WHERE
                employee_id = p_emp_id;

            IF gn_count > 1 THEN
                p_status := 'e';
                p_error := p_error || 'hire date cant be CHANGED';
            END IF;

        END;

        BEGIN
            IF p_job_id IS NULL THEN
                p_status := 'e';
                p_error := p_error || ' job id cannot be null';
            END IF;
        END;

        BEGIN
            IF p_salary IS NULL THEN
                p_status := 'e';
                p_error := p_error || ' SALARY CANNOT BE NULL';
            ELSE
                IF p_salary < 5000 THEN
                    p_status := 'E';
                    p_error := p_error || ' SALARY CANNOT BE LESS THEN 5000';
                END IF;
            END IF;
        END;

        BEGIN
            IF p_comm_pct < 0 THEN
                p_status := 'E';
                p_error := p_error || 'COMMISSION PCT CANNOT BE NEGATIVVE';
            END IF;
        END;

        BEGIN
            IF p_mgr_id < 0 THEN
                p_status := 'E';
                p_error := p_error || 'manager id CANNOT BE GATIVVE';
            END IF;
        END;

        BEGIN
            IF p_dept_id IS NULL THEN
                p_status := 'E';
                p_error := p_error || 'department is  CANNOT BE Null';
            END IF;
        END;

    END validate_update;
/**********************************************************************************************************************************************

PROCEDURE TO LOAD OUR DATA IN DATABASE

************************************************************************************************************************************************/

    PROCEDURE load_data_insert (
        p_emp_id   IN employees.employee_id%TYPE,
        p_fname    IN employees.first_name%TYPE,
        p_lname    IN employees.last_name%TYPE,
        p_email    IN employees.email%TYPE,
        p_phno     IN employees.phone_number%TYPE,
        p_hdate    IN employees.hire_date%TYPE,
        p_job_id   IN jobs.job_id%TYPE,
        p_salary   IN employees.salary%TYPE,
        p_comm_pct IN employees.commission_pct%TYPE,
        p_mgr_id   IN employees.manager_id%TYPE,
        p_dept_id  IN departments.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    ) AS
    BEGIN
        INSERT INTO employees  VALUES (
            p_emp_id,
            p_fname,
            p_lname,
            p_email,
            p_phno,
            p_hdate,
            p_job_id,
            p_salary,
            p_comm_pct,
            p_mgr_id,
            p_dept_id
        );

        COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || sqlcode
                       || sqlerrm;
    END load_data_insert;

/*************************************************************************************************************************************

PROCEDURE TO LOAD OUR UPDATED DATA

******************************************************************************************************************************************/

    PROCEDURE load_data_updte (
        p_emp_id   IN employees.employee_id%TYPE,
        p_fname in   employees.first_name%TYPE,
        p_lname  in  employees.last_name%TYPE,
        p_email   in employees.email%TYPE,
        p_phno   in  employees.phone_number%TYPE,
        p_hdate   in employees.hire_date%TYPE,
        p_job_id  in JOBS.job_id%TYPE,
        p_salary  in employees.salary%TYPE,
        p_comm_pct in employees.commission_pct%TYPE,
        p_mgr_id in  employees.manager_id%TYPE,
        p_dept_id in DEPARTMENTS.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    ) AS
    BEGIN
        IF p_status = 'e' THEN
            p_error := p_error || 'data cant be update';
        ELSE
            UPDATE employees
            SET
                employee_id = nvl(employee_id, p_emp_id),
                first_name = nvl(first_name, p_fname),
                last_name = nvl(last_name, p_lname),
                email = nvl(email, p_email),
                phone_number = nvl(phone_number, p_phno),
                hire_date = nvl(hire_date, p_hdate),
                job_id = nvl(job_id, p_job_id),
                salary = nvl(salary, p_salary),
                commission_pct = nvl(commission_pct, p_comm_pct),
                manager_id = nvl(manager_id, p_mgr_id),
                department_id = nvl(department_id, p_dept_id);

        END IF;
    END load_data_updte;

/***************************************************************************************************************************************

MAIN PROCEDURE

********************************************************************************************************************************************/

    PROCEDURE main (
        p_emp_id   IN employees.employee_id%TYPE,
        p_fname    employees.first_name%TYPE,
        p_lname    employees.last_name%TYPE,
        p_email    employees.email%TYPE,
        p_phno     employees.phone_number%TYPE,
        p_hdate    employees.hire_date%TYPE,
        p_job_id   jobs.job_id%TYPE,
        p_salary   employees.salary%TYPE,
        p_comm_pct employees.commission_pct%TYPE,
        p_mgr_id   employees.manager_id%TYPE,
        p_dept_id  departments.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    ) AS
    BEGIN
            if p_status='v'
        then
      load_data_insert (
        p_emp_id  ,
        p_fname   ,
        p_lname   ,
        p_email   ,
        p_phno    ,
        p_hdate    ,
        p_job_id   ,
        p_salary   ,
        p_comm_pct ,
        p_mgr_id   ,
        p_dept_id, p_status,
        p_error);  
    end if;


        IF p_emp_id IS NULL THEN
            validate_insert(p_emp_id, p_fname, p_lname, p_email, p_phno,
                           p_hdate, p_job_id, p_salary, p_comm_pct, p_mgr_id,
                           p_dept_id, p_status, p_error);

        ELSE
            validate_update(p_emp_id, p_fname, p_lname, p_email, p_phno,
                           p_hdate, p_job_id, p_salary, p_comm_pct, p_mgr_id,
                           p_dept_id, p_status, p_error);
        END IF;
EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || sqlcode
                       || sqlerrm;
    END main;

END proce;


--------------------------------------------CALLING OF PACKAGE------------------------------------------------------------------
select * from employees;
DECLARE 
l_e varchar2(2000);
l_s varchar2(3000);
begin
proce.load_data_insert( 208,'dipanshu','shukla', 'd.shukla','123.456.345.1',TO_DATE('07-jun-2001'),'HR_REP', 5600,0.3,100,110,l_e,l_s);
end;