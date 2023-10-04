CREATE OR REPLACE PACKAGE BODY xxintg_legacy_po_creation_rp
AS

---->global variablw decleration
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
    gn_request_id      fnd_concurrent_requests.request_id%TYPE := fnd_profile.value('CONC_REQUEST_ID');
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
from XXINTG_LEGACY_MAIN_STAGING_RP where  request_id = gn_request_id;

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
from XXINTG_LEGACY_MAIN_STAGING_RP 
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
select distinct po_num , org_id 
from XXINTG_LEGACY_MAIN_STAGING_RP 
where request_id=p_request_id;
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

procedure update_staging_data( p_request_id number)
as
BEGIN
update XXINTG_LEGACY_MAIN_STAGING_RP lg1
set lg1.po_header_id=(select int.po_header_id from po_headers_interface int
where int.interface_header_id=lg1.PO_HEADER_INTERFACE_ID)
where request_id=gn_request_id;
COMMIT;
update XXINTG_LEGACY_MAIN_STAGING_RP lg1
set lg1.po_line_id=(select int.PO_LINE_ID from PO_LINES_INTERFACE int
where int.INTERFACE_LINE_ID=lg1.PO_INTERFACE_LINE_ID)
where request_id=gn_request_id;

COMMIT;
UPDATE XXINTG_LEGACY_MAIN_STAGING_RP LG1
SET LG1.PO_NUM=(SELECT  SEGMENT1 FROM PO_HEADERS_ALL INT WHERE 
INT.PO_HEADER_ID =LG1.PO_HEADER_ID) WHERE REQUEST_ID=GN_REQUEST_ID;
COMMIT;
EXCEPTION WHEN OTHERS THEN
FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR OCCURED WHILE UPDATING STAGING TABLE');

end update_staging_data;

/*******************************************
procedure for insertig in base tables
********************************************/
PROCEDURE LOAD_IN_po_BASE_TABLE(p_REQUEST_id IN number)
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
             ,     argument6 => l_approval_status -- APPROVAL STATUS
                , argument7 => NULL, 
                  argument8 => gn_request_id, 
                  argument9 => NULL -- OPERATING UNIT
                   , argument10 => NULL -- GLOBAL AGREEMENT
                                                  ); -- GATHER STATS

        COMMIT;
        IF l_request_id = 0 THEN
         RAISE fnd_api.g_exc_error;
             dbms_output.put_line('ERROR IN REQ SUB');
               update XXINTG_LEGACY_MAIN_STAGING_RP 
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


               
        update XXINTG_LEGACY_MAIN_STAGING_RP 
        set status='SC' where request_id= gn_request_id;
--        AND RECORD_ID=P_RECORD_ID;

END IF;
        END IF;
 
 -- CHECK INTERFACE TABLE ERRORS
        BEGIN
            SELECT
                 pie.error_message 
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
END LOAD_IN_po_BASE_TABLE;



/**********************************************
proceDure of inserting into INTERFACE table
************************************************/
    PROCEDURE load_in_po_interface (
        p_batch_id IN NUMBER
    ) AS

        l_e             VARCHAR2(1000);
        ln_header_count NUMBER := 1;
        p_line_count    NUMBER := 1;
        ln_header_id    NUMBER;
        ln_line_id      NUMBER;
        ln_po_num       po_headers_all.segment1%TYPE;
        ln_hdr_id       po_headers_all.po_header_id%TYPE;
        CURSOR cur_po_intf_header 
        IS
        SELECT DISTINCT legacy_po_num,
            org_id,
            currency_code,
            agent_id,
            vendor_id,
            vendor_site_id
            ,request_id
--rec_po.record_id
        FROM
            XXINTG_LEGACY_MAIN_STAGING_RP
        WHERE
                CURRENT_STATUS = 'V'
            AND request_id = p_batch_id;

        CURSOR cur_po_intf_lines (
            p_po_num IN VARCHAR2
        ) IS
        SELECT
            *
        FROM
            XXINTG_LEGACY_MAIN_STAGING_RP
        WHERE
                CURRENT_STATUS = 'V'
--            AND request_id = p_batch_id
            AND LEGACY_PO_NUM = p_po_num;

    BEGIN
    
     fnd_file.put_line(fnd_file.log, '15');
        FOR rec_po IN cur_po_intf_header LOOP
            BEGIN
 --HEADER INSERT
                     fnd_file.put_line(fnd_file.log, '16');

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
                        gn_request_id,
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
                        'POXPOPDOI IMPORT',
                        SYSDATE
                    ); 
                         fnd_file.put_line(fnd_file.log, '17');

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
                            
                         fnd_file.put_line(fnd_file.log, '17.1');
                 commit;
                 UPDATE XXINTG_LEGACY_MAIN_STAGING_RP
                SET
                    current_status = 'interface_INSERTION DONE SUCCESSFULLY',
                    po_header_interface_id=ln_header_id,
                    po_interface_line_id=ln_line_id
                       WHERE
                                request_id = rec_po.request_id
                             AND LEGACY_PO_NUM =rec_po.LEGACY_PO_NUM
                             and error_msg is null;
                    COMMIT;
                EXCEPTION
                    WHEN OTHERS THEN
                    l_e :=sqlcode||'-'||sqlerrm;
                    
                         fnd_file.put_line(fnd_file.log, '17.2');
                        UPDATE XXINTG_LEGACY_MAIN_STAGING_RP
                        SET
                             current_status = 'interface_INSERTION UN-SUCCESSFULLY',
                            error_msg = 'ERROR WHILE INSERT DATA 
                            INTO INTERFACE TABLE.'||l_e
                        WHERE
                                request_id = rec_po.request_id
                             AND LEGACY_PO_NUM =rec_po.LEGACY_PO_NUM;
                        COMMIT;
                END;

