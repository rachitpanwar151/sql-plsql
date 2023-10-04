CREATE OR REPLACE PACKAGE  BODY xxintg_po_insert_validate_rp AS
    
---->global variable decleration
      
	GN_GROUP_ID  NUMBER:=  rcv_interface_groups_s.nextval;
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





  l_po_header_id po_headers_all.po_header_id%type;
  l_po_number             po_headers_all.segment1%TYPE;
  l_payment_method_code   ap_invoices_all.payment_method_code%TYPE :='Check';
  l_org_id                NUMBER := 204;
  l_vendor_id             po_headers_all.vendor_id%TYPE;
  l_vendor_site_id        po_headers_all.vendor_site_id%TYPE;
  l_invoice_id            ap_invoices_all.invoice_id%TYPE;
  v_request_id            NUMBER;
  l_boolean               BOOLEAN;
  l_phase                 VARCHAR2 (200);
  l_status                VARCHAR2 (200);
  l_dev_phase             VARCHAR2 (200);
  l_dev_status            VARCHAR2 (200);
  l_message               VARCHAR2 (200);
  g_invalid_ex            EXCEPTION;
  l_error_seq             VARCHAR2 (200);
  l_error_msg             VARCHAR2 (4000);
  LN_AMT_COUNT NUMBER;

-------->cursor for header

CURSOR CUR_PO_HDR(P_PO_HDR_ID NUMBER)
IS 
SELECT DISTINCT 
               PHA.ORG_ID,
               PHA.CURRENCY_CODE,
               PHA.SEGMENT1 PO_NUMBER,
               PHA.VENDOR_ID,
               PHA.VENDOR_SITE_ID
               
        FROM PO_HEADERS_ALL PHA, XXINTG_LEGACY_MAIN_STAGING_RP xlmsr
        WHERE PHA.PO_HEADER_ID=xlmsr.PO_HEADER_ID
         AND PHA.ORG_ID=xlmsr.ORG_ID;
         
--------> cursor for line

CURSOR CUR_PO_LINE(P_PO_HDR_ID NUMBER) 
IS
SELECT * FROM PO_LINES_ALL
WHERE PO_HEADER_ID=P_PO_HDR_ID;


L_PO_HDR_ID NUMBER;

PROCEDURE ap_INTERFACE(P_PO_NUMBER IN NUMBER, P_ORG_ID IN NUMBER)
AS
/**********************************************************
procedure to load data from staging to interface for ap
************************************************************/

  BEGIN
  
  select distinct po_num,org_id into l_po_number,l_org_id
from XXINTG_PO_STAGING_RP where  request_id = p_batch_id;

  l_payment_method_code := 'CHECK';
  l_invoice_id := ap_invoices_interface_s.nextval;
 begin
SELECT distinct poh.vendor_id, poh.vendor_site_id,pol.po_header_id
    INTO   l_vendor_id, l_vendor_site_id,l_po_header_id
    FROM   po_headers_all poh, po_lines_all pol
    WHERE  poh.segment1 = l_po_number
    AND    poh.po_header_id = pol.po_header_id;
     
    SELECT
                SUM(LIST_PRICE_PER_UNIT * quantity)
            INTO ln_amt_count
            FROM
               PO_LINES_aLL
            WHERE
                po_header_id=l_po_header_id;


  EXCEPTION
    WHEN OTHERS THEN
      l_error_seq := '01';
      l_error_msg := sqlerrm;
      RAISE g_invalid_ex;
  END;
