  create or replace package BODY xxintg_locations
as
    PROCEDURE insert_locations (
        p_location_id     locations.location_id%TYPE,
        p_street_address  locations.street_address%TYPE,
        p_postal_CODE  locations.postal_CODE%TYPE,
        p_city            locations.city%TYPE,
        p_state_province locations.state_province%TYPE,
        p_country_id      locations.country_id%TYPE,
        p_status        out  VARCHAR2,
        p_error          out VARCHAR2
    )
    AS
    BEGIN
     INSERT INTO LOCATIONS VALUES(
        p_location_id    ,
        p_street_address ,
        p_postal_CODE  ,
        p_city           ,
        p_state_province ,
        p_country_id      );
        EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('DATA CANT BE INSERTED'||SQLCODE||'-'||SQLERRM);
     END insert_locations;
     
     PROCEDURE VALIDATE_INSERT(
        p_location_id     locations.location_id%TYPE,
        p_street_address  locations.street_address%TYPE,
        p_postal_CODE  locations.postal_CODE%TYPE,
        p_city            locations.city%TYPE,
        p_state_province locations.state_province%TYPE,
        p_country_id      locations.country_id%TYPE,
        p_status     OUT     VARCHAR2,
        p_error        OUT   VARCHAR2)
        AS
        BEGIN
        IF P_LOCATION_ID IS NULL THEN
        P_STATUS:='E';
        P_ERROR:=P_ERROR||'LOCATION ID CANNOT BE NULL';
    END IF;
    
        IF P_STREET_ADDRESS  IS NULL THEN
        P_STATUS:='E';
        P_ERROR:=P_ERROR||' STREET ADDRESS CANNOT BE NULL';
    END IF;
    
        IF P_POSTAL_CODE IS NULL THEN
        P_STATUS:='E';
        P_ERROR :=P_ERROR||' POSTAL CODE CANNOT BE NULL';
    END IF;
    
        IF P_CITY IS NULL THEN
        P_STATUS:='E';
        P_ERROR :=P_ERROR||' CITY CANNOT BE NULL';
    END IF;
    
        IF P_STATE_PROVINCE IS NULL THEN
        P_STATUS:='E';
        P_ERROR :=P_ERROR||' STATE_PROVINCE CANNOT BE NULL';
    END IF;
    
    IF P_COUNTRY_ID IS NULL THEN
        P_STATUS:='E';
        P_ERROR :=P_ERROR||' COUNTRY ID  CANNOT BE NULL';
        END IF;
    END VALIDATE_INSERT;

 procedure update_LOCATIONS (
        p_location_id     locations.location_id%TYPE,
        p_street_address locations.street_address%TYPE,
 p_postal_CODE  locations.postal_CODE%TYPE,
        p_city            locations.city%TYPE,
        P_STATE_PROVINCE locations.state_provInce%TYPE,
        p_country_id      locations.country_id%TYPE,
        p_status        out  VARCHAR2,
        p_error         out  VARCHAR2 )
        AS
        BEGIN
        UPDATE LOCATIONS SET STREET_ADDRESS=NVL(P_STREET_ADDRESS,STREET_ADDRESS),
        POSTAL_CODE=NVL(P_POSTAL_CODE,POSTAL_CODE),
        CITY=NVL(P_CITY,CITY),STATE_PROVINCE=NVL(p_STATE_PROVINCE,STATE_PROVINCE),
        COUNTRY_ID=NVL(P_COUNTRY_ID,COUNTRY_ID)WHERE LOCATION_ID=P_LOCATION_ID;
        EXCEPTION WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('ERROR OCCURED '||SQLCODE||SQLERRM);
                
                END update_LOCATIONS;
                
                
                PROCEDURE VALIDATE_UPDATE_LOCATIONS(
        p_location_id     locations.location_id%TYPE,
        p_street_address locations.street_address%TYPE,
 p_postal_CODE  locations.postal_CODE%TYPE,
        p_city            locations.city%TYPE,
        P_STATE_PROVINCE locations.state_provInce%TYPE,
        p_country_id      locations.country_id%TYPE,
        p_status     out     VARCHAR2,
        p_error        out   VARCHAR2)
                AS
                             BEGIN
                IF LENGTH(P_STREET_ADDRESS)>500 THEN 
                P_STATUS:='E';
                P_ERROR:=P_ERROR||' LENGTH OF ADDRESS SHOULD NOT BE REATER THEN 500';
                END IF;
                IF LENGTH(P_POSTAL_CODE)<>6 THEN
                P_STATUS:='E';
                P_ERROR:=P_ERROR||' POSTAL ADDRESS SHOULD HAVE 6 DIGIT NUMBER';
                ELSE 
        IF P_POSTAL_CODE IS NULL THEN
        P_STATUS:='E';
        P_ERROR :=P_ERROR||' POSTAL CODE CANNOT BE NULL';
    END IF;
    END IF;
        IF P_CITY IS NULL THEN
        P_STATUS:='E';
        P_ERROR :=P_ERROR||' CITY CANNOT BE NULL';
    END IF;
    
        IF P_STATE_PROVINCE IS NULL THEN
        P_STATUS:='E';
        P_ERROR :=P_ERROR||' STATE_PROVINCE CANNOT BE NULL';
    END IF;
    
    IF P_COUNTRY_ID IS NULL THEN
        P_STATUS:='E';
        P_ERROR :=P_ERROR||' COUNTRY ID  CANNOT BE NULL';
        END IF;
        END VALIDATE_UPDATE_LOCATIONS;
        procedure
        main_locations ( 
        p_location_id     locations.location_id%TYPE,
        p_street_address  locations.street_address%TYPE,
        p_postal_CODE  locations.postal_CODE%TYPE,
        p_city            locations.city%TYPE,
        p_state_province locations.state_province%TYPE,
        p_country_id      locations.country_id%TYPE,
        p_status         out  VARCHAR2,
        p_error          out  VARCHAR2)
        AS
        BEGIN
        IF P_LOCATION_ID IS NULL THEN
    VALIDATE_INSERT(    p_location_id  ,
        p_street_address,
        p_postal_CODE  ,
        p_city          ,
        p_state_province,
        p_country_id    ,
        p_status        ,
        p_error         );
        IF P_STATUS='V' THEN
INSERT_LOCATIONS(   p_location_id   ,
        p_street_address ,
        p_postal_CODE  ,
        p_city           ,
        p_state_province ,
        p_country_id     ,
        p_status         ,
        p_error        
        ); END IF;
ELSE         
VALIDATE_UPDATE_LOCATIONS(p_location_id  ,
        p_street_address ,
 p_postal_CODE  ,
        p_city           ,
        P_STATE_PROVINCE ,
        p_country_id ,
        p_status     ,
        p_error        );
IF P_STATUS='V' THEN
update_LOCATIONS (       p_location_id  ,
        p_street_address ,
 p_postal_CODE  ,
        p_city           ,
        P_STATE_PROVINCE ,
        p_country_id      ,
        p_status          ,
        p_error               );
        END IF;
        END IF;
        END main_locations;   
    END xxintg_locations;