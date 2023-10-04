CREATE OR REPLACE PACKAGE body xxintg_requisition_pkg_rachit
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



/**********************************
LOAD INTO BASE TABLE REQUISITION
**********************************/
procedure LOAD_IN_BASE_TABLE(p_batch_id in number) 
as
CURSOR CUR_UPDATE_STG(p_batch_id in number) 
IS    
        SELECT RHA.REQUISITION_HEADER_ID,
        RHA.SEGMENT1 ,
        RLA.REQUISITION_LINE_ID,
        line_num,
        rha.ORG_ID,
        rha.REQUEST_ID,
        rha.PREPARER_ID
        FROM PO_REQUISITION_HEADERS_ALL RHA,
        PO_REQUISITION_LINES_aLL RLA
        WHERE 1=1
        AND RHA.REQUISITION_HEADER_ID=RLA.REQUISITION_HEADER_ID
        AND RHA.AUTHORIZATION_STATUS='APPROVED'
        AND RHA.REQUEST_ID=P_batch_id;


        L_SR_NO        NUMBER;
        L_REQUEST_ID   NUMBER;
        LC_CONC_STATUS BOOLEAN;
        LC_PHASE       VARCHAR2(200);
        LN_INTERVAL    VARCHAR2(2000) := 5;
        LC_STATUS      VARCHAR2(2000);
        LN_MAX_WAIT    VARCHAR2(2000) := 60;
        LC_DEV_PHASE   VARCHAR2(2000);
        LC_DEV_STATUS  VARCHAR2(2000);
        LC_MESSAGE     VARCHAR2(2000);
        LN_REQ_HEADER_ID PO_REQUISITION_HEADERS_ALL.REQUISITION_HEADER_ID%TYPE;
        LC_REQ_NUMBER    PO_REQUISITION_HEADERS_ALL.SEGMENT1%TYPE;
        LN_REQ_LINE_ID   PO_REQUISITION_LINES_ALL.REQUISITION_LINE_ID%TYPE;

begin
fnd_global.apps_initialize(
                            g_user_id,
                            g_resp_id,
                            g_resp_appl_id);

mo_global.init('PO');
--MO_GLOBAL.SET_POLICY_CONTEXT('S',204);
fnd_request.set_org_id(204);

 -- SUBMIT IMPORT STANDARD PURCHASE ORDERS
l_request_id := apps.fnd_request.submit_request(
                                                application => 'PO',
                                                program => 'REQIMPORT',
												description=>'Requistion Desc',
												sub_request=>false,
                                                argument1 => 'INV',
                                                argument2 => p_batch_id
                                                ,argument3 => 'ALL',
                                                argument4 => NULL,
                                                argument5 => 'N',
                                                argument6 => 'Y');

COMMIT;

IF l_request_id = 0 THEN
    fnd_file.put_line(fnd_file.log, 'REQUEST ID NOT GENERATED');
ELSIF l_request_id > 0 THEN
    fnd_file.put_line(fnd_file.log, 'REQUEST GENERATED');
    LOOP
        lc_conc_status := fnd_concurrent.wait_for_request(
                                                            request_id => l_request_id,
                                                            INTERVAL => ln_interval,
                                                            max_wait => ln_max_wait
                                                            ,phase => lc_phase,
                                                            status => lc_status,
                                                            dev_phase => lc_dev_phase,
                                                            dev_status => lc_dev_status,
                                                            message => lc_message
                                                         );

        EXIT WHEN upper(lc_phase) = 'COMPLETED' OR
        upper(lc_status) IN ( 'CANCELLED', 'ERROR', 'TERMINATED' );

    END LOOP;

    fnd_file.put_line(fnd_file.log, rpad('LOADER REQUEST PHASE/STATUS.', 45, ' ')
                                    || ': '
                                    || lc_phase
                                    || '-'
                                    || lc_status);

    IF (
        upper(lc_phase) = 'COMPLETED'
        AND upper(lc_status) = 'NORMAL'
    ) THEN



/************************************************
* Update STAGGING TABLES
************************************************/

        BEGIN
            FOR rec_update IN cur_update_stg(l_request_id) LOOP
                UPDATE stag_Req
                SET
                    REQ_HEADER_ID = rec_update.requisition_header_id,
                    REQ_LINE_ID = rec_update.requisition_line_id,
                    REQ_NUMBER = rec_update.segment1
                WHERE
                        1 = 1
                        and PREPARER_ID=rec_update.PREPARER_ID
--                    and record_id=REC_STG.RECORD_ID
                    AND REQUEST_ID = rec_update.REQUEST_ID ;

                COMMIT;
            END LOOP;        
