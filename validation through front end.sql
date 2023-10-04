CREATE OR REPLACE PACKAGE BODY xxintg_validation_rp AS

/**************************************************************************************************
VERSION            WHEN            WHO                       WHY
 
1.0           20-JULY-2023    RACHIT PANWAR           TO MAKE A PACKAGE BODY TO UPDATE AND
                                                      AND INSERT DETAILS IN STAGING AND BASE TABLE
**************************************************************************************************/

/**************************************
PROCEDURE OF  PRINTING A REPORT
*************************************/
   
--global variablw decleration   
   
   
   gn_chk         NUMBER; -- For validating count of a particular value
gc_chk         VARCHAR2(2); --For validating check
g_user_id      fnd_user.user_id%TYPE := fnd_profile.value('USER_ID');  -- Geeting user Id
g_resp_id      fnd_responsibility_tl.responsibility_id%TYPE := fnd_profile.value('RESP_ID'); --Getting REsponsibiity ID
g_resp_appl_id fnd_responsibility_tl.application_id%TYPE := fnd_profile.value('RESP_APPL_ID'); --Getting application ID
l_request_id   fnd_concurrent_requests.request_id%TYPE := fnd_profile.VALUE ('CONC_REQUEST_ID');
g_interval     number;
g_max_weight   number;
g_phase        varchar2(100);
g_status       varchar2(100);
g_conc_status  BOOLEAN;
gc_dev_phase   varchar2(100);
gc_dev_status  varchar2(100);
gc_message     varchar2(1000);




    PROCEDURE print_report (
        p_batch_id     NUMBER,
        p_process_type VARCHAR2
    ) AS
    

/***************************
LOCAL VARIABLE DECLERATION
****************************/
        ln_tcount NUMBER;
        ln_vcount NUMBER;
        ln_ecount NUMBER;

    
------------------->CURSOR FOR PRINTING ERROR REPORT
        CURSOR cur_report_error IS
        SELECT
            *
        FROM
            xxintg_staging_rp
        WHERE
                request_id = p_batch_id
            AND status = 'E';


----------------->CURSOR FOR PRINTING VALIDATE REPORT
        CURSOR cur_report_validate IS
        SELECT
            *
        FROM
            xxintg_staging_rp
        WHERE
                request_id = p_batch_id
            AND status = 'V';

    BEGIN
        fnd_file.put_line(fnd_file.output,' ');
        fnd_file.put_line(fnd_file.output,'PRINTING REPORT:');
        fnd_file.put_line(fnd_file.output,' ');
-----------------> TOTAL  RECORDS IN STAGING TABLE 
        SELECT
            COUNT(*)
        INTO ln_tcount
        FROM
            xxintg_staging_rp
        WHERE
            request_id = p_batch_id;
-------------> TOTAL ERROR RECORDS IN STAGING TABLE 

        SELECT
            COUNT(*)
        INTO ln_ecount
        FROM
            xxintg_staging_rp
        WHERE
                status = 'E'
            AND request_id = p_batch_id;
-------------> TOTAL VALIDATE RECORDS IN STAGING TABLE 

        SELECT
            COUNT(*)
        INTO ln_vcount
        FROM
            xxintg_staging_rp
        WHERE
                request_id = p_batch_id
            AND status = 'V';
     

