CREATE OR REPLACE PACKAGE BODY proce AS
/************************************************************************************************************************************************************

package body to validatee_insert and validate_update the data FROM xxintg_emp_rp

WHO                          VERSION                             WHEN                                           WHY              
RACHIT PANWAR                1.0.0                               30-JUNE-2023                          TO MAKE A PROCEDURE SPEC FOR VALIDATION AND UPDATION

************************************************************************************************************************************************************/

    gn_count    NUMBER ;
/***************************************************************************************************************************************

PROCEDURE TO VALIDATE OUR INSERTED VALUES

****************************************************************************************************************************************/
    PROCEDURE validate_insert (
        p_emp_id   IN xxintg_emp_rp.employee_id%TYPE,
        p_fname    IN xxintg_emp_rp.first_name%TYPE,
        p_lname    IN xxintg_emp_rp.last_name%TYPE,
        p_email    IN xxintg_emp_rp.email%TYPE,
        p_phno     IN xxintg_emp_rp.phone_number%TYPE,
        p_hdate    IN xxintg_emp_rp.hire_date%TYPE,
        p_job_id   IN jobs.job_id%TYPE,
        p_salary   IN xxintg_emp_rp.salary%TYPE,
        p_comm_pct IN xxintg_emp_rp.commission_pct%TYPE,
        p_mgr_id   IN xxintg_emp_rp.manager_id%TYPE,
        p_dept_id  IN departments.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    ) AS
    BEGIN

    DBMS_OUTPUT.PUT_LINE('STARTING VALIDATE INSERT');
    p_status := 'V';
/*******************************
EMPLOYEE ID VALIDATE
*******************************/
 
        IF p_emp_id IS NULL THEN
            p_status := 'E';
            p_error := 'employee_id cant be null';
        ELSE
            
                SELECT
                    COUNT(*)
                INTO gn_count
                FROM
                    xxintg_emp_rp
                WHERE
                    employee_id = p_emp_id;

                IF gn_count > 0 THEN
                    p_status := 'E';
                end if;
        END IF;

/*******************************
FIRST NAME VALIDATE
*******************************/
     IF p_fname IS NULL THEN
        p_status := 'E';
        p_error := p_error || ' || name cant be null';
    else 
	IF length(p_fname) > 20 THEN
        p_status := 'E';
        p_error := p_error || ' || length of first_name cant be greater than 20';
   
	END IF;
end if;

/*******************************
LAST NAME VALIDATE
*******************************/
    
    IF p_lname IS NULL THEN
        p_status := 'E';
        p_error := p_error || ' || last name cant be null';
    else
	IF length(p_lname) > 20 THEN
        p_status := 'E';
        p_error := p_error || ' || length of last name cant be greater than 20';
	end if;
	END IF;

/*******************************
EMAIL VALIDATE
*******************************/

        IF p_email IS NULL THEN
            p_status := 'E';
            p_error := p_error || ' || email cant be null';
              ELSIF inSTR(P_EMAIL,'@')=0
              THEN
               p_status := 'E';
     p_error := p_error || ' || email should have ATLEAST 1 @ SIGN';
        END IF;

/*******************************
PHONE VALIDATE
*******************************/
        IF p_phno IS NULL THEN
            p_status := 'E';
            p_error := p_error || ' || phone number cannot be null';
        ELSIF length(p_phno) <> 10 THEN
            p_status := 'E';
            p_error := p_error || ' || length of phno must be of 10 digits';
        END IF;

/*******************************
HIREDATE VALIDATE
*******************************/

        IF p_hdate IS NULL THEN
            p_status := 'E';
            p_error := p_error || ' | hire date cant be null';
            ELSE
			if trunc(p_hdate)<trunc(sysdate) then
            p_status:='E';
            p_error:=p_error||' || hiredate day can not be a back date';
            END IF;
end if;
/*******************************
JOB ID  VALIDATE
*******************************/

        IF p_job_id IS NULL THEN
            p_status := 'E';
            p_error := p_error || ' job id cannot be null';
		else
select count(*) into gn_count from jobs where lower(job_id)=lower(p_job_id);
if gn_count  =0 then
P_STATUS:='E';
P_ERROR:=P_ERROR||' || Job ID doesnt exist';
end if;		
        END IF;
        
/*******************************
SALARY VALIDATE
*******************************/
        IF p_salary IS NULL THEN
            p_status := 'E';
            p_error := p_error || ' || SALARY CANNOT BE NULL';
        ELSIF p_salary < 5000 THEN
            p_status := 'E';
            p_error := p_error || ' || SALARY CANNOT BE LESS THEN 5000';
        END IF;