--        end loop;                    

        EXCEPTION
            WHEN OTHERS THEN
                fnd_file.put_line(fnd_file.log, 'Error in updating and fetching query'
                                                || '-'
                                                || sqlerrm);
        END;
    ELSE
        dbms_output.put_line('Error  '
                             || sqlerrm
                             || ' - '
                             || l_request_id);
        fnd_file.put_line(fnd_file.log, 'Error  '
                                        || sqlerrm
                                        || ' - '
                                        || l_request_id);
    END IF;
END IF;
EXCEPTION WHEN OTHERS THEN
FND_FILE.PUT_LINE(FND_FILE.LOG,'ERROR IN INSERTING DATA');
END LOAD_IN_BASE_TABLE;




/**********************************************
proceDure of inserting into INTERFACE table
************************************************/
       PROCEDURE load_in_interface (
        p_batch_id IN NUMBER
    ) AS
        lc_error_msg1    VARCHAR2(10000);
        l_sr_no          NUMBER;
        l_request_id     NUMBER;
        lc_conc_status   BOOLEAN;
        lc_phase         VARCHAR2(200);
        ln_interval      VARCHAR2(2000) := 5;
        lc_status        VARCHAR2(2000);
        ln_max_wait      VARCHAR2(2000) := 60;
        lc_dev_phase     VARCHAR2(2000);
        lc_dev_status    VARCHAR2(2000);
        lc_message       VARCHAR2(2000);
        ln_req_header_id po_requisition_headers_all.requisition_header_id%TYPE;
        lc_req_number    po_requisition_headers_all.segment1%TYPE;
        ln_req_line_id   po_requisition_lines_all.requisition_line_id%TYPE;
 
 
        CURSOR cur_req IS
        SELECT
            *
        FROM
            stag_req
        WHERE
                status = 'V'
            AND request_id = p_batch_id;

    BEGIN
        FOR rec_req IN cur_req LOOP
            BEGIN
                INSERT INTO po_requisitions_interface_all (
                        interface_source_code,
                        source_type_code,
                        requisition_type,
                        destination_type_code,
                        item_id,
                        item_description,
                        quantity,
                        authorization_status,
                        preparer_id,
                        autosource_flag,
                        req_number_segment1 --*** see the note
                        ,
                        header_attribute13 ---xtra infomation
                        ,
                        line_attribute15 ---xtra infomation
                        ,
                        uom_code,
                        destination_organization_id,
                        destination_subinventory,
                        deliver_to_location_id,
                        deliver_to_requestor_id,
                        need_by_date,
                        gl_date,
                        charge_account_id,
                        accrual_account_id,
                        variance_account_id,
                        org_id,
                        suggested_vendor_id,
                        suggested_vendor_site_id,
                        unit_price,
                        creation_date,
                        created_by,
                        last_update_date,
                        last_updated_by,
                        batch_id
                    ) VALUES (
                        'INV',
                        'VENDOR',
                        'PURCHASE',
                        'INVENTORY',
                        rec_req.item_id,
                        rec_req.record_id
                        || ' Description'||'RACHIT PANWAR'||P_batch_id,
                        rec_req.quantity,
                        'APPROVED' --------'INCOMPLETE' or 'APPROVED'
                        ,
                        rec_req.preparer_id,
                        'P',
                        NULL,
                        'ZZ' ---xtra infomation
                        ,
                        204 ---xtra infomation
                        ,
                        substr(rec_req.UNIT_OF_MEASURE,
                               1,
                               2),
                        204,
                        NULL,
                        204,
                        rec_req.preparer_id --rec_get_lines_info.requestor
                        ,
                        sysdate + 5,
                        sysdate + 5,
                        NULL,
                        NULL,
                        NULL,
                        204,
                        rec_req.supplier_id,
                        rec_req.supplier_site_id,
                        145,
                        sysdate,
                        g_user_id,
                        sysdate,
                        g_user_id,
                        p_batch_id
                    );
commit;
                UPDATE stag_req
                SET
                    status = 'S'
                WHERE
                        request_id = p_batch_id
                    AND record_id = rec_req.record_id;

            EXCEPTION
                WHEN OTHERS THEN
                    lc_error_msg1 := 'Error occurred while inserting data into po header interface table '
                                     || sqlcode
                                     || '-'
                                     || sqlerrm;
                    UPDATE stag_req
                    SET
                        error_msg = lc_error_msg1,
                        status = 'E'
                    WHERE
                            request_id = p_batch_id
                        AND record_id = rec_req.record_id;

            END;

            COMMIT;
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.log, ' error occurred  while inserting in 
            requisition interface table '
                                            || ' '
                                            || sqlcode
                                            || ' | '
                                            || sqlerrm);
    END load_in_interface;

