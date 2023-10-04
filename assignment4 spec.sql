create  or replace package  name_to_id_in_dept
as  procedure  mainn (
    p_dept_id
    departments.department_id%type, p_dept_name
    departments.department_name%type, p_mngr_id departments.manager_id%type, p_loc_name
    locations.city%type
    ,
    p_status out varchar2,
    p_error out varchar2 );
    end
        name_to_id_in_dept;