/*******************************
COMMISSION PCT VALIDATE
*******************************/

IF p_comm_pct not between 0 and 1 THEN
            p_status := 'E';
            p_error := p_error || ' || COMMISSION PCT MUST BE BETWEEN 0 AND 1';
        END IF;

/*******************************
MANAGER ID VALIDATE
*******************************/

        IF p_mgr_id is null THEN
            p_status := 'E';
            p_error := p_error || ' || manager id CANNOT BE NEGATIVVE';
        else 
		 select count(*) into gn_count from xxintg_emp_rp where employee_id=p_mgr_id;
		 if gn_count =0 then
		  p_status := 'E';
            p_error := p_error || ' || manager must be an employee first';
		 end if;
		END IF;

/*******************************
DEPARTMENT ID VALIDATE
*******************************/

        IF p_dept_id IS NULL THEN
            p_status := 'E';
            p_error := p_error || ' || department is  CANNOT BE Null';
			else 
		 select count(*) into gn_count from DEPARTMENTs where DEPARTMENT_id=p_dept_id;
		 if gn_count =0 then
		  p_status := 'E';
            p_error := p_error || ' || department id doesnt exist';
		 end if;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_error := p_error
                       || 'Error in validating Data'
                       || ' - '
                       || sqlcode
                       || ' - '
                       || sqlerrm;

    END validate_insert;         

/**************************************************************************************************************************************************

PROCEDURE  TO VALIDARE OUR UPDATED VALUE

*************************************************************************************************************************************************/

    PROCEDURE validate_update (
        p_emp_id   IN xxintg_emp_rp.employee_id%TYPE,
        p_fname    IN xxintg_emp_rp.first_name%TYPE,
        p_lname    IN xxintg_emp_rp.last_name%TYPE,
        p_email    IN xxintg_emp_rp.email%TYPE,
        p_phno     IN xxintg_emp_rp.phone_number%TYPE,
        p_hdate    IN xxintg_emp_rp.hire_date%TYPE,
        p_job_id   IN jobs.job_id%TYPE,
        p_salary   IN xxintg_emp_rp.salary%TYPE,
        p_comm_pct IN xxintg_emp_rp.commission_pct%TYPE,
        p_mgr_id   IN xxintg_emp_rp.manager_id%TYPE,
        p_dept_id  IN departments.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    ) AS
    BEGIN
    DBMS_OUTPUT.PUT_LINE('STARTING VALIDATE UPDATE');
/*******************************
updated EMPLOYEE ID VALIDATE
*******************************/
 
        IF p_emp_id IS NULL THEN
            p_status := 'E';
            p_error := 'employee_id cant be null';
        ELSE
            
                SELECT
                    COUNT(*)
                INTO gn_count
                FROM
                    xxintg_emp_rp
                WHERE
                    employee_id = p_emp_id;

                IF gn_count > 0 THEN
                    p_status := 'E';
                end if;
        END IF;

/******************************
updated FIRST NAME VALIDATE
*******************************/
     IF p_fname IS NULL THEN
        p_status := 'E';
        p_error := p_error || ' || name cant be null';
    else 
	IF length(p_fname) > 20 THEN
        p_status := 'E';
        p_error := p_error || ' || length of first_name cant be greater than 20';
   
	END IF;
end if;

/*******************************
updated LAST NAME VALIDATE
*******************************/
    
    IF p_lname IS NULL THEN
        p_status := 'E';
        p_error := p_error || ' || last name cant be null';
    else
	IF length(p_lname) > 20 THEN
        p_status := 'E';
        p_error := p_error || ' || length of last name cant be greater than 20';
	end if;
	END IF;

/*******************************
updated EMAIL VALIDATE
*******************************/

        IF p_email IS NULL THEN
            p_status := 'E';
            p_error := p_error || ' || email cant be null';
              ELSIF inSTR(P_EMAIL,'@')=0
              THEN
               p_status := 'E';
     p_error := p_error || ' || email should have ATLEAST 1 @ SIGN';
        END IF;

/*******************************
updated PHONE VALIDATE
*******************************/
        IF p_phno IS NULL THEN
            p_status := 'E';
            p_error := p_error || ' || phone number cannot be null';
        ELSIF length(p_phno) <> 10 THEN
            p_status := 'E';
            p_error := p_error || ' || length of phno must be of 10 digits';
        END IF;

