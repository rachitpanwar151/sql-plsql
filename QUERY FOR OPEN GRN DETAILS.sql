SELECT
    rsh.receipt_num                                  grn_no,
    rsh.creation_date                                receipt_date,
    rsh.shipment_header_id,
    rsl.shipment_line_status_code,
    pha.segment1                                     po_number,
    pha.po_header_id                                po_header_id,
    pha.creation_date                                po_date,
    (rsl.quantity_received - rsl.quantity_shipped ) pending_qty,
    rsl.quantity_received                            receipt_quantity,
    rsl.amount                                       receipt_value
FROM
    rcv_shipment_headers rsh,
    rcv_shipment_lines   rsl,
    po_headers_all       pha
WHERE
        RSH.shipment_header_id = RSL.shipment_header_id
    AND RSL.source_document_code = 'PO'
    AND pha.type_lookup_code NOT IN ( 'RFQ', 'QUOTATION' )
    AND pha.po_header_id = RSL.po_header_id
    AND pha.org_id = 204
    AND RSL.to_organization_id = 204
    AND RSL.shipment_line_status_code NOT IN ( 'FULLY RECEIVED', 'CANCELLED' );