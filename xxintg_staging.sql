create table xxintg_staging (
record_id number,
employee_id number ,
first_name varchar2(40),
last_name varchar2(40),
email varchar2(20), 
phone_number number(12,2),
hire_date date , 
job_id varchar2(10),
job_title varchar2(20),
salary number,
commission_pct number(2,2),
manager_id number,
department_id number,
department_name varchar2(20),
batch_id number
);
commit;

SELECT * FROM xxintg_staging;

CREATE SEQUENCE record_id_SEQ

START WITH 1

INCREMENT BY 1

MINVALUE 1

MAXVALUE 100

NOCYCLE ;