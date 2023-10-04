CREATE OR REPLACE PACKAGE BODY XXINTG_CURSOR
AS
PROCEDURE PRINT_PARAMETERS()
AS
BEGIN
DBMS_OUTPUT.PUT_LINE(RPAD(' ',30)||' '||RPAD(' ' ,30)||' '||RPAD(' ',30)||' '||RPAD(' ' ,30)
||' '||RPAD(' ',30)||' '||RPAD(' ' ,30)||' '||RPAD(' ',30)||' '||RPAD(' ' ,30)||' '||
RPAD(' ',30)||' '||RPAD(' ' ,30)||' '||RPAD(' ',30)||' '||RPAD(' ' ,30)
||' '||RPAD(' ',30)||' '||RPAD(' ' ,30)||' '||RPAD(' ',30)||' '||RPAD(' ' ,30));
END PRINT_PARAMETERS;

END XXINTG_CURSOR;