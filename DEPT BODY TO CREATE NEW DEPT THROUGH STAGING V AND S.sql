CREATE OR REPLACE PACKAGE BODY xxintg_dept_rp_fe AS


/**************************************************************************************************
VERSION            WHEN            WHO                       WHY
 
1.0           2-AUGUST-2023    RACHIT PANWAR           TO MAKE A PACKAGE BODY TO UPDATE AND
                                                      AND INSERT DETAILS IN STAGING AND BASE TABLE
**************************************************************************************************/
	
    
    
  ------------------------>GLOBAL VARIABLE
    gn_max_wait        VARCHAR2(200);
    gn_interval        VARCHAR2(300);
    gc_error_flag      BOOLEAN;
    gn_cp_request_id   VARCHAR2(200);
    gc_status          VARCHAR2(200);
    gc_data_validation VARCHAR2(300);
    gc_error_message   VARCHAR2(2000);
    gc_conc_status     NUMBER;
    gc_phase           VARCHAR2(200);
    gn_chk             NUMBER; -- For validating count of a particular value
    gc_chk             VARCHAR2(2); --For validating check
    g_user_id          fnd_user.user_id%TYPE := fnd_profile.value('USER_ID');  -- Geeting user Id
    g_resp_id          fnd_responsibility_tl.responsibility_id%TYPE := fnd_profile.value('RESP_ID'); --Getting REsponsibiity ID
    g_resp_appl_id     fnd_responsibility_tl.application_id%TYPE := fnd_profile.value('RESP_APPL_ID'); --Getting application ID
    g_request_id       fnd_concurrent_requests.request_id%TYPE := fnd_profile.value('CONC_REQUEST_ID');
    g_interval         NUMBER;
    g_max_weight       NUMBER;
    g_phase            VARCHAR2(100);
    g_status           VARCHAR2(100);
    g_conc_status      BOOLEAN;
    gc_dev_phase       VARCHAR2(100);
    gc_dev_status      VARCHAR2(100);
    gc_message         VARCHAR2(1000);
    gn_count           NUMBER;

/*******************************
PROCEDURE OF PRINTING PARAMETER
*******************************/
    PROCEDURE print_parameter (
        g_request_id   IN NUMBER,
        p_process_type IN VARCHAR2
    ) AS
    BEGIN
        fnd_file.put_line(fnd_file.output, rpad('PARAMETERS', 25, ' '));
        fnd_file.put_line(fnd_file.output, '');
        fnd_file.put_line(fnd_file.output, rpad('BATCH ID ', 25, ' ')
                                           || ':-'
                                           || rpad(g_request_id, 25, ' '));

        fnd_file.put_line(fnd_file.output, rpad('PROCESS TYPE', 25, ' ')
                                           || ':-'
                                           || rpad(p_process_type, 25, ' '));

        fnd_file.put_line(fnd_file.output, '');
    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output, 'ERROR IN PRINTING PARAMETERS'
                                               || '-'
                                               || sqlcode
                                               || '-'
                                               || sqlerrm);
    END print_parameter;
/****************************************************
PROCEDURE OF LOADING DATA INTO STAGING TABLE.
*****************************************************/

    PROCEDURE load_data_in_staging (
        p_file_name IN VARCHAR2
    ) AS
        l_request_id NUMBER;
    BEGIN
        mo_global.init('PO');
        fnd_global.apps_initialize(user_id => g_user_id, 
        resp_id => g_resp_id, resp_appl_id => g_resp_appl_id);

        l_request_id := fnd_request.submit_request(application => 'XXINTG',
        program => 'XXINTG_RACHIT',
        description => 'REQUEST CONCURRENT PROGRAM TO EXECUTE FROM API-BACKEND SJ'
        , start_time => sysdate, sub_request => FALSE,
            argument1 => '/u01/install/APPS/fs1/EBSapps/appl/xxintg/12.0.0/bin/XXINTG_DEPT_CONTROL_FILE_RP.CTL'
          , argument2 => '/tmp/RPANWAR/DEPT_RP/',
          argument3 => p_file_name||'.csv',
          argument4 => '/tmp/RPANWAR/DEPT_RP/DPT_LOG_rp.log'
             , argument5 => '/tmp/RPANWAR/DEPT_RP/DPT_BAD_rp.bad',
        argument6 => '/tmp/RPANWAR/DEPT_RP/DPT_DIS_rp.dis', 
        argument7 => '/tmp/RPANWAR/DEPT_RP/'
                                                  );

        COMMIT;
        IF ( l_request_id = 0 ) THEN
            fnd_file.put_line(fnd_file.log, 'Request not Submitted');
        ELSE
            fnd_file.put_line(fnd_file.log, 'Request submitted with request id - ' || l_request_id);
            LOOP
                g_conc_status := fnd_concurrent.wait_for_request(request_id => l_request_id, INTERVAL => 1, max_wait => 0, phase => g_phase
                , status => g_status,
                                                                dev_phase => gc_dev_phase, dev_status => gc_dev_status, message => gc_message
                                                                );

                EXIT WHEN upper(g_phase) = 'COMPLETED' OR upper(g_status) IN ( 'CANCELLED', 'ERROR', 'TERMINATED' );

            END LOOP;

            IF (
                upper(g_phase) = 'COMPLETED'
                AND upper(g_status) = 'NORMAL'
            ) THEN
                BEGIN
                    UPDATE xxintg_staging_dept_rp
                    SET
                        request_id = g_request_id,
                        created_by = g_user_id,
                        last_updated_by = g_user_id,
                        created_date = sysdate,
                        last_updated_date = sysdate,
                        record_id=record_seq.NEXTVAL
                        
                    WHERE
                        status = 'N';

                    COMMIT;
                EXCEPTION
                    WHEN OTHERS THEN
                        fnd_file.put_line(fnd_file.output, sqlcode || sqlerrm);
                END;
            END IF;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output, 'Unexpected error '
                                               || sqlcode
                                               || ' - '
                                               || sqlerrm);

            COMMIT;
    END load_data_in_staging;
    
    
    
