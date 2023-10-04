CREATE OR REPLACE PACKAGE body xxintg_receipt_rp 
AS  
    
    PROCEDURE  LOAD_IN_INTERFACE(P_BATCH_ID IN NUMBER)
   AS
    ln_user_id      NUMBER;
  ln_po_header_id NUMBER;
  ln_vendor_id    NUMBER;
  lv_segment1     VARCHAR2(20);
  ln_org_id       NUMBER;
  ln_line_num     NUMBER;
CURSOR CUR_INSERT_HEADER_INTERFACE
  IS
   SELECT  PO_HEADER_ID, VENDOR_ID, ORG_ID, PO_LINE_ID
FROM XXINTG_PO_STAGING_TABLE_RP WHERE REQUEST_ID=P_BATCH_ID AND STATUS='SC';
BEGIN

SELECT CREATED_BY,
         po_header_id,
         vendor_id,
         segment1,
         org_id
    INTO ln_user_id,
        ln_po_header_id,
         ln_vendor_id,
         lv_segment1,
         ln_org_id
    FROM po_headers_all
   WHERE segment1 =:PO_NUMBER
     AND org_id =:P_ORG_ID
     AND CREATED_BY=1014843;
  
   FOR REC_INSERT_HEADER_INTERFACE IN CUR_INSERT_HEADER_INTERFACE
   LOOP
   BEGIN
  INSERT INTO rcv_headers_interface
    (header_interface_id,
  
  
  SELECT * FROM rcv_headers_interface
  
  
   
   /* SELECT * FROM RCV_HEADERS_INTERFACE;-- PROCESSING_REQUEST_ID
 SELECT * FROM RCV_TRANSACTIONS_INTERFACE;
    */
    
    
    
    PROCEDURE main_procedure (
        errbuff        OUT VARCHAR2,
        retcode        OUT VARCHAR2,
        p_process_type VARCHAR2,
        data_file_name VARCHAR2
    );
    as
    begin
    
    null;
    end main_procedure;

END xxintg_receipt_rp;