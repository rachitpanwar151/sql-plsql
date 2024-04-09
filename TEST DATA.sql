 BEGIN
INSERT INTO XXAWR_STAGING_HEADER_SO (
    TRANSACTIONAL_CURR_CODE,pricing_date,
    customer_name,order_type_name,
    price_list_name,sold_from_org_name,
    salesrep_name,sf_order_id,OIC_INSTANCE_ID,cancel_reason,
    cancel_flag,STATUS
) VALUES (
    'USD',sysdate,to_char('Big 4 Rental'),
    'mixed','Corporate',
    'Vision Operations','No Sales Credit','272','302',
   '','','N'
   
--    'Administrative reason','Y','N'

);


INSERT INTO XXAWR_STAGING_LINE_SO (
    ordered_quantity,ship_from_org_name,item_name,
    sf_order_id,uom_code,OIC_INSTANCE_ID,line_cancel_flag,
    stg_del_instr_id,STG_DEL_INSTR_STATUS,LINE_CANCEL_REASON,SF_LINE_ID,STATUS) VALUES (
    10,'Seattle Manufacturing','destmok_transmission_a',
    '272','Ea','302','','12A',
--    'CANCEL LINE','Administrative reason'
--    'BOOK',''
--'DRAFT',''
'RESERVE',''
,1, 'N');

    END;
/

commit;