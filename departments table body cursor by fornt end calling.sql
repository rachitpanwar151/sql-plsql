create or replace package body  xxintg_departments_rp
as
procedure departments_dtls
as
cursor cur_dept(p_dept_id departments.department_id%type)
is
select  * from departments where department_id=p_dept_id;
begin
for rec_dept in cur_dept(90) 
loop
fnd_file.put_line(fnd_file.log,rec_dept.department_id||' '||rec_dept.department_name||' '||rec_dept.location_id||
' '||rec_dept.manager_id);
fnd_file.put_line(fnd_file.output,rec_dept.department_id||' '||rec_dept.department_name||' '||rec_dept.location_id||
' '||rec_dept.manager_id);
end loop;

end departments_dtls;
procedure main_procedure ( errbuff out varchar2 , reetcode out varchar2)
as
begin
departments_dtls;
end main_procedure;

end xxintg_departments_rp;

