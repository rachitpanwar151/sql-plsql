
CREATE OR REPLACE PACKAGE body  proce 
AS
/************************************************************************************************************************************************************

package body to validatee_insert and validate_update the data

WHO                          VERSION                             WHEN                                           WHY              
RACHIT PANWAR                1.0.0                               30-JUNE-2023                          TO MAKE A PROCEDURE SPEC FOR VALIDATION AND UPDATION

************************************************************************************************************************************************************/


GN_COUNT NUMBER:=0;
gn_hiredate date;

/***************************************************************************************************************************************

PROCEDURE TO VALIDATE OUR INSERTED VALUES

****************************************************************************************************************************************/
   PROCEDURE validate_insert (
        p_emp_id   IN employees.employee_id%TYPE,
        p_fname in    employees.first_name%TYPE,
        p_lname  in  employees.last_name%TYPE,
        p_email   in employees.email%TYPE,
        p_phno   in  employees.phone_number%TYPE,
        p_hdate   in employees.hire_date%TYPE,
        p_job_id  in employees.job_id%TYPE,
        p_salary in  employees.salary%TYPE,
        p_comm_pct in employees.commission_pct%TYPE,
        p_mgr_id  in employees.manager_id%TYPE,
        p_dept_id in employees.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    ) AS    
  BEGIN
   P_STATUS :='V';
 
    begin
    IF p_emp_id IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'employee_id cant be null';
            ELSE
                IF p_emp_id < 0 THEN
                    p_status := 'e';
                    p_error := p_error || ' employee_id should be greater than zero';
                ELSE
                    SELECT COUNT(*) into gn_count  FROM  employees where employee_id=p_emp_id;
                    IF gn_count > 0 THEN
                        p_status := 'e';
                        p_error := p_error || 'duplicate value you cant take duplicate value';
                    END IF;

                END IF;
            END IF;
        END;

        BEGIN
            IF length(p_fname) > 20 THEN
                p_status := 'e';
                p_error := p_error || 'length of first_name cant be greater than 20';
            ELSE
                IF p_fname IS NULL THEN
                    p_status := 'e';
                    p_error := p_error || 'name cant be null';
                END IF;
            END IF;
        END;
        BEGIN
            IF length(p_lname) > 20 THEN
                p_status := 'e';
                p_error := p_error || 'lemgth of last name cant be greater than 20';
            ELSE
                IF p_lname IS NULL THEN
                    p_status := 'e';
                    p_error := p_error || 'last name cant be null';
                END IF;
            END IF;
        END;

        BEGIN
            IF p_email IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'email cant be null';
            ELSE
                IF instr(p_email, '.') = 1 THEN
                    p_status := 'e';
                    p_error := p_error || 'email should have only 1 dot';
                END IF;
            END IF;
        END;

        BEGIN
            IF p_phno IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'phone number cannot be null';
            ELSE
                IF length(p_phno) > 10 THEN
                    p_status := 'e';
                    p_error := p_error || ' length of phno cant be greater than 10';
                END IF;
            END IF;
        END;

        BEGIN
            IF p_hdate IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'hire date cant be null';
            END IF;
        END;

        BEGIN
            IF p_job_id IS NULL THEN
                p_status := 'e';
                p_error := p_error || ' job id cannot be null';
            END IF;
        END;

        BEGIN
            IF p_salary IS NULL THEN
                p_status := 'e';
                p_error := p_error || ' SALARY CANNOT BE NULL';
            ELSE
                IF p_salary < 5000 THEN
                    p_status := 'E';
                    p_error := p_error || ' SALARY CANNOT BE LESS THEN 5000';
                END IF;
            END IF;
        END;

        BEGIN
            IF p_comm_pct < 0 THEN
                p_status := 'E';
                p_error := p_error || 'COMMISSION PCT CANNOT BE NEGATIVVE';
            END IF;
        END;
        BEGIN
        if p_mgr_id <0
        then
         p_status := 'E';
                p_error := p_error || 'manager id CANNOT BE NEGATIVVE';
             end if;      
         end;
         begin
         
         if  p_dept_id is null then
          p_status := 'E';
                p_error := p_error || 'department is  CANNOT BE Null';
         end if;
         end;
    end validate_insert;         

/**************************************************************************************************************************************************

PROCEDURE  TO VALIDARE OUR UPDATED VALUE

*************************************************************************************************************************************************/