FOR REC_PO_HDR IN CUR_PO_HDR(l_po_header_id)
LOOP
  BEGIN
    INSERT INTO ap_invoices_interface (invoice_id
                                      ,invoice_num
                                      ,PO_NUMBER
                                      ,vendor_id
                                      ,vendor_site_id
                                      ,invoice_amount
                                      ,invoice_currency_code
                                      ,invoice_date
                                      ,description
                                      ,source
                                      ,org_id
                                      ,payment_method_code)
    VALUES      (l_invoice_id
                ,'rachit -' || l_invoice_id
                ,l_po_number
                ,l_vendor_id
                ,l_vendor_site_id
                ,ln_amt_count
                ,'USD'
                ,SYSDATE
                ,'This Invoice is created by RACHIT PANWAR   - '||SYSDATE
                ,'MANUAL INVOICE ENTRY'
                ,l_org_id
                ,l_payment_method_code);
  END;
  
  
    FOR REC_LINE IN CUR_PO_LINE(l_po_header_id) LOOP
    
  BEGIN
    INSERT INTO ap_invoice_lines_interface (invoice_id
                                           ,line_number
                                           ,line_type_lookup_code
                                           ,amount,
                                           po_header_id,
                                           PO_LINE_ID)
    VALUES      (l_invoice_id
                ,REC_LINE.LINE_NUM
                ,'ITEM'
                ,ln_amt_count
                ,l_po_header_id
                ,REC_LINE.PO_LINE_ID);
  END;
  
  
  COMMIT;
  END LOOP;
  END LOOP;
 END ap_INTERFACE;


  procedure load_in_ap_base_table
as
  BEGIN
    mo_global.init ('SQLAP');
    fnd_global.apps_initialize (user_id => 1014843, resp_id =>50554, resp_appl_id => 200 );
    --    fnd_request.set_org_id (204);
    --    mo_global.set_policy_context ('S', 204);

    v_request_id :=
      fnd_request.submit_request (application   => 'SQLAP'
                                 ,program       => 'APXIIMPT'
                                 ,description   => ''
                                 ,start_time    => NULL
                                 ,sub_request   => FALSE
                                 ,argument1     => 204
                                 ,argument2     => 'MANUAL INVOICE ENTRY'
                                 ,argument3     => NULL
                                 ,argument4     => NULL
                                 ,argument5     => NULL
                                 ,argument6     => NULL
                                 ,argument7     => NULL
                                 ,argument8     => 'N'
                                 ,argument9     => 'Y');
    COMMIT;

    IF v_request_id > 0 THEN
    dbms_output.put_line('SuBMITED SUCC');
      l_boolean :=
        fnd_concurrent.wait_for_request (v_request_id
                                        ,20
                                        ,0
                                        ,l_phase
                                        ,l_status
                                        ,l_dev_phase
                                        ,l_dev_status
                                        ,l_message);
else 
    dbms_output.put_line('SuBMITED WITH ERROR');
    END IF;

    dbms_output.put_line ('********************************');

    IF (l_status = 'Normal') THEN
      dbms_output.put_line ('Invoice Created Successfully, Please see the output of Payables OPEN Invoice Import program request id :' || v_request_id);
    ELSE
      l_error_seq := '02';
      l_error_msg := 'Payable Open Ivoice Pogram failed you can see the log from the application for the following reqiest id :' || v_request_id;
      RAISE g_invalid_ex;
    END IF;


  dbms_output.put_line ('********************************');
EXCEPTION
  WHEN g_invalid_ex THEN
    dbms_output.put_line ('l_error_seq = ' || l_error_seq);
    dbms_output.put_line ('l_error_msg = ' || l_error_msg);
  WHEN OTHERS THEN
    dbms_output.put_line ('Error :' || sqlerrm);

end load_in_ap_base_table;


/**************************************************
procedure for creating receipt
*******************************************************/

procedure creating_ap(p_request_id in number)
IS

cursor cur_ap
is
select distinct po_num , org_id 
from XXINTG_PO_STAGING_RP 
where request_id=p_request_id;
 BEGIN
 for rec_ap in cur_ap 
 loop
 ap_INTERFACE(rec_ap.po_num , rec_ap.oRG_ID );
  
  
  end loop;
 load_in_ap_base_table;
 
 END creating_ap;



