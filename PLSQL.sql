select * from employees;
select * from countries;
select * from departments;
select * from jobs;
select * from job_history;
select * from locations;
select * from employees fetch  first 5 percent rows only;
select * from employees where job_id like '%A%';
select * from employees where department_id is null;
select * from employees order by employee_id desc ,salary asc;
select q'[i'm a boy and my name is rachit]' from dual;
select * from employees where department_id =&1;

declare 
n number;
begin
n:=&j;
dbms_output.put_line(n);
end;


declare
p number:=10;
q number:=20;
r number:=30;
s number;
begin
s:=mod((p*q*r),100);
dbms_output.put_line(s);
end;

declare
ln_m number;
ln_km number:=12;
begin
ln_m:=ln_km*1000;
dbms_output.put_line(ln_m);
end;

declare
a varchar2(20):='hi i am rachit ';
b varchar2(40):='i am a singer';
c varchar2(100);
begin
c:=a||b;
dbms_output.put_line(c);
end;

declare
ln_str varchar2(30):='RACHIT';
ln_rev varchar2(40);
begin
select reverse(ln_str) into ln_rev from dual;
dbms_output.put_line(ln_rev);
end;

declare
lc_str varchar2(30):='rachit';
lc_rev varchar2(30);
begin
for i in reverse 1..length(lc_str) loop
lc_rev:=lc_rev||substr(lc_str,i,1);
end loop;
dbms_output.put_line(lc_rev);
end;

***********************************************************************************************************************************



-- procedure of reversing string

create or replace procedure str_rev_proc ( lc_str in varchar2,lc_snd out varchar)
as 
begin
for i in reverse 1..length(lc_str) loop
lc_snd:=lc_snd||substr(lc_str,i,1);
end loop;
end str_rev_proc;


declare
n varchar2(20):='rachit';
r varchar2(20);
begin
str_rev_proc(n,r);
dbms_output.put_line(r);
end;

********************************************************************************************************************************


-- procedure of reversing number and palinfrome

create or replace procedure palindrome_proc (  p_n in number,p_rev out number)
as 
ln_rev number;
begin 
for i in reverse 1..length(p_n) loop
 ln_rev:=ln_rev||substr(p_n,i,1);
end loop;
p_rev:=ln_rev;
end palindrome_proc;


declare 
ln_reverse number;
begin
PALINDROME_PROC(1011,ln_reverse);
dbms_output.put_line('Reverse of 1011 : '||ln_reverse);
end;

*********************************************************************************************************************************



astric program


begin
for i in 1..5
loop 
for j in 1..i loop 
dbms_output.put('*');
end loop;
dbms_output.put_line(' ');
end loop;
end;


begin
for k in reverse 1..4 loop
for l in 1..k loop
dbms_output.put('*');
end loop;
dbms_output.put_line(' ');
end loop;
end ;


begin 
begin
for i in 1..5 loop
for j in 1..i loop
dbms_output.put('*');
end loop;
dbms_output.put_line(' ');
end loop;
end;
for k in reverse 1..4 loop
for l in 1..k loop
dbms_output.put('*');
end loop;
 dbms_output.put_line(' ');
 end loop;
 end ; 
 
 begin
 for i in reverse 1..5 loop
 for j in 1..i-1 loop
 for k in 1..i loop 
 dbms_output.put('*');
 end loop;
 dbms_output.put(' ');
 end loop;
 dbms_output.put_line(' ');
 end loop;
 end; 
 
  
  create  or replace function evenodd( p_num number)
  return varchar2
  as
  begin
  if mod(p_num,2)=0 
  then
  return 'even'; 
  else 
  return 'odd';
  end if ;
  end;
  
  select * from all_objects where lower(object_name)='evenodd';
  
  select evenodd(29) from dual;
  
  
  ****************************************************************************************************************************************
  
  create or replace function datewa ( p_date date , p_type varchar2)
  return varchar2
  as
  begin
if p_type='day'
then 
return p_type(p_date,'day');
elsif p_type='month'
then
return to_char(p_date,'month');
elsif p_type=to_char(p_date,'dd') 
then
return to_char(p_date,'dd');
elsif p_type=to_char(p_date,'rrrr')
then
return  to_char(p_date,'rrrr');
end if;
end;
select datewa(to_date('12-04-2023')) from dual;

