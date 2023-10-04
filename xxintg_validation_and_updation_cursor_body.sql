CREATE OR REPLACE PACKAGE BODY xxintg_validate_and_insert AS

/**************************************************************************************************
VERSION            WHEN            WHO                       WHY

1.0           20-JULY-2023    RACHIT PANWAR           TO MAKE A PACKAGE BODY TO UPDATE AND
                                                    AND INSERT DETAILS IN STAGING AND BASE TABLE
***************************************************************************************************/

/***************************
GLOBAL VARIABLE DECLERATION
****************************/
    gn_tcount NUMBER;
    gn_scount NUMBER;
    gn_vcount NUMBER;
    gn_ecount NUMBER;

/**************************************
PROCEDURE OF  PRINTING A REPORT
*************************************/
    PROCEDURE print_report (
        p_batch_id     NUMBER,
        p_process_type VARCHAR2
    ) AS
----------------------CURSOR FOR PRINTING ERROR REPORT
        CURSOR cur_report_error IS
        SELECT
            *
        FROM
            xxintg_staging_rp
        WHERE
                request_id = p_batch_id
            AND status = 'E';


-------------CURSOR FOR PRINTING SUCCESS REPORT
        CURSOR cur_report_success IS
        SELECT
            *
        FROM
            xxintg_staging_rp
        WHERE
                request_id = p_batch_id
            AND status = 'S';
            
-------------------------CURSOR FOR PRINTING VALIDATE REPORT
            CURSOR CUR_REPORT_VALIDATE
            IS
            SELECT * FROM XXINTG_STAGING_RP 
            WHERE REQUEST_ID=P_BATCH_ID AND STATUS='V'; 

    BEGIN
-------------> TOTAL  RECORDS IN STAGING TABLE 
        SELECT
            COUNT(*)
        INTO gn_tcount
        FROM
            xxintg_staging_rp
            WHERE
            REQUEST_ID=P_BATCH_ID;

        
        
---------------------> TOTAL NUMBER OF ERROR STATUS  COUNT IN  STAGING TABLE

        SELECT
            COUNT(*)
        INTO gn_ecount
        FROM
            xxintg_staging_rp
        WHERE
            status = 'E'
            AND
            REQUEST_ID=P_BATCH_ID;

---------> TOTAL VALIDATE RECORD IN STAGING 
SELECT
            COUNT(*)
        INTO gn_Vcount
        FROM
            xxintg_staging_rp
        WHERE
            status = 'V'
            AND
            REQUEST_ID=P_BATCH_ID;




---------> TOTAL SUCCESS RECORD IN STAGING AFTER INSERTION
        SELECT
            COUNT(*)
        INTO gn_scount
        FROM
            xxintg_staging_rp
        WHERE
            status = 'S';

        dbms_output.put_line(rpad('TOTAL_COUNT', 30)
                             || ':-'
                             || rpad(gn_tcount, 30));

        dbms_output.put_line(rpad('S_STATUS_COUNT', 30)
                             || ':-'
                             || rpad(gn_vcount, 30));

        dbms_output.put_line(rpad('E_STATUS_COUNT', 30)
                             || ':-'
                             || rpad(gn_ecount, 30));
                
                
        dbms_output.put_line(rpad('VALIDATE_COUNT', 30)
                             || ':-'
                             || rpad(gn_Vcount, 30));
                            
