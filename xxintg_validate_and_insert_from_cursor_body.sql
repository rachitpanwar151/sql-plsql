CREATE OR REPLACE PACKAGE BODY XXINTG_VALIDATE_AND_INSERT
AS

/**************************************************************************************************
VERSION            WHEN            WHO                       WHY

1.0           20-JULY-2023    RACHIT PANWAR           TO MAKE A PACKAGE BODY TO UPDATE AND
                                                    AND INSERT DETAILS IN STAGING AND BASE TABLE
***************************************************************************************************/

/***************************
GLOBAL VARIABLE DECLERATION
****************************/
    GN_TCOUNT NUMBER;
    gn_scount NUMBER;
    GN_VCOUNT number;
    GN_ECOUNT NUMBER;
/**************************************
PROCEDURE OF  PRINTING A REPORT
*************************************/
  PROCEDURE reportt (
        p_batch_id     NUMBER,
        p_process_type VARCHAR
    ) AS
    BEGIN

----------> TOTAL NUMBER OF RECORDS COUNT   IN STAGING TABLE
    SELECT
            COUNT(*)
        INTO GN_TCOUNT
        FROM
            xxintg_staging_rp;
---------------------> TOTAL NUMBER OF ERROR STATUS  COUNT IN  STAGING TABLE

        SELECT
            COUNT(*)
        INTO GN_ECOUNT
        FROM
            xxintg_staging_rp
        WHERE
            status = 'E';
            
-------------> CHECKING CONDICTION OF VALIDATE ONLY PROCESS TYPE

            IF UPPER(P_PROCESS_TYPE)='VALIDATE ONLY '
            THEN

-------------> TOTAL VALIDATE RECORDS IN STAGING TABLE 
        SELECT
            COUNT(*)
        INTO GN_VCOUNT
        FROM
            xxintg_staging_rp
        WHERE
            status = 'V';

        dbms_output.put_line(rpad('TOTAL_COUNT', 30)
                             || ' '
                             || rpad('V_STATUS_COUNT', 30)
                             || ' '
                             || rpad('E_STATUS_COUNT', 30));

        dbms_output.put_line(rpad(GN_TCOUNT, 30)
                             || ' '
                             || rpad(GN_VCOUNT, 30)
                             || ' '
                             || rpad(GN_ECOUNT, 30));

 -------------> ELSE CHECKING OTHER CONDICTION OF VALIDATE AND INSERT IN BASE TABLE
      ELSIF UPPER(P_PROCESS_TYPE)='VALIDATE AND INSERT'
           THEN

---------> TOTAL SUCCESS RECORD IN STAGING AFTER INSERTION
       SELECT
            COUNT(*)
        INTO gn_Scount
        FROM
            xxintg_staging_rp
        WHERE
            status = 'S';
 
 
        dbms_output.put_line(rpad('TOTAL_COUNT', 30)
                             || ' '
                             || rpad('V_STATUS_COUNT', 30)
                             || ' '
                             || rpad('E_STATUS_COUNT', 30));

        dbms_output.put_line(rpad(GN_TCOUNT, 30)
                             || ' '
                             || rpad(gn_scount, 30)
                             || ' '
                             || rpad(GN_ECOUNT, 30));

END IF;

EXCEPTION WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('ERROR OCCURED '||SQLCODE||' '||SQLERRM);

    END reportt;



/*************************************
proceDure of inserting into base table
***************************************/

procedure insert_into_employees(p_batch_id in number)
as
cursor CUR_EMP_DTL
is
select * from xxintg_staging_rp where reQUEST_id=p_batch_id and status='V';
BEGIN
FOR REC_EMP_DTL IN CUR_EMP_DTL 
LOOP
BEGIN
INSERT INTO EMPLOYEES VALUES(
EMPLOYEES_SEQ.NEXTVAL,
REC_EMP_DTL.FIRST_NAME,
REC_EMP_DTL.LAST_NAME,
REC_EMP_DTL.EMAIL,
REC_EMP_DTL.PHONE_NUMBER,
REC_EMP_DTL.HIRE_DATE,
REC_EMP_DTL.JOB_ID,
REC_EMP_DTL.SALARY,
REC_EMP_DTL.COMMISSION_PCT,
REC_EMP_DTL.MANAGER_ID,
REC_EMP_DTL.DEPARTMENT_ID
);
BEGIN
UPDATE XXINTG_STAGING_RP SET STATUS='S' WHERE REQUEST_ID=P_BATCH_ID
AND RECORD_ID=REC_EMP_DTL.RECORD_ID;
EXCEPTION WHEN OTHERS
THEN
DBMS_OUTPUT.PUT_LINE('ERROR IN DATA UPDATION '||SQLCODE||' '||SQLERRM);
END;
EXCEPTION WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('DATA CANT BE '||SQLCODE||' '||SQLERRM);
END;
END LOOP;
EXCEPTION WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('DATA CANT BE INSERTED INTO EMPLOYEES'||SQLCODE||' '||SQLERRM);

