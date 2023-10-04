select * from ap_lookup_codes;
select * from ap_invoices_all where invoice_id='145054';
select *from ap_suppliers;
select * from ap_invoice_lines_all;
select * from hr_operating_units;
select * from po_lookup_codes;
SELECT * FROM PO_HEADERS_ALL WHERE segment1 = '7082';
SELECT* FROM AP_SUPPLIERS;
SELECT * FROM PO_LOOKUP_CODES;
--------------------------------------------------------------------------------

select 
PHA.CREATED_BY,
AIA.ORG_ID,
hou.name organisation_name, 
aia.invoice_type_lookup_code type
,PHA.SEGMENT1  PO_NUMBER     ,
    aps.vendor_name,
    PV.SEGMENT1 SUPPLIER_NUM,
    ASSA.VENDOR_SITE_CODE
,aia.invoice_date,
    aia.invoice_num,
    aia.invoice_currency_code,
    aia.invoice_amount,
    aia.gl_date,
    aia.payment_cross_rate_date,
    aia.terms_date,
    apt.name         terms_name,
    aia.payment_method_lookup_code,
    aia.pay_group_lookup_code,
    aia.taxation_country
 
from 
ap_invoices_all aia,
hr_operating_units hou,
PO_HEADERS_ALL PHA,
AP_SUPPLIERS APS,
PO_VENDORS PV,
AP_SUPPLIER_SITES_ALL ASSA
,ap_terms APT,
ap_LOOKUP_CODES aLC
where
aia.org_id=hou.organization_id
AND PHA.PO_HEADER_ID=AIA.QUICK_PO_HEADER_ID
AND aia.vendor_id = aps.vendor_id
AND AIA.VENDOR_ID= PV.VENDOR_ID
AND AIA.VENDOR_ID=ASSA.VENDOR_ID
 AND aia.terms_id = apt.term_id
AND AIA.INVOICE_TYPE_LOOKUP_CODE=aLC.LOOKUP_CODE
and alc.lookup_type='INVOICE TYPE'
AND pha.segment1 = '7082'
and aia.vendor_site_id=assa.vendor_site_id;
  