/******************************************************
procedure for loading receipt into receipt interface 
********************************************************/
PROCEDURE RECIPTS_INTERFACE(P_PO_NUMBER IN NUMBER, P_ORG_ID IN NUMBER)
AS


  ln_user_id      NUMBER;
  ln_po_header_id NUMBER;
  ln_vendor_id    NUMBER;
  lv_segment1     VARCHAR2(20);
  ln_org_id       NUMBER;
  ln_line_num     NUMBER;
  ln_parent_txn_id NUMBER;
 
  CURSOR po_line IS
    SELECT pl.item_id,
           pl.po_line_id,
           pl.line_num,
           --pll.quantity,
           pd.quantity_ordered quantity,
           pd.po_distribution_id,
           pl.unit_meas_lookup_code,
           mp.organization_code,
           pll.line_location_id,
           pll.closed_code,
           pll.quantity_received,
           pll.cancel_flag,
           pll.shipment_num
      FROM po_lines_all          pl,
           po_line_locations_all pll,
           po_distributions_all  pd,
           mtl_parameters        mp
     WHERE pl.po_header_id = ln_po_header_id
       AND pl.po_line_id = pll.po_line_id
       AND pd.line_location_id = pll.line_location_id
       AND pd.po_line_id = pl.po_line_id
       AND pll.ship_to_organization_id = mp.organization_id;
      
BEGIN
 
ln_user_id := g_user_id;
 
  SELECT po_header_id,
         vendor_id,
         segment1,
         org_id
    INTO ln_po_header_id,
         ln_vendor_id,
         lv_segment1,
         ln_org_id
    FROM po_headers_all
   WHERE segment1 =P_PO_NUMBER
     AND org_id =P_ORG_ID;
    
  
  INSERT INTO rcv_headers_interface
    (header_interface_id,
     group_id,
     processing_status_code,
     receipt_source_code,
     transaction_type,
     last_update_date,
     last_updated_by,
     last_update_login,
     vendor_id,
     expected_receipt_date,
     validation_flag,
     org_id)
    SELECT rcv_headers_interface_s.nextval,
          GN_GROUP_ID,
           'PENDING',
           'VENDOR',
           'NEW',
           sysdate,
           ln_user_id,
           0,
           ln_vendor_id,
           sysdate,
           'y',
           ln_org_id
      FROM dual;
     
  FOR cur_po_line IN po_line
  LOOP
    IF cur_po_line.closed_code IN ('APPROVED', 'OPEN')
       AND cur_po_line.quantity_received < cur_po_line.quantity
       AND NVL(cur_po_line.cancel_flag,'N') = 'N'
    THEN
      INSERT INTO rcv_transactions_interface
        (interface_transaction_id,
         group_id,
         last_update_date,
         last_updated_by,
         creation_date,
         created_by,
         last_update_login,
         transaction_type,
         transaction_date,
         processing_status_code,
         processing_mode_code,
         transaction_status_code,
         po_header_id,
         po_line_id,
         item_id,
         quantity,
         unit_of_measure,
         po_line_location_id,
         po_distribution_id,
         auto_transact_code,
         receipt_source_code,
         to_organization_code,
         source_document_code,
         header_interface_id,
         validation_flag,
         org_id)
        SELECT rcv_transactions_interface_s.
