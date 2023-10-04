CREATE OR REPLACE PACKAGE xx_emp_more AS
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
       p_department_name   IN departments.department_name%TYPE,
        p_status            OUT VARCHAR2,
        p_error             OUT VARCHAR2,
        p_loc_name          in locations.location_id%TYPE,
        p_dept_manager_name in employees.employee_id%TYPE
    );

END xx_emp_more;