/***********************************************
procedure of VALIDATING VALUES
************************************************/
     PROCEDURE validate_data (
        p_batch_id IN NUMBER,p_status OUT varchar2
    ) AS
--------------------> CURSOR
        CURSOR cur_req_stag IS
        SELECT
            *
        FROM
            stag_req
        WHERE
                status = 'N'
            AND request_id = p_batch_id;

    BEGIN
        FOR rec_req_stag IN cur_req_stag
        LOOP
            BEGIN
                rec_req_stag.status := 'V';
                
/*********************************
operating id validation
**********************************/
if rec_req_stag.OPERATION_NAME is null
then
                rec_req_stag.status := 'E';
                    rec_req_stag.error_msg := 'Org_name CANNOT BE NULL';
    else
    begin
    
    
    select ORGANIZATION_ID 
    into rec_req_stag.OPERATING_ID
    from hr_operating_units where 
    upper(name) = upper(rec_req_stag.OPERATION_NAME);
exception when others
then
rec_req_stag.status :='E';
rec_req_stag.error_msg := rec_req_stag.error_msg
                                                     || '-'
                                                     || 'Org_name DOESNT EXIST';
                    END;
                END IF;


/*************************************
 preparer id validation
 *************************************/
 if rec_req_stag.preparer_name is null then
 rec_req_stag.status:='E';
 rec_req_stag.error_msg:='preparer name cannot be null';
 else
 begin
 fnd_file.put_line(fnd_file.log,'preparer name is '||rec_req_stag.PREPARER_NAME);
-- SELECT * FROM PO_REQUISITION_HEADERS_ALL;
 select ppf.person_ID 
 into rec_req_stag.PREPARER_ID
 FROM PER_PEOPLE_F PPF,po_agents pa
 WHERE  upper(PPF.FULL_NAME)=upper(rec_req_stag.PREPARER_NAME)
 and ppf.person_id = pa.agent_id 
and (trunc(sysdate) between trunc(ppf.EFFECTIVE_START_DATE)and trunc(ppf.EFFECTIVE_END_DATE))
and (ppf.CURRENT_EMPLOYEE_FLAG='Y' or ppf.current_npw_flag='Y');
-- selece * from 
exception when others
then
rec_req_stag.status :='E';
rec_req_stag.error_msg := rec_req_stag.error_msg
                     || '-'
                     || 'PREPARER NAME  DOESNT EXIST';
        
 END;
 END IF;
                
/********************************
VALIDATING ORGANISATION NAME
*********************************/
                IF rec_req_stag.ORAGANISATION_NAME IS NULL THEN
                    rec_req_stag.status := 'E';
                    rec_req_stag.error_msg := 'Org_name CANNOT BE NULL';
                ELSE
                    BEGIN
                        SELECT
                            organization_id
                        INTO rec_req_stag.ORGANISATION_ID
                        FROM
                            hr_operating_units
                        WHERE
                            upper(name) = upper(rec_req_stag.ORAGANISATION_NAME);

                    EXCEPTION
                        WHEN OTHERS THEN
                            rec_req_stag.status := 'E';
                            rec_req_stag.error_msg := rec_req_stag.error_msg
                                                     || '-'
                                                     || 'Org_name DOESNT EXIST';
                    END;
                END IF;

/*************************************************
 SUPPLIER NAME VALIDATION
**************************************************/
                IF rec_req_stag.SUPPLIER_name IS NULL THEN
                    rec_req_stag.status := 'E';
                    rec_req_stag.error_msg := rec_req_stag.error_msg
                                             || '-'
                                             || ' VENDOR NAME CANNOT BE NULL';
                ELSE
                    BEGIN
                        SELECT
                            vendor_id
                        INTO rec_req_stag.SUPPLIER_id
                        FROM
                            ap_suppliers
                        WHERE
                            vendor_name = rec_req_stag.SUPPLIER_name;

                    EXCEPTION
                        WHEN OTHERS THEN
                            rec_req_stag.status := 'E';
                            rec_req_stag.error_msg := rec_req_stag.error_msg
                                                     || '-'
                                                     || 'VENDOR / SUPPLIER NAME NOT VALID';
                    END;
                END IF;
   
   /***********************************************
   SUPPLIER SITE CODE VALIDATION
   ************************************************/
                BEGIN
                    SELECT
                        vendor_site_id
                    INTO rec_req_stag.SUPPLIER_SITE_ID
                    FROM
                        ap_supplier_sites_all
                    WHERE
                            org_id = rec_req_stag.ORGANISATION_ID
                        AND upper(vendor_site_code) = upper(rec_req_stag.SUPPLIER_SITE_NAME)
                        AND vendor_id = rec_req_stag.SUPPLIER_ID;

                EXCEPTION
                    WHEN OTHERS THEN
                        rec_req_stag.status := 'E';
                        rec_req_stag.error_msg := rec_req_stag.error_msg
                                                 || '-'
                                                 || 'VENDOR SITE id IS INVALID'||'-'||sqlcode||sqlerrm;
                END;
   
   
