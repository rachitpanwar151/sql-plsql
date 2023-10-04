CREATE OR REPLACE PACKAGE BODY dept_porc AS

    gn_count NUMBER := 0;

    PROCEDURE validate_dept (
        p_dpt_id      IN departments.department_id%TYPE,
        p_dept_name   IN departments.department_name%TYPE,
        p_manager_id  IN departments.manager_id%TYPE,
        p_location_id IN departments.location_id%TYPE,
        p_status      OUT VARCHAR2,
        p_error       OUT VARCHAR2
    ) AS
    BEGIN
        p_status := 'V';
        BEGIN
            IF p_dpt_id IS NOT NULL THEN
                p_status := 'e';
                p_error := p_error || 'department_id cannot be null';
            ELSE
                SELECT
                    COUNT(*)
                INTO gn_count
                FROM
                    departments
                WHERE
                    department_id = p_dpt_id;

                IF gn_count < 1 THEN
                    p_status := 'e';
                    p_error := p_error || 'department_id doesnt exist';
                END IF;

            END IF;

        END;

        BEGIN
            IF p_dept_name IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'department name cannot be null';
            ELSE
                IF length(p_dept_name) > 30 THEN
                    p_status := 'e';
                    p_error := p_error || 'department name cannot be greater then 30 character';
                END IF;
            END IF;
        END;

        BEGIN
            IF length(p_manager_id) > 6 THEN
                p_status := 'e';
                p_error := p_error || 'length og manager id is not greater than 6';
            END IF;
        END;

        BEGIN
            IF length(p_location_id) > 4 THEN
                p_status := 'e';
                p_error := p_error || ' location id cannot have more than 4 character';
            END IF;
        END;

    END validate_dept;

    PROCEDURE insert_dept (
        p_dpt_id      IN departments.department_id%TYPE,
        p_dept_name   IN departments.department_name%TYPE,
        p_manager_id  IN departments.manager_id%TYPE,
        p_location_id IN departments.location_id%TYPE,
        p_status      OUT VARCHAR2,
        p_error       OUT VARCHAR2
    ) AS
    BEGIN
        IF p_status = 'E' THEN
            p_error := p_error || ' DATA CANNOT BE INSERTED';
        ELSE
            INSERT INTO departments VALUES (
                p_dpt_id,
                p_dept_name,
                p_manager_id,
                p_location_id
            );

            COMMIT;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || sqlcode
                       || sqlerrm;
    END insert_dept;

    PROCEDURE main_dept (
        p_dpt_id      IN departments.department_id%TYPE,
        p_dept_name   IN departments.department_name%TYPE,
        p_manager_id  IN departments.manager_id%TYPE,
        p_location_id IN departments.location_id%TYPE,
        p_status      OUT VARCHAR2,
        p_error       OUT VARCHAR2
    ) AS
    BEGIN
        IF p_status = 'v' THEN
            insert_dept(p_dpt_id, p_dept_name, p_manager_id, p_location_id, p_status,
                       p_error);
        END IF;

        IF p_status = 'V' THEN
            validate_dept(p_dpt_id, p_dept_name, p_manager_id, p_location_id, p_status,
                         p_error);
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || sqlcode
                       || sqlerrm;
    END main_dept;

END dept_porc;

--------------------------------------------------calling--------------------------------------------------------

declare
l_s varchar2(200);
l_e varchar2(3000);
begin
dept_porc.insert_dept(280,'enter',200,1700,l_s,l_e);
end;

select * from departments;
desc departments;