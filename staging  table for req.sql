create table stag_req
(
operation_name varchar2(200),
operating_id number,
legacy_req_number number,
req_number number,
preparer_id number,
preparer_name varchar2(300),
req_type varchar2(200),
authorization_status varchar2(200),
total_amt number,
req_header_id number,
req_line_id number,
item_description varchar2(2000),
line_num number,
line_type varchar2(300),
item_id number,
item_name varchar2(300),
category varchar2(300),
unit_of_measure varchar2(20),
quantity number,
price number,
deliver_to_loc_id number,
deliver_to_loc_name varchar2(300),
destination_type varchar2(300),
organisation_id number,
supplier_id number,
supplier_name varchar2(300),
supplier_site_id number,
supplier_site_name varchar2(300),
oraganisation_name varchar2(200),
requester_id number,
requester_name varchar2(200),
req_source varchar2(300),
need_by_date date,
created_by varchar2(200),
created_date date,
last_upadated_by varchar2(300),
last_updated_date date,
request_id number,
record_id number,
error_msg varchar2(3000),
status varchar2(3)
);





CREATE SEQUENCE RECORD_ID_SEQ_RP
START WITH 1
INCREMENT BY 1;


select * from stag_req;

drop table stag_req;