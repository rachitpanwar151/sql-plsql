select oeha.header_id
       ,oeha.org_id
       ,hou.name as operating_unit_name
       ,oeha.order_number
       ,oeha.ordered_date
       ,oeha.request_date
       ,oeha.salesrep_id
       ,rsrp.name as sales_person
       ,oeha.order_type_id
       ,ott.name as order_type
       ,oeha.price_list_id
       ,qplh.name as price_list_name
       ,oeha.invoice_to_org_id
       ,hzl1.address1||'-'||hzl1.city||'-'||hzl1.postal_code as invoice_to_org_name
       ,oeha.sold_from_org_id
       ,oeha.sold_to_org_id
       ,hzp.party_name as customer
       ,oeha.ship_from_org_id
       ,ood.organization_name as ship_from_org_name
       ,oeha.ship_to_org_id
       ,hzl.address1||'-'||hzl.city||'-'||hzl.postal_code as ship_to_location
       ,oeha.order_category_code
       ,oeha.flow_status_code as order_status
       ,oela.line_number
       ,oela.ordered_item
       ,oela.schedule_ship_date
       ,msi.primary_unit_of_measure as uom
       ,wdd.source_header_id
       ,wdd.subinventory
       ,wdd.released_status
       ,wdd.carrier_id
       ,wdd.unit_price
       ,wdd.currency_code
       ,wdd.transaction_id
       ,wda.delivery_assignment_id
       ,wda.delivery_id
       ,wnd.ultimate_dropoff_location_id
       ,wnd.customer_id
       ,wnd.confirmed_by
       ,wnd.weight_uom_code
       ,wnd.volume_uom_code
       ,wnd.delivery_type
       ,wnd.carrier_id
       from oe_order_headers_all oeha
            ,oe_order_lines_all oela
            ,mtl_system_items_b msi
            ,wsh_delivery_details wdd
            ,wsh_delivery_assignments wda
            ,wsh_new_deliveries wnd
            ,hr_operating_units hou
            ,hz_cust_accounts hzca
            ,hz_parties hzp
            ,org_organization_definitions ood
            ,hz_cust_site_uses_all hzcsu
            ,hz_cust_acct_sites_all hzcas
            ,hz_party_sites hzps
            ,hz_locations hzl
            ,hz_cust_site_uses_all hzcsu1
            ,hz_cust_acct_sites_all hzcas1
            ,hz_party_sites hzps1
            ,hz_locations hzl1
            ,oe_transaction_types_tl ott
            ,qp_list_headers_tl qplh
            ,ra_salesreps_all rsrp
            ,ra_customer_trx_all rctxa
            ,ra_customer_trx_lines_all rctxl
            where 
            oeha.header_id = oela.header_id
            and oela.order_quantity_uom = msi.primary_uom_code
            and msi.segment1 = oela.ordered_item
            and msi.organization_id = oeha.org_id
            and wdd.source_header_id = oeha.header_id
            and wda.delivery_detail_id = wdd.delivery_detail_id
            and wnd.delivery_id = wda.delivery_id
            and hou.organization_id = oeha.org_id 
            and hzca.cust_account_id = oeha.sold_to_org_id
            and hzp.party_id = hzca.party_id
            and ood.organization_id = oeha.ship_from_org_id
            and hzcsu.site_use_id = oeha.ship_to_org_id
            and hzcas.cust_acct_site_id = hzcsu.cust_acct_site_id
            and hzps.party_site_id = hzcas.party_site_id
            and hzps.location_id = hzl.location_id
            and hzcsu1.site_use_id = oeha.invoice_to_org_id
            and hzcas1.cust_acct_site_id = hzcsu1.cust_acct_site_id
            and hzps1.party_site_id = hzcas1.party_site_id
            and hzps1.location_id = hzl1.location_id
            and ott.transaction_type_id = oeha.order_type_id
            and qplh.list_header_id = oeha.price_list_id
            and rsrp.salesrep_id = oeha.salesrep_id
            and rctxl.interface_line_attribute1 = to_char(oeha.order_number)
            and rctxa.customer_trx_id = rctxl.customer_trx_id
            and oeha.order_number = 69369