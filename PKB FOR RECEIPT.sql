CREATE OR REPLACE PACKAGE BODY XXINTG_RECEIPT_PKG_RP AS

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



PROCEDURE MAIN_PROC (
        errbuff        OUT VARCHAR2,
        retcode        OUT VARCHAR2)
        
        AS
        
        BEGIN
     RECIPTS_INTERFACE(7971,204);
     load_in_receipt_base_table;
        
    END MAIN_PROC;



END XXINTG_RECEIPT_PKG_RP;
--------------------------------------------------------------------------------------------------------------------

SELECT * FROM RCV_SHIPMENT_HEADERS;