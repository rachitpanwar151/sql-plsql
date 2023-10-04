CREATE OR REPLACE PACKAGE BODY XXINTG_EMP_NEW_DTL_RP
AS
PROCEDURE EMP_DTLS(P_EMP_ID EMPLOYEES.EMPLOYEE_ID%type)
AS
CURSOR CUR_EMP
is
select * from employees where employee_id=p_emp_id;
begin
for rec_emp in cur_emp loop
fnd_file.put_line(fnd_file.output,rec_emp.employee_id||' '||rec_emp.first_name);
end loop;
end emp_dtls;



PROCEDURE MAIN_PROCEDURE(ERRBUFF OUT VARCHAR2,REETCODE OUT VARCHAR2, P_EMPLOYEE_ID EMPLOYEES.EMPLOYEE_ID%TYPE)
AS 
BEGIN
emp_dtls(p_employee_id);
END MAIN_PROCEDURE;
END XXINTG_EMP_NEW_DTL_RP;