------------------CHECKING CONDITION-----------------------------------

        IF upper(p_process_type) = 'VALIDATE ONLY' 
        THEN
            fnd_file.put_line(fnd_file.output,rpad('TOTAL RECORDS', 22)
                                 || ' :- '
                                 || ln_tcount);
            fnd_file.put_line(fnd_file.output,rpad('TOTAL ERROR RECORDS', 22)
                                 || ' :- '
                                 || ln_ecount);
            fnd_file.put_line(fnd_file.output,rpad('TOTAL VALIDATE RECORDS', 22)
                                 || ' :- '
                                 || ln_vcount);
            fnd_file.put_line(fnd_file.output,'**********VALIDATE REPORT************');
           
           
            fnd_file.put_line(fnd_file.output,' ');
            IF ln_vcount = 0 THEN
                fnd_file.put_line(fnd_file.output,' NO validated record FOUND');
            ELSE
           
            fnd_file.put_line(fnd_file.output,rpad('EMPLOYEE ID', 20, ' ')
                                 || '|'
                                 || rpad('FIRST NAME', 20, ' ')
                                 || '|'
                                 || rpad('LAST NAME', 20, ' ')
                                 || '|'
                                 || rpad('EMAIL', 20, ' ')
                                 || '|'
                                 || rpad('PHONE NUMBER', 20, ' ')
                                 || '|'
                                 || rpad('HIRE DATE', 20, ' ')
                                 || '|'
                                 || rpad('JOB ID', 20, ' ')
                                 || '|'
                                 || rpad('SALARY', 20, ' ')
                                 || '|'
                                 || rpad('COMMISSION PCT', 20, ' ')
                                 || '|'
                                 || rpad('MANAGER ID', 20, ' ')
                                 || '|'
                                 || rpad('DEPARTMENT ID', 20, ' ')
                                 || '|'
                                 || rpad('STATUS', 20, ' ')
                                 || '|'
                                 || rpad('ERROR', 20, ' '));

            fnd_file.put_line(fnd_file.output,rpad('-', 100, '-'));
            FOR rec_report_validate IN cur_report_validate LOOP
                BEGIN
                    fnd_file.put_line(fnd_file.output,rpad(nvl(to_char(rec_report_validate.employee_id),'NUll'),20,' ')
                    ||'|'||rpad(rec_report_validate.first_name, 20, ' ')
                    ||'|'|| rpad(rec_report_validate.last_name, 20, ' ')
                    ||'|'
                                         || rpad(rec_report_validate.email, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_validate.phone_number, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_validate.hire_date, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_validate.job_id, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_validate.salary, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_validate.commission_pct, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_validate.manager_id, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_validate.department_id, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_validate.status, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_validate.errorr, 20, ' '));

                EXCEPTION
                    WHEN OTHERS THEN
                        fnd_file.put_line(fnd_file.output,'ERROR IN PRINTING VALIDATE REPORT');
                END;
            END LOOP;
end if;
            fnd_file.put_line(fnd_file.output,' ');
            IF ln_ecount = 0 THEN
                fnd_file.put_line(fnd_file.output,' NO ERROR record FOUND');
            ELSE
                fnd_file.put_line(fnd_file.output,'**********ERROR REPORT************');
                fnd_file.put_line(fnd_file.output,rpad('EMPLOYEE ID', 20, ' ')
                                     || '|'
                                     || rpad('FIRST NAME', 20, ' ')
                                     || '|'
                                     || rpad('LAST NAME', 20, ' ')
                                     || '|'
                                     || rpad('EMAIL', 20, ' ')
                                     || '|'
                                     || rpad('PHONE NUMBER', 20, ' ')
                                     || '|'
                                     || rpad('HIRE DATE', 20, ' ')
                                     || '|'
                                     || rpad('JOB ID', 20, ' ')
                                     || '|'
                                     || rpad('SALARY', 20, ' ')
                                     || '|'
                                     || rpad('COMMISSION PCT', 20, ' ')
                                     || '|'
                                     || rpad('MANAGER ID', 20, ' ')
                                     || '|'
                                     || rpad('DEPARTMENT ID', 20, ' ')
                                     || '|'
                                     || rpad('STATUS', 20, ' ')
                                     || '|'
                                     || rpad('ERROR', 20, ' '));

                fnd_file.put_line(fnd_file.output,rpad('-', 100, '-'));
                FOR rec_error_report IN cur_report_error LOOP
                    BEGIN
                        fnd_file.put_line(fnd_file.output,rpad(nvl(to_char(rec_error_report.employee_id),'Null'),20,' ')
                                             || '|'
                                             || rpad(rec_error_report.first_name, 20)
                                             || '|'
                                             || rpad(rec_error_report.last_name, 20)
                                             || '|'
                                             || rpad(rec_error_report.email, 20)
                                             || '|'
                                             || rpad(rec_error_report.phone_number, 20)
                                             || '|'
                                             || rpad(rec_error_report.hire_date, 20)
                                             || '|'
                                             || rpad(rec_error_report.job_id, 20)
                                             || '|'
                                             || rpad(rec_error_report.salary, 20)
                                             || '|'
                                             || rpad(rec_error_report.commission_pct, 20)
                                             || '|'
                                             || rpad(rec_error_report.manager_id, 20)
                                             || '|'
                                             || rpad(rec_error_report.department_id, 20)
                                             || '|'
                                             || rpad(rec_error_report.status, 20)
                                             || '|'
                                             || rpad(rec_error_report.errorr, 20));

                    EXCEPTION
                        WHEN OTHERS THEN
                            fnd_file.put_line(fnd_file.output,'ERROR OCCURED IN PRINTING ERROR REPORT');
                    END;
                END LOOP;

            END IF;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output,'ERROR OCCURED  in printing report '
                                 || '|'
                                 || sqlcode
                                 || '|'
                                 || sqlerrm);
    END print_report;