***********************************************************************************************************************


create or replace function return_date_val(p_date date, p_type varchar2)
return varchar2
as
begin
if p_type = 'day' then
return to_char(p_date,'day');
elsif p_type = 'dd' then
return to_char(p_date,'dd');
elsif p_type = 'year' then
return to_char(p_date,'RRRR');
elsif p_type = 'month' then
return to_char(p_date,'month');
end if;
end;

select return_date_val(to_date('12-april-2023'),'month') from dual;
*****************************************************************************************************************************************

create or replace procedure XX_sum( p  in number, pp in number, ppp out number)
as 
begin
ppp:=p+pp;
end xx_sum;

declare
a number:=10;
b number :=20;
c number;
begin
xx_sum( a,b,c);
dbms_output.put_line(c);
end;

*********************************************************************************************************************

create or replace procedure xx_isu( p number,pp number)
is  sumo number:=0;
begin
sumo:=p+pp;
dbms_output.put_line(sumo);
end xx_isu;

declare
a number:=10;g
b number:=10;
begin
xx_isu(a,b);
end;             

********************************************************************************************************************************

create or replace function xx_max( ln_a number,ln_b number) return number
as 
begin
if ln_a>ln_b
then
return ln_a;
elsif ln_b>ln_a 
then
return ln_b;
else
return ln_a;
end if;
end;

select xx_max(10,20) from dual;

declare
a number:=10;
b number:=20;
c number;
begin
dbms_output.put_line(xx_max(20,50));
end;
****************************************************************************************************************************

 create or replace procedure calc(  a in number , b in number  ,sumo out number, subo out number, div out number, mul out number )
 as 
 begin
 sumo:=a+b;
 subo:=a-b;
 mul:=a*b;
 div :=a/b;
  end calc;
  
  declare
  a number:=30;
  b number:=40;
  c number;
  d number;
  e number;
  f number;
  begin
  
  calc(a,b,c,d,e,f);
dbms_output.put_line(a||' '||b||' '||c);

end;

**************************************************************************************************************************************

create  or replace procedure concat_rp( n in varchar2 , nn in varchar2 , nnn out varchar2)
as 
begin
dbms_output.put_line(initcap(n||' '||nn));
end concat_rp;


declare
a varchar2(20):='rachit';
b varchar2(30):='panwar ';
c varchar2(100);
begin
concat_rp(a,b,c);
end;

***************************************************************************************************************************************

create or replace procedure rachit_substr( n in varchar, ln in number, endd in number)
as 
r varchar2(20);
begin
for i in 1..ln loop
r:=  
end;


**************************************************************************************************************************************

CREATE OR REPLACE PROCEDURE substring_proc (
    input_string IN VARCHAR2,
    start_index IN NUMBER,
    substring_length IN NUMBER,
    result OUT VARCHAR2
)
IS
BEGIN
    result := SUBSTR(input_string, start_index, substring_length);
END;


DECLARE
    input_str VARCHAR2(100) := 'Hello, World!';
    start_idx NUMBER := 8;
    length_val NUMBER := 5;
    output_str VARCHAR2(100);
BEGIN
    substring_proc(input_str, start_idx, length_val, output_str);
    DBMS_OUTPUT.PUT_LINE(output_str);
END;




***************************************************************************************************************************



CREATE OR REPLACE FUNCTION substring(input_string IN VARCHAR2, start_index IN NUMBER, length IN NUMBER)
    RETURN VARCHAR2
IS
BEGIN
    RETURN SUBSTR(input_string, start_index, length);
END;
DECLARE
    input_string VARCHAR2(100) := 'Hello, World!';
    start_index NUMBER := 8;
    substring_length NUMBER := 5;
    result VARCHAR2(100);
BEGIN
    result := substring(input_string, start_index, substring_length);
    DBMS_OUTPUT.PUT_LINE(result);
END;


*************************************************************************************************************************************


