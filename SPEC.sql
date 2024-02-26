CREATE OR REPLACE PACKAGE XXAWR_SALES_ORDER_PACKAGE_INTG AS
   /*******************************************************************************************************************
    * $Header         : @(#)
    * Program Name    : XXAWR_SALES_ORDER_PACKAGE.pks
    * Language        : PL/SQL
    * Description     : PACKAGE BODY FOR AWR SALES ORDER 
    * 
    * History         :
    *
    * WHO                       WHAT                                                     WHEN
    * --------------   -------------------------------------------------           --------------
    *                   1.0 - AWR SO SPEC                                             08-JAN-2024
    *******************************************************************************************************************/

   /*******************************************************************************************************************
    * Variable       : Declaration and Initialization
    * Description    : Variables Declaration and Initialization
    * History        :
    * WHO              WHAT                                                                 WHEN
    * --------------   -------------------------------------------------                --------------
    *                    1.0 - AWR SO VARIABLE DECLERATION                                    08-JAN-2024
    *******************************************************************************************************************/

   /*******************************************************************************************************************
    * Global Variables : Declaration and Initialization
    *******************************************************************************************************************/
    
/********** DECLARING INITIALIZING GLOBAL VARIABLES ******************/
    gn_count NUMBER;
    gn_org_id NUMBER := 204;
    gn_resp_id fnd_responsibility_tl.responsibility_id%TYPE := fnd_profile.value('RESP_ID');
    gn_resp_appl_id fnd_responsibility_tl.application_id%TYPE := fnd_profile.value('RESP_APPL_ID');
    gn_request_id fnd_concurrent_requests.request_id%TYPE := fnd_profile.value('CONC_REQUEST_ID');
    gn_limit NUMBER := 100;
    gc_instance VARCHAR2(50);
    gn_group_id NUMBER := rcv_interface_groups_s.nextval;
    gn_max_wait VARCHAR2(200);
    gn_interval VARCHAR2(300);
    gc_error_flag BOOLEAN;
    gn_cp_request_id VARCHAR2(200);
    gc_status VARCHAR2(200);
    gc_data_validation VARCHAR2(300);
    gc_error_msg VARCHAR2(2000);
    gc_conc_status NUMBER;
    gc_phase VARCHAR2(200);
    gn_chk NUMBER; -- For validating count of a particular value
    gc_chk VARCHAR2(2); --For validating check
    gn_user_id fnd_user.user_id%TYPE := fnd_profile.value('USER_ID');  -- Geeting user Id
    g_interval NUMBER;
    g_max_weight NUMBER;
    g_phase VARCHAR2(100);
    g_status VARCHAR2(100);
    g_conc_status BOOLEAN;
    gc_dev_phase VARCHAR2(100);
    gc_dev_status VARCHAR2(100);
    gc_message VARCHAR2(1000);

  /************************************************
    * Varaibles
  ************************************************/

    l_return_status VARCHAR2(1000);
    l_msg_count NUMBER;
    l_msg_data VARCHAR2(1000);
    p_api_version_number NUMBER := 1.0;
    p_init_msg_list VARCHAR2(10) := fnd_api.g_false;
    p_return_values VARCHAR2(10) := fnd_api.g_false;
    p_action_commit VARCHAR2(10) := fnd_api.g_false;
    x_return_status VARCHAR2(1);
    x_msg_count NUMBER;
    x_msg_data VARCHAR2(100);
    l_header_rec oe_order_pub.header_rec_type;
    l_line_tbl oe_order_pub.line_tbl_type;
    l_action_request_tbl oe_order_pub.request_tbl_type;
    l_header_adj_tbl oe_order_pub.header_adj_tbl_type;
    l_line_adj_tbl oe_order_pub.line_adj_tbl_type;
    l_header_scr_tbl oe_order_pub.header_scredit_tbl_type;
    l_line_scredit_tbl oe_order_pub.line_scredit_tbl_type;
    l_request_rec oe_order_pub.request_rec_type;
    x_header_rec oe_order_pub.header_rec_type := oe_order_pub.g_miss_header_rec;
    p_old_header_rec oe_order_pub.header_rec_type := oe_order_pub.g_miss_header_rec;
    p_header_val_rec oe_order_pub.header_val_rec_type := oe_order_pub.g_miss_header_val_rec;
    p_old_header_val_rec oe_order_pub.header_val_rec_type := oe_order_pub.g_miss_header_val_rec;
    p_header_adj_tbl oe_order_pub.header_adj_tbl_type := oe_order_pub.g_miss_header_adj_tbl;
    p_old_header_adj_tbl oe_order_pub.header_adj_tbl_type := oe_order_pub.g_miss_header_adj_tbl;
    p_header_adj_val_tbl oe_order_pub.header_adj_val_tbl_type := oe_order_pub.g_miss_header_adj_val_tbl;
    p_old_header_adj_val_tbl oe_order_pub.header_adj_val_tbl_type := oe_order_pub.g_miss_header_adj_val_tbl;
    p_header_price_att_tbl oe_order_pub.header_price_att_tbl_type := oe_order_pub.g_miss_header_price_att_tbl;
    p_old_header_price_att_tbl oe_order_pub.header_price_att_tbl_type := oe_order_pub.g_miss_header_price_att_tbl;
    p_header_adj_att_tbl oe_order_pub.header_adj_att_tbl_type := oe_order_pub.g_miss_header_adj_att_tbl;
    p_old_header_adj_att_tbl oe_order_pub.header_adj_att_tbl_type := oe_order_pub.g_miss_header_adj_att_tbl;
    p_header_adj_assoc_tbl oe_order_pub.header_adj_assoc_tbl_type := oe_order_pub.g_miss_header_adj_assoc_tbl;
    p_old_header_adj_assoc_tbl oe_order_pub.header_adj_assoc_tbl_type := oe_order_pub.g_miss_header_adj_assoc_tbl;
    p_header_scredit_tbl oe_order_pub.header_scredit_tbl_type := oe_order_pub.g_miss_header_scredit_tbl;
    p_old_header_scredit_tbl oe_order_pub.header_scredit_tbl_type := oe_order_pub.g_miss_header_scredit_tbl;
    p_header_scredit_val_tbl oe_order_pub.header_scredit_val_tbl_type := oe_order_pub.g_miss_header_scredit_val_tbl;
    p_old_header_scredit_val_tbl oe_order_pub.header_scredit_val_tbl_type := oe_order_pub.g_miss_header_scredit_val_tbl;
    x_line_val_tbl oe_order_pub.line_val_tbl_type;
    x_line_adj_tbl oe_order_pub.line_adj_tbl_type;
    x_line_adj_val_tbl oe_order_pub.line_adj_val_tbl_type;
    x_line_price_att_tbl oe_order_pub.line_price_att_tbl_type;
    x_line_adj_att_tbl oe_order_pub.line_adj_att_tbl_type;
    x_line_adj_assoc_tbl oe_order_pub.line_adj_assoc_tbl_type;
    x_line_scredit_tbl oe_order_pub.line_scredit_tbl_type;
    x_line_scredit_val_tbl oe_order_pub.line_scredit_val_tbl_type;
    x_lot_serial_tbl oe_order_pub.lot_serial_tbl_type;
    x_lot_serial_val_tbl oe_order_pub.lot_serial_val_tbl_type;
    x_action_request_tbl oe_order_pub.request_tbl_type;
    p_line_tbl oe_order_pub.line_tbl_type := oe_order_pub.g_miss_line_tbl;
    p_old_line_tbl oe_order_pub.line_tbl_type := oe_order_pub.g_miss_line_tbl;
    p_line_val_tbl oe_order_pub.line_val_tbl_type := oe_order_pub.g_miss_line_val_tbl;
    p_old_line_val_tbl oe_order_pub.line_val_tbl_type := oe_order_pub.g_miss_line_val_tbl;
    p_line_adj_tbl oe_order_pub.line_adj_tbl_type := oe_order_pub.g_miss_line_adj_tbl;
    p_old_line_adj_tbl oe_order_pub.line_adj_tbl_type := oe_order_pub.g_miss_line_adj_tbl;
    p_line_adj_val_tbl oe_order_pub.line_adj_val_tbl_type := oe_order_pub.g_miss_line_adj_val_tbl;
    p_old_line_adj_val_tbl oe_order_pub.line_adj_val_tbl_type := oe_order_pub.g_miss_line_adj_val_tbl;
    p_line_price_att_tbl oe_order_pub.line_price_att_tbl_type := oe_order_pub.g_miss_line_price_att_tbl;
    p_old_line_price_att_tbl oe_order_pub.line_price_att_tbl_type := oe_order_pub.g_miss_line_price_att_tbl;
    p_line_adj_att_tbl oe_order_pub.line_adj_att_tbl_type := oe_order_pub.g_miss_line_adj_att_tbl;
    p_old_line_adj_att_tbl oe_order_pub.line_adj_att_tbl_type := oe_order_pub.g_miss_line_adj_att_tbl;
    p_line_adj_assoc_tbl oe_order_pub.line_adj_assoc_tbl_type := oe_order_pub.g_miss_line_adj_assoc_tbl;
    p_old_line_adj_assoc_tbl oe_order_pub.line_adj_assoc_tbl_type := oe_order_pub.g_miss_line_adj_assoc_tbl;
    p_line_scredit_tbl oe_order_pub.line_scredit_tbl_type := oe_order_pub.g_miss_line_scredit_tbl;
    p_old_line_scredit_tbl oe_order_pub.line_scredit_tbl_type := oe_order_pub.g_miss_line_scredit_tbl;
    p_line_scredit_val_tbl oe_order_pub.line_scredit_val_tbl_type := oe_order_pub.g_miss_line_scredit_val_tbl;
    p_old_line_scredit_val_tbl oe_order_pub.line_scredit_val_tbl_type := oe_order_pub.g_miss_line_scredit_val_tbl;
    p_lot_serial_tbl oe_order_pub.lot_serial_tbl_type := oe_order_pub.g_miss_lot_serial_tbl;
    p_old_lot_serial_tbl oe_order_pub.lot_serial_tbl_type := oe_order_pub.g_miss_lot_serial_tbl;
    p_lot_serial_val_tbl oe_order_pub.lot_serial_val_tbl_type := oe_order_pub.g_miss_lot_serial_val_tbl;
    p_old_lot_serial_val_tbl oe_order_pub.lot_serial_val_tbl_type := oe_order_pub.g_miss_lot_serial_val_tbl;
    p_action_request_tbl oe_order_pub.request_tbl_type := oe_order_pub.g_miss_request_tbl;
    x_header_val_rec oe_order_pub.header_val_rec_type;
    x_header_adj_tbl oe_order_pub.header_adj_tbl_type;
    x_header_adj_val_tbl oe_order_pub.header_adj_val_tbl_type;
    x_header_price_att_tbl oe_order_pub.header_price_att_tbl_type;
    x_header_adj_att_tbl oe_order_pub.header_adj_att_tbl_type;
    x_header_adj_assoc_tbl oe_order_pub.header_adj_assoc_tbl_type;
    x_header_scredit_tbl oe_order_pub.header_scredit_tbl_type;
    x_header_scredit_val_tbl oe_order_pub.header_scredit_val_tbl_type;
    x_debug_file VARCHAR2(100);
    l_line_tbl_index NUMBER;
    l_msg_index_out NUMBER(10);
   
   
     /*******************************************************************************************************************
    * Record Type and Table Type: Header IN record Type and Table type Declaration and Initialization
    *******************************************************************************************************************/

    TYPE XXAWR_SALES_ORDER_REC_TYPE_HDR IS RECORD (
            RECORD_ID NUMBER,
            transactional_curr_code VARCHAR2(240),
            SF_ORDER_NUMBER     NUMBER,
            pricing_date            DATE,
            customer_id             VARCHAR2(240),--CUSTOMER NAME IE SOLD TO ORG NAME
            customer_name           VARCHAR2(240),
            price_list_id           VARCHAR2(240),
            price_list_name         VARCHAR2(240)  --LIST HEADER Id
            ,ordered_date            DATE,
            sold_from_org_id        VARCHAR2(240),
            sold_from_org_name      VARCHAR2(240),
            salesrep_id             VARCHAR2(240),
            salesrep_name           VARCHAR2(240),
            order_type_id           VARCHAR2(240),
            order_type_name         VARCHAR2(240),
            error_msg               VARCHAR2(2000),
            l_line_table_index      NUMBER,
            uom_code                VARCHAR2(240),
            ordered_quantity        NUMBER,
            inventory_item_id       mtl_system_items_b.inventory_item_id%TYPE,
            inventory_item_name     mtl_system_items_b.segment1%TYPE, --SEGMENT1
            order_number            NUMBER,
            line_id                 VARCHAR2(240),
            line_number             NUMBER
    ,OIC_INTERFACE_ID VARCHAR2(240)
    );
    TYPE XXAWR_SALES_ORDER_TABLE_TYPE_HDR IS
        TABLE OF XXAWR_SALES_ORDER_REC_TYPE_HDR INDEX BY BINARY_INTEGER;
    SO_HDR_IN_AWR XXAWR_SALES_ORDER_TABLE_TYPE_HDR;
    SO_HDR_OUT_AWR XXAWR_SALES_ORDER_TABLE_TYPE_HDR;
 

 
    TYPE XXAWR_SALES_ORDER_REC_TYPE_LINE IS RECORD (
    RECORD_ID NUMBER,
    SF_ORDER_NUMBER number,
           uom_code                VARCHAR2(240),
            ordered_quantity        NUMBER,
            ship_from_org_id        VARCHAR2(240),
            ship_from_org_name      VARCHAR2(240),
            cancel_flag varchar2(10),
            inventory_item_id       mtl_system_items_b.inventory_item_id%TYPE,
            inventory_item_name     mtl_system_items_b.segment1%TYPE --SEGMENT1
            ,CHANGE_REASON varchar2(240),
          OIC_INTERFACE_ID VARCHAR2(240)
 );
    type XXAWR_SALES_ORDER_TABLE_TYPE_LINE is table
    of XXAWR_SALES_ORDER_REC_TYPE_LINE index by binary_integer;
   SO_LINE_IN_AWR XXAWR_SALES_ORDER_TABLE_TYPE_LINE;
    SO_LINE_OUT_AWR XXAWR_SALES_ORDER_TABLE_TYPE_LINE;
  
	
   /*******************************************************************************************************************
    * Program Name   : XXAWR_insert_custom
    * Language v_action_request_tbl_out      : PL/SQL
    * Description    : Procedure To Populate Data from SALESFORCE System to Oracle Staging Table
    * History        :
    * WHO              WHAT                                                          WHEN
    * --------------   -------------------------------------------------------       --------------
    *                     Populate Data from SALESFORCE System to Oracle Staging Table      08-JAN-2024
    *******************************************************************************************************************/
    PROCEDURE XXAWR_INSERT_CUSTOM_DATA_AWR (
       p_interface_id IN NUMBER,
        p_so_HDR_in        IN XXAWR_SALES_ORDER_TABLE_TYPE_HDR,
        p_so_HDR_out       OUT XXAWR_SALES_ORDER_TABLE_TYPE_HDR,
        p_SO_LINE_IN_AWR       in XXAWR_SALES_ORDER_TABLE_TYPE_LINE,
        p_SO_LINE_OUT_AWR      out XXAWR_SALES_ORDER_TABLE_TYPE_LINE
    );
	
	
	/*******************************************************************************************************************
    * Program Name   : main
    * Language       : PL/SQL
    * Description    : Procedure TO Populate Data from SALESFORCE System to Oracle Staging Table
    * History        :
    * WHO              WHAT                                                             WHEN
    * --------------   -------------------------------------------------------       --------------
    *                    DRAFT 1.0 IE MAIN PROGRAM DECLERATION IN SPEC                   08-JAN-2024              08-JAN-2024
   *******************************************************************************************************************/

    PROCEDURE MAIN_PROCEDURE (
--        p_errbuff OUT VARCHAR2,
--        p_retcode OUT VARCHAR2
             p_OIC_interface_id IN NUMBER
      -- ,P_ACTION_TYPE  IN VARCHAR2
   
    );

END XXAWR_SALES_ORDER_PACKAGE_INTG;