/****************************************
VALIDATE_PROCEDURE FOR VALIDATING DATA
****************************************/
    PROCEDURE validate_procedure (
        g_request_id IN NUMBER
    ) AS

--cursor for dept validation
        CURSOR cur_dept_val 
        IS
        SELECT
            *
        FROM
            xxintg_staging_dept_rp
        WHERE
                request_id = g_request_id
            AND status = 'N';

/*****************
Local variables
*****************/
        lc_status      VARCHAR2(10);
        lc_errorr      VARCHAR2(10000);
        ln_count       NUMBER;
        lc_dept        VARCHAR2(50);
        ln_dcount       NUMBER;
        ln_location_id NUMBER;
    BEGIN
        FOR rec_dept_val IN cur_dept_val LOOP
            lc_status := 'V';
            lc_errorr := NULL;
            BEGIN
/*****************************
validation for dept name
*****************************/

                IF rec_dept_val.department_name IS NULL THEN
                    lc_status := 'E';
                    lc_errorr := lc_errorr
                                 || '-'
                                 || 'Department name can not be null';
                ELSE
                        SELECT
                            COUNT(department_name)
                        INTO ln_dcount
                        FROM
                            departments
                        WHERE
                            upper(department_name) = upper(rec_dept_val.department_name);

                        IF ln_dcount >0 THEN
                    lc_status := 'E';
                    lc_errorr := lc_errorr
                                 || '-'
                                 || ' department name already exist in department table';
                        END IF;
                END IF;
/**************************
validation for manager_id
**************************/

                SELECT
                    COUNT(*)
                INTO ln_count
                FROM
                    employees
                WHERE
                    employee_id = rec_dept_val.manager_id;

                IF ln_count = 0 THEN
                    lc_status := 'E';
                    lc_errorr := lc_errorr
                                 || '-'
                                 || ' Manager should be employee';
                END IF;
/**********************************
validation for location id
***********************************/

                BEGIN
                    SELECT
                        location_id
                    INTO ln_location_id
                    FROM
                        locations
                    WHERE
                        upper(city) = upper(rec_dept_val.city);

                EXCEPTION
                    WHEN OTHERS THEN
                        lc_status := 'E';
                        lc_errorr := lc_errorr
                                     || '-'
                                     || 'city is wrong please enter correct city to get
                                     correct location id'
                                     || sqlcode
                                     || '-'
                                     || sqlerrm;

                END;
                UPDATE xxintg_staging_dept_rp
                SET
                    status = lc_status,
                    errorr = lc_errorr,
                    department_id=DEPARTMENTID_SEQ.NEXTVAL
                    ,location_id=ln_location_id
WHERE
                        record_id = rec_dept_val.record_id
                    AND request_id = g_request_id;
commit;
            EXCEPTION
                WHEN OTHERS THEN
                    fnd_file.put_line(fnd_file.log, 'Error occured while updating for record '
                                                    || g_request_id
                                                    || '-'
                                                    || rec_dept_val.record_id
                                                    || ' '
                                                    || sqlcode
                                                    || ' | '
                                                    || sqlerrm);
            END;

            fnd_file.put_line(fnd_file.log, lc_status);
            fnd_file.put_line(fnd_file.log, rec_dept_val.errorr);
    
        END LOOP;

        fnd_file.put_line(fnd_file.log, lc_status);
    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.log, 'Error occured in validation procedure'
                                            || ' '
                                            || sqlcode
                                            || ' | '
                                            || sqlerrm);
    END validate_procedure;
    
    
    
