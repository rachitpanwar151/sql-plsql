SELECT
    prh.requisition_header_id,
    prh.segment1,
    prh.authorization_status,
    prh.type_lookup_code,
    prl.item_description,
    pap.full_name,
    prl.unit_meas_lookup_code,
    prl.unit_price,
    prl.quantity,
    prl.org_id,
    prl.deliver_to_location_id,
    prl.SOURCE_TYPE_CODE,
    prl.DESTINATION_TYPE_CODE,
    prl.purchase_basis,
    prl.matching_basis,
    hla.location_code,
    hou.name,
    mtl.segment1||':'||mtl.segment2 as category,
    fnu.user_name,
    prh.creation_date,
    prh.last_update_date
   ,
   
   
    pha.po_header_id,
    pha.type_lookup_code,
    pha.segment1,
    pha.vendor_id,
    pha.vendor_site_id,
    pha.bill_to_location_id,
    pha.currency_code,
    pha.authorization_status,
    pha.org_id,
    pha.DOCUMENT_CREATION_METHOD,
    pha.APPROVED_FLAG,
    pha.APPROVED_DATE,
    pha.CREATED_LANGUAGE,
    pla.po_line_id,
    pla.item_id,
    pla.item_description,
    pla.unit_meas_lookup_code,
    pla.unit_price,
    pla.quantity,
    hou.name,
    aps.vendor_name,
    mtl.segment1||':'||mtl.segment2 as category,
    fnu.user_name,
    pha.creation_date,
    pha.last_update_date
    
    
    
    
    
    ,
    rsh.shipment_header_id,
    rsh.receipt_num,
    rsh.receipt_source_code,
    rsh.vendor_id,
    aps.vendor_name,
    rsh.organization_id,
    hou.name as organization_name,
    rsh.employee_id,
    rsl.quantity_shipped,
    rsl.quantity_received,
    rsl.unit_of_measure,
    rsl.item_description,
    rsl.shipment_line_status_code,
    rsl.source_document_code,
    rsl.destination_type_code,
    fnu.user_name,
    rsh.creation_date,
    rsh.last_update_date
   
    
    ,
PHA.CREATED_BY,
AIA.ORG_ID,
hou.name organisation_name, 
aia.invoice_type_lookup_code type
,PHA.SEGMENT1  PO_NUMBER     ,
    aps.vendor_name,
    ASSA.VENDOR_SITE_CODE
,aia.invoice_date,
    aia.invoice_num,
    aia.invoice_currency_code,
    aia.invoice_amount,
    aia.gl_date,
    aia.payment_cross_rate_date,
    aia.terms_date,
    aia.payment_method_lookup_code,
    aia.pay_group_lookup_code,
    aia.taxation_country
 
FROM
    po_requisition_headers_all   prh,
    po_requisition_lines_all     prl,
    po_req_distributions_all     prda,
    po_distributions_all         pda,
    po_line_locations_all        plla,
    po_lines_all                 pla,
    po_headers_all               pha,
    ap_suppliers                 aps,
    ap_supplier_sites_all        assa,
    rcv_shipment_headers         rsh,
    rcv_shipment_lines           rsl,
    ap_invoices_all              aia,
    ap_invoice_distributions_all aida,
    per_all_people_f             pap,
    hr_operating_units           hou,
    hr_locations_all             hla,
    fnd_user                     fnu,
    mtl_categories               mtl
WHERE   prh.requisition_header_id = prl.requisition_header_id
    AND prl.requisition_line_id = prda.requisition_line_id
    AND pda.req_distribution_id = prda.distribution_id
    AND plla.line_location_id = pda.line_location_id
    AND pla.po_line_id = plla.po_line_id
    AND pla.po_header_id = pha.po_header_id
    AND aps.vendor_id = pha.vendor_id
    AND assa.vendor_site_id = pha.vendor_site_id
    AND aps.vendor_id = assa.vendor_id
    AND rsh.shipment_header_id = rsl.shipment_header_id
    AND rsl.po_distribution_id = pda.po_distribution_id
    AND aida.po_distribution_id = pda.po_distribution_id
    AND aps.vendor_id = aia.vendor_id
    AND aida.invoice_id = aia.invoice_id
    AND prh.preparer_id = pap.person_id
    AND prh.org_id = hou.organization_id
    AND prl.deliver_to_location_id = hla.location_id
    AND prh.org_id = hou.organization_id
    AND prl.deliver_to_location_id = hla.location_id
    AND prh.created_by = fnu.user_id
    AND prl.category_id = mtl.category_id
    AND prh.segment1 = '16004';


