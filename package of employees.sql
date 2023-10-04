create or replace package body xxintg_emp_dtls_pkg_RP
as
procedure  emp_dtls
as
cursor cur_emp(p_emp_id employees.employee_id%type)
is
select * from employees where employee_id<p_emp_id;
begin
for rec_emp in cur_emp(101)
loop 
fnd_file.put_line(fnd_file.log,rec_emp.employee_id||' '||rec_emp.first_name||' '|| rec_emp.last_name||'
 '||rec_emp.email||' '||rec_emp.phone_number);

fnd_file.put_line(fnd_file.output,rec_emp.employee_id||' '||rec_emp.first_name||' '|| rec_emp.last_name||'
 '||rec_emp.email||' '||rec_emp.phone_number);
 end loop;
 end emp_dtls;
 procedure main_procedure(errbuff out varchar2, reetcode out varchar2)
 as
 begin
 emp_dtls;
 end main_procedure;
 end xxintg_emp_dtls_pkg_RP;
 
 