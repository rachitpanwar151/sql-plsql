create or replace  package  body  xxintg_different_tables
as
----------------------------------------------------------------------------------------    

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
procedure to print table columns
****************************************/
procedure tablee (P_TABLE VARCHAR2,P_TYPE VARCHAR2)
as

--cursor for employee table

CURSOR CUR_EMP_DTLS
  IS 
  SELECT * FROM EMPLOYEES ;
  
  REC_EMP_DTL CUR_EMP_DTLS%ROWTYPE;

BEGIN
IF P_TABLE='EMPLOYEES' AND P_TYPE='COLUMNS'  THEN 
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
 end
elsif P_TABLE='departments' AND P_TYPE='columns'  THEN
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
 

elsIF P_table ='JOBS ' and p_type ='columns'
THEN
OPEN CUR_JOBS_DTLS;
LOOP
FETCH CUR_JOBS_DTLS INTO REC_JOBS_DTLS;
EXIT WHEN  CUR_JOBS_DTLS%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(RPAD(REC_JOBS_DTLS.JOB_ID,30)||
    ' '||RPAD(REC_JOBS_DTLS.JOB_TITLE,30)||' '||
    RPAD(REC_JOBS_DTLS.MIN_SALARY,30)||' '||RPAD(REC_JOBS_DTLS.MAX_SALARY,30));
    END LOOP; 
 
 
 elsIF P_type='LOCATIONS' and p_type='columns'
    THEN
    OPEN CUR_LOCATIONS_DTLS;
    LOOP
    FETCH CUR_LOCATIONS_DTLS INTO REC_LOCATIONS_DTLS;
    EXIT WHEN CUR_LOCATIONS_DTLS %NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(RPAD(REC_LOCATIONS_DTLS.LOCATION_ID,30)||' '||RPAD(REC_LOCATIONS_DTLS.STREET_ADDRESS,30)
    ||' '|| RPAD(REC_LOCATIONS_DTLS.POSTAL_CODE,30)||' '|| RPAD(REC_LOCATIONS_DTLS.CITY,30)||' ' ||
    RPAD(REC_LOCATIONS_DTLS.STATE_PROVINCE,30)||' '||RPAD(REC_LOCATIONS_DTLS.COUNTRY_ID,30));
    END LOOP;
 elsIF P_type='LOCATIONS' and p_type='columns'
    THEN
    OPEN CUR_LOCATIONS_DTLS;
    LOOP
    FETCH CUR_LOCATIONS_DTLS INTO REC_LOCATIONS_DTLS;
    EXIT WHEN CUR_LOCATIONS_DTLS %NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(RPAD(REC_LOCATIONS_DTLS.LOCATION_ID,30)||' '||RPAD(REC_LOCATIONS_DTLS.STREET_ADDRESS,30)
    ||' '|| RPAD(REC_LOCATIONS_DTLS.POSTAL_CODE,30)||' '|| RPAD(REC_LOCATIONS_DTLS.CITY,30)||' ' ||
    RPAD(REC_LOCATIONS_DTLS.STATE_PROVINCE,30)||' '||RPAD(REC_LOCATIONS_DTLS.COUNTRY_ID,30));
    END LOOP;
 elsIF P_table='REGIONS' and p_type='columns'
     THEN
     OPEN CUR_REGIONS_DTLS;
     LOOP
     FETCH CUR_REGIONS_DTLS INTO REC_REGIONS_DTLS;
     EXIT WHEN CUR_REGIONS_DTLS%NOTFOUND;
     DBMS_OUTPUT.PUT_LINE(RPAD(REC_REGIONS_DTLS.REGION_ID,30)
     ||' '||RPAD(REC_REGIONS_DTLS.REGION_NAME,30));
     END LOOP;
  elsIF P_table='JOB_HISTORY' and P_type='columns'
     THEN
     LOOP
     FETCH CUR_JOB_HISTORY_DTLS INTO REC_JOB_HISTORY_DTLS ;
     EXIT WHEN CUR_JOB_HISTORY_DTLS %NOTFOUND;
     DBMS_OUTPUT.PUT_LINE(RPAD(REC_JOB_HISTORY_DTLS.EMPLOYEE_ID,30)||' '||RPAD(REC_JOB_HISTORY_DTLS.START_DATE,30)||' '||
     RPAD(REC_JOB_HISTORY_DTLS.END_DATE,30)||' '||RPAD(REC_JOB_HISTORY_DTLS.JOB_ID,30)||' '||RPAD(REC_JOB_HISTORY_DTLS.DEPARTMENT_ID,30));
