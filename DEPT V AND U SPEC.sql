CREATE OR REPLACE PACKAGE xx_intg_dept AS


/*********************************************************************
WHO                       WHEN                             VERSION                     WHY
RACHIT                    3 JULY 2023                      1.0.0                       TO MAKE A SPEC OF DEPARTMENT TABLE
***********************************************************************/
    PROCEDURE mainn (
        p_dept_id  IN  departments.department_id%TYPE,
        p_dept_name IN departments.department_name%TYPE,
        p_mngr_id   IN employees.manager_id%TYPE,
        p_loc_id   IN  locations.location_id%TYPE,
        P_STATUS OUT VARCHAR2,
        P_ERROR OUT VARCHAR2
    );

END xx_intg_dept;
