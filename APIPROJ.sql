CREATE OR REPLACE PACKAGE BODY xx_ver_inst_data_api AS
/******************************************
INSERT VALUE VALIDATION PROCEDURE
******************************************/
    PROCEDURE insert_validate_data (
        p_emp_id     IN emp_backup1.employee_id%TYPE,
        p_fname      IN emp_backup1.first_name%TYPE,
        p_lname      IN emp_backup1.last_name%TYPE,
        p_phone      IN emp_backup1.phone_number%TYPE,
        p_hire_date  IN emp_backup1.hire_date%TYPE,
        p_job_id     IN emp_backup1.job_id%TYPE,
        p_sal        IN emp_backup1.salary%TYPE,
        p_comm_pct   IN emp_backup1.commission_pct%TYPE,
        p_manager_id IN emp_backup1.manager_id%TYPE,
        p_dept_id    IN emp_backup1.department_id%TYPE,
        p_status     OUT VARCHAR2,
        p_error      OUT VARCHAR2
    ) IS
--LN_EMP_COUNT NUMBER;
        lc_job_id     VARCHAR2(20);
        ln_manager_id NUMBER;
        ln_dept_id    NUMBER;
        ln_hire_date  DATE;
    BEGIN
        p_status := 'V';
/***********************
VALIDATE EMPLOYEE_ID
***********************/
--        BEGIN
            IF p_emp_id IS NULL THEN
--SELECT COUNT(*) INTO LN_EMP_COUNT FROM EMP_BACKUP1 WHERE EMPLOYEE_ID=P_EMP_ID;
--IF LN_EMP_COUNT=1 THEN
                p_status := 'E';
                p_error := p_error
                           || ' - '
                           || ' EMPLOYEE ID CAN NOT BE NULL';
--P_ERROR:=P_ERROR||' - '||' EMPLOYEE ID ALREADY EXIST';
            END IF;

--        END;
/***************************
VERIFY FIRST_NAME 
***************************/
            IF p_fname IS NULL THEN
                p_status := 'E';
                p_error := p_error
                           || ' - '
                           || ' FIRST NAME COLUMN CAN NOT BE NULL';
            END IF;

/***************************
VERIFY LAST_NAME 
***************************/
            IF  p_lname IS NULL  THEN
                p_status := 'E';
                p_error := p_error
                           || ' - '
                           || 'LAST NAME COLUMN CAN NOT BE NULL';
            END IF;

/**********************************
VALIDATE PHONE_NUMBER
-LENGTH OF PHONE NUM. SHOULD BE 10.
**********************************/
        IF p_phone IS NULL THEN
            p_status := 'E';
            p_error := 'PHONE CAN NOT BE NULL';
        ELSE
            IF length(p_phone) <> 10 THEN
                p_status := 'E';
                p_error := p_error
                           || ' - '
                           || 'NOT CORRECT PHONE NUMBER';
            END IF;
        END IF;
/***************************
VERIFY HIRE_DATE 
***************************/
        IF p_hire_date IS NULL THEN
            p_status := 'E';
            p_error := 'HIRE DATE CAN NOT BE NULL';
        ELSE
                IF to_char(p_hire_date, 'DAY') != 'WEDNESDAY' THEN
                    ln_hire_date := next_day(p_hire_date, 'WEDNESDAY');
                END IF;
        END IF;
/**********************
VERIFY JOB_ID
**********************/
        IF p_job_id IS NULL THEN
            p_status := 'E';
            p_error := 'JOB ID CAN NOT BE NULL';
        ELSE
            BEGIN
                SELECT
                    job_id
                INTO lc_job_id
                FROM
                    jobs
                WHERE
                    job_id = p_job_id;

            EXCEPTION
                WHEN OTHERS THEN
                    p_status := 'E';
                    p_error := p_error
                               || ' - '
                               || 'JOB DOES NOT EXIST';
            END;
        END IF;
/***************************
VERIFY SALARY
***************************/
        IF p_sal IS NULL THEN
            p_status := 'E';
            p_error := 'SALARY CAN NOT BE NULL';
        ELSE
            IF ( p_sal < 1000 ) THEN
                p_status := 'E';
                p_error := p_error
                           || ' - '
                           || 'SALARY CAN NOT BE LESS THAN 1000';
            END IF;
        END IF;
/***************************
VERIFY COMMISSION
***************************/
            IF p_comm_pct IS NOT NULL THEN
                IF ( p_comm_pct < 0 OR p_comm_pct > 1 ) THEN
                    p_status := 'E';
                    p_error := p_error
                               || ' - '
                               || 'COMMISSION CAN NOT BE GREATER THAN 1';
                END IF;

            END IF;
/***************************
VERIFY MANAGER
***************************/
        IF p_manager_id IS NULL THEN
            p_status := 'E';
            p_error := 'MANAGER CAN NOT BE NULL';
        ELSE
            BEGIN
                SELECT
                    manager_id
                INTO ln_manager_id
                FROM
                    employees
                WHERE
                    employee_id = p_manager_id;

            EXCEPTION
                WHEN OTHERS THEN
                    p_status := 'E';
                    p_error := p_error
                               || ' - '
                               || 'IT IS NOT A MANAGER ID';
            END;
        END IF;
/***************************
VERIFY DEPARTMENT
***************************/
        IF p_dept_id IS NULL THEN
            p_status := 'E';
            p_error := 'DEPARTMENT ID CAN NOT BE NULL';
        ELSE
            BEGIN
                SELECT
                    department_id
                INTO ln_dept_id
                FROM
                    departments
                WHERE
                    department_id = p_dept_id;

            EXCEPTION
                WHEN OTHERS THEN
                    p_status := 'E';
                    p_error := p_error
                               || ' - '
                               || 'DEPARTMENT DOES NOT EXISTS';
            END;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || ' - '
                       || 'SOME UNEXPECTED ERROR IN VERIFY THE INSERT DATA'
                       || sqlcode
                       || ' - '
                       || sqlerrm;

    END insert_validate_data;
