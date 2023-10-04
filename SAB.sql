select * from rp_vm;	
select * from po_lines_all;		
create materialized view po_info_rp
refresh complete on demand 
as
select * from rp_vm;
select * from po_lines_all;		
select * from rp_mv;		
BEGIN dbms_mview.refresh('rp_mv',atomic_refresh=>TRUE); END;
create materialized view rp_mv
refresh complete on demand
as
select * from po.po_headers_all;	
drop materialized view rp_mv;	
create materialized view rp_mv
as
select * from po.po_headers_all;	
create view rp_vm
as
select * from po.po_headers_all;
SELECT
    party.party_name                                                                          sold_to,
    cust_acct.account_number                                                                  customer_number,
    h.cust_po_number,
    h.cust_po_number,
    sold_party.person_last_name
    || decode(sold_party.person_first_name, NULL, NULL, ', ' || sold_party.person_first_name) sold_to_contact,
    ship_su.location                                                                          ship_to_location,
    ship_loc.address1                                                                         ship_to_address1,
    decode(ship_loc.city, NULL, NULL, ship_loc.city || ', ')
    || decode(ship_loc.state, NULL, ship_loc.province || ', ', ship_loc.state || ', ')
    || decode(ship_loc.postal_code, NULL, NULL, ship_loc.postal_code || ', ')
    || decode(ship_loc.country, NULL, NULL, ship_loc.country)                                 ship_to_address5,
    bill_su.location                                                                          invoice_to_location,
    decode(bill_loc.city, NULL, NULL, bill_loc.city || ', ')
    || decode(bill_loc.state, NULL, bill_loc.province || ', ', bill_loc.state || ', ')
    || decode(bill_loc.postal_code, NULL, NULL, bill_loc.postal_code || ', ')
    || decode(bill_loc.country, NULL, NULL, bill_loc.country)                                 invoice_to_address5,
    h.order_number,
    ot.name                                                                                   order_type,
    h.ordered_date,
    pl.name                                                                                   price_list,
    h.salesrep_id,
    h.transactional_curr_code,
    h.flow_status_code,
    h.user_status_code
FROM
    hz_parties              party,
    hz_cust_accounts        cust_acct,
    oe_order_headers        h,
    hz_cust_site_uses_all   ship_su,
    hz_parties              sold_party,
    hz_locations            ship_loc,
    hz_cust_site_uses_all   bill_su,
    hz_locations            bill_loc,
    oe_transaction_types_tl ot,
    qp_list_headers_tl      pl
WHERE
        h.order_type_id = ot.transaction_type_id
    AND h.price_list_id = pl.list_header_id (+)
    AND h.sold_to_org_id = cust_acct.cust_account_id (+)
    AND cust_acct.party_id = party.party_id (+)
    AND h.ship_to_org_id = ship_su.site_use_id (+)
    AND h.invoice_to_org_id = bill_su.site_use_id (+)
    AND h.order_number = 69369;		1695723725438	SQL	1	0.655
SELECT
    party.party_name                                                                          sold_to,
    cust_acct.account_number                                                                  customer_number,
    h.cust_po_number,
    h.cust_po_number,
    sold_party.person_last_name
    || decode(sold_party.person_first_name, NULL, NULL, ', ' || sold_party.person_first_name) sold_to_contact,
    ship_su.location                                                                          ship_to_location,
    ship_loc.address1                                                                         ship_to_address1,
    decode(ship_loc.city, NULL, NULL, ship_loc.city || ', ')
    || decode(ship_loc.state, NULL, ship_loc.province || ', ', ship_loc.state || ', ')
    || decode(ship_loc.postal_code, NULL, NULL, ship_loc.postal_code || ', ')
    || decode(ship_loc.country, NULL, NULL, ship_loc.country)                                 ship_to_address5,
    bill_su.location                                                                          invoice_to_location,
    decode(bill_loc.city, NULL, NULL, bill_loc.city || ', ')
    || decode(bill_loc.state, NULL, bill_loc.province || ', ', bill_loc.state || ', ')
    || decode(bill_loc.postal_code, NULL, NULL, bill_loc.postal_code || ', ')
    || decode(bill_loc.country, NULL, NULL, bill_loc.country)                                 invoice_to_address5,
    h.order_number,
    ot.name                                                                                   order_type,
    h.ordered_date,
    pl.name                                                                                   price_list,
    h.salesrep_id,
    h.transactional_curr_code,
    h.flow_status_code,
    h.user_status_code
FROM
    hz_parties              party,
    hz_cust_accounts        cust_acct,
    oe_order_headers        h,
    hz_cust_site_uses_all   ship_su,
    hz_parties              sold_party,
    hz_locations            ship_loc,
    hz_cust_site_uses_all   bill_su,
    hz_locations            bill_loc,
    oe_transaction_types_tl ot,
    qp_list_headers_tl      pl
WHERE
        h.order_type_id = ot.transaction_type_id
    AND h.price_list_id = pl.list_header_id (+)
    AND h.sold_to_org_id = cust_acct.cust_account_id (+)
    AND cust_acct.party_id = party.party_id (+)
    AND h.ship_to_org_id = ship_su.site_use_id (+)
    AND h.invoice_to_org_id = bill_su.site_use_id (+)
    AND h.order_number = 69398;		
    
