CREATE OR REPLACE PACKAGE BODY XX_INTG_CURSOR_IF_CONDICTION
AS 
 
/********************************************************************************

version     who               when                         wjy
1.0         rachit panwar     13-july-23                   to make a 
                                                         package having procedure
                                                        of main_xurs and checking if confiction
*********************************************************************************/


/***********************************************
main procedure
************************************************/

PROCEDURE  MAIN_CURS(P_VAL IN VARCHAR2)
AS


--cursor for employee table 
CURSOR CUR_EMP_DTLS
  IS 
  SELECT * FROM EMPLOYEES ;  
  REC_EMP_DTL CUR_EMP_DTLS%ROWTYPE;
    
    
    --cursor for departments table 
    
CURSOR CUR_DEPT_DTLS
IS
SELECT * FROM DEPARTMENTS;
REC_DEPT_DTL  CUR_DEPT_DTLS%ROWTYPE;

BEGIN

-----------------checking condiction------------


IF P_VAL='EMPLOYEES' THEN 
    OPEN cur_emp_dtls;
    LOOP
        FETCH cur_emp_dtls INTO rec_emp_dtl;
        EXIT WHEN cur_emp_dtls%notfound;
        dbms_output.put_line(RPAD(rec_emp_dtl.employee_id,30)
                             || ' '
                             || RPAD(rec_emp_dtl.first_name,30)
                             || ' '
                             || RPAD(rec_emp_dtl.department_id,30)||' '||
                             RPAD(rec_emp_dtl.EMAIL,30)||' '||
                             RPAD(rec_emp_dtl.PHONE_NUMBER,30)||' '||
                             RPAD(rec_emp_dtl.HIRE_DATE,30)||' '||
                             RPAD(rec_emp_dtl.JOB_ID,30)||' '||
                             RPAD(rec_emp_dtl.SALARY,30)||' '||
                             RPAD(rec_emp_dtl.COMMISSION_PCT,30)||' '||
                             RPAD(rec_emp_dtl.MANAGER_ID,30)||' '||
                             RPAD(rec_emp_dtl.DEPARTMENT_ID,30));

    END LOOP; 
    CLOSE cur_emp_dtls;
ELSIF P_VAL='DEPARTMENTS' THEN
    OPEN cur_dept_dtls;
    LOOP
        FETCH cur_dept_dtls INTO rec_dept_dtl;
        EXIT WHEN cur_dept_dtls%notfound;
        dbms_output.put_line(RPAD(rec_dept_dtl.department_id,30)
                             || ' '
                             || RPAD(rec_dept_dtl.department_name,30)
                             || ' '||RPAD(rec_dept_dtl.MANAGER_ID,30)||' '
                             || RPAD(rec_dept_dtl.location_id,30));

    END LOOP;
    CLOSE cur_dept_dtls;
END IF;
EXCEPTION WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(SQLCODE||SQLERRM);
END MAIN_CURS;
END XX_INTG_CURSOR_IF_CONDICTION;


------------------------CALLING-------------------

BEGIN
XX_INTG_CURSOR_IF_CONDICTION.MAIN_CURS('EMPLOYEES');
END;