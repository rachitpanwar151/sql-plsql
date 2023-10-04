CREATE OR REPLACE PACKAGE BODY xx_intg_dept AS

    gn_count NUMBER; 
/********************************************************************
UPDATE PROCEDURE
***************************G*****************************************/

    PROCEDURE update_d (
        p_dept_id   IN departments.department_id%TYPE,
        p_dept_name IN departments.department_name%TYPE,
        p_mngr_id   IN employees.manager_id%TYPE,
        p_loc_id    IN locations.location_id%TYPE,
        p_status    OUT VARCHAR2,
        p_error     OUT VARCHAR2
    ) AS
    BEGIN
        UPDATE departments
        SET
            department_name = nvl(p_dept_name, department_name),
            manager_id = nvl(p_mngr_id, manager_id),
            location_id = nvl(p_loc_id, location_id)
        WHERE
            department_id = p_dept_id;

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Error while updating data'
                                 || sqlcode
                                 || '-'
                                 || sqlerrm);
    END update_d;

/******************************************************************
INSERT PROCEDURE
*******************************************************************/

    PROCEDURE insert_d (
        p_dept_id   IN departments.department_id%TYPE,
        p_dept_name IN departments.department_name%TYPE,
        p_mngr_id   IN employees.manager_id%TYPE,
        p_loc_id    IN locations.location_id%TYPE,
        p_status    OUT VARCHAR2,
        p_error     OUT VARCHAR2
    ) AS
    BEGIN
        INSERT INTO departments VALUES (
            p_dept_id,
            p_dept_name,
            p_mngr_id,
            p_loc_id
        );

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('error while loading data'
                                 || sqlcode
                                 || '-'
                                 || sqlerrm);
            dbms_output.put_line(dbms_utility.format_error_backtrace());
    END insert_d;

    PROCEDURE validate_insert_data (
        p_dept_id   IN departments.department_id%TYPE,
        p_dept_name IN departments.department_name%TYPE,
        p_mngr_id   IN employees.manager_id%TYPE,
        p_loc_id    IN locations.location_id%TYPE,
        p_status    OUT VARCHAR2,
        p_error     OUT VARCHAR2
    ) AS
    BEGIN
        p_status := 'V';
/*****************************
VALIDATING DEPARTMENT ID
*****************/

        IF p_dept_id IS NULL THEN
            p_status := 'E';
            p_error := 'DEPARTMENT ID CANNOT BE NULL';
        ELSE
            IF length(p_dept_id) > 3 THEN
                p_status := 'e';
                p_error := p_error || 'length of department_id is exceed.';
            ELSE
                SELECT
                    COUNT(*)
                INTO gn_count
                FROM
                    departments
                WHERE
                    department_id = p_dept_id;

    DBMS_OUTPUT.PUT_LINE(GN_COUNT);
                IF gn_count = 1 THEN
                    p_status := 'e';
                    p_error := p_error || 'DEPARTMENT ID ALREADY EXIST';
                END IF;

            END IF;
        END IF;

/************************************************************
VALIDATING DEPARTMENT_NAME
************************************************************/
        IF length(p_dept_name) > 40 THEN
            p_status := 'E';
            p_error := p_error || 'LENGTH EXCEED';
        ELSE
            SELECT
                COUNT(*)
            INTO gn_count
            FROM
                departments WHERE UPPER(DEPARTMENT_NAME)=UPPER(P_DEPT_NAME);

    DBMS_OUTPUT.PUT_LINE(GN_COUNT);
            IF gn_count =1 THEN
                p_status := 'E';
                p_error := p_error || ' DEPARTMENT NAME ALREADY EXIST';
            END IF;

        END IF;
        
        
        /********************************************
        VALIDATING MANAGER ID
        *****************************************/
        IF length(p_mngr_id) > 3 THEN
            p_status := 'E';
            p_error := p_error || 'length of manager_id is exceed.';
        ELSE
        
    DBMS_OUTPUT.PUT_LINE(GN_COUNT);
            SELECT
                COUNT(*)
            INTO gn_count
            FROM
                employees
            WHERE
                p_mngr_id = employee_id;

    DBMS_OUTPUT.PUT_LINE(GN_COUNT);
            IF gn_count > 1 THEN
                p_status := 'E';
                p_error := p_error || 'manager employee_id should be 1.';
            END IF;

        END IF;
        /************************************
        VALIDATING LOCATION ID
*********************************************/
        IF length(p_loc_id) > 4 THEN
            p_status := 'E';
            p_error := p_error || 'LENGTH EXCEED';
        ELSE
        
    DBMS_OUTPUT.PUT_LINE(GN_COUNT);
            SELECT
                COUNT(*)
            INTO gn_count
            FROM
                locations
            WHERE
                location_id = p_loc_id;

    DBMS_OUTPUT.PUT_LINE(GN_COUNT);
            IF gn_count = 0 THEN
                p_status := 'E';
                p_error := p_error || 'LOCATION DOESNT EXIST';
            END IF;

        END IF;

        IF p_status = 'V' THEN
            insert_d(p_dept_id, p_dept_name, p_mngr_id, p_loc_id, p_status,
                    p_error);
        END IF;

    END validate_insert_data;

    PROCEDURE validate_update (
        p_dept_id   IN departments.department_id%TYPE,
        p_dept_name IN departments.department_name%TYPE,
        p_mngr_id   IN employees.manager_id%TYPE,
        p_loc_id    IN locations.location_id%TYPE,
        p_status    OUT VARCHAR2,
        p_error     OUT VARCHAR2
    ) AS
    BEGIN
        p_status := 'V';