SELECT
    party.party_name                                                                          sold_to,
    cust_acct.account_number                                                                  customer_number,
    h.cust_po_number,
    h.cust_po_number,
    sold_party.person_last_name
    || decode(sold_party.person_first_name, NULL, NULL, ', ' || sold_party.person_first_name) sold_to_contact,
    ship_su.location                                                                          ship_to_location,
    ship_loc.address1                                                                         ship_to_address1,
    decode(ship_loc.city, NULL, NULL, ship_loc.city || ', ')
    || decode(ship_loc.state, NULL, ship_loc.province || ', ', ship_loc.state || ', ')
    || decode(ship_loc.postal_code, NULL, NULL, ship_loc.postal_code || ', ')
    || decode(ship_loc.country, NULL, NULL, ship_loc.country)                                 ship_to_address5,
    bill_su.location                                                                          invoice_to_location,
    decode(bill_loc.city, NULL, NULL, bill_loc.city || ', ')
    || decode(bill_loc.state, NULL, bill_loc.province || ', ', bill_loc.state || ', ')
    || decode(bill_loc.postal_code, NULL, NULL, bill_loc.postal_code || ', ')
    || decode(bill_loc.country, NULL, NULL, bill_loc.country)                                 invoice_to_address5,
    h.order_number,
    ot.name                                                                                   order_type,
    h.ordered_date,
    pl.name                                                                                   price_list,
    h.salesrep_id,
    h.transactional_curr_code,
    h.flow_status_code,
    h.user_status_code
FROM
    hz_parties              party,
    hz_cust_accounts        cust_acct,
    oe_order_headers        h,
    hz_cust_site_uses_all   ship_su,
    hz_parties              sold_party,
    hz_locations            ship_loc,
    hz_cust_site_uses_all   bill_su,
    hz_locations            bill_loc,
    oe_transaction_types_tl ot,
    qp_list_headers_tl      pl
WHERE
        h.order_type_id = ot.transaction_type_id
    AND h.price_list_id = pl.list_header_id (+)
    AND h.sold_to_org_id = cust_acct.cust_account_id (+)
    AND cust_acct.party_id = party.party_id (+)
    AND h.ship_to_org_id = ship_su.site_use_id (+)
    AND h.invoice_to_org_id = bill_su.site_use_id (+)
    AND h.order_number = 69381;		
SELECT
    party.party_name                                                                          sold_to,
    cust_acct.account_number                                                                  customer_number,
    h.cust_po_number,
    h.cust_po_number,
    sold_party.person_last_name
    || decode(sold_party.person_first_name, NULL, NULL, ', ' || sold_party.person_first_name) sold_to_contact,
    ship_su.location                                                                          ship_to_location,
    ship_loc.address1                                                                         ship_to_address1,
    decode(ship_loc.city, NULL, NULL, ship_loc.city || ', ')
    || decode(ship_loc.state, NULL, ship_loc.province || ', ', ship_loc.state || ', ')
    || decode(ship_loc.postal_code, NULL, NULL, ship_loc.postal_code || ', ')
    || decode(ship_loc.country, NULL, NULL, ship_loc.country)                                 ship_to_address5,
    bill_su.location                                                                          invoice_to_location,
    decode(bill_loc.city, NULL, NULL, bill_loc.city || ', ')
    || decode(bill_loc.state, NULL, bill_loc.province || ', ', bill_loc.state || ', ')
    || decode(bill_loc.postal_code, NULL, NULL, bill_loc.postal_code || ', ')
    || decode(bill_loc.country, NULL, NULL, bill_loc.country)                                 invoice_to_address5,
    h.order_number,
    ot.name                                                                                   order_type,
    h.ordered_date,
    pl.name                                                                                   price_list,
    h.salesrep_id,
    h.transactional_curr_code,
    h.flow_status_code,
    h.user_status_code
FROM
    hz_parties              party,
    hz_cust_accounts        cust_acct,
    oe_order_headers        h,
    hz_cust_site_uses_all   ship_su,
    hz_parties              sold_party,
    hz_locations            ship_loc,
    hz_cust_site_uses_all   bill_su,
    hz_locations            bill_loc,
    oe_transaction_types_tl ot,
    qp_list_headers_tl      pl
WHERE
        h.order_type_id = ot.transaction_type_id
    AND h.price_list_id = pl.list_header_id (+)
    AND h.sold_to_org_id = cust_acct.cust_account_id (+)
    AND cust_acct.party_id = party.party_id (+)
    AND h.ship_to_org_id = ship_su.site_use_id (+)
    AND h.invoice_to_org_id = bill_su.site_use_id (+)
    AND h.order_number = 69390;		
BEGIN dbms_mview.refresh('PO_INFO_mv_rp',atomic_refresH=>TRUE); END;;		
select * from PO_INFO_mv_rp;		
SELECT * from PO_info_vw_rp;		
CREATE VIEW PO_info_vw_rp
AS
SELECT * FROM PO_HEADERS_ALL;		
CREATE MATERIALIZED VIEW PO_INFO_mv_rp
AS
SELECT * FROM PO.PO_HEADERS_ALL  WHERE ORG_ID=204;		
select * from PO_INFO;		
SELECT * from po;	
CREATE MATERIALIZED VIEW PO_INFO
AS
SELECT * FROM PO.PO_HEADERS_ALL  WHERE ORG_ID=204;	
CREATE VIEW PO
AS
SELECT * FROM PO_HEADERS_ALL;		
CREATE MATERIALIZED VIEW PO_INFO
AS
SELECT * FROM PO_HEADERS_ALL;
SELECT * FROM PO_LINES_ALL WHERE;	
SELECT * FROM PO_LINES_ALL;		
SELECT * FROM PO_HEADERS_ALL;		
SELECT
 party.party_name  SOLD_TO
 ,  cust_acct.account_number  CUSTOMER_NUMBER,
  h.cust_po_number,
  h.cust_po_number,
   sold_party.person_last_name
        || decode(sold_party.person_first_name, NULL, NULL, ', ' || sold_party.person_first_name)       sold_to_contact,
             ship_su.location                                                                                ship_to_location
