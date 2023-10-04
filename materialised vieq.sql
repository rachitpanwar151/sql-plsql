create or replace package body xxintg_cp_materialized_view
as
procedure mv_refresh
as
begin

DBMS_MVIEW.REFRESH('RP_mATERIALIZED_VIEW',method=>'C');

end mv_refresh;
procedure main_procedure(errbuff out varchar2, reetcode out varchar2)
as

begin
mv_refresh;
end main_procedure;
end xxintg_cp_materialized_view;


select * from RP_mATERIALIZED_VIEW;





SELECT
    *
FROM
    user_mviews
WHERE
    mview_name = upper('rp_mATERIALIZED_VIEW');




CREATE MATERIALIZED VIEW RP_MATERIALIZED_VIEW
    REFRESH
            COMPLETE
            ON DEMAND
AS
    SELECT
        *
    FROM
        po.po_headers_all;

BEGIN
    dbms_mview.refresh('PO_INFO_mv_rp', atomic_refresh => TRUE);
END;