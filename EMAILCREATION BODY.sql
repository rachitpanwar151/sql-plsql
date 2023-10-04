CREATE OR REPLACE PACKAGE BODY XXINTG_EMPLOYEE_EMAIL_CREATION AS

     gn_emp_id employees.employee_id%TYPE; 
/*******************************************************************************************
DEFINING AND DECLARING PROCEURE LOADDATE FOR INSETING THE DATA IN BASE TABLE
*********************************************************************************************/
    PROCEDURE LOADDATA (
        P_EMPLOYEE_ID    IN EMPLOYEES.EMPLOYEE_ID%TYPE,
        P_FIRST_NAME     IN EMPLOYEES.FIRST_NAME%TYPE,
        P_LAST_NAME      IN EMPLOYEES.LAST_NAME%TYPE,
        P_EMAIL          IN EMPLOYEES.EMAIL%TYPE,
        P_PHONE_NUMBER   IN EMPLOYEES.PHONE_NUMBER%TYPE,
        P_HIRE_DATE      IN EMPLOYEES.HIRE_DATE%TYPE,
        P_JOB_ID         IN EMPLOYEES.JOB_ID%TYPE,
        P_SALARY         IN EMPLOYEES.SALARY%TYPE,
        P_COMMISSION_PCT IN EMPLOYEES.COMMISSION_PCT%TYPE,
        P_MANAGER_ID     IN EMPLOYEES.MANAGER_ID%TYPE,
        P_DEPARTMENT_ID  IN EMPLOYEES.DEPARTMENT_ID%TYPE,
        LC_STATUS        OUT VARCHAR2,
        LC_ERROR         OUT VARCHAR2
    ) AS
    BEGIN
        
        LC_STATUS := 'V'; -- SETTING THE STATUS VALIDATED 'V'
        gn_emp_id := EMPLOYEES_SEQ.NEXTVAL; --GENERATING THE EMPLOYEE ID BY SEQUENCE
     
     
        BEGIN
            INSERT INTO EMPLOYEES VALUES (
                gn_emp_id,
                P_FIRST_NAME,
                P_LAST_NAME,
                P_EMAIL,
                P_PHONE_NUMBER,
                P_HIRE_DATE,
                P_JOB_ID,
                P_SALARY,
                P_COMMISSION_PCT,
                P_MANAGER_ID,
                P_DEPARTMENT_ID
            );
 COMMIT; -- COMMITING THE INSERT
 
        EXCEPTION
            WHEN OTHERS THEN
                LC_STATUS := 'E';
                LC_ERROR := SQLCODE
                            || '-'
                            || SQLERRM;
                DBMS_OUTPUT.PUT_LINE('ERROR IN DATA INSERTION '
                                     || SQLCODE
                                     || '-'
                                     || SQLERRM);
        END;

    EXCEPTION
        WHEN OTHERS THEN
            LC_STATUS := 'E';
            LC_ERROR := SQLCODE
                        || '-'
                        || SQLERRM;
            DBMS_OUTPUT.PUT_LINE('ERROR IN LOADING DATA '
                                 || SQLCODE
                                 || '-'
                                 || SQLERRM);
    END LOADDATA;


/**************************************
procedure for validating data
***************************************/

    PROCEDURE VALIDATEDATA (
        P_EMPLOYEE_ID    IN EMPLOYEES.EMPLOYEE_ID%TYPE,
        P_FIRST_NAME     IN EMPLOYEES.FIRST_NAME%TYPE,
        P_LAST_NAME      IN EMPLOYEES.LAST_NAME%TYPE,
        P_EMAIL          OUT EMPLOYEES.EMAIL%TYPE,
        P_PHONE_NUMBER   IN EMPLOYEES.PHONE_NUMBER%TYPE,
        P_HIRE_DATE      IN EMPLOYEES.HIRE_DATE%TYPE,
        P_JOB_ID         IN EMPLOYEES.JOB_ID%TYPE,
        P_SALARY         IN EMPLOYEES.SALARY%TYPE,
        P_COMMISSION_PCT IN EMPLOYEES.COMMISSION_PCT%TYPE,
        P_MANAGER_ID     IN EMPLOYEES.MANAGER_ID%TYPE,
        P_DEPARTMENT_ID  IN EMPLOYEES.DEPARTMENT_ID%TYPE,
        P_STATUS         OUT VARCHAR2,
        P_ERROR          OUT VARCHAR2
    ) AS

        LN_EMAIL       VARCHAR2(40);
        LN_EMAIL_COUNT NUMBER := 0;
        LN_COUNT       NUMBER := 0;
        LN_PH_COUNT    NUMBER;
        LN_JOB_ID      JOBS.JOB_ID%TYPE;
    BEGIN
        P_STATUS := 'V';