,

        ship_loc.address1                                                                               ship_to_address1,

        decode(ship_loc.city, NULL, NULL, ship_loc.city || ', ')
        || decode(ship_loc.state, NULL, ship_loc.province || ', ', ship_loc.state || ', ')
        || decode(ship_loc.postal_code, NULL, NULL, ship_loc.postal_code || ', ')
        || decode(ship_loc.country, NULL, NULL, ship_loc.country)                                       ship_to_address5


,bill_su.location                                                                                invoice_to_location,
         decode(bill_loc.city, NULL, NULL, bill_loc.city || ', ')
        || decode(bill_loc.state, NULL, bill_loc.province || ', ', bill_loc.state || ', ')
        || decode(bill_loc.postal_code, NULL, NULL, bill_loc.postal_code || ', ')
        || decode(bill_loc.country, NULL, NULL, bill_loc.country)                                       invoice_to_address5
       , h.order_number,
               ot.name     order_type,
               h.ordered_date,
        pl.name                                                                                         price_list,
       h.salesrep_id,
        h.transactional_curr_code,
        h.flow_status_code,
         h.user_status_code
FROM
  hz_parties              party,
   hz_cust_accounts        cust_acct,
      oe_order_headers        h,
       hz_cust_site_uses_all   ship_su,
        hz_parties              sold_party,
        hz_locations            ship_loc,
        hz_cust_site_uses_all   bill_su,
        hz_locations            bill_loc,
        oe_transaction_types_tl ot, 
        qp_list_headers_tl      pl




        WHERE
     h.order_type_id = ot.transaction_type_id
      AND h.price_list_id = pl.list_header_id (+)
        AND h.sold_to_org_id = cust_acct.cust_account_id (+)
        AND cust_acct.party_id = party.party_id (+)
           AND h.ship_to_org_id = ship_su.site_use_id (+)
      AND h.invoice_to_org_id = bill_su.site_use_id (+)
AND 
h.order_number=69390;		
SELECT
 party.party_name  SOLD_TO
 ,  cust_acct.account_number  CUSTOMER_NUMBER,
  h.cust_po_number,
  h.cust_po_number,
   sold_party.person_last_name
        || decode(sold_party.person_first_name, NULL, NULL, ', ' || sold_party.person_first_name)       sold_to_contact,
             ship_su.location                                                                                ship_to_location
,

        ship_loc.address1                                                                               ship_to_address1,

        decode(ship_loc.city, NULL, NULL, ship_loc.city || ', ')
        || decode(ship_loc.state, NULL, ship_loc.province || ', ', ship_loc.state || ', ')
        || decode(ship_loc.postal_code, NULL, NULL, ship_loc.postal_code || ', ')
        || decode(ship_loc.country, NULL, NULL, ship_loc.country)                                       ship_to_address5


,bill_su.location                                                                                invoice_to_location,
         decode(bill_loc.city, NULL, NULL, bill_loc.city || ', ')
        || decode(bill_loc.state, NULL, bill_loc.province || ', ', bill_loc.state || ', ')
        || decode(bill_loc.postal_code, NULL, NULL, bill_loc.postal_code || ', ')
        || decode(bill_loc.country, NULL, NULL, bill_loc.country)                                       invoice_to_address5
       , h.order_number,
               ot.name     order_type,
               h.ordered_date,
        pl.name                                                                                         price_list,
       h.salesrep_id,
        h.transactional_curr_code,
        h.flow_status_code,
         h.user_status_code
FROM
  hz_parties              party,
   hz_cust_accounts        cust_acct,
      oe_order_headers        h,
       hz_cust_site_uses_all   ship_su,
        hz_parties              sold_party,
        hz_locations            ship_loc,
        hz_cust_site_uses_all   bill_su,
        hz_locations            bill_loc,
        oe_transaction_types_tl ot, 
        qp_list_headers_tl      pl




        WHERE
     h.order_type_id = ot.transaction_type_id
--      AND h.price_list_id = pl.list_header_id (+)
--        AND h.sold_to_org_id = cust_acct.cust_account_id (+)
        AND cust_acct.party_id = party.party_id (+)
           AND h.ship_to_org_id = ship_su.site_use_id (+)
      AND h.invoice_to_org_id = bill_su.site_use_id (+)
AND 
h.order_number=69390;		
SELECT
 party.party_name  SOLD_TO
 ,  cust_acct.account_number  CUSTOMER_NUMBER,
  h.cust_po_number,
  h.cust_po_number,
   sold_party.person_last_name
        || decode(sold_party.person_first_name, NULL, NULL, ', ' || sold_party.person_first_name)       sold_to_contact,
             ship_su.location                                                                                ship_to_location
