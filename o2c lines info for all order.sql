select 
  l.line_id,
  l.ordered_item,
  l.ordered_quantity,
  l.order_quantity_uom,
  l.unit_selling_price,
    l.request_date,
    l.flow_status_code,
    lt.name                  line_type,
    l.cancelled_quantity,
    l.order_source_id,
    l.tax_code,
    l.user_item_description
      from
      oe_order_lines_all      l,
      oe_transaction_types_tl lt    
                where l.line_type_id = lt.transaction_type_id
                                                                               ;
            