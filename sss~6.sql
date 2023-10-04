create or replace package pckg_all
as
procedure main;
end pckg_all;

---------------------------------------------------------------------------

create or  replace package body pckg_all
as
procedure cur_cursor
as
cursor regions
is 
select * from regions;
r1 regions%rowtype;
cursor countries (p_region_id varchar2)
is
select * from countries;
r2 countries%rowtype;
cursor locations( p_region_id varchar2, p_country_id varchar2)
is
select * from locations ;
r3 locations%rowtype;
cursor departments(p_region_id varchar2, p_country_id varchar2 , p_location_id varchar2)
is 
select * from departments;
r4 departments%rowtype;
cursor employees (p_region_id varchar2, p_country_id varchar2 , p_location_id varchar2,p_department_id varchar2)
is
select * from employees e, departments d, locations l , country c, regions r 
where e.department_id=d.department_id
and d.location_id=l.location_id
and l.country_id=c.country_id
and c.region_id=r.region_id
and r1.region_id=p_region_id
and r4. department_id=p_department_id
and r3.location_id=p_location_id 
and r2.country_id=p_country_id;
begin
for regions in r1
loop
dbms_output.put_line(rpad('region_name',20)||' '||r1.region_name);
for country in r2 loop
dbms_output.put_line(rpad('country_name',20)||' '|r2.country_name);
for locations in r3 