,

        ship_loc.address1                                                                               ship_to_address1,

        decode(ship_loc.city, NULL, NULL, ship_loc.city || ', ')
        || decode(ship_loc.state, NULL, ship_loc.province || ', ', ship_loc.state || ', ')
        || decode(ship_loc.postal_code, NULL, NULL, ship_loc.postal_code || ', ')
        || decode(ship_loc.country, NULL, NULL, ship_loc.country)                                       ship_to_address5


,bill_su.location                                                                                invoice_to_location,
         decode(bill_loc.city, NULL, NULL, bill_loc.city || ', ')
        || decode(bill_loc.state, NULL, bill_loc.province || ', ', bill_loc.state || ', ')
        || decode(bill_loc.postal_code, NULL, NULL, bill_loc.postal_code || ', ')
        || decode(bill_loc.country, NULL, NULL, bill_loc.country)                                       invoice_to_address5
       , h.order_number,
               ot.name     order_type,
               h.ordered_date,
        pl.name                                                                                         price_list,
       h.salesrep_id,
        h.transactional_curr_code,
        h.flow_status_code,
         h.user_status_code
FROM
  hz_parties              party,
   hz_cust_accounts        cust_acct,
      oe_order_headers        h,
       hz_cust_site_uses_all   ship_su,
        hz_parties              sold_party,
        hz_locations            ship_loc,
        hz_cust_site_uses_all   bill_su,
        hz_locations            bill_loc,
        oe_transaction_types_tl ot, 
        qp_list_headers_tl      pl




        WHERE
     h.order_type_id = ot.transaction_type_id
--      AND h.price_list_id = pl.list_header_id (+)
--        AND h.sold_to_org_id = cust_acct.cust_account_id (+)
--        AND cust_acct.party_id = party.party_id (+)
           AND h.ship_to_org_id = ship_su.site_use_id (+)
      AND h.invoice_to_org_id = bill_su.site_use_id (+)
AND 
h.order_number=69390;		1695713215252	SQL	1	1.902
SELECT
 party.party_name  SOLD_TO
 ,  cust_acct.account_number  CUSTOMER_NUMBER,
  h.cust_po_number,
  h.cust_po_number,
   sold_party.person_last_name
        || decode(sold_party.person_first_name, NULL, NULL, ', ' || sold_party.person_first_name)       sold_to_contact,
             ship_su.location                                                                                ship_to_location
,

        ship_loc.address1                                                                               ship_to_address1,

        decode(ship_loc.city, NULL, NULL, ship_loc.city || ', ')
        || decode(ship_loc.state, NULL, ship_loc.province || ', ', ship_loc.state || ', ')
        || decode(ship_loc.postal_code, NULL, NULL, ship_loc.postal_code || ', ')
        || decode(ship_loc.country, NULL, NULL, ship_loc.country)                                       ship_to_address5


,bill_su.location                                                                                invoice_to_location,
         decode(bill_loc.city, NULL, NULL, bill_loc.city || ', ')
        || decode(bill_loc.state, NULL, bill_loc.province || ', ', bill_loc.state || ', ')
        || decode(bill_loc.postal_code, NULL, NULL, bill_loc.postal_code || ', ')
        || decode(bill_loc.country, NULL, NULL, bill_loc.country)                                       invoice_to_address5
       , h.order_number,
               ot.name     order_type,
               h.ordered_date,
        pl.name                                                                                         price_list,
       h.salesrep_id,
        h.transactional_curr_code,
        h.flow_status_code,
         h.user_status_code
FROM
  hz_parties              party,
   hz_cust_accounts        cust_acct,
      oe_order_headers        h,
       hz_cust_site_uses_all   ship_su,
        hz_parties              sold_party,
        hz_locations            ship_loc,
        hz_cust_site_uses_all   bill_su,
        hz_locations            bill_loc,
        oe_transaction_types_tl ot, 
        qp_list_headers_tl      pl




        WHERE
     h.order_type_id = ot.transaction_type_id
--      AND h.price_list_id = pl.list_header_id (+)
--        AND h.sold_to_org_id = cust_acct.cust_account_id (+)
--        AND cust_acct.party_id = party.party_id (+)
--           AND h.ship_to_org_id = ship_su.site_use_id (+)
      AND h.invoice_to_org_id = bill_su.site_use_id (+)
AND 
h.order_number=69390;		1695713184682	SQL	1	0.28
SELECT
 party.party_name  SOLD_TO
 ,  cust_acct.account_number  CUSTOMER_NUMBER,
  h.cust_po_number,
  h.cust_po_number,
   sold_party.person_last_name
        || decode(sold_party.person_first_name, NULL, NULL, ', ' || sold_party.person_first_name)       sold_to_contact,
             ship_su.location                                                                                ship_to_location
,

        ship_loc.address1                                                                               ship_to_address1,

        decode(ship_loc.city, NULL, NULL, ship_loc.city || ', ')
        || decode(ship_loc.state, NULL, ship_loc.province || ', ', ship_loc.state || ', ')
        || decode(ship_loc.postal_code, NULL, NULL, ship_loc.postal_code || ', ')
        || decode(ship_loc.country, NULL, NULL, ship_loc.country)                                       ship_to_address5


