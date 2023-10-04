CREATE OR REPLACE PACKAGE BODY xxintg_parameter AS


/********************************************************************************

version     who               when                         wjy
1.0         rachit panwar     13-july-23                   to make a 
                                                         package having procedure
                                                        of main and report
*********************************************************************************/

/*********************************
report procedure
**********************************/

    PROCEDURE reportt (
        p_val IN VARCHAR2
    ) AS

--cursor for employees table

        CURSOR cur_emp_dtls IS
        SELECT
            *
        FROM
            employees;

        rec_emp_dtl          cur_emp_dtls%rowtype;
----------------------------------------------------------------------------------------    

-- cursor for departmetns table
        CURSOR cur_dept_dtls IS
        SELECT
            *
        FROM
            departments;

        rec_dept_dtl         cur_dept_dtls%rowtype;
------------------------------------------------------------------------------------------------
 
 -- cursor for job table

        CURSOR cur_jobs_dtls IS
        SELECT
            *
        FROM
            jobs;

        rec_jobs_dtls        cur_jobs_dtls%rowtype;
--------------------------------------------------------------------------------------------
        CURSOR cur_locations_dtls IS
        SELECT
            *
        FROM
            locations;

        rec_locations_dtls   cur_locations_dtls%rowtype;

-----------------------------------------------------------------
--cursor for region table

        CURSOR cur_regions_dtls IS
        SELECT
            *
        FROM
            regions;

        rec_regions_dtls     cur_regions_dtls%rowtype;
 -----------------------------------------------------------------------------

--cursor for countries table

        CURSOR cur_countries_dtls IS
        SELECT
            *
        FROM
            countries;

        rec_countries_dtls   cur_countries_dtls%rowtype;
 -------------------------------------------------------------------------------------
 
 --cursor for job history table 


        CURSOR cur_job_history_dtls IS
        SELECT
            *
        FROM
            job_history;

        rec_job_history_dtls cur_job_history_dtls%rowtype;
---------------------------------------------------------------------------------



    BEGIN