PROCEDURE validate_update (
        p_emp_id   IN employees.employee_id%TYPE,
        p_fname    employees.first_name%TYPE,
        p_lname    employees.last_name%TYPE,
        p_email    employees.email%TYPE,
        p_phno     employees.phone_number%TYPE,
        p_hdate    employees.hire_date%TYPE,
        p_job_id   employees.job_id%TYPE,
        p_salary   employees.salary%TYPE,
        p_comm_pct employees.commission_pct%TYPE,
        p_mgr_id   employees.manager_id%TYPE,
        p_dept_id  employees.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    )
    as
     begin
     
   begin
    IF p_emp_id IS NULL 
    THEN
    
                p_status := 'e';
                p_error := p_error || 'employee_id cant be null';
            ELSE
                IF p_emp_id < 0 THEN
                    p_status := 'e';
                    p_error := p_error || ' employee_id should be greater than zero';
                ELSE
                    SELECT COUNT(*) into gn_count  FROM  employees where employee_id=p_emp_id;
                    IF gn_count > 0 THEN
                        p_status := 'e';
                        p_error := p_error || 'duplicate value you cant take duplicate value';
                    END IF;

                END IF;
            END IF;
        END;

        BEGIN
            IF length(p_fname) > 20 THEN
                p_status := 'e';
                p_error := p_error || 'length of first_name cant be greater than 20';
            ELSE
                IF p_fname IS NULL THEN
                    p_status := 'e';
                    p_error := p_error || 'name cant be null';
                END IF;
            END IF;
end;
       

        BEGIN
            IF length(p_lname) > 20 THEN
                p_status := 'e';
                p_error := p_error || 'lemgth of last name cant be greater than 20';
            ELSE
                IF p_lname IS NULL THEN
                    p_status := 'e';
                    p_error := p_error || 'last name cant be null';
                END IF;
            END IF;
        END;

        BEGIN
            IF p_email IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'email cant be null';
            ELSE
                IF instr(p_email, '.') = 1 THEN
                    p_status := 'e';
                    p_error := p_error || 'email should have only 1 dot';
                END IF;
            END IF;
        END;
        BEGIN
            IF p_phno IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'phone number cannot be null';
            ELSE
                IF length(p_phno) > 10 THEN
                    p_status := 'e';
                    p_error := p_error || ' length of phno cant be greater than 10';
                END IF;
            END IF;
        END;
        BEGIN
           SELECT COUNT(1) into gn_count FROM EMPLOYEES WHERE EMPLOYEE_ID=P_EMP_ID;
           IF gn_count>1 THEN 
           p_status := 'e';
                p_error := p_error || 'hire date cant be CHANGED';
            END IF;
        END;

        BEGIN
            IF p_job_id IS NULL THEN
                p_status := 'e';
                p_error := p_error || ' job id cannot be null';
            END IF;
        END;

        BEGIN
            IF p_salary IS NULL THEN
                p_status := 'e';
                p_error := p_error || ' SALARY CANNOT BE NULL';
            ELSE
                IF p_salary < 5000 THEN
                    p_status := 'E';
                    p_error := p_error || ' SALARY CANNOT BE LESS THEN 5000';
                END IF;
            END IF;
        END;

        BEGIN
            IF p_comm_pct < 0 THEN
                p_status := 'E';
                p_error := p_error || 'COMMISSION PCT CANNOT BE NEGATIVVE';
            END IF;
        END;
        BEGIN
        if p_mgr_id <0
        then
         p_status := 'E';
                p_error := p_error || 'manager id CANNOT BE GATIVVE';
             end if;      
         end;
         begin
         
         if  p_dept_id is null then
          p_status := 'E';
                p_error := p_error || 'department is  CANNOT BE Null';
           
         end if;
         end;
     end validate_update;
