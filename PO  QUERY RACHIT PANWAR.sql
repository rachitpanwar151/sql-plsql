SELECT
    ph.po_header_id,
    ph.type_lookup_code,
    ph.segment1,
    ph.vendor_id,
    ph.vendor_site_id,
    ph.bill_to_location_id,
    ph.currency_code,
    ph.authorization_status,
    ph.org_id,
    ph.DOCUMENT_CREATION_METHOD,
    ph.APPROVED_FLAG,
    ph.APPROVED_DATE,
    ph.CREATED_LANGUAGE,
    pl.po_line_id,
    pl.item_id,
    pl.item_description,
    pl.unit_meas_lookup_code,
    pl.unit_price,
    pl.quantity,
    hou.name,
    aps.vendor_name,
    apss.vendor_Site_code,
    mtl.segment1||':'||mtl.segment2 as category,
    fnu.user_name,
    ph.creation_date,
    ph.last_update_date
FROM
    po_headers_all       ph,
    po_lines_all         pl,
    po_distributions_all pd,
    hr_operating_units   hou,
    fnd_user fnu,
    ap_suppliers aps,
    ap_supplier_sites_all apss,
    mtl_categories mtl
WHERE
        ph.segment1 = '7082'
    AND ph.po_header_id = pl.po_header_id
    AND pl.po_line_id = pd.po_line_id
    AND ph.org_id = hou.organization_id
    AND ph.created_by=fnu.user_id
    AND ph.vendor_id=aps.vendor_id
    AND ph.vendor_site_id=apss.vendor_site_id
    AND pl.category_id=mtl.category_id;