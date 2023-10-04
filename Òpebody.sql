CREATE OR REPLACE PACKAGE BODY xx_intg_emp AS


/************************************************************************************************************************************************************

package to validatee_insert the data


WHO                          VERSION                             WHEN                                           WHY              
RACHIT PANWAR                1.0.0                               30-JUNE-2023                          TO MAKE A PROCEDURE SPEC FOR VALIDATION AND UPDATION


**************************************************************************************************************************************************************/

gn_mgr_id employees.manager_id%type;
gn_count varchar2(300);
    PROCEDURE vvalidate (
        p_emp_id   IN employees.employee_id%TYPE,
        p_fname    IN employees.first_name%TYPE,
        p_lname    IN employees.last_name%TYPE,
        p_email    IN employees.email%TYPE,
        p_phno     IN employees.phone_number%TYPE,
        p_h_date   IN employees.hire_date%TYPE,
        p_job_id   IN employees.job_id%TYPE,
        p_salary   IN employees.salary%TYPE,
        p_comm_pct IN employees.commission_pct%TYPE,
        p_mgr_id   IN employees.manager_id%TYPE,
        p_dept_id  IN employees.department_id%TYPE,
        p_status   OUT VARCHAR2,
        p_error    OUT VARCHAR2
    ) AS
    begin
    p_status:='v';   
        BEGIN
            IF p_emp_id IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'employee_id cant be null';
            ELSE
                IF p_emp_id < 0 THEN
                    p_status := 'e';
                    p_error := p_error || ' employee_id should be greater than zero';
                ELSE
                    SELECT COUNT(*) into gn_count  FROM  employees where employee_id=p_emp_id;
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
            IF p_h_date IS NULL THEN
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
            SELECT
                COUNT(*)
            INTO gn_mgr_id
            FROM
                employees
            WHERE
                manager_id = gn_mgr_id;

            IF gn_mgr_id = 0 THEN
                p_status := 'E';
                p_error := p_error || 'MANAGER ID CANNOT BE NULL';
            END IF;

        END;

        BEGIN
            IF p_dept_id IS NULL THEN
                p_status := 'E';
                p_error := p_error || 'DEPARTMENT ID CANNOT BE NULL';
            END IF;
        END;

END vvalidate;

    PROCEDURE loaddata (
        p_emp_id   IN employees.employee_id%TYPE,
        p_fname    IN employees.first_name%TYPE,
        p_lname    IN employees.last_name%TYPE,
        p_email    IN employees.email%TYPE,
        p_phno     IN employees.phone_number%TYPE,
        p_h_date   IN employees.hire_date%TYPE,
        p_job_id   IN employees.job_id%TYPE,
        p_salary   IN employees.salary%TYPE,
        p_comm_pct IN employees.commission_pct%TYPE,
        p_mgr_id   IN employees.manager_id%TYPE,
        p_dept_id  IN employees.department_id%TYPE,
        p_status   OUT VARCHAR2,
        p_error    OUT VARCHAR2
    ) AS
    BEGIN
        IF p_status = 'E' THEN
            p_error := p_error || 'CANNOT LOAD DATE';
        ELSE
            INSERT INTO employees VALUES (
                p_emp_id,
                p_fname,
                p_lname,
                p_email,
                p_phno,
                p_h_date,
                p_job_id,
                p_salary,  
                p_comm_pct,
                p_mgr_id,
                p_dept_id
            );

            COMMIT;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || sqlcode
                       || sqlerrm;
    END loaddata;
    
 procedure  maine (p_emp_id in  employees.employee_id%type,
p_fname in employees.first_name%type,
p_lname in employees.last_name%type,
p_email in employees.email%type,
p_phno in employees.phone_number%type,
p_h_date in employees.hire_date%type,
p_job_id in employees.job_id%type,
p_salary in employees.salary%type,
p_comm_pct in employees.commission_pct%type,
p_mgr_id in employees.manager_id%type,
p_dept_id in employees.department_id%type
, p_status out varchar2,
p_error out varchar2)
AS
begin
VValidate(
                p_emp_id,
                p_fname,
                p_lname,
                p_email,
                p_phno,
                p_h_date,
                p_job_id,
                p_salary,
                p_comm_pct,
                p_mgr_id,
                p_dept_id,p_status,p_error
            );
            if p_status='v'
            then
            loaddata ( p_emp_id,
                p_fname,
                p_lname,
                p_email,
                p_phno,
                p_h_date,
                p_job_id,
                p_salary,
                p_comm_pct,
                p_mgr_id,
                p_dept_id, p_status,p_error
            ); 
            end if;
    EXCEPTION
    WHEN OTHERS THEN 
    P_STATUS:='E';
    P_ERROR:=P_ERROR||SQLCODE||SQLERRM;
     
end maine;
    END;
    
    