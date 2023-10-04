declare
cursor c1
is
select * from departments;
begin
for r1 in c1
loop
dbms_output.put_line(r1.department_id);
dbms_output.put_line(r1.department_name);
end loop;
end;


--------------nested loop
`
declare
cursor c1 
is 
select * from departments;
cursor c2(p_dept_id  varchar2)
is
select * from employees where department_id=p_dept_id;
begin
for r1 in c1
loop
dbms_output.put_line(r1.department_id||'  '||r1.department_name);
 for  r2 in c2(r1.department_id) 
 loop
 dbms_output.put_line(r2.first_name||'  '||r2.email||'  '||r2.phone_number);
 end loop;
 end loop;
 end;