CREATE OR REPLACE PROCEDURE XXINTG_EMP_DTLS_RP(ERRBUF OUT Varchar2,
                                            reetcode out varchar2
                                            )
AS
CURSOR PARAMETERISED_CURSOR(P_EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE)
IS 
SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID=P_EMP_ID;
BEGIN
FOR REC_CURSOR IN PARAMETERISED_CURSOR(101)
LOOP
fnd_file.PUT_LINE(fnd_file.log,REC_CURSOR.EMPLOYEE_ID||' '||REC_CURSOR.FIRST_NAME||' '||REC_CURSOR.LAST_NAME||' '|| REC_CURSOR.EMAIL||' '||
REC_CURSOR.PHONE_NUMBER||' '||REC_CURSOR.DEPARTMENT_ID);
fnd_file.PUT_LINE(fnd_file.output,REC_CURSOR.EMPLOYEE_ID||' '||REC_CURSOR.FIRST_NAME||' '||REC_CURSOR.LAST_NAME||' '|| REC_CURSOR.EMAIL||' '||
REC_CURSOR.PHONE_NUMBER||' '||REC_CURSOR.DEPARTMENT_ID);
END LOOP; 
END XXINTG_EMP_DTLS_RP;
