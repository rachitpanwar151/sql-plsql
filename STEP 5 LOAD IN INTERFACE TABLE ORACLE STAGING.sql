
/*************************************
proceDure of inserting into INTERFACE table
***************************************/
procedure load_in_interface(p_batch_id IN number)
AS
l_e varchar2(1000);
        ln_header_count NUMBER := 1;
        p_line_count    NUMBER := 1;
        ln_header_id    NUMBER;
        ln_line_id      NUMBER;
        ln_po_num       po_headers_all.segment1%TYPE;
        ln_hdr_id       po_headers_all.po_header_id%TYPE;
cursor cur_po_intf is select * from xxintg_po_staging_table_rp where status='V' and request_id=p_batch_id;
begin
for rec_po in cur_po_intf LOOP
begin
 --HEADER INSERT
                    FOR j IN 1..ln_header_count LOOP
                        ln_header_id := po_headers_interface_s.nextval;
                        INSERT INTO po_headers_interface (
                            interface_header_id,
                            batch_id,
                            process_code,
                            action,
                            org_id,
                            document_type_code,
                            comments,
                            currency_code,
                            agent_id,
                            vendor_id,
                            vendor_site_id,
                            ship_to_location_id,
                            bill_to_location_id,
                            attribute1,
                            creation_date
                        ) VALUES (
                            ln_header_id,
                            rec_po.request_id,
                            'PENDING',
                            'ORIGINAL',
                            rec_po.org_id,
                            'STANDARD',
                            'This is a Purchase Order - RPANWAR',
                            rec_po.currency_code,
                            rec_po.agent_id,
                            rec_po.vendor_id,
                            rec_po.vendor_site_id,
                            204,
                            204,
                            'LROBIN POXPOPDOI IMPORT',
                            rec_po.creation_date
                        ); 
--LINE INSERT		
                        FOR i IN 1..p_line_count LOOP
                            ln_line_id := po_lines_interface_s.nextval;
                            INSERT INTO po_lines_interface (
                                interface_line_id,
                                interface_header_id,
                                action,
                                line_num,
                                line_type,
                                item,
                                uom_code,
                                quantity,
                                unit_price,
                                ship_to_location_id,
                                need_by_date,
                                promised_date,
                                creation_date,
                                line_loc_populated_flag
                            ) VALUES (
                                ln_line_id,
                                ln_header_id,
                                'PENDING',
                                i,
                                rec_po.line_type,
                                rec_po.item_name,
                                rec_po.uom_code,
                                rec_po.quantity,
                                rec_po.unit_price,
                                204,
                                sysdate+10,
                                sysdate+8,
                                rec_po.creation_date,
                                'N'
                            );

                        END LOOP;

                    END LOOP;
 UPDATE xxintg_po_staging_table_rp
                        SET
                            status = 'S'
                            WHERE
                                request_id = rec_po.request_id
                            AND record_id = rec_po.record_id;
                    COMMIT;
                EXCEPTION
                    WHEN OTHERS THEN
                    l_e :=sqlcode||'-'||sqlerrm;
                        UPDATE xxintg_po_staging_table_rp
                        SET
                            status = 'E',
                            error_msg = 'ERROR WHILE INSERT DATA INTO INTERFACE TABLE.'||l_e
                        WHERE
                                request_id = rec_po.request_id
                            AND record_id = rec_po.record_id;

                        COMMIT;
                END;

end LOOP;
EXCEPTION
when others THEN
fnd_file.put_line(fnd_file.output,'ERROR IN INTERFACE INSERT : '||sqlcode||'-'||sqlerrm);
end load_in_interface;
