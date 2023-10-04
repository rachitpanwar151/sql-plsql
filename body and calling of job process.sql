CREATE OR REPLACE PACKAGE BODY j_pckg AS

    PROCEDURE j_validate (
        p_jobid     VARCHAR2,
        p_jobtitle  VARCHAR2,
        p_minsalary NUMBER,
        p_maxsalary NUMBER,
        p_status    OUT VARCHAR,
        p_error     OUT VARCHAR
    ) AS
    BEGIN
        BEGIN
            IF p_jobid IS NULL THEN
                p_status := 'E';
                p_error := p_error || 'JOB_ID CANNOT BE NULL';
            END IF;
        END;

        BEGIN
            IF p_jobtitle IS NULL THEN
                p_status := 'E';
                p_error := p_error || 'JOB_ID CANNOT BE NULL';
            END IF;

        END;

        BEGIN
            IF length(p_minsalary) > 6 THEN
                p_status := 'E';
                p_error := p_error || 'JOB_ID CANNOT BE NULL';
            END IF;
        END;

        BEGIN
            IF lengtH(p_maxsalary) > 6 THEN
                p_status := 'E';
                p_error := p_error || 'JOB_ID CANNOT BE NULL';
            END IF;
        END;

    END J_VALIDATE;
 
 
 PROCEDURE J_LOADDATA( P_JOBID VARCHAR2, P_JOBTITLE VARCHAR2,P_MINSALARY NUMBER , P_MAXSALARY NUMBER ,P_STATUS OUT VARCHAR, P_ERROR OUT VARCHAR2)
 AS
 BEGIN
 
   IF P_STATUS='E'
   THEN
   P_ERROR:=P_ERROR||'DATA CANT INSERT ';
   ELSE 
 INSERT INTO JOBS VALUES(P_JOBID 
, P_JOBTITLE 
,P_MINSALARY 
, P_MAXSALARY );
COMMIT;
END IF;
   EXCEPTION  WHEN OTHERS THEN 
   P_STATUS:='E';
   P_ERROR:=P_ERROR||SQLCODE||SQLERRM;
   
 END J_LOADDATA;
 
 PROCEDURE J_MAIN( P_JOBID VARCHAR2, P_JOBTITLE VARCHAR2,P_MINSALARY NUMBER , P_MAXSALARY NUMBER ,P_STATUS OUT VARCHAR, P_ERROR OUT VARCHAR2)
 AS
BEGIN

J_VALIDATE( P_JOBID 
, P_JOBTITLE 
,P_MINSALARY 
, P_MAXSALARY 
,P_STATUS ,
P_ERROR );
IF P_STATUS='V '
THEN 
J_LOADDATA( P_JOBID
, P_JOBTITLE 
,P_MINSALARY  
, P_MAXSALARY 
,P_STATUS 
, P_ERROR );
END IF; EXCEPTION
    WHEN OTHERS THEN
        p_status := 'E';
        p_error := p_error
                   || sqlcode
                   || sqlerrm;
END j_main;
 END j_pckg;
 
 
 
 
 
 
 
 ------------------------------------CALLING--------------------------- 
 SELECT * FROM JOBS;
 DECLARE
 LN_E VARCHAR2(40);
 ln_c varchar2(30);
 BEGIN
 J_PCKG.J_LOADDATA('AS_CONS','ASSOCIATE CONSULTANT',19500,150000,ln_c,ln_e);
 END;
 