/*******************************
updated HIREDATE VALIDATE
*******************************/

        IF p_hdate IS NULL THEN
            p_status := 'E';
            p_error := p_error || ' | hire date cant be null';
            ELSE
			if trunc(p_hdate)<trunc(sysdate) then
            p_status:='E';
            p_error:=p_error||' || hiredate day can not be a back date';
            END IF;
end if;
/*******************************
updated JOB ID  VALIDATE
*******************************/

        IF p_job_id IS NULL THEN
            p_status := 'E';
            p_error := p_error || ' job id cannot be null';
		else
select count(*) into gn_count from jobs where lower(job_id)=lower(p_job_id);
if gn_count  =0 then
P_STATUS:='E';
P_ERROR:=P_ERROR||' || Job ID doesnt exist';
end if;		
        END IF;
        
/*******************************
updated SALARY VALIDATE
*******************************/
        IF p_salary IS NULL THEN
            p_status := 'E';
            p_error := p_error || ' || SALARY CANNOT BE NULL';
        ELSIF p_salary < 5000 THEN
            p_status := 'E';
            p_error := p_error || ' || SALARY CANNOT BE LESS THEN 5000';
        END IF;

/*******************************
updated COMMISSION PCT VALIDATE
*******************************/

IF p_comm_pct not between 0 and 1 THEN
            p_status := 'E';
            p_error := p_error || ' || COMMISSION PCT MUST BE BETWEEN 0 AND 1';
        END IF;

/*******************************
updated MANAGER ID VALIDATE
*******************************/

        IF p_mgr_id is null THEN
            p_status := 'E';
            p_error := p_error || ' || manager id CANNOT BE NEGATIVVE';
        else 
		 select count(*) into gn_count from xxintg_emp_rp where employee_id=p_mgr_id;
		 if gn_count =0 then
		  p_status := 'E';
            p_error := p_error || ' || manager must be an employee first';
		 end if;
		END IF;

/*******************************
updated DEPARTMENT ID VALIDATE
*******************************/

        IF p_dept_id IS NULL THEN
            p_status := 'E';
            p_error := p_error || ' || department is  CANNOT BE Null';
			else 
		 select count(*) into gn_count from DEPARTMENTs where DEPARTMENT_id=p_dept_id;
		 if gn_count =0 then
		  p_status := 'E';
            p_error := p_error || ' || department id doesnt exist';
		 end if;
end if;
    END validate_update;
/**********************************************************************************************************************************************

PROCEDURE TO LOAD OUR DATA IN DATABASE

************************************************************************************************************************************************/

    PROCEDURE load_data_insert (
        p_emp_id   IN xxintg_emp_rp.employee_id%TYPE,
        p_fname    IN xxintg_emp_rp.first_name%TYPE,
        p_lname    IN xxintg_emp_rp.last_name%TYPE,
        p_email    IN xxintg_emp_rp.email%TYPE,
        p_phno     IN xxintg_emp_rp.phone_number%TYPE,
        p_hdate    IN xxintg_emp_rp.hire_date%TYPE,
        p_job_id   IN jobs.job_id%TYPE,
        p_salary   IN xxintg_emp_rp.salary%TYPE,
        p_comm_pct IN xxintg_emp_rp.commission_pct%TYPE,
        p_mgr_id   IN xxintg_emp_rp.manager_id%TYPE,
        p_dept_id  IN departments.department_id%TYPE) AS
    BEGIN
    
    DBMS_OUTPUT.PUT_LINE('LOAD DATA INSERT');

        INSERT INTO xxintg_emp_rp
		(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id) 
		VALUES (
         p_emp_id,p_fname,p_lname,P_EMAIL,p_phno,p_hdate,p_job_id,p_salary,p_comm_pct,p_mgr_id,p_dept_id   
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
		rollback;
		DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.format_error_backtrace);
            p_status := 'E';
            p_error := p_error
                       || sqlcode
                       || sqlerrm;
    END load_data_insert;