/****************************
INSERT PROCEDURE
****************************/
    PROCEDURE insert_data (
        p_emp_id     IN emp_backup1.employee_id%TYPE,
        p_fname      IN emp_backup1.first_name%TYPE,
        p_lname      IN emp_backup1.last_name%TYPE,
        p_phone      IN emp_backup1.phone_number%TYPE,
        p_hire_date  IN emp_backup1.hire_date%TYPE,
        p_job_id     IN emp_backup1.job_id%TYPE,
        p_sal        IN emp_backup1.salary%TYPE,
        p_comm_pct   IN emp_backup1.commission_pct%TYPE,
        p_manager_id IN emp_backup1.manager_id%TYPE,
        p_dept_id    IN emp_backup1.department_id%TYPE,
        p_status     OUT VARCHAR2,
        p_error      OUT VARCHAR2
    ) IS
    BEGIN
        p_status := 'S';
        INSERT INTO emp_backup1 (
            employee_id,
            first_name,
            last_name,
            phone_number,
            hire_date,
            job_id,
            salary,
            commission_pct,
            manager_id,
            department_id
        ) VALUES (
            p_emp_id,
            p_fname,
            p_lname,
            p_phone,
            p_hire_date,
            p_job_id,
            p_sal,
            p_comm_pct,
            p_manager_id,
            p_dept_id
        );
COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || ' - '
                       || ' ERROR IN INSERTING DATA'
                       || sqlcode
                       || ' - '
                       || sqlerrm;

    END insert_data;
    
/******************************************
UPDATE VALUE VALIDATION PROCEDURE
******************************************/
    PROCEDURE update_validate_data (
        p_emp_id     IN emp_backup1.employee_id%TYPE,
        p_fname      IN emp_backup1.first_name%TYPE,
        p_lname      IN emp_backup1.last_name%TYPE,
        p_phone      IN emp_backup1.phone_number%TYPE,
        p_hire_date  IN emp_backup1.hire_date%TYPE,
        p_job_id     IN emp_backup1.job_id%TYPE,
        p_sal        IN emp_backup1.salary%TYPE,
        p_comm_pct   IN emp_backup1.commission_pct%TYPE,
        p_manager_id IN emp_backup1.manager_id%TYPE,
        p_dept_id    IN emp_backup1.department_id%TYPE,
        p_status     OUT VARCHAR2,
        p_error      OUT VARCHAR2
    ) IS

        lc_fname      VARCHAR2(30);
        lc_lname      VARCHAR2(30);
        lc_hire_date  DATE;
        lc_job_id     VARCHAR2(20);
        ln_manager_id NUMBER;
        ln_dept_id    NUMBER;
    BEGIN
        p_status := 'V';
/**********************************
VALIDATE FIRST_NAME
**********************************/
        IF p_fname IS NOT NULL THEN
--            BEGIN
                SELECT
                    first_name
                INTO lc_fname
                FROM
                    emp_backup1
                WHERE
                    employee_id = p_emp_id;

                IF p_fname != lc_fname THEN
                    p_status := 'E';
                    p_error := 'name can not be changed';
                END IF;

--            END;

        END IF;
/**********************************
VALIDATE LAST_NAME
**********************************/
        IF p_lname IS NOT NULL THEN
--            BEGIN
                SELECT
                    last_name
                INTO lc_lname
                FROM
                    emp_backup1
                WHERE
                    employee_id = p_emp_id;

                IF p_lname != lc_lname THEN
                    p_status := 'E';
                    p_error := 'last name can not be changed';
                END IF;

--            END;
        END IF;
/**********************************
VALIDATE PHONE_NUMBER
-LENGTH OF PHONE NUM. SHOULD BE 10.
**********************************/
        IF p_phone IS NOT NULL THEN
            IF length(p_phone) <> 10 THEN
                p_status := 'E';
                p_error := p_error
                           || ' - '
                           || 'NOT CORRECT PHONE NUMBER';
            END IF;
        END IF;
/**********************************
VALIDATE HIRE DATE
**********************************/
        IF p_hire_date IS NOT NULL THEN
--            BEGIN
                SELECT
                    hire_date
                INTO lc_hire_date
                FROM
                    emp_backup1
                WHERE
                    employee_id = p_emp_id;

                IF p_hire_date != lc_hire_date THEN
                    p_status := 'E';
                    p_error := 'HIRING DATE CAN NOT BE CHANGED';
                END IF;

--            END;
        END IF;
/**********************
VERIFY JOB_ID
**********************/
        IF p_job_id IS NOT NULL THEN
            BEGIN
                SELECT
                    job_id
                INTO lc_job_id
                FROM
                    jobs
                WHERE
                    job_id = p_job_id;

            EXCEPTION
                WHEN OTHERS THEN
                    p_status := 'E';
                    p_error := p_error
                               || ' - '
                               || 'JOB DOES NOT EXIST';
            END;
        END IF;
/***************************
VERIFY SALARY
***************************/
        IF p_sal IS NOT NULL THEN
            IF ( p_sal < 1000 ) THEN
                p_status := 'E';
                p_error := p_error
                           || ' - '
                           || 'SALARY CAN NOT BE LESS THAN 1000';
            END IF;
        END IF;
/***************************
VERIFY COMMISSION
***************************/
            IF p_comm_pct IS NOT NULL THEN
                IF ( p_comm_pct < 0 OR p_comm_pct > 1 ) THEN
                    p_status := 'E';
                    p_error := p_error
                               || ' - '
                               || 'COMMISSION CAN NOT BE GREATER THAN 1'
                               || ' - '
                               || sqlcode
                               || ' - '
                               || sqlerrm;

                END IF;

            END IF;
/***************************
VERIFY MANAGER
***************************/
        IF p_manager_id IS NOT NULL THEN
            BEGIN
                SELECT
                    manager_id
                INTO ln_manager_id
                FROM
                    employees
                WHERE
                    employee_id = p_manager_id;

            EXCEPTION
                WHEN OTHERS THEN
                    p_status := 'E';
                    p_error := p_error
                               || ' - '
                               || 'IT IS NOT A MANAGER ID';
            END;
        END IF;
/***************************
VERIFY DEPARTMENT
***************************/
        IF p_dept_id IS NOT NULL THEN
            BEGIN
                SELECT
                    department_id
                INTO ln_dept_id
                FROM
                    departments
                WHERE
                    department_id = p_dept_id;

            EXCEPTION
                WHEN OTHERS THEN
                    p_status := 'E';
                    p_error := p_error
                               || ' - '
                               || 'DEPARTMENT DOES NOT EXISTS';
            END;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || ' - '
                       || sqlcode
                       || ' - '
                       || sqlerrm;
    END update_validate_data;
    
    
