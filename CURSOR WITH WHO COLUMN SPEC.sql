CREATE OR REPLACE PACKAGE XXINTG_CURSOR 
AS
PROCEDURE  XXINTG_MAIN(P_PROCESS_TYPE VARCHAR2, P_BATCH_ID VARCHAR2);
END XXINTG_CURSOR;