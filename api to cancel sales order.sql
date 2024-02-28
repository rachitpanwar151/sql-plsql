
DECLARE
v_api_version_number           NUMBER  := 1;
v_return_status                VARCHAR2 (2000);
v_msg_count                    NUMBER;
v_msg_data                     VARCHAR2 (2000);

-- IN Variables --
v_header_rec                   oe_order_pub.header_rec_type;
v_line_tbl                     oe_order_pub.line_tbl_type;
v_action_request_tbl           oe_order_pub.request_tbl_type;
v_line_adj_tbl                 oe_order_pub.line_adj_tbl_type;

-- OUT Variables --
v_header_rec_out               oe_order_pub.header_rec_type;
v_header_val_rec_out           oe_order_pub.header_val_rec_type;
v_header_adj_tbl_out           oe_order_pub.header_adj_tbl_type;
v_header_adj_val_tbl_out       oe_order_pub.header_adj_val_tbl_type;
v_header_price_att_tbl_out     oe_order_pub.header_price_att_tbl_type;
v_header_adj_att_tbl_out       oe_order_pub.header_adj_att_tbl_type;
v_header_adj_assoc_tbl_out     oe_order_pub.header_adj_assoc_tbl_type;
v_header_scredit_tbl_out       oe_order_pub.header_scredit_tbl_type;
v_header_scredit_val_tbl_out   oe_order_pub.header_scredit_val_tbl_type;
v_line_tbl_out                 oe_order_pub.line_tbl_type;
v_line_val_tbl_out             oe_order_pub.line_val_tbl_type;
v_line_adj_tbl_out             oe_order_pub.line_adj_tbl_type;
v_line_adj_val_tbl_out         oe_order_pub.line_adj_val_tbl_type;
v_line_price_att_tbl_out       oe_order_pub.line_price_att_tbl_type;
v_line_adj_att_tbl_out         oe_order_pub.line_adj_att_tbl_type;
v_line_adj_assoc_tbl_out       oe_order_pub.line_adj_assoc_tbl_type;
v_line_scredit_tbl_out         oe_order_pub.line_scredit_tbl_type;
v_line_scredit_val_tbl_out     oe_order_pub.line_scredit_val_tbl_type;
v_lot_serial_tbl_out           oe_order_pub.lot_serial_tbl_type;
v_lot_serial_val_tbl_out       oe_order_pub.lot_serial_val_tbl_type;
v_action_request_tbl_out       oe_order_pub.request_tbl_type;

v_msg_index                    NUMBER;
v_data                         VARCHAR2 (2000);
v_loop_count                   NUMBER;
v_debug_file                   VARCHAR2 (200);
b_return_status                VARCHAR2 (200);
b_msg_count                    NUMBER;
b_msg_data                     VARCHAR2 (2000);
BEGIN

DBMS_OUTPUT.PUT_LINE('Starting of script');

-- Setting the Enviroment --

mo_global.init('ONT');
fnd_global.apps_initialize ( user_id      => 1014843
                            ,resp_id      => 21623
                            ,resp_appl_id => 660);
mo_global.set_policy_context('S',204);

-- CANCEL HEADER --


v_header_rec                        := oe_order_pub.g_miss_header_rec;
v_header_rec.operation              := OE_GLOBALS.G_OPR_UPDATE;
v_header_rec.header_id              := 478779;
v_header_rec.cancelled_flag         := 'Y';
v_header_rec.change_reason          := 'Not provided';

DBMS_OUTPUT.PUT_LINE('Starting of API');

-- CALLING THE API TO CANCEL AN ORDER --

OE_ORDER_PUB.PROCESS_ORDER (
p_api_version_number            => v_api_version_number
, p_header_rec                  => v_header_rec
, p_line_tbl                    => v_line_tbl
, p_action_request_tbl          => v_action_request_tbl
, p_line_adj_tbl                => v_line_adj_tbl
-- OUT variables
, x_header_rec                  => v_header_rec_out
, x_header_val_rec              => v_header_val_rec_out
, x_header_adj_tbl              => v_header_adj_tbl_out
, x_header_adj_val_tbl          => v_header_adj_val_tbl_out
, x_header_price_att_tbl        => v_header_price_att_tbl_out
, x_header_adj_att_tbl          => v_header_adj_att_tbl_out
, x_header_adj_assoc_tbl        => v_header_adj_assoc_tbl_out
, x_header_scredit_tbl          => v_header_scredit_tbl_out
, x_header_scredit_val_tbl      => v_header_scredit_val_tbl_out
, x_line_tbl                    => v_line_tbl_out
, x_line_val_tbl                => v_line_val_tbl_out
, x_line_adj_tbl                => v_line_adj_tbl_out
, x_line_adj_val_tbl            => v_line_adj_val_tbl_out
, x_line_price_att_tbl          => v_line_price_att_tbl_out
, x_line_adj_att_tbl            => v_line_adj_att_tbl_out
, x_line_adj_assoc_tbl          => v_line_adj_assoc_tbl_out
, x_line_scredit_tbl            => v_line_scredit_tbl_out
, x_line_scredit_val_tbl        => v_line_scredit_val_tbl_out
, x_lot_serial_tbl              => v_lot_serial_tbl_out
, x_lot_serial_val_tbl          => v_lot_serial_val_tbl_out
, x_action_request_tbl          => v_action_request_tbl_out
, x_return_status               => v_return_status
, x_msg_count                   => v_msg_count
, x_msg_data                    => v_msg_data
);

DBMS_OUTPUT.PUT_LINE('Completion of API');


IF v_return_status = fnd_api.g_ret_sts_success THEN
    COMMIT;
    DBMS_OUTPUT.put_line ('Order Cancellation Success : '||v_header_rec_out.header_id);
ELSE
    DBMS_OUTPUT.put_line ('Order Cancellation failed:'||v_msg_data);
    ROLLBACK;
    FOR i IN 1 .. v_msg_count
    LOOP
      v_msg_data := oe_msg_pub.get( p_msg_index => i, p_encoded => 'F');
      dbms_output.put_line( i|| ') '|| v_msg_data);
    END LOOP;
END IF;
END;
