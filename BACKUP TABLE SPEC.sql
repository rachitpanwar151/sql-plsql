CREATE OR REPLACE PACKAGE EMPLOYEE_BACKUP_INSERTION
AS
PROCEDURE MAIN_BACKUP;
END  EMPLOYEE_BACKUP_INSERTION;

CREATE TABLE EMPLOYEE_BACKUP
AS
SELECT * FROM EMPLOYEES WHERE 1=2;