,bill_su.location                                                                                invoice_to_location,
         decode(bill_loc.city, NULL, NULL, bill_loc.city || ', ')
        || decode(bill_loc.state, NULL, bill_loc.province || ', ', bill_loc.state || ', ')
        || decode(bill_loc.postal_code, NULL, NULL, bill_loc.postal_code || ', ')
        || decode(bill_loc.country, NULL, NULL, bill_loc.country)                                       invoice_to_address5
       , h.order_number,
               ot.name     order_type,
               h.ordered_date,
        pl.name                                                                                         price_list,
       h.salesrep_id,
        h.transactional_curr_code,
        h.flow_status_code,
         h.user_status_code
FROM
  hz_parties              party,
   hz_cust_accounts        cust_acct,
      oe_order_headers        h,
       hz_cust_site_uses_all   ship_su,
        hz_parties              sold_party,
        hz_locations            ship_loc,
        hz_cust_site_uses_all   bill_su,
        hz_locations            bill_loc,
        oe_transaction_types_tl ot, 
        qp_list_headers_tl      pl




        WHERE
     h.order_type_id = ot.transaction_type_id
--      AND h.price_list_id = pl.list_header_id (+)
--        AND h.sold_to_org_id = cust_acct.cust_account_id (+)
--        AND cust_acct.party_id = party.party_id (+)
--           AND h.ship_to_org_id = ship_su.site_use_id (+)
--      AND h.invoice_to_org_id = bill_su.site_use_id (+)
AND 
h.order_number=69390;		
SELECT
 party.party_name  SOLD_TO
 ,  cust_acct.account_number  CUSTOMER_NUMBER,
  h.cust_po_number,
  h.cust_po_number,
   sold_party.person_last_name
        || decode(sold_party.person_first_name, NULL, NULL, ', ' || sold_party.person_first_name)       sold_to_contact,
             ship_su.location                                                                                ship_to_location
,

        ship_loc.address1                                                                               ship_to_address1,

        decode(ship_loc.city, NULL, NULL, ship_loc.city || ', ')
        || decode(ship_loc.state, NULL, ship_loc.province || ', ', ship_loc.state || ', ')
        || decode(ship_loc.postal_code, NULL, NULL, ship_loc.postal_code || ', ')
        || decode(ship_loc.country, NULL, NULL, ship_loc.country)                                       ship_to_address5


,bill_su.location                                                                                invoice_to_location,
         decode(bill_loc.city, NULL, NULL, bill_loc.city || ', ')
        || decode(bill_loc.state, NULL, bill_loc.province || ', ', bill_loc.state || ', ')
        || decode(bill_loc.postal_code, NULL, NULL, bill_loc.postal_code || ', ')
        || decode(bill_loc.country, NULL, NULL, bill_loc.country)                                       invoice_to_address5
       , h.order_number,
               ot.name     order_type,
               h.ordered_date,
        pl.name                                                                                         price_list,
       h.salesrep_id,
        h.transactional_curr_code,
        h.flow_status_code,
         h.user_status_code
FROM
  hz_parties              party,
   hz_cust_accounts        cust_acct,
      oe_order_headers        h,
       hz_cust_site_uses_all   ship_su,
        hz_parties              sold_party,
        hz_locations            ship_loc,
        hz_cust_site_uses_all   bill_su,
        hz_locations            bill_loc,
        oe_transaction_types_tl ot, 
        qp_list_headers_tl      pl




        WHERE
--     h.order_type_id = ot.transaction_type_id
--      AND h.price_list_id = pl.list_header_id (+)
--        AND h.sold_to_org_id = cust_acct.cust_account_id (+)
--        AND cust_acct.party_id = party.party_id (+)
--           AND h.ship_to_org_id = ship_su.site_use_id (+)
--      AND h.invoice_to_org_id = bill_su.site_use_id (+)
--AND 
h.order_number=69390;		
SELECT
 party.party_name  SOLD_TO
 ,  cust_acct.account_number  CUSTOMER_NUMBER,
  h.cust_po_number,
  h.cust_po_number,
   sold_party.person_last_name
        || decode(sold_party.person_first_name, NULL, NULL, ', ' || sold_party.person_first_name)       sold_to_contact,
             ship_su.location                                                                                ship_to_location
,

        ship_loc.address1                                                                               ship_to_address1,

        decode(ship_loc.city, NULL, NULL, ship_loc.city || ', ')
        || decode(ship_loc.state, NULL, ship_loc.province || ', ', ship_loc.state || ', ')
        || decode(ship_loc.postal_code, NULL, NULL, ship_loc.postal_code || ', ')
        || decode(ship_loc.country, NULL, NULL, ship_loc.country)                                       ship_to_address5


,bill_su.location                                                                                invoice_to_location,
         decode(bill_loc.city, NULL, NULL, bill_loc.city || ', ')
        || decode(bill_loc.state, NULL, bill_loc.province || ', ', bill_loc.state || ', ')
        || decode(bill_loc.postal_code, NULL, NULL, bill_loc.postal_code || ', ')
        || decode(bill_loc.country, NULL, NULL, bill_loc.country)                                       invoice_to_address5
       , h.order_number,
               ot.name     order_type,
               h.ordered_date,
        pl.name                                                                                         price_list,
       h.salesrep_id,
        h.transactional_curr_code,
        h.flow_status_code,
         h.user_status_code
