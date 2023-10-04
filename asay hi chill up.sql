 set serveroutput on;
 
  declare
  a number:=10;
  b number:=20;
  c number;
  begin
  c:=a+b;
  dbms_output.put_line(c);
  end;
  
  declare 
  v_sal employees.salary%type;
  begin
  select salary into v_sal  from employees where employee_id=101;
  dbms_output.put_line(v_sal) ;
  end;
  
   
   declare
   cursor c1 
   is
   select employee_id, first_name from employees order by 1;
   v_eid employees.employee_id%type;
   v_efn employees.first_name%type;
   begin
   open c1;
   loop 
   fetch c1 into v_eid,v_efn;
   dbms_output.put_line(v_eid||' '|| v_efn);
   exit when c1 %notfound;
   end loop;
   close c1;
   end; 