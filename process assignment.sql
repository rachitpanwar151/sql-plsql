-------------------------------------------SPEC-------------------------------------------




CREATE OR REPLACE PACKAGE xx_intgreal AS
    PROCEDURE validatee(
        p_emp_id    IN NUMBER,
        p_fname      IN VARCHAR2,
        p_lname      IN VARCHAR2,
        p_email      IN VARCHAR2,
        p_phno     IN  VARCHAR2,
        p_hiredate   IN DATE,
        p_job_id     IN VARCHAR2,
        p_salary     IN NUMBER,
        p_com_oct    IN NUMBER,
        p_manager_id IN NUMBER,
        p_dept_id    IN NUMBER,
        p_status     OUT VARCHAR2,
        p_error      OUT VARCHAR2
    );

    PROCEDURE mainn (
        p_emp_id    IN NUMBER,
        p_fname      IN VARCHAR2,
        p_lname      IN VARCHAR2,
        p_email      IN VARCHAR2,
        p_phno       VARCHAR2,
        p_hiredate   IN DATE,
        p_job_id     IN VARCHAR2,
        p_salary     IN NUMBER,
        p_com_oct    IN NUMBER,
        p_manager_id IN NUMBER,
        p_dept_id    IN NUMBER,
        p_status     OUT VARCHAR2,
        p_error      OUT VARCHAR2
    );

    PROCEDURE loaddata (
        p_emp_id    IN NUMBER,
        p_fname      IN VARCHAR2,
        p_lname      IN VARCHAR2,
        p_email      IN VARCHAR2,
        p_phno       VARCHAR2,
        p_hiredate   IN DATE,
        p_job_id     IN VARCHAR2,
        p_salary     IN NUMBER,
        p_com_oct    IN NUMBER,
        p_manager_id IN NUMBER,
        p_dept_id    IN NUMBER,
        p_status     OUT VARCHAR2,
        p_error      OUT VARCHAR2
    );

END xx_intgreal;