/******************************
UPDATE PROCEDURE
******************************/
    PROCEDURE update_data (
        p_emp_id     IN emp_backup1.employee_id%TYPE,
        p_fname      IN emp_backup1.first_name%TYPE,
        p_lname      IN emp_backup1.last_name%TYPE,
        p_phone      IN emp_backup1.phone_number%TYPE,
        p_hire_date  IN emp_backup1.hire_date%TYPE,
        p_job_id     IN emp_backup1.job_id%TYPE,
        p_sal        IN emp_backup1.salary%TYPE,
        p_comm_pct   IN emp_backup1.commission_pct%TYPE,
        p_manager_id IN emp_backup1.manager_id%TYPE,
        p_dept_id    IN emp_backup1.department_id%TYPE,
        p_status     OUT VARCHAR2,
        p_error      OUT VARCHAR2
    ) IS
    BEGIN
        p_status := 'S';
        UPDATE emp_backup1
        SET
            first_name = nvl(p_fname, first_name),
            last_name = nvl(p_lname, last_name),
            phone_number = nvl(p_phone, phone_number),
            hire_date = nvl(p_hire_date, hire_date),
            job_id = nvl(p_job_id, job_id),
            salary = nvl(p_sal, salary),
            commission_pct = p_comm_pct,
            manager_id = nvl(p_manager_id, manager_id),
            department_id = nvl(p_dept_id, department_id)
        WHERE
            employee_id = p_emp_id;
commit;
    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || ' - '
                       || 'ERROR IN UPDATING THE ROW'
                       || sqlcode
                       || ' - '
                       || sqlerrm;

    END update_data;

/******************************
REPORT PROCEDURE
******************************/
    PROCEDURE report_print (
        p_emp_id     IN emp_backup1.employee_id%TYPE,
        p_fname      IN emp_backup1.first_name%TYPE,
        p_lname      IN emp_backup1.last_name%TYPE,
        p_phone      IN emp_backup1.phone_number%TYPE,
        p_hire_date  IN emp_backup1.hire_date%TYPE,
        p_job_id     IN emp_backup1.job_id%TYPE,
        p_sal        IN emp_backup1.salary%TYPE,
        p_comm_pct   IN emp_backup1.commission_pct%TYPE,
        p_manager_id IN emp_backup1.manager_id%TYPE,
        p_dept_id    IN emp_backup1.department_id%TYPE,
        p_status     IN VARCHAR2,
        p_error      IN VARCHAR2
    ) IS
    BEGIN
/***********************************
COLUMN NAME PRINT
***********************************/
    DBMS_OUTPUT.PUT_LINE(RPAD('EMPLOYEE ID',15,' ')||' | '||RPAD('FIRST NAME',15,' ')||' | '||RPAD('LAST NAME',15,' ')||' | '||RPAD('PHONE NUMBER',15,' ')||
    ' | '||RPAD('HIRE DATE',15,' ')||' | '||RPAD('JOB ID',15,' ')||' | '||RPAD('SALARY',15,' ')||' | '||RPAD('COMMISSION PCT',15,' ')||' | '||RPAD('MANAGER ID',
    5,' ')||' | '||RPAD('DEPARTMENT ID',5,' ')||' | '||RPAD('STATUS',10,' ')||' | '||RPAD('ERROR',1000));
/***********************************
COLUMN VALUE PRINT
***********************************/
    DBMS_OUTPUT.PUT_LINE(RPAD(P_EMP_ID,15,' ')||' | '||RPAD(P_FNAME,15,' ')||' | '||RPAD(P_LNAME,15,' ')||' | '||RPAD(P_PHONE,15,' ')||
    ' | '||RPAD(P_HIRE_DATE,15,' ')||' | '||RPAD(P_JOB_ID,15,' ')||' | '||RPAD(P_SAL,15,' ')||' | '||RPAD(P_COMM_PCT,15,' ')||' | '||RPAD(P_MANAGER_ID,
    5,' ')||' | '||RPAD(P_DEPT_ID,5,' ')||' | '||RPAD(P_STATUS,10,' ')||' | '||RPAD(P_ERROR,1000));
    
    END REPORT_PRINT;
/*******************************************************
MAIN PROCEDURE FOR CALLING  INSERT AND UPDATE AND VALIDATION EMP_BACKUP TABLE
********************************************************/
    PROCEDURE main_emp (
        p_emp_id     IN emp_backup1.employee_id%TYPE,
        p_fname      IN emp_backup1.first_name%TYPE,
        p_lname      IN emp_backup1.last_name%TYPE,
        p_phone      IN emp_backup1.phone_number%TYPE,
        p_hire_date  IN emp_backup1.hire_date%TYPE,
        p_job_id     IN emp_backup1.job_id%TYPE,
        p_sal        IN emp_backup1.salary%TYPE,
        p_comm_pct   IN emp_backup1.commission_pct%TYPE,
        p_manager_id IN emp_backup1.manager_id%TYPE,
        p_dept_id    IN emp_backup1.department_id%TYPE
--        p_status     OUT VARCHAR2,
--        p_error      OUT VARCHAR2
    ) IS
        ln_count_emp NUMBER;
        lc_status VARCHAR2(20);
        lc_error VARCHAR2(1000);
    BEGIN
