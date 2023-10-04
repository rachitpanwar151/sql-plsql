CREATE OR REPLACE PACKAGE BODY xxintg_for_cursor AS

    PROCEDURE for_print AS

        CURSOR cur_regions IS
        SELECT
            *
        FROM
            regions;

        CURSOR cur_country (
            p_region_id VARCHAR2
        ) IS
        SELECT
            *
        FROM
            countries
        WHERE
            region_id = p_region_id;

        CURSOR cur_employees (
            p_region_id  VARCHAR2,
            p_country_id VARCHAR2
        ) IS
        SELECT
            emp.employee_id,
            emp.first_name,
            dpt.department_name,
            loc.city
        FROM
            employees   emp,
            locations   loc,
            departments dpt,
            countries   c,
            regions     r
        WHERE
                emp.department_id = dpt.department_id
            AND dpt.location_id = loc.location_id
            AND loc.country_id = c.country_id
            AND c.region_id = r.region_id
            AND r.region_id = p_region_id
            AND c.country_id = p_country_id;

    BEGIN
        FOR r1 IN cur_regions LOOP
            dbms_output.put_line(rpad('region_name:= ', 20)
                                 || ' '
                                 || r1.region_name);

            FOR r2 IN cur_country(r1.region_id) LOOP
                dbms_output.put_line(' ');
                dbms_output.put_line(rpad('country_name := ', 20)
                                     || ' '
                                     || r2.country_name);

                dbms_output.put_line(' ');
                dbms_output.put_line(rpad('employees_id', 20)
                                     || ' '
                                     || rpad('name', 20)
                                     || ' '
                                     || rpad('department_name', 20)
                                     || ' '
                                     || rpad('location_name', 20));

                FOR r3 IN cur_employees(r1.region_id, r2.country_id) LOOP
                    dbms_output.put_line(rpad(r3.employee_id, 20)
                                         || ' '
                                         || rpad(r3.first_name, 20)
                                         || ' '
                                         || rpad(r3.department_name, 20)
                                         || ' '
                                         || rpad(r3.city, 20));
                END LOOP;

            END LOOP;

            dbms_output.put_line(' ');
 dbms_output.put_line('==================================================================================================================================');
        END LOOP;
    END for_print;

    PROCEDURE cursor_main AS
    BEGIN
        for_print;
    END cursor_main;

END xxintg_for_cursor;
 
 ----------------------------------------------------------------------------------------

BEGIN
    xxintg_for_cursor.cursor_main;
END; 