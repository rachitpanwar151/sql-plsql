CREATE OR REPLACE PACKAGE BODY xxintg_po_insert_validate_rp AS



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





/*******************************************
procedure for insertig in base tables
********************************************/
PROCEDURE LOAD_IN_BASE_TABLE(p_REQUEST_id IN number)
AS
      l_default_buyer_id NUMBER;
        l_approval_status  VARCHAR2(150) := 'INITIATE APPROVAL';
        l_org_id           NUMBER := 204;
        l_request_id       NUMBER;
        l_result           BOOLEAN;
        l_phase            VARCHAR2(100);
        l_status           VARCHAR2(100);
        l_dev_phase        VARCHAR2(100);
        l_dev_status       VARCHAR2(100);
        l_message          VARCHAR2(100);
        l_interface_error  VARCHAR2(4000);
        l_error_msg        VARCHAR2(4000);
    BEGIN
        fnd_global.apps_initialize(g_user_id, g_resp_id, g_resp_appl_id);
        mo_global.init('PO');
        fnd_request.set_org_id(204);
        l_request_id := fnd_request.submit_request(application => 'PO',
        program => 'POXPOPDOI',
        description => NULL, 
        start_time => sysdate
        , sub_request => false,
                                                  argument1 => NULL, argument2 => 'STANDARD' -- DOCUMENT TYPE
                                                  , argument3 => NULL -- DOCUMENT SUBTYPE
                                                  , argument4 => 'N' -- CREATE OR UPDATE ITEMS
                                                  , argument5 => NULL -- CREATE SOURCING RULES
                                                  ,
                                                  argument6 => l_approval_status -- APPROVAL STATUS
                                                  , argument7 => NULL, 
                                                  argument8 => p_request_id, 
                                                  argument9 => NULL -- OPERATING UNIT
                                                  , argument10 => NULL -- GLOBAL AGREEMENT
                                                  ); -- GATHER STATS

        COMMIT;
        IF l_request_id = 0 THEN
         RAISE fnd_api.g_exc_error;
             dbms_output.put_line('ERROR IN REQ SUB');
               update xxintg_po_staging_table_rp 
               set status='E',
               error_msg='PO CREATION FAILED'
               where request_id=p_request_id;
       ELSE
loop

            l_result := fnd_concurrent.wait_for_request(l_request_id, 1, 0, l_phase, l_status,
                                                       l_dev_phase, l_dev_status, l_message);

exit when upper(l_phase)='COMPLETED' OR UPPER(L_STATUS)IN('ERROR','TERMINATED','CANCELLED');
end loop;

IF UPPER(L_PHASE)='COMPLETED' AND UPPER(L_STATUS)='NORMAL'
THEN
                update_staging_data(P_request_id);

        update xxintg_po_staging_table_rp 
        set status='SC' where request_id= p_batch_id
        AND RECORD_ID=P_RECORD_ID;
END IF;
        END IF;
 
 -- CHECK INTERFACE TABLE ERRORS
        BEGIN
            SELECT
                substr(rtrim(xmlagg(xmlelement(e, pie.error_message || ',')).extract('//TEXT()'), ','),
                       1,
                       3950)
            INTO l_interface_error
            FROM
                po_interface_errors     pie,
                po.po_headers_interface phi
            WHERE
                    pie.interface_header_id = phi.interface_header_id
                AND phi.batch_id = p_request_id;

        EXCEPTION
            WHEN OTHERS THEN
                fnd_file.put_line(fnd_file.log, 'Error in check interface tbl : '
                                                || sqlcode
                                                || '-'
                                                || sqlerrm);
        END;

        IF l_interface_error IS NOT NULL THEN
            fnd_message.set_name('FND', 'FND_GENERIC_MESSAGE');
            fnd_message.set_token('SQLERRM', l_interface_error);
            fnd_message.set_token('SEQ', '02');
            l_error_msg := substr(fnd_message.get, 1, 3999);
        ELSE
            fnd_file.put_line(fnd_file.log, 'L_REQUEST_ID = ' || l_request_id);
            fnd_file.put_line(fnd_file.log, 'L_ERROR_MSG = ' || l_error_msg);
        END IF;

    EXCEPTION
        WHEN fnd_api.g_exc_error THEN
            fnd_file.put_line(fnd_file.log, l_error_msg);
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output, 'ERROR IN PO SUBMIT REQUEST PROCESS  - '
                                               || sqlcode
                                               || '-'
                                               || sqlerrm);