--        dbms_output.put_line(rpad('EMPLOYEE ID IS', 20, ' ')
--                             || ' : '
--                             || p_emp_id);
--
--        dbms_output.put_line(rpad('FIRST NAME IS', 20, ' ')
--                             || ' : '
--                             || p_fname);
--
--        dbms_output.put_line(rpad('LAST NAME IS', 20, ' ')
--                             || ' : '
--                             || p_lname);
--
--        dbms_output.put_line(rpad('PHONE NUMBER IS', 20, ' ')
--                             || ' : '
--                             || p_phone);
--
--        dbms_output.put_line(rpad('HIRE DATE IS', 20, ' ')
--                             || ' : '
--                             || p_hire_date);
--
--        dbms_output.put_line(rpad('JOB ID IS', 20, ' ')
--                             || ' : '
--                             || p_job_id);
--
--        dbms_output.put_line(rpad('SALARY IS', 20, ' ')
--                             || ' : '
--                             || p_sal);
--
--        dbms_output.put_line(rpad('COMMISSION IS', 20, ' ')
--                             || ' : '
--                             || p_comm_pct);
--
--        dbms_output.put_line(rpad('MANAGER ID IS', 20, ' ')
--                             || ' : '
--                             || p_manager_id);
--
--        dbms_output.put_line(rpad('DEPARTMENT ID IS', 20, ' ')
--                             || ' : '
--                             || p_dept_id);

        IF p_emp_id IS NULL THEN
            lc_status := 'E';
            lc_error := 'EMPLOYEE ID CAN NOT BE NULL';
        ELSE
            SELECT
                COUNT(*)
            INTO ln_count_emp
            FROM
                emp_backup1
            WHERE
                employee_id = p_emp_id;

            IF ln_count_emp = 0 THEN
                insert_validate_data(p_emp_id, p_fname, p_lname, p_phone, p_hire_date,
                                    p_job_id, p_sal, p_comm_pct, p_manager_id, p_dept_id,
                                    lc_status, lc_error);

                IF lc_status = 'V' THEN
                    insert_data(p_emp_id, p_fname, p_lname, p_phone, p_hire_date,
                               p_job_id, p_sal, p_comm_pct, p_manager_id, p_dept_id,
                               lc_status, lc_error);

                END IF;

            ELSE
                update_validate_data(p_emp_id, p_fname, p_lname, p_phone, p_hire_date,
                                    p_job_id, p_sal, p_comm_pct, p_manager_id, p_dept_id,
                                    lc_status, lc_error);

                IF lc_status = 'V' THEN
                    update_data(p_emp_id, p_fname, p_lname, p_phone, p_hire_date,
                               p_job_id, p_sal, p_comm_pct, p_manager_id, p_dept_id,
                               lc_status, lc_error);

                END IF;

            END IF;

        END IF;
                            report_print(p_emp_id, p_fname, p_lname, p_phone, p_hire_date,
                               p_job_id, p_sal, p_comm_pct, p_manager_id, p_dept_id,
                               lc_status, lc_error);

    EXCEPTION
        WHEN OTHERS THEN
            lc_status := 'E';
            lc_error := lc_error
                       || ' - '
                       || ' ERROR IN MAIN PROC'
                       || sqlcode
                       || ' - '
                       || sqlerrm;

    END main_emp;

/*********************************************
VALID PROCEDURE FOR inserting DEPT_BACKUP1 TABLES CLOUMN
*********************************************/
    PROCEDURE insert_validate_dept (
        p_dept_id     IN dept_backup1.department_id%TYPE,
        p_dept_name   IN dept_backup1.department_name%TYPE,
        p_manager_id  IN dept_backup1.manager_id%TYPE,
        p_location_id IN dept_backup1.location_id%TYPE,
        p_status      OUT VARCHAR2,
        p_error       OUT VARCHAR2
    ) IS
        ln_count_dept_id   NUMBER;
        ln_employee_id     NUMBER;
        ln_location_id     NUMBER;
        lc_count_dept_name VARCHAR2(50);
    BEGIN
        p_status := 'V';
/********************
VALIDATION FOR DEPARMTENT ID
*********************/
IF P_DEPT_ID IS NULL THEN
                p_status := 'E';
                p_error := p_error
                           || ' - '
                           || 'DEPARTMENT ID CAN NOT BE NULL';
            END IF;

/********************************
VALIDATION FOR DEPARTMENT NAME
********************************/
        IF p_dept_name IS NULL THEN
            p_status := 'E';
            p_error := p_error
                       || ' - '
                       || 'DEPARTMENT NAME CAN NOT BE NULL';
        ELSE
            SELECT
                COUNT(1)
            INTO lc_count_dept_name
            FROM
                dept_backup1
            WHERE
                department_name = p_dept_name;

            IF lc_count_dept_name > 0 THEN
                p_status := 'E';
                p_error := p_error
                           || ' - '
                           || 'DEPARTMENT NAME IS ALREADY EXISTS';
            END IF;

        END IF;

/************************************
VALIDATION OF MANAGER ID
*************************************/
        IF p_manager_id IS NOT NULL THEN
            BEGIN
                SELECT
                    employee_id
                INTO ln_employee_id
                FROM
                    emp_backup1
                WHERE
                    employee_id = p_manager_id;

            EXCEPTION
                WHEN OTHERS THEN
                    p_status := 'E';
                    p_error := p_error
                               || ' - '
                               || 'MANAGER ID DOES NOT EXISTS IN EMPLOYEE TABLE';
            END;
        END IF;
/**************************************
VALIDATION OF LOCATION ID
**************************************/
        BEGIN
            SELECT
                location_id
            INTO ln_location_id
            FROM
                locations
            WHERE
                location_id = p_location_id;

        EXCEPTION
            WHEN OTHERS THEN
                p_status := 'E';
                p_error := p_error
                           || ' - '
                           || 'LOCATION ID DOES NOT EXISTS IN LOCATION TABLE';
        END;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || ' - '
                       || sqlcode
                       || ' - '
                       || sqlerrm;
    END insert_validate_dept;
    
 /********************************************************
VALID PROCEDURE FOR UPDATE DEPT_BACKUP1 TABLES CLOUMN
*********************************************************/
    PROCEDURE update_validate_dept (
        p_dept_id     IN dept_backup1.department_id%TYPE,
        p_dept_name   IN dept_backup1.department_name%TYPE,
        p_manager_id  IN dept_backup1.manager_id%TYPE,
        p_location_id IN dept_backup1.location_id%TYPE,
        p_status      OUT VARCHAR2,
        p_error       OUT VARCHAR2
    ) IS
        lc_dept_name   VARCHAR2(50);
        ln_manager_id  NUMBER;
        ln_location_id NUMBER;
    BEGIN
        p_status := 'V';
/****************************************
VALIDATE DEPARTMENT NAME
****************************************/
        IF p_dept_name IS NOT NULL THEN
            SELECT
               count(1)
            INTO lc_dept_name
            FROM
                dept_backup1
            WHERE
                department_name = p_dept_name;

            IF lc_dept_name >0 THEN
                p_status := 'E';
                p_error := p_error
                           || ' - '
                           || 'DEPARTMENT NAME IS ALREADY EXIST';
            END IF;

        END IF;