/*********************************************
   ITEM_Number NAME VALIDATION
**********************************************/

                IF rec_req_stag.item_name IS NULL THEN
                    rec_req_stag.status := 'E';
                    rec_req_stag.error_msg := rec_req_stag.error_msg
                                             || '-'
                                             || ' ITEM NAME CANNOT BE NULL';
                ELSE
                    BEGIN
                        SELECT
                            inventory_item_id
                        INTO rec_req_stag.item_id
                        FROM
                            mtl_system_items_b
                        WHERE
                                upper(segment1) = upper(rec_req_stag.item_name)
                            AND organization_id = rec_req_stag.ORGANISATION_ID;

                    EXCEPTION
                        WHEN OTHERS THEN
                            rec_req_stag.status := 'E';
                            rec_req_stag.error_msg := rec_req_stag.error_msg
                                                     || '-'
                                                     || ' ITEM NAME IS INVALID';
                    END;
                END IF;
                
   /************************************************
   UNIT OF MEASUREMENT VALIDATION
   *************************************************/
                IF rec_req_stag.UNIT_OF_MEASURE IS NULL THEN
                    rec_req_stag.status := 'E';
                    rec_req_stag.error_msg := rec_req_stag.error_msg
                                             || '-'
                                             || ' UNIT OF MEASURE CANNOT BE NULL';

                END IF;

                UPDATE stag_req
                SET 
                    status = rec_req_stag.status,
                    error_msg = rec_req_stag.error_msg,
                    ORGANISATION_ID = rec_req_stag.ORGANISATION_ID,
                    SUPPLIER_ID = rec_req_stag.SUPPLIER_ID,
                    SUPPLIER_SITE_ID = rec_req_stag.SUPPLIER_SITE_ID,
                    item_id = rec_req_stag.item_id,
                    OPERATING_ID=rec_req_stag.OPERATING_ID,
                    PREPARER_ID=rec_req_stag.PREPARER_ID
                    WHERE
                        request_id = rec_req_stag.request_id
                    AND record_id = rec_req_stag.record_id;
fnd_file.put_line(fnd_file.log,'yha update');
                COMMIT;
            EXCEPTION
                WHEN OTHERS THEN
                    fnd_file.put_line(fnd_file.output, 'backtrace : ' || dbms_utility.format_error_backtrace);
                    fnd_file.put_line(fnd_file.output, 'UNEXPEXTED ERROR IN VALIDATION '
                                                       || sqlcode
                                                       || '|'
                                                       || sqlerrm);

            END;
		p_status:=rec_req_stag.status;	
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output, 'ERROR IN VALIDATING DATA '
                                               || sqlcode
                                               || '-'
                                               || sqlerrm);

            fnd_file.put_line(fnd_file.output, dbms_utility.format_error_backtrace);
    END validate_data;


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
        COMMIT;
        IF ( l_request_id = 0 ) THEN
            fnd_file.put_line(fnd_file.log, 'Request not Submitted');
        ELSE
            fnd_file.put_line(fnd_file.log, 'Request submitted with request id - ' || l_request_id);
            LOOP
                g_conc_status := fnd_concurrent.wait_for_request(request_id => l_request_id, 
                INTERVAL => 1, max_wait => 0, phase => g_phase
                , status => g_status,
                dev_phase => gc_dev_phase, dev_status => gc_dev_status, message => gc_message
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
                        status='N';
                        --where status='null';	

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

PROCEDURE main_procedure (
    errbuff        OUT VARCHAR2,
    retcode        OUT VARCHAR2,
    p_process_type IN VARCHAR2,
    p_file_name    IN VARCHAR2
) AS
    lc_status VARCHAR2(10);
BEGIN
    IF lower(p_process_type) = 'load only' THEN
        print_parameter(p_process_type, p_file_name);
        load_in_staging_table(p_file_name);
validate_data (
        p_batch_id,LC_status) ;

    load_in_interface (
        p_batch_id 
    );
    LOAD_IN_BASE_TABLE(p_batch_id);
    END IF;
END main_procedure;
end  xxintg_requisition_pkg_rachit;


-----------------------------------------------------------------------------

