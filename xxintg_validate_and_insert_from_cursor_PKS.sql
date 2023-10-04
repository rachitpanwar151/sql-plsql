CREATE OR REPLACE PACKAGE XXINTG_VALIDATE_AND_INSERT
AS

    PROCEDURE main_procedure (
        p_batch_id     NUMBER,
        p_process_type VARCHAR2
    ) ;
    END  XXINTG_VALIDATE_AND_INSERT;
    
    
    
    select  record_id.NEXTVAL from dual;