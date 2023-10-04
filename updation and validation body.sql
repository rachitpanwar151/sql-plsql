----------------------------------satarting of procedure for updation and validation IN EMPLOYEE TABLE------------------------------------------------------------




CREATE OR REPLACE PACKAGE proce AS

/************************************************************************************************************************************************************

package to validatee_insert and validate_update the data


WHO                          VERSION                             WHEN                                           WHY              
RACHIT PANWAR                1.0.0                               30-JUNE-2023                          TO MAKE A PROCEDURE SPEC FOR VALIDATION AND UPDATION


**************************************************************************************************************************************************************/

    PROCEDURE main (
        p_emp_id   IN xxintg_emp_rp.employee_id%TYPE,
        p_fname  in  xxintg_emp_rp.first_name%TYPE,
        p_lname   in xxintg_emp_rp.last_name%TYPE,
        p_email   in xxintg_emp_rp.email%TYPE,
        p_phno   in  xxintg_emp_rp.phone_number%TYPE,
        p_hdate   in xxintg_emp_rp.hire_date%TYPE,
        p_job_id in  jobs.job_id%TYPE,
        p_salary  in xxintg_emp_rp.salary%TYPE,
        p_comm_pct in xxintg_emp_rp.commission_pct%TYPE,
        p_mgr_id  in  xxintg_emp_rp.manager_id%TYPE,
        p_dept_id in departments.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    );

END proce;


----------------------------------------------------------end------------------------------------------------------------------------------

