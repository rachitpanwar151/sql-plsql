create or replace package body  xxintg_interface
as
GN_RECORD_ID NUMBER;

/********************************************
MAIN PROCEDURE FOR CALLING 
********************************************/

procedure mainn( p_interfaceid in number)
as
ln_count number;
LC_STATUS  VARCHAR2(30);
LC_ERROR  VARCHAR2(7000);
begin
LC_STATUS:='V';
DBMS_OUTPUT.PUT_LINE('BEGINING OF MAIN');
/*********************************
parameter printing
**********************************/

dbms_output.put_line(rpad('p_interfaceid',30)||p_interfaceid);


DBMS_OUTPUT.PUT_LINE('PARAMETER PRINTING');
/******************************************
checking if batch id exist in table or not
*******************************************/



DBMS_OUTPUT.PUT_LINE('CHECKING IF BATCH ID REALLY EXIST OR NOT');

select count(*) into ln_count from  xxintg_staging where batch_id=p_interfaceid;
if ln_count=1
then
LC_STATUS:='E';
LC_ERROR:= 'batch id already exist';
DBMS_OUTPUT.PUT_LINE(LC_ERROR);
ELSE

DBMS_OUTPUT.PUT_LINE('INSERTING VALUES IN TABLE');
 GN_RECORD_ID:=record_id_SEQ.NEXTVAL;
LC_STATUS:='N';
INSERT INTO XXINTG_STAGING VALUES(GN_RECORD_ID,
101,
'RACHIT' ,
'PANWAR',
'RP@INTELLOGER.COM', 
7456007594,
'31-JAN-2023' , 
'IT_PROG',
'APP SPECALIST',
2000000,
0.2,
101 ,
80 ,
'ORACLE ENTERPRIXE',
1);
DBMS_OUTPUT.PUT_LINE('INSERT SUCCESSFUL');
end IF;
end mainn;
end xxintg_interface;


-------------------------------
BEGIN
xxintg_interface.MAINN(2);
END;

SELECT * FROM XXINTG_STAGING;