/***********************************************
procedure of VALIDATING VALUES
************************************************/
    PROCEDURE validate_data (
        p_batch_id NUMBER
    ) AS
/********************************************** 
LOCAL VARIABLES
**********************************************/
        lc_email         VARCHAR(50);
        ln_count         NUMBER;
        lc_status        VARCHAR(30);
        lc_error         VARCHAR(3000);
        lc_department_id VARCHAR(50);
        lc_job_id        VARCHAR(30);

----->DECLARING CURSOR FOR VALIDATION

        CURSOR CUR_emp_stag_dtl IS
        SELECT
            *
        FROM
            xxintg_staging_rp
        WHERE
                status = 'N'
            AND request_id = p_batch_id;

    BEGIN
        FOR rec_emp_stag_dtl IN CUR_emp_stag_dtl LOOP
            BEGIN
                lc_status := 'V';
                lc_error := NULL;

/*****************************
FIRST_NAME VALIDATION
******************************/
                IF rec_emp_stag_dtl.first_name IS NULL THEN
                    lc_status := 'E';
                    lc_error := lc_error
                                || '|'
                                || '-FIRST_NAME CANNOT BE NULL';
                ELSIF length(rec_emp_stag_dtl.first_name) > 20 THEN
                    lc_status := 'E';
                    lc_error := lc_error ||' '|| '-FIRST_NAME CAN ONLY HAVE 20 CHARACTER';
                END IF;

/*****************************
LAST_NAME VALIDATION
******************************/
                IF rec_emp_stag_dtl.last_name IS NULL THEN
                    lc_status := 'E';
                    lc_error := lc_error
                                || '|'
                                || '-LAST NAME CANNNOT BE NULL';
                ELSIF length(rec_emp_stag_dtl.last_name) > 20 THEN
                    lc_status := 'E';
                    lc_error := lc_error
                                || '|'
                                || '-LAST_NAME CAN ONLY HAVE 20 CHARACTER';
                END IF;

/************************************
EMAIL VALIDATION
*************************************/

                lc_email := upper(rec_emp_stag_dtl.first_name
                                  || '.'
                                  || rec_emp_stag_dtl.last_name)
                            || '@INTELLOGER.COM';

                SELECT
                    COUNT(email)
                INTO ln_count
                FROM
                    employees
                WHERE
                        upper(first_name) = upper(rec_emp_stag_dtl.first_name)
                    AND upper(last_name) = upper(rec_emp_stag_dtl.last_name);

                IF ln_count > 0 THEN
                    lc_email := upper(rec_emp_stag_dtl.first_name
                                      || '.'
                                      || rec_emp_stag_dtl.last_name)
                                || ln_count
                                || '@INTELLOGER.COM';
                END IF;