END INSERT_INTO_EMPLOYEES;

/***********************************************
procedure of VALIDATING VALUES
************************************************/
    PROCEDURE validatee (
        p_batch_id NUMBER
    ) AS
/**********************************************
LOCAL VARIABLES
**********************************************/
        lc_email         VARCHAR(50);
        ln_count         NUMBER;
        LC_STATUS        VARCHAR(30);
        LC_ERROR         VARCHAR(3000);
        lc_department_id VARCHAR(50);
        lc_job_id        VARCHAR(30);

----->DECLARING CURSOR FOR VALIDATION

        CURSOR CUR_STNG_DTL IS
        SELECT
            *
        FROM
            xxintg_staging_rp
        WHERE
                status = 'N'
            AND request_id = p_batch_id;

    BEGIN
        FOR REC_STNG_DTL IN CUR_STNG_DTL LOOP
            LC_STATUS := 'V';

/********************************
EMPLOYEE_ID VALIDATION
*********************************/

            IF REC_STNG_DTL.employee_id IS NOT NULL THEN
                SELECT
                    COUNT(employee_id)
                INTO ln_count
                FROM
                    employees
                WHERE
                    employee_id = REC_STNG_DTL.employee_id;

                IF ln_count > 0 THEN
                    dbms_output.put_line('EMPLOYEE_ID ERREC_STNG_DTL');
                    LC_STATUS := 'E';
                    LC_ERROR := ' EMPLOYEE ID ALREADY EXIST ';
                    dbms_output.put_line('1');
                END IF;

            END IF;

/*****************************
FIRST_NAME VALIDATION
******************************/
IF LENGTH(REC_STNG_DTL.FIRST_NAME)>20 THEN
LC_STATUS:='E';
LC_ERROR:=LC_ERROR||'  FIRST_NAME CAN ONLY HAVE 20 CHARACTER';
END IF;

/*****************************
LAST_NAME VALIDATION
******************************/
IF LENGTH(REC_STNG_DTL.LAST_NAME)>20 THEN
LC_STATUS:='E';
LC_ERROR:=LC_ERROR||'  LAST_NAME CAN ONLY HAVE 20 CHARACTER';
END IF;



/************************************
EMAIL VALIDATION
*************************************/

            lc_email :=upper( REC_STNG_DTL.first_name
                        || '.'
                        || REC_STNG_DTL.last_name)
                        || '@INTELLOGER.COM';
            BEGIN

                SELECT
                    COUNT(email)
                INTO ln_count
                FROM
                    employees
                WHERE
                        upper(first_name) = upper(REC_STNG_DTL.first_name)
                    AND upper(last_name) = upper(REC_STNG_DTL.last_name);

                IF ln_count > 0 THEN
                    lc_email := upper(REC_STNG_DTL.first_name
                                || '.'
                                || REC_STNG_DTL.last_name)
                                || ln_count
                                || '@INTELLOGER.COM';               
                END IF;

            EXCEPTION
                WHEN OTHERS THEN
                    LC_STATUS := 'E';
                    LC_ERROR := LC_ERROR
                                || ' CANT GENERATE EMAIL'
                                || sqlcode
                                || sqlerrm;
                    dbms_output.put_line('EMPLOYEE_ID ERR3');
                    dbms_output.put_line('2');
            END;
