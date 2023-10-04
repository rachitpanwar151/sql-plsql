create or replace package body xx_emp
as
procedure updatee (p_employee_id    IN employees.employee_id%TYPE,
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
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2)
        as
        lc_job_id varchar2(30);
        ln_dept_id number;
        begin
        dbms_output.put_line('update');
        if p_job_title is not null
        then
        select job_id into lc_job_id from jobs where job_title=p_job_title; 
        if p_department_name is not null
        then
          select department_id into ln_dept_id from departments where department_name=p_department_name;
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
            end if;
            end if;

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Error while updating data'
                                 || sqlcode
                                 || '-'
                                 || sqlerrm);
    END updatee;
    procedure insertt(
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
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2)
        as
        lc_job_id  varchar2(30);
        ln_dept_id number;
        begin
        dbms_output.put_line('insert');
        begin
        select job_id into lc_job_id from jobs where job_title=p_job_title; 
        
        
    exception when others then
    dbms_output.put_line('job id  doesnt exist'||sqlcode||'-'||sqlerrm);
    end;
        begin
        select department_id into ln_dept_id from departments where department_name=p_department_name;
        
    exception when others then
    dbms_output.put_line(' dept id  doesnt exist'||sqlcode||'-'||sqlerrm);
    
        end;
        insert into employees values(
        p_employee_id   ,
        p_first_name    ,
        p_last_name     ,
        p_email         ,
        p_phone_number   ,
        p_hire_date      ,
        lc_job_id      ,
        p_salary        , 
        p_commission_pct ,
        p_manager_id     ,
        ln_dept_id);
        
    exception when others then
    dbms_output.put_line(sqlcode||'-'||sqlerrm);
    
        end insertt;
        
    
    procedure VALIDATE_INSERTT(p_employee_id    IN employees.employee_id%TYPE,
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
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2)
        as
        ln_count number;
        begin
        dbms_output.put_line('insert validate');
        p_status := 'V';   
   --EMPLOYEE_ID VALIDATION.  
        dbms_output.put_line('VALIDATING INSERTED DATA 1');
        IF p_employee_id IS NULL THEN
            p_status := 'E';
            p_error := p_error || 'employee_id cant be null';
            ELSE
                SELECT
                    COUNT(*)
                INTO ln_count
                FROM
                    employees
                WHERE
                    employee_id = p_employee_id;

                IF ln_count > 0 THEN
                    p_status := 'E';
                    p_error := p_error || 'you cant take duplicate value in employee_id';
                END IF;

        
        END IF;

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
        ELSIF length(p_LAST_name) > 20 THEN
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
            IF instr(p_email, '@') = 0 AND instr(p_email, '.com') = 0 THEN
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
        ELSIF length(p_phone_number)<> 10 THEN
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
               LOWER( job_title)=LOWER(p_job_title);

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

        IF length(p_manager_id) > 3 THEN
            p_status := 'E';
            p_error := p_error || 'length of manager_id is exceed.';
        ELSE
            SELECT
                COUNT(*)
            INTO Ln_count
            FROM
                employees
            WHERE
               employee_id= p_manager_id;

            IF Ln_count > 1 THEN
                p_status := 'E';
                p_error := p_error || 'manager ID SHOULD BE employee';
            END IF;

        END IF;
--department_id validation.
        IF length(p_department_name) > 3 THEN
            p_status := 'E';
            p_error := p_error || 'length of department_id is exceed.';
        ELSE
            SELECT
                COUNT(*)
            INTO ln_count
            FROM
                departments
            WHERE
                department_name = p_department_name;

            IF ln_count = 0 THEN
                p_status := 'E';
                p_error := p_error || 'atlest one employee should be there in department.';
            END IF;

        END IF;

        IF ( p_status = 'V' ) THEN
            insertT(p_employee_id, p_first_name, p_last_name, p_email, p_phone_number,
                       p_hire_date, p_job_TITLE, p_salary, p_commission_pct, p_manager_id,
                       p_department_name,p_status,p_error);
        END IF;
end validate_insertt;

procedure validate_update
       ( p_employee_id    IN employees.employee_id%TYPE,
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
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2
    ) AS
    LN_COUNT NUMBER:=0;
    BEGIN
    dbms_output.put_line('validate update');
        p_status := 'v';
