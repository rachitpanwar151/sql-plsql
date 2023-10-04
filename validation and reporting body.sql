CREATE OR REPLACE PACKAGE BODY xxintg_validate_and_insert AS

/**************************************************************************************************
VERSION            WHEN            WHO                       WHY
 
1.0           20-JULY-2023    RACHIT PANWAR           TO MAKE A PACKAGE BODY TO UPDATE AND
                                                      AND INSERT DETAILS IN STAGING AND BASE TABLE
**************************************************************************************************/

/**************************************
PROCEDURE OF  PRINTING A REPORT
*************************************/
    PROCEDURE print_report (
        p_batch_id     NUMBER,
        p_process_type VARCHAR2
    ) AS
    

/***************************
LOCAL VARIABLE DECLERATION
****************************/
        ln_tcount NUMBER;
        ln_scount NUMBER;
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


------------->CURSOR FOR PRINTING SUCCESS REPORT
        CURSOR cur_report_success IS
        SELECT
            *
        FROM
            xxintg_staging_rp
        WHERE
                request_id = p_batch_id
            AND status = 'S';
            
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
        dbms_output.put_line(' ');
        dbms_output.put_line('PRINTING REPORT:');
        dbms_output.put_line(' ');
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
     
     -------------> TOTAL SUCCESS RECORDS IN STAGING TABLE 

        SELECT
            COUNT(*)
        INTO ln_scount
        FROM
            xxintg_staging_rp
        WHERE
            status = 'S'
            and
            request_id=p_batch_id;