/***********************
INSERT INTO BASE TABLE.
***********************/

    PROCEDURE insert_in_dept (
        g_request_id IN NUMBER
    ) AS	
    lc_e VARCHAR2(3000);
--CURSOR FOR INSERTING DATA IN BASE TABLE.

        CURSOR curr_ins_base_tbl IS
        SELECT
            *
        FROM
            xxintg_staging_dept_rp
            WHERE STATUS = 'V';

            --DECALRING VARIABLE
        
    BEGIN
        FOR rec_curr_ins_base_tbl IN curr_ins_base_tbl LOOP
            BEGIN
                INSERT INTO departments VALUES (
                    DEPARTMENTID_SEQ.NEXTVAL,
            /*                    
                    CREATE SEQUENCE DEPARTMENTID_SEQ
                    START WITH 1
                    INCREMENT BY 1;
              */             
                    rec_curr_ins_base_tbl.department_name,
                    rec_curr_ins_base_tbl.manager_id,
                    rec_curr_ins_base_tbl.location_id
                );

                UPDATE xxintg_staging_dept_rp
                SET
department_id=DEPARTMENTID_SEQ.currval,
                    status = 'S'
                WHERE
                        record_id = rec_curr_ins_base_tbl.record_id
                    AND request_id = g_request_id;
COMMIT;
            EXCEPTION
                WHEN OTHERS THEN
                 lc_e := 'ERROR OCCURED IN INSERTING DATA '
                            || sqlcode
                            || sqlerrm;
                   
                    UPDATE xxintg_staging_dept_rp
                    SET
                        status = 'E',
                        errorr = lc_e
                    WHERE
                            request_id = g_request_id
                        AND record_id = rec_curr_ins_base_tbl.record_id;

            END;

            COMMIT;
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output, 'ERROR IN BASE TABLE INSERT'
                                               || sqlcode
                                               || '-'
                                               || sqlerrm);
    END insert_in_dept;

/******************************
PROCEDURE FOR PRINTING REPORT 
*******************************/

    PROCEDURE print_report (
        g_request_id   IN NUMBER,
        p_process_type IN VARCHAR2
    ) AS
	
/***************************
LOCAL VARIABLE DECLERATION
****************************/
        ln_tcount NUMBER;
        ln_vcount NUMBER;
        ln_ecount NUMBER;
        ln_scount NUMBER;
    
--CURSOR FOR PRINTING ERROR REPORT.        

        CURSOR curr_print_error IS
        SELECT
            *
        FROM
            xxintg_staging_dept_rp
        WHERE
                request_id = g_request_id
            AND status = 'E';
        
--CURSOR FOR PRINTING VALIDATE REPORT. 

        CURSOR curr_print_validate IS
        SELECT
            *
        FROM
            xxintg_staging_dept_rp
        WHERE
                request_id = g_request_id
            AND status = 'V';   
       
--CURSOR FOR PRINTING SUCCESS REPORT.

        CURSOR curr_print_success IS
        SELECT
            *
        FROM
            xxintg_staging_dept_rp
        WHERE
                request_id = g_request_id
            AND status = 'S';

    BEGIN
        fnd_file.put_line(fnd_file.output, ' ');
        fnd_file.put_line(fnd_file.output, 'PRINTING REPORT:');
        fnd_file.put_line(fnd_file.output, ' ');
    
--TOTAL RECORD IN STAGING TABLE.   

        SELECT
            COUNT(*)
        INTO ln_tcount
        FROM
            xxintg_staging_dept_rp
        WHERE
            request_id = g_request_id;

--TOTAL ERROR RECORD IN STAGING TABLE. 

        SELECT
            COUNT(*)
        INTO ln_ecount
        FROM
            xxintg_staging_dept_rp
        WHERE
                status = 'E'
            AND request_id = g_request_id;

----TOTAL SUCCESS RECORD IN STAGING TABLE.

        SELECT
            COUNT(*)
        INTO ln_scount
        FROM
            xxintg_staging_dept_rp
        WHERE
                status = 'S'
            AND request_id = g_request_id;
            