END LOAD_IN_BASE_TABLE;



/**********************************************
proceDure of inserting into INTERFACE table
************************************************/
procedure load_in_interface(p_batch_id IN number)
AS
l_e varchar2(1000);
        ln_header_count NUMBER := 1;
        p_line_count    NUMBER := 1;
        ln_header_id    NUMBER;
        ln_line_id      NUMBER;
        ln_po_num       po_headers_all.segment1%TYPE;
        ln_hdr_id       po_headers_all.po_header_id%TYPE;


cursor cur_po_intf is
select * from xxintg_po_staging_table_rp where 
status='V' and request_id=p_batch_id;
begin
for rec_po in cur_po_intf LOOP
begin
 --HEADER INSERT
                    FOR j IN 1..ln_header_count LOOP
                        ln_header_id := po_headers_interface_s.nextval;
                        INSERT INTO po_headers_interface (
                            interface_header_id,
                            batch_id,
                            process_code,
                            action,
                            org_id,
                            document_type_code,
                            comments,
                            currency_code,
                            agent_id,
                            vendor_id,
                            vendor_site_id,
                            ship_to_location_id,
                            bill_to_location_id,
                            attribute1,
                            creation_date
                        ) VALUES (
                            ln_header_id,
                            rec_po.request_id,
                            'PENDING',
                            'ORIGINAL',
                            rec_po.org_id,
                            'STANDARD',
                            'This is a Purchase Order - RPANWAR',
                            rec_po.currency_code,
                            rec_po.agent_id,
                            rec_po.vendor_id,
                            rec_po.vendor_site_id,
                            204,
                            204,
                            'LROBIN POXPOPDOI IMPORT',
                            rec_po.creation_date
                        ); 
--LINE INSERT		
                        FOR i IN 1..p_line_count LOOP
                            ln_line_id := po_lines_interface_s.nextval;
                            INSERT INTO po_lines_interface (
                                interface_line_id,
                                interface_header_id,
                                action,
                                line_num,
                                line_type,
                                item,
                                uom_code,
                                quantity,
                                unit_price,
                                ship_to_location_id,
                                need_by_date,
                                promised_date,
                                creation_date,
                                line_loc_populated_flag
                            ) VALUES (
                                ln_line_id,
                                ln_header_id,
                                'PENDING',
                                i,
                                rec_po.line_type,
                                rec_po.item_name,
                                rec_po.uom_code,
                                rec_po.quantity,
                                rec_po.unit_price,
                                204,
                                sysdate+10,
                                sysdate+8,
                                rec_po.creation_date,
                                'N'
                            );
commit;
                        END LOOP;

                    END LOOP;
 UPDATE xxintg_po_staging_table_rp
                        SET
                            status = 'S'
                            WHERE
                                request_id = rec_po.request_id
                            AND record_id = rec_po.record_id;
                    COMMIT;
                EXCEPTION
                    WHEN OTHERS THEN
                    l_e :=sqlcode||'-'||sqlerrm;
                        UPDATE xxintg_po_staging_table_rp
                        SET
                            status = 'E',
                            error_msg = 'ERROR WHILE INSERT DATA INTO INTERFACE TABLE.'||l_e
                        WHERE
                                request_id = rec_po.request_id
                            AND record_id = rec_po.record_id;

                        COMMIT;
                END;

end LOOP;
EXCEPTION
when others THEN
fnd_file.put_line(fnd_file.output,'ERROR IN INTERFACE INSERT : '||sqlcode||'-'||sqlerrm);
end load_in_interface;

/***********************************************
procedure of VALIDATING VALUES
************************************************/
    PROCEDURE validate_data (
        p_batch_id IN NUMBER,p_status OUT varchar2
    ) AS
--------------------> CURSOR
        CURSOR cur_po_stag IS
        SELECT
            *
        FROM
            xxintg_po_staging_table_rp
        WHERE
                status = 'N'
            AND request_id = p_batch_id;

    BEGIN
        FOR rec_po_stag IN cur_po_stag LOOP
            BEGIN
                rec_po_stag.status := 'V';