------------------------------------PRINTING REPORT--------------------------------------
        
        dbms_output.put_line('**********VALIDATE REPORT************');
        dbms_output.put_line(rpad('EMPLOYEE_ID', 20, ' ')
                             || '||'
                             || rpad('FIRST_NAME', 20, ' ')
                             || '||'
                             || rpad('LAST_NAME', 20, ' ')
                             || '||'
                             || rpad('EMAIL', 20, ' ')
                             || ' ||'
                             || rpad('PHONE_NUMBER', 20, ' ')
                             || '||'
                             || rpad('HIRE_DATE', 20, ' ')
                             || '||'
                             || rpad('JOB_ID', 20, ' ')
                             || '||'
                             || rpad('SALARY', 20, ' ')
                             || '||'
                             || rpad('COMMISSION_PCT', 20, ' ')
                             || '||'
                             || rpad('MANAGER ID', 20, ' ')
                             || '||'
                             || rpad('DEPARTMENT ID', 20, ' ')
                             || '||'
                             || rpad('STATUS', 20, ' ')
                             || '||'
                             || rpad('ERROR', 20, ' '));

        FOR REC_REPORT_VALIDATE IN CUR_REPORT_VALIDATE
        LOOP
            dbms_output.put_line(rpad(REC_REPORT_VALIDATE.employee_id, 20, ' ')
                                 || '-'
                                 || rpad(REC_REPORT_VALIDATE.first_name, 20, ' ')
                                 || '-'
                                 || rpad(REC_REPORT_VALIDATE.last_name, 0, ' ')
                                 || '-'
                                 || rpad(REC_REPORT_VALIDATE.email, 20, ' ')
                                 || ' '
                                 || rpad(REC_REPORT_VALIDATE.phone_number, 20, ' ')
                                 || '-'
                                 || rpad(REC_REPORT_VALIDATE.hire_date, 20, ' ')
                                 || '-'
                                 || ' '
                                 || rpad(REC_REPORT_VALIDATE.job_id, 20, ' ')
                                 || '-'
                                 || rpad(REC_REPORT_VALIDATE.salary, 20, ' ')
                                 || '-'
                                 || rpad(REC_REPORT_VALIDATE.commission_pct, 20, ' ')
                                 || '-'
                                 || rpad(REC_REPORT_VALIDATE.manager_id, 20, ' ')
                                 || '-'
                                 || rpad(REC_REPORT_VALIDATE.department_id, 20, ' ')
                                 || '-'
                                 || rpad(REC_REPORT_VALIDATE.status, 20, ' ')
                                 || ' '
                                 || rpad(REC_REPORT_VALIDATE.errorr, 20, ' '));
        END LOOP;
        
        
        
        
        
        
        
        
        
        dbms_output.put_line('**********SUCCESS REPORT************');
        dbms_output.put_line(rpad('EMPLOYEE_ID', 20, ' ')
                             || '||'
                             || rpad('FIRST_NAME', 20, ' ')
                             || '||'
                             || rpad('LAST_NAME', 20, ' ')
                             || '||'
                             || rpad('EMAIL', 20, ' ')
                             || ' ||'
                             || rpad('PHONE_NUMBER', 20, ' ')
                             || '||'
                             || rpad('HIRE_DATE', 20, ' ')
                             || '||'
                             || rpad('JOB_ID', 20, ' ')
                             || '||'
                             || rpad('SALARY', 20, ' ')
                             || '||'
                             || rpad('COMMISSION_PCT', 20, ' ')
                             || '||'
                             || rpad('MANAGER ID', 20, ' ')
                             || '||'
                             || rpad('DEPARTMENT ID', 20, ' ')
                             || '||'
                             || rpad('STATUS', 20, ' ')
                             || '||'
                             || rpad('ERROR', 20, ' '));

        FOR rec_report_success IN cur_report_success LOOP
            dbms_output.put_line(rpad(rec_report_success.employee_id, 20, ' ')
                                 || '-'
                                 || rpad(rec_report_success.first_name, 20, ' ')
                                 || '-'
                                 || rpad(rec_report_success.last_name, 0, ' ')
                                 || '-'
                                 || rpad(rec_report_success.email, 20, ' ')
                                 || ' '
                                 || rpad(rec_report_success.phone_number, 20, ' ')
                                 || '-'
                                 || rpad(rec_report_success.hire_date, 20, ' ')
                                 || '-'
                                 || ' '
                                 || rpad(rec_report_success.job_id, 20, ' ')
                                 || '-'
                                 || rpad(rec_report_success.salary, 20, ' ')
                                 || '-'
                                 || rpad(rec_report_success.commission_pct, 20, ' ')
                                 || '-'
                                 || rpad(rec_report_success.manager_id, 20, ' ')
                                 || '-'
                                 || rpad(rec_report_success.department_id, 20, ' ')
                                 || '-'
                                 || rpad(rec_report_success.status, 20, ' ')
                                 || ' '
                                 || rpad(rec_report_success.errorr, 20, ' '));
        END LOOP;