end LOOP;
            EXCEPTION
                WHEN OTHERS THEN
                    l_e := sqlcode
                           || '-'
                           || sqlerrm;
                   
            END;
--LOAD_IN_BASE_TABLE(p_batch_id);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output, 'ERROR IN INTERFACE INSERT : '
                                               || sqlcode
                                               || '-'
                                               || sqlerrm);
    END load_in_po_interface;


/*************************************************
validations of master table
***************************************************/
procedure validate_main_table ( p_batch_id in varchar2)
--, p_status out varchar2)
as
cursor cur_main_tbl_rp
is 
select * from XXINTG_LEGACY_MAIN_STAGING_RP
where STATUS ='SV';
--and request_id = p_batch_id;
begin
--fnd_file.put_line(fnd_file.output,'validation k begin k andr aya');

     fnd_file.put_line(fnd_file.log, '12  validation data in master done ');
for rec_main_tbl_rp in cur_main_tbl_rp
loop
begin
rec_main_tbl_rp.CURRENT_STATUS:='V';

     fnd_file.put_line(fnd_file.log, '12  validation data in master done  status iss'||rec_main_tbl_rp.CURRENT_STATUS);
/*************************************
LEGACY_PO_NUM validation
**************************************/
if rec_main_tbl_rp.LEGACY_PO_NUM is null
then
rec_main_tbl_rp.ERROR_MSG:=' legacy po num cant be null';
rec_main_tbl_rp.CURRENT_STATUS:='E';
end if;
/********************************************
LINE_TYPE validation
*********************************************/
if rec_main_tbl_rp.LINE_TYPE is null then 
rec_main_tbl_rp.ERROR_MSG:=rec_main_tbl_rp.ERROR_MSG||'-'||
' line type cannot be null';
rec_main_tbl_rp.CURRENT_STATUS:='E';
end if;
/**************************************************
ORG_NAME validation
****************************************************/
  IF rec_main_tbl_rp.org_name IS NULL THEN
rec_main_tbl_rp.ERROR_MSG:=rec_main_tbl_rp.ERROR_MSG||'-'||
' org name cannot be null';
rec_main_tbl_rp.CURRENT_STATUS:='E';
                ELSE
                    BEGIN
                        SELECT
                            organization_id
                        INTO rec_main_tbl_rp.org_id
                        FROM
                            hr_operating_units
                        WHERE
                            upper(name) = upper(rec_main_tbl_rp.org_name);

                    EXCEPTION
                        WHEN OTHERS THEN
                         rec_main_tbl_rp.CURRENT_STATUS:='E';
                rec_main_tbl_rp.ERROR_MSG:=rec_main_tbl_rp.ERROR_MSG|| '-'
                                                     || 'Org_name DOESNT EXIST';
                    END;
                END IF;
/********************************************
VENDOR_NAME
*********************************************/
  IF rec_main_tbl_rp.vendor_name IS NULL THEN
                    rec_main_tbl_rp.status := 'E';
                    rec_main_tbl_rp.error_msg := rec_main_tbl_rp.error_msg
                                             || '-'
                                             || ' VENDOR NAME CANNOT BE NULL';
                ELSE  
                    BEGIN
                        SELECT
                            vendor_id
                        INTO rec_main_tbl_rp.vendor_id
                        FROM
                            ap_suppliers
                        WHERE
                            vendor_name = rec_main_tbl_rp.vendor_name;

                    EXCEPTION
                        WHEN OTHERS THEN
                          
                    rec_main_tbl_rp.status := 'E';
                    rec_main_tbl_rp.error_msg := rec_main_tbl_rp.error_msg
                                             || '-'|| 'VENDOR NAME NOT VALID';
                    END;
                END IF;
   
/*******************************************************
VENDOR_SITE_CODE
********************************************************/
  BEGIN
                    SELECT
                        vendor_site_id
                    INTO rec_main_tbl_rp.vendor_site_id
                    FROM
                        ap_supplier_sites_all
                    WHERE
                            org_id = rec_main_tbl_rp.org_id
                        AND vendor_site_code = rec_main_tbl_rp.vendor_site_code
                        AND vendor_id = rec_main_tbl_rp.vendor_id;

                EXCEPTION
                    WHEN OTHERS THEN
                        rec_main_tbl_rp.status := 'E';
                    rec_main_tbl_rp.error_msg := rec_main_tbl_rp.error_msg
                                             || '-' || 'VENDOR SITE CODE IS INVALID';
                END;
   /*********************************************************************
BUYER_NAME
**********************************************************************/

                IF rec_main_tbl_rp.buyer_name IS NULL THEN
                   rec_main_tbl_rp.status := 'E';
                    rec_main_tbl_rp.error_msg := rec_main_tbl_rp.error_msg
                                             || '-' || 'BUYER NAME CANNOT BE NULL';
                ELSE
                    BEGIN
                        SELECT
                            ppl.person_id
                        INTO rec_main_tbl_rp.agent_id
                        FROM
                            po_agents        pa,
                            per_all_people_f ppl
                        WHERE
                                pa.agent_id = ppl.person_id
                            AND TRIM(upper(ppl.full_name)) = TRIM(upper
                            (rec_main_tbl_rp.buyer_name))
                            AND trunc(sysdate) BETWEEN 
                            trunc(effective_start_date) AND trunc(effective_end_date)
                            AND ( current_employee_flag = 'Y'
                                  OR current_npw_flag = 'Y' );

                    EXCEPTION
                        WHEN OTHERS THEN
                           rec_main_tbl_rp.status := 'E';
                    rec_main_tbl_rp.error_msg := rec_main_tbl_rp.error_msg
                                             ||'-'
                                                     || 'BUYER NAME IS INVALID';
                    END;
                END IF;

