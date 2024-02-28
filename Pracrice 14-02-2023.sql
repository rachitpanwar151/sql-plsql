CREATE USER user
IDENTIFIED BY password;
select trunc(sysdate) from dual;

SELECT *
FROM dictionary
WHERE table_name = 'USER_OBJECTS';

select all_user from tab;

ALTER TABLE SOMILDB
rename COLUMN 'Sr.No.' TO 'ID';

DROP table somildb;


ALTER TABLE SOMILDB
RENAME COLUMN col1 to ID;
ALTER TABLE Somildb
MODIFY COLUMN  datatype;

select * from somildb;
update somildb set col ='ID' WHERE COL ='SR.No.'; 

create table table1 (varvhar2(10000),id number),rowid ;


create table SomilDb(ID NUMBER,First_name Varchar2(200),last_name varchar(200),phone_number number(20),email varchar2(100),salary number(20,2),STATUS VARCHAR(200));

alter table somildb
add status varchar2(20);
alter table somildb
add email varchar2(200);

drop table somildb;

alter table somildb
rename column Sr.No. to IDD;

create table SomilDb(ID number,First_name Varchar2(200),last_name varchar(200),phone_number number(20),email varchar2(100),salary number(20,2),STATUS VARCHAR(200));

insert into somildb values(&ID,'&FIRST','&LAST','&PHONE','&EMAIL','&SALARY','&Active');
SELECT * FROM SOMILDB;

alter table somildb
modify column first_name varchar2(300);


insert into somildb values(2,'Rohit','Yadav','somil.yadav119@gmail.com','35000','8090149103','Active');
commit;
rollback;
select * from somildb;

SELECT * FROM SOMILDB;
commit;
update somildb set status ='Active' where lower(first_name) ='somil'; 
alter table Somildb
add last_name varchar2(200) ;

select * from somildb;
rename yadavdb to somildb;
select * from yadavdb;
rollback;


alter table mytest rename column name to emp_name;
      alter table mytest_emp rename to mytest


select * from v$nls_parameters where nls_date_format;