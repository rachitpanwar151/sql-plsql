
  CREATE TABLE XXAWR_SO_STAGING 
   (INTERFACE_ID VARCHAR2(240),
   TEMP_CUST_PO_NUMBER NUMBER,
   record_ID VARCHAR2(240), 
	REQUEST_ID VARCHAR2(240 ), 
	OPERATION VARCHAR2(240 ), 
	TRANSACTIONAL_CURR_CODE VARCHAR2(240 ), 
	PRICING_DATE DATE, 
	CUSTOMER_NAME VARCHAR2(240 ), --SOLD TO ORG NAME
	CUSTOMER_ID VARCHAR2(240 ), --SOLD TO ORG ID
	ORDER_TYPE_NAME VARCHAR2(240 ),
    FLOWSTATUSCODE_HDR VARCHAR2(240),
    FLOWSTATUSCODE_LINE VARCHAR2(240),
	ORDERED_DATE DATE, 
	ORDERED_TYPE_ID VARCHAR2(240), 
	ORDERED_QUANTITY NUMBER, 
	PRICE_LIST_NAME VARCHAR2(240), 
	PRICE_LIST_ID VARCHAR2(240 ), 
	SOLD_FROM_ORG_ID VARCHAR2(240 ), 
	SOLD_FROM_ORG_NAME VARCHAR2(240), 
	SALESREP_ID VARCHAR2(240 ), 
	SALESREP_NAME VARCHAR2(240), 
	SHIP_FROM_ORG_ID VARCHAR2(240 ), 
	SHIP_FROM_ORG_NAME VARCHAR2(240 ),
    SHIP_TO_ORG_ID varchar2(240),
    SHIP_TO_ORG_name  varchar2(240),
	INVENTORY_ITEM_ID VARCHAR2(240),
    INVENTORY_ITEM_NAME VARCHAR2(240), 
	PARTY_TYPE VARCHAR2(240 ), 
	PARTY_TYPE_ID VARCHAR2(240 ), 
	ORDER_HEADER_ID VARCHAR2(240 ),
    ORDER_LINE_ID VARCHAR2(200),
    UOM_CODE varchar2(240),
	ORDER_NUMBER NUMBER, 
--    DELIVERY_ID VARCHAR2(240),
	SPLIT_BY VARCHAR2(240 ), 
	SPLIT_ACTION_CODE VARCHAR2(240 ), 
	CHANGE_REASON VARCHAR2(240 ), 
	ACTION_CODE VARCHAR2(2 ), 
	DELIVERY_ID VARCHAR2(240 ), 
	ACTION_FLAG VARCHAR2(240 ), 
	CLOSE_TRIP_FLAG VARCHAR2(240 ), 
	TRIP_SHIP_METHOD VARCHAR2(240 ), 
	DEFER_INTERFACE_FLAG VARCHAR2(240), 
	L_LINE_TBL_INDEX VARCHAR2(240 ), 
	RETURN_REASON VARCHAR2(240 ), 
	RETURN_ATTRIBUTE1 VARCHAR2(240), 
	STATUS_MSG VARCHAR2(2000 ),
	ERROR_MSG VARCHAR2(2000 ), 
	CREATED_BY VARCHAR2(240 ), 
	CREATED_DATE DATE, 
	LAST_UPDATED_BY VARCHAR2(240 ), 
	LAST_UPDATED_DATE DATE, 
	LAST_LOGIN VARCHAR2(240 )
   ) ;
   
   DROP TABLE XXAWR_SO_STAGING;
   
   select * from xxawr_so_staging
   order by 2; 
   
   
   truncate table xxawr_so_staging;
   
   
   
   select * from WSH_DELIVERY_DETAILS wHERe SOURCE_HEADER_ID=464794;
   
   select * from oe_order_lines_all wHERe line_ID=773288;
   select FLOW_STATUS_CODE,a.* from oe_order_lines_all a wHERe created_by=1014843
   order by creation_Date desc;
   
   select FLOW_STATUS_CODE from oe_order_HEADERS_all wHERe HEADER_ID=464794;
   
   
   select FLOW_STATUS_CODE from oe_order_headers_all h where header_id=464781;
   
   select * from oe_order_LINEs_all h where header_id=460850;
   
   
   select * from oe_headers_iface_all where created_by =1014843;
   
   DECLARE
    p_batch_id         fnd_concurrent_requests.request_id%TYPE := fnd_profile.value('CONC_REQUEST_ID');
    BEGIN
   
--   INSERT INTO XXAWR_SO_STAGING(
--	TRANSACTIONAL_CURR_CODE ,PRICING_DATE  ,
--	SOLD_TO_ORG_NAME ,ORDER_TYPE ,ORDERED_QUANTITY , 
--	PRICE_LIST_NAME , SOLD_FROM_ORG_NAME ,SALESREP_NAME , 
--	SHIP_FROM_ORG_NAME ,INVENTORY_ITEM_NAME, 
--	CUSTOMER_NAME, REQUEST_ID )VALUES
--    ('USD',sysdate,'Vision Operations','Mixed',10,
--    'Corporate','Vision Operations','No Sales Credit',
--    'Seattle Manufacturing','destmok_transmission_a',
--    'AT Private Ltd', p_batch_id);
    DBMS_OUTPUT.PUT_LINE('YTT'||P_BATCH_ID);
    END;
COMMIT;    SELECT * FROM ra_salesreps_all;