/***********************************************
PO_TYPE
************************************************/
 if rec_main_tbl_rp.po_type is null
then

                           rec_main_tbl_rp.status := 'E';
                    rec_main_tbl_rp.error_msg := rec_main_tbl_rp.error_msg
                                             ||'-'
||'buyer name cannot be null';
end if;
/*********************************************************
agent_id
**********************************************************/
   
/******************************
   BUYER VALIDATION
*******************************/

                IF rec_main_tbl_rp.buyer_name IS NULL THEN
                    rec_main_tbl_rp.status := 'E';
                    rec_main_tbl_rp.error_msg := rec_main_tbl_rp.error_msg || 'BUYER NAME CANNOT BE NULL';
                ELSE
                    BEGIN
                        SELECT
                            ppl.person_id
                        INTO rec_main_tbl_rp.agent_id
                        FROM
                            po_agents        pa,
                            per_all_people_f ppl
                        WHERE
                                pa.agent_id = ppl.person_id
                            AND TRIM(upper(ppl.full_name)) = 
                            TRIM(upper(rec_main_tbl_rp.buyer_name))
                            AND trunc(sysdate) BETWEEN 
                            trunc(effective_start_date) AND trunc(effective_end_date)
                            AND ( current_employee_flag = 'Y'
                                  OR current_npw_flag = 'Y' );

                    EXCEPTION
                        WHEN OTHERS THEN
                            rec_main_tbl_rp.status := 'E';
                            rec_main_tbl_rp.error_msg := rec_main_tbl_rp.error_msg
                                                     || '-'
                                                     || 'BUYER NAME IS INVALID';
                    END;
                END IF;
/******************************************
item name
*******************************************/
IF rec_main_tbl_rp.item_name IS NULL THEN
    rec_main_tbl_rp.current_status := 'E';
    rec_main_tbl_rp.error_msg := rec_main_tbl_rp.error_msg
                                 || '-'
                                 || ' ITEM NAME CANNOT BE NULL';
ELSE
         BEGIN
                        SELECT
                            inventory_item_id
                        INTO rec_main_tbl_rp.item_id
                        FROM
                            mtl_system_items_b
                        WHERE
                                upper(segment1) = upper(rec_main_tbl_rp.item_name)
                            AND organization_id = rec_main_tbl_rp.org_id;

                    EXCEPTION
                        WHEN OTHERS THEN
rec_main_tbl_rp.current_status := 'E';

rec_main_tbl_rp.error_msg := rec_main_tbl_rp.error_msg
                             || '-'
                             || 'buyer name cannot be null'
                             || '-'
                             || ' ITEM NAME IS INVALID';           END;
                END IF;
                
/************************************************
 UNIT OF MEASUREMENT VALIDATION
*************************************************/
IF rec_main_tbl_rp.uom_code IS NULL THEN
    rec_main_tbl_rp.current_status := 'E';
    rec_main_tbl_rp.error_msg := rec_main_tbl_rp.error_msg
                                 || '-'
                                 || ' UNIT OF MEASURE CANNOT BE NULL';
END IF;

     fnd_file.put_line(fnd_file.log, '13  validation data in master done  status iss'||rec_main_tbl_rp.CURRENT_STATUS);
update XXINTG_LEGACY_MAIN_STAGING_RP
set 
CURRENT_STATUS=rec_main_tbl_rp.CURRENT_STATUS,
error_msg=rec_main_tbl_rp.error_msg,
VENDOR_SITE_ID=rec_main_tbl_rp.vendor_site_id,
VENDOR_ID=rec_main_tbl_rp.vendor_id,
ORG_ID=rec_main_tbl_rp.ORG_ID,
AGENT_ID=rec_main_tbl_rp.AGENT_ID,
ITEM_ID=rec_main_tbl_rp.ITEM_ID
WHERE 
            1=1 and
                        request_id = rec_main_tbl_rp.request_id
                        AND RECORD_ID=REC_MAIN_TBL_RP.RECORD_ID;

commit;
  EXCEPTION
                WHEN OTHERS THEN
                    fnd_file.put_line(fnd_file.output, 'backtrace : ' || dbms_utility.format_error_backtrace);
                    fnd_file.put_line(fnd_file.output, 'UNEXPEXTED ERROR IN VALIDATION '
                                                       || sqlcode
                                                       || '|'
                                                       || sqlerrm);
                                                       
     fnd_file.put_line(fnd_file.log, '14 validation data in master done  erroror mee');

end ;
end loop;
 EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output, 'ERROR IN VALIDATING DATA '
                                               || sqlcode
                                               || '-'
                                               || sqlerrm);

            fnd_file.put_line(fnd_file.output, dbms_utility.format_error_backtrace);
   
end validate_main_table;


/**********************************************
PROCEDURE TO INSERT IN MAIN/MASTER TABLE
************************************************/
PROCEDURE INSERT_IN_MASTER_TABLE(P_BATCH_ID IN VARCHAR2, P_STATUS OUT VARCHAR2)
AS
LN_PO_HEADER_ID NUMBER;
CURSOR CUR_STAG1
IS
SELECT * FROM xxintg_lagacy1_stag WHERE 1=1
AND request_id=gn_request_ID 
AND STATUS1_LEGACY1 ='V';
CURSOR CUR_STAG2 
IS 
SELECT * FROM xxintg_legacy2_stag WHERE 1=1
and request_id=gn_request_id
AND STATUS_LEGACY2 ='V';