create or replace procedure evoyt( ln_i int ) 
as 
begin
if mod(ln_i ,2)=0 then
dbms_output.put_line('even;');
else 
dbms_output.put_line('odd');
end if;
end;


declare
a number:=10;
begin
evoyt(a);
end;

*********************************************************************************************************
create or replace function evod(a number) return varchar
as 
begin
if mod(a,2)=0
then return 'true';
else return 'false';
end if;
end;

select evod(11) from dual;

**************************************************************************************************************************

package




create or replace package  p_sum 
as 
function f_sum( a number , b number) return number;
function f_sum( a number , b number, c number) return number;
end;


create or replace package  body p_sum 
as 
function f_sum( a number , b number) return number
as 
begin 
return a+b;
end f_sum;

function f_sum( a number , b number, c number) return number
as
begin
return a+b+c;
end f_sum;
end;

select p_sum.f_sum(10,10) from dual;

select p_sum.f_sum(10,20,30) from dual;

******************************************************************************************************************************************

create or replace procedure xx_intg_sum( a in number, b in number)
as 
sumoo number;
begin
sumoo:=a+b;
end;

declare
aa number;
bb number;
begin
aa:=20;
bb:=40;
xx_intg_sum(aa,bb);
end;


***********************************************************************************************************************************


create or replace package xx_intg 
as 
procedure summ( ln_a number, ln_b number ,ln_sum out number);
function even(ln_bb number) return varchar2;
function subb(lnz number,lnx number) return number;
end xx_intg;

create or replace package body xx_intg 
as 
procedure summ( ln_a number, ln_b number ,ln_sum out number)
as
begin
ln_sum:=ln_a+ln_b;
dbms_output.put_line(ln_sum );
end summ;
function even(ln_bb number) return varchar2
as
begin
if mod(ln_bb,2)=0
then
return 'even';
else 
return 'odd';
end if ;
end even;
function subb(lnz number,lnx number) return number
as
begin
return lnz-lnx;
end subb;
end xx_intg;

--calling

select xx_intg.even(1) from dual;

select xx_intg.subb(30,20) from dual;

declare
a number;
b number;
c number;
begin
a:=20;
b:=30;
xx_intg.summ(a,b,c);
end;

****************************************************************************************************************************************

create or replace function f_s ( n number, nn number)
return number
as
begin
return(n+nn);
end f_s;

select f_s(10,20) from dual;
******************************************************************************************************************************************

create or replace procedure pp_s( n in number, nn in number)
as
s number;
begin
s:=n+nn;
dbms_output.put_line(s);
end;


declare
a number:=&n;
b number:=&m;
begin
p_s(a,b);
end;

*****************************************************************************************************************************************

select * from all_objects where lower(object_name) ='p_s';


create or replace package pp_s
as
function fuddu( ladka varchar2,ladki varchar2) return varchar2;
procedure repro ( boy in varchar2, girls in varchar2);
procedure repro ( boy in varchar2, girls in varchar2);
end pp_s;


create or replace package body pp_s
as 
function fuddu( ladka varchar2,ladki varchar2) return varchar2 
as 
ln_res varchar2(30);
begin
return ladka||' '||ladki;
end fuddu;
procedure repro ( boy in varchar2, girls in varchar2)
as
baby varchar2(130);
begin
baby:=boy||' '||girls;
dbms_output.put_line(baby);
end repro;
end pp_s ;

select pp_s.fuddu('rachit','panwar') from dual;

declare
a varchar2(10):='rachita';
b varchar2(30):='panwar';
begin
pp_s.repro(a,b);
end;


************************************************************************************************************************************
CREATE OR REPLACE PROCEDURE process_employee (
   employee_id_in IN employees.employee_id%TYPE)
IS
   l_fullname VARCHAR2(100);
BEGIN
   SELECT last_name ||' '|| ',' ||' '|| first_name
     INTO l_fullname
     FROM employees
    WHERE employee_id = employee_id_in;
dbms_output.put_line(l_fullname);
END;

declare 
e_id employees.employee_id%type;
begin
process_employee(109);
end;

*****************************************************************************************************************************