---------------------------error report---------------------------------------
        dbms_output.put_line('**********error REPORT************');
        dbms_output.put_line(rpad('EMPLOYEE_ID', 20, ' ')
                             || '||'
                             || rpad('FIRST_NAME', 20, ' ')
                             || '||'
                             || rpad('LAST_NAME', 20, ' ')
                             || '||'
                             || rpad('EMAIL', 20, ' ')
                             || ' ||'
                             || rpad('PHONE_NUMBER', 20, ' ')
                             || '||'
                             || rpad('HIRE_DATE', 20, ' ')
                             || '||'
                             || rpad('JOB_ID', 20, ' ')
                             || '||'
                             || rpad('SALARY', 20, ' ')
                             || '||'
                             || rpad('COMMISSION_PCT', 20, ' ')
                             || '||'
                             || rpad('MANAGER ID', 20, ' ')
                             || '||'
                             || rpad('DEPARTMENT ID', 20, ' ')
                             || '||'
                             || rpad('STATUS', 20, ' ')
                             || '||'
                             || rpad('ERROR', 20, ' '));

        FOR rec_error_report IN cur_report_error LOOP
            dbms_output.put_line(rpad(rec_error_report.employee_id, 20)
                                 || ' '
                                 || rpad(rec_error_report.first_name, 20)
                                 || ' '
                                 || rpad(rec_error_report.last_name, 20)
                                 || ' '
                                 || rpad(rec_error_report.email, 20)
                                 || ' '
                                 || rpad(rec_error_report.phone_number, 20)
                                 || ' '
                                 || rpad(rec_error_report.hire_date, 20)
                                 || ' '
                                 || rpad(rec_error_report.job_id, 20)
                                 || ' '
                                 || rpad(rec_error_report.salary, 20)
                                 || ' '
                                 || rpad(rec_error_report.commission_pct, 20)
                                 || ' '
                                 || rpad(rec_error_report.manager_id, 20)
                                 || ' '
                                 || rpad(rec_error_report.department_id, 20)
                                 || ' '
                                 || rpad(rec_error_report.status, 20)
                                 || ' '
                                 || rpad(rec_error_report.errorr, 20));
        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR OCCURED  in printing report '
                                 || ' '
                                 || sqlcode
                                 || ' -- '
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
                    employees_seq.NEXTVAL,
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
                    status = 'S'
                WHERE
                        request_id = p_batch_id
                    AND record_id = rec_emp_dtl.record_id;

            EXCEPTION
                WHEN OTHERS THEN
                    UPDATE xxintg_staging_rp
                    SET
                        status = 'E'
                    WHERE
                            request_id = p_batch_id
                        AND record_id = rec_emp_dtl.record_id;