nextval,
               rcv_interface_groups_s.currval,
               sysdate,
               ln_user_id,
               sysdate,
               ln_user_id,
               0,
               'RECEIVE',
               SYSDATE,
               'PENDING',
               'BATCH',
               'PENDING',
               ln_po_header_id,
               cur_po_line.po_line_id,
               cur_po_line.item_id,
               cur_po_line.quantity,
               cur_po_line.unit_meas_lookup_code,
               cur_po_line.line_location_id,
               cur_po_line.po_distribution_id,
               'RECEIVE',
               'VENDOR',
               cur_po_line.organization_code,
               'PO',
               rcv_headers_interface_s.currval,
               'Y',
               ln_org_id
          FROM dual;
         
      ln_parent_txn_id := rcv_transactions_interface_s.currval;  
         
      INSERT INTO rcv_transactions_interface
        (
         parent_interface_txn_id,
         interface_transaction_id,
         group_id,
         last_update_date,
         last_updated_by,
         creation_date,
         created_by,
         last_update_login,
         transaction_type,
         transaction_date,
         processing_status_code,
         processing_mode_code,
         transaction_status_code,
         po_header_id,
         po_line_id,
         item_id,
         quantity,
         unit_of_measure,
         po_line_location_id,
         po_distribution_id,
         auto_transact_code,
         receipt_source_code,
         to_organization_code,
         source_document_code,
         header_interface_id,
         validation_flag,
         org_id)
        SELECT ln_parent_txn_id,
               rcv_transactions_interface_s.nextval,
               rcv_interface_groups_s.currval,            
               sysdate,
               ln_user_id,
               sysdate,
               ln_user_id,
               0,
               'DELIVER',
               SYSDATE,
               'PENDING',
               'BATCH',
               'PENDING',
               ln_po_header_id,
               cur_po_line.po_line_id,
               cur_po_line.item_id,
               cur_po_line.quantity,
               cur_po_line.unit_meas_lookup_code,
               cur_po_line.line_location_id,
               cur_po_line.po_distribution_id,
               NULL,--'RECEIVE',
               'VENDOR',
               cur_po_line.organization_code,
               'PO',
               rcv_headers_interface_s.currval,
               'Y',
               ln_org_id
          FROM dual;         
      dbms_output.put_line('po line: ' || cur_po_line.line_num || ' shipment: ' || cur_po_line.shipment_num ||
                           ' has been inserted sucessfully inserted in the Interface tables.');
    ELSE
      dbms_output.put_line('po line ' || cur_po_line.line_num || ' is either closed, cancelled, received or have some errors');
    END IF;
  END LOOP;
  COMMIT;
END RECIPTS_INTERFACE;


/***********************************************************
procedure for loading receipt data into receipt base table
************************************************************/


    PROCEDURE load_in_receipt_base_table
    AS
        l_request_id NUMBER;
    BEGIN
         MO_GLOBAL.INIT ('PO');
    FND_GLOBAL.APPS_INITIALIZE(
    USER_ID => G_USER_ID,
    RESP_ID => G_RESP_ID,
    RESP_APPL_ID => G_RESP_APPL_ID);
    L_REQUEST_ID := FND_REQUEST.SUBMIT_REQUEST(
    APPLICATION => 'PO',
    PROGRAM =>'RVCTP',  
    DESCRIPTION => 'REQUEST CONCURRENT PROGRAM TO EXECUTE FROM API-BACKEND SJ',
    START_TIME => SYSDATE,
    SUB_REQUEST => FALSE,
   
    ARGUMENT1 =>'BATCH',
    ARGUMENT2 =>GN_GROUP_ID,
    ARGUMENT3 =>204
    
   );        COMMIT; IF ( l_request_id = 0 ) THEN
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

--            IF (
--                upper(g_phase) = 'COMPLETED'
--                AND upper(g_status) = 'NORMAL'
--            ) THEN
--                BEGIN
--                    UPDATE XXINTG_PO_STAGING_RP
--                    SET
--                        request_id = p_batch_id,
--                        created_by = g_user_id,
--                        updated_date = sysdate,
--                        creation_date = sysdate,
--                        updated_by = g_user_id,
--                        status = 'N'
--where status is null;

--                    COMMIT;
--                EXCEPTION
--                    WHEN OTHERS THEN
--                        fnd_file.put_line(fnd_file.output, sqlcode || sqlerrm);
--                END;
--            END IF;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output, 'Unexpected error '
                                               || sqlcode
                                               || ' - '
                                               || sqlerrm);

            COMMIT;
    END load_in_receipt_base_table;




/**************************************************
procedure for creating receipt
*******************************************************/

procedure creating_receipt(p_request_id in number)
IS

cursor cur_receipt
is
select distinct po_num , org_id from XXINTG_PO_STAGING_RP where request_id=p_request_id;
 BEGIN
 for rec_receipt in cur_receipt 
 loop
 RECIPTS_INTERFACE(rec_receipt.po_num , rec_receipt.oRG_ID );
  
  
  end loop;
 load_in_receipt_base_table;
 
 END creating_receipt;



    
    
    
