SQL> SELECT SUBSTR('ABC.SINGH@GNMAIL.COM',1,3) FIRST_NAME,SUBSTR('ABC.SINGH@GMAIL.COM',5,9) SURNAME,SUBSTR('ABC.SINGH@GMAL.COM',11,15) MAIL_TYPE,SUBSTR('ABC.SINGH@GMAIL.COM',16,19) DOMAIN FROM DUAL;

select substr('first.last@gmail.com',instr('first.last@gmail.com','.')+1,instr('first.last@gmail.com','@')-length(substr('first.last@gmail.com',1,instr('first.last@gmail.com','.')+1))) last_name from dual;


create table emp_tes (name varchar2(100),last_name varchar2(100),id number);
insert into emp_tes values ('Amit','IT%ES_T',10);
insert into emp_tes values ('Bunty','IT_P_TYP',20);
insert into emp_tes values ('wenzu','WES_%%_TYU',30);
insert into emp_tes values ('Gabbar','%TYP%__TY%',40);
insert into emp_tes values ('Kaliya','AD_IT',50);
insert into emp_tes values ('David','SA_TBPA',60);



