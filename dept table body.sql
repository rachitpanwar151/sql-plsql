CREATE OR REPLACE PACKAGE dept_porc AS
    PROCEDURE validate_dept (
    
        p_dpt_id      IN departments.department_id%TYPE,
        p_dept_name   IN departments.department_name%TYPE,
        p_manager_id  IN departments.manager_id%TYPE,
        p_location_id IN departments.location_id%TYPE,
        p_status      OUT VARCHAR2,
        p_error       OUT VARCHAR2
    );

    PROCEDURE insert_dept (
    
        p_dpt_id      IN departments.department_id%TYPE,
        p_dept_name   IN departments.department_name%TYPE,
        p_manager_id  IN departments.manager_id%TYPE,
        p_location_id IN departments.location_id%TYPE,
        p_status      OUT VARCHAR2,
        p_error       OUT VARCHAR2
    );

    PROCEDURE main_dept (
        p_dpt_id      IN departments.department_id%TYPE,
        p_dept_name   IN departments.department_name%TYPE,
        p_manager_id  IN departments.manager_id%TYPE,
        p_location_id IN departments.location_id%TYPE,
        p_status      OUT VARCHAR2,
        p_error       OUT VARCHAR2
     );

END;