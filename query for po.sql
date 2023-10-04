select * from po_headers_all where SEGMENT1='7082';
select * from po_lines_all where po_header_id='308102';
select * from po_distributions_all where po_line_id=' ';
SELECT * FROM PO_HEADERS_V;
SELECT * FROM PO_VENDORS;
SELECT * FROM po_vendor_sites_all;
SELECT AGENT_ID FROM PO_AGENTS;
SELECT * FROM PER_ALL_PEOPLE_F;
SELECT * FROM po_lookup_codes;
select * from ap_supplier_sites_all;
select * from mtl_system_items;
select * from po_lines_all;
select * from mtl_system_items where inventory_item_id='87';

--------------------------------------------------------------------------------------------------------


SELECT
    pha.org_id,
    hou.name as organization_name,
    pha.approved_flag,
    pha.creation_date,
    pha.segment1 po_number,
    pha.type_lookup_code,
     pv.vendor_name,
    assa.vendor_site_code,
    pha.ship_to_location_id,
    pha.bill_to_location_id,
    pha.authorization_status,
    pla.unit_price,
    pha.comments
    ,pla.line_num
,msi.item_type    
, mt.segment1
    || ' '
    || mt.segment2        item_category,
    pla.item_description,
 pla.unit_meas_lookup_code,
    pla.quantity,
    pla.unit_price,
    pla.unit_price * pla.quantity,
    msi.last_update_date
FROM
   mtl_categories             mt,
      po_headers_all      pha,
    po_lines_all        pla,
    po_vendors          pv
   ,ap_supplier_sites_all assa
   ,po_agents           pa
   , mtl_system_items msi,
   hr_operating_units hou
   wHERE
        pha.po_header_id = pla.po_header_id
              AND pla.category_id = mt.category_id
            AND pla.item_id = msi.inventory_item_id
     AND pha.vendor_id = pv.vendor_id
    AND pha.vendor_site_id = assa.vendor_site_id
    AND pha.agent_id = pa.agent_id
    AND pha.segment1 = '7082'
    and pha.created_by='1014843'
        AND pha.ORG_ID = hou.organization_id;