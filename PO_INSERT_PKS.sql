CREATE OR REPLACE PACKAGE xxintg_po_insert_validate_rp AS
    PROCEDURE main_procedure (
        errbuff        OUT VARCHAR2,
        retcode        OUT VARCHAR2,
        p_process_type VARCHAR2,
        data_file_name VARCHAR2
    );

END xxintg_po_insert_validate_rp;