------------------CHECKING CONDITION-----------------------------------

        IF upper(p_process_type) = 'VALIDATE ONLY' THEN
            dbms_output.put_line(rpad('TOTAL RECORDS', 22)
                                 || ' :- '
                                 || ln_tcount);
            dbms_output.put_line(rpad('TOTAL ERROR RECORDS', 22)
                                 || ' :- '
                                 || ln_ecount);
            dbms_output.put_line(rpad('TOTAL VALIDATE RECORDS', 22)
                                 || ' :- '
                                 || ln_vcount);
            dbms_output.put_line('**********VALIDATE REPORT************');
           
           
            dbms_output.put_line(' ');
            IF ln_vcount = 0 THEN
                dbms_output.put_line(' NO validated record FOUND');
            ELSE
           
            dbms_output.put_line(rpad('EMPLOYEE ID', 20, ' ')
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

            dbms_output.put_line(rpad('-', 100, '-'));
            FOR rec_report_validate IN cur_report_validate LOOP
                BEGIN
                    dbms_output.put_line(rpad(nvl(to_char(rec_report_validate.employee_id),'NUll'),20,' ')
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
                        dbms_output.put_line('ERROR IN PRINTING VALIDATE REPORT');
                END;
            END LOOP;
end if;
            dbms_output.put_line(' ');
            IF ln_ecount = 0 THEN
                dbms_output.put_line(' NO ERROR record FOUND');
            ELSE
                dbms_output.put_line('**********ERROR REPORT************');
                dbms_output.put_line(rpad('EMPLOYEE ID', 20, ' ')
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

                dbms_output.put_line(rpad('-', 100, '-'));
                FOR rec_error_report IN cur_report_error LOOP
                    BEGIN
                        dbms_output.put_line(rpad(nvl(to_char(rec_error_report.employee_id),'Null'),20,' ')
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
                            dbms_output.put_line('ERROR OCCURED IN PRINTING ERROR REPORT');
                    END;
                END LOOP;

            END IF;

        END IF;

        IF upper(p_process_type) = 'VALIDATE AND INSERT' THEN
            dbms_output.put_line(rpad('TOTAL RECORDS', 22)
                                 || ' :- '
                                 || ln_tcount);
            dbms_output.put_line(rpad('TOTAL SUCCESS RECORDS', 22)
                                 || ' :- '
                                 || ln_scount);
            dbms_output.put_line(rpad('TOTAL ERROR RECORDS', 22)
                                 || ' :- '
                                 || ln_ecount);
       
       
       
       
            dbms_output.put_line(' ');
            IF ln_scount = 0 THEN
                dbms_output.put_line(' NO success record FOUND');
            ELSE
            dbms_output.put_line('**********SUCCESS REPORT************');
       
            dbms_output.put_line(rpad('EMPLOYEE_ID', 20, ' ')
                                 || '|'
                                 || rpad('FIRST_NAME', 20, ' ')
                                 || '|'
                                 || rpad('LAST_NAME', 20, ' ')
                                 || '|'
                                 || rpad('EMAIL', 20, ' ')
                                 || '|'
                                 || rpad('PHONE_NUMBER', 20, ' ')
                                 || '|'
                                 || rpad('HIRE_DATE', 20, ' ')
                                 || '|'
                                 || rpad('JOB_ID', 20, ' ')
                                 || '|'
                                 || rpad('SALARY', 20, ' ')
                                 || '|'
                                 || rpad('COMMISSION_PCT', 20, ' ')
                                 || '|'
                                 || rpad('MANAGER ID', 20, ' ')
                                 || '|'
                                 || rpad('DEPARTMENT ID', 20, ' ')
                                 || '|'
                                 || rpad('STATUS', 20, ' ')
                                 || '|'
                                 || rpad('ERROR', 20, ' '));

            dbms_output.put_line(rpad('-', 100, '-'));
            FOR rec_report_success IN cur_report_success LOOP
                BEGIN
                    dbms_output.put_line(rpad(rec_report_success.employee_id, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_success.first_name, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_success.last_name, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_success.email, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_success.phone_number, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_success.hire_date, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_success.job_id, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_success.salary, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_success.commission_pct, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_success.manager_id, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_success.department_id, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_success.status, 20, ' ')
                                         || '|'
                                         || rpad(rec_report_success.errorr, 20, ' '));

                EXCEPTION
                    WHEN OTHERS THEN
                        dbms_output.put_line('ERROR IN PRINTING SUCCESS REPORT');
                END;
            END LOOP;
            end if;




            dbms_output.put_line(' ');
            IF ln_ecount = 0 THEN
                dbms_output.put_line(' NO ERROR record FOUND');
            ELSE
            dbms_output.put_line('**********error REPORT************');
                 dbms_output.put_line(rpad('EMPLOYEE_ID', 20, ' ')
                                     || '|'
                                     || rpad('FIRST_NAME', 20, ' ')
                                     || '|'
                                     || rpad('LAST_NAME', 20, ' ')
                                     || '|'
                                     || rpad('EMAIL', 20, ' ')
                                     || '|'
                                     || rpad('PHONE_NUMBER', 20, ' ')
                                     || '|'
                                     || rpad('HIRE_DATE', 20, ' ')
                                     || '|'
                                     || rpad('JOB_ID', 20, ' ')
                                     || '|'
                                     || rpad('SALARY', 20, ' ')
                                     || '|'
                                     || rpad('COMMISSION_PCT', 20, ' ')
                                     || '|'
                                     || rpad('MANAGER ID', 20, ' ')
                                     || '|'
                                     || rpad('DEPARTMENT ID', 20, ' ')
                                     || '|'
                                     || rpad('STATUS', 20, ' ')
                                     || '|'
                                     || rpad('ERROR', 20, ' '));

                dbms_output.put_line(rpad('-', 100, '-'));
                FOR rec_error_report IN cur_report_error LOOP
                    BEGIN
                        dbms_output.put_line(rpad(nvl(to_char(rec_error_report.employee_id),'Null'),20,' ')
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
                            dbms_output.put_line(' ERROR IN PRINTING ERROR REPORT'
                                                 || '|'
                                                 || sqlcode
                                                 || '|'
                                                 || sqlerrm);
                    END;
                END LOOP;
            END IF;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR OCCURED  in printing report '
                                 || '|'
                                 || sqlcode
                                 || '|'
                                 || sqlerrm);
    END print_report;



/*************************************
proceDure of inserting into base table
***************************************/

    PROCEDURE load_emp_data (
        p_batch_id IN NUMBER
    ) AS
        CURSOR cur_emp_dtl IS
        SELECT
            *
        FROM
            xxintg_staging_rp
        WHERE
                request_id = p_batch_id
            AND status = 'V';

    BEGIN
        FOR rec_emp_dtl IN cur_emp_dtl LOOP
            BEGIN
                INSERT INTO employees VALUES (
                    EMPLOYEES_SEQ.NEXTVAL,
                    rec_emp_dtl.first_name,
                    rec_emp_dtl.last_name,
                    rec_emp_dtl.email,
                    rec_emp_dtl.phone_number,
                    rec_emp_dtl.hire_date,
                    rec_emp_dtl.job_id,
                    rec_emp_dtl.salary,
                    rec_emp_dtl.commission_pct,
                    rec_emp_dtl.manager_id,
                    rec_emp_dtl.department_id
                );

                UPDATE xxintg_staging_rp
                SET
                    status = 'S',
                    employee_id=employees_seq.currval
                WHERE
                        request_id = p_batch_id
                    AND record_id = rec_emp_dtl.record_id;

                COMMIT;
            EXCEPTION
                WHEN OTHERS THEN
                    UPDATE xxintg_staging_rp
                    SET
                        status = 'E',
                        errorr = 'ERROR OCCURED WHILE INSERTING DATA  INTO EMPLOYEE_TABLE'
                    WHERE
                            request_id = p_batch_id
                        AND record_id = rec_emp_dtl.record_id;

                    COMMIT;
            END;
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(' ERROR OCCURED IN BASE TABLE INSERT PROCESS'
                                 || '|'
                                 || sqlcode
                                 || '|'
                                 || sqlerrm);
    END load_emp_data;

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
                    dbms_output.put_line('backtrace : ' || dbms_utility.format_error_backtrace);
                    dbms_output.put_line('UNEXPEXTED ERROR IN VALIDATION '
                                         || sqlcode
                                         || '|'
                                         || sqlerrm);
            END;
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR IN VALIDATING DATA '
                                 || sqlcode
                                 || '-'
                                 || sqlerrm);
            dbms_output.put_line(dbms_utility.format_error_backtrace);
    END validate_data;


/*********************************************
procedure of insertion in staging table
************************************************/


    PROCEDURE load_in_staging_table (
        p_batch_id NUMBER
    ) AS
    BEGIN
        INSERT INTO xxintg_staging_rp VALUES (
            p_batch_id,
            record_id.NEXTVAL,
            '',
            'HEMA',
            'NEGI',
            '',
            8500876578,
            sysdate - 6,
            '',
            'Programmer',
            95000,
            0.1,
            110,
            '',
            'Executive',
            'ROBIN',
            'ROBIN',
            sysdate,
            sysdate,
            1011,
            'N',
            ''
        );

        INSERT INTO xxintg_staging_rp VALUES (
            p_batch_id,
            record_id.NEXTVAL,
            '',
            'rOhit',
            'panwar',
            '',
            8000300000,
            sysdate - 6,
            '',
            'Programmer',
            10000,
            0.4,
            121,
            '',
            'Executive',
            'ROBIN',
            'ROBIN',
            sysdate,
            sysdate,
            1011,
            'N',
            ''
        );
        
        
        INSERT INTO xxintg_staging_rp VALUES (
            p_batch_id,
            record_id.NEXTVAL,
            '',
            'rOhit',
            'panwar',
            '',
            4000300000,
            sysdate - 6,
            '',
            'Programmer',
            10000,
            0.4,
            121,
            '',
            'Executive',
            'ROBIN',
            'ROBIN',
            sysdate,
            sysdate,
            1011,
            'N',
            ''
        );


        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR OCCURED in INSERTING THE DATA INTO staging table'
                                 || sqlcode
                                 || '-'
                                 || sqlerrm);
    END load_in_staging_table;

    PROCEDURE print_parameter (
        p_batch_id     NUMBER,
        p_process_type VARCHAR
    ) AS
/*********************************
PROCEDURE FOR PARAMETER PRINTING
***********************************/

    BEGIN
        dbms_output.put_line('USER INPUTS:');
        dbms_output.put_line(rpad('BATCH_ID', 20)
                             || '|'
                             || rpad('Process_type', 20));

        dbms_output.put_line(rpad(p_batch_id, 20)
                             || '|'
                             || rpad(p_process_type, 20));

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR OCCURED in printing parameter');
    END print_parameter;


/*****************************
main procedure for calling
******************************/
    PROCEDURE main_procedure (
        p_batch_id     IN NUMBER,
        p_process_type IN VARCHAR2
    ) AS
        ln_count NUMBER;
    BEGIN
        print_parameter(p_batch_id, p_process_type);
        IF p_batch_id IS NULL OR p_process_type IS NULL THEN
            dbms_output.put_line('BATCH ID OR  PROCESS TYPE CANNOT BE NULL');
        ELSE
            IF upper(p_process_type) NOT IN ( 'VALIDATE ONLY', 'VALIDATE AND INSERT' ) THEN
                dbms_output.put_line(' PROCESS TYPE SHOULD BE VALIDATE ONLY  OR VALIDATE AND INSERT');
            ELSE
                SELECT
                    COUNT(*)
                INTO ln_count
                FROM
                    xxintg_staging_rp
                WHERE
                    request_id = p_batch_id;

                IF ln_count > 0 THEN
                    dbms_output.put_line('BATCH ID ALREADY EXIST');
                ELSE
                    IF upper(p_process_type) = 'VALIDATE ONLY' THEN
                        load_in_staging_table(p_batch_id);
                        validate_data(p_batch_id);
                        print_report(p_batch_id, p_process_type);
                    ELSE
                        load_in_staging_table(p_batch_id);
                        validate_data(p_batch_id);
                        load_emp_data(p_batch_id);
                        print_report(p_batch_id, p_process_type);
                    END IF;
                END IF;

            END IF;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR OCCURED IN MAIN PROCESS'
                                 || '|' 
                                 || sqlcode
                                 || '|'
                                 || sqlerrm);
    END main_procedure;

END xxintg_validate_and_insert;
    
    ------------------------------------------------------------------------------