----TOTAL VALIDATE RECORD IN STAGING TABLE. 

        SELECT
            COUNT(*)
        INTO ln_vcount
        FROM
            xxintg_staging_dept_rp
        WHERE
                status = 'V'
            AND request_id = g_request_id;

        fnd_file.put_line(fnd_file.output, rpad('*', 20, '*')
                                           || 'SUMMARY REPORT'
                                           || rpad('*',20, '*'));

        fnd_file.put_line(fnd_file.output, '');
        fnd_file.put_line(fnd_file.output, rpad('TOTAL COUNT', 30, ' ')
                                           || ' | '
                                           || rpad(ln_tcount, 30, ' '));

        fnd_file.put_line(fnd_file.output, rpad('ERROR COUNT',30, ' ')
                                           || ' | '
                                           || rpad(ln_ecount, 30, ' '));

        IF upper(p_process_type) = 'VALIDATE ONLY' THEN
            fnd_file.put_line(fnd_file.output, rpad('VALIDATE COUNT', 30, ' ')
                                               || ' | '
                                               || rpad(ln_vcount,30, ' '));
        ELSE
            fnd_file.put_line(fnd_file.output, rpad('SUCCESS COUNT',30, ' ')
                                               || ' | '
                                               || rpad(ln_scount,30, ' '));

            fnd_file.put_line(fnd_file.output, ' ');
        END IF;
---------------------------->PRINTING DETAIL REPORT.

        IF ln_ecount =0 THEN
        fnd_file.put_line(fnd_file.output,'NO ERROR FOUND');
            ELSE
            fnd_file.put_line(fnd_file.output, rpad('*', 20, '*')
                                               || 'ERROR REPORT'
                                               || rpad('*', 20, '*'));

            fnd_file.put_line(fnd_file.output, ' ');
            fnd_file.put_line(fnd_file.output, rpad('DEPARTMENT ID', 30, ' ')
                                               || ' | '
                                               || rpad('DEPARTMENT NAME', 30, ' ')
                                               || ' | '
                                               || rpad('MANAGER_ID', 30, ' ')
                                               || ' | '
                                               || rpad('LOCATION ID', 30, ' ')
                                               || ' | '
                                               || rpad('STATUS', 30, ' ')
                                               || ' | '
                                               ||rpad('ERROR', 300, ' '));

            fnd_file.put_line(fnd_file.output, ' ');
            FOR rec_curr_print_error IN curr_print_error 
            LOOP
                BEGIN
                    fnd_file.put_line(fnd_file.output, rpad(nvl(to_char(rec_curr_print_error.department_id), 'null'), 30, ' ')
                                                       || ' | '
                                                       || rpad(rec_curr_print_error.department_name, 30, ' ')
                                                       || ' | '
                                                       || rpad(rec_curr_print_error.manager_id, 30, ' ')
                                                       || ' | '
                                                       || rpad(rec_curr_print_error.location_id, 30, ' ')
                                                       || ' | '
                                                       || rpad(rec_curr_print_error.status,30, ' ')
                                                       || ' | '
                                        || rpad('ERROR', 300, ' '));

                    fnd_file.put_line(fnd_file.output, ' ');
                EXCEPTION
                    WHEN OTHERS THEN
                        fnd_file.put_line(fnd_file.output, 'ERROR WHILE PRINTING ERROR REPORT.'
                                                           || ' '
                                                           || g_request_id
                                                           || ' '
                                                           || rec_curr_print_error.record_id);
                END;
            END LOOP;

        END IF;

        IF ln_vcount = 0 THEN
            fnd_file.put_line(fnd_file.output,'NOTHING TO VALIDATE');
            ELSE
            fnd_file.put_line(fnd_file.output, rpad('*', 20, '*')
                                               || 'VALIDATION REPORT'
                                               || rpad('*', 20, '*'));

            fnd_file.put_line(fnd_file.output, ' ');
            fnd_file.put_line(fnd_file.output, rpad('DEPARTMENT ID', 30, ' ')
                                               || ' | '
                                               || rpad('DEPARTMENT NAME', 30, ' ')
                                               || ' | '
                                               || rpad('MANAGER_ID', 30, ' ')
                                               || ' | '
                                               || rpad('LOCATION ID', 30, ' ')
                                               || ' | '
                                               || rpad('STATUS', 30, ' '));

            fnd_file.put_line(fnd_file.output, ' ');
            FOR rec_curr_print_validate IN curr_print_validate LOOP
                BEGIN
                    fnd_file.put_line(fnd_file.output, rpad(nvl(to_char(rec_curr_print_validate.department_id), 'null '),30, ' ')
                                                       || ' | '
                                                       || rpad(rec_curr_print_validate.department_name, 30)
                                                       || ' | '
                                                       || rpad(rec_curr_print_validate.manager_id, 30)
                                                       || ' | '
                                                       || rpad(rec_curr_print_validate.location_id, 30)
                                                       || ' | '
                                                       || rpad(rec_curr_print_validate.status, 30));

                    fnd_file.put_line(fnd_file.output, ' ');
                EXCEPTION
                    WHEN OTHERS THEN
                      
          fnd_file.put_line(fnd_file.output, 'ERROR WHILE PRINTING VALIDATE REPORT.'
                                                           || ' '
                                                           || g_request_id
                                                           || ' '
                                              || rec_curr_print_validate.record_id);
                END;
            END LOOP;
        END IF;
        IF ln_scount =0 THEN

        fnd_file.put_line(fnd_file.output,' NOTHING IN SUCCESS');
