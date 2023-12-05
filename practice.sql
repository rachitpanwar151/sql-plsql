select pha.po_header_id,
pha.agent_id,
pha.TERMS_ID,
pha.type_lookup_code,
pla.item_id,
pla.item_description,
pla.unit_price,
pla.quantity
from po_headers_all pha, po_lines_all pla 
where pha.po_header_id=pla.po_header_id and type_lookup_code='STANDARD'
and pha.org_id=204 
and rownum<=20---- dont use this until it require;
;


select * from fnd_application_tl where application_name='Purchasing';
select * from fnd_application where application_id=201;

select *from po_headers_all;

select * from gl_code_combinations;

begin
mo_global.set_policy_context('S',204);
end;
select * from po_requisition_headers_all;
select * from po_req_distributions;
select * from po_action_history;
16209
8668
10307

select * from po_headers_all;

select * from po_lines_all;

select * from po_line_locations_all;

select * from rcv_shipment_headers;

select * from rcv_shipment_lines;

select * from rcv_transactions;

select * from po_distributions_all;
select * from ap_invoices_all;
select * from ap_invoice_distributions_all;
8670
10309

select * from po_requisition_lines;
select * from po_req_distributions;
select * from po_requisition_headers;


declare 
v_name employees.first_name%type;
begin
select first_name into v_name from employees where rownum<2;
dbms_output.put_line(v_name);
end;


select * from xla_accounting_errors where last_updated_by=1014843;


SELECT * FROM FND_EXECUTABLES;

SELECT * FROM FND_CONCURRENT_PROGRAMS;

SELECT * FROM FND_CONCURRENT_PROGRAMS_TL;

SELECT * FROM FND_LOOKUP_VALUES WHERE MEANING LIKE 'Oracle Reports';

SELECT * FROM XDO_DS_DEFINITIONS_B; --> TO GET INFO ABOUT DATA DEFINATION

SELECT * FROM XDO_LOBS WHERE LOB_CODE='XXINTG_PO_DTLS_RSP' AND XDO_FILE_TYPE='RTF';

SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID=:V;

SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID=NVL(:V,EMPLOYEE_ID);


SELECT * FROM EMPLOYEES WHERE (EMPLOYEE_ID=:V OR :V IS NULL);

SELECT :V DEPT, EMPLOYEE_ID FROM EMPLOYEES;

SELECT &P FROM EMPLOYEES;

SELECT &COLNAME FROM &TABLENAME;

SELECT * FROM &TBLNAME;

select user from dual;

select * from gl_ledgers;

select * from po_headers_all where created_by=1014843;


select * from all_users;
select * from all_objects;
select * from all_views;
select * from all_source;


CREATE OR REPLACE VIEW PO_RPP
AS
SELECT * FROM PO_HEADERS_ALL;

SELECT * FROM PO_RPP;

SELECT * FROM FND_MENUS;

select * from wf_item_types_tl;

declare
type v_nt is table of varchar2(200);
v_first_name v_nt;
begin
select first_name bulk collect into v_first_name from employees;
for i in 1..v_first_name.count
loop
dbms_output.put_line('first_name is '||v_first_name(i));
end loop;
end;




declare
type hid is table of varchar2(2000);
header_id hid;
begin
select po_header_id bulk collect into header_id from po_headers_all;
for i in 1..header_id.count
loop
dbms_output.put_line('header id is '||header_id(i));
end loop;
end ;



declare
cursor c is 
select first_name from employees;
type t_name is table of varchar2(300);
vname t_name;
begin
open c;
loop
fetch c bulk collect into vname;
for i in 1..vname.count
loop
dbms_output.put_line(i||' '||'first name is '||vname(i));
end loop;
end loop;
close c;
end ;



declare 
cursor c
is 
select first_name from employees;
type v_nt is table of varchar2(200);
v_first_name v_nt;
begin
open c;
loop
fetch c bulk collect into v_first_name  limit 10;
exit when v_first_name.count=0;
for i in 1..v_first_name.count 
loop
dbms_output.put_line(i||' '||v_first_name(i));
end loop;
end loop;
close c;
end;