CURSOR CUR_STAG3 IS
SELECT * FROM xxintg_legacy3_stag
WHERE 1=1 AND
REQUEST_ID=GN_REQUEST_ID AND
STATUS_LEGACY3='V';
BEGIN
begin
FOR REC_STAG1 IN CUR_STAG1
LOOP
/*

CREATE SEQUENCE PO_HEADER_ID_SEQ_RP
 START WITH     1
 INCREMENT BY   1;

*/
     fnd_file.put_line(fnd_file.log, '8  status leg1 master validation ');

LN_PO_HEADER_ID:=PO_HEADER_ID_SEQ_RP.NEXTVAL;
DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY. FORMAT_ERROR_BACKTRACE);
INSERT INTO XXINTG_LEGACY_MAIN_STAGING_RP
(	
	LEGACY_PO_NUM, 
	LINE_TYPE,
	ORG_NAME,
	VENDOR_NAME,
	BUYER_NAME, 
	PO_TYPE, 
	VENDOR_SITE_CODE,
	SHIP_TO_LOC_ID, 
	BILL_TO_LOC_ID, 
	ITEM_NAME, 
	UOM_CODE, 
	QUANTITY, 
	UNIT_PRICE, 
	CURRENCY_CODE, 
	LINE_NUM
    ,request_id,
    record_id)
    VALUES(
    
    REC_STAG1.LEGACY_PO_NUM,
    REC_STAG1.LINE_TYPE,
    REC_STAG1.ORG_NAME,
    REC_STAG1.VENDOR_NAME,
    REC_STAG1.BUYER_NAME,
    REC_STAG1.PO_TYPE,
    REC_STAG1.VENDOR_SITE_NAME,
    REC_STAG1.SHIP_TO_LOC_ID,
    REC_STAG1.BILL_TO_LOC_ID,
    REC_STAG1.ITEM_NAME,
    REC_STAG1.UOM_CODE,
    REC_STAG1.QUANTITY,
    REC_STAG1.UNIT_PRICE,
    REC_STAG1.CURRENCY_CODE,
    REC_STAG1.LINE_NUM,
    REC_STAG1.request_id,
    REC_STAG1.record_id
    );
    DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    
     fnd_file.put_line(fnd_file.log, '10  validation data in master done ');
    UPDATE XXINTG_LEGACY_MAIN_STAGING_RP
    SET
    CREATED_BY=g_user_id,
    CREATION_DATE=SYSDATE,
    UPDATED_BY=g_user_id,
    UPDATED_DATE=SYSDATE,
    STATUS='SV' 
    where request_id=REC_STAG1.request_id;
    END LOOP;
        exception when others then
    fnd_file.put_line(fnd_file.log,sqlcode||'-'||sqlerrm);
    end;
begin
FOR REC_STAG2 IN CUR_STAG2
LOOP

insert into XXINTG_LEGACY_MAIN_STAGING_RP
(
LEGACY_PO_NUM,
LINE_TYPE
,ORG_NAME,
VENDOR_NAME,
VENDOR_SITE_CODE,
BUYER_NAME
,ITEM_NAME,
UOM_CODE,
QUANTITY,
CURRENCY_CODE ,
 LINE_NUM ,request_id,
 record_id
)

values
(
 REC_STAG2.legacy_po_num,
 REC_STAG2.LINE_TYPE ,
 REC_STAG2.ORG_NAME ,
 REC_STAG2.SUPPLIER_NAME ,
 REC_STAG2.SUPPLIER_SITE_CODE ,
 REC_STAG2.AGENT_NAME,
 REC_STAG2.ITEM_Name  ,
 REC_STAG2.UOM_CODE ,
 REC_STAG2.QUANTITY ,
 REC_STAG2.CURRENCY_CODE ,
 REC_STAG2.LINE_NUM ,REC_STAG2.request_id,
 REC_STAG2.record_id
);
  UPDATE XXINTG_LEGACY_MAIN_STAGING_RP
    SET CREATED_BY=g_user_id,
    CREATION_DATE=SYSDATE,
    UPDATED_BY=g_user_id,
    UPDATED_DATE=SYSDATE,
    STATUS='SV'
    where request_id=REC_STAG2.request_id;

END LOOP;
   exception when others then
    fnd_file.put_line(fnd_file.log,sqlcode||'-'||sqlerrm);
    end;

begin
FOR REC_STAG3 IN CUR_STAG3 LOOP
INSERT INTO XXINTG_LEGACY_MAIN_STAGING_RP
(
	LEGACY_PO_NUM, 
	LINE_TYPE,
	ORG_NAME,
	VENDOR_NAME,       
    VENDOR_SITE_CODE,    
	ITEM_NAME, 
	UOM_CODE,
    request_id,
    record_id
)    VALUES(
REC_STAG3.LEGACY_PO_NUM,
    REC_STAG3.LINE_TYPE,
    REC_STAG3.ORG_NAME,
    REC_STAG3.SUPPLIER_NAME,
    REC_STAG3.SUPPLIER_SITE_CODE,
    REC_STAG3.ITEM_NAME,
    REC_STAG3.UOM_CODE,
    REC_STAG3.request_id,
    REC_STAG3.record_id
    );
    DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY. FORMAT_ERROR_BACKTRACE);
    UPDATE XXINTG_LEGACY_MAIN_STAGING_RP
    SET 
    CREATED_BY=g_user_id,
    CREATION_DATE=SYSDATE,
    UPDATED_BY=g_user_id,
    UPDATED_DATE=SYSDATE,
    STATUS='SV'
    where request_id=REC_STAG3.request_id;
    END LOOP;
   exception when others then
    fnd_file.put_line(fnd_file.log,sqlcode||'-'||sqlerrm);
    end;


 END INSERT_IN_MASTER_TABLE;



