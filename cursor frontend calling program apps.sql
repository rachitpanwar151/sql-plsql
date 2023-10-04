create or replace procedure xxintg_cursor_emp_data_rp(errbuff out varchar2,retcode out varchar2)
as
cursor cur_emp_data
is
select * from employees;
begin
for rec_data in cur_emp_data
loop
fnd_file.put_line(fnd_file.log,rec_data.first_name);
fnd_file.put_line(fnd_file.log,rec_data.last_name);
fnd_file.put_line(fnd_file.output,rec_data.first_name);
fnd_file.put_line(fnd_file.output,rec_data.last_name);
end loop;
end xxintg_cursor_emp_data_rp;