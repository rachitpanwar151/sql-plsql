create or replace  package  body  xxintg_different_tables

as
procedure cursor_defination(P_TABLE VARCHAR2,P_TYPE VARCHAR2)
as

--cursor for employee table

    CURSOR cur_emp_dtls IS
    SELECT
        *
    FROM
        employees;

    rec_emp_dtl          cur_emp_dtls%rowtype;
----------------------------------------------------------------------------------------    

 

--cursor for department table



    CURSOR cur_dept_dtls IS
    SELECT
        *
    FROM
        departments;

    rec_dept_dtl         cur_dept_dtls%rowtype;

 

------------------------------------------------------------------------------------------------

--cursor for jobs tabel
    CURSOR cur_jobs_dtls IS
    SELECT
        *
    FROM
        jobs;

    rec_jobs_dtls        cur_jobs_dtls%rowtype;

 

--------------------------------------------------------------------------------------------

--cursor for locations



    CURSOR cur_locations_dtls IS
    SELECT
        *
    FROM
        locations;

    rec_locations_dtls   cur_locations_dtls%rowtype;

 

-----------------------------------------------------------------

 

--cursor for regions table





    CURSOR cur_regions_dtls IS
    SELECT
        *
    FROM
        regions;

    rec_regions_dtls     cur_regions_dtls%rowtype;

 

-----------------------------------------------------------------------------

 

--cursor for countries





    CURSOR cur_countries_dtls IS
    SELECT
        *
    FROM
        countries;

    rec_countries_dtls   cur_countries_dtls%rowtype;

 

-------------------------------------------------------------------------------------

 



--cursor for job_history





    CURSOR cur_job_history_dtls IS
    SELECT
        *
    FROM
        job_history;

    rec_job_history_dtls cur_job_history_dtls%rowtype;

 

---------------------------------------------------------------------------------

 

 



