
    
    create table mytest (
    name varchar2(100), id number ,order_date date,qty number(4,2)
    )
    
    
    select * from all_objects where object_name like 'my' and object_type = 'table';
    
    select * from user_objects where object_name='mytest';
    
    dba_objects
    
    select * from user_tab_cols where column_name=upper('department_id') ;
    
    select *  from mytest;
    
    select * from user_tab_cols;
    

CREATE TABLE MYTEST(
      NAME VARCHAR2(100),
      ID NUMBER,
      ORDER_DATE DATE,
      QTY NUMBER(4,2)
      ) 



CREATE TABLE MYTEST(
      NAME VARCHAR2(100),
      ID NUMBER,
      ORDER_DATE DATE,
      QTY NUMBER(4,2)
      )
     

alter table table_name 
     add column_name datatype;
     

alter table mytest
     add price number;


     alter table mytest
     add ( cust_name varchar2(1000) , item varchar2(100) )



      MAX COL = 1000
      NAME = 128 
      COL = 128 
      NAME - NUMBER N SPEICAL CHAR  ,KEYWORDS 
      


alter column 
      columns - 
      modify exsting column
            data type  
               number --> varchar2 
               number - date 
               vchar - date 
               vchar2 
             incraee in size 
             

alter table mytest1 modify name date
             

alter table mytest modify ( name varchar2(2000) , CUST_NAME varchar2(2000))
      drop col
     

alter table mytest drop column order_date;
      add new column - single , multiple 
      rename ext colum 
      table 
      


rename table name 
      INSERT INTO MYTEST 
      VALUES ('Annnnnnnnnnnnnnnnnnnnnnnnnnjjjjjjjjjjjjjjjjjjjjjn',
      2,SYSDATE,4.2,null,null,null)
      SELECT * FROM MYTEST       
      COMMIT;



SELECT * FROM ALL_OBJECTS WHERE oBJECT_TYPE ='TABLE' and UPPER(object_name) ='MYTEST' OWNED BY USER + HAVE ACCESS USER_OBJECTS - OWNED BY CURRENT USER (ALL OBJECT TYPE) SELECT * FROM USER_TAB_COLS WHERE table_name LIKE  'MYTEST' 
COLUMN_NAME ='DEPARTMENT_ID' 



SELECT * FROM USER_TAB_COLUMNS WHERE COLUMN_NAME ='DEPARTMENT_ID' TABLE_NAME = 'MYTEST'





 SELECT * FROM MYTEST 



alter table mytest rename column name to emp_name;


      alter table mytest_emp rename to mytest


CREATE TABLE  RACHITDB(
NAME VARCHAR(50),
ID NUMBER,
PHNO NUMBER,
AGE NUMBER);

INSERT INTO RACHITDB
VALUES ('ROBIN',101,9897937475,22)
VALUES('DEEPANSHU',102,6758729347,22);

INSERT INTO RACHITDB
VALUES ('DEEPANSHU',102,6758729347,22)

SELECT * FROM RACHITDB;


ALTER TABLE RACHITDB DROP COLUMN PHNO


ALTER TABLE RACHITDB ADD 
LASTNAME VARCHAR(50)


SELECT * FROM  RACHITDB

ALTER TABLE RACHITDB MODIFY  LASTNAME NUMBER 

 
 
 SELECT AGE , ID, NAME FROM RACHITDB


CREATE TABLE EMP_T
( NAME VARCHAR2(100) NOT NULL,
      ID  NUMBER NOT NULL ,
      ID1  NUMBER NOT NULL UNIQUE 
      )
      INSERT INTO EMP_T   VALUES ('F',10 ,20)


 create table orac
(
id number unique not null,
name varchar2(50),
address varchar2(100) default '55 chandan nagar dehradun',

)



alter table orac add column dob date default sysdate;

select * from user_tab_cols where table name = upper('orac');
select * from orac;
insert into orac (id,name,address) values (1,'rachit',);

[12:34] Govind Singh
Validation / implement rules / data integrity / consistency / linking 
  NOT NULL -  1.it restrict to capture or enter null values in table columns
              2.multiple columns can be not null 
     ORA-01400: cannot insert NULL into ("HR"."EMP_T"."NAME")
     


CREATE TABLE EMP_T
    ( NAME VARCHAR2(100) NOT NULL,
      ID  NUMBER  ,
      ID1  NUMBER 
      )




      CREATE TABLE EMP_T1
    ( NAME VARCHAR2(100) NOT NULL,
      ID  NUMBER  NOT NULL ,
      ID1  NUMBER 
      )



       alter table EMP_T MODIFY (ID NOT NULL)
  UNIQUE -    1.it restrict to capture unique values in table columns
              2.multiple columns can be not null 
      - can enter multiple null value in column - 
      -- ORA-00001: unique constraint (HR.SYS_C0010540) violated
    COLUMN LEVEL 




    CREATE TABLE EMP_T
      ( NAME VARCHAR2(100) NOT NULL,
      ID  NUMBER unique
      )



      not null + unique 



      TABLE LEVEL 
          




