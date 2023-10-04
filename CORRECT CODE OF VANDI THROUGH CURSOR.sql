CREATE OR REPLACE PACKAGE BODY xxintg_v_i_pckg AS

/***************************
GLOBAL VARIABLE DECLERATION
****************************/
    gn_tcount NUMBER;
    gn_scount NUMBER;
    gn_ecount NUMBER;
/***********************
PACKAGE BODY
************************/

    PROCEDURE print_parameter (
        p_batch_id   NUMBER,
        p_process_id VARCHAR2
    ) AS
/*********************************
PROCEDURE FOR PARAMETER PRINTING
***********************************/

    BEGIN
        dbms_output.put_line(rpad('P_BATCH_ID', 20)
                             || ' '
                             || rpad('P_PROCESS_ID', 20));

        dbms_output.put_line('PARAMETER PRINTED SUCCESSFULLY');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR OCCURED'
                                 || sqlcode
                                 || '-'
                                 || sqlerrm);
    END print_parameter;

/****

select * from XXINTG_STAGING_RP;
TRUNCATE TABLE  XXINTG_STAGING_RP;
DROP TABLE XXINTG_STAGING_RP;
*****/

/**********************************************
PROCEDURE FOR INSERTING VALUE IN STAGING 
***********************************************/

    PROCEDURE insert_into_staging (
        p_batch_id NUMBER
    ) AS
    BEGIN
        INSERT INTO xxintg_staging_rp VALUES (
            p_batch_id,
            record_id.NEXTVAL,
            '',
            'rachit',
            'panwar',
            '',
            8976532109,
            sysdate,
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

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR OCCURED'
                                 || sqlcode
                                 || '-'
                                 || sqlerrm);
    END insert_into_staging;

/***********************************************
VALIDATING VALUES
************************************************/
    PROCEDURE validatee (
        p_batch_id NUMBER
    ) AS
/**********************************************
LOCAL VARIABLES
**********************************************/
        lc_email         VARCHAR2(50);
        ln_count         NUMBER;
        lc_status        VARCHAR2(30);
        lc_error         VARCHAR2(3000);
        lc_department_id VARCHAR2(50);
        lc_job_id        VARCHAR2(30);
--DECLARING CURSOR FOR VALIDATION

        CURSOR c1 IS
        SELECT
            *
        FROM
            xxintg_staging_rp
        WHERE
                status = 'N'
            AND request_id = p_batch_id;

    BEGIN
        FOR r1 IN c1 LOOP
            lc_status := 'V';

/********************************
EMPLOYEE_ID VALIDATION
*********************************/

            IF r1.employee_id IS NOT NULL THEN
                SELECT
                    COUNT(employee_id)
                INTO ln_count
                FROM
                    employees
                WHERE
                    employee_id = r1.employee_id;

                IF ln_count > 0 THEN
                    dbms_output.put_line('EMPLOYEE_ID ERR1');
                    lc_status := 'E';
                    lc_error := ' EMPLOYEE ID ALREADY EXIST ';
                    dbms_output.put_line('1');
                END IF;

            END IF;

/************************************
EMAIL VALIDATION
*************************************/

            lc_email := r1.first_name
                        || ' '
                        || r1.last_name
                        || '@INTELLOGER.COM';
            BEGIN
                SELECT
                    COUNT(email)
                INTO ln_count
                FROM
                    employees
                WHERE
                        upper(first_name) = upper(r1.first_name)
                    AND upper(last_name) = upper(r1.last_name);

                IF ln_count > 0 THEN
                    lc_email := r1.first_name
                                || '.'
                                || r1.last_name
                                || to_char(ln_count)
                                || '@INTELLOGER.COM';

                    dbms_output.put_line('EMPLOYEE_ID ERR2');
                END IF;

                dbms_output.put_line('EMail VALIDATED');
            EXCEPTION
                WHEN OTHERS THEN
                    lc_status := 'E';
                    lc_error := lc_error
                                || ' CANT GENERATE EMAIL'
                                || sqlcode
                                || sqlerrm;
                    dbms_output.put_line('EMPLOYEE_ID ERR3');
                    dbms_output.put_line('2');
            END;
/********************************************
PHONE NUMBER VALIDATION
**********************************************/

            IF r1.phone_number IS NULL THEN
                lc_status := 'E';
                lc_error := lc_error || ' PHONE NUMBER CANNOT BE NULL';
                dbms_output.put_line('EMPLOYEE_ID ERR4');
            ELSIF length(r1.phone_number) <> 10 THEN
                dbms_output.put_line('EMPLOYEE_ID ERR5');
                lc_status := 'E';
                lc_error := lc_error || ' PHONE NUMBER HAVE 10 DIGITS NUMBER';
                dbms_output.put_line('3');
            ELSE
                BEGIN
                    SELECT
                        COUNT(phone_number)
                    INTO ln_count
                    FROM
                        employees
                    WHERE
                        phone_number = r1.phone_number;

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
            IF r1.hire_date > sysdate THEN
                dbms_output.put_line('EMPLOYEE_ID ERR7');
                lc_status := 'E';
                lc_error := lc_error || ' HIREDATE SHOULD BE LESS THAN AND EQUAL TO SYADATE';
                dbms_output.put_line('5');
            END IF;

            dbms_output.put_line('hiredate validate');

/**********************************
JOB ID VALIDATION
*************************************/
            BEGIN
                SELECT
                    job_id
                INTO lc_job_id
                FROM
                    jobs
                WHERE
                    job_title = r1.job_title;

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

            dbms_output.put_line('jobid validate');