/*********************************************************
procedure for update in staging
**********************************************************/

    PROCEDURE update_staging_data (
        p_request_id NUMBER
        ) AS

        CURSOR cur_updt_stng IS
        SELECT
            *
        FROM
            XXINTG_PO_STAGING_RP
        WHERE
                status <> 'E'
            AND request_id = p_request_id;
            
        ln_po_header_id po_headers_all.po_header_id%TYPE;
        ln_po_line_id   po_lines_all.po_line_id%TYPE;
        ln_po_number    po_headers_all.segment1%TYPE;
        lc_status       VARCHAR2(5);
        lc_err_msg      VARCHAR2(3000);
    BEGIN
        FOR rec_stg IN cur_updt_stng LOOP
            BEGIN
                    SELECT
                        DISTINCT pha.segment1,PHA.PO_HEADER_ID
                    INTO ln_po_number,ln_po_header_id
                    FROM
                        po_headers_all             pha,
                        PO_LINES_ALL  PLA,
                        po_headers_interface       phi,
                        XXINTG_PO_STAGING_RP x
                    WHERE
                            pha.po_header_id = phi.po_header_id
                        AND pha.po_header_id = pLA.po_header_id
                        AND phi.batch_id = x.request_id
                        AND x.record_id =rec_stg.record_id;
                UPDATE XXINTG_PO_STAGING_RP
                    SET
                        po_num = ln_po_number,
                        po_header_id = ln_po_header_id
                        WHERE
                            request_id = rec_stg.request_id
                        AND record_id = rec_stg.record_id;

                EXCEPTION
                    WHEN OTHERS THEN
                        lc_status := 'E';
                        lc_err_msg := lc_err_msg
                                      || '-'
                                      || 'error while UPDATING STAGING AFTER INSERTIONG IN HEADERS'
                                      || sqlerrm;
                    UPDATE XXINTG_PO_STAGING_RP
                    SET
                        error_msg = lc_err_msg
                    WHERE
                            request_id = rec_stg.request_id
                        AND record_id = rec_stg.record_id;
                        COMMIT;
end;

        END LOOP;
    END update_staging_data;
    
    
    
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
        ARGUMENT1 => '/u01/install/APPS/fs1/EBSapps/appl/xxintg/12.0.0/bin/control_file_po_rp.ctl'
 , ARGUMENT2 => '/tmp/RPANWAR/po/' ,
 ARGUMENT3 => P_FILE_NAME || '.csv' , 
 ARGUMENT4 => '/tmp/RPANWAR/po/'||p_file_name||'.log' ,
 ARGUMENT5 => '/tmp/RPANWAR/po/'||p_file_name||'.bad'
 , ARGUMENT6 => '/tmp/RPANWAR/po/'||p_file_name||'.dis' ,
 ARGUMENT7 => '/tmp/RPANWAR/po' ) ;

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
                    UPDATE XXINTG_PO_STAGING_RP
                    SET
                        request_id = p_batch_id,
                        created_by = g_user_id,
                        updated_date = sysdate,
                        creation_date = sysdate,
                        updated_by = g_user_id,
                        record_id=seq_recordid_rp.nextval,                        
                        status = 'N'
					where status is null;	
/*
create sequence seq_recordid_rp
start with 1
increment by 1;
*/

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
            XXINTG_PO_STAGING_RP
        WHERE
                status = 'N'
            AND request_id = p_batch_id;

    BEGIN
        FOR rec_po_stag IN cur_po_stag LOOP
            BEGIN
fnd_file.put_line(fnd_file.log,'loop may');
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

                UPDATE XXINTG_PO_STAGING_RP
                SET
                current_status='customised_validations',
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
    






/*******************************************
procedure for insertig in base tables
********************************************/
PROCEDURE LOAD_IN_BASE_TABLE(p_REQUEST_id IN number)
AS
CURSOR CUR_UP
IS SELECT * FROM XXINTG_PO_STAGING_RP
WHERE STATUS='V' AND REQUEST_ID=P_REQUEST_ID; 
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
        program =>'POXPOPDOI',
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
             dbms_output.put_line('ERROR IN INSERTING IN BASE TABLE');
               update XXINTG_PO_STAGING_RP 
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
--       update_staging_data(P_request_id);

