DECLARE
p_errbuff VARCHAR2(240);
p_retcode VARCHAR2(240);
BEGIN
XXAWR_SALES_ORDER_PACKAGE_INTG.MAIN_PROCEDURE(p_errbuff,p_retcode, 'CANCEL');
END;



SELECT * FROM OE_ORDER_HEADERS_ALL WHERE HEADER_ID=481033;

SELECT FLOW_STATUS_CODE  FROM OE_ORDER_HEADERS_ALL WHERE HEADER_ID=481033;

SELECT * FROM OE_ORDER_LINES_ALL WHERE HEADER_ID=481781;

SELECT FLOW_STATUS_CODE  FROM OE_ORDER_LINES_ALL WHERE HEADER_ID=481033;