COMMIT;
            END;
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(' error occured in DATA  INSERTION INT EMPLOYEES TABLE'
                                 || ' 
                    '
                                 || sqlcode
                                 || ' '
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

        CURSOR cur_EMP_stng_dtl IS
        SELECT
            *
        FROM
            xxintg_staging_rp
        WHERE
                status = 'N'
            AND request_id = p_batch_id;
BEGIN

    BEGIN
        FOR rec_EMP_stng_dtl IN cur_EMP_stng_dtl LOOP
            lc_status := 'V';
LC_ERROR:=NULL;
/********************************
EMPLOYEE_ID VALIDATION
*********************************/

            IF rec_EMP_stng_dtl.employee_id IS NOT NULL THEN
                SELECT
                    COUNT(employee_id)
                INTO ln_count
                FROM
                    employees
                WHERE
                    employee_id = rec_EMP_stng_dtl.employee_id;

                IF ln_count > 0 THEN
                    dbms_output.put_line('EMPLOYEE_ID ERrec_EMP_stng_dtl');
                    lc_status := 'E';
                    lc_error := ' EMPLOYEE ID ALREADY EXIST ';
                    dbms_output.put_line('1');
                END IF;

            END IF;

/*****************************
FIRST_NAME VALIDATION
******************************/
            IF rec_EMP_stng_dtl.first_name IS NULL THEN
                lc_status := 'E';
                lc_error := lc_error
                            || ' '
                            || 'FIRST_NAME CANNOT BE NULL';
            ELSIF length(rec_EMP_stng_dtl.first_name) > 20 THEN
                lc_status := 'E';
                lc_error := lc_error || '  FIRST_NAME CAN ONLY HAVE 20 CHARACTER';
            END IF;

/*****************************
LAST_NAME VALIDATION
******************************/
            IF rec_EMP_stng_dtl.last_name IS NULL THEN
                lc_status := 'E';
                lc_error := lc_error
                            || ' '
                            || 'LAST NAME CANNNOT BE NULL';
            ELSIF length(rec_EMP_stng_dtl.last_name) > 20 THEN
                lc_status := 'E';
                lc_error := lc_error || '  LAST_NAME CAN ONLY HAVE 20 CHARACTER';
            END IF;



/************************************
EMAIL VALIDATION
*************************************/

            lc_email := upper(rec_EMP_stng_dtl.first_name
                              || '.'
                              || rec_EMP_stng_dtl.last_name)
                        || '@INTELLOGER.COM';

            BEGIN
                SELECT
                    COUNT(email)
                INTO ln_count
                FROM
                    employees
                WHERE
                        upper(first_name) = upper(rec_EMP_stng_dtl.first_name)
                    AND upper(last_name) = upper(rec_EMP_stng_dtl.last_name);

                IF ln_count > 0 THEN
                    lc_email := upper(rec_EMP_stng_dtl.first_name
                                      || '.'
                                      || rec_EMP_stng_dtl.last_name)
                                || ln_count
                                || '@INTELLOGER.COM';

                END IF;
            END;
/********************************************
PHONE NUMBER VALIDATION
**********************************************/

            IF rec_EMP_stng_dtl.phone_number IS NULL THEN
                lc_status := 'E';
                lc_error := lc_error || ' PHONE NUMBER CANNOT BE NULL';
                dbms_output.put_line('EMPLOYEE_ID ERR4');
            ELSIF length(rec_EMP_stng_dtl.phone_number) <> 10 THEN
                dbms_output.put_line('EMPLOYEE_ID ERR5');
                lc_status := 'E';
                lc_error := lc_error || ' PHONE NUMBER HAVE 10 DIGITS NUMBER';
                dbms_output.put_line('3');
            ELSE
                BEGIN
                    ln_count := 0;
                    SELECT
                        COUNT(phone_number)
                    INTO ln_count
                    FROM
                        employees
                    WHERE
                        phone_number = rec_EMP_stng_dtl.phone_number;

                    IF ln_count > 0 THEN
                        dbms_output.put_line('EMPLOYEE_ID ERR6');
                        lc_status := 'E';
                        lc_error := lc_error || ' PHONE NUMBER ALREADY EXIST WRITE A DIFFERENT PHONE NUMBER';
                        dbms_output.put_line('4');
                    END IF;

                END;

                dbms_output.put_line('phone number validate');
            END IF;
 
 /*****************************
  HIRE DATE VALIDATION
 *******************************/
            IF rec_EMP_stng_dtl.hire_date > sysdate THEN
                dbms_output.put_line('EMPLOYEE_ID ERR7');
                lc_status := 'E';
                lc_error := lc_error || ' HIREDATE SHOULD BE LESS THAN AND EQUAL TO SYADATE';
                dbms_output.put_line('5');
            END IF;

            dbms_output.put_line('hiredate validate');

/**********************************
JOB ID VALIDATION
*************************************/

            IF lower(rec_EMP_stng_dtl.job_title) IS NULL THEN
                lc_status := 'E';
                lc_error := lc_error
                            || ' - '
                            || 'Job id can not be null';
                ELSE
                BEGIN
                    SELECT
                        job_id
                    INTO lc_job_id
                    FROM
                        jobs
                    WHERE
                        job_title = rec_EMP_stng_dtl.job_title;

                    dbms_output.put_line('EMPLOYEE_ID ERR8');
                EXCEPTION
                    WHEN OTHERS THEN
                        lc_status := 'E';
                        lc_error := lc_error
                                    || ' '
                                    || 'JOB TITLE DOES NOT EXISTS';
                        dbms_output.put_line('6');
                        dbms_output.put_line('EMPLOYEE_ID ERR9');
                END;

            END IF;

            dbms_output.put_line('jobid validate');

/**********************************************
SALARY VALIDATION
**********************************************/

            IF rec_EMP_stng_dtl.salary IS NULL THEN
                rec_EMP_stng_dtl.salary := 5000;
            ELSE
                IF rec_EMP_stng_dtl.salary < 5000 THEN
                    lc_status := 'E';
                    lc_error := lc_error || ' MINIMUM  SLAARY SHOULD BE  5000';
                    dbms_output.put_line('EMPLOYEE_ID ERrec_EMP_stng_dtl');
                    dbms_output.put_line('7');
                END IF;
            END IF;

            dbms_output.put_line('salary validate');
	/*************************
		*COMMISION PCT VALIDATION
		**************************/
            IF rec_EMP_stng_dtl.commission_pct NOT BETWEEN 0 AND 1 THEN
                dbms_output.put_line('EMPLOYEE_ID ERrec_EMP_stng_dtl1');
                lc_status := 'E';
                lc_error := lc_error || ' COMMISSION PCT CANNOT BE GREATER THAN 1 AND LESS THAN 0';
                dbms_output.put_line('8');
            END IF;

            dbms_output.put_line('commission pct validate');
/**************************
MANAGER ID VALIDATION
*****************************/

            IF rec_EMP_stng_dtl.manager_id IS NULL THEN
                dbms_output.put_line('EMPLOYEE_ID ERrec_EMP_stng_dtl2');
                lc_status := 'E';
                lc_error := lc_error || ' MANAGER ID CANNOT BE NULL';
                dbms_output.put_line('9');
            ELSE
                ln_count := 0;
                SELECT
                    COUNT(*)
                INTO ln_count
                FROM
                    employees
                WHERE
                    employee_id = rec_EMP_stng_dtl.manager_id;
--                    DBMS_OUTPUT.PUT_LINE(LN_COUNT||'EMPLOYEE_ID ERrec_EMP_stng_dtl3');

                IF ln_count <> 1 THEN
                    lc_status := 'E';
                    lc_error := lc_error || ' MANAGER ID DOESNT EXIST';
                    dbms_output.put_line('EMPLOYEE_ID rec_EMP_stng_dtl');
                    dbms_output.put_line('10');
                END IF;

            END IF;
    
    /******************************
    DEPARTMENTID VALIDATION
    *******************************/
            IF rec_EMP_stng_dtl.department_name IS NULL THEN
                lc_status := 'E';
                lc_error := lc_error || ' DEPARTMENT NAME IS MANDATORY PLEASE WRITE A VALID DEPARTMENT NAME';
            ELSE
                BEGIN
                    SELECT
                        department_id
                    INTO lc_department_id
                    FROM
                        departments
                    WHERE
                        lower(department_name) = lower(rec_EMP_stng_dtl.department_name);

                EXCEPTION
                    WHEN OTHERS THEN
                        lc_status := 'E';
                        lc_error := lc_error||' '
                                    || 'DEPARTMENT_ID DOESNT EXIST'
                                    || sqlcode
                                    || ' '
                                    || sqlerrm;
                        dbms_output.put_line('11');
                END;
            END IF;

            dbms_output.put_line(lc_status
                                 || ' HOHO '
                                 || lc_error);
            BEGIN
                UPDATE xxintg_staging_rp
                SET
                    status = lc_status,
                    errorr = lc_error,
                    email = lc_email,
                    department_id = lc_department_id,
                    job_id = lc_job_id
                WHERE
                        record_id = rec_EMP_stng_dtl.record_id
                    AND request_id = p_batch_id;

            EXCEPTION
                WHEN OTHERS THEN
                    dbms_output.put_line(' CANNOT UPDATE STATUS,ERROR,EMAIL,DEPARTMENT,JOBID INTO STAGING TABLE'||sqlcode
                                         || ' | '
                                         || sqlerrm);
            END;

            COMMIT;
            dbms_output.put_line(lc_status
                                 || ' HOHO '
                                 || lc_error);

        END LOOP;
        EXCEPTION WHEN OTHERS THEN 
LC_STATUS:='E';
LC_ERROR:=LC_ERROR||' '||'ERROR OCCURED  IN VALIDATION  LOOP';
END;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR IN VALIDATING DATA '||sqlcode || '-'||sqlerrm);
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
            'KADAR',
            'KHAN',
            '',
            7566908765,
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
            'rOBhit',
            'panwar',
            '',
            8976530000,
            sysdate-6,
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
            'ANITA',
            'PANWAR',
            '',
            8755800932,
            sysdate - 6,
            '',
            'Programmer',
            80000,
            0.8,
            126,
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
            'DOLY',
            'panwar',
            '',
            8976123000,
            sysdate-6,
            '',
            'Programmer',
            10000,
            0.9,
            122,
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
            'RAHUL SINGH',
            'PANWAR',
            '',
            8700841932,
            sysdate - 6,
            '',
            'Programmer',
            60000,
            0.3,
            111,
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
            'SARDR',
            'panwar',
            '',
            8911130000,
            sysdate-6,
            '',
            'Programmer',
            56000,
            0.4,
            129,
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
            dbms_output.put_line('ERROR OCCURED in INSERTING THE DATA IN staging table'
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
        dbms_output.put_line(rpad('BATCH_ID', 20)
                             || ' '
                             || rpad('Process_type', 20));

        dbms_output.put_line(rpad(p_batch_id, 20)
                             || ' '
                             || rpad(p_process_type, 20));

        dbms_output.put_line('PARAMETER PRINTED SUCCESSFULLY');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR OCCURED'
                                 || sqlcode
                                 || '-'
                                 || sqlerrm);
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
        IF p_batch_id IS NULL THEN
            dbms_output.put_line('BATCH ID CANNOT BE NULL');
        ELSE
            SELECT
                COUNT(*)
            INTO ln_count
            FROM
                xxintg_staging_rp
            WHERE
                    REQUEST_id = p_batch_id;

            IF ln_count > 0 THEN
                dbms_output.put_line('ERROR OCCURED '||' BATCH ID ALREADY SUCCESS BEFORE');
    ELSE
            load_in_staging_table(p_batch_id);
            IF upper(p_process_type) = 'VALIDATE ONLY' THEN
                validate_data(p_batch_id);
                print_report(p_batch_id, p_process_type);
            ELSIF upper(p_process_type) = 'VALIDATE AND INSERT' THEN
                validate_data(p_batch_id);
                load_emp_data(p_batch_id);
                print_report(p_batch_id, p_process_type);
            END IF;

        END IF;
END IF;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR OCCURED IN MAIN PROCESS'||' '||sqlcode
                                 || ' '
                                 || sqlerrm);
    END main_procedure;

END xxintg_validate_and_insert;
    
    ------------------------------------------------------------------------------