/*************************************************************************************************************************************

PROCEDURE TO LOAD OUR UPDATED DATA

******************************************************************************************************************************************/
    PROCEDURE load_data_updte (
        p_emp_id   IN xxintg_emp_rp.employee_id%TYPE,
        p_fname    IN xxintg_emp_rp.first_name%TYPE,
        p_lname    IN xxintg_emp_rp.last_name%TYPE,
        p_email    IN xxintg_emp_rp.email%TYPE,
        p_phno     IN xxintg_emp_rp.phone_number%TYPE,
        p_hdate    IN xxintg_emp_rp.hire_date%TYPE,
        p_job_id   IN jobs.job_id%TYPE,
        p_salary   IN xxintg_emp_rp.salary%TYPE,
        p_comm_pct IN xxintg_emp_rp.commission_pct%TYPE,
        p_mgr_id   IN xxintg_emp_rp.manager_id%TYPE,
        p_dept_id  IN departments.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    ) AS
    BEGIN
    
    DBMS_OUTPUT.PUT_LINE('LOAD DATA UPDATE');

        IF p_status = 'E' THEN
            p_error := p_error || 'data cant be update';
        ELSE
            UPDATE xxintg_emp_rp
            SET
                employee_id = nvl(employee_id, p_emp_id),
                first_name = nvl(first_name, p_fname),
                last_name = nvl(last_name, p_lname),
                email = nvl(email, p_email),
                phone_number = nvl(phone_number, p_phno),
                hire_date = nvl(hire_date, p_hdate),
                job_id = nvl(job_id, p_job_id),
                salary = nvl(salary, p_salary),
                commission_pct = nvl(commission_pct, p_comm_pct),
                manager_id = nvl(manager_id, p_mgr_id),
                department_id = nvl(department_id, p_dept_id);

        END IF;
    END load_data_updte;

/***************************************************************************************************************************************

MAIN PROCEDURE

********************************************************************************************************************************************/

    PROCEDURE main (
        p_emp_id   IN xxintg_emp_rp.employee_id%TYPE,
        p_fname   IN xxintg_emp_rp.first_name%TYPE,
        p_lname  IN  xxintg_emp_rp.last_name%TYPE,
        p_email  IN  xxintg_emp_rp.email%TYPE,
        p_phno   IN  xxintg_emp_rp.phone_number%TYPE,
        p_hdate   IN xxintg_emp_rp.hire_date%TYPE,
        p_job_id  IN jobs.job_id%TYPE,
        p_salary IN  xxintg_emp_rp.salary%TYPE,
        p_comm_pct IN xxintg_emp_rp.commission_pct%TYPE,
        p_mgr_id IN  xxintg_emp_rp.manager_id%TYPE,
        p_dept_id IN departments.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    ) AS
    BEGIN
        
        DBMS_OUTPUT.PUT_LINE('MAIN PROCEDURE');


--checking condiction and calling validate
        IF p_emp_id IS NOT NULL THEN
            validate_insert(p_emp_id, p_fname, p_lname, p_email, p_phno,
                           p_hdate, p_job_id, p_salary, p_comm_pct, p_mgr_id,
                           p_dept_id, p_status, p_error);
						   DBMS_OUTPUT.put_line('Data validation completed');
                           IF P_STATUS ='V'
                           THEN 
DBMS_OUTPUT.put_line('Loading Data into xxintg_emp_rp');
        --calling of inserting the data
      load_data_insert (
        p_emp_id  ,
        p_fname   ,
        p_lname   ,
        p_email   ,
        p_phno    ,
        p_hdate    ,
        p_job_id   ,
        p_salary   ,
        p_comm_pct ,
        p_mgr_id   ,
        p_dept_id, p_status,
        p_error);
        END IF;
       ELSE
            validate_update(p_emp_id, p_fname, p_lname, p_email, p_phno,
                           p_hdate, p_job_id, p_salary, p_comm_pct, p_mgr_id,
                           p_dept_id, p_status, p_error);
                           IF P_STATUS='V'
                           THEN
                           load_data_updte (
        p_emp_id  ,
        p_fname ,
        p_lname ,
        p_email ,
        p_phno  ,
        p_hdate ,
        p_job_id  ,
        p_salary  ,
        p_comm_pct ,
        p_mgr_id   ,
        p_dept_id ,
        p_status    ,
        p_error    
    ) ;
                  ELSE
                  P_ERROR:=P_ERROR||SQLCODE||SQLERRM;
        END IF; 
        end if;
        EXCEPTION
    WHEN OTHERS THEN
        p_status := 'E';
        p_error := p_error
                   || sqlcode
                   || sqlerrm;
END main;
END proce;


-------------------------------end---------------------------------------------------

declare
p_status varchar2(50);
p_error varchar2(4000);

begin
proce.load_data_insert( 208,'dipanshu','shukla', 'd.shukla','123.456.345.1','07-jun-2001','HR_REP', 5600,0.3,100,110,p_status,p_error);
end;
