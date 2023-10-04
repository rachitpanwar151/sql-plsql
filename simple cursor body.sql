create or replace package body pckg_par_cur
as
  procedure mainn
  as
cursor curemp(p_dept_id in varchar2 )
is 
select * from employees where department_id=p_dept_id;
rec_emp curemp%rowtype;
begin
open curemp(50);
loop 
fetch curemp into rec_emp;
exit when curemp%notfound;
dbms_output.put_line(rec_emp.employee_id||' '||rec_emp.first_name||' '||rec_emp.department_id);
end loop;
close curemp;
end mainn;
end pckg_par_cur;

----------------------------------
begin
pckg_par_cur.mainn();
end;