/********************************************
PHONE NUMBER VALIDATION
**********************************************/

            IF REC_STNG_DTL.phone_number IS NULL THEN
                LC_STATUS := 'E';
                LC_ERROR := LC_ERROR || ' PHONE NUMBER CANNOT BE NULL';
                dbms_output.put_line('EMPLOYEE_ID ERR4');
            ELSIF length(REC_STNG_DTL.phone_number) <> 10 THEN
                dbms_output.put_line('EMPLOYEE_ID ERR5');
                LC_STATUS := 'E';
                LC_ERROR := LC_ERROR || ' PHONE NUMBER HAVE 10 DIGITS NUMBER';
                dbms_output.put_line('3');
            ELSE
                BEGIN
                ln_count:=0;
                    SELECT
                        COUNT(phone_number)
                    INTO ln_count
                    FROM
                        employees
                    WHERE
                        phone_number = REC_STNG_DTL.phone_number;

                    IF ln_count > 0 THEN
                        dbms_output.put_line('EMPLOYEE_ID ERR6');
                        LC_STATUS := 'E';
                        LC_ERROR := LC_ERROR || ' PHONE NUMBER ALREADY EXIST WRITE A DIFFERENT PHONE NUMBER';
                        dbms_output.put_line('4');
                    END IF;

                END;

                dbms_output.put_line('phone number validate');
            END IF;
 
 /*****************************
  HIRE DATE VALIDATION
 *******************************/
            IF REC_STNG_DTL.hire_date > sysdate THEN
                dbms_output.put_line('EMPLOYEE_ID ERR7');
                LC_STATUS := 'E';
                LC_ERROR := LC_ERROR || ' HIREDATE SHOULD BE LESS THAN AND EQUAL TO SYADATE';
                dbms_output.put_line('5');
            END IF;

            dbms_output.put_line('hiredate validate');

/**********************************
JOB ID VALIDATION
*************************************/
            BEGIN
                SELECT
                    job_id
                INTO lc_job_id
                FROM
                    jobs
                WHERE
                    job_title = REC_STNG_DTL.job_title;

                dbms_output.put_line('EMPLOYEE_ID ERR8');
            EXCEPTION
                WHEN OTHERS THEN
                    LC_STATUS := 'E';
                    LC_ERROR := LC_ERROR
                                || ' '
                                || 'JOB TITLE DOES NOT EXISTS';
                    dbms_output.put_line('6');
                    dbms_output.put_line('EMPLOYEE_ID ERR9');
            END;

            dbms_output.put_line('jobid validate');

/**********************************************
SALARY VALIDATION
**********************************************/
            IF REC_STNG_DTL.salary < 5000 THEN
                LC_STATUS := 'E';
                LC_ERROR := LC_ERROR || ' SLAARY SHOULD BE GREATER THAN 5000';
                dbms_output.put_line('EMPLOYEE_ID ERREC_STNG_DTL0');
                dbms_output.put_line('7');
            END IF;

            dbms_output.put_line('salary validate');
	/*************************
		*COMMISION PCT VALIDATION
		**************************/
            IF REC_STNG_DTL.commission_pct NOT BETWEEN 0 AND 1 THEN
                dbms_output.put_line('EMPLOYEE_ID ERREC_STNG_DTL1');
                LC_STATUS := 'E';
                LC_ERROR := LC_ERROR || ' COMMISSION PCT CANNOT BE GREATER THAN 1 AND LESS THAN 0';
                dbms_output.put_line('8');
            END IF;

            dbms_output.put_line('commission pct validate');
/**************************
MANAGER ID VALIDATION
*****************************/

            IF REC_STNG_DTL.manager_id IS NULL THEN
                dbms_output.put_line('EMPLOYEE_ID ERREC_STNG_DTL2');
                LC_STATUS := 'E';
                LC_ERROR := LC_ERROR || ' MANAGER ID CANNOT BE NULL';
                dbms_output.put_line('9');
            ELSE
            ln_count:=0;
                SELECT
                    COUNT(*)
                INTO ln_count
                FROM
                    employees
                WHERE
                    employee_id = REC_STNG_DTL.manager_id;
--                    DBMS_OUTPUT.PUT_LINE(LN_COUNT||'EMPLOYEE_ID ERREC_STNG_DTL3');

                IF ln_count <> 1 THEN
                    LC_STATUS := 'E';
                    LC_ERROR := lc_error || ' MANAGER ID DOESNT EXIST';
                    dbms_output.put_line('EMPLOYEE_ID ERREC_STNG_DTL3');
                    dbms_output.put_line('10');
                END IF;

            END IF;
    /****************************************
    DEPARTMENT NAME VALIDATION
    *****************************************/
     IF REC_STNG_DTL.DEPARTMENT_NAME IS NULL 
     THEN 
     LC_STATUS:='E';
     LC_ERROR:=LC_ERROR||' DEPARTMENT NAME IS MANDATORY PLEASE WRITE A VALID DEPARTMENT NAME';
     END IF;
     
     
    /******************************
    DEPARTMENTID VALIDATION
    *******************************/

            BEGIN
                SELECT
                    department_id
                INTO lc_department_id
                FROM
                    departments
                WHERE
                    lower(department_name) = lower(REC_STNG_DTL.department_name);

            EXCEPTION
                WHEN OTHERS THEN
                    LC_STATUS := 'E';
                    lc_error := lc_error
                                || 'DEPARTMENT_ID DOESNT EXIST'
                                || sqlcode
                                || ' '
                                || sqlerrm;
                    dbms_output.put_line('11');
            END;