/**********************************************
SALARY VALIDATION
**********************************************/
            IF r1.salary < 0 THEN
                lc_status := 'E';
                lc_error := lc_error || ' SLAARY SHOULD BE GREATER THAN 0';
                dbms_output.put_line('EMPLOYEE_ID ERR10');
                dbms_output.put_line('7');
            END IF;

            dbms_output.put_line('salary validate');
	/*************************
		*COMMISION PCT VALIDATION
		**************************/
            IF r1.commission_pct NOT BETWEEN 0 AND 1 THEN
                dbms_output.put_line('EMPLOYEE_ID ERR11');
                lc_status := 'E';
                lc_error := lc_error || ' COMMISSION PCT CANNOT BE GREATER THAN 1 AND LESS THAN 0';
                dbms_output.put_line('8');
            END IF;

            dbms_output.put_line('commission pct validate');
/**************************
MANAGER ID VALIDATION
*****************************/

            IF r1.manager_id IS NULL THEN
                dbms_output.put_line('EMPLOYEE_ID ERR12');
                lc_status := 'E';
                lc_error := lc_error || ' MANAGER ID CANNOT BE NULL';
                dbms_output.put_line('9');
            ELSE
                SELECT
                    COUNT(*)
                INTO ln_count
                FROM
                    employees
                WHERE
                    employee_id = r1.manager_id;
--                    DBMS_OUTPUT.PUT_LINE(LN_COUNT||'EMPLOYEE_ID ERR13');

                IF ln_count <> 1 THEN
                    lc_status := 'E';
                    lc_error := lc_error || ' MANAGER ID DOESNT EXIST';
                    dbms_output.put_line('EMPLOYEE_ID ERR13');
                    dbms_output.put_line('10');
                END IF;

            END IF;
    
    /******************************
    DEPARTMENTID VALIDATION
    *******************************/

            BEGIN
                SELECT
                    department_id
                INTO lc_department_id
                FROM
                    departments
                WHERE
                    lower(department_name) = lower(r1.department_name);

            EXCEPTION
                WHEN OTHERS THEN
                    lc_status := 'E';
                    lc_error := lc_error
                                || 'DEPARTMENT_ID DOESNT EXIST'
                                || sqlcode
                                || ' '
                                || sqlerrm;
                    dbms_output.put_line('11');
            END;
DBMS_OUTPUT.PUT_LINE(LC_STATUS||' HOHO '||LC_ERROR);
            UPDATE xxintg_staging_rp
            SET
                status = lc_status,
                errorr = lc_error,
                email = lc_email,
                department_id = lc_department_id,
                job_id = lc_job_id
            WHERE
                    record_id = r1.record_id
                AND request_id = p_batch_id;
                COMMIT;
DBMS_OUTPUT.PUT_LINE(LC_STATUS||' HOHO '||LC_ERROR);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('EMPLOYEE_ID ERR20');
            dbms_output.put_line(sqlcode || sqlerrm);
    END validatee;

    PROCEDURE insert_into_employees (
        p_batch_id NUMBER
    ) AS
        CURSOR c2 IS
        SELECT
            *
        FROM
            xxintg_staging_rp
        WHERE
                status = 'V'
            AND request_id = p_batch_id;

    BEGIN
        dbms_output.put_line('YAHAHAHAHAHAHAHAH');
        FOR r2 IN c2 LOOP
            INSERT INTO employees VALUES (
                r2.employee_id,
                r2.first_name,
                r2.last_name,
                r2.email,
                r2.phone_number,
                r2.hire_date,
                r2.job_id,
                r2.salary,
                r2.commission_pct,
                r2.manager_id,
                r2.department_id
            );

            UPDATE xxintg_staging_rp
            SET
                status = 'S',
                employee_id = employees_seq.NEXTVAL
            WHERE
                    request_id = p_batch_id
                AND record_id = r2.record_id;

        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR OCCURED AT INSETION IN BASE TABLE'
                                 || sqlcode
                                 || ' '
                                 || sqlerrm);
    END insert_into_employees;

    PROCEDURE reportt (
        p_batch_id     NUMBER,
        p_process_type VARCHAR2
    ) AS
    BEGIN


        SELECT
            COUNT(*)
        INTO gn_tcount
        FROM
            xxintg_staging_rp;

        SELECT
            COUNT(*)
        INTO gn_scount
        FROM
            xxintg_staging_rp
        WHERE
            status = 'S';

        SELECT
            COUNT(*)
        INTO gn_ecount
        FROM
            xxintg_staging_rp
        WHERE
            status = 'E';

        dbms_output.put_line(rpad('TOTAL_COUNT', 30)
                             || ' '
                             || rpad('S_STATUS_COUNT', 30)
                             || ' '
                             || rpad('E_STATUS_COUNT', 30));

        dbms_output.put_line(rpad(gn_tcount, 30)
                             || ' '
                             || rpad(gn_scount, 30)
                             || ' '
                             || rpad(gn_ecount, 30));

    END reportt;

    PROCEDURE main_procedure (
        p_batch_id     NUMBER,
        p_process_type VARCHAR2
    ) AS
    BEGIN
        IF p_process_type = 'VALIDATE ONLY' THEN
            print_parameter(p_batch_id, p_process_type);
            insert_into_staging(p_batch_id);
            validatee(p_batch_id);
            reportt(p_batch_id, p_process_type);
        ELSIF p_process_type = 'VALIDATE AND INSERT' THEN
            insert_into_staging(p_batch_id);
            validatee(p_batch_id);
            insert_into_employees(p_batch_id);
            reportt(p_batch_id, p_process_type);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlcode
                                 || ' '
                                 || sqlerrm);
    END main_procedure;

END xxintg_v_i_pckg;
----------------------END OF PACKAGE-------------------

BEGIN
    xxintg_v_i_pckg.main_procedure(1, 'VALIDATE ONLY');
END;

SELECT
    *
FROM
    xxintg_staging_rp;

SELECT
    *
FROM
    employees;