create or replace package x
as
procedure find(p_name in varchar2, p_id out  number);
end x;


---------------------------------------------------------

create or replace package BODY x
as
procedure find(p_name in varchar2, p_id out  number)
AS
BEGIN
SELECT DEPARTMENT_ID INTO P_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME=P_NAME;
DBMS_OUTPUT.PUT_LINE(P_ID);
INSERT INTO RPP VALUES
(P_ID,P_NAME);
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('ERROR OCCURED'||SQLCODE||'-'||SQLERRM);
END FIND;
END X;
---------------------------END----------------------------------------

DECLARE
P_ID NUMBER;
P_NAME VARCHAR2(300);
BEGIN
X.FIND('Administration',P_ID);
DBMS_OUTPUT.PUT_LINE(P_ID);
END;


CREATE TABLE RPP
AS
SELECT DEPARTMENT_ID ,DEPARTMENT_NAME FROM DEPARTMENTS WHERE 1=2;
ROLLBACK;

TRUNCATE TABLE
RPP;
SELECT * FROM RPP;
