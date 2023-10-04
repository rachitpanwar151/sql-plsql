create or replace package xxintg_requisition_pkg_rp 
as

procedure main_proce(errbuff out varchar2 , retcode out varchar2
, P_PROCESS_TYPE VARCHAR2, P_FILE_NAME VARCHAR2);
end  xxintg_requisition_pkg_rp;