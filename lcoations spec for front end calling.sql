create or replace package BODY xxintg_locations_rp
as
PROCEDURE XXINTG_LOCATIONS
AS
CURSOR CUR_LOCATIONS(P_LOCATION_ID LOCATIONS.LOCATION_ID%TYPE)
IS
SELECT * FROM LOCATIONS WHERE LOCATION_ID=P_LOCATION_ID;
BEGIN
FOR REC_LOCATION IN CUR_LOCATIONS(1700)
LOOP
FND_FILE.PUT_LINE(FND_FILE.LOG,REC_LOCATION.LOCATION_ID||' '||REC_LOCATION.CITY||
' '||REC_LOCATION.STREET_ADDRESS||' '||REC_LOCATION.POSTAL_CODE||' '||REC_LOCATION.STATE_PROVINCE||
' '||REC_LOCATION.COUNTRY_ID);
FND_FILE.PUT_LINE(FND_FILE.OUTPUT,REC_LOCATION.LOCATION_ID||' '||REC_LOCATION.CITY||
' '||REC_LOCATION.STREET_ADDRESS||' '||REC_LOCATION.POSTAL_CODE||' '||REC_LOCATION.STATE_PROVINCE||
' '||REC_LOCATION.COUNTRY_ID);
END LOOP;
END XXINTG_LOCATIONS;
PROCEDURE MAIN_PROCEDURE(ERRBUFF OUT VARCHAR2, REETCODE OUT VARCHAR2)
AS
BEGIN
XXINTG_LOCATIONS;
END MAIN_PROCEDURE;
END xxintg_locations_rp;