BEGIN
FOR REC_UP IN CUR_UP LOOP

        update XXINTG_PO_STAGING_RP 
        set status='S' where request_id= p_batch_id
        AND RECORD_ID=REC_UP.RECORD_ID;


END LOOP;
EXCEPTION WHEN OTHERS THEN 
FND_FILE.PUT_LINE(FND_FILE.LOG,'ERROR OCCURED WHILE UPDATING STAGING'||SQLERRM);

END ;
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
    PROCEDURE load_in_interface (
        p_batch_id IN NUMBER
    ) AS

        l_e             VARCHAR2(1000);
        ln_header_count NUMBER := 1;
        p_line_count    NUMBER := 1;
        ln_header_id    NUMBER;
        ln_line_id      NUMBER;
        ln_po_num       po_headers_all.segment1%TYPE;
        ln_hdr_id       po_headers_all.po_header_id%TYPE;
        CURSOR cur_po_intf_header IS
        SELECT DISTINCT legacy_po_num,
            org_id,
            currency_code,
            agent_id,
            vendor_id,
            vendor_site_id
            
--rec_po.record_id
        FROM
            xxintg_po_staging_rp
        WHERE
                status = 'V'
            AND request_id = p_batch_id;

        CURSOR cur_po_intf_lines (
            p_po_num IN VARCHAR2
        ) IS
        SELECT
            *
        FROM
            xxintg_po_staging_rp
        WHERE
                status = 'V'
--            AND request_id = p_batch_id
            AND LEGACY_PO_NUM = p_po_num;

    BEGIN
        FOR rec_po IN cur_po_intf_header LOOP
            BEGIN
 --HEADER INSERT
                
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
                        p_batch_id,
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
                        SYSDATE
                    ); 
--LINE INSERT		

                    FOR rec_po_line IN cur_po_intf_lines(rec_po.legacy_po_num) LOOP
                        BEGIN
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
                                rec_po_line.line_num,
                                rec_po_line.line_type,
                                rec_po_line.item_name,
                                rec_po_line.uom_code,
                                rec_po_line.quantity,
                                rec_po_line.unit_price,
                                204,
                                sysdate + 10,
                                sysdate + 8,
                               SYSDATE,
                                'N'
                            );
                 UPDATE xxintg_po_staging_rp
                SET
                    current_status = 'interface_INSERTION DONE SUCCESSFULLY'
                WHERE
                        
                    record_id = rec_po_line.record_id;
                    COMMIT;


                EXCEPTION
                    WHEN OTHERS THEN
                    l_e :=sqlcode||'-'||sqlerrm;
                     UPDATE xxintg_po_staging_rp
                    SET
                        status = 'E',
                        error_msg = 'interface_INSERTION COULD NOT BE DONE' || l_e
                    WHERE
                         record_id = rec_po_line.record_id;

                    COMMIT;
                        END;
                    END LOOP;

--                END LOOP;

                
                COMMIT;
            EXCEPTION
                WHEN OTHERS THEN
                    l_e := sqlcode
                           || '-'
                           || sqlerrm;
                   
            END;
LOAD_IN_BASE_TABLE(p_batch_id);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output, 'ERROR IN INTERFACE INSERT : '
                                               || sqlcode
                                               || '-'
                                               || sqlerrm);
    END load_in_interface;
    
	
	
	
	
	
	
	
    PROCEDURE main_procedure (
        errbuff        OUT VARCHAR2,
        retcode        OUT VARCHAR2,
        p_process_type VARCHAR2,
        P_file_name VARCHAR2
    )AS
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
                  --      LOAD_IN_BASE_TABLE(p_batch_id );
                                update_staging_data(P_BATCH_id);
                      creating_receipt(P_BATCH_id);
                   
						else 
						fnd_file.put_line(fnd_file.output,'VALIDATION STATUS : '||lc_status);
						end if;
                    ELSE
                        fnd_file.put_line(fnd_file.output, 'invalid data');
               END IF;
            end if;
            end if;
            end if;
        END MAIN_PROCEDURE;
END xxintg_po_insert_validate_rp;

--DESC XXINTG_PO_STAGING_RP;