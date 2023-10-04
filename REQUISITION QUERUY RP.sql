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
    hl.location_code,
    hou.name,
    mtl.segment1||':'||mtl.segment2 as category,
    fnu.user_name,
    prh.creation_date,
    prh.last_update_date
   
FROM
    po_requisition_headers_all prh,
    po_requisition_lines_all   prl,
    po_req_distributions_all   prd,
    hr_operating_units         hou,
    hr_locations_all           hl,
    fnd_user fnu,
    mtl_categories mtl,
    per_all_people_f pap
WHERE
        prh.requisition_header_id = prl.requisition_header_id
    AND prl.requisition_line_id = prd.requisition_line_id
    AND prh.org_id = hou.organization_id
    AND prl.deliver_to_location_id = hl.location_id
    AND prh.created_by=fnu.user_id
    AND prl.category_id=mtl.category_id
    AND prh.segment1 = '15986'
    AND prh.PREPARER_ID=pap.person_id;