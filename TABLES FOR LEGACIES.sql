
create table xxintg_lagacy1_stag
(
legacy_po_num number,
LINE_TYPE varchar2(200),
ORG_NAME varchar2(200),
VENDOR_NAME varchar2(200),
VENDOR_SITE_NAME varchar2(200),
BUYER_NAME varchar2(200),
PO_TYPE varchar2(200),
SHIP_TO_LOC_ID varchar2(200),
BILL_TO_LOC_ID varchar2(200),
ITEM_Name varchar2(200),
UOM_CODE  varchar2(200),
QUANTITY varchar2(200),
UNIT_PRICE number, 
CURRENCY_CODE varchar2(200),
LINE_NUM number,
status1_legacy1 varchar2(20),
error_legacy1 varchar2(2000)
,BATCH NUMBER,
ORG_ID NUMBER,
VENDOR_ID NUMBER,
VENDOR_SITE_ID NUMBER
);
ALTER TABLE  xxintg_lagacy1_stag
RENAME COLUMN BATCH_ID TO request_id;

SELECT * FROM XXINTG_LAGACY1_STAG;

create table xxintg_legacy2_stag
(

 legacy_po_num number,
 LINE_TYPE varchar2(200),
 ORG_NAME varchar2(200),
 SUPPLIER_NAME varchar2(200),
 SUPPLIER_SITE_CODE varchar2(200),
 AGENT_NAME varchar2(200),
 ITEM_Name varchar2(200) ,
 UOM_CODE varchar2(200),
 QUANTITY number,
 UNIT_PRICE number,
 CURRENCY_CODE varchar2(200),
 LINE_NUM number,
status_legacy2 varchar2(20),
error_legacy2 varchar2(2000),
REQUEST_ID NUMBER
);

alter table xxintg_legacy2_stag 
add record_id number;

create table xxintg_legacy3_stag
(
legacy_po_num number,
LINE_TYPE varchar2(200),
ORG_NAME varchar2(200),
SUPPLIER_NAME varchar2(200),
SUPPLIER_SITE_CODE varchar2(200),
ITEM_Name varchar2(200),
UOM_CODE varchar2(200),
status_legacy3 varchar2(200),
error_legacy3 varchar2(200),
request_id number
);


alter table xxintg_legacy3_stag 
add record_id number;


--------------------------------------------------------------------------------------------------

alter table xxintg_lagacy1_stag add record_id number;
drop table xxintg_lagacy1_stag;
select * from xxintg_lagacy1_stag;
TRUNCATE TABLE XXINTG_LAGACY1_STAG;
select * from xxintg_legacy2_stag;
TRUNCATE TABLE XXINTG_LEGACY2_STAG;
select * from   xxintg_legacy3_stag;
truncate table xxintg_legacy3_stag;

drop table xxintg_legacy2_stag;

select * from XXINTG_LEGACY_MAIN_STAGING_RP;
truncate table XXINTG_LEGACY_MAIN_STAGING_RP;
SELECT * FROM FND_LOOKUP_VALUES WHERE LOOKUP_TYPE=' XXINTG_LOOKUP_LEGACY_RP';
desc XXINTG_LEGACY_MAIN_STAGING_RP;
SELECT * FROM XXINTG_LEGACY_MAIN_STAGING_RP;
truncate table xxintg_legacy_main_staging_rp;