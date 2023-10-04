create or replace package xxintg_locations
as
    procedure
        main_locations ( 
        p_location_id     locations.location_id%TYPE,
        p_street_address  locations.street_address%TYPE,
        p_postal_CODE  locations.postal_CODE%TYPE,
        p_city            locations.city%TYPE,
        p_state_province locations.state_province%TYPE,
        p_country_id      locations.country_id%TYPE,
        p_status         out  VARCHAR2,
        p_error         out  VARCHAR2);
    end
        xxintg_locations;
        
        SELECT * FROM LOCATIONS;