FROM
  hz_parties              party,
   hz_cust_accounts        cust_acct,
      oe_order_headers        h,
       hz_cust_site_uses_all   ship_su,
        hz_parties              sold_party,
        hz_locations            ship_loc,
        hz_cust_site_uses_all   bill_su,
        hz_locations            bill_loc,
        oe_transaction_types_tl ot, 
        qp_list_headers_tl      pl




        WHERE
     h.order_type_id = ot.transaction_type_id
      AND h.price_list_id = pl.list_header_id (+)
        AND h.sold_to_org_id = cust_acct.cust_account_id (+)
--        AND cust_acct.party_id = party.party_id (+)
--           AND h.ship_to_org_id = ship_su.site_use_id (+)
--      AND h.invoice_to_org_id = bill_su.site_use_id (+)
AND h.order_number=69390;		
SELECT
 party.party_name  SOLD_TO
 ,  cust_acct.account_number  CUSTOMER_NUMBER,
  h.cust_po_number,
  h.cust_po_number,
   sold_party.person_last_name
        || decode(sold_party.person_first_name, NULL, NULL, ', ' || sold_party.person_first_name)       sold_to_contact,
             ship_su.location                                                                                ship_to_location
,

        ship_loc.address1                                                                               ship_to_address1,

        decode(ship_loc.city, NULL, NULL, ship_loc.city || ', ')
        || decode(ship_loc.state, NULL, ship_loc.province || ', ', ship_loc.state || ', ')
        || decode(ship_loc.postal_code, NULL, NULL, ship_loc.postal_code || ', ')
        || decode(ship_loc.country, NULL, NULL, ship_loc.country)                                       ship_to_address5


,bill_su.location                                                                                invoice_to_location,
         decode(bill_loc.city, NULL, NULL, bill_loc.city || ', ')
        || decode(bill_loc.state, NULL, bill_loc.province || ', ', bill_loc.state || ', ')
        || decode(bill_loc.postal_code, NULL, NULL, bill_loc.postal_code || ', ')
        || decode(bill_loc.country, NULL, NULL, bill_loc.country)                                       invoice_to_address5
       , h.order_number,
               ot.name     order_type,
               h.ordered_date,
        pl.name                                                                                         price_list,
       h.salesrep_id,
        h.transactional_curr_code,
        h.flow_status_code,
         h.user_status_code
FROM
  hz_parties              party,
   hz_cust_accounts        cust_acct,
      oe_order_headers        h,
       hz_cust_site_uses_all   ship_su,
        hz_parties              sold_party,
        hz_locations            ship_loc,
        hz_cust_site_uses_all   bill_su,
        hz_locations            bill_loc,
        oe_transaction_types_tl ot, 
        qp_list_headers_tl      pl




        WHERE
     h.order_type_id = ot.transaction_type_id
      AND h.price_list_id = pl.list_header_id (+)
        AND h.sold_to_org_id = cust_acct.cust_account_id (+)
        AND cust_acct.party_id = party.party_id (+)
           AND h.ship_to_org_id = ship_su.site_use_id (+)
--      AND h.invoice_to_org_id = bill_su.site_use_id (+)
AND h.order_number=69390;		
SELECT
 party.party_name  SOLD_TO
 ,  cust_acct.account_number  CUSTOMER_NUMBER,
  h.cust_po_number,
  h.cust_po_number,
   sold_party.person_last_name
        || decode(sold_party.person_first_name, NULL, NULL, ', ' || sold_party.person_first_name)       sold_to_contact,
             ship_su.location                                                                                ship_to_location
,

        ship_loc.address1                                                                               ship_to_address1,

        decode(ship_loc.city, NULL, NULL, ship_loc.city || ', ')
        || decode(ship_loc.state, NULL, ship_loc.province || ', ', ship_loc.state || ', ')
        || decode(ship_loc.postal_code, NULL, NULL, ship_loc.postal_code || ', ')
        || decode(ship_loc.country, NULL, NULL, ship_loc.country)                                       ship_to_address5


,bill_su.location                                                                                invoice_to_location,
         decode(bill_loc.city, NULL, NULL, bill_loc.city || ', ')
        || decode(bill_loc.state, NULL, bill_loc.province || ', ', bill_loc.state || ', ')
        || decode(bill_loc.postal_code, NULL, NULL, bill_loc.postal_code || ', ')
        || decode(bill_loc.country, NULL, NULL, bill_loc.country)                                       invoice_to_address5
       , h.order_number,
               ot.name     order_type,
               h.ordered_date,
        pl.name                                                                                         price_list,
       h.salesrep_id,
        h.transactional_curr_code,
        h.flow_status_code,
         h.user_status_code
FROM
  hz_parties              party,
   hz_cust_accounts        cust_acct,
      oe_order_headers        h,
       hz_cust_site_uses_all   ship_su,
        hz_parties              sold_party,
        hz_locations            ship_loc,
        hz_cust_site_uses_all   bill_su,
        hz_locations            bill_loc,
oe_transaction_types_tl ot, 

        qp_list_headers_tl      pl		
SELECT
 party.party_name  SOLD_TO
 ,  cust_acct.account_number  CUSTOMER_NUMBER,
  h.cust_po_number,
  h.cust_po_number,
   sold_party.person_last_name
        || decode(sold_party.person_first_name, NULL, NULL, ', ' || sold_party.person_first_name)       sold_to_contact,
             ship_su.location                                                                                ship_to_location