create or replace package xxintg_dtls
as
procedure ln_proc( p_ number,p_n number);
procedure proc2(p_p varchar2);
end xxintg_dtls;


create or replace package body xxintg_dtls
as
procedure ln_proc( p_ number,p_n number)
as
begin
dbms_output.put_line(p_*p_n);
end ln_proc;
procedure proc2(p_p varchar2)
as
begin
dbms_output.put_line(p_p||' '||p_p);
end proc2;
end xxintg_dtls;


declare
a number;
--b number;
begin
select department_id into a from employees where employee_id=101;
dbms_output.put_line(a);
end;


************************************************************************************************************************************


declare
null;
begin
null;
 end;

*******************************************************************************************************************************************
create  or replace function p(p_num number) return varchar2
as 
s number:=0;
begin
for i in 2..p_num loop
if MOD(P_NUM,I)=0
THEN
s:=s+1;
END IF;
end loop;
if s=1 then
return 'prime';
else
return 'not_prime';
end if;
end;


select p(4) from dual;

declare
a number:=11;
c varchar2(30);
begin
c:=p(A);
dbms_output.put_line(c);
end;
***************************************************************************************************************************

select * from user_source;

********************************************************************************************************************************


create or replace package xxintg_duplicate1
as
function sum1(p1 number , p2 number) return number;
end;

create or replace procedure xxintg_duplicate1
as 
begin
 null;
end;
*************************************************************************************************************************************

select * from departments;


declare
ln_dept_id number:=10;
lc_dept_name varchar2(100);
begin
select department_name into lc_dept_name from departments where department_id =ln_dept_id;
dbms_output.put_line(lc_dept_name);
end;


declare

ln_dept_id varchar2(30):=50;
lc_emp_name varchar2(200);
begin
select first_name into lc_emp_name from employees where department_id=ln_dept_id;
dbms_output.put_line(lc_emp_name);
end;

*************************************************************************************************************

declare

ln_dept_id varchar2(30):=50;
lc_emp_name varchar2(200);
begin
select first_name into lc_emp_name from employees where department_id=ln_dept_id;
dbms_output.put_line(lc_emp_name);

exception when others then
dbms_output.put_line('error occo]ured'||sqlcode||' '||sqlerrm);
end;


************************************************************************************************************************

declare

ln_dept_id varchar2(30):=50;
lc_emp_name varchar2(200);
begin

dbms_output.put_line('start');
select first_name into lc_emp_name from employees where department_id=ln_dept_id;
dbms_output.put_line(lc_emp_name);

dbms_output.put_line('end');
exception when others then
dbms_output.put_line('error occo]ured'||sqlcode||' '||sqlerrm);
end;
**********************************************************************************************************************************


declare

ln_dept_id varchar2(30):=50;
lc_emp_name varchar2(200);
begin

dbms_output.put_line('start');
select first_name into lc_emp_name from employees where department_id=ln_dept_id;
dbms_output.put_line(lc_emp_name);

dbms_output.put_line('end');
exception when others then
dbms_output.put_line('error occo]ured'||sqlcode||' '||sqlerrm);
end;
******************************************************************************************************************************************



declare

ln_dept_id varchar2(30):=50;
lc_emp_name varchar2(200);
n number;
begin

dbms_output.put_line('start');
n:=1/0;

select first_name into lc_emp_name from employees where department_id=ln_dept_id;
dbms_output.put_line(lc_emp_name);

dbms_output.put_line('end');
exception when others then
dbms_output.put_line('error occo]ured'||sqlcode||' '||sqlerrm);
end;


*********************************************************************************************************************************



declare

ln_dept_id varchar2(30):=50;
lc_emp_name varchar2(200);
begin

dbms_output.put_line('start');

begin

select first_name into lc_emp_name from employees where department_id=ln_dept_id;
dbms_output.put_line(lc_emp_name);

dbms_output.put_line('end');
exception when others then
dbms_output.put_line('error occo]ured'||sqlcode||' '||sqlerrm);
end;
dbms_output.put_line('end walah');

exception when others then
dbms_output.put_line('main error'||sqlcode||' '||sqlerrm);
end;


********************************************************************************************************************************