DBMS_OUTPUT.PUT_LINE(LC_STATUS||' HOHO '||LC_ERROR);
            UPDATE XXINTG_STAGING_RP
            SET
                status = LC_STATUS,
                errorr = LC_ERROR,
                email = lc_email,
                department_id = lc_department_id,
                job_id = lc_job_id
            WHERE
                    record_id = REC_STNG_DTL.record_id
                AND request_id = p_batch_id;
                COMMIT;
DBMS_OUTPUT.PUT_LINE(LC_STATUS||' HOHO '||LC_ERROR);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlcode || sqlerrm);
    END validatee;


/*********************************************
procedure of insertion in staging table
************************************************/


PROCEDURE insert_into_staging (
        p_batch_id NUMBER
    ) AS
    BEGIN
        INSERT INTO xxintg_staging_rp VALUES (
            p_batch_id,
            record_id.NEXTVAL,
            '',
            'rOHIT',
            'paNDAY',
            '',
            9999100000,
            sysdate-6,
            '',
            'Programmer',
            10000,
            0.4,
            121,
            '',
            'Executive',
            'ROBIN',
            'ROBIN',
            sysdate,
            sysdate,
            1011,
            'N',
            ''
        );
--        INSERT INTO xxintg_staging_rp VALUES (
--            p_batch_id,
--            record_id.NEXTVAL,
--            '',
--            'rachit',
--            'panwar',
--            '',
--            8976530000,
--            sysdate-6,
--            '',
--            'Programmer',
--            10000,
--            0.4,
--            121,
--            '',
--            'Executive',
--            'ROBIN',
--            'ROBIN',
--            sysdate,
--            sysdate,
--            1011,
--            'N',
--            ''
--        );
        commit;

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR OCCURED in staging table'
                                 || sqlcode
                                 || '-'
                                 || sqlerrm);
    END insert_into_staging;

PROCEDURE print_parameter (
        p_batch_id   NUMBER,
        p_process_TYPE VARCHAR
    ) AS
/*********************************
PROCEDURE FOR PARAMETER PRINTING
***********************************/

    BEGIN
        dbms_output.put_line(rpad('P_BATCH_ID', 20)
                             || ' '
                             || rpad('p_process_type', 20));
        dbms_output.put_line(rpad(P_BATCH_ID, 20)
                             || ' '
                             || rpad(p_process_type, 20));

        dbms_output.put_line('PARAMETER PRINTED SUCCESSFULLY');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR OCCURED'
                                 || sqlcode
                                 || '-'
                                 || sqlerrm);
    END print_parameter;


/*****************************
main procedure for calling
******************************/
PROCEDURE main_procedure (
        p_batch_id     NUMBER,
        p_process_type VARCHAR2
    )
    AS
    BEGIN
    IF P_BATCH_ID IS NULL 
    THEN
    DBMS_OUTPUT.PUT_LINE('BATCH ID CANNOT BE NULL');
    ELSE
    
    print_parameter(p_batch_id, p_process_type);
    insert_into_staging(p_batch_id);
 IF UPPER(p_process_type) = UPPER('VALIDATE ONLY') THEN
                 
            validatee(p_batch_id);
            reportt(p_batch_id, p_process_type);
        ELSIF UPPER(p_process_type) = 'VALIDATE AND INSERT' THEN        
            validatee(p_batch_id);
            insert_into_employees(p_batch_id);
            reportt(p_batch_id, p_process_type);
    
        END IF;
    
        END IF;
    
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlcode
                                 || ' '
                                 || sqlerrm);
    
    END MAIN_PROCEDURE;
    
    END  XXINTG_VALIDATE_AND_INSERT;
    
    ------------------------------------------------------------------------------
    BEGIN 
    XXINTG_VALIDATE_AND_INSERT.MAIN_PROCEDURE(3,'VALIDATE ONLY');
    END;
    
    truncate table xxintg_staging_rp;
    
    SELECT * FROM EMPLOYEES;  

    select * from xxintg_staging_rp;
    