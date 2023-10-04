create or replace package body xxing_updation_through_cursor
as
procedure print_parameter(p_dept_id VARCHAR2 ,p_percentage_inc VARCHAR2)
as
begin
dbms_output.put_line(rpad('department_id',20));
dbms_output.put_line(rpad('increased percentage',20));
end print_parameter;
procedure update_salary(P_DEPT_ID EMPLOYEES.DEPARTMENT_ID%TYPE,p_percentage_inc EMPLOYEES.SALARY%TYPe)
as
cursor c1
is 
select * from employees where department_id=p_dept_id;
begin
for r1 in c1
loop
dbms_output.put_line(r1.employee_id);
dbms_output.put_line(r1.salary);
update employees set salary= r1.salary+(r1.salary+0.1)
where employee_id=r1.employee_id;
end loop;
COMMIT;
end update_salary;
procedure reportt(P_DEPT_ID VARCHAR2)
as
CURSOR C2
IS
SELECT   e.salary new_salary ,ee.salary  old_salary
from employees e,emp_cur_new_table ee 
where e.employee_id=ee.employee_id
AND E.DEPARTMENT_ID=P_DEPT_ID;
BEGIN
FOR R2 IN C2
LOOP
DBMS_OUTPUT.PUT_LINE(r2.new_salary);
DBMS_OUTPUT.PUT_LINE(r2.old_salary);
END LOOP;
end reportt;
procedure main_procedure(p_dept_id employees.department_id%type, p_percentage_inc varchar2)
as
begin
print_parameter(p_dept_id ,p_percentage_inc );
update_salary(P_DEPT_ID,p_percentage_inc);
reportt(P_DEPT_ID);
end main_procedure;
end xxing_updation_through_cursor;

--------------------------------------------------------------------------------

BEGIN
xxing_updation_through_cursor.main_procedure(50,10);
END;