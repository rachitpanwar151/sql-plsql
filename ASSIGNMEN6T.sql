

**********************PACKAGE SPEC***************************

CREATE OR REPLACE PACKAGE xx_intg_agnmnt AS
    PROCEDURE get_dtl (
        ln_deptid   IN NUMBER,
        ln_deptname out VARCHAR2
    );

    FUNCTION get_dtls (
        ln_deptid   NUMBER
        ) RETURN VARCHAR2;

END xx_intg_agnmnt;

/*******************PACKAGE BODY**************************/

CREATE OR REPLACE PACKAGE BODY xx_intg_agnmnt AS
    PROCEDURE get_dtl (
        ln_deptid   IN NUMBER,
        ln_deptname out VARCHAR2
    )
    AS
     BEGIN
     SELECT DEPARTMENT_name INTO LN_Deptname FROM DEPARTMENTS where department_id=ln_deptid;
    
     EXCEPTION WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE(' INVALID DEPARTMENT_ID'||SQLCODE||'-'||SQLERRM);
     END get_dtl;
     
    FUNCTION get_dtls (
        ln _deptid   NUMBER
    ) RETURN VARCHAR2
    AS
    LN_DEPTNAME varchar2(40);
    BEGIN
     SELECT DEPARTMENT_NAME INTO LN_DEPTNAME FROM DEPARTMENTS WHERE DEPARTMENT_ID=LN_DEPTID;
          return LN_DEPTNAME;
     EXCEPTION WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE(' INVALID DEPARTMENT_ID'||SQLCODE||'-'||SQLERRM);
return null;
     END get_dtls;
     end xx_intg_agnmnt;
     
     
-------------------------packages calling-------------------------------

select xx_intg_agnmnt.get_dtls(10) from dual;

declare
a number:=10;
c varchar2(30);
begin
xx_intg_agnmnt.get_dtl(a,c);
dbms_output.put_line(c);
end;



--------------------------------------------------------ASSIGNMENT2-----------------------------------------------------------------

CREATE OR REPLACE PROCEDURE XX_INTG_GET_DTL(P_ID IN NUMBER, P_TYPE IN VARCHAR2,P_STORE OUT VARCHAR2)
AS
LC_STR VARCHAR2(30);
BEGIN
BEGIN
IF P_TYPE='DEPT_NAME' THEN
SELECT DEPARTMENT_ID INTO LC_STR  FROM DEPARTMENTS WHERE DEPARTMENT_ID=P_ID;
P_STORE:=LC_STR;
ELSIF P_TYPE='EMP_NAME'
THEN
SELECT FIRST_NAME INTO LC_STR FROM EMPLOYEES WHERE EMPLOYEE_ID=P_ID;
P_STORE:=LC_STR;
END IF;
EXCEPTION
WHEN OTHERS THEN 
DBMS_OUTPUT.PUT_LINE('ERROR'||SQLCODE||' '||SQLERRM);
END;
END XX_INTG_GET_DTL;



DECLARE
A NUMBER:=101;
B VARCHAR2(30):='EMP_NAME';
C VARCHAR2(40);
BEGIN
XX_INTG_GET_DTL(A,B,C);
DBMS_OUTPUT.PUT_LINE(C);
END;
---------------------------------------------FUNCTION -------------------------------------
CREATE OR REPLACE FUNCTION XX_INTG_DTL( P_ID NUMBER,P_TYPE VARCHAR2)RETURN VARCHAR2
AS
LC_STORE VARCHAR2(300);
BEGIN
BEGIN
IF(P_TYPE='EMP_NAME') THEN
SELECT FIRST_NAME INTO LC_STORE  FROM EMPLOYEES WHERE EMPLOYEE_ID=P_ID;
RETURN LC_STORE;
ELSIF P_TYPE='DEPT_NAME' THEN
SELECT DEPARTMENT_NAME INTO LC_STORE  FROM DEPARTMENTS WHERE DEPARTMENT_ID=P_ID;
RETURN LC_STORE;
END IF;
EXCEPTION
WHEN OTHERS THEN 
DBMS_OUTPUT.PUT_LINE('ERROR'||SQLCODE||' '||SQLERRM);
END;
END XX_INTG_DTL;

SELECT XX_INTG_DTL(10,'DEPT_NAME') FROM DUAL;
**************************************************************************************************************************************



CREATE OR REPLACE PACKAGE RP
AS
PROCEDURE EMPP_DETAILS( P_ID NUMBER, P_TYPE VARCHAR ,P_STORE OUT VARCHAR);
FUNCTION EMP_DETAILS( P_ID NUMBER,P_TYPE VARCHAR) RETURN VARCHAR;
END;

CREATE OR REPLACE PACKAGE BODY RP
AS
PROCEDURE EMPP_DETAILS( P_ID  NUMBER, P_TYPE  VARCHAR ,P_STORE OUT VARCHAR)
AS
LC_STTR VARCHAR2(30);
BEGIN
IF P_TYPE='EMPLOYEE_NAME'  
THEN
SELECT FIRST_NAME INTO LC_STTR FROM EMPLOYEES WHERE EMPLOYEE_ID=P_ID;
P_STORE:=LC_STTR;
ELSIF P_TYPE='DEPARTMENT_NAME' 
THEN 
SELECT DEPARTMENT_NAME INTO LC_STTR FROM DEPARTMENTS WHERE DEPARTMENT_ID=P_ID;
P_STORE:=LC_STTR;
END IF;
EXCEPTION WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(SQLCODE||SQLERRM);
END EMPP_DETAILS;


FUNCTION EMP_DETAILS( P_ID NUMBER,P_TYPE VARCHAR) RETURN VARCHAR
AS
LC_STTR VARCHAR2(40);
BEGIN
IF P_TYPE ='EMP_NAME' THEN
SELECT FIRST_NAME INTO LC_STTR  FROM EMPLOYEES WHERE EMPLOYEE_ID = P_ID;
RETURN LC_STTR;
ELSIF P_TYPE ='DEPT_NAME' THEN
SELECT DEPARTMENT_NAME INTO LC_STTR FROM
    departments
    wHERE
        department_id = p_id;
        RETURN lc_sttr;
    end  if;
        end;
    end;
    
    
    select rp.EMP_DETAILS(101,'department_name') from dual;
*******************************************************************************************************************************

create or replace package sal
as
function S_sal( P_EMPID number) return number;
end;

create or replace package  body sal
as
function S_sal( P_EMPID number) return number
AS
LN_SAL NUMBER;
begin
select salary into LN_sal from employees where employee_id=P_empid;
RETURN LN_SAL;
exception
when others then
dbms_output.put_line('error'||sqlcode||' '||sqlerrm);
end;
end;

SELECT SAL.S_SAL(101) FROM DUAL;

*********************************************************************************************************************************

 DESC EMPLOYEES;
 SELECT * FROM DEPARTMENTS;  
 *******************************************************************************************************************************