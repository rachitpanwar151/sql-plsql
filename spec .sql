create or replace package xxing_updation_through_cursor
as
procedure main_procedure(p_dept_id employees.department_id%type, p_percentage_inc varchar2);
end  xxing_updation_through_cursor;