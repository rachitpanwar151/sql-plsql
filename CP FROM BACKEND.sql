declare
 p_errbuff  VARCHAR2(240);
        p_retcode  VARCHAR2(240);
       
begin
XXAWR_SALES_ORDER_PACKAGE_AWR.main_prg(p_errbuff,p_retcode,'CREATE AND BOOK');
end;


select flow_status_code from oe_order_headers_all WHERE HEADER_ID=469768;