/***************************
first name validation
****************************/

        IF P_FIRST_NAME IS NULL THEN
            P_STATUS := 'E';
            P_ERROR := P_ERROR || ' first_name cannot be null';
        ELSIF LENGTH(P_FIRST_NAME) > 20 THEN
            DBMS_OUTPUT.PUT_LINE('2');
            P_STATUS := 'E';
            P_ERROR := P_ERROR || ' FIRST NAME CANNNOT HAVE MORE THAN 20 CHARACTER';
        END IF;
/*****************************
LAST NAME VALIDATION
******************************/

        IF P_LAST_NAME IS NULL THEN
            P_STATUS := 'E';
            P_ERROR := P_ERROR || ' LAST NAME CANNOT BE NULL';
        ELSE
            IF LENGTH(P_LAST_NAME) > 20 THEN
                DBMS_OUTPUT.PUT_LINE('3');
                P_STATUS := 'E';
                P_ERROR := P_ERROR || ' LAST NAME CANNOT HAVE MORE THAN 20 CHARACTER';
            END IF;
        END IF;

/**************************
EMAIL VALIDATION
***************************/

        P_EMAIL := P_FIRST_NAME
                   || '.'
                   || P_LAST_NAME
                   || '@INTELLOGER.COM';
        SELECT
            COUNT(EMAIL)
        INTO LN_EMAIL_COUNT
        FROM
            EMPLOYEES
        WHERE
                UPPER(FIRST_NAME) = UPPER(P_FIRST_NAME)
            AND UPPER(LAST_NAME) = UPPER(P_LAST_NAME);

        IF LN_EMAIL_COUNT > 0 THEN
            P_EMAIL := P_FIRST_NAME
                       || '.'
                       || P_LAST_NAME
                       || LN_EMAIL_COUNT
                       || '@INTELLOGER.COM';
        END IF;
		
        /*******************************************************
        PHONE NUMBER VALIDATION
        ********************************************************/
        
        IF P_PHONE_NUMBER IS NULL THEN
            P_STATUS := 'E';
            P_ERROR := P_ERROR
                       || ' '
                       || 'PHONE NUMBER CAN NOT BE NULL';
        ELSIF LENGTH(P_PHONE_NUMBER) != 10 THEN
            P_STATUS := 'E';
            P_ERROR := P_ERROR
                       || ' '
                       || 'PHONE NUMBER SHOULD HAVE 10 DIGITS';
        ELSE
            SELECT
                COUNT(PHONE_NUMBER)
            INTO LN_PH_COUNT
            FROM
                EMPLOYEES
            WHERE
                PHONE_NUMBER = P_PHONE_NUMBER;

            IF LN_PH_COUNT > 0 THEN
                P_STATUS := 'E';
                P_ERROR := P_ERROR
                           || ' '
                           || 'PHONE NUMBER ALREADY EXISTS';
            END IF;

        END IF;
            /***************************************************
            HIRE DATE VALIDATION
            ****************************************************/
            
        IF P_HIRE_DATE IS NULL THEN
            P_STATUS := 'E';
            P_ERROR := P_ERROR
                       || ' '
                       || 'HIRE DATE CAN NOT BE NULL';
        ELSIF P_HIRE_DATE > SYSDATE THEN
            DBMS_OUTPUT.PUT_LINE('6');
            P_STATUS := 'E';
            P_ERROR := P_ERROR || ' HIRE DATE CANNOT BE GREATER THEN SYSDATE';
        END IF;
 

            /***********************************************
            JOB ID VALIDATION
            ************************************************/
            
        IF P_JOB_ID IS NULL THEN
            P_STATUS := 'E';
            P_ERROR := P_ERROR || '  JOB ID CANNOT BE NULL';
        ELSE
            BEGIN
                SELECT
                    JOB_ID
                INTO LN_JOB_ID
                FROM
                    JOBS
                WHERE
                    JOB_ID = P_JOB_ID;

            EXCEPTION
                WHEN OTHERS THEN
                    P_STATUS := 'E';
                    P_ERROR := P_ERROR
                               || ' '
                               || 'JOB ID DOES NOT EXISTS';
            END;
        END IF;
    
    
    /*******************************
    SALARY VALIDATION
    ********************************/
    
        IF P_SALARY < 5000 THEN
            DBMS_OUTPUT.PUT_LINE('8');
            P_STATUS := 'E';
            P_ERROR := P_ERROR || ' SALARY SHOULD BE GREATER THAN 5000';
        END IF;
		
		
		/*************************
		*COMMISION PCT VALIDATION
		**************************/

        IF P_COMMISSION_PCT NOT BETWEEN 0 AND 1 THEN
            DBMS_OUTPUT.PUT_LINE('9');
            P_STATUS := 'E';
            P_ERROR := P_ERROR || ' COMMISSION PCT CANNOT BE GREATER THAN 1 AND LESS THAN 0';
        END IF;

        DBMS_OUTPUT.PUT_LINE(P_STATUS
                             || '-'
                             || P_ERROR);
							 
      /************************************************
      MANAGER ID  VALIDATION
********************************************************/

        IF P_MANAGER_ID IS NULL THEN
            P_STATUS := 'E';
            P_ERROR := P_ERROR || ' MANAGER ID CANNOT BE NULL';
        ELSE
            SELECT
                COUNT(*)
            INTO LN_COUNT
            FROM
                EMPLOYEES
            WHERE
                EMPLOYEE_ID = P_MANAGER_ID;

            IF LN_COUNT <> 1 THEN
                DBMS_OUTPUT.PUT_LINE('10');
                P_STATUS := 'E';
                P_ERROR := P_ERROR || ' MANAGER SHOULD BE AN EMPLOYEE';
            END IF;

        END IF;

        DBMS_OUTPUT.PUT_LINE(P_STATUS
                             || '-'
                             || P_ERROR);
							 
        /******************************************
        DEPARTMENT ID VALIDATION
        ********************************************/
        
        IF P_DEPARTMENT_ID IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('11');
            P_STATUS := 'E';
            P_ERROR := P_ERROR || ' DEPARTMENT_ID IS NULL';
        ELSE
            SELECT
                COUNT(DEPARTMENT_ID)
            INTO LN_COUNT
            FROM
                DEPARTMENTS
            WHERE
                DEPARTMENT_ID = P_DEPARTMENT_ID;

            IF LN_COUNT != 1 THEN
                P_STATUS := 'E';
                P_ERROR := P_ERROR
                           || ' '
                           || 'DEPARTMENT DOES NOT EXIST';
            END IF;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            P_STATUS := 'E';
            P_ERROR := 'ERROR IN PERFORMING VALIDATION '
                       || SQLCODE
                       || '-'
                       || SQLERRM;
    END VALIDATEDATA;

        /***************************************
        main procedure where calling other procedure
        *****************************************/
        
    PROCEDURE MAINNN (
        P_EMPLOYEE_ID    IN EMPLOYEES.EMPLOYEE_ID%TYPE,
        P_FIRST_NAME     IN EMPLOYEES.FIRST_NAME%TYPE,
        P_LAST_NAME      IN EMPLOYEES.LAST_NAME%TYPE,
        P_PHONE_NUMBER   IN EMPLOYEES.PHONE_NUMBER%TYPE,
        P_HIRE_DATE      IN EMPLOYEES.HIRE_DATE%TYPE,
        P_JOB_ID         IN EMPLOYEES.JOB_ID%TYPE,
        P_SALARY         IN EMPLOYEES.SALARY%TYPE,
        P_COMMISSION_PCT IN EMPLOYEES.COMMISSION_PCT%TYPE,
        P_MANAGER_ID     IN EMPLOYEES.MANAGER_ID%TYPE,
        P_DEPARTMENT_ID  IN EMPLOYEES.DEPARTMENT_ID%TYPE
    ) AS
        LC_STATUS VARCHAR2(3000);
        LC_ERROR  VARCHAR2(7000);
        LC_EMAIL  VARCHAR2(40);
    BEGIN
    
    
    /**************************
    PRINTING PARAMETER
    ******************************/
    
        DBMS_OUTPUT.PUT_LINE(RPAD('p_employee_id ', 15)
                             || P_EMPLOYEE_ID);
        DBMS_OUTPUT.PUT_LINE(RPAD('p_first_name  ', 15)
                             || P_FIRST_NAME);
        DBMS_OUTPUT.PUT_LINE(RPAD('p_last_name  ', 15)
                             || P_LAST_NAME);

        DBMS_OUTPUT.PUT_LINE(RPAD('p_phone_number  ', 15)
                             || P_PHONE_NUMBER);
        DBMS_OUTPUT.PUT_LINE(RPAD('p_hire_date  ', 15)
                             || P_HIRE_DATE);
        DBMS_OUTPUT.PUT_LINE(RPAD('p_hire_date ', 15)
                             || P_HIRE_DATE);
        DBMS_OUTPUT.PUT_LINE(RPAD('p_job_id  ', 15)
                             || P_JOB_ID);
        DBMS_OUTPUT.PUT_LINE(RPAD('p_salary  ', 15)
                             || P_SALARY);
        DBMS_OUTPUT.PUT_LINE(RPAD('p_commission_pct  ', 15)
                             || P_COMMISSION_PCT);
        DBMS_OUTPUT.PUT_LINE(RPAD('p_manager_id  ', 15)
                             || P_MANAGER_ID);
        DBMS_OUTPUT.PUT_LINE(RPAD('p_department_id  ', 15)
                             || P_DEPARTMENT_ID);

                /*******************
                CALLING PROCEDURES
                ********************/

        IF P_EMPLOYEE_ID IS NULL THEN
        VALIDATEDATA
        (P_EMPLOYEE_ID, P_FIRST_NAME, P_LAST_NAME, LC_EMAIL, P_PHONE_NUMBER,
        P_HIRE_DATE, P_JOB_ID, P_SALARY, P_COMMISSION_PCT, P_MANAGER_ID,
        P_DEPARTMENT_ID, LC_STATUS, LC_ERROR);

            IF LC_STATUS = 'V' THEN
                DBMS_OUTPUT.PUT_LINE('VALIDATE SUCCESSFULLY');
                LOADDATA(employees_seq.nextval, P_FIRST_NAME, P_LAST_NAME, LC_EMAIL, P_PHONE_NUMBER,
                        P_HIRE_DATE, P_JOB_ID, P_SALARY, P_COMMISSION_PCT, P_MANAGER_ID,
                        P_DEPARTMENT_ID, LC_STATUS, LC_ERROR);

                IF LC_STATUS = 'V' THEN
                    DBMS_OUTPUT.PUT_LINE('INSERT SUCCESSFULLY');
                END IF;
            END IF;

        END IF;