/****************************************
VALIDATE MANAGER ID
****************************************/
        IF p_manager_id IS NOT NULL THEN
        BEGIN
            SELECT
                employee_id
            INTO ln_manager_id
            FROM
                emp_backup1
            WHERE
                employee_id = p_manager_id;
EXCEPTION WHEN OTHERS THEN
                p_status := 'E';
                p_error := p_error
                           || ' - '
                           || 'MANAGER ID DOES NOT EXIST';
         END;
        END IF;
/****************************************
VALIDATE LOCATON ID
****************************************/
        IF p_location_id IS NOT NULL THEN
        BEGIN
            SELECT
                location_id
            INTO ln_location_id
            FROM
                locations
            WHERE
                location_id = p_location_id;
EXCEPTION WHEN OTHERS THEN
                p_status := 'E';
                p_error := p_error
                           || ' - '
                           || 'LOCATION ID DOES NOT EXIST';
                 END;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || ' - '
                       || sqlcode
                       || ' - '
                       || sqlerrm;
    END update_validate_dept;
/***************************************************
PROCEDURE TO UPDATE VALUE FOR DEPT_BACKUP1 TABLE
************************************************/
    PROCEDURE update_dept (
        p_dept_id     IN dept_backup1.department_id%TYPE,
        p_dept_name   IN dept_backup1.department_name%TYPE,
        p_manager_id  IN dept_backup1.manager_id%TYPE,
        p_location_id IN dept_backup1.location_id%TYPE,
        p_status      OUT VARCHAR2,
        p_error       OUT VARCHAR2
    ) IS
    BEGIN
        p_status := 'S';
        UPDATE dept_backup1
        SET
            department_id = nvl(p_dept_id, department_id),
            department_name = nvl(p_dept_name, department_name),
            manager_id = nvl(p_manager_id, manager_id),
            location_id = nvl(p_location_id, location_id)
        WHERE
            department_id = p_dept_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || 'ERROR IN UPDATING'
                       || ' - '
                       || sqlcode
                       || ' - '
                       || sqlerrm;

    END update_dept;