--EMAIL UPDATE VALIDATION.
        IF instr(p_email, '@') = 0 OR instr(p_email, 'com') = 0 THEN
            p_status := 'E';
            p_error := p_error || 'INVALID EMAIL.';
        ELSE
            SELECT
                COUNT(*)
            INTO Ln_count
            FROM
                employees
            WHERE
                email = p_email;

            IF Ln_count > 1 THEN
                p_status := 'E';
                p_error := p_error || 'EMAIL REPETED.';
            END IF;

        END IF;
--PHONE UPDATE VALIDATION.
        IF length(p_phone_number) > 10 THEN
            p_status := 'E';
            p_error := p_error || 'phone number can not be grater then 10';
        ELSE
            SELECT
                COUNT(*)
            INTO Ln_count
            FROM
                employees
            WHERE
                phone_number = p_phone_number;

            IF Ln_count > 0 THEN
                p_status := 'E';
                p_error := p_error || 'you cant take duplicate value in phone_number';
            END IF;

        END IF;


 --JOB_ID VALIDATION.                  
        SELECT
            COUNT(*)
        INTO Ln_count
        FROM
            jobs
        WHERE
             job_TITLE=p_job_TITLE;

        IF Ln_count = 0 THEN
            p_status := 'E';
            p_error := p_error || 'atleast one employee should be there in job';
        END IF;   

--SALARY UPDATE VALIDATION
        IF p_salary < 10000 THEN
            p_status := 'E';
            p_error := p_error || 'minimum salary is 10000.';
        ELSIF length(p_salary) > 8 THEN
            p_status := 'E';
            p_error := p_error || 'salary range exceed';
        END IF; 

--COMMISSION PCT UPDATE VALIDATION.
        IF p_commission_pct < 0 THEN
            p_status := 'E';
            p_error := p_error || 'commission can not be in negative.';
        ELSIF p_commission_pct > 0.5 THEN
            p_status := 'E';
            p_error := p_error || 'commission limit exceed.';
        END IF;

----MANAGER_ID UPDATE VALIDATION.
        IF length(p_manager_id) > 3 THEN
            p_status := 'E';
            p_error := p_error || 'length of manager_id is exceed.';
        ELSE
            SELECT
                COUNT(*)
            INTO Ln_count
            FROM
                employees
            WHERE
                p_manager_id = employee_id;

            IF Ln_count > 1 THEN
                p_status := 'E';
                p_error := p_error || 'manager employee_id should be 1.';
            END IF;

        END IF;

----department_name validation.
        IF (p_department_name) is null THEN
            p_status := 'E';
            p_error := p_error || 'department name cannot be null';
        ELSE
            SELECT
                COUNT(*)
            INTO Ln_count
            FROM
                departments
            WHERE
                department_name = p_department_name;

            IF Ln_count = 0 THEN
                p_status := 'E';
                p_error := p_error || 'atlest one employee should be there in department.';
            END IF;

        END IF;

        IF ( p_status = 'V' ) THEN
            updatee(p_employee_id, p_first_name, p_last_name, p_email, p_phone_number,
                       p_hire_date, p_job_title
                       , p_salary, p_commission_pct, p_manager_id,
                       p_department_name,p_status,p_error);
        END IF;
end validate_update;



    PROCEDURE mainn   ( p_employee_id    IN employees.employee_id%TYPE,
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
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2
    )AS
    ln_count number:=0;
    BEGIN
        SELECT
            COUNT(*)
        INTO ln_count
        FROM
            employees
        WHERE
           employee_id=p_employee_id;

        IF ln_count = 0 THEN
            validate_insertt(p_employee_id, p_first_name, p_last_name, p_email, p_phone_number,
                               p_hire_date,  p_job_title, p_salary, p_commission_pct, p_manager_id,
                               p_department_name, p_status, p_error);

        ELSE
            validate_update(p_employee_id, p_first_name, p_last_name, p_email, p_phone_number,
                               p_hire_date, p_job_title
                               , p_salary, p_commission_pct, p_manager_id,
                               p_department_name, p_status, p_error);
        END IF;

    END mainn;
    end create or replace package body xx_emp