,

        ship_loc.address1                                                                               ship_to_address1,

        decode(ship_loc.city, NULL, NULL, ship_loc.city || ', ')
        || decode(ship_loc.state, NULL, ship_loc.province || ', ', ship_loc.state || ', ')
        || decode(ship_loc.postal_code, NULL, NULL, ship_loc.postal_code || ', ')
        || decode(ship_loc.country, NULL, NULL, ship_loc.country)                                       ship_to_address5
FROM
  hz_parties              party,
   hz_cust_accounts        cust_acct,
      oe_order_headers        h,
       hz_cust_site_uses_all   ship_su,
        hz_parties              sold_party,
        hz_locations            ship_loc		
SELECT
 party.party_name  SOLD_TO
 ,  cust_acct.account_number  CUSTOMER_NUMBER,
  h.cust_po_number,
  h.cust_po_number,
   sold_party.person_last_name
        || decode(sold_party.person_first_name, NULL, NULL, ', ' || sold_party.person_first_name)       sold_to_contact,
             ship_su.location                                                                                ship_to_location
FROM
  hz_parties              party,
   hz_cust_accounts        cust_acct,
      oe_order_headers        h,
       hz_cust_site_uses_all   ship_su,
        hz_parties              sold_party;		
SELECT sold_to_contact_id FROM oe_order_headers;		
SELECT * FROM oe_order_headers		
    BEGIN
    MO_GLOBAL.SET_POLICY_CONTEXT('S','204');
    END;		