ELSE
            fnd_file.put_line(fnd_file.output, rpad('*', 20, '*')
                                               || 'SUCCESS REPORT'
                                               || rpad('*', 20, '*'));

            fnd_file.put_line(fnd_file.output, ' ');
            fnd_file.put_line(fnd_file.output, rpad('DEPARTMENT ID', 30, ' ')
                                               || ' | '
                                               || rpad('DEPARTMENT NAME', 30, ' ')
                                               || ' | '
                                               || rpad('MANAGER_ID', 30, ' ')
                                               || ' | '
                                               || rpad('LOCATION ID', 30, ' ')
                                               || ' | '
                                               || rpad('STATUS', 30, ' '));

            fnd_file.put_line(fnd_file.output, ' ');
            FOR rec_curr_print_success IN curr_print_success LOOP
                BEGIN
                    fnd_file.put_line(fnd_file.output, rpad(nvl(to_char(rec_curr_print_success.department_id), ' '), 30, ' ')
                                                       || ' | '
                                                       || rpad(rec_curr_print_success.department_name, 30)
                                                       || ' | '
                                                       || rpad(rec_curr_print_success.manager_id,  30)
                                                       || ' | '
                                                       || rpad(rec_curr_print_success.location_id,  30)
                                                       || ' | '
                                                       || rpad(rec_curr_print_success.status, 30));

                    fnd_file.put_line(fnd_file.output, ' ');
                EXCEPTION
                    WHEN OTHERS THEN
                        fnd_file.put_line(fnd_file.output, 'ERROR WHILE PRINTING SUCCESS REPORT.'
                                                           || ' '
                                                           || g_request_id
                                                           || ' '
                                                           || rec_curr_print_success.record_id);
                END;
            END LOOP;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output, 'ERROR IN PRINT REPORT MAIN EXCEPTION'
                                               || ' '
                                               || sqlcode
                                               || ' | '
                                               || sqlerrm);
    END print_report;
/*****************************
MAIN PROCEDURE FOR CALLING
******************************/

    PROCEDURE main_procedure (
        error_buff     OUT VARCHAR2,
        reet_code      OUT VARCHAR2,
        p_file_name    IN VARCHAR2,
        p_process_type IN VARCHAR2
    ) AS
        ln_batch_count NUMBER;
    BEGIN
       print_parameter(g_request_id, p_process_type);
        IF p_process_type IS NULL THEN
            fnd_file.put_line(fnd_file.output, ' PROCESS TYPE CANNOT BE NULL');
        ELSE
            IF upper(p_process_type) NOT IN ( 'VALIDATE ONLY', 'VALIDATE LOAD' ) THEN
                fnd_file.put_line(fnd_file.output, 'PROCESS TYPE SHOULD BE VALIDATE ONLY  OR VALIDATE LOAD');
            ELSE
                 IF upper(p_process_type) = upper('VALIDATE ONLY') THEN
                    load_data_in_staging(p_file_name);
                    validate_procedure(g_request_id);
                    print_report(g_request_id, p_process_type);
                ELSIF upper(p_process_type) = upper('VALIDATE LOAD') THEN
                    load_data_in_staging(p_file_name);
                    validate_procedure(g_request_id);
                    insert_in_dept(g_request_id);
                    print_report(g_request_id, p_process_type);
                END IF;

            END IF;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output, 'ERROR IN MAIN PROCEDURE'
                                               || '-'
                                               || sqlcode
                                               || sqlerrm);
    END main_procedure;

END xxintg_dept_rp_fe;  
----------------------------------------------------------------------------------

SELECT
    *
FROM
    departments order by 1;
delete from  departments where department_id in(10,12);
SELECT
    *
FROM
    locations;
    
    select * from xxintg_staging_dept_rp;
    truncate table xxintg_staging_dept_rp;
    COMMIT;