as
procedure updatee (p_employee_id    IN employees.employee_id%TYPE,
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
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2)
        as
        lc_job_id varchar2(30);
        ln_dept_id number;
        begin
        dbms_output.put_line('update');
        if p_job_title is not null
        then
        select job_id into lc_job_id from jobs where job_title=p_job_title; 
        if p_department_name is not null
        then
          select department_id into ln_dept_id from departments where department_name=p_department_name;
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
            end if;
            end if;

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Error while updating data'
                                 || sqlcode
                                 || '-'
                                 || sqlerrm);
    END updatee;
    procedure insertt(
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
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2)
        as
        lc_job_id  varchar2(30);
        ln_dept_id number;
        begin
        dbms_output.put_line('insert');
        begin
        select job_id into lc_job_id from jobs where job_title=p_job_title; 
        
        
    exception when others then
    dbms_output.put_line('job id  doesnt exist'||sqlcode||'-'||sqlerrm);
    end;
        begin
        select department_id into ln_dept_id from departments where department_name=p_department_name;
        
    exception when others then
    dbms_output.put_line(' dept id  doesnt exist'||sqlcode||'-'||sqlerrm);
    
        end;
        insert into employees values(
        p_employee_id   ,
        p_first_name    ,
        p_last_name     ,
        p_email         ,
        p_phone_number   ,
        p_hire_date      ,
        lc_job_id      ,
        p_salary        , 
        p_commission_pct ,
        p_manager_id     ,
        ln_dept_id);
        
    exception when others then
    dbms_output.put_line(sqlcode||'-'||sqlerrm);
    
        end insertt;
        
    
    procedure VALIDATE_INSERTT(p_employee_id    IN employees.employee_id%TYPE,
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
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2)
        as
        ln_count number;
        begin
        dbms_output.put_line('insert validate');
        p_status := 'V';   
   --EMPLOYEE_ID VALIDATION.  
        dbms_output.put_line('VALIDATING INSERTED DATA 1');
        IF p_employee_id IS NULL THEN
            p_status := 'E';
            p_error := p_error || 'employee_id cant be null';
            ELSE
                SELECT
                    COUNT(*)
                INTO ln_count
                FROM
                    employees
                WHERE
                    employee_id = p_employee_id;

                IF ln_count > 0 THEN
                    p_status := 'E';
                    p_error := p_error || 'you cant take duplicate value in employee_id';
                END IF;

        
        END IF;

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
        ELSIF length(p_LAST_name) > 20 THEN
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
            IF instr(p_email, '@') = 0 AND instr(p_email, '.com') = 0 THEN
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
        ELSIF length(p_phone_number)<> 10 THEN
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
               LOWER( job_title)=LOWER(p_job_title);

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

        IF length(p_manager_id) > 3 THEN
            p_status := 'E';
            p_error := p_error || 'length of manager_id is exceed.';
        ELSE
            SELECT
                COUNT(*)
            INTO Ln_count
            FROM
                employees
            WHERE
               employee_id= p_manager_id;

            IF Ln_count > 1 THEN
                p_status := 'E';
                p_error := p_error || 'manager ID SHOULD BE employee';
            END IF;

        END IF;
--department_id validation.
        IF length(p_department_name) > 3 THEN
            p_status := 'E';
            p_error := p_error || 'length of department_id is exceed.';
        ELSE
            SELECT
                COUNT(*)
            INTO ln_count
            FROM
                departments
            WHERE
                department_name = p_department_name;

            IF ln_count = 0 THEN
                p_status := 'E';
                p_error := p_error || 'atlest one employee should be there in department.';
            END IF;

        END IF;

        IF ( p_status = 'V' ) THEN
            insertT(p_employee_id, p_first_name, p_last_name, p_email, p_phone_number,
                       p_hire_date, p_job_TITLE, p_salary, p_commission_pct, p_manager_id,
                       p_department_name,p_status,p_error);
        END IF;
end validate_insertt;

procedure validate_update
       ( p_employee_id    IN employees.employee_id%TYPE,
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
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2
    ) AS
    LN_COUNT NUMBER:=0;
    BEGIN
    dbms_output.put_line('validate update');
        p_status := 'v';
--EMAIL UPDATE VALIDATION.
        IF instr(p_email, '@') = 0 OR instr(p_email, 'com') = 0 THEN
            p_status := 'E';
            p_error := p_error || 'INVALID EMAIL.';
        ELSE
            SELECT
                COUNT(*)
            INTO Ln_count
            FROM
                employees
            WHERE
                email = p_email;

            IF Ln_count > 1 THEN
                p_status := 'E';
                p_error := p_error || 'EMAIL REPETED.';
            END IF;

        END IF;