/******************************************
VALIDATION FOR LEGACY 1
*******************************************/
PROCEDURE VALIDATION_LEGACY1(P_BATCH_ID IN NUMBER,
P_STATUS OUT VARCHAR2)
AS
CURSOR CUR_LEGACY1
IS
SELECT * FROM xxintg_lagacy1_stag
WHERE request_id=gn_request_id
AND STATUS1_LEGACY1 ='N';
BEGIN
FOR REC_LEGACY1 IN CUR_LEGACY1 
LOOP
BEGIN
     fnd_file.put_line(fnd_file.log, '6  status leg1 validation '||rec_legacy1.status1_legacy1);

REC_LEGACY1.STATUS1_LEGACY1:='V';
/*****************************************
legacy_po_num VALIDATION
*******************************************/
IF REC_LEGACY1.legacy_po_num IS NULL
THEN
REC_LEGACY1.STATUS1_LEGACY1:='E';
REC_LEGACY1.ERROR_LEGACY1:='LEGACY PO NUM CANT BE NULL';
END IF;
/**************************************
LINE TYPE VALIDATION
***************************************/
IF REC_LEGACY1.LINE_TYPE IS NULL 
THEN
REC_LEGACY1.STATUS1_LEGACY1:='E';
REC_LEGACY1.ERROR_LEGACY1:=' LINE TYPE CANNOT  BE NULL';
END IF;
/***********************************************
ORG NAME/id validation
*************************************************/

IF REC_LEGACY1.ORG_NAME IS NULL 
THEN
REC_LEGACY1.STATUS1_LEGACy1:='E';
REC_LEGACY1.ERROR_LEGACY1:='ORG NAME CANNOTBE NULL';
END IF;
/*****************************************
VENDOR NAME 
******************************************/
IF REC_LEGACY1.VENDOR_NAME IS NULL
THEN
REC_LEGACY1.STATUS1_LEGACY1:='E';
REC_LEGACY1.ERROR_LEGACY1:='VENDOR NAME CANNOT BE NULL';
END IF;
/*************************************************
VENDOR SITE NAme VALIDATION
**************************************************/
IF REC_LEGACY1.VENDOR_SITE_NAME is null then 
REC_LEGACY1.STATUS1_LEGACY1:='E';
REC_LEGACY1.ERROR_LEGACY1:='VENDOR NAME CANNOT BE NULL';
end if;

/***************************************
buyer name validation
****************************************/
if rec_legacy1.buyer_name is null
then
rec_legacy1.status1_legacy1:='E';
rec_legacy1.error_legacy1:=' buyer name cannot be null';
end if;
/******************************************
po_type validation
*******************************************/
if rec_legacy1.po_type is null
then
rec_legacy1.status1_legacy1:='E';
rec_legacy1.error_legacy1:=' po type cannot be null';
end if;

/**********************************************
ship to loc id validation
***********************************************/
if rec_legacy1.ship_to_loc_id is null then
rec_legacy1.status1_legacy1:='E';
rec_legacy1.error_legacy1:=' ship to location id ';
end if;

/**************************************************
bill to location id validation
***************************************************/
if rec_legacy1.bill_to_loc_id is null then
rec_legacy1.status1_legacy1:='E';
rec_legacy1.error_legacy1:='bill to location id  cannot be null';
end if;


/****************************************************
item name validation
*******************************************************/

if rec_legacy1.item_name is null 
then
rec_legacy1.status1_legacy1:='E';
rec_legacy1.error_legacy1:='item name cannot be null';
end if;
/***********************************************************
uom code validation
************************************************/
if rec_legacy1.uom_code is null  
then
rec_legacy1.status1_legacy1:='E';
rec_legacy1.error_legacy1:='uom code cannot be null';
end if;
/*********************************************
quantity validation
*********************************************/

if rec_legacy1.quantity is null 
then
rec_legacy1.status1_legacy1:='E';
rec_legacy1.error_legacy1:='quantity cannot be null';
end if;
/********************************************
unit price validation
**********************************************/

if rec_legacy1.unit_price is null 
then
rec_legacy1.status1_legacy1:='E';
rec_legacy1.error_legacy1:='unit price  cannot be null';
end if;

/*********************************************
country code validation
*********************************************/

if rec_legacy1.currency_code is null 
then
rec_legacy1.status1_legacy1:='E';
rec_legacy1.error_legacy1:='country code cannot be null';
end if;
/*********************************
line num
**********************************/

if rec_legacy1.line_num is null 
then
rec_legacy1.status1_legacy1:='E';
rec_legacy1.error_legacy1:='line num cannot be null';
end if;

     fnd_file.put_line(fnd_file.log, '7  status leg1 validation '||rec_legacy1.status1_legacy1);
