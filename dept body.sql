create or replace package body xxintg_dept_rp
as
procedure proce_dept(p_dept_id departments.department_id%type)
as
cursor cur_dept
is 
select * from departments where department_id=p_dept_id;
begin
for rec_dept in cur_dept loop
fnd_file.put_line(fnd_file.output,rec_dept.department_id||' '||rec_dept.department_name||' '||
rec_dept.location_id||' '||rec_dept.manager_id);
end loop;
end proce_dept;




procedure main_procedure(errbuff out varchar2, reetcode out varchar2,p_department_id varchar2)
as
begin
proce_dept(p_department_id);
end main_procedure;
end xxintg_dept_rp
;