--PHONE UPDATE VALIDATION.
        IF length(p_phone_number) > 10 THEN
            p_status := 'E';
            p_error := p_error || 'phone number can not be grater then 10';
        ELSE
            SELECT
                COUNT(*)
            INTO Ln_count
            FROM
                employees
            WHERE
                phone_number = p_phone_number;

            IF Ln_count > 0 THEN
                p_status := 'E';
                p_error := p_error || 'you cant take duplicate value in phone_number';
            END IF;

        END IF;


 --JOB_ID VALIDATION.                  
        SELECT
            COUNT(*)
        INTO Ln_count
        FROM
            jobs
        WHERE
             job_TITLE=p_job_TITLE;

        IF Ln_count = 0 THEN
            p_status := 'E';
            p_error := p_error || 'atleast one employee should be there in job';
        END IF;   

--SALARY UPDATE VALIDATION
        IF p_salary < 10000 THEN
            p_status := 'E';
            p_error := p_error || 'minimum salary is 10000.';
        ELSIF length(p_salary) > 8 THEN
            p_status := 'E';
            p_error := p_error || 'salary range exceed';
        END IF; 

--COMMISSION PCT UPDATE VALIDATION.
        IF p_commission_pct < 0 THEN
            p_status := 'E';
            p_error := p_error || 'commission can not be in negative.';
        ELSIF p_commission_pct > 0.5 THEN
            p_status := 'E';
            p_error := p_error || 'commission limit exceed.';
        END IF;

----MANAGER_ID UPDATE VALIDATION.
        IF length(p_manager_id) > 3 THEN
            p_status := 'E';
            p_error := p_error || 'length of manager_id is exceed.';
        ELSE
            SELECT
                COUNT(*)
            INTO Ln_count
            FROM
                employees
            WHERE
                p_manager_id = employee_id;

            IF Ln_count > 1 THEN
                p_status := 'E';
                p_error := p_error || 'manager employee_id should be 1.';
            END IF;

        END IF;

----department_name validation.
        IF (p_department_name) is null THEN
            p_status := 'E';
            p_error := p_error || 'department name cannot be null';
        ELSE
            SELECT
                COUNT(*)
            INTO Ln_count
            FROM
                departments
            WHERE
                department_name = p_department_name;

            IF Ln_count = 0 THEN
                p_status := 'E';
                p_error := p_error || 'atlest one employee should be there in department.';
            END IF;

        END IF;

        IF ( p_status = 'V' ) THEN
            updatee(p_employee_id, p_first_name, p_last_name, p_email, p_phone_number,
                       p_hire_date, p_job_title
                       , p_salary, p_commission_pct, p_manager_id,
                       p_department_name,p_status,p_error);
        END IF;
end validate_update;



    PROCEDURE mainn   ( p_employee_id    IN employees.employee_id%TYPE,
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
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2
    )AS
    ln_count number:=0;
    BEGIN
        SELECT
            COUNT(*)
        INTO ln_count
        FROM
            employees
        WHERE
           employee_id=p_employee_id;

        IF ln_count = 0 THEN
            validate_insertt(p_employee_id, p_first_name, p_last_name, p_email, p_phone_number,
                               p_hire_date,  p_job_title, p_salary, p_commission_pct, p_manager_id,
                               p_department_name, p_status, p_error);

        ELSE
            validate_update(p_employee_id, p_first_name, p_last_name, p_email, p_phone_number,
                               p_hire_date, p_job_title
                               , p_salary, p_commission_pct, p_manager_id,
                               p_department_name, p_status, p_error);
        END IF;

    END mainn;
    end xx_emp;
    
    
    --------------------------------calling---------------------------------------
    
    
    
    declare
    begin
    end;

;
    
    
    --------------------------------calling---------------------------------------
    
    
    
    declare
    lc_status varchar2(300);
    lc_error varchar2(7000);
    begin
xx_emp.mainn(207,'rachit','panwar','rac.pa@gmail.com','123.456789','05-jun-03','President',17000,0.5,100,'IT',lc_status,lc_error);    
   dbms_output.put_line(lc_status||'-'||lc_error);
   dbms_output.put_line(sqlcode||sqlerrm);
   end;
   
   
    select * from jobs;
    select * from employees;
    select * from departments;