/********************************
VALIDATING ORGANISATION NAME
*********************************/
                IF rec_po_stag.org_name IS NULL THEN
                    rec_po_stag.status := 'E';
                    rec_po_stag.error_msg := 'Org_name CANNOT BE NULL';
                ELSE
                    BEGIN
                        SELECT
                            organization_id
                        INTO rec_po_stag.org_id
                        FROM
                            hr_operating_units
                        WHERE
                            upper(name) = upper(rec_po_stag.org_name);

                    EXCEPTION
                        WHEN OTHERS THEN
                            rec_po_stag.status := 'E';
                            rec_po_stag.error_msg := rec_po_stag.error_msg
                                                     || '-'
                                                     || 'Org_name DOESNT EXIST';
                    END;
                END IF;

/*************************************************
VENDOR NAME VALIDATION
(**************************************************/
                IF rec_po_stag.vendor_name IS NULL THEN
                    rec_po_stag.status := 'E';
                    rec_po_stag.error_msg := rec_po_stag.error_msg
                                             || '-'
                                             || ' VENDOR NAME CANNOT BE NULL';
                ELSE
                    BEGIN
                        SELECT
                            vendor_id
                        INTO rec_po_stag.vendor_id
                        FROM
                            ap_suppliers
                        WHERE
                            vendor_name = rec_po_stag.vendor_name;

                    EXCEPTION
                        WHEN OTHERS THEN
                            rec_po_stag.status := 'E';
                            rec_po_stag.error_msg := rec_po_stag.error_msg
                                                     || '-'
                                                     || 'VENDOR NAME NOT VALID';
                    END;
                END IF;
   
   /***********************************************
   VENDOR SITE CODE VALIDATION
   ************************************************/
                BEGIN
                    SELECT
                        vendor_site_id
                    INTO rec_po_stag.vendor_site_id
                    FROM
                        ap_supplier_sites_all
                    WHERE
                            org_id = rec_po_stag.org_id
                        AND vendor_site_code = rec_po_stag.vendor_site_code
                        AND vendor_id = rec_po_stag.vendor_id;

                EXCEPTION
                    WHEN OTHERS THEN
                        rec_po_stag.status := 'E';
                        rec_po_stag.error_msg := rec_po_stag.error_msg
                                                 || '-'
                                                 || 'VENDOR SITE CODE IS INVALID';
                END;
   
   
   /******************************
   BUYER VALIDATION
   *******************************/

                IF rec_po_stag.buyer_name IS NULL THEN
                    rec_po_stag.status := 'E';
                    rec_po_stag.error_msg := rec_po_stag.error_msg || 'BUYER NAME CANNOT BE NULL';
                ELSE
                    BEGIN
                        SELECT
                            ppl.person_id
                        INTO rec_po_stag.agent_id
                        FROM
                            po_agents        pa,
                            per_all_people_f ppl
                        WHERE
                                pa.agent_id = ppl.person_id
                            AND TRIM(upper(ppl.full_name)) = TRIM(upper(rec_po_stag.buyer_name))
                            AND trunc(sysdate) BETWEEN trunc(effective_start_date) AND trunc(effective_end_date)
                            AND ( current_employee_flag = 'Y'
                                  OR current_npw_flag = 'Y' );

                    EXCEPTION
                        WHEN OTHERS THEN
                            rec_po_stag.status := 'E';
                            rec_po_stag.error_msg := rec_po_stag.error_msg
                                                     || '-'
                                                     || 'BUYER NAME IS INVALID';
                    END;
                END IF;
   /*********************************************
   ITEM_Number NAME VALIDATION
   **********************************************/

                IF rec_po_stag.item_name IS NULL THEN
                    rec_po_stag.status := 'E';
                    rec_po_stag.error_msg := rec_po_stag.error_msg
                                             || '-'
                                             || ' ITEM NAME CANNOT BE NULL';
                ELSE
                    BEGIN
                        SELECT
                            inventory_item_id
                        INTO rec_po_stag.item_id
                        FROM
                            mtl_system_items_b
                        WHERE
                                upper(segment1) = upper(rec_po_stag.item_name)
                            AND organization_id = rec_po_stag.org_id;

                    EXCEPTION
                        WHEN OTHERS THEN
                            rec_po_stag.status := 'E';
                            rec_po_stag.error_msg := rec_po_stag.error_msg
                                                     || '-'
                                                     || ' ITEM NAME IS INVALID';
                    END;
                END IF;
   /************************************************
   UNIT OF MEASUREMENT VALIDATION
   *************************************************/
                IF rec_po_stag.uom_code IS NULL THEN
                    rec_po_stag.status := 'E';
                    rec_po_stag.error_msg := rec_po_stag.error_msg
                                             || '-'
                                             || ' UNIT OF MEASURE CANNOT BE NULL';
                END IF;

                UPDATE xxintg_po_staging_table_rp
                SET
                    status = rec_po_stag.status,
                    error_msg = rec_po_stag.error_msg,
                    org_id = rec_po_stag.org_id,
                    vendor_id = rec_po_stag.vendor_id,
                    vendor_site_id = rec_po_stag.vendor_site_id,
                    agent_id = rec_po_stag.agent_id,
                    item_id = rec_po_stag.item_id
                WHERE
                        request_id = rec_po_stag.request_id
                    AND record_id = rec_po_stag.record_id;

                COMMIT;
            EXCEPTION
                WHEN OTHERS THEN
                    fnd_file.put_line(fnd_file.output, 'backtrace : ' || dbms_utility.format_error_backtrace);
                    fnd_file.put_line(fnd_file.output, 'UNEXPEXTED ERROR IN VALIDATION '
                                                       || sqlcode
                                                       || '|'
                                                       || sqlerrm);

            END;
		p_status:=rec_po_stag.status;	
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output, 'ERROR IN VALIDATING DATA '
                                               || sqlcode
                                               || '-'
                                               || sqlerrm);

            fnd_file.put_line(fnd_file.output, dbms_utility.format_error_backtrace);
    END validate_data;
    
