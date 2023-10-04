create or replace package xxintg_dept_rp
as
procedure main_procedure(errbuff out varchar2, reetcode out varchar2,p_department_id varchar2);
end xxintg_dept_rp;