
DECLARE
--XXAWR_INSERT_CUSTOM VARCHAR
BEGIN
 
         XXAWR_PCKG_SO_RP.SO_CREATE_IN(1).TRANSACTIONAL_CURR_CODE := 'USD';
         XXAWR_PCKG_SO_RP.SO_CREATE_IN(1).PRICING_DATE := SYSDATE;
         XXAWR_PCKG_SO_RP.SO_CREATE_IN(1).CUSTOMER_NAME :=TO_CHAR('AT Private Ltd');
         XXAWR_PCKG_SO_RP.SO_CREATE_IN(1).ORDER_TYPE_NAME :='Mixed';
         XXAWR_PCKG_SO_RP.SO_CREATE_IN(1).ORDERED_QUANTITY :=10;
         XXAWR_PCKG_SO_RP.SO_CREATE_IN(1).PRICE_LIST_NAME := 'Corporate';
        XXAWR_PCKG_SO_RP.SO_CREATE_IN(1).SOLD_FROM_ORG_NAME :='Vision Operations';
        XXAWR_PCKG_SO_RP.SO_CREATE_IN(1).SALESREP_NAME:= 'No Sales Credit';
        XXAWR_PCKG_SO_RP.SO_CREATE_IN(1).SHIP_FROM_ORG_NAME:= 'Seattle Manufacturing';
        XXAWR_PCKG_SO_RP.SO_CREATE_IN(1).INVENTORY_ITEM_NAME :='rp_car';
--XXAWR_PCKG_SO_RP.SO_CREATE_IN(1).STATUS_MSG :='N';
XXAWR_PCKG_SO_RP.SO_CREATE_IN(1).TEMP_CUST_PO_NUMBER :=1;
 XXAWR_PCKG_SO_RP.SO_CREATE_IN(1).uom_code := 'Ea';
                                 
                                 -------------------
                                 

         XXAWR_PCKG_SO_RP.SO_CREATE_IN(2).TRANSACTIONAL_CURR_CODE := 'USD';
         XXAWR_PCKG_SO_RP.SO_CREATE_IN(2).PRICING_DATE := SYSDATE;
         XXAWR_PCKG_SO_RP.SO_CREATE_IN(2).CUSTOMER_NAME :=TO_CHAR('AT Private Ltd');
         XXAWR_PCKG_SO_RP.SO_CREATE_IN(2).ORDER_TYPE_NAME :='Mixed';
         XXAWR_PCKG_SO_RP.SO_CREATE_IN(2).ORDERED_QUANTITY :=10;
         XXAWR_PCKG_SO_RP.SO_CREATE_IN(2).PRICE_LIST_NAME := 'Corporate';
        XXAWR_PCKG_SO_RP.SO_CREATE_IN(2).SOLD_FROM_ORG_NAME :='Vision Operations';
        XXAWR_PCKG_SO_RP.SO_CREATE_IN(2).SALESREP_NAME:= 'No Sales Credit';
        XXAWR_PCKG_SO_RP.SO_CREATE_IN(2).SHIP_FROM_ORG_NAME:= 'Seattle Manufacturing';
        XXAWR_PCKG_SO_RP.SO_CREATE_IN(2).INVENTORY_ITEM_NAME :='Copper_bottle';
--XXAWR_PCKG_SO_RP.SO_CREATE_IN(2).STATUS_MSG :='N';
XXAWR_PCKG_SO_RP.SO_CREATE_IN(2).TEMP_CUST_PO_NUMBER :=1;
                  XXAWR_PCKG_SO_RP.SO_CREATE_IN(2).uom_code := 'Ea';
                                 
                                 
                                 
                                 ---------------------------------------
                                 
                                 

         XXAWR_PCKG_SO_RP.SO_CREATE_IN(3).TRANSACTIONAL_CURR_CODE := 'USD';
         XXAWR_PCKG_SO_RP.SO_CREATE_IN(3).PRICING_DATE := SYSDATE;
         XXAWR_PCKG_SO_RP.SO_CREATE_IN(3).CUSTOMER_NAME :=TO_CHAR('T Private Ltd');
         XXAWR_PCKG_SO_RP.SO_CREATE_IN(3).ORDER_TYPE_NAME :='Mixed';
         XXAWR_PCKG_SO_RP.SO_CREATE_IN(3).ORDERED_QUANTITY :=10;
         XXAWR_PCKG_SO_RP.SO_CREATE_IN(3).PRICE_LIST_NAME := 'orporate';
        XXAWR_PCKG_SO_RP.SO_CREATE_IN(3).SOLD_FROM_ORG_NAME :='on Operations';
        XXAWR_PCKG_SO_RP.SO_CREATE_IN(3).SALESREP_NAME:= 'No Sales it';
        XXAWR_PCKG_SO_RP.SO_CREATE_IN(3).SHIP_FROM_ORG_NAME:= 'Seattle Manusdhfsjdhjcturing';
        XXAWR_PCKG_SO_RP.SO_CREATE_IN(3).INVENTORY_ITEM_NAME :='destmoransmission_a';
--XXAWR_PCKG_SO_RP.SO_CREATE_IN(3).STATUS_MSG :='N';
XXAWR_PCKG_SO_RP.SO_CREATE_IN(3).TEMP_CUST_PO_NUMBER :=2;

--                        XXAWR_PCKG_SO_RP.SO_CREATE_IN(1).CUSTOMER_NAME := 'AT Private Ltd';
                  XXAWR_PCKG_SO_RP.SO_CREATE_IN(3).uom_code := 'Ea';
                                                            
                                 
                                 
                                 
             XXAWR_PCKG_SO_RP.XXAWR_INSERT_CUSTOM(12,XXAWR_PCKG_SO_RP.SO_CREATE_IN,XXAWR_PCKG_SO_RP.SO_CREATE_OUT);     
--                        XXINTG_ITEM_PRICING_SEQ.NEXTVAL;
END;