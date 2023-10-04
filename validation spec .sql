create or replace package xxintg_validation_rp
as
procedure main_procedure( errbuff out varchar2, reetcode out varchar2, p_batch_id number, p_process_type varchar2);
end xxintg_validation_rp;


/*
create table xxintg_staging_rp
(
request_id number,
record_id number,
employee_id number,
first_name varchar2(40),
last_name varchar2(40),
email varchar2(30),
phone_number number,
hire_date date,
job_id varchar2(5),
job_title varchar2(30),
salary number,
commission_pct number
,manager_id number,
department_id number,
department_name varchar2(30),
    created_by varchar2(20),
    last_updated_by varchar2(20),
    created_date date,
    last_updated_date date,
    login_id number,
status varchar2(5),
errorr varchar2(4000)
);
*/


create sequence employees_Id_rp
increment by 1
minvalue 1
maxvalue 1000
nocycle
nocache;
create sequence record_id_rp
increment by 1
minvalue 1
maxvalue 1000
nocycle
nocache;