UPDATE xxintg_lagacy1_stag
SET  status1_legacy1=rec_legacy1.status1_legacy1
,error_legacy1=rec_legacy1.error_legacy1 
WHERE 
 request_id = rec_legacy1.request_id;
 
                COMMIT;
            EXCEPTION
                WHEN OTHERS THEN
   fnd_file.put_line(fnd_file.output, 'backtrace : ' || dbms_utility.format_error_backtrace);
   fnd_file.put_line(fnd_file.output, 'UNEXPEXTED ERROR IN VALIDATION '
                                                       || sqlcode
                                                       || '|'
                                                       || sqlerrm);

end;

END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output, 'ERROR IN VALIDATING DATA '
                                               || sqlcode
                                               || '-'
                                               || sqlerrm);

    fnd_file.put_line(fnd_file.output, dbms_utility.format_error_backtrace);
   END VALIDATION_LEGACY1;



/******************************************
VALIDATION FOR LEGACY 2
*******************************************/
PROCEDURE VALIDATION_LEGACY2(P_BATCH_ID IN NUMBER,
P_STATUS OUT VARCHAR2)
AS
CURSOR CUR_LEGACY2
IS
SELECT * FROM xxintg_legacy2_stag
WHERE REQUEST_ID=gn_request_id
AND STATUS_LEGACY2 ='N';
BEGIN
FOR REC_LEGACY2 IN CUR_LEGACY2 
LOOP
BEGIN
REC_LEGACY2.STATUS_LEGACY2:='V';
/*****************************************
legacy_po_num VALIDATION
*******************************************/
IF REC_LEGACY2.legacy_po_num IS NULL
THEN
REC_LEGACY2.STATUS_LEGACY2:='E';
REC_LEGACY2.ERROR_LEGACY2:='LEGACY PO NUM CANT BE NULL';
END IF;
/**************************************
LINE TYPE VALIDATION
***************************************/
IF REC_LEGACY2.LINE_TYPE IS NULL 
THEN
REC_LEGACY2.STATUS_LEGACY2:='E';
REC_LEGACY2.ERROR_LEGACY2:=' LINE TYPE CANNOT  BE NULL';
END IF;
/***********************************************
ORG NAME/id validation
*************************************************/

IF REC_LEGACY2.ORG_NAME IS NULL 
THEN
REC_LEGACY2.STATUS_LEGACy2:='E';
REC_LEGACY2.ERROR_LEGACY2:='ORG NAME CANNOTBE NULL';
END IF;
/*****************************************
VENDOR/supplier NAME 
******************************************/
IF REC_LEGACY2.supplier_NAME IS NULL
THEN
REC_LEGACY2.STATUS_LEGACY2:='E';
REC_LEGACY2.ERROR_LEGACY2:='VENDOR NAME CANNOT BE NULL';
END IF;
/*************************************************
VENDOR/supplier SITE NAme VALIDATION
**************************************************/
IF REC_LEGACY2.supplier_SITE_code is null then 
REC_LEGACY2.STATUS_LEGACY2:='E';
REC_LEGACY2.ERROR_LEGACY2:='VENDOR NAME CANNOT BE NULL';
end if;

/****************************************************
item name validation
*******************************************************/

if rec_legacy2.item_name is null 
then
rec_legacy2.status_legacy2:='E';
rec_legacy2.error_legacy2:='item name cannot be null';
end if;
/***********************************************************
uom code validation
************************************************/
if rec_legacy2.uom_code is null  
then
rec_legacy2.status_legacy2:='E';
rec_legacy2.error_legacy2:='uom code cannot be null';
end if;
/*********************************************
quantity validation
*********************************************/

if rec_legacy2.quantity is null 
then
rec_legacy2.status_legacy2:='E';
rec_legacy2.error_legacy2:='quantity cannot be null';
end if;
/********************************************
unit price validation
**********************************************/

if rec_legacy2.unit_price is null 
then
rec_legacy2.status_legacy2:='E';
rec_legacy2.error_legacy2:='unit price  cannot be null';
end if;

/*********************************************
country code validation
*********************************************/

if rec_legacy2.currency_code is null 
then
rec_legacy2.status_legacy2:='E';
rec_legacy2.error_legacy2:='country code cannot be null';
end if;
/*********************************
line num
**********************************/

if rec_legacy2.line_num is null 
then
rec_legacy2.status_legacy2:='E';
rec_legacy2.error_legacy2:='line num cannot be null';
end if;

UPDATE xxintg_legacy2_stag
SET  status_legacy2=rec_legacy2.status_legacy2
,ERROR_LEGACY2=rec_legacy2.ERROR_LEGACY2 
WHERE 
 request_id = rec_legacy2.request_id;
  commit;
             EXCEPTION
                WHEN OTHERS THEN
                    fnd_file.put_line(fnd_file.output, 'backtrace : ' || dbms_utility.format_error_backtrace);
                    fnd_file.put_line(fnd_file.output, 'UNEXPEXTED ERROR IN VALIDATION '
                                                       || sqlcode
                                                       || '|'
                                                       || sqlerrm);
 end;         
 fnd_file.put_line(fnd_file.output, dbms_utility.format_error_backtrace);

END LOOP;
END VALIDATION_LEGACY2;