end loop;
  end if;
  end tablee;
  
  
  /**********************************************
  procedure to print constraints of table
  ***********************************************/
  
  procedure constraintss(P_TABLE VARCHAR2,P_TYPE VARCHAR2)
  as
  begin
    IF P_TABLE='EMPLOYEES' AND P_TYPE='CONSTRAINTS'  THEN 
    OPEN cur_emp_dtls;
    LOOP
        FETCH cur_emp_dtls INTO rec_emp_dtl;
        EXIT WHEN cur_emp_dtls%notfound;
        dbms_output.put_line(RPAD('department_id',30)||' '||'EMP_DEPT_FK');
        dbms_output.put_line(RPAD('EMAIL',30)||' '||'EMP_LAST_NAME_NN');
        dbms_output.put_line(RPAD('EMAIL',30)||' '||'EMP_EMP_ID_PK');
        dbms_output.put_line(RPAD('EMAIL',30)||' '||'EMP_EMAIL_UK');
        dbms_output.put_line(RPAD('EMAIL',30)||' '||'EMP_EMAIL_NN');
        dbms_output.put_line(RPAD('HIRE_DATE',30)||' '||'EMP_HIRE_DATE_NN');
        dbms_output.put_line(RPAD('JOB_ID',30)||' '||'EMP_JOB_FK');
        dbms_output.put_line(RPAD('job_id',30)||' '||'EMP_JOB_NN');
        dbms_output.put_line(RPAD('salary',30)||' '||'EMP_SALARY_MIN');
        dbms_output.put_line(RPAD('MANAGER_ID',30)||' '||'EMP_MANAGER_FK');
                           
END LOOP;
elsif P_TABLE='departments' AND P_TYPE='constraints'  THEN
    OPEN cur_dept_dtls;
    LOOP
        FETCH cur_dept_dtls INTO rec_dept_dtl;
        EXIT WHEN cur_dept_dtls%notfound;
        
        dbms_output.put_line(RPAD('department_id',30)||'DEPT_ID_PK');
        dbms_output.put_line(RPAD('department_name',30)||'DEPT_NAME_NN');
        dbms_output.put_line(RPAD('MANAGER_ID',30)||' DEPT_MGR_FK');
        dbms_output.put_line(RPAD('location_id',30)||'DEPT_LOC_FK');
END LOOP;
elsIF P_table ='JOBS ' and p_type ='constraints'
THEN
OPEN CUR_JOBS_DTLS;
LOOP
FETCH CUR_JOBS_DTLS INTO REC_JOBS_DTLS;
EXIT WHEN  CUR_JOBS_DTLS%NOTFOUND;
    
    DBMS_OUTPUT.PUT_LINE(RPAD('JOB_ID',30)||' JOB_ID_PK');
    DBMS_OUTPUT.PUT_LINE(RPAD('JOB_TITLE',30)||'JOB_TITLE_NN ');
    end loop;
