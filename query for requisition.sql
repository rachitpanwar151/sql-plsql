SELECT
    *
FROM
    po_requisition_headers_all
WHERE
    segment1 = '15986';

SELECT
    *
FROM
    po_requisition_lines_all
WHERE
    deliver_to_location_id = '204';

SELECT
    *
FROM
    po_req_distributions_all
WHERE
    requisition_line_id = '594252';

SELECT  * FROM    per_all_people_f
WHER person_id = '25';



SELECT * FROM PO_AGENTS;


SELECT
    *
FROM
    mtl_system_items
WHERE
    inventory_item_id = '154728';

SELECT
    *
FROM
    mtl_categories;

SELECT * FROM HR_OPERATING_UNITS WHERE NAME='Vision Operations';

SELECT * FROM HR_LOCATIONS_ALL WHERE LOCATION_CODE='V1- New York City';

SELECT * FROM PO_LOOKUP_CODES;


SELECT
    prha.org_id,
    hou.name as organization_name,
    prha.segment1,
    prha.description,
    prha.type_lookup_code document_type_display,
    prha.authorization_status,
    papf.full_name        preparer,
    prla.line_num,
    msi.item_type,
    mc.segment1
    || ' '
    || mc.segment2        item_category,
    prla.item_description,
    prla.unit_meas_lookup_code,
    prla.quantity,
    prla.unit_price,
    prla.need_by_date,
    prla.destination_type_code,
    papf.full_name        requestor,
    hou.name              organisation_name,
    hla.location_code,
    prla.source_type_code
FROM
    po_requisition_headers_all prha,
    po_requisition_lines_all   prla,
    po_req_distributions_all   prda,
    per_all_people_f           papf,
    mtl_system_items           msi,
    mtl_categories             mc,
    hr_operating_units         hou,
    hr_locations_all           hla
WHERE
PRHA.REQUISITION_HEADER_ID=PRLA.REQUISITION_HEADER_ID 
AND prla.REQUISITION_LINE_ID = prda.REQUISITION_LINE_ID
    AND prha.preparer_id = papf.person_id
        AND prla.item_id = msi.inventory_item_id
         AND prla.category_id = mc.category_id
              AND prla.org_id = hou.organization_id
              AND prla.deliver_to_location_id = hla.location_id
                        AND prha.segment1 = '15986'
                        and prha.CREATED_BY='1014843'
                        ;
                        
                        
                        
                        
                        SELECT * FROM MTL_SYSTEM_ITEMS_B;