/********************************************
PHONE NUMBER VALIDATION
**********************************************/

                IF rec_emp_stag_dtl.phone_number IS NULL THEN
                    lc_status := 'E';
                    lc_error := lc_error
                                || '|'
                                || '-PHONE NUMBER CANNOT BE NULL';
                ELSE
                    IF length(rec_emp_stag_dtl.phone_number) <> 10 THEN
                        lc_status := 'E';
                        lc_error := lc_error
                                    || '|'
                                    || '-PHONE NUMBER HAVE 10 DIGITS NUMBER';
                    ELSE
                        ln_count := 0;
                        SELECT
                            COUNT(phone_number)
                        INTO ln_count
                        FROM
                            employees
                        WHERE
                            phone_number = rec_emp_stag_dtl.phone_number;

                        IF ln_count > 0 THEN
                            lc_status := 'E';
                            lc_error := lc_error
                                        || '|'
                                        || '-PHONE NUMBER ALREADY EXIST WRITE A DIFFERENT PHONE NUMBER';
                        END IF;

                    END IF;
                END IF;
       
 /*****************************
  HIRE DATE VALIDATION
 *******************************/

                IF rec_emp_stag_dtl.hire_date IS NULL THEN
                    lc_status := 'E';
                    lc_error := lc_error
                                || '|'
                                || '-HIRE_DATE CANNOT BE NULL';
                ELSE
                    IF trunc(rec_emp_stag_dtl.hire_date) > trunc(sysdate) THEN
                        lc_status := 'E';
                        lc_error := lc_error
                                    || '|'
                                    || '-HIRE_DATE CANNOT BE A FUTURE DATE';
                    END IF;
                END IF;

/**********************************
JOB ID VALIDATION
*************************************/

                IF lower(rec_emp_stag_dtl.job_title) IS NULL THEN
                    lc_status := 'E';
                    lc_error := lc_error
                                || '|'
                                || '-Job TITLE can not be null';
                ELSE
                    BEGIN
                        SELECT
                            job_id
                        INTO lc_job_id
                        FROM
                            jobs
                        WHERE
                            lower(job_title) = lower(rec_emp_stag_dtl.job_title);

                    EXCEPTION
                        WHEN OTHERS THEN
                            lc_status := 'E';
                            lc_error := lc_error
                                        || '|'
                                        || '-JOB TITLE DOES NOT EXISTS';
                    END;
                END IF;

/**********************************************
SALARY VALIDATION
**********************************************/

                IF rec_emp_stag_dtl.salary IS NULL THEN
                    lc_status := 'E';
                    lc_error := lc_error
                                || '|'
                                || '-SALARY CANNOT BE NULL';
                ELSIF rec_emp_stag_dtl.salary < 5000 THEN
                    lc_status := 'E';
                    lc_error := lc_error
                                || '|'
                                || '-MINIMUM  SALARY SHOULD BE  5000';
                END IF;
            
	/*************************
		*COMMISION PCT VALIDATION
		**************************/
                IF rec_emp_stag_dtl.commission_pct NOT BETWEEN 0 AND 1 THEN
                    lc_status := 'E';
                    lc_error := lc_error
                                || '|'
                                || '-COMMISSION PCT CANNOT BE GREATER THAN 1 AND LESS THAN 0';
                END IF;