elsiF P_type='LOCATIONS' and p_type='constraints'
    THEN
    OPEN CUR_LOCATIONS_DTLS;
    LOOP
    FETCH CUR_LOCATIONS_DTLS INTO REC_LOCATIONS_DTLS;
    EXIT WHEN CUR_LOCATIONS_DTLS %NOTFOUND;
    
    DBMS_OUTPUT.PUT_LINE(RPAD('LOCATION_ID',30)||' LOC_ID_PK');
    DBMS_OUTPUT.PUT_LINE(RPAD('CITY',30)||'LOC_ID_PK ');
    DBMS_OUTPUT.PUT_LINE(RPAD('LOCATION_ID',30)||'LOC_C_ID_FK');
    END LOOP;
elsIF P_table='REGIONS' and p_type='constraints'
     THEN
     OPEN CUR_REGIONS_DTLS;
     LOOP
     FETCH CUR_REGIONS_DTLS INTO REC_REGIONS_DTLS;
     EXIT WHEN CUR_REGIONS_DTLS%NOTFOUND;
     DBMS_OUTPUT.PUT_LINE(RPAD('REGION_ID',30)||'REGION_ID_NN ');
     DBMS_OUTPUT.PUT_LINE(RPAD('REGION_ID',30)||' REG_ID_PK');
     END LOOP;
elsIF P_table='JOB_HISTORY' and P_type='constraints'
     THEN
     LOOP
     FETCH CUR_JOB_HISTORY_DTLS INTO REC_JOB_HISTORY_DTLS ;
     EXIT WHEN CUR_JOB_HISTORY_DTLS %NOTFOUND;
     DBMS_OUTPUT.PUT_LINE(RPAD('EMPLOYEE_ID',30)||'JHIST_EMP_FK ');
     DBMS_OUTPUT.PUT_LINE(RPAD('START_DATE',30)||' JHIST_START_DATE_NN');
     DBMS_OUTPUT.PUT_LINE(RPAD('END_DATE',30)||' JHIST_END_DATE_NN');
     DBMS_OUTPUT.PUT_LINE(RPAD('JOB_ID',30)||'JHIST_JOB_FK ');
     DBMS_OUTPUT.PUT_LINE(RPAD('DEPARTMENT_ID',30)||'JHIST_DEPT_FK');
     DBMS_OUTPUT.PUT_LINE(RPAD('EMPLOYEE_ID',30)||'JHIST_DEPT_FK ');
     DBMS_OUTPUT.PUT_LINE(RPAD('employee_id',30)||'JHIST_EMP_ID_ST_DATE_PK ');
     DBMS_OUTPUT.PUT_LINE(RPAD('END_DATE',30)||'JHIST_DATE_INTERVAL ');
     DBMS_OUTPUT.PUT_LINE(RPAD('JOB_ID',30)||' JHIST_JOB_NN');
     END LOOP;
end if;
end constraintss;


/**************************************

procedure to pritn index of tables

*****************************************/


procedure indexx(P_TABLE VARCHAR2,P_TYPE VARCHAR2)
as
begin

    IF P_TABLE='EMPLOYEES' AND P_TYPE='INDEXES'  THEN 
    OPEN cur_emp_dtls;
    LOOP
        FETCH cur_emp_dtls INTO rec_emp_dtl;
        EXIT WHEN cur_emp_dtls%notfound;
        dbms_output.put_line(RPAD('EMAIL',30)||' '||'EMP_EMAIL_UK');
        dbms_output.put_line(RPAD('EMPLOYEE_ID',30)||' '||'EMP_EMP_ID_PK');
        dbms_output.put_line(RPAD('DEPARTMENT_ID',30)||' '||'EMP_DEPARTMENT_IX');
        dbms_output.put_line(RPAD('FIRST_NAME||LAST_NAME',30)||' '||'EMP_NAME_IX');
        dbms_output.put_line(RPAD('JOB_ID',30)||' '||'EMP_JOB_IX');
        dbms_output.put_line(RPAD('MANAGER_ID',30)||' '||'EMP_MANAGER_IX');
                           
