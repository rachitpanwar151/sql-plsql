set serveroutput on
DECLARE
 l_header_rec OE_ORDER_PUB.Header_Rec_Type;
 l_line_tbl OE_ORDER_PUB.Line_Tbl_Type;
 l_action_request_tbl OE_ORDER_PUB.Request_Tbl_Type;
 l_header_adj_tbl OE_ORDER_PUB.Header_Adj_Tbl_Type;
 l_line_adj_tbl OE_ORDER_PUB.line_adj_tbl_Type;
 l_header_scr_tbl OE_ORDER_PUB.Header_Scredit_Tbl_Type;
 l_line_scredit_tbl OE_ORDER_PUB.Line_Scredit_Tbl_Type;
 l_request_rec OE_ORDER_PUB.Request_Rec_Type ;
 l_return_status VARCHAR2(1000);
 l_msg_count NUMBER;
 l_msg_data VARCHAR2(1000);
 p_api_version_number NUMBER :=1.0;
 p_init_msg_list VARCHAR2(10) := FND_API.G_FALSE;
 p_return_values VARCHAR2(10) := FND_API.G_FALSE;
 p_action_commit VARCHAR2(10) := FND_API.G_FALSE;
 x_return_status VARCHAR2(1);
 x_msg_count NUMBER;
 x_msg_data VARCHAR2(100);
 p_header_rec OE_ORDER_PUB.Header_Rec_Type := OE_ORDER_PUB.G_MISS_HEADER_REC;
 p_old_header_rec OE_ORDER_PUB.Header_Rec_Type := OE_ORDER_PUB.G_MISS_HEADER_REC;
 p_header_val_rec OE_ORDER_PUB.Header_Val_Rec_Type := OE_ORDER_PUB.G_MISS_HEADER_VAL_REC;
 p_old_header_val_rec OE_ORDER_PUB.Header_Val_Rec_Type := OE_ORDER_PUB.G_MISS_HEADER_VAL_REC;
 p_Header_Adj_tbl OE_ORDER_PUB.Header_Adj_Tbl_Type := OE_ORDER_PUB.G_MISS_HEADER_ADJ_TBL;
 p_old_Header_Adj_tbl OE_ORDER_PUB.Header_Adj_Tbl_Type := OE_ORDER_PUB.G_MISS_HEADER_ADJ_TBL;
 p_Header_Adj_val_tbl OE_ORDER_PUB.Header_Adj_Val_Tbl_Type := OE_ORDER_PUB.G_MISS_HEADER_ADJ_VAL_TBL;
 p_old_Header_Adj_val_tbl OE_ORDER_PUB.Header_Adj_Val_Tbl_Type := OE_ORDER_PUB.G_MISS_HEADER_ADJ_VAL_TBL;
 p_Header_price_Att_tbl OE_ORDER_PUB.Header_Price_Att_Tbl_Type := OE_ORDER_PUB.G_MISS_HEADER_PRICE_ATT_TBL;
 p_old_Header_Price_Att_tbl OE_ORDER_PUB.Header_Price_Att_Tbl_Type := OE_ORDER_PUB.G_MISS_HEADER_PRICE_ATT_TBL;
 p_Header_Adj_Att_tbl OE_ORDER_PUB.Header_Adj_Att_Tbl_Type :=  OE_ORDER_PUB.G_MISS_HEADER_ADJ_ATT_TBL;
 p_old_Header_Adj_Att_tbl OE_ORDER_PUB.Header_Adj_Att_Tbl_Type := OE_ORDER_PUB.G_MISS_HEADER_ADJ_ATT_TBL;
 p_Header_Adj_Assoc_tbl OE_ORDER_PUB.Header_Adj_Assoc_Tbl_Type := OE_ORDER_PUB.G_MISS_HEADER_ADJ_ASSOC_TBL;
 p_old_Header_Adj_Assoc_tbl OE_ORDER_PUB.Header_Adj_Assoc_Tbl_Type := OE_ORDER_PUB.G_MISS_HEADER_ADJ_ASSOC_TBL;
 p_Header_Scredit_tbl OE_ORDER_PUB.Header_Scredit_Tbl_Type := OE_ORDER_PUB.G_MISS_HEADER_SCREDIT_TBL;
 p_old_Header_Scredit_tbl OE_ORDER_PUB.Header_Scredit_Tbl_Type := OE_ORDER_PUB.G_MISS_HEADER_SCREDIT_TBL;
 p_Header_Scredit_val_tbl OE_ORDER_PUB.Header_Scredit_Val_Tbl_Type := OE_ORDER_PUB.G_MISS_HEADER_SCREDIT_VAL_TBL;
 p_old_Header_Scredit_val_tbl OE_ORDER_PUB.Header_Scredit_Val_Tbl_Type := OE_ORDER_PUB.G_MISS_HEADER_SCREDIT_VAL_TBL;
 p_line_tbl OE_ORDER_PUB.Line_Tbl_Type := OE_ORDER_PUB.G_MISS_LINE_TBL;
 p_old_line_tbl OE_ORDER_PUB.Line_Tbl_Type := OE_ORDER_PUB.G_MISS_LINE_TBL;
 p_line_val_tbl OE_ORDER_PUB.Line_Val_Tbl_Type :=  OE_ORDER_PUB.G_MISS_LINE_VAL_TBL;
 p_old_line_val_tbl OE_ORDER_PUB.Line_Val_Tbl_Type := OE_ORDER_PUB.G_MISS_LINE_VAL_TBL;
 p_Line_Adj_tbl OE_ORDER_PUB.Line_Adj_Tbl_Type := OE_ORDER_PUB.G_MISS_LINE_ADJ_TBL;
 p_old_Line_Adj_tbl OE_ORDER_PUB.Line_Adj_Tbl_Type := OE_ORDER_PUB.G_MISS_LINE_ADJ_TBL;
 p_Line_Adj_val_tbl OE_ORDER_PUB.Line_Adj_Val_Tbl_Type := OE_ORDER_PUB.G_MISS_LINE_ADJ_VAL_TBL;
 p_old_Line_Adj_val_tbl OE_ORDER_PUB.Line_Adj_Val_Tbl_Type := OE_ORDER_PUB.G_MISS_LINE_ADJ_VAL_TBL;
 p_Line_price_Att_tbl OE_ORDER_PUB.Line_Price_Att_Tbl_Type := OE_ORDER_PUB.G_MISS_LINE_PRICE_ATT_TBL;
 p_old_Line_Price_Att_tbl OE_ORDER_PUB.Line_Price_Att_Tbl_Type := OE_ORDER_PUB.G_MISS_LINE_PRICE_ATT_TBL;
 p_Line_Adj_Att_tbl OE_ORDER_PUB.Line_Adj_Att_Tbl_Type := OE_ORDER_PUB.G_MISS_LINE_ADJ_ATT_TBL;
 p_old_Line_Adj_Att_tbl OE_ORDER_PUB.Line_Adj_Att_Tbl_Type := OE_ORDER_PUB.G_MISS_LINE_ADJ_ATT_TBL;
 p_Line_Adj_Assoc_tbl OE_ORDER_PUB.Line_Adj_Assoc_Tbl_Type := OE_ORDER_PUB.G_MISS_LINE_ADJ_ASSOC_TBL;
 p_old_Line_Adj_Assoc_tbl OE_ORDER_PUB.Line_Adj_Assoc_Tbl_Type := OE_ORDER_PUB.G_MISS_LINE_ADJ_ASSOC_TBL;
 p_Line_Scredit_tbl OE_ORDER_PUB.Line_Scredit_Tbl_Type := OE_ORDER_PUB.G_MISS_LINE_SCREDIT_TBL;
 p_old_Line_Scredit_tbl OE_ORDER_PUB.Line_Scredit_Tbl_Type := OE_ORDER_PUB.G_MISS_LINE_SCREDIT_TBL;
 p_Line_Scredit_val_tbl OE_ORDER_PUB.Line_Scredit_Val_Tbl_Type := OE_ORDER_PUB.G_MISS_LINE_SCREDIT_VAL_TBL;
 p_old_Line_Scredit_val_tbl OE_ORDER_PUB.Line_Scredit_Val_Tbl_Type := OE_ORDER_PUB.G_MISS_LINE_SCREDIT_VAL_TBL;
 p_Lot_Serial_tbl OE_ORDER_PUB.Lot_Serial_Tbl_Type := OE_ORDER_PUB.G_MISS_LOT_SERIAL_TBL;
 p_old_Lot_Serial_tbl OE_ORDER_PUB.Lot_Serial_Tbl_Type := OE_ORDER_PUB.G_MISS_LOT_SERIAL_TBL;
 p_Lot_Serial_val_tbl OE_ORDER_PUB.Lot_Serial_Val_Tbl_Type := OE_ORDER_PUB.G_MISS_LOT_SERIAL_VAL_TBL;
 p_old_Lot_Serial_val_tbl OE_ORDER_PUB.Lot_Serial_Val_Tbl_Type := OE_ORDER_PUB.G_MISS_LOT_SERIAL_VAL_TBL;
 p_action_request_tbl OE_ORDER_PUB.Request_Tbl_Type := OE_ORDER_PUB.G_MISS_REQUEST_TBL;

 x_header_rec OE_ORDER_PUB.Header_Rec_Type;
 x_action_request_tbl OE_ORDER_PUB.Request_Tbl_Type;
 x_header_val_rec OE_ORDER_PUB.Header_Val_Rec_Type;
 x_Header_Adj_tbl OE_ORDER_PUB.Header_Adj_Tbl_Type;
 x_Header_Adj_val_tbl OE_ORDER_PUB.Header_Adj_Val_Tbl_Type;
 x_Header_price_Att_tbl OE_ORDER_PUB.Header_Price_Att_Tbl_Type;
 x_Header_Adj_Att_tbl OE_ORDER_PUB.Header_Adj_Att_Tbl_Type;
 x_Header_Adj_Assoc_tbl OE_ORDER_PUB.Header_Adj_Assoc_Tbl_Type;
 x_Header_Scredit_tbl OE_ORDER_PUB.Header_Scredit_Tbl_Type;
 x_Header_Scredit_val_tbl OE_ORDER_PUB.Header_Scredit_Val_Tbl_Type;
 x_line_val_tbl OE_ORDER_PUB.Line_Val_Tbl_Type;
 x_Line_Adj_tbl OE_ORDER_PUB.Line_Adj_Tbl_Type;
 x_Line_Adj_val_tbl OE_ORDER_PUB.Line_Adj_Val_Tbl_Type;
 x_Line_price_Att_tbl OE_ORDER_PUB.Line_Price_Att_Tbl_Type;
 x_Line_Adj_Att_tbl OE_ORDER_PUB.Line_Adj_Att_Tbl_Type;
 x_Line_Adj_Assoc_tbl OE_ORDER_PUB.Line_Adj_Assoc_Tbl_Type;
 x_Line_Scredit_tbl OE_ORDER_PUB.Line_Scredit_Tbl_Type;
 x_line_tbl OE_ORDER_PUB.Line_Tbl_Type ;
 x_Line_Scredit_val_tbl OE_ORDER_PUB.Line_Scredit_Val_Tbl_Type;
 x_Lot_Serial_tbl OE_ORDER_PUB.Lot_Serial_Tbl_Type;
 x_Lot_Serial_val_tbl OE_ORDER_PUB.Lot_Serial_Val_Tbl_Type;
 x_action_request_tbl OE_ORDER_PUB.Request_Tbl_Type;
 X_DEBUG_FILE VARCHAR2(100);
 l_line_tbl_index NUMBER;
 l_msg_index_out NUMBER(10);