/*****************************
VALIDATING DEPARTMENT ID
*****************/

        IF p_dept_id IS NULL THEN
            p_status := 'E';
            p_error := 'DEPARTMENT ID CANNOT BE NULL';
        ELSE
            IF length(p_dept_id) > 3 THEN
                p_status := 'E';
                p_error := p_error || 'length of department_id is exceed.';
            ELSE
            
    DBMS_OUTPUT.PUT_LINE(GN_COUNT);
                SELECT
                    COUNT(*)
                INTO gn_count
                FROM
                    departments
                WHERE
                    department_id = p_dept_id;

    DBMS_OUTPUT.PUT_LINE(GN_COUNT);
                IF gn_count = 0 THEN
                    p_status := 'e';
                    p_error := p_error || 'DEPARTMENT ID ALREADY EXIST';
                END IF;

            END IF;
        END IF;

/************************************************************
VALIDATING DEPARTMENT_NAME
************************************************************/
        IF length(p_dept_name) > 40 THEN
            p_status := 'E';
            p_error := p_error || 'LENGTH EXCEED';
        ELSE
            SELECT
                COUNT(*)
            INTO gn_count
            FROM
                departments;

    DBMS_OUTPUT.PUT_LINE(GN_COUNT);
            IF gn_count > 0 THEN
                p_status := 'E';
                p_error := p_error || ' DEPARTMENT NAME ALREADY EXIST';
            END IF;

        END IF;
        
        
        /********************************************
        VALIDATING MANAGER ID
        *****************************************/
        IF length(p_mngr_id) > 3 THEN
            p_status := 'e';
            p_error := p_error || 'length of manager_id is exceed.';
        ELSE
            SELECT
                COUNT(*)
            INTO gn_count
            FROM
                employees
            WHERE
                p_mngr_id = employee_id;

            IF gn_count > 1 THEN
                p_status := 'e';
                p_error := p_error || 'manager employee_id should be 1.';
            END IF;

        END IF;
        /************************************
        VALIDATING LOCATION ID
*********************************************/
        IF length(p_loc_id) > 4 THEN
            p_status := 'E';
            p_error := p_error || 'LENGTH EXCEED';
        ELSE
            SELECT
                COUNT(*)
            INTO gn_count
            FROM
                locations
            WHERE
                location_id = p_loc_id;

            IF gn_count = 0 THEN
                p_status := 'E';
                p_error := p_error || 'LOCATION DOESNT EXIST';
            END IF;

        END IF;

        IF p_status = 'v' THEN
            update_d(p_dept_id, p_dept_name, p_mngr_id, p_loc_id, p_status,
                    p_error);
        END IF;

    END validate_update;
    
/***************************************************
PROCEDURE MAIN
*****************************************************/


    PROCEDURE mainn (
        p_dept_id   IN departments.department_id%TYPE,
        p_dept_name IN departments.department_name%TYPE,
        p_mngr_id   IN employees.manager_id%TYPE,
        p_loc_id    IN locations.location_id%TYPE,
        p_status    OUT VARCHAR2,
        p_error     OUT VARCHAR2
    ) AS
    BEGIN
    DBMS_OUTPUT.PUT_LINE(GN_COUNT);
        SELECT
            COUNT(*)
        INTO gn_count
        FROM
            employees
        WHERE
            p_dept_id = department_id;

    DBMS_OUTPUT.PUT_LINE(GN_COUNT);
        IF gn_count = 0 THEN
            validate_insert_data(p_dept_id, p_dept_name, p_mngr_id, p_loc_id, p_status,
                                p_error);
        ELSE
            validate_update(p_dept_id, p_dept_name, p_mngr_id, p_loc_id, p_status,
                           p_error);
        END IF;

    END mainn;

END xx_intg_dept;
    
    ------------------------------------END------------------------------------

DECLARE
    l_error  VARCHAR2(200);
    l_status VARCHAR2(3000);
BEGIN
    xx_intg_dept.mainn(280, 'IT GEEK', 100, 1700, l_error,
                      l_status);
    dbms_output.put_line(l_error
                         || '-'
                         || l_status);
END;

DELETE FROM departments
WHERE
    department_id = 280;

SELECT
    *
FROM
    departments;
    
    desc locations;