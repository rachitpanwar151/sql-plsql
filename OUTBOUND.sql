
DECLARE
    fhandle utl_file.file_type;
    fn_data VARCHAR2(2000);
    CURSOR cur_emp IS
    SELECT
        employee_id,
        first_name,
        last_name,
        job_id,
        department_id
    FROM
        employees;

BEGIN
    fhandle := utl_file.fopen('RP1', 'rptxt.csv', 'w');
    utl_file.put(fhandle, 'EMPLOYEE_ID'
                          || ','
                          || 'FIRST_NAME'
                          || ','
                          || 'LAST_NAME'
                          || ','
                          || 'JOB_ID'
                          || ','
                          || 'DEPARTMENT_ID');

    FOR rec_emp IN cur_emp LOOP
        fn_data := rec_emp.employee_id
                   || ','
                   || rec_emp.first_name
                   || ','
                   || rec_emp.last_name
                   || ','
                   || rec_emp.job_id
                   || ','
                   || rec_emp.department_id;

        utl_file.put_line(fhandle, fn_data);
    END LOOP;

    IF utl_file.is_open(fhandle) THEN
        utl_file.fclose(fhandle);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '
                             || sqlcode
                             || ' - '
                             || sqlerrm);
        RAISE;
END;

