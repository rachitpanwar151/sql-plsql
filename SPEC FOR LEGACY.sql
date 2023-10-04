CREATE OR REPLACE PACKAGE xxintg_legacy_po_creation_rp AS
    PROCEDURE main_procedure (
    errbuff        OUT VARCHAR2,
    reetcode       OUT VARCHAR2,
    data_file_name IN VARCHAR2,
    SOURCE IN VARCHAR2
);
END xxintg_legacy_po_creation_rp;

SELECT
    *
FROM
    xxintg_legacy_main_staging_rp;