/******************************************
VALIDATION FOR LEGACY 3
*******************************************/
PROCEDURE VALIDATION_LEGACY3(P_BATCH_ID IN NUMBER,
P_STATUS OUT VARCHAR2)
AS
CURSOR CUR_LEGACY3
IS
SELECT * FROM xxintg_legacy3_stag
WHERE REQUEST_ID=gn_request_id
AND STATUS_LEGACY3 ='N';
BEGIN
FOR REC_LEGACY3 IN CUR_LEGACY3 
LOOP
BEGIN
REC_LEGACY3.STATUS_LEGACY3:='V';
/*****************************************
legacy_po_num VALIDATION
*******************************************/
IF REC_LEGACY3.legacy_po_num IS NULL
THEN
REC_LEGACY3.STATUS_LEGACY3:='E';
REC_LEGACY3.ERROR_LEGACY3:='LEGACY PO NUM CANT BE NULL';
END IF;
/**************************************
LINE TYPE VALIDATION
***************************************/
IF REC_LEGACY3.LINE_TYPE IS NULL 
THEN
REC_LEGACY3.STATUS_LEGACY3:='E';
REC_LEGACY3.ERROR_LEGACY3:=' LINE TYPE CANNOT  BE NULL';
END IF;
/***********************************************
ORG NAME validation
*************************************************/

IF REC_LEGACY3.ORG_NAME IS NULL 
THEN
REC_LEGACY3.STATUS_LEGACy3:='E';
REC_LEGACY3.ERROR_LEGACY3:='ORG NAME CANNOTBE NULL';
END IF;
/*****************************************
VENDOR/supplier NAME 
******************************************/
IF REC_LEGACY3.supplier_NAME IS NULL
THEN
REC_LEGACY3.STATUS_LEGACY3:='E';
REC_LEGACY3.ERROR_LEGACY3:='VENDOR NAME CANNOT BE NULL';
END IF;
/*************************************************
VENDOR/supplier SITE NAme VALIDATION
**************************************************/
IF REC_LEGACY3.supplier_SITE_code is null then 
REC_LEGACY3.STATUS_LEGACY3:='E';
REC_LEGACY3.ERROR_LEGACY3:='VENDOR NAME CANNOT BE NULL';
end if;

/****************************************************
item name validation
*******************************************************/

if rec_legacy3.item_name is null 
then
rec_legacy3.status_legacy3:='E';
rec_legacy3.ERROR_LEGACY3:='item name cannot be null';
end if;
/***********************************************************
uom code validation
************************************************/
if rec_legacy3.uom_code is null  
then
rec_legacy3.status_legacy3:='E';
rec_legacy3.ERROR_LEGACY3:='uom code cannot be null';
end if;
end;

UPDATE xxintg_legacy3_stag
SET  status_legacy3=rec_legacy3.status_legacy3
,ERROR_LEGACY3=rec_legacy3.ERROR_LEGACY3 
WHERE 
 request_id = rec_legacy3.request_id;
  commit;
            
END LOOP;
END VALIDATION_LEGACY3;





/**************************************
** PROCEDURE FOR DATA LOAD IN STAGGING  
***************************************/
  PROCEDURE LOAD_IN_legacy_STAG(
        P_DATA_FILE_NAME IN VARCHAR2, 
        P_file_PATH IN VARCHAR2) AS

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
    BEGIN
        mo_global.init('PO');
        fnd_global.apps_initialize(user_id => g_user_id, 
        resp_id => g_resp_id, resp_appl_id => g_resp_appl_id);

     fnd_file.put_line(fnd_file.log, '2 ');


       L_REQUEST_ID := FND_REQUEST.SUBMIT_REQUEST(
    APPLICATION => 'XXINTG',
    PROGRAM => 'XXINTG_RACHIT', 
    DESCRIPTION => 'REQUEST CONCURRENT PROGRAM TO EXECUTE FROM API-BACKEND rachit panwar',
    START_TIME => SYSDATE,
    SUB_REQUEST => FALSE,
   argument1 => P_file_PATH||P_DATA_FILE_NAME||'.ctl'
    , argument2 =>P_file_PATH,
    argument3 =>P_DATA_FILE_NAME||'.csv', 
    argument4 => '/tmp/RPANWAR/'||P_DATA_FILE_NAME||gn_request_id||'.log'
    , argument5 => '/tmp/RPANWAR/'||P_DATA_FILE_NAME||gn_request_id||'.bad',
   argument6 => '/tmp/RPANWAR/'||P_DATA_FILE_NAME||gn_request_id||'.dis',
    argument7 => '/tmp/RPANWAR/'
                        );

        COMMIT;


        IF L_REQUEST_ID = 0 THEN
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'REQUEST ID NOT GENERATED');
        ELSe
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'REQUEST GENERATED');
            LOOP
                LC_CONC_STATUS := FND_CONCURRENT.WAIT_FOR_REQUEST(
                REQUEST_ID => L_REQUEST_ID,
                INTERVAL => LN_INTERVAL,
                MAX_WAIT => LN_MAX_WAIT
                , PHASE => LC_PHASE,
                STATUS => LC_STATUS,
                DEV_PHASE => LC_DEV_PHASE,
                DEV_STATUS => LC_DEV_STATUS,
                MESSAGE => LC_MESSAGE
                  );
EXIT WHEN UPPER(LC_PHASE) = 'COMPLETED' OR
UPPER(LC_STATUS) IN ( 'CANCELLED', 'ERROR', 'TERMINATED' );

            END LOOP;
            IF (
                UPPER(LC_PHASE) = 'COMPLETED'
                AND UPPER(LC_STATUS) = 'NORMAL'
            ) THEN

/*
create sequence record_id_stag1_rp_seq
start with 1
increment by 1;
*/
                begin
                UPDATE xxintg_lagacy1_stag
                    SET
                        request_id = gn_request_id,
                        record_id= record_id_stag1_rp_seq.nextval,
                        STATUS1_LEGACY1 = 'N'
					where STATUS1_LEGACY1 is null;	
      
     fnd_file.put_line(fnd_file.log, '3 ');
      commit;
           EXCEPTION
                    WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('Error in Updating '
                                             || SQLERRM
                                             || ' - '
                                             || L_REQUEST_ID);
                        FND_FILE.PUT_LINE(FND_FILE.LOG, 'Error in Updating stag1 status '
                                                        || SQLERRM
                                                        || ' - '
                                                        || L_REQUEST_ID);

      end;
