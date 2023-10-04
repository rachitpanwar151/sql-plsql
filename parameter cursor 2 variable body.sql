create or replace package body cur_par_2
as

/**********************************************
cur_par_2  package body
**************************************************/


/******************************************************************************************
version              when                   who               why
1.0                16-july-23            rachit panwar   to show how parameter cursoor work
*******************************************************************************************/

/**********************************
declaring  cursor
************************************/
cursor empdtl( p_dept_id in employees.department_id%type,
p_sal employees.salary%type)
is 
select * from employees where department_id=p_dept_id and salary>p_sal;
rec_dtl empdtl%rowtype;

/**********************************
main procedure
(************************************/


procedure mainn
as
begin
open empdtl(60,5000);
loop 
fetch empdtl into rec_dtl;
exit when  empdtl%notfound;
dbms_output.put_line(rec_dtl.employee_id||' '
||rec_dtl.first_name||' '||rec_dtl.salary||
' '||rec_dtl.phone_number|| 
' '||rec_dtl.department_id);
end loop ;
close empdtl;
exception when others then
dbms_output.put_line('error occured'||sqlcode);
end mainn;
end cur_par_2;
---------------------------------------------------------------------------------------------


begin
cur_par_2.mainn;
end;