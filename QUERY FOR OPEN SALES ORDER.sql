  SELECT
  organization_code "Inventory Org",
  ooha.order_number,
  OOHA.HEADER_ID,
  OOLA.LINE_ID,
         ott.name order_type,
         ooha.cust_po_number,
         ooha.fob_point_code     fob,
         ooha.flow_status_code   "Order Status",
         ooha.ordered_date,
         ooha.booked_date,
         ooha.org_id,
         hcasa.cust_acct_site_id,
         hp.party_name           "Customer Name",
         hps.party_site_number   "Ship to site number",
         hl.city                 "Customer City",
         hl.state                "Customer State",
         hl.country              "Customer Country",
         ft.nls_territory        "Region",
         hpb.party_name          "Bill Customer Name",
         hpsb.party_site_number  "Bill to site number",
         hlb.city                "Bill Customer City",
         hlb.state               "Bill Customer State",
         hlb.country             "Bill Customer Country",
         ftb.nls_territory       "Bill Region",
         organization_code       "Inventory Org",
         oola.line_number,
         oola.actual_shipment_date "Actual Ship Date",
         oola.ordered_item       "Item#/Part#",
         oola.flow_status_code   "Line Status",
         msib.description        "Item Description",
         oola.source_type_code   "Source Type",
         oola.schedule_ship_date,
         oola.pricing_quantity   "Quantity",
         oola.pricing_quantity_uom "UOM"
    FROM apps.oe_order_headers_all       ooha,
         apps.oe_order_lines_all         oola,
         apps.mtl_system_items_b         msib,
         -----
         apps.org_organization_definitions ood,
         apps.hz_cust_site_uses_all      hcsua,
         apps.hz_cust_acct_sites_all     hcasa,
         apps.hz_party_sites             hps,
         apps.hz_locations               hl,
         apps.hz_parties                 hp,
         apps.fnd_territories            ft,
         ------
         apps.hz_cust_site_uses_all      hcsuab,
         apps.hz_cust_acct_sites_all     hcasab,
         apps.hz_party_sites             hpsb,
         apps.hz_locations               hlb,
         apps.hz_parties                 hpb,
         apps.fnd_territories            ftb,
         apps.oe_transaction_types_tl    ott
   WHERE     1 = 1
         AND ooha.header_id = oola.header_id
         AND ooha.org_id = oola.org_id
         AND oola.ordered_item = msib.segment1
         AND ooha.ship_from_org_id = msib.organization_id
         --
         AND ooha.ship_from_org_id = ood.organization_id(+)
         AND ooha.ship_to_org_id = hcsua.site_use_id(+)
         AND hcsua.cust_acct_site_id = hcasa.cust_acct_site_id(+)
         AND hcasa.party_site_id = hps.party_site_id(+)
         AND hps.location_id = hl.location_id(+)
         AND hps.party_id = hp.party_id(+)
         AND hl.country = ft.territory_code(+)
         --
         and oola.open_flag = 'Y' --condition to find the open sales order----

         AND ooha.invoice_to_org_id = hcsuab.site_use_id
         AND hcsuab.cust_acct_site_id = hcasab.cust_acct_site_id
         AND hcasab.party_site_id = hpsb.party_site_id
         AND hpsb.location_id = hlb.location_id
         AND hpsb.party_id = hpb.party_id
         AND hlb.country = ftb.territory_code
         --
         AND ott.language = 'US'
         AND ott.transaction_type_id = ooha.order_type_id
--         AND ooha.order_number = '69443'
ORDER BY ooha.order_number, oola.line_number;