declare
n number;
ln_dept_id varchar2(30):=50;
lc_emp_name varchar2(200);
begin

n:=1/0;
dbms_output.put_line('start');

begin

select first_name into lc_emp_name from employees where department_id=ln_dept_id;
dbms_output.put_line(lc_emp_name);

dbms_output.put_line('end');
exception when others then
dbms_output.put_line('error occo]ured'||sqlcode||' '||sqlerrm);
end;
dbms_output.put_line('end walah');

exception when others then
dbms_output.put_line('main error'||sqlcode||' '||sqlerrm);
end;


**************************************************************************************************************************

create or replace package xx_dtl
as
function get_dtl( p_dept_id number) return varchar;
procedure get_dtls( P_emp_id in number, P_dept_id out number , p_dept_name out varchar2, p_status  out varchar2);
end xx_dtl;

select * from departments;

create or replace package body xx_dtl
as
function get_dtl( p_dept_id number) return varchar2
is
p_dept_name varchar2(58);
begin
select department_id into P_dept_id from employees ;
return P_dept_id;
begin
select department_name into p_dept_name from departments where department_id=p_dept_id;
return p_dept_name;
exception when others
then
dbms_output.put_line('error occur'||sqlcode||'-'||sqlerrm);
end;
exception
when others then 
dbms_output.put_line('main error occur'||sqlcode||' - '||sqlerrm);
end ;
end xx_dtl;


****************************************************************************************************************************

create or replace function emp_dtl( p_emp_dept_id varchar2,p_emp_dept_name varchar2) return varchar2
is
begin
select department_id into p_emp_dept_id from employees;
return p_emp_dept_id ;
begin 
select department_name into p_emp_dept_name from departments where department_id=p_emp_dept_id;
return p_emp_dept_name;
exception when others then 
dbms_output.put_line('inner error occured'||sqlcode||' '||sqlerrm);
end;
exception when others then
dbms_output.put_line('inner error occured'||sqlcode||' '||sqlerrm);
end;
****************************************************************************************************************************************
select * from employees;

**************************************************************************************************************************************


create or replace function f_get_dtl( p_emp_id  number,p_value_type  varchar) return varchar2
as
ln_fname varchar2(20);
begin
select employee_id into p_emp_id from employees;
begin
select first_name into ln_fname from employees where employee_id=p_emp_id;
 if p_value_type=ln_fname
 then 
return first_name;
end ;
begin
select email into ln_email from employees where employee_id=p_emp_id;
 if p_value_type=ln_email
 then return email;
 begin
 select phone_number
 elsif p_value_type=phone_number
 then return phone_number;
 elsif p_value_type=hire_date
 then return hire_date;
 elsif p_value_type=job_id
 then return job_id;
 elsif p_value_type=salary
 then return salary;
 elsif p_value_type=commission_pct
 then return commission_pct;
 elsif p_value_type =manager_id
 then
 return manager_id;
 elsif p_value_type=last_name
 then return last_name;
     else 
     return department_id ;
 end if;
 end;
end f_get_dtl;


select f_get_dtl(101,first_name) from dual;

**************************************************************************************************************************************


create or replace package xx_asgnmnt1
as
procedure proc_getdtl(p_emp_id in number,p_dept_id out number,p_dept_name out varchar2,p_status  out varchar2);
function func_getdtl(p_dept_id number, p_dept_name varchar2) return varchar2;
end;



create or replace package body xx_asgnmnt1
as
procedure proc_getdtl(p_emp_id in  number,p_dept_id number,p_dept_name out varchar2, p_status  out varchar2)
as 
begin
select employee_id into p_emp_id from employees;

dbms_output.put_line(p_emp_id);
begin
select department_id into p_dept_id from employees where employee_id=p_emp_id;
dbms_output.put_line(p_dept_id);
begin
select department_name into p_dept_name  from departments where department_id=p_dept_id;
dbms_output.put_line(p_dept_name);
end;
end;
exception
when others then
dbms_output.put_line('no data found'||sqlcode||' --- '||sqlerrm);
end;
function func_getdtl(p_dept_id number, p_dept_name varchar2) return varchar2
as
begin
null;
end;
end;