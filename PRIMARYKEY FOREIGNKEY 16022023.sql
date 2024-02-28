select * from user_cons_columns where lower(table_name) ='somildb';

desc user_cons_columns;

select * from somildb;

drop table somildb;

create table somildb(roll_number number primary key  ,
                     student_id number unique,
                     address varchar2(20) unique,
                     first_name varchar2(20) unique not null,
                     last_name varchar2(20) unique not null,
                     department_name varchar(200) not null,
                     department_id number not null,
                     addmission_date date,
                     fee number constraint fee_min_cond check (fee>10000),
                     Date_of_birth date
                     )
insert into somildb  values(1816421072,
                            24964,
                            '336a2 pashuapti',
                            'Somil',
                            'Yadav',
                            'Electrical and Electronics',
                            21,
                            '21-08-2018',
                            11904,
                            '21-08-2000'
                            )
select * from user_constraints where lower(table_name)='somildb';
alter table somildb
drop constraint FEE_MIN_COND 

alter table somildb
add constraint FEE_MIN_COND check (fee>11000);

select * from USER_UNUSED_COL_TABS;
select * from all_tab_columns;
select * from all_cons_columns;
select * from all_constraints;
select * from all_objects;
select * from user_objects;
select * from user_tab_columns;
select * from user_cons_columns;
select * from user_tab_columns;
select * from user_tables where lower(table_name) ='somildb';

desc employees;

SELECT * FROM v$version
create table somil_test(empId number primary key ,
first_name varchar2(200),
department_id number)
select * from all_cons_columns where lower(table_name)='somil_test';
INSERT INTO somil_test VALUES (10,'somil',101);
insert into somil_test values(20,'somil',102);
insert into somil_test values(30,'yadavil',103);
select * from somil_test;
drop table somil_test;



create table somil_test1 (empId1 number primary key ,
first_name varchar2(200),
department_id1 number,
CONSTRAINT SYS_C008302 FOREIGN KEY (department_id)
REFERENCES somil_test(department_id) 
)

select * from somil_test1;
drop table somil_test1;
select * from somil_test1;

drop table department;
create table department(dep_id number primary key,f_name varchar(20) not null);
insert into department values(101,'CS');
insert into department values (102,'EE');
INSERT INTO DEPARTMENT VALUES (103,'ME');
SELECT * FROM DEPARTMENT ;

CREATE TABLE STUDENT(STU_ID NUMBER PRIMARY KEY ,F_NAME VARCHAR2(20),depart_id number, FOREIGN KEY (DEPart_ID) REFERENCES DEPARTMENT(DEP_ID));

select * from student;
insert into student values(1816421072,'somil',101);
insert into student values(1019210,'syafav',102);

select * from user_constraints where lower(table_name) ='student';
alter table student
disable  constraints SYS_C008310

alter table student
drop constraints SYS_C008310

alter table student
add constraint fk_depart FOREIGN KEY (DEPart_ID) REFERENCES DEPARTMENT(DEP_ID);


select * from student;
select * from department;

CREATE TABLE SOMILDB2(BRANCH VARCHAR2(20) , PROF_ID NUMBER );
CREATE TABLE SOMILDB1(ROLL_NO NUMBER PRIMARY KEY,DEPARTMENT_ID NUMBER NOT NULL UNIQUE ,DEPARTMENT_NAME VARCHAR2(20) UNIQUE);
INSERT INTO SOMILDB1 VALUES(18164121072,21,'ELECTRICAL');
INSERT INTO SOMILDB1 VALUES(1816421073,22,'ELECTRONICS');
SELECT * FROM SOMILDB;

create table somildb(roll_number number primary key  ,
                     student_id number unique,
                     address varchar2(20) unique,
                     first_name varchar2(20) unique not null,
                     last_name varchar2(20) unique not null,
                     department_name varchar(200) not null,
                     department_id1 number not null,
                     BRANCH1 VARCHAR2(20),
                     addmission_date date,
                     fee number constraint fee_min_cond check (fee>10000),
                     Date_of_birth date,
                     FOREIGN KEY (DEPARTMENT_ID1) REFERENCES SOMILDB1(DEPARTMENT_ID),
                     FOREIGN KEY (BRANCH1) REFERENCES SOMILDB2(BRANCH) 
                     );
insert into somildb  values(1816421072,
                            24964,
                            '336a2 pashuapti',
                            'Somil',
                            'Yadav',
                            'Electrical and Electronics',
                            21,
                            '21-08-2018',
                            11904,
                            '21-08-2000'
                            );
                            
SELECT * FROM SOMILDB1;
DROP TABLE SOMILDB;

SELECT * FROM USER_CONSTRAINTS WHERE UPPER(TABLE_NAME) ='SOMILDB';