create or replace package body xx_regions
as
    PROCEDURE insertt (
        p_region_id   regions.region_id%TYPE,
        p_region_name regions.region_name%TYPE,
          p_status out varchar2,
        p_error out varchar2
    )
    as
    begin
    DBMS_OUTPUT.PUT_LINE('INSERTING DATA');
    INSERT INTO REGIONS VALUES( P_REGION_ID, P_REGION_NAME);
    EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('CANT INSERT DATA'||SQLCODE||'--'|| SQLERRM);
    end insertt;

    PROCEDURE updatee (
        p_region_id   regions.region_id%TYPE,
        p_region_name regions.region_name%TYPE,
          p_status out varchar2,
        p_error out varchar2
    )
    as
    begin
    update into regions 
    set
    region_id=nvl(p_region_id,region_id),
    region_name=nvl(p_region_name,region_name);
    exception when others then
    dbms_output.put_line(sqlcode||'-'||sqlerrm);
    end updatee;

    PROCEDURE v_insert (
        p_region_id   regions.region_id%TYPE,
        p_region_name regions.region_name%TYPE,
          p_status out varchar2,
        p_error out varchar2
    )
    as
    LN_COUNT NUMBER;
    begin
    p_STATUS:='V';
    
    IF P_REGION_ID IS  NULL
    THEN
    P_STATUS:='E';
    P_ERROR:=P_ERROR||'REGION IS CANNOT BE NULL';
    ELSE 
    SELECT COUNT(1) INTO LN_COUNT FROM REGIONS WHERE REGION_ID=P_REGION_ID;
    IF LN_COUNT=1
    THEN
    P_STATUS:='E';
    P_ERROR:=P_ERROR||' REGION ID ALREADY EXIST';
    END IF ;
    END IF;
    IF P_REGION_NAME IS NULL
    THEN
    P_STATUS:='E';
    P_ERROR:=P_ERROR||' REGION NAME CANNOT BE NULL';
    ELSE
    SELECT COUNT(1) INTO LN_COUNT FROM 
    end v_insert;

    PROCEDURE v_update (
        p_region_id   regions.region_id%TYPE,
        p_region_name regions.region_name%TYPE,
      p_status out varchar2,
        p_error out varchar2)
        as
        begin
        end v_update;


procedure mainn(p_region_id regions.region_id%TYPE,
p_region_name regions.region_name%type)
as
begin

end mainn;