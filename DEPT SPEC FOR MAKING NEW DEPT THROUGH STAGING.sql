create or replace package xxintg_dept_rp_fe
as
 PROCEDURE MAIN_PROCEDURE (
        ERROR_BUFF     OUT VARCHAR2,
        REET_CODE      OUT VARCHAR2,
        P_FILE_NAME    IN  VARCHAR2,
        P_PROCESS_TYPE IN VARCHAR2
    );
    end xxintg_dept_rp_fe;