/****************************************

 

procedure to print table columns

 

****************************************/



    PROCEDURE table_columns AS
    BEGIN
        IF
            p_table = 'EMPLOYEES'
            AND p_type = 'COLUMNS'
        THEN
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

        ELSIF
            p_table = 'departments'
            AND p_type = 'columns'
        THEN
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

        ELSIF
            p_table = 'JOBS '
            AND p_type = 'columns'
        THEN
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

        ELSIF
            p_type = 'LOCATIONS'
            AND p_type = 'columns'
        THEN
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

        ELSIF
            p_type = 'LOCATIONS'
            AND p_type = 'columns'
        THEN
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

        ELSIF
            p_table = 'REGIONS'
            AND p_type = 'columns'
        THEN
            OPEN cur_regions_dtls;
            LOOP
                FETCH cur_regions_dtls INTO rec_regions_dtls;
                EXIT WHEN cur_regions_dtls%notfound;
                dbms_output.put_line(rpad(rec_regions_dtls.region_id, 30)
                                     || ' '
                                     || rpad(rec_regions_dtls.region_name, 30));

            END LOOP;

        ELSIF
            p_table = 'JOB_HISTORY'
            AND p_type = 'columns'
        THEN
            LOOP
                FETCH cur_job_history_dtls INTO rec_job_history_dtls;
                EXIT WHEN cur_job_history_dtls%notfound;
                dbms_output.put_line(rpad(rec_job_history_dtls.employee_id, 30)
                                     || ' '
                                     || rpad(rec_job_history_dtls.start_date, 30)
                                     || ' '
                                     || rpad(rec_job_history_dtls.end_date, 30)
                                     || ' '
                                     || rpad(rec_job_history_dtls.job_id, 30)
                                     || ' '
                                     || rpad(rec_job_history_dtls.department_id, 30));

            END LOOP;
        END IF;
    END table_columns;

 

 

  /**********************************************

 

  procedure to print constraints of table

 

  ***********************************************/





    PROCEDURE table_constraints AS
    BEGIN
        IF
            p_table = 'EMPLOYEES'
            AND p_type = 'CONSTRAINTS'
        THEN
            OPEN cur_emp_dtls;
            LOOP
                FETCH cur_emp_dtls INTO rec_emp_dtl;
                EXIT WHEN cur_emp_dtls%notfound;
                dbms_output.put_line(rpad('department_id', 30)
                                     || ' '
                                     || 'EMP_DEPT_FK');
                dbms_output.put_line(rpad('EMAIL', 30)
                                     || ' '
                                     || 'EMP_LAST_NAME_NN');
                dbms_output.put_line(rpad('EMAIL', 30)
                                     || ' '
                                     || 'EMP_EMP_ID_PK');
                dbms_output.put_line(rpad('EMAIL', 30)
                                     || ' '
                                     || 'EMP_EMAIL_UK');
                dbms_output.put_line(rpad('EMAIL', 30)
                                     || ' '
                                     || 'EMP_EMAIL_NN');
                dbms_output.put_line(rpad('HIRE_DATE', 30)
                                     || ' '
                                     || 'EMP_HIRE_DATE_NN');
                dbms_output.put_line(rpad('JOB_ID', 30)
                                     || ' '
                                     || 'EMP_JOB_FK');
                dbms_output.put_line(rpad('job_id', 30)
                                     || ' '
                                     || 'EMP_JOB_NN');
                dbms_output.put_line(rpad('salary', 30)
                                     || ' '
                                     || 'EMP_SALARY_MIN');
                dbms_output.put_line(rpad('MANAGER_ID', 30)
                                     || ' '
                                     || 'EMP_MANAGER_FK');
            END LOOP;

        ELSIF
            p_table = 'departments'
            AND p_type = 'constraints'
        THEN
            OPEN cur_dept_dtls;
            LOOP
                FETCH cur_dept_dtls INTO rec_dept_dtl;
                EXIT WHEN cur_dept_dtls%notfound;
                dbms_output.put_line(rpad('department_id', 30)
                                     || 'DEPT_ID_PK');
                dbms_output.put_line(rpad('department_name', 30)
                                     || 'DEPT_NAME_NN');
                dbms_output.put_line(rpad('MANAGER_ID', 30)
                                     || ' DEPT_MGR_FK');
                dbms_output.put_line(rpad('location_id', 30)
                                     || 'DEPT_LOC_FK');
            END LOOP;

        ELSIF
            p_table = 'JOBS '
            AND p_type = 'constraints'
        THEN
            OPEN cur_jobs_dtls;
            LOOP
                FETCH cur_jobs_dtls INTO rec_jobs_dtls;
                EXIT WHEN cur_jobs_dtls%notfound;
                SELECT
                    *
                FROM
                    user_constraints
                WHERE
                    table_name = 'JOBS';

                dbms_output.put_line(rpad('JOB_ID', 30)
                                     || ' JOB_ID_PK');
                dbms_output.put_line(rpad('JOB_TITLE', 30)
                                     || 'JOB_TITLE_NN ');
            END LOOP;

        ELSIF
            p_type = 'LOCATIONS'
            AND p_type = 'constraints'
        THEN
            OPEN cur_locations_dtls;
            LOOP
                FETCH cur_locations_dtls INTO rec_locations_dtls;
                EXIT WHEN cur_locations_dtls%notfound;
                dbms_output.put_line(rpad('LOCATION_ID', 30)
                                     || ' LOC_ID_PK');
                dbms_output.put_line(rpad('CITY', 30)
                                     || 'LOC_ID_PK ');
                dbms_output.put_line(rpad('LOCATION_ID', 30)
                                     || 'LOC_C_ID_FK');
            END LOOP;

        ELSIF
            p_table = 'REGIONS'
            AND p_type = 'constraints'
        THEN
            OPEN cur_regions_dtls;
            LOOP
                FETCH cur_regions_dtls INTO rec_regions_dtls;
                EXIT WHEN cur_regions_dtls%notfound;
                dbms_output.put_line(rpad('REGION_ID', 30)
                                     || 'REGION_ID_NN ');
                dbms_output.put_line(rpad('REGION_ID', 30)
                                     || ' REG_ID_PK');
            END LOOP;

        ELSIF
            p_table = 'JOB_HISTORY'
            AND p_type = 'constraints'
        THEN
            LOOP
                FETCH cur_job_history_dtls INTO rec_job_history_dtls;
                EXIT WHEN cur_job_history_dtls%notfound;
                dbms_output.put_line(rpad('EMPLOYEE_ID', 30)
                                     || 'JHIST_EMP_FK ');
                dbms_output.put_line(rpad('START_DATE', 30)
                                     || ' JHIST_START_DATE_NN');
                dbms_output.put_line(rpad('END_DATE', 30)
                                     || ' JHIST_END_DATE_NN');
                dbms_output.put_line(rpad('JOB_ID', 30)
                                     || 'JHIST_JOB_FK ');
                dbms_output.put_line(rpad('DEPARTMENT_ID', 30)
                                     || 'JHIST_DEPT_FK');
                dbms_output.put_line(rpad('EMPLOYEE_ID', 30)
                                     || 'JHIST_DEPT_FK ');
                dbms_output.put_line(rpad('employee_id', 30)
                                     || 'JHIST_EMP_ID_ST_DATE_PK ');
                dbms_output.put_line(rpad('END_DATE', 30)
                                     || 'JHIST_DATE_INTERVAL ');
                dbms_output.put_line(rpad('JOB_ID', 30)
                                     || ' JHIST_JOB_NN');
            END LOOP;
        END IF;
    END table_constraints;

 

 

 

