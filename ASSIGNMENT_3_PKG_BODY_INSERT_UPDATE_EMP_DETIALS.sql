create or replace PACKAGE BODY xxintg_pkg_insert_and_update_data_emp AS


--UPDATE PROCEDURE 

PROCEDURE update_procedure (
        p_employee_id    IN employees.employee_id%TYPE,
        p_first_name     IN employees.first_name%TYPE,
        p_last_name      IN employees.last_name%TYPE,
        p_email          IN employees.email%TYPE,
        p_phone_number   IN employees.phone_number%TYPE,
        p_hire_date      IN employees.hire_date%TYPE,
        p_job_id         IN jobs.job_id%TYPE,
        p_salary         IN employees.salary%TYPE,
        p_commission_pct IN employees.commission_pct%TYPE,
        p_manager_id     IN employees.manager_id%TYPE,
        p_department_id  IN departments.department_id%TYPE
       
    )AS
    BEGIN

    UPDATE employees set email = nvl(p_email,email),
                        phone_number =  nvl(p_phone_number,phone_number),
                         salary = nvl(p_salary,salary),
                         job_id = nvl(p_job_id,job_id),
                         commission_pct = nvl(p_commission_pct,commission_pct), 
                         manager_id = nvl(p_manager_id,manager_id),
                         department_id = nvl(p_department_id,department_id)
    where employee_id=p_employee_id;


    exception when others then
    dbms_output.put_line('Error while updating data'||sqlcode||'-'||sqlerrm);


    END update_procedure;


-- INSERT PROCEDURE 

  PROCEDURE insert_procedure (
        p_employee_id    IN employees.employee_id%TYPE,
        p_first_name     IN employees.first_name%TYPE,
        p_last_name      IN employees.last_name%TYPE,
        p_email          IN employees.email%TYPE,
        p_phone_number   IN employees.phone_number%TYPE,
        p_hire_date      IN employees.hire_date%TYPE,
        p_job_id         IN jobs.job_id%TYPE,
        p_salary         IN employees.salary%TYPE,
        p_commission_pct IN employees.commission_pct%TYPE,
        p_manager_id     IN employees.manager_id%TYPE,
        p_department_id  IN departments.department_id%TYPE
    )
    as
    begin

    insert into employees values
    (p_employee_id,
     p_first_name,
     p_last_name,
     p_email,
     p_phone_number,
     p_hire_date,
     p_job_id,
     p_salary,
     p_commission_pct,
     p_manager_id,
     p_department_id);

    exception when others then
    dbms_output.put_line('error while loading data'||sqlcode||'-'||sqlerrm);
    dbms_output.put_line(dbms_utility.format_error_backtrace());

end insert_procedure;



--VALIDATE INSERT DATA

PROCEDURE validate_insert (
        p_employee_id    IN employees.employee_id%TYPE,
        p_first_name     IN employees.first_name%TYPE,
        p_last_name      IN employees.last_name%TYPE,
        p_email          IN employees.email%TYPE,
        p_phone_number   IN employees.phone_number%TYPE,
        p_hire_date      IN employees.hire_date%TYPE,
        p_job_id         IN jobs.job_id%TYPE,
        p_salary         IN employees.salary%TYPE,
        p_commission_pct IN employees.commission_pct%TYPE,
        p_manager_id     IN employees.manager_id%TYPE,
        p_department_id  IN departments.department_id%TYPE,
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2
    )AS


 begin
    p_status:='v';   
   --EMPLOYEE_ID VALIDATION.  
   dbms_output.put_line('debug massage 1');
            IF p_employee_id IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'employee_id cant be null';
            ELSE
                IF p_employee_id < 0 THEN
                    p_status := 'e';
                    p_error := p_error || ' employee_id should be greater than zero';
                ELSIF
                LENGTH(p_employee_id)>6 then
                p_status := 'e';
                    p_error := p_error || ' employee_id should be greater than zero';
                    else
                    SELECT COUNT(*) into gn_count  FROM  employees where employee_id=p_employee_id;
                    IF gn_count > 0 THEN
                        p_status := 'e';
                        p_error := p_error || 'you cant take duplicate value in employee_id';
                    END IF;
                END IF;
            END IF;

--first_name validation.

                IF p_first_name IS NULL THEN
                    p_status := 'e';
                    p_error := p_error || 'first_name cant be null';
                    elsif length(p_first_name) > 20 THEN
                p_status := 'e';
                p_error := p_error || 'length of first_name cant be greater than 20';

                END IF;

