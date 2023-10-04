CREATE OR REPLACE PACKAGE BODY pckg_diff_proce_curs
AS 

/********************************************************************************

version     who               when                         wjy
1.0         rachit panwar     13-july-23                   to make a 
                                                         package having procedure
                                                        of main and report
*********************************************************************************/


/***************************
PROCEDURE FOR EMPLOYEES
****************************/
    PROCEDURE emp AS
        CURSOR emp_dtls IS
        SELECT
            *
        FROM
            employees;

        rec_var emp_dtls%rowtype;
    BEGIN
        OPEN emp_dtls;
        LOOP
            FETCH emp_dtls INTO rec_var;
            EXIT WHEN emp_dtls%notfound;
            dbms_output.put_line(RPAD(rec_var.employee_id,20)
                             || ' '
                             || RPAD(rec_var.first_name,20)
                             || ' '
                             || RPAD(rec_var.department_id,20)||' '||
                             RPAD(rec_var.EMAIL,20)||' '||
                             RPAD(rec_var.PHONE_NUMBER,20)||' '||
                             RPAD(rec_var.HIRE_DATE,20)||' '||
                             RPAD(rec_var.JOB_ID,20)||' '||
                             RPAD(rec_var.SALARY,20)||' '||
                             RPAD(rec_var.COMMISSION_PCT,20)||' '||
                             RPAD(rec_var.MANAGER_ID,20)||' '||
                             RPAD(rec_var.DEPARTMENT_ID,20));
END LOOP;

        CLOSE emp_dtls;
    END;

/*********************************
PROCEDURE FOR DEPARTMENTS
**********************************/
    PROCEDURE dept AS
        CURSOR dept_dtls IS
        SELECT
            *
        FROM
            departments;

        rec_var dept_dtls%rowtype;
    BEGIN
        OPEN dept_dtls;
        LOOP
            FETCH dept_dtls INTO rec_var;
            EXIT WHEN dept_dtls%notfound;
               dbms_output.put_line(RPAD(rec_var.department_id,20)
                             || ' '
                             || RPAD(rec_var.department_name,20)
                             || ' '||RPAD(rec_var.MANAGER_ID,20)||' '
                             || RPAD(rec_var.location_id,20));
 END LOOP;

        CLOSE dept_dtls;
    END;

/*********************************************
PROCEDURE FOR JOBS TABLE
********************************************/

procedure JOBS
as
cursor JOBS_dtls
is 
select * from JOBS;
rec_var JOBS_dtls%rowtype;
begin
open JOBS_dtls;
loop
fetch JOBS_dtls into rec_var;
exit when JOBS_dtls%notfound;
dbms_output.put_line(rpad(rec_var.JOB_id,20)||' '||
rpad(rec_var.job_title,20) ||' '||
rpad(rec_var.min_salary,20)||' '||
rpad(rec_var.max_salary,20));
end loop;
close JOBS_dtls;
end ;


/*****************************************
PROCEDURE FOR JOB_HISTORY TABLE
*******************************************/
procedure JOB_HISTORY
as
cursor JOB_HISTORY_dtls
is 
select * from JOB_HISTORY;
rec_var JOB_HISTORY_dtls%rowtype;
begin
open JOB_HISTORY_dtls;
loop
fetch JoB_HISTORY_dtls into rec_var;
exit when JOB_HISTORY_dtls%notfound;
dbms_output.put_line(rpad(rec_var.employee_id,20)
|| ' '||rpad(rec_var.START_DATE,20)||' '||
rpad(rec_var.end_date,20)||' '||
rpad(rec_var.job_id,20)||' '||
rpad(rec_var.department_id,20));

end loop;
close JOB_HISTORY_dtls;
end ;


/***********************************
PROCEDURE FOR LOCATIONS
\************************************/

procedure locations
as
cursor locations_dtls
is 
select * from locations;
rec_var locations_dtls%rowtype;
begin
open locations_dtls;
loop
fetch locations_dtls into rec_var;
exit when locations_dtls%notfound;
dbms_output.put_line(rpad(rec_var.location_id,20)||' '||
RPAD(REC_VAR.STREET_ADDRESS,20)||' '||
RPAD(REC_VAR.POSTAL_CODE,20)
||' '||RPAD(REC_VAR.CITY,20));
end loop;
close locations_dtls;
end ;


/*********************************
PROCEDURE FOR REGIONS
**********************************/

procedure REGIONS
as
cursor REGIONS_dtls
is 
select * from REGIons;
rec_var REGions_dtls%rowtype;
begin
open REGions_dtls;
loop
fetch REGions_dtls into rec_var;
exit when REGions_dtls%notfound;
dbms_output.put_line(rpad(rec_var.REGion_id,20)||' '||
RPAD(REC_VAR.REGION_NAME,20));
end loop;
close REGions_dtls;
end ;

/********************************
PROCEDURE FOR COUNTRY TABLE
********************************/

procedure COUNTRY
as
cursor COUNTRIES_dtls
is 
select * from COUNTRIEs;
rec_var COUNTRIEs_dtls%rowtype;
begin
open COUNTRIEs_dtls;
loop
fetch COUNTRIEs_dtls into rec_var;
exit when COUNTRIEs_dtls%notfound;
dbms_output.put_line(rpad(rec_var.COUNTRY_id,20)||' '||
RPAD(REC_VAR.COUNTRY_NAME,20)||' '||
RPAD(REC_VAR.REGION_ID,30));
end loop;
close COUNTRIES_dtls;
end ;


/************************************
procedure for main
****************************************/
    PROCEDURE main_proce (
        p_type IN VARCHAR2
    ) AS
    BEGIN
        IF p_type IS NULL THEN
            dbms_output.put_line('error occured---argument is null');
        ELSIF p_type = 'DEPARTMENTS' THEN
    DEPT;
            ELSIF p_type = 'employees' THEN
            emp;
            elsif p_type='jobs'
            then
            jobs;
            elsif p_type='job_history'
            then job_history;
            elsif p_type='locations'
            then
            locations;
       ELSIF P_TYPE='REGIONS' THEN
       REGIONS;

ELSIF P_TYPE='COUNTRIES'
THEN
COUNTRY;
END IF;
    END main_proce;

END pckg_diff_proce_curs;




--call--
BEGIN
    pckg_diff_proce_curs.main_proce('COUNTRIES');
END;