/************************************************
PROCEDURE TO INSERT FOR DEPT_BACKUP1
************************************************/
    PROCEDURE insert_dept (
        p_dept_id     IN dept_backup1.department_id%TYPE,
        p_dept_name   IN dept_backup1.department_name%TYPE,
        p_manager_id  IN dept_backup1.manager_id%TYPE,
        p_location_id IN dept_backup1.location_id%TYPE,
        p_status      OUT VARCHAR2,
        p_error       OUT VARCHAR2
    ) IS
    BEGIN
        p_status := 'S';
        INSERT INTO dept_backup1 (
            department_id,
            department_name,
            manager_id,
            location_id
        ) VALUES (
            p_dept_id,
            p_dept_name,
            p_manager_id,
            p_location_id
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || ' - '
                       || ' ERROR IN INSERTING DATA'
                       || sqlcode
                       || ' - '
                       || sqlerrm;

    END insert_dept;
/***************************************************************
MAIN PROCEDURE TO CALL VALIDATE,INSERT PROCE. INTO DEPT_BACKUP1 
***************************************************************/
    PROCEDURE main_dept (
        p_dept_id     IN dept_backup1.department_id%TYPE,
        p_dept_name   IN dept_backup1.department_name%TYPE,
        p_manager_id  IN dept_backup1.manager_id%TYPE,
        p_location_id IN dept_backup1.location_id%TYPE,
        p_status      OUT VARCHAR2,
        p_error       OUT VARCHAR2
    ) IS
        ln_count_dept_id NUMBER;
    BEGIN
        dbms_output.put_line(rpad('DEPARTMENT ID IS', 25, ' ')
                             || ' - '
                             || p_dept_id);

        dbms_output.put_line(rpad('DEPARTMENT NAME IS', 25, ' ')
                             || ' - '
                             || p_dept_name);

        dbms_output.put_line(rpad('MANAGER ID IS', 25, ' ')
                             || ' - '
                             || p_manager_id);

        dbms_output.put_line(rpad('LOCATION ID IS', 25, ' ')
                             || ' - '
                             || p_location_id);

        IF p_dept_id IS NULL THEN
            p_status := 'E';
            p_error := 'DEPARTMENT ID CAN NOT BE NULL';
        ELSE
            SELECT
                COUNT(1)
            INTO ln_count_dept_id
            FROM
                dept_backup1
            WHERE
                department_id = p_dept_id;

            IF ln_count_dept_id = 0 THEN
                insert_validate_dept(p_dept_id, p_dept_name, p_manager_id, p_location_id, p_status,
                                    p_error);
                IF p_status = 'V' THEN
                    insert_dept(p_dept_id, p_dept_name, p_manager_id, p_location_id, p_status,
                               p_error);
                END IF;

            ELSE
                update_validate_dept(p_dept_id, p_dept_name, p_manager_id, p_location_id, p_status,
                                    p_error);
                IF p_status = 'V' THEN
                    update_dept(p_dept_id, p_dept_name, p_manager_id, p_location_id, p_status,
                               p_error);
                END IF;

            END IF;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || ' - '
                       || ' ERROR IN MAIN BODY'
                       || sqlcode
                       || ' - '
                       || sqlerrm;

    END main_dept;
    
/***********************************
INSERT VALIDATION OF LOCATION
***********************************/
    PROCEDURE insert_validate_loc (
        p_loc_id         IN loc_backup1.location_id%TYPE,
        p_street_add     IN loc_backup1.street_address%TYPE,
        p_postal_code    IN loc_backup1.postal_code%TYPE,
        p_city           IN loc_backup1.city%TYPE,
        p_state_province IN loc_backup1.state_province%TYPE,
        p_country_id     IN loc_backup1.country_id%TYPE,
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2
    ) IS
        lc_country_id VARCHAR2(10);
    BEGIN
        p_status := 'V';
/*************************************
VALIDATION FOR LOCATION ID
*************************************/
        IF p_loc_id IS NULL THEN
            p_status := 'E';
            p_error := p_error
                       || ' - '
                       || 'LOCATION ID CAN NOT BE NULL';
        END IF;
/***************************************
VALIDATION FOR POSTAL CODE
***************************************/
        IF length(p_postal_code) > 6 THEN
            p_status := 'E';
            p_error := p_error
                       || ' - '
                       || 'LENGTH OF POST CODE CAN NOT BE GREATER THAN 6 DIGIT';
        END IF;
/***************************************
VALIDATION FOR CITY
***************************************/
        IF p_city IS NULL THEN
            p_status := 'E';
            p_error := 'CITY COLUMN CAN NOT BE NULL';
        END IF;
/***************************************
VALIDATION FOR COUNTRY ID
***************************************/
        IF p_country_id IS NULL THEN
            p_status := 'E';
            p_error := p_error
                       || ' - '
                       || 'COUNTRY ID CAN NOT BE NULL';
        ELSE
            BEGIN
                SELECT
                    country_id
                INTO lc_country_id
                FROM
                    countries
                WHERE
                    country_id = p_country_id;

            EXCEPTION
                WHEN OTHERS THEN
                    p_status := 'E';
                    p_error := p_error
                               || ' - '
                               || 'COUNTRY ID DOES NOT EXIST';
            END;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || ' - '
                       || sqlcode
                       || ' - '
                       || sqlerrm;
    END insert_validate_loc;
       
/***********************************
INSERT PROCEDURE IN LOCATION TABLE
***********************************/
    PROCEDURE insert_loc (
        p_loc_id         IN loc_backup1.location_id%TYPE,
        p_street_add     IN loc_backup1.street_address%TYPE,
        p_postal_code    IN loc_backup1.postal_code%TYPE,
        p_city           IN loc_backup1.city%TYPE,
        p_state_province IN loc_backup1.state_province%TYPE,
        p_country_id     IN loc_backup1.country_id%TYPE,
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2
    ) IS
    BEGIN
        p_status := 'S';
        INSERT INTO loc_backup1 (
            location_id,
            street_address,
            postal_code,
            city,
            state_province,
            country_id
        ) VALUES (
            p_loc_id,
            p_street_add,
            p_postal_code,
            p_city,
            p_state_province,
            p_country_id
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := 'ERROR IN INSERT'
                       || ' - '
                       || sqlcode
                       || ' - '
                       || sqlerrm;
    END insert_loc;
    
/***********************************
UPDATE VALIDATION PROCEDURE OF LOCATION
***********************************/
    PROCEDURE update_validate_loc (
        p_loc_id         IN loc_backup1.location_id%TYPE,
        p_street_add     IN loc_backup1.street_address%TYPE,
        p_postal_code    IN loc_backup1.postal_code%TYPE,
        p_city           IN loc_backup1.city%TYPE,
        p_state_province IN loc_backup1.state_province%TYPE,
        p_country_id     IN loc_backup1.country_id%TYPE,
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2
    ) IS
        lc_country_id VARCHAR2(10);
    BEGIN
        p_status := 'V';
/************************************
VALIDATION FOR POSTAL CODE
************************************/
        IF p_postal_code IS NOT NULL THEN
            IF length(p_postal_code) > 6 THEN
                p_status := 'E';
                p_error := p_error
                           || ' - '
                           || 'POST CODE CAN NOT BE GREATER THAN 6 DIGITS';
            END IF;

        END IF;

/************************************
VALIDATION FOR COUNTRY ID
************************************/
        IF p_country_id IS NOT NULL THEN
            BEGIN
                SELECT
                    country_id
                INTO lc_country_id
                FROM
                    countries
                WHERE
                    country_id = p_country_id;

            EXCEPTION
                WHEN OTHERS THEN
                    p_status := 'E';
                    p_error := p_error
                               || ' - '
                               || 'COUNTRY ID DOES NOT EXIST';
            END;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || ' - '
                       || 'ERROR IN UPDATE VALIDATION'
                       || sqlcode
                       || ' - '
                       || sqlerrm;

    END update_validate_loc;
       
/***********************************
UPDATE  PROCEDURE OF LOCATION
***********************************/
    PROCEDURE update_loc (
        p_loc_id         IN loc_backup1.location_id%TYPE,
        p_street_add     IN loc_backup1.street_address%TYPE,
        p_postal_code    IN loc_backup1.postal_code%TYPE,
        p_city           IN loc_backup1.city%TYPE,
        p_state_province IN loc_backup1.state_province%TYPE,
        p_country_id     IN loc_backup1.country_id%TYPE,
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2
    ) IS
    BEGIN
        p_status := 'S';
        UPDATE loc_backup1
        SET
            location_id = nvl(p_loc_id, location_id),
            street_address = nvl(p_street_add, street_address),
            postal_code = nvl(p_postal_code, postal_code),
            city = nvl(p_city, city),
            state_province = nvl(p_state_province, state_province),
            country_id = nvl(p_country_id, country_id)
        WHERE
            location_id = p_loc_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || 'ERROR IN UPDATING'
                       || ' - '
                       || sqlcode
                       || ' - '
                       || sqlerrm;

    END update_loc;
/***********************************
MAIN PROCEDURE FOR LOCATION TABLE
***********************************/
    PROCEDURE main_loc (
        p_loc_id         IN loc_backup1.location_id%TYPE,
        p_street_add     IN loc_backup1.street_address%TYPE,
        p_postal_code    IN loc_backup1.postal_code%TYPE,
        p_city           IN loc_backup1.city%TYPE,
        p_state_province IN loc_backup1.state_province%TYPE,
        p_country_id     IN loc_backup1.country_id%TYPE,
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2
    ) IS
        ln_loc_id NUMBER;
    BEGIN
        dbms_output.put_line(rpad('LOCATION ID IS', 25, ' ')
                             || ' - '
                             || p_loc_id);

        dbms_output.put_line(rpad('STREET ADDRESS IS', 25, ' ')
                             || ' - '
                             || p_street_add);

        dbms_output.put_line(rpad('POSTAL CODE IS', 25, ' ')
                             || ' - '
                             || p_postal_code);

        dbms_output.put_line(rpad('city IS', 25, ' ')
                             || ' - '
                             || p_city);

        dbms_output.put_line(rpad('STATE PROVINCE', 25, ' ')
                             || ' - '
                             || p_state_province);

        dbms_output.put_line(rpad('COUNTRY ID IS', 25, ' ')
                             || ' - '
                             || p_country_id);

        IF p_loc_id IS NULL THEN
            p_status := 'E';
            p_error := 'LOCATION ID CAN NOT BE NULL';
        ELSE
            SELECT
                COUNT(1)
            INTO ln_loc_id
            FROM
                loc_backup1
            WHERE
                location_id = p_loc_id;

            IF ln_loc_id = 0 THEN
                insert_validate_loc(p_loc_id, p_street_add, p_postal_code, p_city, p_state_province,
                                   p_country_id, p_status, p_error);

                IF p_status = 'V' THEN
                    insert_loc(p_loc_id, p_street_add, p_postal_code, p_city, p_state_province,
                              p_country_id, p_status, p_error);

                END IF;

            ELSE
                update_validate_loc(p_loc_id, p_street_add, p_postal_code, p_city, p_state_province,
                                   p_country_id, p_status, p_error);

                IF p_status = 'V' THEN
                    update_loc(p_loc_id, p_street_add, p_postal_code, p_city, p_state_province,
                              p_country_id, p_status, p_error);

                END IF;

            END IF;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := 'UNEXPECTED ERROR IN MAIN PROC'
                       || ' - '
                       || sqlcode
                       || ' - '
                       || sqlerrm;
    END main_loc;

/******************************************
VALIDATE INSERT PROCEDURE FOR COUNTRIES
******************************************/
    PROCEDURE insert_validate_cou (
        p_country_id   IN cou_backup1.country_id%TYPE,
        p_country_name IN cou_backup1.country_name%TYPE,
        p_region_id    IN cou_backup1.region_id%TYPE,
        p_status       OUT VARCHAR2,
        p_error        OUT VARCHAR2
    ) IS
        ln_region_id NUMBER;
    BEGIN
        p_status := 'V';
/*******************************
VALIDATION FOR COUNTRY ID
*******************************/
        IF p_country_id IS NULL THEN
            p_status := 'E';
            p_error := 'COUNTRY ID CAN NOT BE NULL';
            IF length(p_country_id) > 2 THEN
                p_status := 'E';
                p_error := p_error || 'LENGTH CAN NOT BE GREATER THAN 2 CHAR';
            END IF;

        END IF;
/*******************************
VALIDATION FOR REGION ID
*******************************/
        BEGIN
            SELECT
                region_id
            INTO ln_region_id
            FROM
                regions
            WHERE
                region_id = p_region_id;

        EXCEPTION
            WHEN OTHERS THEN
                p_status := 'E';
                p_error := 'REGION ID DOES NOT EXIST'
                           || ' - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
        END;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || ' - '
                       || 'ERROR IN INSERT VALIDATION'
                       || sqlcode
                       || ' - '
                       || sqlerrm;

    END insert_validate_cou;
       
/******************************************
INSERT PROCEDURE FOR COUNTRIES
******************************************/
    PROCEDURE insert_cou (
        p_country_id   IN cou_backup1.country_id%TYPE,
        p_country_name IN cou_backup1.country_name%TYPE,
        p_region_id    IN cou_backup1.region_id%TYPE,
        p_status       OUT VARCHAR2,
        p_error        OUT VARCHAR2
    ) IS
    BEGIN
        p_status := 'S';
        INSERT INTO cou_backup1 (
            country_id,
            country_name,
            region_id
        ) VALUES (
            p_country_id,
            p_country_name,
            p_region_id
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := 'ERROR IN INSERTING'
                       || ' - '
                       || sqlcode
                       || ' - '
                       || sqlerrm;
    END insert_cou;
       
/******************************************
VALIDATE UPDATE PROCEDURE FOR COUNTRIES
******************************************/
    PROCEDURE update_validate_cou (
        p_country_id   IN cou_backup1.country_id%TYPE,
        p_country_name IN cou_backup1.country_name%TYPE,
        p_region_id    IN cou_backup1.region_id%TYPE,
        p_status       OUT VARCHAR2,
        p_error        OUT VARCHAR2
    ) IS
        ln_region_id NUMBER;
    BEGIN
        p_status := 'V';
/****************************
VALIDATE COUNTRY ID
****************************/
        IF length(p_country_id) > 2 THEN
            p_status := 'E';
            p_error := p_error || 'LENGTH CAN NOT BE GREATER THAN 2 CHAR';
        END IF;

/*******************************
VALIDATION FOR REGION ID
*******************************/
        IF p_region_id IS NOT NULL THEN
            BEGIN
                SELECT
                    region_id
                INTO ln_region_id
                FROM
                    regions
                WHERE
                    region_id = p_region_id;

            EXCEPTION
                WHEN OTHERS THEN
                    p_status := 'E';
                    p_error := p_error
                               || 'REGION ID DOES NOT EXIST'
                               || ' - '
                               || sqlcode
                               || ' - '
                               || sqlerrm;

            END;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || ' - '
                       || 'ERROR IN UPDATE VALIDATION'
                       || sqlcode
                       || ' - '
                       || sqlerrm;

    END update_validate_cou;
       
/******************************************
UPDATE PROCEDURE FOR COUNTRIES
******************************************/
    PROCEDURE update_cou (
        p_country_id   IN cou_backup1.country_id%TYPE,
        p_country_name IN cou_backup1.country_name%TYPE,
        p_region_id    IN cou_backup1.region_id%TYPE,
        p_status       OUT VARCHAR2,
        p_error        OUT VARCHAR2
    ) IS
    BEGIN
        p_status := 'S';
        UPDATE cou_backup1
        SET
            country_id = nvl(p_country_id, country_id),
            country_name = nvl(p_country_name, country_name),
            region_id = nvl(p_region_id, region_id)
        WHERE
            country_id = p_country_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || ' - '
                       || 'ERROR IN UPDATE'
                       || sqlcode
                       || ' - '
                       || sqlerrm;

    END update_cou;
/***********************************
MAIN PROCEDURE FOR COUNTRIES TABLE
***********************************/
    PROCEDURE main_cou (
        p_country_id   IN cou_backup1.country_id%TYPE,
        p_country_name IN cou_backup1.country_name%TYPE,
        p_region_id    IN cou_backup1.region_id%TYPE,
        p_status       OUT VARCHAR2,
        p_error        OUT VARCHAR2
    ) IS
        lc_country_id VARCHAR2(10);
    BEGIN
        dbms_output.put_line(rpad('COUNTRY ID IS', 25, ' ')
                             || ' - '
                             || p_country_id);

        dbms_output.put_line(rpad('COUNTRY NAME IS', 25, ' ')
                             || ' - '
                             || p_country_name);

        dbms_output.put_line(rpad('REGION ID IS', 25, ' ')
                             || ' - '
                             || p_region_id);

        IF p_country_id IS NULL THEN
            p_status := 'E';
            p_error := 'COUNTRY ID CAN NOT BE NULL';
        ELSE
            SELECT
                COUNT(1)
            INTO lc_country_id
            FROM
                cou_backup1
            WHERE
                country_id = p_country_id;

            IF lc_country_id = 0 THEN
                insert_validate_cou(p_country_id, p_country_name, p_region_id, p_status, p_error);
                IF p_status = 'V' THEN
                    insert_cou(p_country_id, p_country_name, p_region_id, p_status, p_error);
                END IF;

            ELSE
                update_validate_cou(p_country_id, p_country_name, p_region_id, p_status, p_error);
                IF p_status = 'V' THEN
                    update_cou(p_country_id, p_country_name, p_region_id, p_status, p_error);
                END IF;

            END IF;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || ' - '
                       || sqlcode
                       || ' - '
                       || sqlerrm;
    END main_cou;

/***********************************
INSERT VALIDATION FOR REGIONS TABLE
***********************************/
    PROCEDURE insert_validate_reg (
        p_region_id   IN reg_backup1.region_id%TYPE,
        p_region_name IN reg_backup1.region_name%TYPE,
        p_status      OUT VARCHAR2,
        p_error       OUT VARCHAR2
    ) IS
    BEGIN
        p_status := 'V';
/******************************
VALIDATE REGION ID
******************************/
        IF p_region_id IS NULL THEN
            p_status := 'E';
            p_error := 'REGION ID CAN NOT BE NULL';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || 'UNEXPECTED ERROR IN INSERT VALIDATION'
                       || sqlcode
                       || ' - '
                       || sqlerrm;
    END insert_validate_reg;
       
/***********************************
INSERT FOR REGIONS TABLE
***********************************/
    PROCEDURE insert_reg (
        p_region_id   IN reg_backup1.region_id%TYPE,
        p_region_name IN reg_backup1.region_name%TYPE,
        p_status      OUT VARCHAR2,
        p_error       OUT VARCHAR2
    ) IS
    BEGIN
        p_status := 'S';
        INSERT INTO reg_backup1 (
            region_id,
            region_name
        ) VALUES (
            p_region_id,
            p_region_name
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || 'UNEXPECTED ERROR IN INSERTING'
                       || sqlcode
                       || ' - '
                       || sqlerrm;
    END insert_reg;
       
/***********************************
UPDATE VALIDATION FOR REGIONS TABLE
***********************************/
    PROCEDURE update_validate_reg (
        p_region_id   IN reg_backup1.region_id%TYPE,
        p_region_name IN reg_backup1.region_name%TYPE,
        p_status      OUT VARCHAR2,
        p_error       OUT VARCHAR2
    ) IS
        lc_count_region_name VARCHAR2(40);
    BEGIN
        p_status := 'V';
/******************************
VALIDATE REGION NAME
******************************/
        IF p_region_name IS NOT NULL THEN
            SELECT
                COUNT(1)
            INTO lc_count_region_name
            FROM
                reg_backup1
            WHERE
                region_name = p_region_name;

            IF lc_count_region_name = 1 THEN
                p_status := 'E';
                p_error := 'SAME REGION NAME CAN NOT BE MORE THAN 1';
            END IF;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || 'UNEXPECTED ERROR IN UPDATE VALIDATION'
                       || sqlcode
                       || ' - '
                       || sqlerrm;
    END update_validate_reg;
       
/***********************************
UPDATE VALIDATION FOR REGIONS TABLE
***********************************/
    PROCEDURE update_reg (
        p_region_id   IN reg_backup1.region_id%TYPE,
        p_region_name IN reg_backup1.region_name%TYPE,
        p_status      OUT VARCHAR2,
        p_error       OUT VARCHAR2
    ) IS
        lc_count_region_name VARCHAR2(40);
    BEGIN
        p_status := 'S';
        UPDATE reg_backup1
        SET
            region_id = nvl(p_region_id, region_id),
            region_name = nvl(p_region_name, region_name)
        WHERE
            region_id = p_region_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || 'UNEXPECTED ERROR IN UPDATING'
                       || sqlcode
                       || ' - '
                       || sqlerrm;
    END update_reg;
/***********************************
MAIN SPECK FOR REGIONS TABLE
***********************************/
    PROCEDURE main_reg (
        p_region_id   IN reg_backup1.region_id%TYPE,
        p_region_name IN reg_backup1.region_name%TYPE,
        p_status      OUT VARCHAR2,
        p_error       OUT VARCHAR2
    ) IS
        ln_count_region_id NUMBER;
    BEGIN
        dbms_output.put_line(rpad('REGION ID IS', 25, ' ')
                             || ' - '
                             || p_region_id);

        dbms_output.put_line(rpad('REGION NAME IS', 25, ' ')
                             || ' - '
                             || p_region_name);

        IF p_region_id IS NULL THEN
            p_status := 'E';
            p_error := 'REGION ID CAN NOT BE NULL';
        ELSE
            SELECT
                COUNT(1)
            INTO ln_count_region_id
            FROM
                reg_backup1
            WHERE
                region_id = p_region_id;

            IF ln_count_region_id = 0 THEN
                insert_validate_reg(p_region_id, p_region_name, p_status, p_error);
                IF p_status = 'V' THEN
                    insert_reg(p_region_id, p_region_name, p_status, p_error);
                END IF;

            ELSE
                update_validate_reg(p_region_id, p_region_name, p_status, p_error);
                IF p_status = 'V' THEN
                    update_reg(p_region_id, p_region_name, p_status, p_error);
                END IF;

            END IF;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || 'UNEXPECTED ERROR IN MAIN'
                       || sqlcode
                       || ' - '
                       || sqlerrm;
    END main_reg;
END xx_ver_inst_data_api;



