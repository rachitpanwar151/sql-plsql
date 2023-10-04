CREATE OR REPLACE PACKAGE xxintg_employee_EMAIL_CREATION 
AS
/*********************************************************************************************
WHEN               VERSION          WHO                             WHY
10-JULY-2023       1.0.0             RACHIT PANWAR         TO CREATE PACKAGE SPEC 
***********************************************************************************************/


/****************************************************
CREATING PACKAGE FOR EMAIL GENERATION AND REPORTING
******************************************************/

---DEFINING MAIN PROCEDURE FOR PACKAGE

    PROCEDURE mainnn (
        p_employee_id    IN employees.employee_id%TYPE,
        p_first_name     IN employees.first_name%TYPE,
        p_last_name      IN employees.last_name%TYPE,
        p_phone_number   IN employees.phone_number%TYPE,
        p_hire_date      IN employees.hire_date%TYPE,
        p_job_id         IN employees.job_id%TYPE,
        p_salary         IN employees.salary%TYPE,
        p_commission_pct IN employees.commission_pct%TYPE,
        p_manager_id     IN employees.manager_id%TYPE,
        p_department_id  IN employees.department_id%TYPE
    );
----------------------ENDING PACKAGE-----------------------
END xxintg_employee_EMAIL_CREATION;