CREATE OR REPLACE PACKAGE xxintg_requisition_pkg_rp AS
    PROCEDURE main_proce (
        errbuff OUT VARCHAR2,
        retcode OUT VARCHAR2
    );

END xxintg_requisition_pkg_rp;