--checkingp  pval and calling defining cursor

        IF p_val = 'EMPLOYEES' THEN
            dbms_output.put_line(rpad('employee_id', 30)
                                 || ' '
                                 || rpad('first_name', 30)
                                 || ' '
                                 || rpad('Department_id', 30)
                                 || ' '
                                 || rpad('EMAIL', 30)
                                 || ' '
                                 || rpad('PHONE_NUMBER', 30)
                                 || ' '
                                 || rpad('HIRE_DATE', 30)
                                 || ' '
                                 || rpad('JOB_ID', 30)
                                 || ' '
                                 || rpad('SALARY', 30)
                                 || ' '
                                 || rpad('COMMISSION_PCT', 30)
                                 || ' '
                                 || rpad('MANAGER_ID', 30)
                                 || ' '
                                 || rpad('DEPARTMENT_ID', 30));

            OPEN cur_emp_dtls;
            LOOP
                FETCH cur_emp_dtls INTO rec_emp_dtl;
                EXIT WHEN cur_emp_dtls%notfound;
                dbms_output.put_line(rpad(rec_emp_dtl.employee_id, 30)
                                     || ' '
                                     || rpad(rec_emp_dtl.first_name, 30)
                                     || ' '
                                     || rpad(rec_emp_dtl.department_id, 30)
                                     || ' '
                                     || rpad(rec_emp_dtl.email, 30)
                                     || ' '
                                     || rpad(rec_emp_dtl.phone_number, 30)
                                     || ' '
                                     || rpad(rec_emp_dtl.hire_date, 30)
                                     || ' '
                                     || rpad(rec_emp_dtl.job_id, 30)
                                     || ' '
                                     || rpad(rec_emp_dtl.salary, 30)
                                     || ' '
                                     || rpad(rec_emp_dtl.commission_pct, 30)
                                     || ' '
                                     || rpad(rec_emp_dtl.manager_id, 30)
                                     || ' '
                                     || rpad(rec_emp_dtl.department_id, 30));

            END LOOP;

        ELSIF p_val = 'DEPARTMENTS' THEN
            dbms_output.put_line(rpad('department_id', 30)
                                 || ' '
                                 || rpad('department_name', 30)
                                 || ' '
                                 || rpad('MANAGER_ID', 30)
                                 || ' '
                                 || rpad('location_id', 30));

            OPEN cur_dept_dtls;
            LOOP
                FETCH cur_dept_dtls INTO rec_dept_dtl;
                EXIT WHEN cur_dept_dtls%notfound;
                dbms_output.put_line(rpad(rec_dept_dtl.department_id, 30)
                                     || ' '
                                     || rpad(rec_dept_dtl.department_name, 30)
                                     || ' '
                                     || rpad(rec_dept_dtl.manager_id, 30)
                                     || ' '
                                     || rpad(rec_dept_dtl.location_id, 30));

            END LOOP;

        ELSIF p_val = 'JOBS' THEN
            dbms_output.put_line(rpad('JOB_ID', 30)
                                 || ' '
                                 || rpad('JOB_TITLE', 30)
                                 || ' '
                                 || rpad('MIN_SALARY', 30)
                                 || ' '
                                 || rpad('MAX_SALARY', 30));

            OPEN cur_jobs_dtls;
            LOOP
                FETCH cur_jobs_dtls INTO rec_jobs_dtls;
                EXIT WHEN cur_jobs_dtls%notfound;
                dbms_output.put_line(rpad(rec_jobs_dtls.job_id, 30)
                                     || ' '
                                     || rpad(rec_jobs_dtls.job_title, 30)
                                     || ' '
                                     || rpad(rec_jobs_dtls.min_salary, 30)
                                     || ' '
                                     || rpad(rec_jobs_dtls.max_salary, 30));

            END LOOP;

        ELSIF p_val = 'LOCATIONS' THEN
            dbms_output.put_line(rpad('LOCATION_ID', 30)
                                 || ' '
                                 || rpad('STREET_ADDRESS', 30)
                                 || ' '
                                 || rpad('POSTAL_CODE', 30)
                                 || ' '
                                 || rpad('CITY', 30)
                                 || ' '
                                 || rpad('STATE_PROVINCE', 30)
                                 || ' '
                                 || rpad('COUNTRY_ID', 30));

            OPEN cur_locations_dtls;
            LOOP
                FETCH cur_locations_dtls INTO rec_locations_dtls;
                EXIT WHEN cur_locations_dtls%notfound;
                dbms_output.put_line(rpad(rec_locations_dtls.location_id, 30)
                                     || ' '
                                     || rpad(rec_locations_dtls.street_address, 30)
                                     || ' '
                                     || rpad(rec_locations_dtls.postal_code, 30)
                                     || ' '
                                     || rpad(rec_locations_dtls.city, 30)
                                     || ' '
                                     || rpad(rec_locations_dtls.state_province, 30)
                                     || ' '
                                     || rpad(rec_locations_dtls.country_id, 30));

            END LOOP;

        ELSIF p_val = 'REGIONS' THEN
            dbms_output.put_line(rpad('REGION_ID', 30)
                                 || ' '
                                 || rpad('REGION_NAME', 30));

            OPEN cur_regions_dtls;
            LOOP
                FETCH cur_regions_dtls INTO rec_regions_dtls;
                EXIT WHEN cur_regions_dtls%notfound;
                dbms_output.put_line(rpad(rec_regions_dtls.region_id, 30)
                                     || ' '
                                     || rpad(rec_regions_dtls.region_name, 30));

            END LOOP;

        ELSIF p_val = 'JOB_HISTORY' THEN
            dbms_output.put_line(rpad('EMPLOYEE_ID', 20)
                                 || ' '
                                 || rpad('START_DATE', 20)
                                 || ' '
                                 || rpad('END_DATE', 20)
                                 || ' '
                                 || rpad('JOB_ID', 20)
                                 || ' '
                                 || rpad('DEPARTMENT_ID', 20));

            OPEN cur_job_history_dtls;
            LOOP
                FETCH cur_job_history_dtls INTO rec_job_history_dtls;
                EXIT WHEN cur_job_history_dtls%notfound;
                dbms_output.put_line(rpad(rec_job_history_dtls.employee_id, 20)
                                     || ' '
                                     || rpad(rec_job_history_dtls.start_date, 20)
                                     || ' '
                                     || rpad(rec_job_history_dtls.end_date, 20)
                                     || '
     '
                                     || rpad(rec_job_history_dtls.job_id, 20)
                                     || '
     '
                                     || rpad(rec_job_history_dtls.department_id, 20));

            END LOOP;

        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlcode || sqlerrm);
    END reportt;

/*************************************

main procedure

***************************************/

    PROCEDURE main_parameter (
        p_val IN VARCHAR2
    ) AS
    BEGIN
        reportt(p_val);
    END main_parameter;

END xxintg_parameter;

-----------------------------------------------------------------------------------------

-------------CALL-------
BEGIN
    xxintg_parameter.main_parameter('JOB_HISTORY');
END;