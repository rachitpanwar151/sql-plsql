create or replace package body xxintg_ap_invoice_rp
as

/***************************************************************
package body for ap invoice generation  individual
*****************************************************************/

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
               
        FROM PO_HEADERS_ALL PHA
        WHERE PHA.PO_HEADER_ID=311873
        AND PHA.ORG_ID=204;

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
  
l_po_number := '7982';
  l_payment_method_code := 'CHECK';
  l_org_id := 204;
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
                po_header_id = 311873;
 
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



PROCEDURE MAIN_PROCedure (
        errbuff        OUT VARCHAR2,
        retcode        OUT VARCHAR2)
        
        AS
        
        BEGIN
     ap_INTERFACE(7971,204);
     load_in_ap_base_table;
        
    END MAIN_PROCedure;

END xxintg_ap_invoice_rp;

--select * from po_requisition_headers_all;
-- DESC PO_HEADERS_ALL;
--SELECT * FROM AP_SUPPLIERs;
--select * from po_headers_all;
--SELECT *FROM DEPARTMENTS;
------------------------------------------------------------------------------
select * from ap_invoices_interface where po_number=7971;

SELECT * FROM AP_INTERFACE_REJECTIONS WHERE CREATED_BY =1014843 AND REQUEST_ID=7736117;


select * from ap_invoiceS_ALL ORDER BY LAST_UPDATE_DATE DESC;


select * from ap_invoiceS_ALL WHERE LAST_UPDATED_BY=1014843 ORDER BY LAST_UPDATE_DATE DESC;