SELECT * FROM oe_order_headers WHERE ORG_ID=204;
SELECT * FROM oe_order_headers;		
SELECT * FROM hz_cust_accounts;	
SELECT * FROM hz_locations;		
select flow_status_code from oe_order_headers_all where order_number='69383';		1695621982892	SQL	1	0.036
select * from oe_order_headers_all where order_number='69383';		1695621918677	SQL	2	0.035
select * from oe_order_headers_all where order_number='69383' and flow_status_code ='Booked';		1695621905355	SQL	1	0.039
select flow_status_code from oe_order_headers_all where header_id=374793;		1695621548816	SQL	1	0.037
select flow_status_code from oe_order_lines_all where header_id=374793;		1695621534743	SQL	1	0.035
select * from oe_order_lines_all where header_id=374793;		1695621462392	SQL	1	0.105
select * from mtl_onhand_quantities_detail where inventory_item_id ='244205';		1695619832446	SQL	1	0.06
select * from mtl_onhand_quantities_detail		1695619816774	SQL	1	0.426
select * from mtl_system_items_b where segment1 like 'o2c%';		1695619452151	SQL	2	0.156
select * from mtl_system_items_b where segment1 like 'o2c%i%';		1695619270162	SQL	2	0.087
select * from mtl_system_items_b where segment1 like 'o2c iteme';		1695619222346	SQL	1	0.135
file:/C:/Users/GOD/pkb of ap.sql		1695618051234	Script	4	0.0
SELECT * FROM RCV_SHIPMENT_HEADERS ORDER BY SHIPMENT_HEADER_ID DESC;		1695581786627	SQL	7	0.711
select * from XXINTG_LEGACY_MAIN_STAGING_RP;		1695579937985	SQL	6	0.223
select * from ap_invoices_interface where po_number=7971;		1695577237063	SQL	1	0.441
SELECT * FROM AP_INVOICES;		1695577177666	SQL	3	1.088
select * from po_headers_interface order by INTERFACE_HEADER_ID desc;		1695576527905	SQL	6	0.355
SELECT * FROM XXINTG_LEGACY_MAIN_STAGING_RP;		1695576213884	SQL	16	0.214
SELECT * FROM RCV_SHIPMENT_HEADERS;		1695576101008	SQL	1	0.158
SELECT * FROM rcv_transactions_interface WHERE CREATED_BY =1014843;		1695536337360	SQL	1	0.309
SELECT * FROM rcv_transactions_interface;		1695536319254	SQL	1	0.452
UPDATE XXINTG_LEGACY_MAIN_STAGING_RP LG1
SET LG1.PO_NUM=(SELECT  SEGMENT1 FROM PO_HEADERS_ALL INT WHERE 
INT.PO_HEADER_ID =LG1.PO_HEADER_ID) WHERE REQUEST_ID=7747673;		1695535436556	SQL	1	0.215
SELECT * FROM PO_HEADERS_ALL WHERE CREATED_BY =1014843 ORDER BY LAST_UPDATE_DATE DESC;		1695535272519	SQL	8	0.385
update XXINTG_LEGACY_MAIN_STAGING_RP lg1
set lg1.po_line_id=(select DISTINCT int.PO_LINE_ID from PO_LINES_INTERFACE int
where int.INTERFACE_LINE_ID=lg1.PO_INTERFACE_LINE_ID)
where request_id=7747673;		1695535166039	SQL	1	0.319
SELECT * FROM PO_LINES_INTERFACE;		1695535112111	SQL	4	0.692
update XXINTG_LEGACY_MAIN_STAGING_RP lg1
set lg1.po_header_id=(select int.po_header_id from po_headers_interface int
where int.interface_header_id=lg1.PO_HEADER_INTERFACE_ID)
where request_id=7747673;		1695534421864	SQL	1	0.285
select * from user_SOURCE where NAME like UPPER('XXINTG_MASTER_TXXINTG_PO_REQ_HPABLE_DATA_HP%');		1695531800084	SQL	1	0.281
select * from user_objects where object_name like upper('xxintg%hp%');		1695531773240	SQL	3	0.204
select * from user_SOURCE where NAME like UPPER('XXINTG_MASTER_TABLE_DATA_HP%');		1695531551115	SQL	1	0.454
select * from user_SOURCE where NAME like UPPER('XXINTG_PO_MASTER_DATA_STG_HP%');		1695531532983	SQL	1	0.422
select * from user_SOURCE where NAME like UPPER('XXINTG_P2P_PROCESS_DS_PKG%');		1695531438590	SQL	2	0.179
select * from user_objects where object_name like upper('xxintg%ds%');		1695531364431	SQL	7	0.143
select * from user_SOURCE where NAME like UPPER('XXINTG_MULTI_LEGACY_PO_INV_AP_DS%');	Apps	1695531321409	SQL	2	0.368
select * from user_SOURCE where NAME like UPPER('XXINTG_DS_PO_TO_AP%');	Apps	1695531140457	SQL	2	0.222
select * from user_SOURCE where NAME like UPPER('XXINTG_DS_PO_TO_AP_INVOICE2%');	Apps	1695530858342	SQL	1	0.39
select * from user_objects where object_name like upper('xxxintg%ds%');	Apps	1695530816331	SQL	1	0.173
select * from user_objects where object_name like upper('xxxintg%po%ds%');	Apps	1695530768272	SQL	1	0.36
select * from user_SOURCE where NAME like UPPER('XXINTG_PO_DETAIL_DS%');	Apps	1695530691657	SQL	1	1.719
select * from user_SOURCE where NAME like UPPER('XXINTG%PO%ds');	Apps	1695530655218	SQL	1	0.466
select * from user_SOURCE where NAME like UPPER('XXINTG%PO%pkg%ds');	Apps	1695530649710	SQL	1	0.346
select * from user_SOURCE where NAME like UPPER('XXINTG%PO%INV%pkg%ds');	Apps	1695530643434	SQL	1	0.539
select * from user_SOURCE where NAME like UPPER('XXINTG%PO%TO%INV%pkg%ds');	Apps	1695530635143	SQL	1	0.691
select * from user_SOURCE where NAME like UPPER('XXINTG%PO%TO%INV%pkg');	Apps	1695530070070	SQL	1	1.24
select * from user_SOURCE;	Apps	1695530035884	SQL	1	1.948
select * from user_PROCEDURES where OBJECT_NAME like UPPER('XXINTG%PO%TO%INV%pkg');	Apps	1695529935561	SQL	1	0.975
select * from user_PROCEDURES where OBJECT_NAME like UPPER('XXINTG%PO%TO%INV%pkg') and oBject_type='PACKAGE BODY';	Apps	1695529929130	SQL	1	0.667
select * from user_PROCEDURES;	Apps	1695529921994	SQL	1	2.329
select * from user_objects where OBJECT_NAME like UPPER('XXINTG%PO%TO%INV%pkg') and oBject_type='PACKAGE BODY';	Apps	1695529837863	SQL	1	0.162
select * from user_objects where OBJECT_NAME like UPPER('XXINTG%PO%TO%INV%pkg') and oBject_type='PACKAGE';	Apps	1695529815689	SQL	1	0.598
select * from user_objects where OBJECT_NAME like 'XXINTG%PO%TO%INV%pkg' and oBject_type='PACKAGE';	Apps	1695529307644	SQL	1	0.151
select * from user_objects;	Apps	1695529195316	SQL	1	0.201
select * from user_objects where object_name like 'XXINTG%PO%TO%INV%pkg';	Apps	1695529185357	SQL	2	0.25
SELECT * FROM PO_HEADERS_ALL WHERE CREATED_BY =1014843;	Apps	1695491507420	SQL	1	0.449
declare
l_interface_error varchar2(200);
BEGIN
        SELECT
                substr(rtrim(xmlagg(xmlelement(e, pie.error_message || ',')).extract('//TEXT()'), ','),
                       1,
                       3950)
            INTO l_interface_error
            FROM
                po_interface_errors     pie,
                po.po_headers_interface phi

            WHERE
                    pie.interface_header_id = phi.interface_header_id
                AND phi.batch_id = 7747389;
dbms_output.put_line('l_interface_error IS'||l_interface_error);

exception when others then
dbms_output.put_line('error');
end;	Apps	1695491350768	SQL	1	0.168
declare
l_interface_error varchar2(200);
BEGIN

            SELECT
                 pie.error_message 
                 INTO l_interface_error
            FROM
                po_interface_errors     pie,
                po.po_headers_interface phi
            WHERE
                    pie.interface_header_id = phi.interface_header_id
                AND phi.batch_id = 7747389;
dbms_output.put_line('l_interface_error IS'||l_interface_error);

exception when others then
dbms_output.put_line('error');
end;	Apps	1695491181572	SQL	1	0.213
SELECT
                 pie.error_message 
--                 INTO l_interface_error
            FROM
                po_interface_errors     pie,
                po.po_headers_interface phi
            WHERE
                    pie.interface_header_id = phi.interface_header_id
                AND phi.batch_id = 7747438;		1695491114504	SQL	1	0.104