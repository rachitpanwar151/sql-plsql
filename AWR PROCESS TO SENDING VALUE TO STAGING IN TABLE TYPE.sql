--FOR HEADER
DECLARE
BEGIN
 
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(1).TRANSACTIONAL_CURR_CODE := 'USD';
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(1).PRICING_DATE := SYSDATE;
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(1).CUSTOMER_NAME :=TO_CHAR('AT Private Ltd');
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(1).ORDER_TYPE_NAME :='Mixed';
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(1).PRICE_LIST_NAME := 'Corporate';
        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(1).SOLD_FROM_ORG_NAME :='Vision Operations';
        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(1).SALESREP_NAME:= 'No Sales Credit';
        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(1).TEMP_CUST_PO_NUMBER :=1;
--        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(1).RECORD_ID :=RECORD_HDR.NEXTVAL;

                                 
                                 -------------------
                                 

         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(2).TRANSACTIONAL_CURR_CODE := 'USD';
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(2).PRICING_DATE := SYSDATE;
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(2).CUSTOMER_NAME :=TO_CHAR('AT Private Ltd');
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(2).ORDER_TYPE_NAME :='Mixed';
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(2).PRICE_LIST_NAME := 'Corporate';
        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(2).SOLD_FROM_ORG_NAME :='Vision Operations';
        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(2).SALESREP_NAME:= 'No Sales Credit';                          
        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(2).TEMP_CUST_PO_NUMBER :=1;
--        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(2).RECORD_ID :=RECORD_HDR.NEXTVAL;                                 
                                 
                                 ---------------------------------------
                                 
                                 

         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(3).TRANSACTIONAL_CURR_CODE := 'USD';
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(3).PRICING_DATE := SYSDATE;
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(3).CUSTOMER_NAME :=TO_CHAR('AT Private Ltd');
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(3).ORDER_TYPE_NAME :='Mixed';
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(3).PRICE_LIST_NAME := 'Corporate';
        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(3).SOLD_FROM_ORG_NAME :='Vision Operations';
        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(3).SALESREP_NAME:= 'No Sales Credit';
       XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(3).TEMP_CUST_PO_NUMBER :=2;
--               XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(3).RECORD_ID :=RECORD_HDR.NEXTVAL;
       
       
       
                XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(1).ORDERED_QUANTITY :=10;
        XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(1).SHIP_FROM_ORG_NAME:= 'Seattle Manufacturing';
        XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(1).INVENTORY_ITEM_NAME :='rp_car';
XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(1).TEMP_CUST_PO_NUMBER :=1;
 XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(1).uom_code := 'Ea';
-- XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(1).RECORD_ID := RECORD_LINE.NEXTVAL;                                
                                 -------------------
                                 

         XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(2).ORDERED_QUANTITY :=10;
        XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(2).SHIP_FROM_ORG_NAME:= 'Seattle Manufacturing'; 
        XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(2).INVENTORY_ITEM_NAME :='Copper_bottle';
       XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(2).TEMP_CUST_PO_NUMBER :=1;
      XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(2).uom_code := 'Ea';
--    XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(2).RECORD_ID := RECORD_LINE.NEXTVAL;                                
                                 
                                 
                                 ---------------------------------------
                               
                                 

         XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(3).ORDERED_QUANTITY :=10;
        XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(3).SHIP_FROM_ORG_NAME:= 'Seattle Manufacturing';
        XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(3).INVENTORY_ITEM_NAME :='destmok_transmission_a';
XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(3).TEMP_CUST_PO_NUMBER :=2;
XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(3).uom_code := 'Ea';
--XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(3).RECORD_ID := RECORD_LINE.NEXTVAL;

       
       XXAWR_SALES_ORDER_PACKAGE_AWR.xxawr_insert_custom_data_awr(12,
       XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR,
       XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_OUT_AWR,
       XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in,
       XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_out);     

END;