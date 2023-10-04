CREATE OR REPLACE PACKAGE BODY value_dump_not_duplicate AS

    PROCEDURE value_dump_procedure
    AS
        CURSOR c1
        IS
        SELECT
            emp.employee_id,
            emp.first_name || emp.last_name   employee_name,
            emp.hire_date,
            jb.job_id,
            jb.job_title,
            emp.salary,
            emp.commission_pct,
            emp1.manager_id,
            emp1.first_name || emp1.last_name manager_name,
            dept.department_id,
            dept.department_name,
            loc.location_id,
            loc.city,
            cou.country_id,
            cou.country_name,
            rgn.region_id,
            rgn.region_name
        FROM
            employees   emp,
            employees   emp1,
            departments dept,
            locations   loc,
            jobs        jb,
            countries   cou,
            regions     rgn
        WHERE
                emp.department_id = dept.department_id (+)
            AND emp.job_id = jb.job_id
            AND dept.location_id = loc.location_id (+)
            AND loc.country_id = cou.country_id (+)
            AND cou.region_id = rgn.region_id (+)
            AND emp.manager_id = emp1.employee_id (+)
        AND EMP.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM ALLTABLECOLUMS);
    BEGIN
        FOR rec1 IN c1 LOOP
        
            INSERT INTO alltablecolums VALUES (
                rec1.employee_id,
                rec1.employee_name,
                rec1.hire_date,
                rec1.job_id,
                rec1.job_title,
                rec1.salary,
                rec1.commission_pct,
                rec1.manager_id,
                rec1.manager_name,
                rec1.department_id,
                rec1.department_name,
                rec1.location_id,
                rec1.city,
                rec1.country_id,
                rec1.country_name,
                rec1.region_id,
                rec1.region_name
            );

            COMMIT;
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlcode
                                 || ' '
                                 || sqlerrm);
    END value_dump_procedure;

    PROCEDURE main_value_dump AS
    BEGIN
        value_dump_procedure;
    END main_value_dump;

END value_dump_not_duplicate;

-----------------------------CALLING---------------------------------------

BEGIN
    value_dump_not_duplicate.main_value_dump;
END;
------------------------------------------------------------------------------

SELECT
    *
FROM
    alltablecolums
ORDER BY
    1;