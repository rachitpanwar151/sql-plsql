---------------------starting of package with %type--------------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE xx_intg_emp AS
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
    );

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
    );

    PROCEDURE maine (
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
    );

END xx_intg_emp;
 
 
 -----------------------------end---------------------------------------------------------------------------------------------------------