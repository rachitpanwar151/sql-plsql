
CREATE TABLE rptbl2(
    empnumber varchar2(100),
    name VARCHAR2(300)
)
ORGANIZATION EXTERNAL(
    TYPE oracle_loader
    DEFAULT DIRECTORY rp1
    ACCESS PARAMETERS 
    (
    RECORDS DELIMITED BY NEWLINE
    FIELDS TERMINATED BY ',')
    LOCATION ('rpcsv.csv')
);



select * from rptbl2;