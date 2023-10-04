
--------------------------------------------CALLING OF PACKAGE------------------------------------------------------------------

insert into xxintg_emp_rp
select * from employees;
commit;
SELECT
    *
FROM
   xxintg_emp_rp;

DECLARE
    l_s VARCHAR2(3000);
    l_v VARCHAR2(3000);
BEGIN
    proce.main(210, 'HEMU', 'POK', 'HP@micros', '1122334455',
              sysdate+1, 'SA_REP', 5000, 0.5, 100,
              90, l_s, l_v);
              if l_s <>'V' then
              dbms_output.put_line('Error Report : '||l_v);
              end if;
END;
