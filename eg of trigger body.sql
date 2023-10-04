create or replace package body before_after_trigger
as
 function before_report
 return boolean
 As
-- cursor cur_stag 
-- is
--SELECT
--    org_id FROM
--    po_headers_all
--WHERE
--    segment1 = p_segment1;
 begin
-- 
-- for i in cur_stag
-- loop
-- insert into staG_report(org_ID)
-- values(i.org_id);
-- 
-- commit;
-- end loop;
 return true;
     exception
        when others then
        return false;
 end before_report;
 
-- function after_report return boolean
-- is 
----after report logic 
-- cursor cur_stag_AFTER 
-- is
--SELECT
--    PO_header_id FROM
--    po_headers_all
--WHERE
--    segment1 = p_segment1;
-- begin
-- 
-- for i in cur_stag_AFTER
-- loop
-- insert into staG_report(header_id)
--VALUES (i.PO_header_id); 
-- end loop;
-- commit;
-- return true;
--    exception
--        when others then
--        return false;
-- 
-- 
-- end after_report ;
 end before_after_trigger;
 
 --------------------------------------------------------------------
 
create TABLE staG_report
(
org_ID number
,header_id  VARCHAR2(200)
);

select * from staG_report; 

XXINTG_REPORT_WITH_TRIGGER



 select to_char(sysdate,'dd-mm-rr hh:mm:ss pm') from dual;
 
 select * from v$nls_parameters;
 
 
 select * from per_all_people_f
 ;
 
 select * from per_people_f where person_id=25;
 
 select * from fnd_user where employee_id=25;
 
 select * from wf_roles where lower(name)='operations';
 