CREATE TABLE EMP_T
      ( NAME VARCHAR2(100) NOT NULL,
      ID  NUMBER,
      CONSTRAINT uq_id UNIQUE(ID)
      )





      CREATE TABLE EMP_T
      ( NAME VARCHAR2(100) NOT NULL,
      ID  NUMBER,
      CONSTRAINT uq_id UNIQUE(ID ,NAME)
      )




         ALTER OPTION 
         alter table EMP_T 
      add CONSTRAINT uq_first_name UNIQUE(FIRST_NAME)
      COMBINATION 



        alter table EMP_T 
      add CONSTRAINT uq_first_name UNIQUE(FIRST_NAME , LAST_NAME)
  PRIMARY KEY - unique identification of row | Link | 
     - not null value 
     - unique 
     - only on primary key is allowed 
         - with only one column 
           -- Column level 



          CREATE TABLE EMP_T
         (       ROLL_NO  NUMBER PRIMARY KEY ,
              FIRST_NAME VARCHAR2(100) ,
              LAST_NAME VARCHAR2(100),
              DEPARTMENT_ID NUMBER 
          )
        table level 
         CREATE TABLE EMP_T
         (       ROLL_NO  NUMBER  ,
              FIRST_NAME VARCHAR2(100) ,
              LAST_NAME VARCHAR2(100),
              DEPARTMENT_ID NUMBER ,
              CONSTRAINT pk_roll_no PRIMARY KEY(ROLL_NO))
          )


desc orac;


CREATE TABLE RP(ID NUMBER NOT NULL,NAME VARCHAR2(20))

ALTER TABLE RP MODIFY (NAME NOT NULL);

SELECT USER CONSTRAINT FROM RP;
SELECT * FROM RP;

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = UPPER('RP')

ALTER TABLE RP MODIFY ID NULL
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME ='RP'


CREATE TABLE DELL(NAME VARCHAR2(20), ID NUMBER UNIQUE, DEPARTMENT NUMBER)

SELECT *  FROM USER_CONSTRAINTS WHERE TABLE_NAME =UPPER( 'DELL')

ALTER TABLE DELL ADD CONSTRAINTS NAME_N UNIQUE(NAME)

SELECT * FROM DELL

ALTER TABLE DELL DISABLE CONSTRAINTS NAME_N

ALTER TABLE DELL ENABLE CONSTRAINTS NAME_N

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'EMPLOYEES'

CREATE TABLE DUMB(NAME VARCHAR2(10), ID NUMBER)


ALTER TABLE DUMB ADD CONSTRAINTS NAMEE UNIQUE(NAME), IDD UNIQUW(ID)


ALTER TABLE EMPLOYEES ADD CONSTRAINTS TEST1 UNIQUE(SALARY)


DROP TABLE RACHITPANWAR

--RACHIT PANWAR

 CREATE  TABLE RACHITPANWAR ( NAME  VARCHAR2(20) NOT NULL,ADDRESS VARCHAR2(10) NOT NULL, PHNO NUMBER UNIQUE, EMAIL VARCHAR(20) UNIQUE , EID  NUMBER NOT NULL UNIQUE, 
 AGE NUMBER NOT NULL UNIQUE, ID  NUMBER PRIMARY KEY ,DEPT VARCHAR(5),HIREDATE NUMBER,DESIGNATION VARCHAR2(10)) 
 
 
 SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='RACHITPANWAR'
 
 alter table  RACHITPANWAR DROP CONSTRAINTS SYS_C008350
 alter table  RACHITPANWAR DROP CONSTRAINTS SYS_C008351
 
 alter table  RACHITPANWAR DROP CONSTRAINTS SYS_C008352
 
 alter table  RACHITPANWAR DROP CONSTRAINTS SYS_C008353
 
 alter table  RACHITPANWAR DROP CONSTRAINTS SYS_C008354
 
 alter table  RACHITPANWAR DROP CONSTRAINTS SYS_C008355
 
 alter table  RACHITPANWAR DROP CONSTRAINTS SYS_C008356
 
  alter table  RACHITPANWAR ENABLE CONSTRAINTS SYS_C008351
 
 alter table  RACHITPANWAR ENABLE CONSTRAINTS SYS_C008352
 
 alter table  RACHITPANWAR ENABLE CONSTRAINTS SYS_C008353
  alter table  RACHITPANWAR ENABLE CONSTRAINTS SYS_C008354
   alter table  RACHITPANWAR ENABLE CONSTRAINTS SYS_C008355
    alter table  RACHITPANWAR ENABLE CONSTRAINTS SYS_C008356
    
    
    select * from USER_CONS_COLUMNS WHERE TABLE_NAME ='RACHITPANWAR'
    
    CHECk CONN
    

 drop table rachitpanwar
 
 
  create table rp_t (name varchar(20) ,id number not null check(id>10));
  
  
  drop table rp_t;
 
 
 insert into rp_t values ( 'rachit',12);
 
 insert into rp_t values('robin',19);
 
 insert into rp_t values ('rahul',10);
 
 select * from all_constraints where table_name ='rp_t';
 
 
 alter table rp_t disable CONSTRAINT SYS_C008279;
 
 
 create table tst ( id number , odate date default sysdate);
 
 
 insert into tst(id) values ('101' );
 select * from tst;
 
 
 select * from all_CONS_COLUMNS where table_name ='tst';
 
 create table intelloger
 (
 name varchar(20), eid number not null ,
 address varchar2(30))
 
 select * from employees;
 select * from departments;
 desc employees;
 select * from all_constraints where table_name = 'EMPLOYEES';
 
 
 SELECT * FROM v$version;
 
 drop table intelloger
 
 
  create table intelloger
 (
 name varchar(20), eid number primary key ,
 address varchar2(30))
 
create table company(employee_id number,pureadd varchar2(30),mail varchar2(20))
 
 drop table company;
 
 select * from all_constraints where lower(table_name) ='company';
 
 
alter table company enable constraints SYS_C008408 ;


alter table company disable constraints SYS_C008408 ;
 
 
 select * from all_constraints where lower(table_name) ='intelloger';
 
 alter table company add constraints ids foreign key (employee_id ) references intelloger (eid);
 
 alter table intelloger drop constraints SYS_C008408 ;
 
 alter table intelloger add constraints empid primary key(eid);
 
 
 
 
 
 
 
 
 