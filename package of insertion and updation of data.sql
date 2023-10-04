
CREATE OR REPLACE PACKAGE xxintg_v_and_u_data_emp AS

/*****************************************************************************************************************************
package of insert and update
--------------------------------------------------------------------------------------------------
who      |version|  when    |  why
rachit panwar| 1.0.0 |28-06-2023| to inserting a data.
*****************************************************************************************************************************/

    gn_count NUMBER := 0; 

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
    );

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
       
    );
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
    );
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
       
    );
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
    );
END xxintg_v_and_u_data_emp;

-------------------------calling------------------------
SELECT * FROM DEPARTMENTS;
declare
lc_status varchar2(300);
lc_error varchar2(7000);
begin
xxintg_v_and_u_data_emp.mainn(
        employees_seq.nextval,
        'rahul'  ,
        'negi'      ,
        'rn@gmail.com'          ,
        '8708828316'   ,
        12-06-04   ,
            'AD_VP'  ,
        24000    ,
        0.1 ,
        190    ,
         '370' ,
        lc_status         ,
        lc_error          
);
end;

DESC EMPLOYEES;