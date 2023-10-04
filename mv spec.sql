create or replace package xxintg_cp_materialized_view
as
procedure main_procedure(errbuff out varchar2, reetcode out varchar2);
end xxintg_cp_materialized_view;