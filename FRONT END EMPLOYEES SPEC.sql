CREATE OR REPLACE PACKAGE  xxintg_validation_rp_FE
AS    PROCEDURE main_procedure (
     errbuff out varchar2, 
     reEtcode out varchar2,
        P_FILE_NAME     IN NUMBER,
        p_process_type IN VARCHAR2
    ) ;
    END  xxintg_validation_rp_FE;