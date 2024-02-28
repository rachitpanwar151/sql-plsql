select * from somildb;

SELECT employee_id, job_id
FROM employees
UNION
SELECT employee_id, job_id
FROM job_history;


SELECT employee_id, job_id, department_id
FROM employees
UNION
SELECT employee_id, job_id, department_id
FROM job_history;

select first_name from employees where department_iD;

select * from somildb;
drop table somildb;

alter table somildb
modify firs varchar(200);

rollback;
create table somildb (FIRS varchar(100) );
insert into somildB VALUES('SOMIL');

select distinct(department_id,first_name) from employees;


DROP TABLE SOMILDB;
CREATE TABLE SOMILDB( FIRST_NAME VARCHAR2(200) PRIMARY KEY, 
                      LAST_NAME VARCHAR(200) NOT  NULL ,
                      PHONE_NUMBER NUMBER,
                      EMP_ID INT UNIQUE
                      )
                                        
INSERT INTO SOMIDB VALUES('SKSS','SHDHS',57886,684,'SJDHGDDS')
INSERT INTO SOMILDB VALUES('&FIRST','&LAST',&PHONE_NUMBER,&EMP_ID,&EMAIL)
UPDATE SOMILDB
SET EMAIL='&RRT' 
ALTER TABLE SOMILDB
ADD EMAIL VARCHAR(200);
SELECT * FROM SOMILDB;

ALTER table SOMILDB
DROP column email


SELECT * FROM user_CONSTRAINTS WHERE TABLE_NAME ='SOMILDB';

DROP TABLE SOMILDB;

CREATE TABLE SOMILDB(ID NUMBER UNIQUE NOT NULL,NAME_FIRST VARCHAR2(200),LAST_NAME VARCHAR2(200),
                    CONSTRAINT SOMIL_sOS  PRIMARY KEY(LAST_NAME)
                    );
                    
INSERT INTO SOMILDB VALUES(&ID,'&FIRST','&LAST_NAME')

SELECT * FROM EMPLOYEES;
RENAME SOMIL21 TO SOMIL2;

CREATE TABLE SOMIL21 AS SELECT * FROM EMPLOYEES;
SELECT * FROM SOMIL2;

CREATE TABLE SOMILSDS(ID NUMBER(20) NOT NULL,
                      NAME_FIRST VARCHAR2(200)
                      )
                      INSERT INTO SOMILSDS VALUES(10,'SOMIL')
SELECT * FROM SOMILSDS;
ALTER TABLE SOMILSDS 
MODIFY COLUMN  NAME_FIRST VARCHAR2(20) NULL
INSERT INTO SOMILSDS VALUES(10,'NULL')

SELECT * FROM user_CONSTRAINTS WHERE TABLE_NAME ='SOMILSDS';

ALTER TABLE SOMILSDS DROP CONSTRAINTS SYS_C008181;
DROP TABLE YADAV

CREATE TABLE YADAV(NAME VARCHAR2(200),ID NUMBER UNIQUE,DEPARMENT NUMBER)

INSERT INTO YADAV VALUES ('SOMIL',20,23)
SELECT * FROM YADAV;

SELECT * FROM user_CONSTRAINTS WHERE TABLE_NAME ='YADAV';

ALTER TABLE YADAV
ADD CONSTRAINTS SYS_C008182 UNIQUE(NAME)

ALTER TABLE YADAV
DISABLE CONSTRAINT SYS_C008182
ALTER TABLE YADAV
DROP CONSTRAINT QW_FOIRS

DROP TABLE YADAV;

CREATE TABLE YADAV(NAME_FIRST VARCHAR2(20) ,ID NUMBER)
alter table yadav
add constraint sssd unique(id)

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME ='yadav'

alter table employees
add constraints test1 unique(salary)

select * from tab;








select * from somildb;

create table somildb(roll_number number primary key  ,
                     student_id number unique,
                     address varchar2(20) unique,
                     first_name varchar2(20) unique not null,
                     last_name varchar2(20) unique not null,
                     department_name varchar(200) not null,
                     department_id number not null,
                     addmission_date date,
                     fee number,
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
                            119300,
                            '21-08-2000'
                            )
                            SELECT * FROM SOMILDB;
                            --SOMIL YADAV 5:05
SELECT * FROM user_CONSTRAINTS WHERE lower(TABLE_NAME) ='somildb';
              --SOMIL YADAV 5:01
              
ALTER TABLE SOMILDB DISABLE  CONSTRAINT SYS_C008186; 
ALTER TABLE SOMILDB DISABLE  CONSTRAINT SYS_C008187;
ALTER TABLE SOMILDB DISABLE  CONSTRAINT SYS_C008188;
ALTER TABLE SOMILDB DISABLE  CONSTRAINT SYS_C008189;
ALTER TABLE SOMILDB DISABLE  CONSTRAINT SYS_C008190;
ALTER TABLE SOMILDB DISABLE  CONSTRAINT SYS_C008191;
ALTER TABLE SOMILDB DISABLE  CONSTRAINT SYS_C008192;
ALTER TABLE SOMILDB DISABLE  CONSTRAINT SYS_C008193;
ALTER TABLE SOMILDB DISABLE  CONSTRAINT SYS_C008194;
--SOMIL YADAV 5:14


ALTER TABLE SOMILDB DROP  CONSTRAINT SYS_C008186;
ALTER TABLE SOMILDB DROP  CONSTRAINT SYS_C008187;
ALTER TABLE SOMILDB DROP  CONSTRAINT SYS_C008188;
ALTER TABLE SOMILDB DROP  CONSTRAINT SYS_C008189;
ALTER TABLE SOMILDB DROP  CONSTRAINT SYS_C008190;
ALTER TABLE SOMILDB DROP  CONSTRAINT SYS_C008191;
ALTER TABLE SOMILDB DROP  CONSTRAINT SYS_C008192;
ALTER TABLE SOMILDB DROP  CONSTRAINT SYS_C008193;
ALTER TABLE SOMILDB DROP  CONSTRAINT SYS_C008194;
--SOMIL YADAV 5:23
SELECT * FROM SOMILDB;

SELECT * FROM USER_CONSTRAINTS WHERE UPPER(TABLE_NAME) ='SOMILDB';
ALTER TABLE SOMILDB ADD CONSTRAINT TEST1 PRIMARY KEY(ROLL_NUMBER);
ALTER TABLE SOMILDB ADD CONSTRAINT TEST2 UNIQUE(STUDENT_ID);
ALTER TABLE SOMILDB ADD CONSTRAINT TEST3 UNIQUE(ADDRESS);
ALTER TABLE SOMILDB MODIFY  FIRST_NAME  NOT NULL UNIQUE;
ALTER TABLE SOMILDB MODIFY LAST_NAME  NOT NULL UNIQUE;
ALTER TABLE SOMILDB MODIFY DEPARTMENT_NAME NOT NULL;
ALTER TABLE SOMILDB MODIFY DEPARTMENT_ID NOT NULL;
--SOMIL YADAV 5:47


select * from  v$nls_parameters;