BEGIN
 dbms_output.enable(1000000);
 fnd_global.apps_initialize(1014843,21623,660); -- pass in user_id, responsibility_id, and application_id
 oe_msg_pub.initialize;
 oe_debug_pub.initialize;
 X_DEBUG_FILE := OE_DEBUG_PUB.Set_Debug_Mode('FILE');
 oe_debug_pub.SetDebugLevel(5); -- Use 5 for the most debuging output, I warn  you its a lot of data
 dbms_output.put_line('START OF NEW DEBUG');
--This is to UPDATE order line
 l_line_tbl_index :=1;
-- Changed attributes
 l_line_tbl(l_line_tbl_index) := OE_ORDER_PUB.G_MISS_LINE_REC;
 l_line_tbl(l_line_tbl_index).ordered_quantity := 2;
-- Primary key of the entity i.e. the order line
 l_line_tbl(l_line_tbl_index).line_id := 798278;
 l_line_tbl(l_line_tbl_index).change_reason := 'Not provided';
-- Indicates to process order that this is an update operation
 l_line_tbl(l_line_tbl_index).operation := OE_GLOBALS.G_OPR_UPDATE;
-- CALL TO PROCESS ORDER
 OE_ORDER_PUB.process_order (
  p_api_version_number => 1.0
  , p_init_msg_list => fnd_api.g_false
  , p_return_values => fnd_api.g_false
  , p_action_commit => fnd_api.g_false
  , x_return_status => l_return_status
  , x_msg_count => l_msg_count
  , x_msg_data => l_msg_data
  , p_header_rec => l_header_rec
  , p_line_tbl => l_line_tbl
  , p_action_request_tbl => l_action_request_tbl
-- OUT PARAMETERS
  , x_header_rec => x_header_rec
  , x_header_val_rec => x_header_val_rec
  , x_Header_Adj_tbl => x_Header_Adj_tbl
  , x_Header_Adj_val_tbl => x_Header_Adj_val_tbl
  , x_Header_price_Att_tbl => x_Header_price_Att_tbl
  , x_Header_Adj_Att_tbl => x_Header_Adj_Att_tbl
  , x_Header_Adj_Assoc_tbl => x_Header_Adj_Assoc_tbl
  , x_Header_Scredit_tbl => x_Header_Scredit_tbl
  , x_Header_Scredit_val_tbl => x_Header_Scredit_val_tbl
  , x_line_tbl => x_line_tbl
  , x_line_val_tbl => x_line_val_tbl
  , x_Line_Adj_tbl => x_Line_Adj_tbl
  , x_Line_Adj_val_tbl => x_Line_Adj_val_tbl
  , x_Line_price_Att_tbl => x_Line_price_Att_tbl
  , x_Line_Adj_Att_tbl => x_Line_Adj_Att_tbl
  , x_Line_Adj_Assoc_tbl => x_Line_Adj_Assoc_tbl
  , x_Line_Scredit_tbl => x_Line_Scredit_tbl
  , x_Line_Scredit_val_tbl => x_Line_Scredit_val_tbl
  , x_Lot_Serial_tbl => x_Lot_Serial_tbl
  , x_Lot_Serial_val_tbl => x_Lot_Serial_val_tbl
  , x_action_request_tbl => p_action_request_tbl
 );

  dbms_output.put_line('OM Debug file: ' ||oe_debug_pub.G_DIR||'/'||oe_debug_pub.G_FILE);

-- Retrieve messages
  FOR i IN 1 .. l_msg_count
  LOOP
   Oe_Msg_Pub.get( p_msg_index => i
   , p_encoded => Fnd_Api.G_FALSE
   , p_data => l_msg_data
   , p_msg_index_out => l_msg_index_out);
   DBMS_OUTPUT.PUT_LINE('message is: ' || l_msg_data);
   DBMS_OUTPUT.PUT_LINE('message index is: ' || l_msg_index_out);
  END LOOP;
-- Check the return status
  IF l_return_status = FND_API.G_RET_STS_SUCCESS
  THEN
   dbms_output.put_line('Line Quantity Update Sucessful');
  ELSE
   dbms_output.put_line('Line Quantity update Failed');
  END IF;
 END;
/
Commit;


select * from oe_order_lines_all where header_id=493799;