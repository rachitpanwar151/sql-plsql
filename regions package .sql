CREATE OR REPLACE PACKAGE xx_regions AS
    PROCEDURE mainn (
        p_region_id in  regions.region_id%TYPE,
        p_region_name in regions.region_name%TYPE,
        p_status out varchar2,
        p_error out varchar2
    );

END xx_regions;