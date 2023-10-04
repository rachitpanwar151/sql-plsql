create or replace package  body xxintg_requisition_pkg_rp 
as
---->global variablw decleration
    gn_max_wait        VARCHAR2(200);
    gn_interval        VARCHAR2(300);
    gc_error_flag      BOOLEAN;
    gn_cp_request_id   VARCHAR2(200);
    gc_status          VARCHAR2(200);
    gc_data_validation VARCHAR2(300);
    gc_error_msg       VARCHAR2(2000);
    gc_conc_status     NUMBER;
    gc_phase           VARCHAR2(200);
    gn_chk             NUMBER; -- For validating count of a particular value
    gc_chk             VARCHAR2(2); --For validating check
    g_user_id          fnd_user.user_id%TYPE := fnd_profile.value('USER_ID');  -- Geeting user Id
    g_resp_id          fnd_responsibility_tl.responsibility_id%TYPE := fnd_profile.value('RESP_ID'); --Getting REsponsibiity ID
    g_resp_appl_id     fnd_responsibility_tl.application_id%TYPE := fnd_profile.value('RESP_APPL_ID'); --Getting application ID
    p_batch_id         fnd_concurrent_requests.request_id%TYPE := fnd_profile.value('CONC_REQUEST_ID');
    g_interval         NUMBER;
    g_max_weight       NUMBER;
    g_phase            VARCHAR2(100);
    g_status           VARCHAR2(100);
    g_conc_status      BOOLEAN;
    gc_dev_phase       VARCHAR2(100);
    gc_dev_status      VARCHAR2(100);
    gc_message         VARCHAR2(1000);


/*********************************************
  procedure of insertion in staging table
************************************************/

    PROCEDURE load_in_staging_table (
        p_file_name VARCHAR2
    ) AS
        l_request_id NUMBER;
    BEGIN
        mo_global.init('PO');
        fnd_global.apps_initialize(user_id => g_user_id, 
        resp_id => g_resp_id, resp_appl_id => g_resp_appl_id);

        l_request_id := fnd_request.submit_request(application => 'XXINTG', 
        program => 'XXINTG_RACHIT', 
        description => 'REQUEST CONCURRENT PROGRAM  TO EXECUTE FROM API-BACKEND' , 
        START_TIME => SYSDATE , 
        SUB_REQUEST => FALSE ,
        ARGUMENT1 => '/u01/install/APPS/fs1/EBSapps/appl/xxintg/12.0.0/bin/control_file_rp.ctl'
 , ARGUMENT2 => '/tmp/RPANWAR/requisition/' ,
 ARGUMENT3 => P_FILE_NAME || '.csv' , 
 ARGUMENT4 => '/tmp/RPANWAR/requisition/'||p_file_name||'.log' ,
 ARGUMENT5 => '/tmp/RPANWAR/requisition/'||p_file_name||'.bad'
 , ARGUMENT6 => '/tmp/RPANWAR/requisition/'||p_file_name||'.dis' ,
 ARGUMENT7 => '/tmp/RPANWAR/requisition' ) ;

        IF ( l_request_id = 0 ) THEN
            fnd_file.put_line(fnd_file.log, 'Request not Submitted');
        ELSE
            fnd_file.put_line(fnd_file.log, 'Request submitted with request id - ' || l_request_id);
            LOOP
                g_conc_status := fnd_concurrent.wait_for_request(request_id => l_request_id, 
                INTERVAL => 1, max_wait => 0, phase => g_phase
                , status => g_status,
                dev_phase => gc_dev_phase,
                dev_status => gc_dev_status, message => gc_message
                );

                EXIT WHEN upper(g_phase) = 'COMPLETED' OR 
                upper(g_status) IN ( 'CANCELLED', 'ERROR', 'TERMINATED' );

            END LOOP;

            IF (
                upper(g_phase) = 'COMPLETED'
                AND upper(g_status) = 'NORMAL'
            ) THEN
                BEGIN
                    UPDATE stag_req
                    SET
                        request_id = p_batch_id,
                        created_by = g_user_id,
                        created_date = sysdate,
                        last_upadated_by = g_user_id,
                        last_updated_date = sysdate,
                        record_id=RECORD_ID_SEQ_RP.nextval,
                        status='N'
                        where status='null';	

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
    END load_in_staging_table;

    
/**************************************************
 PROCEDURE FOR PRINTING PARAMETER
***************************************************/
PROCEDURE PRINT_PARAMETER( P_PROCESS_TYPE VARCHAR2, P_FILE_NAME VARCHAR2)
AS
BEGIN
FND_FILE.PUT_LINE(FND_FILE.OUTPUT,RPAD('P_PROCESS_TYPE',30)||'-->'|| RPAD(P_PROCESS_TYPE,30));
FND_FILE.PUT_LINE(FND_FILE.OUTPUT,RPAD('DATA_FILE_NAME',30)||'-->'||RPAD(P_FILE_NAME,30));

    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output, 'ERROR OCCURED in printing parameter');

END PRINT_PARAMETER;
/**************************************************
procedure for main procedure
****************************************************/

procedure main_proce(
errbuff out varchar2 ,
retcode out varchar2, 
P_PROCESS_TYPE VARCHAR2,
P_FILE_NAME VARCHAR2)
as
LC_STATUS VARCHAR2(10);
begin 

if lower(p_process_type)='load only' then 
PRINT_PARAMETER( P_PROCESS_TYPE , P_FILE_NAME);
load_in_staging_table (
        p_file_name
    ) ;
--validate_data (
--        p_batch_id,LC_status) ;
--
--    load_in_interface (
--        p_batch_id 
--    );
--    LOAD_IN_BASE_TABLE(p_REQUEST_id);
end if;    
end main_proce;
end xxintg_requisition_pkg_rp;


select * from stag_req;
truncate table stag_req;

select * from ap_supplier_sites_all;
select * from 
PO_REQUISITIONS_INTERFACE_ALL  order by CREATION_DATE desc; =to_date('10-sep-23');order by creation_date;

select * from PO_INTERFACE_ERRORS where created_by =1014843;

select * from  ap_supplier_sites_all where vendor_id=600;

select * from
ap_supplier_sites_all;