--last_name validation.
                IF p_last_name IS NULL THEN
                    p_status := 'e';
                    p_error := p_error || 'last_name cant be null';
                    elsif length(p_first_name) > 20 THEN
                p_status := 'e';
                p_error := p_error || 'length of last_name cant be greater than 20';

                END IF;

--email validation.        
            IF p_email IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'email cant be null';
            ELSE
                IF  instr(p_email,'@')=0 or instr(p_email,'com')=0 THEN
                    p_status := 'e';
                    p_error := p_error || 'INVALID EMAIL.';

                else
                select count(*) into gn_count from employees where email=p_email;
                if gn_count>1 then
                p_status := 'e';
                    p_error := p_error || 'EMAIL REPETED.';
                    END IF;
            END IF;
            END IF;


--phone number validation.
            IF p_phone_number IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'phone number can not be null';
              elsif length(p_phone_number)>10 then
              p_status := 'e';
                p_error := p_error || 'phone number can not be grater then 10';
              else
              select count(*) into gn_count from employees where phone_number = p_phone_number;
              IF gn_count > 0 THEN
                        p_status := 'e';
                        p_error := p_error || 'you cant take duplicate value in phone_number';
                    END IF;
                    end if;

--hire_date validation.

 IF p_hire_date IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'hire_date can not be null';
 elsif p_hire_date>sysdate then
                p_status := 'e';
                p_error := p_error || 'hire_date can not be null';

  /*elsif to_char(p_hire_date,'day') not in ('saturday','sunday') then
                p_status := 'e';
                p_error := p_error || 'employee should not be hire on saturday or sunday'; */
                end if;

--job_id validation.
IF p_job_id IS NULL THEN
                p_status := 'e';
                p_error := p_error || 'job_id can not be null';
else
select count(*) into gn_count from jobs where p_job_id = job_id;
IF gn_count = 0 THEN
                        p_status := 'e';
                        p_error := p_error || 'atleast one employee should be there in job';
                    END IF;
                    end if;
--salary validation.
if p_salary<10000 then
p_status := 'e';
                p_error := p_error || 'minimum salary is 10000.';
elsif length(p_salary)>8 then
p_status := 'e';
                p_error := p_error || 'salary range exceed';
end if;

--commission validation.
if p_commission_pct<0 then
p_status := 'e';
                p_error := p_error || 'commission can not be in negative.';
elsif p_commission_pct>50 then
p_status := 'e';
                p_error := p_error || 'commission limit exceed.';
end if;

--manager_id validation.
if length(p_manager_id)>3 then
p_status := 'e';
                p_error := p_error || 'length of manager_id is exceed.';
else
select count(*) into gn_count from employees where p_manager_id = employee_id;
if gn_count>1 then
p_status := 'e';
                p_error := p_error || 'manager employee_id should be 1.';
end if;
end if;
--department_id validation.
if length(p_department_id)>3 then
p_status := 'e';
                p_error := p_error || 'length of department_id is exceed.';
else
select count(*) into gn_count from departments where department_id = p_department_id;
if gn_count=0 then 
p_status := 'e';
                p_error := p_error || 'atlest one employee should be there in department.';
end if;

end if;
if(p_status = 'v')

then
    insert_procedure(p_employee_id,p_first_name,p_last_name,p_email,p_phone_number,p_hire_date,p_job_id,p_salary,p_commission_pct,
    p_manager_id,p_department_id);
end if;
END validate_INSERT;




--UPDATE VALIDATIONS


PROCEDURE validate_update (
        p_employee_id    IN employees.employee_id%TYPE,
        p_first_name     IN employees.first_name%TYPE,
        p_last_name      IN employees.last_name%TYPE,
        p_email          IN employees.email%TYPE,
        p_phone_number   IN employees.phone_number%TYPE,
        p_hire_date      IN employees.hire_date%TYPE,
        p_job_id         IN jobs.job_id%TYPE,
        p_salary         IN employees.salary%TYPE,
        p_commission_pct IN employees.commission_pct%TYPE,
        p_manager_id     IN employees.manager_id%TYPE,
        p_department_id  IN departments.department_id%TYPE,
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2
    )AS
    BEGIN
    p_status:='v';
--EMAIL UPDATE VALIDATION.
    IF  instr(p_email,'@')=0 or instr(p_email,'com')=0 THEN
                    p_status := 'e';
                    p_error := p_error || 'INVALID EMAIL.';

     else
                select count(*) into gn_count from employees where email=p_email;
                if gn_count>1 then
                p_status := 'e';
                    p_error := p_error || 'EMAIL REPETED.';
                    END IF;
            END IF;
