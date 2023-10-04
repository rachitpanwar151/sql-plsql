CREATE OR REPLACE PACKAGE BODY insert_validate_via_cursor_and_staging_table AS
GN_SCOUNT NUMBER;
GN_ECOUNT NUMBER;
GN_TCOUNT NUMBER;

    PROCEDURE print_parameter (
        p_batch_id     NUMBER,
        p_process_type VARCHAR2
    ) AS
    BEGIN
        dbms_output.put_line(rpad('p_batch_id', 30)
                             || rpad('p_process_type', 30));
                             
                             
            DBMS_OUTPUT.PUT_LINE(' parameetr prointed');
    END print_parameter;

    PROCEDURE insert_into_staging (
        p_batch_id NUMBER
    ) AS
    BEGIN
        INSERT INTO xxintg_staging_rp (
            request_id,
            record_id,
            employee_id,
            first_name,
            last_name,
            email,
            phone_number,
            hire_date,
            job_id,
            job_title,
            salary,
            commission_pct,
            manager_id,
            department_id,
            department_name,
            created_by,
            last_updated_by,
            created_date,
            last_updated_date,
            login_id,
            status,
            errorr
        ) VALUES (
            p_batch_id,
            record_id.NEXTVAL,
            '',
            'rachit',
            'panwar',
            '',
            9800003210,
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
            dbms_output.put_line(sqlcode
                                 || '-'
                                 || sqlerrm);
    END insert_into_staging;
procedure validatee(p_batch_id number)
as
        lc_status  VARCHAR2(20);
        lc_error   VARCHAR2(2000);
        ln_count   NUMBER;
        lc_job_id  VARCHAR2(20);
        lc_dept_id VARCHAR2(40);
        lc_email   VARCHAR2(40);
        CURSOR cur_c1 IS
        SELECT
            *
        FROM
            xxintg_staging_rp
        WHERE
                request_id = p_batch_id
            AND status = 'N';

    BEGIN
    
            DBMS_OUTPUT.PUT_LINE('000');
        FOR rec_r1 IN cur_c1 
        LOOP
            lc_status := 'V';
/**********************************
EMPLOYEE_ID VALIDATION
***********************************/

            IF rec_r1.employee_id IS NOT NULL THEN
                SELECT
                    COUNT(*)
                INTO ln_count
                FROM
                    employees
                WHERE
                    employee_id = rec_r1.employee_id;

                IF ln_count > 0 THEN
                    lc_status := 'E';
                    lc_error := lc_error || 'EMPLOYEE_ID IS ALREADY EXISTS';
                END IF;

            END IF;
            DBMS_OUTPUT.PUT_LINE('EMPLOYEE VALIDATED');
        /*******************************************************
        PHONE NUMBER VALIDATION
        ********************************************************/

            IF rec_r1.phone_number IS NULL THEN
                lc_status := 'E';
                lc_error := lc_error
                            || ' '
                            || 'PHONE NUMBER CAN NOT BE NULL';
            ELSIF length(rec_r1.phone_number) != 10 THEN
                lc_status := 'E';
                lc_error := lc_error
                            || ' '
                            || 'PHONE NUMBER SHOULD ONLY A 10 DIGITS NUMBER';
            ELSE
                SELECT
                    COUNT(rec_r1.phone_number)
                INTO ln_count
                FROM
                    employees
                WHERE
                    phone_number = rec_r1.phone_number;

                IF ln_count > 0 THEN
                    lc_status := 'E';
                    lc_error := lc_error
                                || ' '
                                || 'PHONE NUMBER ALREADY EXISTS';
                END IF;

            END IF;
            
            DBMS_OUTPUT.PUT_LINE('PHONE NUMBER VALIDATED');
            /***************************************************
            HIRE DATE VALIDATION
            ****************************************************/

            IF rec_r1.hire_date IS NULL THEN
                lc_status := 'E';
                lc_error := lc_error
                            || ' '
                            || 'HIRE DATE CAN NOT BE NULL';
            ELSIF rec_r1.hire_date > sysdate THEN
                lc_status := 'E';
                lc_error := lc_error || ' HIRE DATE CANNOT BE GREATER THEN SYSDATE';
            END IF;
 

            DBMS_OUTPUT.PUT_LINE('HIREDATE VALIDATED');
            /***********************************************
            JOB ID VALIDATION
            ************************************************/
            BEGIN
                SELECT
                    job_id
                INTO lc_job_id
                FROM
                    jobs
                WHERE
                    job_title = rec_r1.job_title;

            EXCEPTION
                WHEN OTHERS THEN
                    lc_status := 'E';
                    lc_error := lc_error
                                || ' '
                                || 'JOB ID DOES NOT EXISTS';
            END;
    
    
            DBMS_OUTPUT.PUT_LINE('JOBID VALIDATED');
    /*******************************
    SALARY VALIDATION
    ********************************/

            IF rec_r1.salary < 5000 THEN
                lc_status := 'E';
                lc_error := lc_error || ' SALARY SHOULD BE GREATER THAN 5000';
            END IF;
		
		
            DBMS_OUTPUT.PUT_LINE('SALARY VALIDATED');
		/*************************
		*COMMISION PCT VALIDATION
		**************************/

            IF rec_r1.commission_pct NOT BETWEEN 0 AND 1 THEN
                lc_status := 'E';
                lc_error := lc_error || ' COMMISSION PCT CANNOT BE GREATER THAN 1 AND LESS THAN 0';
            END IF;


            DBMS_OUTPUT.PUT_LINE('COMM PCT VALIDATED');
            dbms_output.put_line(lc_status
                                 || '-'
                                 || lc_error);
							 
      /************************************************
      MANAGER ID  VALIDATION
********************************************************/

            IF rec_r1.manager_id IS NULL THEN
                lc_status := 'E';
                lc_error := lc_error || ' MANAGER ID CANNOT BE NULL';
            ELSE
                SELECT
                    COUNT(*)
                INTO ln_count
                FROM
                    employees
                WHERE
                    employee_id = rec_r1.manager_id;

                IF ln_count <> 1 THEN
                    dbms_output.put_line('10');
                    lc_status := 'E';
                    lc_error := lc_error || ' MANAGER SHOULD BE AN EMPLOYEE';
                END IF;

            END IF;


            DBMS_OUTPUT.PUT_LINE('MANAGER ID VALIDATED');
            dbms_output.put_line(lc_status
                                 || '-'
                                 || lc_error);
							 
        /******************************************
        DEPARTMENT ID VALIDATION
        ********************************************/

            IF rec_r1.department_id IS NULL THEN
                dbms_output.put_line('11');
                lc_status := 'E';
                lc_error := lc_error || ' DEPARTMENT_ID IS NULL';
            ELSE
                SELECT
                    department_id
                INTO lc_dept_id
                FROM
                    departments
                WHERE
                    department_id = rec_r1.department_id;

            END IF;

            DBMS_OUTPUT.PUT_LINE('DEPARTMENT ID VALIDATED');
/**************************
EMAIL VALIDATION
***************************/

            rec_r1.email := rec_r1.first_name
                            || '.'
                            || rec_r1.last_name
                            || '@INTELLOGER.COM';

            BEGIN
                SELECT
                    COUNT(email)
                INTO ln_count
                FROM
                    employees
                WHERE
                        upper(first_name) = upper(rec_r1.first_name)
                    AND upper(last_name) = upper(rec_r1.last_name);

                IF ln_count > 0 THEN
                    lc_email := rec_r1.first_name
                                || '.'
                                || rec_r1.last_name
                                || ln_count
                                || '@INTELLOGER.COM';

                END IF;
        
            END;


            DBMS_OUTPUT.PUT_LINE('EMAIL VALIDATED');
        ------------------------------------------------------------
            UPDATE xxintg_staging_rp
            SET
                status = lc_status,
                errorr = lc_error,
                job_id = lc_job_id,
                department_id = lc_dept_id,
                email = lc_email      
                WHERE
                    record_id = rec_r1.record_id
                AND request_id = p_batch_id;

        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            lc_status := 'E';
            lc_error := 'ERROR IN PERFORMING VALIDATION '
                        || sqlcode
                        || '-'
                        || sqlerrm;
    END validatee;

    PROCEDURE insert_into_employees (
        p_batch_id NUMBER
    ) AS
        CURSOR cur_c2 IS
        SELECT
            *
        FROM
            xxintg_staging_rp
        WHERE
                status = 'V'
            AND request_id = p_batch_id;

    BEGIN
        FOR rec_r2 IN cur_c2 LOOP
            INSERT INTO employees VALUES (
                rec_r2.employee_id,
                rec_r2.first_name,
                rec_r2.last_name,
                rec_r2.email,
                rec_r2.phone_number,
                rec_r2.hire_date,
                rec_r2.job_id,
                rec_r2.salary,
                rec_r2.commission_pct,
                rec_r2.manager_id,
                rec_r2.department_id
            );

            UPDATE xxintg_staging_rp
            SET
                status = 'S', 
                employee_id=employees_seq.nextval
            WHERE
                    request_id = p_batch_id
                AND record_id = rec_r2.record_id;

        END LOOP;
    END insert_into_employees;
procedure reportt(p_batch_id varchar2
,p_process_type varchar2)

        as
        begin
    SELECT COUNT(*) INTO Gn_TCOUNT FROM XXINTG_staging_rp;
       SELECT COUNT(*) INTO GN_SCOUNT FROM XXINTG_STAGING_RP WHERE STATUS='S';
       SELECT COUNT(*) INTO GN_ECOUNT FROM XXINTG_STAGING_RP WHERE STATUS='E';
        DBMS_OUTPUT.PUT_LINE(RPAD('TC_COUNT',30)|| ' '||RPAD('GN_SCOUNT',30)||' '||RPAD('GN_ECOOUNT',30));
        DBMS_OUTPUT.PUT_LINE(RPAD(gn_tCOUNT,30)|| ' '||RPAD(GN_SCOUNT,30)||' '||RPAD(GN_ECOUNT,30));      
        end reportt;
    PROCEDURE main_value_dump (
        p_batch_id     NUMBER,
        p_process_type VARCHAR2
    ) AS
    BEGIN
        IF P_PROCESS_TYPE='VALIDATE ONLY'
        THEN
     print_parameter(p_batch_id,p_process_type);   
        insert_into_staging(p_batch_id);
        reportt(p_batch_id,p_process_type);
       ELSIF p_PROCESS_TYPE='VALIDATE AND INSERT'
        THEN
        insert_into_staging(p_batch_id);
validatee (p_batch_id )   ;      
         insert_into_employees ( p_batch_id ) ;
        reportt(p_batch_id,p_process_type);
END IF;          
            END main_value_dump;

END insert_validate_via_cursor_and_staging_table; 

-----------------------------------------------------------------------------------
BEGIN
    value_dump_not_duplicate.main_value_dump(1,'VALIDATE ONLY');
END;

SELECT
    *
FROM
    xxintg_staging_rp;

SELECT
    *
FROM
    employees;

TRUNCATE TABLE xxintg_staging_rp;