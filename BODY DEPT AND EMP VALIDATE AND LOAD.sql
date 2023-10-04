CREATE OR REPLACE PACKAGE BODY emp_dept_valid_and_load_rp 
AS
/******************************
 Global variables
******************************/
    g_user_id      fnd_user.user_id%TYPE := fnd_profile.value('USER_ID');  -- Geeting user Id
    g_resp_id      fnd_responsibility_tl.responsibility_id%TYPE := fnd_profile.value('RESP_ID'); --Getting REsponsibiity ID
    g_resp_appl_id fnd_responsibility_tl.application_id%TYPE := fnd_profile.value('RESP_APPL_ID'); --Getting application ID
    g_request_id   fnd_concurrent_requests.request_id%TYPE := fnd_profile.value('CONC_REQUEST_ID');
    g_interval     NUMBER;
    g_max_weight   NUMBER;
    g_phase        VARCHAR2(100);
    g_status       VARCHAR2(100);
    g_conc_status  BOOLEAN;
    gc_dev_phase   VARCHAR2(100);
    gc_dev_status  VARCHAR2(100);
    gc_message     VARCHAR2(1000);

/********************************
Procedure for printing parameters
********************************/
    PROCEDURE print_parameters (
        p_dept_file_name IN VARCHAR2,
        p_emp_file_name  IN VARCHAR2,
        p_process_type   IN VARCHAR2
    ) AS
    BEGIN
        fnd_file.put_line(fnd_file.output, rpad('*',20, '*')
                                           || 'Printing Parameters'
                                           || rpad('*', 20, '*'));

        fnd_file.put_line(fnd_file.output, rpad('Department File_Name', 20, ' ')
                                           || ' | '
                                           || rpad(p_dept_file_name, 20, ' '));

        fnd_file.put_line(fnd_file.output, rpad('Employee File_Name', 20, ' ')
                                           || ' | '
                                           || rpad(p_emp_file_name, 20, ' '));

        fnd_file.put_line(fnd_file.output, rpad('Process Type', 20, ' ')
                                           || ' | '
                                           || rpad(p_process_type, 20, ' '));

        fnd_file.put_line(fnd_file.output, ' ');
    END print_parameters;
   
   
/**********************
Employee load Procedure
**********************/
    PROCEDURE emp_load (
        p_emp_file_name IN VARCHAR2,
        p_process_type  IN VARCHAR2
    ) AS
        l_request_id NUMBER;
    BEGIN
     fnd_global.apps_initialize(
    user_id => g_user_id,
    resp_id => g_resp_id,
    resp_appl_id => g_resp_appl_id);
   
        l_request_id := fnd_request.submit_request(application => 'PO',
                                                   program => 'XXINTG_EMPLOYEE',
                                                   description => 'REQUEST CONCURRENT PROGRAM  TO EXECUTE FROM API-BACKEND'
                                                   , start_time => sysdate,
                                                   sub_request => FALSE,

        argument1 => 'VALIDATE LOAD' 
        , argument2 => 'emp_data_rp'
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


        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Unexpected error '
                                 || sqlcode
                                 || ' - '
                                 || sqlerrm);
    END emp_load;

   
/*************************
Department Load Procedure
*************************/
    PROCEDURE dept_load (
        p_dept_file_name IN VARCHAR2,
        p_emp_file_name in varchar2,
        p_process_type   IN VARCHAR2
    ) AS
        l_request_id NUMBER;
    BEGIN    
     fnd_global.apps_initialize(
    user_id => g_user_id,
    resp_id => g_resp_id,
    resp_appl_id => g_resp_appl_id);
   
        l_request_id := fnd_request.submit_request(application => 'PO',
                                                   program => 'XXINTG_DEPARTMENT_RP',
                                                   description => 'REQUEST CONCURRENT PROGRAM  TO EXECUTE FROM API-BACKEND'
                                                   ,start_time => sysdate,
                                                   sub_request => FALSE,
  argument1 => 'DEPT_RP_CSV' 
        , argument2 => 'VALIDATE LOAD'
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

                EXIT WHEN upper(g_phase) = 'COMPLETED' OR upper(g_status) IN 
                ( 'CANCELLED', 'ERROR', 'TERMINATED' );

            END LOOP;

         if (upper(g_phase)= 'COMPLETED' and upper(g_status)='NORMAL') then
         emp_load(p_emp_file_name,p_process_type);
         end if;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Unexpected error '
                                 || sqlcode
                                 || ' - '
                                 || sqlerrm);
    END dept_load;


/**************
Main Procedure
**************/

    PROCEDURE main_procedure (
        p_errbuff        OUT VARCHAR2,
        p_retcode        OUT VARCHAR2,
        p_dept_file_name IN VARCHAR2,
        p_emp_file_name  IN VARCHAR2,
        p_process_type IN VARCHAR2
    ) AS
    BEGIN
    
    print_parameters (p_dept_file_name,p_emp_file_name ,  p_process_type  ); 
    dept_load(p_dept_file_name,p_emp_file_name,p_process_type);
    EXCEPTION WHEN OTHERS THEN
    FND_FILE.PUT_LINE(FND_FILE.LOG,'SQCODE'||'-'||SQLERRM);
    END main_procedure;

END emp_dept_valid_and_load_rp;

-------------------------------------------------------------------------------------------------

TRUNCATE TABLE XXINTG_STAGING_RP;
TRUNCATE TABLE XXINTG_STAGING_DEPT_RP;
