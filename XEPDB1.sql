desc employees; 

begin
for i in 1..4
loop
for j in 1..3
loop
dbms_output.put_line(j);
end loop ;
end loop ;
end;

select FIRST_NAME, trim(replace(LOWER(first_name),'li',' ')),LAST_NAME from employees;

 select first_name from employees where trim(replace(first_name,'li',' '))='li';

SELECT FIRST_NAME FROM EMPLOYEES WHERE SUBSTR(LOWER(FIRST_NAME),1,LENGTH(FIRST_NAME))=LENGTH(FIRST_;

begin
for i in 1..4
loop
for j in 1..3
loop
for k in 1..2
loop
dbms_output.put_line('hello');
end loop ;
dbms_output.put_line('hi');
end loop ;
dbms_output.put_line('helii');
end loop;
end;


select * from emp1;

alter table emp1 add surname varchar2(10);  

alter table emp1 add (father_name varchar2(20), mother_name varchar2(
25

ALTER TABLE EMP1 MODIFY FATHER_NAME VARCHAR2(50);

INSERT INTO EMP1  VALUE('SURENDRASINGHPANWAR');

ALTER TABLE EMP1 DROP COLUMN SURNAME ; 

ALTER TABLE EMP1 RENAME  COLUMN SURNAME  TO CAST_NAME;