/**************************************

 

 

procedure to pritn index of tables

 

 

*****************************************/







    PROCEDURE table_index AS
    BEGIN
        IF
            p_table = 'EMPLOYEES'
            AND p_type = 'INDEXES'
        THEN
            OPEN cur_emp_dtls;
            LOOP
                FETCH cur_emp_dtls INTO rec_emp_dtl;
                EXIT WHEN cur_emp_dtls%notfound;
                dbms_output.put_line(rpad('EMAIL', 30)
                                     || ' '
                                     || 'EMP_EMAIL_UK');
                dbms_output.put_line(rpad('EMPLOYEE_ID', 30)
                                     || ' '
                                     || 'EMP_EMP_ID_PK');
                dbms_output.put_line(rpad('DEPARTMENT_ID', 30)
                                     || ' '
                                     || 'EMP_DEPARTMENT_IX');
                dbms_output.put_line(rpad('FIRST_NAME||LAST_NAME', 30)
                                     || ' '
                                     || 'EMP_NAME_IX');
                dbms_output.put_line(rpad('JOB_ID', 30)
                                     || ' '
                                     || 'EMP_JOB_IX');
                dbms_output.put_line(rpad('MANAGER_ID', 30)
                                     || ' '
                                     || 'EMP_MANAGER_IX');
            END LOOP;

        ELSIF
            p_table = 'departments'
            AND p_type = 'INDEXES'
        THEN
            OPEN cur_dept_dtls;
            LOOP
                FETCH cur_dept_dtls INTO rec_dept_dtl;
                EXIT WHEN cur_dept_dtls%notfound;
                dbms_output.put_line(rpad('department_id', 30)
                                     || 'DEPT_ID_PK');
                dbms_output.put_line(rpad('location_id', 30)
                                     || 'DEPT_LOCATION_IX');
            END LOOP;

        ELSIF
            p_table = 'JOBS '
            AND p_type = 'INDEXES'
        THEN
            OPEN cur_jobs_dtls;
            LOOP
                FETCH cur_jobs_dtls INTO rec_jobs_dtls;
                EXIT WHEN cur_jobs_dtls%notfound;
                SELECT
                    *
                FROM
                    user_constraints
                WHERE
                    table_name = 'JOBS';

                dbms_output.put_line(rpad('JOB_ID', 30)
                                     || ' JOB_ID_PK');
            END LOOP;

        ELSIF
            p_table = 'LOCATIONS'
            AND p_type = 'INDEXES'
        THEN
            OPEN cur_locations_dtls;
            LOOP
                FETCH cur_locations_dtls INTO rec_locations_dtls;
                EXIT WHEN cur_locations_dtls%notfound;
                dbms_output.put_line(rpad('LOCATION_ID', 30)
                                     || ' LOC_ID_PK');
                dbms_output.put_line(rpad('CITY', 30)
                                     || 'LOC_ID_IX ');
                dbms_output.put_line(rpad('STATE_PROVIENCE', 30)
                                     || 'LOC_STATE_PROVINCE_IX');
                dbms_output.put_line(rpad('COUNTRY_ID', 30)
                                     || 'LOC_COUNTRY_IX');
            END LOOP;

        ELSIF
            p_table = 'REGIONS'
            AND p_type = 'INDEXES'
        THEN
            OPEN cur_regions_dtls;
            LOOP
                FETCH cur_regions_dtls INTO rec_regions_dtls;
                EXIT WHEN cur_regions_dtls%notfound;
                dbms_output.put_line(rpad('REGION_ID', 30)
                                     || 'REGION_ID_PK ');
            END LOOP;

        ELSIF
            p_table = 'JOB_HISTORY'
            AND p_type = 'INDEXES'
        THEN
            LOOP
                FETCH cur_job_history_dtls INTO rec_job_history_dtls;
                EXIT WHEN cur_job_history_dtls%notfound;
                SELECT
                    *
                FROM
                    user_indexes
                WHERE
                    table_name = 'JOB_HISTORY';

                dbms_output.put_line(rpad('EMPLOYEE_ID', 30)
                                     || 'JHIST_EMP_ID_ST_DATE_PK ');
                dbms_output.put_line(rpad('EMPLOYEE_ID', 30)
                                     || 'JHIST_EMPLOYEE_IX');
                dbms_output.put_line(rpad('DEPARTMENT_ID', 30)
                                     || 'JHIST_DEPARTMENT_IX');
                dbms_output.put_line(rpad('JOB_ID', 30)
                                     || 'JHIST_JOB_IX ');
            END LOOP;
        END IF;
    END table_index;



PROCEDURE show_ALL_data_col (P_TABLE VARCHAR2, P_TYPE VARCHAR2)AS

IF P_TABLE = 'EMPLOYEES'     

 

       

 

END show_ALL_data_col;

 




procedure MAIN_POCEDURE( p_table varchar2, p_type varchar2)

 

as

 

begin

 

if P_TABLE

 

theN

 

END IF;

 

EXCEPTION WHEN OTHERS
    then
        dbms_output.put_line ( sqlcode || sqlerrm );
    end
        main_procedure;
    end
        xxintg_different_tables;

 