----------------------REPORT----------------------------------------------

        DBMS_OUTPUT.PUT_LINE(RPAD('p_employee_id ', 15)
                             || RPAD('p_first_name  ', 15)
                             || RPAD('p_last_name  ', 15)
                             || RPAD('p_email  ', 15)
                             || RPAD('p_phone_number  ', 15)
                             || RPAD('p_hire_date  ', 15)
                             || RPAD('p_job_id  ', 15)
                             || RPAD('p_salary  ', 15)
                             || RPAD('p_commission_pct  ', 15)
                             || RPAD('p_manager_id  ', 15)
                             || RPAD('p_department_id  ', 15));

        DBMS_OUTPUT.PUT_LINE(RPAD(p_employee_id, 15)
                             || RPAD(P_FIRST_NAME, 15)
                             || RPAD(P_LAST_NAME, 15)
                             || RPAD(LC_EMAIL, 25)
                             || RPAD(P_PHONE_NUMBER, 15)
                             || RPAD(P_HIRE_DATE, 15)
                             || RPAD(P_JOB_ID, 15)
                             || RPAD(P_SALARY, 15)
                             || RPAD(P_COMMISSION_PCT, 15)
                             || RPAD(P_MANAGER_ID, 15)
                             || RPAD(P_DEPARTMENT_ID, 15));

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('EROR OCCURED'
                                 || SQLCODE
                                 || '-'
                                 || SQLERRM);
    END MAINNN;

END XXINTG_EMPLOYEE_EMAIL_CREATION;