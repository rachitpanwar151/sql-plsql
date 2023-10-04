CREATE TABLE emp_ext(
    empnumber varchar2(100),
    name VARCHAR2(300)
)
ORGANIZATION EXTERNAL(
    TYPE oracle_loader
    DEFAULT DIRECTORY external_testing
    ACCESS PARAMETERS 
    (
    RECORDS DELIMITED BY NEWLINE
    FIELDS TERMINATED BY ',')
    LOCATION ('RACHIT_PANWAR.csv')
);


SELECT * FROM emp_ext;



--External tabel - 

--connect to hr database with sysdba or sys    --sql plus may yay likho

create directory external_testing as 'C:\extrenal_table_rp';

grant read,write on directory external_testing to hr;

--
--SELECT DISTINCT * FROM COUNTRIES C , LOCATIONSL WHERE L.LOCATION_ID=C.LOCATION_ID AND C.COUNTRY_NAME ='Brazil';
--XXINTG_COUNTRIES
--
--XXINTG_CITY_DEPENDENT