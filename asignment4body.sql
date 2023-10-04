 create  or replace package body  name_to_id_in_dept
as
procedure updatee(
    p_dept_id  departments.department_id%type, 
    p_dept_name departments.department_name%type, 
    p_mngr_id departments.manager_id%type,
    p_loc_name locations.city%type,
    p_status out varchar2,
    p_error out varchar2)
    as
    ln_id varchar2(30);
    begin
    if p_loc_name is not null
    then
    select location_id into ln_id from locations where city=p_loc_name;   
    update departments
    set department_id =nvl(p_dept_id,department_id)
    , department_name=nvl(p_dept_name,department_name),
    manager_id=nvl(p_mngr_id,manager_id),
    location_id=nvl(ln_id,location_id)
    where p_dept_id=department_id;    
    end if;
    end updatee;
   
   procedure insertt(  p_dept_id  departments.department_id%type, 
    p_dept_name departments.department_name%type, 
    p_mngr_id departments.manager_id%type,
    p_loc_name locations.city%type,
    p_status out varchar2,
    p_error out varchar2)
    as
    ln_id varchar2(30);
    begin
    select location_id into ln_id from locations where city=p_loc_name;
    insert into departments VALUES(p_dept_id 
    , p_dept_name,
    p_mngr_id,
    ln_id);
    exception when others then
    dbms_output.put_line('lic_name doesnt exist'||sqlcode||'-'||sqlerrm);
    end insertt;  
    
    
    procedure VALIDATE_INSERTT(  p_dept_id  departments.department_id%type, 
    p_dept_name departments.department_name%type, 
    p_mngr_id departments.manager_id%type,
    p_loc_name locations.city%type,
    p_status out varchar2,
    p_error out varchar2)
    as
    LN_ID NUMBER:=0;
    LN_COUNT NUMBER:=0;
    begin
    p_status:='V';
    DBMS_OUTPUT.PUT_LINE('VALIDATING VALUES');
    IF P_DEPT_ID IS NULL
    THEN
    P_STATUS:='E';
    P_ERROR:=P_ERROR||'DEPARTMENTS IS CANNOT BE NULL';
    ELSE 
    SELECT COUNT(*) INTO LN_COUNT  FROM DEPARTMENTS WHERE DEPARTMENT_ID=P_DepT_ID;
    IF LN_COUNT=1
    THEN
    P_STATUS:='E';
    P_ERROR:=P_ERROR||'DEPARTMENT ID ALREADY EXIST';
    END IF;
    END IF;
    
    IF P_DEPT_NAME IS NULL
    THEN
    P_STATUS:='E';
    P_ERROR:=P_ERROR||'DEPARTMENTS NAME CANNOT BE NULL';
    ELSE 
    SELECT COUNT(*) INTO LN_COUNT  FROM DEPARTMENTS WHERE DEPARTMENT_NAME= P_DEPT_NAME;
    IF LN_COUNT=1
    THEN
    P_STATUS:='E';
    P_ERROR:=P_ERROR||'DEPARTMENT NAME ALREADY EXIST';
    END IF;
    END IF;
    
    IF P_MNGR_ID IS NULL THEN
    P_STATUS:='E';
    P_ERROR:=P_ERROR||'MANAGER ID CANNOT BE NULL';
  END IF;
    
    if p_loc_NAME is null
    then
    P_STATUS:='E';
    P_ERROR:=P_ERROR||'location name CANNOT BE NULL';
    else 
    select count(*) into ln_id from locations where city=p_loc_name;
    if ln_id<1
    then
    p_status:='E';
    P_ERROR:=P_ERROR||'LOCATION_NAME DOESNT EXIST';
    END IF;
     END IF;
     IF P_STATUS='V' THEN
     insertt(  p_dept_id  , 
    p_dept_name , 
    p_mngr_id ,
    p_loc_name ,P_STATUS,P_ERROR);
 END IF;
 end VALIDATE_INSERTT;
         
         PROCEDURE VALIDATEE_UPDATE(p_dept_id  departments.department_id%type, 
    p_dept_name departments.department_name%type, 
    p_mngr_id departments.manager_id%type,
    p_loc_name locations.city%type,
    p_status out varchar2,
    p_error out varchar2)
    as
    LN_ID NUMBER:=0;
    LN_COUNT NUMBER:=0;
    begin
    p_status:='V';
    DBMS_OUTPUT.PUT_LINE('VALIDATING VALUES');
    IF P_DEPT_ID IS NULL
    THEN
    P_STATUS:='E';
    P_ERROR:=P_ERROR||'DEPARTMENTS IS CANNOT BE NULL';
    END IF;
    
    IF P_DEPT_NAME IS NULL
    THEN
    P_STATUS:='E';
    P_ERROR:=P_ERROR||'DEPARTMENTS NAME CANNOT BE NULL';
    END IF;
    
    IF P_MNGR_ID IS NULL THEN
    P_STATUS:='E';
    P_ERROR:=P_ERROR||'MANAGER ID CANNOT BE NULL';
    ELSE 
    SELECT COUNT(*) INTO LN_COUNT  FROM DEPARTMENTS WHERE MANAGER_ID=P_MNGR_ID;
    IF LN_COUNT=1
    THEN
    P_STATUS:='E';
    P_ERROR:=P_ERRoR||'MANAGER ID ALREADY EXIST';
    END IF;
    END IF;
    
    if p_loc_NAME is null
    then
    P_STATUS:='E';
    P_ERROR:=P_ERROR||'location name CANNOT BE NULL';
    else 
    select count(*) into ln_id from locations where city=p_loc_name;
    if ln_id<1
    then
    p_status:='E';
    P_ERROR:=P_ERROR||'LOCATION_NAME DOESNT EXIST';
    END IF;
     END IF;
     IF P_STATUS='V'
     THEN
   updatee(
    p_dept_id  , 
    p_dept_name, 
    p_mngr_id ,
    p_loc_name,
    p_status ,
    p_error );
    END IF;
END VALIDATEE_UPDATE;


procedure mainn(
    p_dept_id       departments.department_id%type, 
    p_dept_name     departments.department_name%type, p_mngr_id departments.manager_id%type,
    p_loc_name      locations.city%type,
    p_status         out varchar2,
    p_error         out varchar2 )
    as
    ln_count number:=0;
    begin

        SELECT
            COUNT(*)
        INTO ln_count
        FROM
            employees
        WHERE
            p_dept_id = department_id;

        IF ln_count = 0 THEN
    validate_INSERTT(  p_dept_id , 
    p_dept_name , 
    p_mngr_id ,
    p_loc_name ,
    p_status ,
    p_error );
    else
    VALIDATEE_UPDATE(p_dept_id , 
    p_dept_name , 
    p_mngr_id ,
    p_loc_name,
    p_status,
    p_error );
    end if;
    end mainn;
    end name_to_id_in_dept;



----------------------------------CALLING-----------------------------------------------------------



DECLARE
L_ERROR VARCHAR2(7000);
L_STATUS VARCHAR2(1000);
BEGIN
name_to_id_in_dept.MAINN(5000,'DEEEEEEE',101,'Roma',L_ERROR,L_STATUS);
DBMS_OUTPUT.PUT_LINE(SQLCODE||'-'||SQLERRM);
 dbms_output.put_line(l_status
                         || '-'
                         || nvl(l_error, 'sucess'));
END;

SELECT* FROM DEPARTMENTS;
SELECT * FROM LOCATIONS;