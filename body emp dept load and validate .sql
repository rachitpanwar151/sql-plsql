CREATE OR REPLACE PACKAGE BODY emp_dept_valid_and_load_rp1
AS


/**************************************************************************************************
VERSION            WHEN            WHO                       WHY
 
1.0           3-AUGUST-2023    RACHIT PANWAR           TO MAKE A PACKAGE BODY TO UPDATE AND
                                                      AND INSERT DETAILS IN STAGING AND BASE TABLE
                                                      AND MAKING DEPT FIRSTS AND THAN EMP
**************************************************************************************************/


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
        
        /*****************************************
        procedure for emp load
        ******************************************/
    PROCEDURE emp_load (
        p_emp_file_name VARCHAR2,
        p_process_type  VARCHAR2
    ) AS
    l_request_id number;
    BEGIN
        mo_global.init('PO');
        fnd_global.apps_initialize(user_id => g_user_id,
        resp_id => g_resp_id, resp_appl_id => g_resp_appl_id);

        l_request_id := fnd_request.submit_request(application => 'XXINTG',
        program => 'XXINTG_HOST1_RP',
        description => 'REQUEST CONCURRENT PROGRAM  TO EXECUTE FROM API-BACKEND'
        , start_time => sysdate,
        sub_request => FALSE
        ,   argument1 => '/u01/install/APPS/fs1/EBSapps/appl/xxintg/12.0.0/bin/XXINTG_EMPLOYEETABLE_DATA_UPLOAD_CONTROL_FILE_RP.ctl',
           argument2 => 'validate and load');

        COMMIT;
        IF ( l_request_id = 0 ) THEN
            fnd_file.put_line(fnd_file.log, 'Request not Submitted');
        ELSE
            fnd_file.put_line(fnd_file.log, 'Request submitted with request id - ' || l_request_id);
            LOOP
                g_conc_status := fnd_concurrent.wait_for_request(request_id => l_request_id,
                INTERVAL => 1, max_wait => 0, phase => g_phase
                , status => g_status,
                dev_phase => gc_dev_phase,
                dev_status => gc_dev_status,
                message => gc_message      );

                EXIT WHEN upper(g_phase) = 'COMPLETED' 
                OR upper(g_status) IN ( 'CANCELLED', 'ERROR', 'TERMINATED' );

            END LOOP;
            END IF;
    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output, 'Unexpected error '
                                               || sqlcode
                                               || ' - '
                                               || sqlerrm);

            COMMIT;
    END emp_load;


        /*****************************************
        procedure for dept load
        ******************************************/
procedure dept_load(p_emp_file_name varchar2,
p_dept_file_name varchar2
,p_process_type varchar2)
as
l_request_id number;
begin
mo_global.init('PO');
        fnd_global.apps_initialize(user_id => g_user_id, 
        resp_id => g_resp_id, resp_appl_id => g_resp_appl_id);

        l_request_id := fnd_request.submit_request(application => 'XXINTG',
        program => 'XXINTG_HOST1_RP',
        description => 'REQUEST CONCURRENT PROGRAM TO EXECUTE FROM API-BACKEND '
        , start_time => sysdate, sub_request => FALSE,
        argument1 => '/u01/install/APPS/fs1/EBSapps/appl/xxintg/12.0.0/bin/XXINTG_DEPT_CONTROL_FILE_RP.CTL',
        argument2 => 'validate and load');

        COMMIT;
        IF ( l_request_id = 0 ) THEN
            fnd_file.put_line(fnd_file.log, 'Request not Submitted');
        ELSE
            fnd_file.put_line(fnd_file.log, 'Request submitted with request id - ' || l_request_id);
            LOOP
                g_conc_status := fnd_concurrent.wait_for_request(request_id => l_request_id, INTERVAL => 1, max_wait => 0, phase => g_phase
                , status => g_status,dev_phase => gc_dev_phase, dev_status => gc_dev_status, message => gc_message
                                                           );

                EXIT WHEN upper(g_phase) = 'COMPLETED'
                OR upper(g_status) IN ( 'CANCELLED', 'ERROR', 'TERMINATED' );

            END LOOP;

            IF (
                upper(g_phase) = 'COMPLETED'
                AND upper(g_status) = 'NORMAL'
            ) THEN
               emp_load(p_emp_file_name,p_process_type);
               end if;
               end if;
               EXCEPTION
                    WHEN OTHERS THEN
                        fnd_file.put_line(fnd_file.output, sqlcode || sqlerrm);
           
end dept_load;

        /*****************************************
        procedure for printing parmeter
        ******************************************/
 PROCEDURE print_parameter(
        p_dept_file_name IN VARCHAR2,
        p_emp_file_name  IN VARCHAR2,
        p_process_type   IN VARCHAR2
    ) AS
    BEGIN

        fnd_file.put_line(fnd_file.output, rpad('Department File Name', 30, ' ')
                                           || ' | '
                                           || rpad(p_dept_file_name, 30, ' '));

        fnd_file.put_line(fnd_file.output, rpad('Employee File Name', 30, ' ')
                                           || ' | '
                                           || rpad(p_emp_file_name, 30, ' '));

        fnd_file.put_line(fnd_file.output, rpad('Process Type', 30, ' ')
                                           || ' | '
                                           || rpad(p_process_type, 30, ' '));

        
    END print_parameter;
        
    PROCEDURE main_procedure (
        p_errbuff        OUT VARCHAR2,
        p_retcode        OUT VARCHAR2,
        p_dept_file_name IN VARCHAR2,
        p_emp_file_name  IN VARCHAR2,
        p_process_type   IN VARCHAR2
    ) AS
    BEGIN
    print_parameter(p_dept_file_name ,p_emp_file_name  ,p_process_type);
        dept_load(p_dept_file_name,p_emp_file_name,p_process_type);
    END main_procedure;

END emp_dept_valid_and_load_rp1;