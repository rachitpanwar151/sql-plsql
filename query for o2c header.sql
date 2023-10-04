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
    oe_order_headers_ALL        h,
    hz_cust_site_uses_all   ship_su,
    hz_parties              sold_party,
    hz_locations            ship_loc,
    hz_cust_site_uses_all   bill_su,
      hz_party_sites          bill_ps,
        hz_cust_acct_sites_all  bill_cas,
      
    hz_locations            bill_loc,
    oe_transaction_types_tl ot,
    qp_list_headers_tl      pl,
        hz_party_sites          ship_ps,
        hz_parties              ship_party,
        hz_relationships        ship_rel,
       hz_cust_accounts        ship_acct,
       
        hz_relationships        sold_rel,
        hz_cust_account_roles   ship_roles,
        
        hz_cust_acct_sites_all  ship_cas
WHERE
        h.order_type_id = ot.transaction_type_id
    AND h.price_list_id = pl.list_header_id 
    AND h.sold_to_org_id = cust_acct.cust_account_id
     AND ship_loc.location_id  = ship_ps.location_id
    AND cust_acct.party_id = party.party_id 
    AND h.ship_to_org_id = ship_su.site_use_id
    AND h.invoice_to_org_id = bill_su.site_use_id
    AND ship_su.cust_acct_site_id = ship_cas.cust_acct_site_id
      AND ship_cas.party_site_id = ship_ps.party_site_id 
        AND ship_loc.location_id  = ship_ps.location_id
          AND ship_roles.party_id = ship_rel.party_id 
        AND ship_roles.role_type  = 'CONTACT'
        AND ship_roles.cust_account_id = ship_acct.cust_account_id 
        AND nvl(ship_rel.object_id, - 1) = nvl(ship_acct.party_id, - 1)
        AND ship_rel.subject_id = ship_party.party_id
        AND sold_rel.subject_id = sold_party.party_id (+)
        AND bill_su.cust_acct_site_id = bill_cas.cust_acct_site_id 
        AND bill_cas.party_site_id = bill_ps.party_site_id 
        AND bill_loc.location_id  = bill_ps.location_id
    AND h.order_number = 69369
    AND  h.BOOKED_FLAG = 'Y' ;	