/*********************************************************
procedure for update in staging
**********************************************************/

procedure update_staging_data( p_request_id number)
as
cursor cur_updt_stng
is
select * from XXINTG_PO_STAGING_TABLE_RP
where  status<>'E' 
and  request_id=P_request_id;


ln_PO_header_id po_headers_all.PO_header_id%type;
ln_PO_line_id po_LINES_all.PO_line_id%type;
ln_po_number po_headers_all.segment1%type;
lc_status varchar2(5);
lc_err_msg varchar2(3000);

begin
for rec_stg in cur_updt_stng loop
begin
lc_status:='V';
lc_err_msg:='null';
begin
select pha.segment1 into ln_PO_number from po_headers_all pha,
PO_HEADERS_INTERFACE PHI, XXINTG_PO_STAGING_TABLE_RP X where 
PHA.po_header_id=PHI.po_header_id
AND PHI.BATCH_ID=X.REQUEST_ID; 
exception when others
then
lc_status:='E';
lc_err_msg:=lc_err_msg||'-'||'error while fetching req number'||sqlcode||'-'|| sqlerrm;
end;

begin


select pHa.PO_HEADER_ID into ln_PO_header_id from po_headers_all pha,
PO_HEADERS_INTERFACE phi ,XXINTG_PO_STAGING_TABLE_RP x where 
pha.PO_HEADER_ID=phi.interface_header_id
AND PHI.BATCH_ID=x.REQUEST_ID; 

exception when others
then
lc_status:='E';
lc_err_msg:=lc_err_msg||'-'||'error while fetching req header id'||sqlcode||'-'|| sqlerrm;
end;

BEGIN
select pla.po_line_id into ln_PO_line_id from PO_HEADERS_INTERFACE phi,
po_lines_all pla, XXINTG_PO_STAGING_TABLE_RP x  where 
pla.PO_HEADER_ID=phI.INTERFACE_HEADER_ID
AND PHI.BATCH_ID=x.REQUEST_ID; 
exception when others
then
lc_status:='E';
lc_err_msg:=lc_err_msg||'-'||'error while fetching req line id'||sqlcode||'-'|| sqlerrm;
end;
IF LC_STATUS='V'
THEN
UPDATE XXINTG_PO_STAGING_TABLE_RP
SET
PO_NUM=LN_po_NUMBER,
PO_HEADER_ID=LN_PO_HEADER_ID,
po_line_id=ln_po_line_id
where request_ID=REC_STG.REQUEST_ID
AND RECORD_ID=REC_STG.RECORD_ID;
ELSE 
UPDATE XXINTG_PO_STAGING_TABLE_RP
SET ERROR_MSG=LC_ERR_MSG
WHERE REQUEST_ID=REC_STG.REQUEST_ID
AND RECORD_ID=REC_STG.RECORD_ID;
END IF;
COMMIT;
EXCEPTION WHEN OTHERS THEN
FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR OCCURED WHILE UPDATING STAGING TABLE');