/**************************
MANAGER ID VALIDATION
*****************************/

                IF rec_emp_stag_dtl.manager_id IS NULL THEN
                    lc_status := 'E';
                    lc_error := lc_error
                                || '|'
                                || '-MANAGER ID CANNOT BE NULL';
                ELSE
                    ln_count := 0;
                    SELECT
                        COUNT(*)
                    INTO ln_count
                    FROM
                        employees
                    WHERE
                        employee_id = rec_emp_stag_dtl.manager_id;

                    IF ln_count = 0 THEN
                        lc_status := 'E';
                        lc_error := lc_error
                                    || '|'
                                    || '-MANAGER MUST BE AN EMPLOYEE';
                    END IF;

                END IF;
    
    /******************************
    DEPARTMENTID VALIDATION
    *******************************/
                IF rec_emp_stag_dtl.department_name IS NULL THEN
                    lc_status := 'E';
                    lc_error := lc_error
                                || '|'
                                || '-DEPARTMENT NAME IS MANDATORY PLEASE WRITE A VALID DEPARTMENT NAME';
                ELSE
                    BEGIN
                        SELECT
                            department_id
                        INTO lc_department_id
                        FROM
                            departments
                        WHERE
                            lower(department_name) = lower(rec_emp_stag_dtl.department_name);

                    EXCEPTION
                        WHEN OTHERS THEN
                            lc_status := 'E';
                            lc_error := lc_error
                                        || '|'
                                        || '-DEPARTMENT_ID DOESNT EXIST';
                    END;
                END IF;

                UPDATE xxintg_staging_rp
                SET
                    status = lc_status,
                    errorr = lc_error,
                    email = lc_email,
                    department_id = lc_department_id,
                    job_id = lc_job_id
                WHERE
                        record_id = rec_emp_stag_dtl.record_id
                    AND request_id = p_batch_id;

                COMMIT;
            EXCEPTION
                WHEN OTHERS THEN
                    fnd_file.put_line(fnd_file.output,'backtrace : ' || dbms_utility.format_error_backtrace);
                    fnd_file.put_line(fnd_file.output,'UNEXPEXTED ERROR IN VALIDATION '
                                         || sqlcode
                                         || '|'
                                         || sqlerrm);
            END;
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output,'ERROR IN VALIDATING DATA '
                                 || sqlcode
                                 || '-'
                                 || sqlerrm);
            fnd_file.put_line(fnd_file.output,dbms_utility.format_error_backtrace);
    END validate_data;


/*********************************************
procedure of insertion in staging table
************************************************/


    PROCEDURE load_in_staging_table (
        p_batch_id NUMBER
    ) AS
        l_request_id number;
        BEGIN
    fnd_global.apps_initialize(
    user_id => 1014843,
    resp_id => 20707,
    resp_appl_id => 201);
    
    l_request_id := fnd_request.submit_request(
    application => 'XXINTG',
    program => 'XXINTG_EMP_DATA_UPLOAD_RP',
    description => 'REQUEST CONCURRENT PROGRAM  TO EXECUTE FROM API-BACKEND',
    start_time => sysdate,
    sub_request => false,
   
    argument1 =>'/u01/install/APPS/fs1/EBSapps/appl/xxintg/12.0.0/bin/XXINTG_EMPLOYEETABLE_DATA_UPLOAD_CONTROL_FILE_RP.ctl',
    argument2 =>'/tmp/cust/',
    argument3 =>'/tmp/cust/emp_csv.csv',
    argument4 =>'/tmp/cust/emp_csv.log',
    argument5 =>'/tmp/cust/emp_csv.log.bad',
    argument6 =>'/tmp/cust/emp_csv.dis',
    argument7 =>'/tmp/cust/emp_csv.arc'
   
    );

    COMMIT;
   fnd_file.put_line (
                fnd_file.LOG,
                   RPAD ('Loader Request ID.', 45, ' ')
                || ': '
                || l_request_id);

 

            /************************************************
             * Validate Load Data Request ID.
             ************************************************/

 

            IF l_request_id = 0
            THEN
                gc_data_validation := gc_error_flag;
                gc_error_message := fnd_message.get;
            ELSE
                /************************************************
                 * Checking request Status  for Completion.
                 ************************************************/

 

                IF l_request_id > 0
                THEN
                    LOOP
                        gc_conc_status :=
                            fnd_concurrent.wait_for_request (
                                request_id   => gn_cp_request_id,
                                interval     => gn_interval,
                                max_wait     => gn_max_wait,
                                phase        => gc_phase,
                                status       => gc_status,
                                dev_phase    => gc_dev_phase,
                                dev_status   => gc_dev_status,
                                MESSAGE      => gc_message);

 

                        EXIT WHEN    UPPER (gc_phase) = 'COMPLETED'
                                  OR UPPER (gc_status) IN
                                         ('CANCELLED', 'ERROR', 'TERMINATED');
                    END LOOP;

 

                    fnd_file.put_line (
                        fnd_file.LOG,
                           RPAD ('Loader Request Phase/Status.', 45, ' ')
                        || ': '
                        || gc_phase
                        || '-'
                        || gc_status);

 

                    IF (    UPPER (gc_phase) = 'COMPLETED'
                        AND UPPER (gc_status) = 'NORMAL')
                    THEN
                        /************************************************
                         * Update Estimate Table with WHO Columns.
                         ************************************************/

 

                        UPDATE xxmtz.xxmtz_fs_estimate_stg
                           SET request_id =l_request_id,
                               created_by = gn_user_id,
                               last_updated_by = gn_user_id,
                               last_updated_date = gd_date,
                               last_updated_login = gn_login_id,
                               org_id = gn_org_id,
                               estimate_upload_type = gc_estimate_phase
                         WHERE process_flag = 'N';

 

                        COMMIT;
                    ELSE
                        gc_data_validation := gc_error_flag;
                        gc_error_message := SQLERRM;
                    END IF;
                END IF;
            END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Unexpected error '
                             || sqlcode
                             || ' - '
                             || sqlerrm);

    
        COMMIT;
    END load_in_staging_table;

    PROCEDURE print_parameter (
        p_batch_id     NUMBER,
        p_process_type VARCHAR
    ) AS