--PHONE UPDATE VALIDATION.
    if length(p_phone_number)>10 then
              p_status := 'e';
                p_error := p_error || 'phone number can not be grater then 10';
              else
              select count(*) into gn_count from employees where phone_number = p_phone_number;
              IF gn_count > 0 THEN
                        p_status := 'e';
                        p_error := p_error || 'you cant take duplicate value in phone_number';
                    END IF;
                    end if;


 --JOB_ID VALIDATION.                  
select count(*) into gn_count from jobs where p_job_id = job_id;
IF gn_count = 0 THEN
                        p_status := 'e';
                        p_error := p_error || 'atleast one employee should be there in job';
                    END IF;   

--SALARY UPDATE VALIDATION
if p_salary<10000 then
p_status := 'e';
                p_error := p_error || 'minimum salary is 10000.';
elsif length(p_salary)>8 then
p_status := 'e';
                p_error := p_error || 'salary range exceed';
end if; 

--COMMISSION PCT UPDATE VALIDATION.
if p_commission_pct<0 then
p_status := 'e';
                p_error := p_error || 'commission can not be in negative.';
elsif p_commission_pct>0.5 then
p_status := 'e';
                p_error := p_error || 'commission limit exceed.';
end if;

----MANAGER_ID UPDATE VALIDATION.
if length(p_manager_id)>3 then
p_status := 'e';
                p_error := p_error || 'length of manager_id is exceed.';
else
select count(*) into gn_count from employees where p_manager_id = employee_id;
if gn_count>1 then
p_status := 'e';
                p_error := p_error || 'manager employee_id should be 1.';
end if;
end if;

----department_id validation.
if length(p_department_id)>3 then
p_status := 'e';
                p_error := p_error || 'length of department_id is exceed.';
else
select count(*) into gn_count from departments where department_id = p_department_id;
if gn_count=0 then 
p_status := 'e';
                p_error := p_error || 'atlest one employee should be there in department.';
end if;
end if;


if(p_status = 'v')

then
    update_procedure(p_employee_id,
                    p_first_name,
                    p_last_name,
                    p_email,
                    p_phone_number,
                    p_hire_date,
                    p_job_id,
                    p_salary,
                    p_commission_pct,
                    p_manager_id,
                    p_department_id);
end if;


END validate_update;


  PROCEDURE main_procedure (
        p_employee_id    IN employees.employee_id%TYPE,
        p_first_name     IN employees.first_name%TYPE,
        p_last_name      IN employees.last_name%TYPE,
        p_email          IN employees.email%TYPE,
        p_phone_number   IN employees.phone_number%TYPE,
        p_hire_date      IN employees.hire_date%TYPE,
        p_job_id         IN jobs.job_id%TYPE,
        p_salary         IN employees.salary%TYPE,
        p_commission_pct IN employees.commission_pct%TYPE,
        p_manager_id     IN employees.manager_id%TYPE,
        p_department_id  IN departments.department_id%TYPE,
        p_status         OUT VARCHAR2,
        p_error          OUT VARCHAR2
    )   
    as   
    begin
    select count(*) into gn_count from employees where p_employee_id = employee_id;
    if gn_count=0 then
    validate_insert(p_employee_id,    
        p_first_name,   
        p_last_name,    
        p_email,   
        p_phone_number, 
        p_hire_date, 
        p_job_id,
        p_salary,
        p_commission_pct ,
        p_manager_id,
        p_department_id,
        p_status,
        p_error );
     else
     validate_update(p_employee_id,    
        p_first_name,   
        p_last_name,    
        p_email,   
        p_phone_number, 
        p_hire_date, 
        p_job_id,
        p_salary,
        p_commission_pct ,
        p_manager_id,
        p_department_id,
        p_status,
        p_error);

        end if;

    end main_procedure;
END xxintg_pkg_insert_and_update_data_emp;





/*
declare
lc_status varchar2(200);
lc_error varchar2(200);
begin

xxintg_pkg_insert_and_update_data_emp.main_procedure(emp_id_seq.nextval,'somil','yadav','abc.singh@gmail.com','9415566311',sysdate,'AD_PRES',12324,0.4,100,20,lc_status,lc_error);
dbms_output.put_line(lc_status||'-'||nvl(lc_error,'sucess'));
end;


select * from employees;
select emp_id_seq.nextval from dual;

DESC EMPLOYEES; */
/* sequence created for inserting unique emp id.
create sequence emp_id_seq
increment by 1
minvalue 300
maxvalue 99999
nocache
nocycle;
*/