END ;
END LOOP;

end update_staging_data;

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
        description => 'REQUEST CONCURRENT PROGRAM  TO EXECUTE FROM API-BACKEND'
        , start_time => sysdate, sub_request => false,
                                                  argument1 => '/u01/install/APPS/fs1/EBSapps/appl/xxintg/12.0.0/bin/control_file_po_rp.ctl'
                                                  , argument2 => '/tmp/RPANWAR/po/', argument3 => p_file_name || '.csv', argument4 => '/tmp/RPANWAR/po/po_data_rp.log'
                                                  , argument5 => '/tmp/RPANWAR/po/po_data_rp.bad',
                                                  argument6 => '/tmp/RPANWAR/po/po_data_rp.dis', argument7 => '/tmp/RPANWAR/po');

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
                    UPDATE xxintg_po_staging_table_rp
                    SET
                        request_id = p_batch_id,
                        created_by = g_user_id,
                        updated_date = sysdate,
                        creation_date = sysdate,
                        updated_by = g_user_id,
                        status = 'N'
					where status is null;	

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
    PROCEDURE print_parameter (
        p_process_type VARCHAR2,
        p_file_name    VARCHAR2
    ) AS
    BEGIN
        fnd_file.put_line(fnd_file.output, rpad('P_PROCESS_TYPE', 30)
                                           || '-->'
                                           || rpad(p_process_type, 30));

        fnd_file.put_line(fnd_file.output, rpad('DATA_FILE_NAME', 30)
                                           || '-->'
                                           || rpad(p_file_name, 30));

    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output, 'ERROR OCCURED in printing parameter');
    END print_parameter;

/********************************************************
MAIN PROCEDURE
*********************************************************/
    PROCEDURE main_procedure (
        errbuff        OUT VARCHAR2,
        retcode        OUT VARCHAR2,
        p_process_type VARCHAR2,
        p_file_name    VARCHAR2
    ) AS
	lc_status varchar2(5);
        ln_count NUMBER;
    BEGIN
        print_parameter(p_process_type, p_file_name);
        IF p_process_type IS NULL THEN
            fnd_file.put_line(fnd_file.output, ' PROCESS TYPE CANNOT BE NULL');
        ELSE
            IF upper(p_process_type) NOT IN ( 'VALIDATE ONLY', 'VALIDATE LOAD' ) THEN
                fnd_file.put_line(fnd_file.output, 'PROCESS TYPE SHOULD BE VALIDATE ONLY  OR VALIDATE LOAD');
            ELSE
                IF upper(p_process_type) = upper('VALIDATE ONLY') THEN
                    load_in_staging_table(p_file_name);
                    validate_data(p_batch_id,lc_status);
                ELSE
                    IF upper(p_process_type) = upper('VALIDATE LOAD') THEN
                        load_in_staging_table(p_file_name);
                        validate_data(p_batch_id,lc_status);
						if lc_status='V' THEN
                        load_in_interface(p_batch_id);
                        LOAD_IN_BASE_TABLE(p_batch_id );

						else 
						fnd_file.put_line(fnd_file.output,'VALIDATION STATUS : '||lc_status);
						end if;
                    ELSE
                        fnd_file.put_line(fnd_file.output, 'invalid data');
                    END IF;
                END IF;
            END IF;
/*create sequence record_id_rp_stag
start with 1
increment by 1;
  */
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output, 'ERROR OCCURED IN MAIN PROCESS'
                                               || '|'
                                               || sqlcode
                                               || '|'
                                               || sqlerrm);
    END main_procedure;

END xxintg_po_insert_validate_rp;


-----------------------------------------------------------------------------------------

SELECT SEGMENT1 FROM MTL_SYSTEM_ITEMS WHERE SEGMENT1='RP_PHONE';



SELECT * FROM PO_HEADERS_INTERFACE
WHERE BATCH_ID=7715230;

SELECT * FROM PO_lines_INTERFACE
WHERE INTERFACE_HEADER_ID=1528261;




select * from po_interface_errors where creation_date=to_date('18-aug-23');

select * from po_headers_all where po_header_id='309233';

SELECT *FROM PO_LINES_INTERFACE;

SELECT * FROM xxintg_po_staging_table_rp;
truncate table xxintg_po_staging_table_rp;

select po_num_rp.nextval from dual;
create sequence po_num_rp
start with 1
increment by 1;