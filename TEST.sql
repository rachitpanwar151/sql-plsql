begin


INSERT INTO XXAWR_SO_HEADERS_STG(  TRANSACTIONAL_CURR_CODE,pricing_date,
    customer_name,order_type_name,
    price_list_name,sold_from_org_name,
    salesrep_name,sf_order_id,OIC_INSTANCE_ID,cancel_reason,
    CANCEL_FLAG,STATUS
) VALUES (
    'USD',sysdate,to_char('Big 4 Rental'),
    'mixed','Corporate',
   'Vision Operations','No Sales Credit','138A',4,
   '','','N'
   
--    'Administrative reason','Y','N'

);



INSERT INTO XXAWR_SO_LINES_STG (
    ordered_quantity,ship_from_org_name,item_code
    ,OIC_INSTANCE_ID,
   SF_LINE_ID,STATUS,stg_header_id) VALUES (
    10,'Seattle Manufacturing','destmok_transmission_a',
    4,1, 'N',1);




INSERT INTO XXAWR_SO_DEL_INSTR_STG(STG_DEL_INSTR_ID,STG_DEL_INSTR_STATUS,
quantity_to_be_delivered,schedule_ship_date,oic_instance_id,STATUS,STG_LINE_ID,STG_HEADER_ID)values(
'12a','book',5,'25-Jan-24',4,'N',1,1);


INSERT INTO XXAWR_SO_DEL_INSTR_STG(STG_DEL_INSTR_ID,STG_DEL_INSTR_STATUS,
quantity_to_be_delivered,schedule_ship_date,oic_instance_id,STATUS,STG_LINE_ID,STG_HEADER_ID)values(
'12Aa','book',5,'25-june-2024',4,'N',1,1);

end;
/
COMMIT;