END LOOP;
elsif P_TABLE='departments' AND P_TYPE='INDEXES'  THEN
    OPEN cur_dept_dtls;
    LOOP
        FETCH cur_dept_dtls INTO rec_dept_dtl;
        EXIT WHEN cur_dept_dtls%notfound;
        dbms_output.put_line(RPAD('department_id',30)||'DEPT_ID_PK');
        dbms_output.put_line(RPAD('location_id',30)||'DEPT_LOCATION_IX');
END LOOP;
elsIF P_table ='JOBS ' and p_type ='INDEXES'
THEN
OPEN CUR_JOBS_DTLS;
LOOP
FETCH CUR_JOBS_DTLS INTO REC_JOBS_DTLS;
EXIT WHEN  CUR_JOBS_DTLS%NOTFOUND;
    
    DBMS_OUTPUT.PUT_LINE(RPAD('JOB_ID',30)||' JOB_ID_PK');    end loop;
elsiF P_type='LOCATIONS' and p_type='INDEXES'
    THEN
    OPEN CUR_LOCATIONS_DTLS;
    LOOP
    FETCH CUR_LOCATIONS_DTLS INTO REC_LOCATIONS_DTLS;
    EXIT WHEN CUR_LOCATIONS_DTLS %NOTFOUND;
      
    DBMS_OUTPUT.PUT_LINE(RPAD('LOCATION_ID',30)||' LOC_ID_PK');
    DBMS_OUTPUT.PUT_LINE(RPAD('CITY',30)||'LOC_ID_IX ');
    DBMS_OUTPUT.PUT_LINE(RPAD('STATE_PROVIENCE',30)||'LOC_STATE_PROVINCE_IX');
    DBMS_OUTPUT.PUT_LINE(RPAD('COUNTRY_ID',30)||'LOC_COUNTRY_IX');
   
    END LOOP;
elsIF P_table='REGIONS' and p_type='INDEXES'
     THEN
     OPEN CUR_REGIONS_DTLS;
     LOOP
     FETCH CUR_REGIONS_DTLS INTO REC_REGIONS_DTLS;
     EXIT WHEN CUR_REGIONS_DTLS%NOTFOUND;
    
     DBMS_OUTPUT.PUT_LINE(RPAD('REGION_ID',30)||'REGION_ID_PK ');
     END LOOP;
elsIF P_table='JOB_HISTORY' and P_type='INDEXES'
     THEN
     LOOP
     FETCH CUR_JOB_HISTORY_DTLS INTO REC_JOB_HISTORY_DTLS ;
     EXIT WHEN CUR_JOB_HISTORY_DTLS %NOTFOUND;
    
     DBMS_OUTPUT.PUT_LINE(RPAD('EMPLOYEE_ID',30)||'JHIST_EMP_ID_ST_DATE_PK ');
     DBMS_OUTPUT.PUT_LINE(RPAD('EMPLOYEE_ID',30)||'JHIST_EMPLOYEE_IX');
     DBMS_OUTPUT.PUT_LINE(RPAD('DEPARTMENT_ID',30)||'JHIST_DEPARTMENT_IX');
     DBMS_OUTPUT.PUT_LINE(RPAD('JOB_ID',30)||'JHIST_JOB_IX ');
     END LOOP;
end if;  
  END indexx;
procedure mainn( p_table varchar2, p_type varchar2)
as
BEGIN
IF P_TABLE='EMPLOYEES' AND P_TYPE='COLUMNS'
THEN
TABLEE;
ELSIF P_TABLE='EMPLOYEES' AND P_TYPE='CONSTRAINTS'
THEN
CONSTRAINTSS;
ELSIF 
P_TABLE ='EMPLOYEES' AND P_TYPE='INDEXES'
THEN 
INDEXX;
ELSIF P_table='EMPLOYEES' AND P_TYPE='ALL'
THEN
TABLEE;
CONSTRAINTSS;
INDEXX;
END IF;
EXCEPTION WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(SQLCODE||SQLERRM);
end mainn;
END xxintg_different_tables;