/*
create sequence record_id_stag2_rp_seq
start with 1
increment by 1;
*/
begin
      UPDATE xxintg_legacy2_stag
      SET
      request_id = gn_request_id,
      record_id=record_id_stag2_rp_seq.nextval,
    status_legacy2 = 'N'
     WHERE
    status_legacy2 IS NULL;
commit;
    FND_FILE.PUT_LINE(FND_FILE.OUTPUT, 'REQUEST SUBMITTED SUCCESSFULLY REQUEST id ' || L_REQUEST_ID);
                
           EXCEPTION
                    WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('Error in Updating stag2 status '
                                             || SQLERRM
                                             || ' - '
                                             || L_REQUEST_ID);
                        FND_FILE.PUT_LINE(FND_FILE.LOG, 'Error in Updating '
                                                        || SQLERRM
                                                        || ' - '
                                                        || L_REQUEST_ID);

    end;
/*
create sequence record_id_stag3_rp_seq
start with 1
increment by 1;
*/
begin
          UPDATE xxintg_legacy3_stag
                    SET
                    request_id = gn_request_id,
                    record_id=record_id_stag3_rp_seq.nextval,
                    status_legacy3 = 'N'
                     WHERE
                        status_legacy3 IS NULL;                
       commit;         
                    DBMS_OUTPUT.PUT_LINE('Request submitted successfully request id ' || L_REQUEST_ID);
                    FND_FILE.PUT_LINE(FND_FILE.OUTPUT, 'REQUEST SUBMITTED SUCCESSFULLY REQUEST id ' || L_REQUEST_ID);
                EXCEPTION
                    WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('Error in Updating stag3 status '
                                             || SQLERRM
                                             || ' - '
                                             || L_REQUEST_ID);
                        FND_FILE.PUT_LINE(FND_FILE.LOG, 'Error in Updating '
                                                        || SQLERRM
                                                        || ' - '
                                                        || L_REQUEST_ID);

                END;
            ELSE
                DBMS_OUTPUT.PUT_LINE('Error  '
                                     || SQLERRM
                                     || ' - '
                                     || L_REQUEST_ID);
                FND_FILE.PUT_LINE(FND_FILE.LOG, 'Error  '
                                                || SQLERRM
                                                || ' - '
                                                || L_REQUEST_ID);

            END IF;

        END IF;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected errro ' || SQLERRM);
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'Unexpected errro ' || SQLERRM);
    END LOAD_IN_legacy_STAG;

/**************************************
** MAIN PROCEDURE FOR CALLING 
***************************************/    
PROCEDURE main_procedure (
    errbuff        OUT VARCHAR2,
    reetcode       OUT VARCHAR2,
    data_file_name IN VARCHAR2,
    SOURCE IN VARCHAR2
)AS
lc_file_name varchar2(200);
LC_STATUS VARCHAR2(20);
lc_file_path varchar2(200);
LN_REQUEST_ID NUMBER:=gn_request_id;
--LN_PO_NUM NUMBER;
BEGIN
begin
        Select substr(meaning,instr(meaning,'/',-1)+1),substr(meaning,1,instr(meaning,'/',-1))
        into lc_file_name,lc_file_path 
        from fnd_lookups where lookup_type='XXINTG_LEGACY1_LOOKUP_RACHIT'
        and lookup_code=SOURCE;
--SELECT PO_NUM INTO LN_PO_NUM 
--FROM xxintg_legacy_main_staging_rp
--WHERE REQUEST_ID=GN_REQUEST_ID;
    END;
     fnd_file.put_line(fnd_file.log, '1 ');
     if SOURCE=upper('legacy1')
     then
    LOAD_IN_legacy_STAG(lc_file_name, lc_file_path);
VALIDATION_LEGACY1(LN_REQUEST_ID,LC_STATUS);
VALIDATION_LEGACY3(LN_REQUEST_ID,LC_STATUS);
INSERT_IN_MASTER_TABLE(LN_REQUEST_ID, LC_STATUS);
validate_main_table (LN_REQUEST_ID);
load_in_po_interface (LN_REQUEST_ID);
LOAD_IN_po_BASE_TABLE(LN_REQUEST_ID );
 update_staging_data(LN_REQUEST_ID);

creating_receipt(LN_REQUEST_ID);
creating_ap(LN_REQUEST_ID);
end if;
if SOURCE=upper('legacy1')
     then
    LOAD_IN_legacy_STAG(lc_file_name, lc_file_path);
VALIDATION_LEGACY2(LN_REQUEST_ID,LC_STATUS);
INSERT_IN_MASTER_TABLE(LN_REQUEST_ID, LC_STATUS);
validate_main_table (LN_REQUEST_ID);
 end if;
if SOURCE=upper('legacy3')
     then
    LOAD_IN_legacy_STAG(lc_file_name, lc_file_path);
VALIDATION_LEGACY3(LN_REQUEST_ID,LC_STATUS);
INSERT_IN_MASTER_TABLE(LN_REQUEST_ID, LC_STATUS);
validate_main_table (LN_REQUEST_ID);
 end if;
 

END main_procedure;

END xxintg_legacy_po_creation_rp;
