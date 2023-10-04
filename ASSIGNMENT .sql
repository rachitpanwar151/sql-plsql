CREATE OR REPLACE PACKAGE xxintg_emp_update_insert_rp AS
   
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
    );

END xxintg_emp_update_insert_rp;


------