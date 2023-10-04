CREATE OR REPLACE PACKAGE xxintg_po_rp AS
    PROCEDURE main_procedure (
        errbuff        OUT VARCHAR2,
        retcode        OUT VARCHAR2,
        p_process_type VARCHAR2,
        P_file_name VARCHAR2
    );

END xxintg_po_rp;