DECLARE 
A VARCHAR2(32768);
BEGIN
A:='RACHIT';
DBMS_OUTPUT.PUT_LINE(A);
END;

DECLARE 
A VARCHAR2(32767);
BEGIN
A:='RACHIT';
DBMS_OUTPUT.PUT_LINE(A);
END;

DECLARE 
A VARCHAR2(0);
BEGIN
A:='RACHIT';
DBMS_OUTPUT.PUT_LINE(A);
END;

DECLARE 
A VARCHAR2(-1);
BEGIN
A:='RACHIT';
DBMS_OUTPUT.PUT_LINE(A);
END;