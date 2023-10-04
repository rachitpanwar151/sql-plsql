select * from  rcv_shipment_headers; 

select * from rcv_shipment_lines; 
select * from fnd_user ;
select * from  ap_suppliers aps;
select * from hr_operating_units  ;




----------------------------------------------------------
SELECT
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
FROM
    rcv_shipment_headers rsh,
    rcv_shipment_lines   rsl,
    fnd_user             fnu,
    ap_suppliers aps,
    hr_operating_units   hou
WHERE
        rsh.receipt_num = '9151'
       AND rsh.shipment_header_id = rsl.shipment_header_id
    AND rsh.created_by = fnu.user_id
    AND rsh.vendor_id=aps.vendor_id
    AND rsh.SHIP_TO_ORG_ID = hou.organization_id;