CREATE OR REPLACE PACKAGE BODY XX_INTG_CURSOR_IF_CONDICTION
AS 

/********************************************************************************

version     who               when                         wjy
1.0         rachit panwar     13-july-23                   to make a 
                                                         package having procedure
                                                        of main for all tables
*********************************************************************************/

 
 /***************************
 main procedure
 *****************************/
 
PROCEDURE  MAIN_CURS(P_VAL IN VARCHAR2)
AS

--cursor for employee table

CURSOR CUR_EMP_DTLS
  IS 
  SELECT * FROM EMPLOYEES ;
  
  REC_EMP_DTL CUR_EMP_DTLS%ROWTYPE;
----------------------------------------------------------------------------------------    

--cursor for department table

CURSOR CUR_DEPT_DTLS
IS
SELECT * FROM DEPARTMENTS;
REC_DEPT_DTL  CUR_DEPT_DTLS%ROWTYPE;
------------------------------------------------------------------------------------------------

--cursor for jobs tabel

CURSOR CUR_JOBS_DTLS
IS 
SELECT * FROM JOBS;
REC_JOBS_DTLS CUR_JOBS_DTLS%ROWTYPE;
--------------------------------------------------------------------------------------------

--cursor for locations

CURSOR CUR_LOCATIONS_DTLS
IS
SELECT * FROM LOCATIONS;
REC_LOCATIONS_DTLS CUR_LOCATIONS_DTLS%ROWTYPE;

-----------------------------------------------------------------

--cursor for regions table 

CURSOR CUR_REGIONS_DTLS
 IS 
 SELECT * FROM REGIONS ;
 REC_REGIONS_DTLS CUR_REGIONS_DTLS%ROWTYPE;
 -----------------------------------------------------------------------------

--cursor for countries

 CURSOR CUR_COUNTRIES_DTLS
 IS 
 SELECT * from countries;
 rec_countries_dtls CUR_COUNTRIES_DTLS%rowtype;
 -------------------------------------------------------------------------------------
 
 --cursor for job_history
 
 
 CURSOR CUR_JOB_HISTORY_DTLS
 IS 
 SELECT * FROM JOB_HISTORY;
 REC_JOB_HISTORY_DTLS CUR_JOB_HISTORY_DTLS%ROWTYPE;
---------------------------------------------------------------------------------


/****************************************
checking all the values and  definging 
cursor according to condiction
****************************************/

BEGIN
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
    END IF;
    CLOSE cur_emp_dtls;
IF P_VAL='DEPARTMENTS' THEN
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
END IF;
IF P_VAL ='JOBS'
THEN
OPEN CUR_JOBS_DTLS;
LOOP
FETCH CUR_JOBS_DTLS INTO REC_JOBS_DTLS;
EXIT WHEN  CUR_JOBS_DTLS%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(RPAD(REC_JOBS_DTLS.JOB_ID,30)||' '||RPAD(REC_JOBS_DTLS.JOB_TITLE,30)||' '||
    RPAD(REC_JOBS_DTLS.MIN_SALARY,30)||' '||RPAD(REC_JOBS_DTLS.MAX_SALARY,30));
    END LOOP;
     END IF;
    IF P_VAL='LOCATIONS'
    THEN
    OPEN CUR_LOCATIONS_DTLS;
    LOOP
    FETCH CUR_LOCATIONS_DTLS INTO REC_LOCATIONS_DTLS;
    EXIT WHEN CUR_LOCATIONS_DTLS %NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(RPAD(REC_LOCATIONS_DTLS.LOCATION_ID,30)||' '||RPAD(REC_LOCATIONS_DTLS.STREET_ADDRESS,30)
    ||' '|| RPAD(REC_LOCATIONS_DTLS.POSTAL_CODE,30)||' '|| RPAD(REC_LOCATIONS_DTLS.CITY,30)||' ' ||
    RPAD(REC_LOCATIONS_DTLS.STATE_PROVINCE,30)||' '||RPAD(REC_LOCATIONS_DTLS.COUNTRY_ID,30));
    END LOOP;
    END IF;
     IF P_VAL='REGIONS'
     THEN
     OPEN CUR_REGIONS_DTLS;
     LOOP
     FETCH CUR_REGIONS_DTLS INTO REC_REGIONS_DTLS;
     EXIT WHEN CUR_REGIONS_DTLS%NOTFOUND;
     DBMS_OUTPUT.PUT_LINE(RPAD(REC_REGIONS_DTLS.REGION_ID,30)||' '||RPAD(REC_REGIONS_DTLS.REGION_NAME,30));
     END LOOP;
     END IF;
     IF P_VAL='JOB_HISTORY'
     THEN
     LOOP
     FETCH CUR_JOB_HISTORY_DTLS INTO REC_JOB_HISTORY_DTLS ;
     EXIT WHEN CUR_JOB_HISTORY_DTLS %NOTFOUND;
     DBMS_OUTPUT.PUT_LINE(RPAD(REC_JOB_HISTORY_DTLS.EMPLOYEE_ID,30)||' '||RPAD(REC_JOB_HISTORY_DTLS.START_DATE,30)||' '||
     RPAD(REC_JOB_HISTORY_DTLS.END_DATE,30)||' '||RPAD(REC_JOB_HISTORY_DTLS.JOB_ID,30)||' '||RPAD(REC_JOB_HISTORY_DTLS.DEPARTMENT_ID,30));
     END LOOP;
     
END IF;
EXCEPTION WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(SQLCODE||SQLERRM);
END MAIN_CURS;
END XX_INTG_CURSOR_IF_CONDICTION;




-----------------------------------CALLING------------------------------------------
BEGIN
XX_INTG_CURSOR_IF_CONDICTION.MAIN_CURS('EMPLOYEES');
END;