/**********************************************************************************************************************************************

PROCEDURE TO LOAD OUR DATA IN DATABASE

************************************************************************************************************************************************/

 PROCEDURE load_data_insert (
        p_emp_id   IN employees.employee_id%TYPE,
        p_fname    employees.first_name%TYPE,
        p_lname    employees.last_name%TYPE,
        p_email    employees.email%TYPE,
        p_phno     employees.phone_number%TYPE,
        p_hdate    employees.hire_date%TYPE,
        p_job_id   employees.job_id%TYPE,
        p_salary   employees.salary%TYPE,
        p_comm_pct employees.commission_pct%TYPE,
        p_mgr_id   employees.manager_id%TYPE,
        p_dept_id  employees.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    )
    as
    begin
       IF P_STATUS='E'
   THEN
   P_ERROR:=P_ERROR||'DATA CANT INSERT ';
   ELSE 
   INSERT INTO  EMPLOYEES(  
    employee_id ,
    first_name   ,
        last_name    ,
        email    ,
        phone_number     ,
        hire_date    ,
        job_id   ,
        salary   ,
        commission_pct ,
        manager_id   ,
        department_id   ) VALUES(
   p_emp_id , 
   p_fname , 
   p_lname
   , p_email
   ,p_phno,
        p_hdate   ,
        p_job_id     ,
        p_salary     ,
        p_com_pct    ,
        p_mgr_id ,
        p_dept_id      );
   COMMIT;
   END IF;
   
   EXCEPTION  WHEN OTHERS THEN 
   P_STATUS:='E';
   P_ERROR:=P_ERROR||SQLCODE||SQLERRM;
   
end load_data_insert;

/*************************************************************************************************************************************

PROCEDURE TO LOAD OUR UPDATED DATA

******************************************************************************************************************************************/

PROCEDURE load_date_updte (
        p_emp_id   IN employees.employee_id%TYPE,
        p_fname    employees.first_name%TYPE,
        p_lname    employees.last_name%TYPE,
        p_email    employees.email%TYPE,
        p_phno     employees.phone_number%TYPE,
        p_hdate    employees.hire_date%TYPE,
        p_job_id   employees.job_id%TYPE,
        p_salary   employees.salary%TYPE,
        p_comm_pct employees.commission_pct%TYPE,
        p_mgr_id   employees.manager_id%TYPE,
        p_dept_id  employees.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    )
    as 
    begin
    if p_status='e'
         then 
         P_ERROR:=P_ERROR||'data cant be update';
         ELSE
         update employees set employee_id=nvl(employee_id,p_emp_id),
     first_name=nvl(first_name,p_fname),
     last_name=nvl(last_name,p_lname),
     email=nvl(email,p_email),
     phone_number=nvl(phone_number,p_phno),
     hire_date=nvl(hire_date,p_hdate),
     job_id=nvl(job_id,p_job_id),
          salary=nvl(salary,p_salary),
     commission_pct=nvl(commission_pct,p_comm_pct),
     manager_id=nvl(manager_id,p_mgr_id),
     department_id=nvl(department_id,p_dept_id);
     end IF;
     END load_date_updte;

/***************************************************************************************************************************************

MAIN PROCEDURE

********************************************************************************************************************************************/

PROCEDURE main (
        p_emp_id   IN employees.employee_id%TYPE,
        p_fname    employees.first_name%TYPE,
        p_lname    employees.last_name%TYPE,
        p_email    employees.email%TYPE,
        p_phno     employees.phone_number%TYPE,
        p_hdate    employees.hire_date%TYPE,
        p_job_id   employees.job_id%TYPE,
        p_salary   employees.salary%TYPE,
        p_comm_pct employees.commission_pct%TYPE,
        p_mgr_id   employees.manager_id%TYPE,
        p_dept_id  employees.department_id%TYPE,
        p_status   OUT VARCHAR,
        p_error    OUT VARCHAR
    )
    AS 
    BEGIN
        IF p_emp_id IS NULL THEN
        validate_insert(  
        p_emp_id  ,
        p_fname   ,
        p_lname    ,
        p_email    ,
        p_phno     ,
        p_hdate    ,
        p_job_id   ,
        p_salary   ,
        p_comm_pct ,
        p_mgr_id   ,
        p_dept_id  ,
        p_status   ,
        p_error    
);
    ELSE
        validate_update(
          
        p_emp_id  ,
        p_fname   ,
        p_lname    ,
        p_email    ,
        p_phno     ,
        p_hdate    ,
        p_job_id   ,
        p_salary   ,
        p_comm_pct ,
        p_mgr_id   ,
        p_dept_id  ,
        p_status   ,
        p_error    );
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        p_status := 'E';
        p_error := p_error
                   || sqlcode
                   || sqlerrm;
END main;
     END proce;