/*********************************
PROCEDURE FOR PARAMETER PRINTING
***********************************/

    BEGIN
        fnd_file.put_line(fnd_file.output,'USER INPUTS:');
        fnd_file.put_line(fnd_file.output,rpad('BATCH_ID', 20)
                             || '|'
                             || rpad('Process_type', 20));

        fnd_file.put_line(fnd_file.output,rpad(p_batch_id, 20)
                             || '|'
                             || rpad(p_process_type, 20));

    EXCEPTION
        WHEN  OTHERS THEN
            fnd_file.put_line(fnd_file.output,'ERROR OCCURED in printing parameter');
    END print_parameter;


/*****************************
main procedure for calling
******************************/
    PROCEDURE main_procedure (
     errbuff out varchar2, 
     reEtcode out varchar2,
        p_batch_id     IN NUMBER,
        p_process_type IN VARCHAR2
    ) AS
    
    
        ln_count NUMBER;
    BEGIN
        print_parameter(p_batch_id, p_process_type);
        IF p_batch_id IS NULL OR p_process_type IS NULL THEN
            fnd_file.put_line(fnd_file.output,'BATCH ID OR  PROCESS TYPE CANNOT BE NULL');
        ELSE
            IF upper(p_process_type) NOT IN ( 'VALIDATE ONLY' ) THEN
                fnd_file.put_line(fnd_file.output,' PROCESS TYPE SHOULD BE VALIDATE ONLY ');
            ELSE
                SELECT
                    COUNT(*)
                INTO ln_count
                FROM
                    xxintg_staging_rp
                WHERE
                    request_id = p_batch_id;

                IF ln_count > 0 THEN
                    fnd_file.put_line(fnd_file.output,'BATCH ID ALREADY EXIST');
                ELSE
                    IF upper(p_process_type) = 'VALIDATE ONLY' THEN
                        load_in_staging_table(p_batch_id);
                        validate_data(p_batch_id);
                        print_report(p_batch_id, p_process_type);
                    END IF;
                END IF;

            END IF;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output,'ERROR OCCURED IN MAIN PROCESS'
                                 || '|' 
                                 || sqlcode
                                 || '|'
                                 || sqlerrm);
    END main_procedure;

END xxintg_validation_rp;

    ------------------------------------------------------------------------------