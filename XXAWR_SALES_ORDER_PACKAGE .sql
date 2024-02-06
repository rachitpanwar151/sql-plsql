CREATE OR REPLACE PACKAGE BODY XXAWR_SALES_ORDER_PACKAGE_AWR

AS
   /*******************************************************************************************************************
    * $Header         : @(#)
    * Program Name    : XXAWR_SALES_ORDER_PACKAGE_AWR.pbs
    * Language        : PL/SQL
    * Description     :
    *
    * History         :
    *
    * WHO              WHAT                                                     WHEN
    * --------------   -------------------------------------------------       --------------
    *                    1.0 - AWR SO                                    08-JAN-2024
    *******************************************************************************************************************/

    /*******************************************************************************************************************
    * Program Name   : XXAWR_INSERT_CUSTOM_DATA_AWR
    * Language       : PL/SQL
    * Description    : Procedure To Populate Data from SALESFORCE System to Oracle Staging Table
    * History        :
    * WHO              WHAT                                                          WHEN
    * --------------   -------------------------------------------------------       --------------
    *                      Populate Data from SALESFORCE System to Oracle Staging Table      08-JAN-2024
    *******************************************************************************************************************/
    PROCEDURE xxawr_insert_custom_data_awr (
        p_interface_id IN NUMBER,
        p_so_in        IN xxawr_so_table_type,
        p_so_out       OUT xxawr_so_table_type,
        p_so_line_in   IN xxawr_so_table_type_line,
        p_so_line_out  OUT xxawr_so_table_type_line
    ) IS
     /****************************************************
       * Local Variables : Declaration and Initialization
       ****************************************************/

        ecode NUMBER;
        emesg VARCHAR2(2000);
    BEGIN
        dbms_output.put_line('Row Count is ' || p_so_in.count);
--        dbms_output.put_line( 'Row Count is ' || p_so_in.count);

   /****************************************************
          * Project Table insert  :  insert in Header
   ****************************************************/

        IF p_so_in.count > 0 THEN
            FOR indx IN 1..p_so_in.count LOOP
                BEGIN
                    INSERT INTO xxawr_so_hdr_staging (
                        record_id,
                        transactional_curr_code,
                        temp_cust_po_number,
                        pricing_date,
                        customer_name --customer name
                        ,
                        order_type_name,
                        price_list_name,
                        sold_from_org_name,
                        salesrep_name,
                        request_id
                    ) VALUES (
                        RECORD_HDR.NEXTVAL,
                        p_so_in(indx).transactional_curr_code,
                        p_so_in(indx).temp_cust_po_number,
                        p_so_in(indx).pricing_date,
                        p_so_in(indx).customer_name,
                        p_so_in(indx).order_type_name,
                        p_so_in(indx).price_list_name,
                        p_so_in(indx).sold_from_org_name,
                        p_so_in(indx).salesrep_name,
                        gn_request_id
                    );

                    COMMIT;
                EXCEPTION
                    WHEN OTHERS THEN
                        ecode := sqlcode;
                        emesg := sqlerrm;
                        UPDATE xxawr_so_hdr_staging
                        SET
                            error_msg = 'Error in inserting TC Level class '
                                        || ecode
                                        || '-'
                                        || emesg,
                            status_msg = 'E'
                        WHERE
                            request_id = gn_request_id;

                        COMMIT;
                END;
            END LOOP;

        END IF;
   /****************************************************
          * Project Table insert  :  insert in line
          ****************************************************/

        IF p_so_line_in.count > 0 THEN
            FOR i IN 1..p_so_line_in.count LOOP
                BEGIN
                    INSERT INTO xxawr_so_line_staging (
                        RECORD_ID,
                        temp_cust_po_number,
                        ordered_quantity,
                        ship_from_org_name,
                        inventory_item_name,
                        uom_code,
                        request_id
                    ) VALUES (
                        RECORD_LINE.NEXTVAL,
                        p_so_line_in(i).temp_cust_po_number,
                        p_so_line_in(i).ordered_quantity,
                        p_so_line_in(i).ship_from_org_name,
                        p_so_line_in(i).inventory_item_name,
                        p_so_line_in(i).uom_code,
                        gn_request_id
                    );

                    COMMIT;
                EXCEPTION
                    WHEN OTHERS THEN
                        ecode := sqlcode;
                        emesg := sqlerrm;
                        UPDATE xxawr_so_line_staging
                        SET
                            error_msg = 'Error in inserting TC Level class '
                                        || ecode
                                        || '-'
                                        || emesg,
                            status_msg = 'E'
                        WHERE
                            request_id = gn_request_id;

                        COMMIT;
                END;
            END LOOP;
        END IF;

    END xxawr_insert_custom_data_awr;
    
    
    
    
    
    PROCEDURE XXAWR_HARDCODE_VALUE
    AS
    BEGIN
    
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(1).TRANSACTIONAL_CURR_CODE := 'USD';
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(1).PRICING_DATE := SYSDATE;
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(1).CUSTOMER_NAME :=TO_CHAR('AT Private Ltd');
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(1).ORDER_TYPE_NAME :='Mixed';
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(1).PRICE_LIST_NAME := 'Corporate';
        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(1).SOLD_FROM_ORG_NAME :='Vision Operations';
        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(1).SALESREP_NAME:= 'No Sales Credit';
        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(1).TEMP_CUST_PO_NUMBER :=1;
--        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(1).RECORD_ID :=RECORD_HDR.NEXTVAL;

                                 
                                 -------------------
                                 

         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(2).TRANSACTIONAL_CURR_CODE := 'USD';
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(2).PRICING_DATE := SYSDATE;
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(2).CUSTOMER_NAME :=TO_CHAR('AT Private Ltd');
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(2).ORDER_TYPE_NAME :='Mixed';
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(2).PRICE_LIST_NAME := 'Corporate';
        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(2).SOLD_FROM_ORG_NAME :='Vision Operations';
        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(2).SALESREP_NAME:= 'No Sales Credit';                          
        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(2).TEMP_CUST_PO_NUMBER :=1;
--        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(2).RECORD_ID :=RECORD_HDR.NEXTVAL;                                 
                                 
                                 ---------------------------------------
                                 
                                 

         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(3).TRANSACTIONAL_CURR_CODE := 'USD';
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(3).PRICING_DATE := SYSDATE;
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(3).CUSTOMER_NAME :=TO_CHAR('AT Private Ltd');
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(3).ORDER_TYPE_NAME :='Mixed';
         XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(3).PRICE_LIST_NAME := 'Corporate';
        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(3).SOLD_FROM_ORG_NAME :='Vision Operations';
        XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(3).SALESREP_NAME:= 'No Sales Credit';
       XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(3).TEMP_CUST_PO_NUMBER :=2;
--               XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR(3).RECORD_ID :=RECORD_HDR.NEXTVAL;
       
       
       
                XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(1).ORDERED_QUANTITY :=10;
        XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(1).SHIP_FROM_ORG_NAME:= 'Seattle Manufacturing';
        XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(1).INVENTORY_ITEM_NAME :='rp_car';
XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(1).TEMP_CUST_PO_NUMBER :=1;
 XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(1).uom_code := 'Ea';
-- XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(1).RECORD_ID := RECORD_LINE.NEXTVAL;                                
                                 -------------------
                                 

         XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(2).ORDERED_QUANTITY :=10;
        XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(2).SHIP_FROM_ORG_NAME:= 'Seattle Manufacturing'; 
        XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(2).INVENTORY_ITEM_NAME :='Copper_bottle';
       XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(2).TEMP_CUST_PO_NUMBER :=1;
      XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(2).uom_code := 'Ea';
--    XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(2).RECORD_ID := RECORD_LINE.NEXTVAL;                                
                                 
                                 
                                 ---------------------------------------
                               
                                 

         XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(3).ORDERED_QUANTITY :=10;
        XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(3).SHIP_FROM_ORG_NAME:= 'Seattle Manufacturing';
        XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(3).INVENTORY_ITEM_NAME :='destmok_transmission_a';
XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(3).TEMP_CUST_PO_NUMBER :=2;
XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(3).uom_code := 'Ea';
--XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in(3).RECORD_ID := RECORD_LINE.NEXTVAL;

    
    END XXAWR_HARDCODE_VALUE;
    
    
    
     /*******************************************************************************************************************
    * Program Name   : UPDATE_ORDER_CREATE_DETAILS
    * Language       : PL/SQL
    * Description    : Procedure To UPDATE ORDER CREATION DETAILS INTO Staging Table
    * History        :
    * WHO              WHAT                                                          WHEN
    * --------------   -------------------------------------------------------       --------------
    *                   Update Data in order details in Staging Table                   08-JAN-2024
    *******************************************************************************************************************/
    PROCEDURE update_order_create_details (
        p_temp_order_num IN VARCHAR2,
        p_header_id      IN NUMBER
    ) AS
    
    CURSOR C_LINE
    IS
    SELECT LINE_NUMBER,RECORD_ID FROM XXAWR_SO_LINE_STAGING
    WHERE STATUS_MSG='V';
    BEGIN
		/*****************************************************************************************
        PROCEDURE TO UPDATE ORDER NUMBER AND HEADER AND LINE ID AND ERRORS  ENCOUNTERED IN API
        *****************************************************************************************/
        BEGIN
   
   dbms_output.put_line('ORDER CREAT UPDATE K LIA ATYA');
   
            UPDATE xxawr_so_hdr_staging
            SET
                order_header_id = p_header_id,
                order_number = (
                    SELECT DISTINCT
                        oe.order_number
                    FROM
                        oe_order_headers_all oe
                    WHERE
                            oe.header_id = p_header_id
                        AND oe.org_id = 204
                ),
                flow_status_code = (
                    SELECT
                        flow_status_code
                    FROM
                        oe_order_headers_all oe
                    WHERE
                            oe.header_id = p_header_id
                        AND oe.org_id = 204
                )
            WHERE
                    temp_cust_po_number = p_temp_order_num
                AND request_id = gn_request_id;

            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('CANT UPDATE ALL DATA IN HEADER STAGING');
        END;


        FOR REC_LINE IN C_LINE
        LOOP
        BEGIN
        
            UPDATE xxawr_so_line_staging
            SET
                order_header_id = p_header_id,
                LINE_ID=(SELECT
                LINE_ID FROM OE_ORDER_LINES_ALL
                WHERE LINE_NUMBER=REC_LINE.LINE_NUMBER
                AND HEADER_ID=p_header_id)
                ,flow_status_code = (
                    SELECT DISTINCT
                        flow_status_code
                    FROM
                        oe_order_lines_all oe
                    WHERE
                            oe.header_id = p_header_id
                        AND oe.org_id = 204
                        AND LINE_NUMBER=REC_LINE.LINE_NUMBER
                )
                
            WHERE
                    temp_cust_po_number = p_temp_order_num
                    AND RECORD_ID=REC_LINE.RECORD_ID
                AND request_id = gn_request_id;

            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('CANT UPDATE ALL DATA IN LINE STAGING');
END ;
END LOOP;
    END update_order_create_details;




    
     /*******************************************************************************************************************
    * Program Name   : UPDATE_BOOKING_DETAILS_STAG
    * Language       : PL/SQL
    * Description    : Procedure To UPDATE BOOKING DETAILS INTO Staging Table
    * History        :
    * WHO              WHAT                                                          WHEN
    * --------------   -------------------------------------------------------       --------------
    *                     Update Data in order details in Staging Table                   08-JAN-2024
    *******************************************************************************************************************/
    
/****************************************************************
PROCEDURE TO UPDATE ORDER NUMBER AND HEADER AND LINE ID AND ERRORS
ENCOUNTERED IN API
********************************************************************/

    PROCEDURE update_booking_details_stag (
        p_header_id IN NUMBER
    ) AS
    BEGIN
        dbms_output.put_line('BOOKING UPDATE K ANDAR AYA');
        BEGIN
            UPDATE xxawr_so_hdr_staging st1
            SET
                st1.flow_status_code = (
                    SELECT DISTINCT
                        oe.flow_status_code
                    FROM
                        oe_order_headers_all oe
                    WHERE
                            oe.header_id = p_header_id
                        AND oe.org_id = 204
                )
            WHERE
                    st1.order_header_id = p_header_id
                AND st1.request_id = gn_request_id;

            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('CANNOT UPDATE BOOKING DETAILS IN HEADER STAING');
        END;

        BEGIN
            UPDATE xxawr_so_line_staging st2
            SET
                st2.flow_status_code = (
                    SELECT DISTINCT
                        oe.flow_status_code
                    FROM
                        oe_order_lines_all oe
                    WHERE
                            oe.header_id = p_header_id
                        AND oe.org_id = 204
                )
            WHERE
                    st2.order_header_id = p_header_id
                AND st2.request_id = gn_request_id;

            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line(' CANNOT UPDATE BOOKING DETAILS IN LINE STAGING');
        END;

    END update_booking_details_stag;

    PROCEDURE update_order_cancel_details (
        p_header_id IN NUMBER
    ) AS
    BEGIN
		/*****************************************************************************************
        PROCEDURE TO UPDATE ORDER NUMBER AND HEADER AND LINE ID AND ERRORS  ENCOUNTERED IN API
        *****************************************************************************************/
        BEGIN
            UPDATE xxawr_so_hdr_staging st1
            SET
                flow_status_code = (
                    SELECT DISTINCT
                        flow_status_code
                    FROM
                        oe_order_headers_all oe
                    WHERE
                            oe.header_id = p_header_id
                        AND oe.org_id = 204
                )
            WHERE
                    st1.order_header_id = p_header_id
                AND st1.request_id = gn_request_id;

            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('CANNOT UPDATE BOOKING DETAILS IN HEADER STAING');
        END;

        BEGIN
            UPDATE xxawr_so_line_staging st2
            SET
                flow_status_code = (
                    SELECT DISTINCT
                        flow_status_code
                    FROM
                        oe_order_lines_all oe
                    WHERE
                            oe.header_id = p_header_id
                        AND oe.org_id = 204
                )
            WHERE
                    st2.order_header_id = p_header_id
                AND st2.request_id = gn_request_id;

            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('CANNOT UPDATE BOOKING DETAILS IN HEADER STAING');
        END;

    END update_order_cancel_details;







    /*******************************************************************************************************************
    * Program Name   : UPDATE_LINE_QUANTITY
    * Language       : PL/SQL
    * Description    : Procedure To UPDATE LINE QUANTITY IN Sales Order
    * History        :
    * WHO              WHAT                                                          WHEN
    * --------------   -------------------------------------------------------       --------------
    *                  Procedure To UPDATE LINE QUANTITY IN Sales Order                                 08-JAN-2024
    *******************************************************************************************************************/





PROCEDURE UPDATE_LINE_QUANTITY
AS
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
CURSOR C_UPDATE_LINE
IS 
SELECT LINE_ID,LINE_NUMBER FROM XXAWR_SO_LINE_STAGING
WHERE STATUS_MSG='V' ;

BEGIN
 dbms_output.enable(1000000);
 
mo_global.init ('ONT');

 FND_GLOBAL.APPS_INITIALIZE(1014843,21623,660);
 oe_msg_pub.initialize;
 oe_debug_pub.initialize;
 X_DEBUG_FILE := OE_DEBUG_PUB.Set_Debug_Mode('FILE');
 oe_debug_pub.SetDebugLevel(5); -- Use 5 for the most debuging output, I warn  you its a lot of data
 dbms_output.put_line('START OF NEW DEBUG');
FOR REC_UPDATE_LINE IN C_UPDATE_LINE
LOOP
--This is to UPDATE order line
 l_line_tbl_index :=REC_UPDATE_LINE.LINE_NUMBER;
-- Changed attributes
 l_line_tbl(l_line_tbl_index) := OE_ORDER_PUB.G_MISS_LINE_REC;
 l_line_tbl(l_line_tbl_index).ordered_quantity := 6;
-- Primary key of the entity i.e. the order line
 l_line_tbl(l_line_tbl_index).line_id := REC_UPDATE_LINE.LINE_ID;
 l_line_tbl(l_line_tbl_index).change_reason := 'Administrative Reason';
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
COMMIT;
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
END LOOP;
END UPDATE_LINE_QUANTITY;



    /*******************************************************************************************************************
    * Program Name   : SALES_ORDER_CANCEL
    * Language       : PL/SQL
    * Description    : Procedure To CANCEL Sales Order
    * History        :
    * WHO              WHAT                                                          WHEN
    * --------------   -------------------------------------------------------       --------------
    *                     Procedure To CANCEL Sales Order                                 08-JAN-2024
    *******************************************************************************************************************/

    PROCEDURE sales_order_cancel AS

        v_api_version_number         NUMBER := 1;
        v_return_status              VARCHAR2(2000);
        v_msg_count                  NUMBER;
        v_msg_data                   VARCHAR2(2000);

-- IN Variables --
        v_header_rec                 oe_order_pub.header_rec_type;
        v_line_tbl                   oe_order_pub.line_tbl_type;
        v_action_request_tbl         oe_order_pub.request_tbl_type;
        v_line_adj_tbl               oe_order_pub.line_adj_tbl_type;

-- OUT Variables --
        v_header_rec_out             oe_order_pub.header_rec_type;
        v_header_val_rec_out         oe_order_pub.header_val_rec_type;
        v_header_adj_tbl_out         oe_order_pub.header_adj_tbl_type;
        v_header_adj_val_tbl_out     oe_order_pub.header_adj_val_tbl_type;
        v_header_price_att_tbl_out   oe_order_pub.header_price_att_tbl_type;
        v_header_adj_att_tbl_out     oe_order_pub.header_adj_att_tbl_type;
        v_header_adj_assoc_tbl_out   oe_order_pub.header_adj_assoc_tbl_type;
        v_header_scredit_tbl_out     oe_order_pub.header_scredit_tbl_type;
        v_header_scredit_val_tbl_out oe_order_pub.header_scredit_val_tbl_type;
        v_line_tbl_out               oe_order_pub.line_tbl_type;
        v_line_val_tbl_out           oe_order_pub.line_val_tbl_type;
        v_line_adj_tbl_out           oe_order_pub.line_adj_tbl_type;
        v_line_adj_val_tbl_out       oe_order_pub.line_adj_val_tbl_type;
        v_line_price_att_tbl_out     oe_order_pub.line_price_att_tbl_type;
        v_line_adj_att_tbl_out       oe_order_pub.line_adj_att_tbl_type;
        v_line_adj_assoc_tbl_out     oe_order_pub.line_adj_assoc_tbl_type;
        v_line_scredit_tbl_out       oe_order_pub.line_scredit_tbl_type;
        v_line_scredit_val_tbl_out   oe_order_pub.line_scredit_val_tbl_type;
        v_lot_serial_tbl_out         oe_order_pub.lot_serial_tbl_type;
        v_lot_serial_val_tbl_out     oe_order_pub.lot_serial_val_tbl_type;
        v_action_request_tbl_out     oe_order_pub.request_tbl_type;
        v_msg_index                  NUMBER;
        v_data                       VARCHAR2(2000);
        v_loop_count                 NUMBER;
        v_debug_file                 VARCHAR2(200);
        b_return_status              VARCHAR2(200);
        b_msg_count                  NUMBER;
        b_msg_data                   VARCHAR2(2000);
        CURSOR c_cancel IS
        SELECT DISTINCT
            order_header_id
        FROM
            xxawr_so_hdr_staging
        WHERE
            flow_status_code = 'BOOKED';

    BEGIN
        dbms_output.put_line('Starting of script');

-- Setting the Enviroment --

        mo_global.init('ONT');
        fnd_global.apps_initialize(user_id => 1014843, resp_id => 21623, resp_appl_id => 660);

        mo_global.set_policy_context('S', 204);

-- CANCEL HEADER --

        FOR r_cancel IN c_cancel LOOP
            v_header_rec := oe_order_pub.g_miss_header_rec;
            v_header_rec.operation := oe_globals.g_opr_update;
            v_header_rec.header_id := r_cancel.order_header_id;
            v_header_rec.cancelled_flag := 'Y';
            v_header_rec.change_reason := 'Administrative Reason';
            dbms_output.put_line('Starting of API');

-- CALLING THE API TO CANCEL AN ORDER --

            oe_order_pub.process_order(p_api_version_number => v_api_version_number, p_header_rec => v_header_rec, p_line_tbl => v_line_tbl
            , p_action_request_tbl => v_action_request_tbl, p_line_adj_tbl => v_line_adj_tbl
-- OUT variables

            ,
                                      x_header_rec => v_header_rec_out, x_header_val_rec => v_header_val_rec_out, x_header_adj_tbl => v_header_adj_tbl_out
                                      , x_header_adj_val_tbl => v_header_adj_val_tbl_out, x_header_price_att_tbl => v_header_price_att_tbl_out
                                      ,
                                      x_header_adj_att_tbl => v_header_adj_att_tbl_out, x_header_adj_assoc_tbl => v_header_adj_assoc_tbl_out
                                      , x_header_scredit_tbl => v_header_scredit_tbl_out, x_header_scredit_val_tbl => v_header_scredit_val_tbl_out
                                      , x_line_tbl => v_line_tbl_out,
                                      x_line_val_tbl => v_line_val_tbl_out, x_line_adj_tbl => v_line_adj_tbl_out, x_line_adj_val_tbl => v_line_adj_val_tbl_out
                                      , x_line_price_att_tbl => v_line_price_att_tbl_out, x_line_adj_att_tbl => v_line_adj_att_tbl_out
                                      ,
                                      x_line_adj_assoc_tbl => v_line_adj_assoc_tbl_out, x_line_scredit_tbl => v_line_scredit_tbl_out,
                                      x_line_scredit_val_tbl => v_line_scredit_val_tbl_out, x_lot_serial_tbl => v_lot_serial_tbl_out,
                                      x_lot_serial_val_tbl => v_lot_serial_val_tbl_out,
                                      x_action_request_tbl => v_action_request_tbl_out, x_return_status => v_return_status, x_msg_count => v_msg_count
                                      , x_msg_data => v_msg_data);

            dbms_output.put_line('Completion of API');
            IF v_return_status = fnd_api.g_ret_sts_success THEN
                COMMIT;
                dbms_output.put_line('Order Cancellation Success : ' || v_header_rec_out.header_id);
            ELSE
                dbms_output.put_line('Order Cancellation failed:' || v_msg_data);
                ROLLBACK;
                FOR i IN 1..v_msg_count LOOP
                    v_msg_data := oe_msg_pub.get(p_msg_index => i, p_encoded => 'F');
                    dbms_output.put_line(i
                                         || ') '
                                         || v_msg_data);
                END LOOP;

            END IF;

            update_order_cancel_details(r_cancel.order_header_id);
        END LOOP;

    END sales_order_cancel;



    
     /*******************************************************************************************************************
    * Program Name   : BOOKING_SALES_ORDER
    * Language       : PL/SQL
    * Description    : Procedure To  BOOKING SALES ORDER
    * History        :
    * WHO              WHAT                                                          WHEN
    * --------------   -------------------------------------------------------       --------------
    *                       BOOKING SALES ORDER                                          08-JAN-2024
    *******************************************************************************************************************/


    PROCEDURE booking_sales_order IS

		/**********PROCEDURE FOR BOOKING ORDERS  ******************/
        v_api_version_number         NUMBER := 1;
        v_return_status              VARCHAR2(2000);
        v_msg_count                  NUMBER;
        v_msg_data                   VARCHAR2(2000);
 -- IN Variables --
        v_header_rec                 oe_order_pub.header_rec_type;
        v_line_tbl                   oe_order_pub.line_tbl_type;
        v_action_request_tbl         oe_order_pub.request_tbl_type;
        v_line_adj_tbl               oe_order_pub.line_adj_tbl_type;
-- OUT Variables --
        v_header_rec_out             oe_order_pub.header_rec_type;
        v_header_val_rec_out         oe_order_pub.header_val_rec_type;
        v_header_adj_tbl_out         oe_order_pub.header_adj_tbl_type;
        v_header_adj_val_tbl_out     oe_order_pub.header_adj_val_tbl_type;
        v_header_price_att_tbl_out   oe_order_pub.header_price_att_tbl_type;
        v_header_adj_att_tbl_out     oe_order_pub.header_adj_att_tbl_type;
        v_header_adj_assoc_tbl_out   oe_order_pub.header_adj_assoc_tbl_type;
        v_header_scredit_tbl_out     oe_order_pub.header_scredit_tbl_type;
        v_header_scredit_val_tbl_out oe_order_pub.header_scredit_val_tbl_type;
        v_line_tbl_out               oe_order_pub.line_tbl_type;
        v_line_val_tbl_out           oe_order_pub.line_val_tbl_type;
        v_line_adj_tbl_out           oe_order_pub.line_adj_tbl_type;
        v_line_adj_val_tbl_out       oe_order_pub.line_adj_val_tbl_type;
        v_line_price_att_tbl_out     oe_order_pub.line_price_att_tbl_type;
        v_line_adj_att_tbl_out       oe_order_pub.line_adj_att_tbl_type;
        v_line_adj_assoc_tbl_out     oe_order_pub.line_adj_assoc_tbl_type;
        v_line_scredit_tbl_out       oe_order_pub.line_scredit_tbl_type;
        v_line_scredit_val_tbl_out   oe_order_pub.line_scredit_val_tbl_type;
        v_lot_serial_tbl_out         oe_order_pub.lot_serial_tbl_type;
        v_lot_serial_val_tbl_out     oe_order_pub.lot_serial_val_tbl_type;
        v_action_request_tbl_out     oe_order_pub.request_tbl_type;
        CURSOR cur_oe_hdr IS
        SELECT
            order_header_id
        FROM
            xxawr_so_hdr_staging
        WHERE
                request_id = gn_request_id
            AND status_msg = 'V';

    BEGIN
        FOR rec_booking_sales_order IN cur_oe_hdr LOOP
            dbms_output.put_line('BOOK K LOOP K ANDAR AYA' || rec_booking_sales_order.order_header_id);

 /*****************INITIALIZE ENVIRONMENT*************************************/

            mo_global.init('ONT');
            fnd_global.apps_initialize(gn_user_id, gn_resp_id, gn_resp_appl_id); -- PASS IN USER_ID, RESPONSIBILITY_ID, AND APPLICATION_ID
	
	/*****************INITIALIZE HEADER RECORD******************************/
            l_header_rec := oe_order_pub.g_miss_header_rec;
	
	/***********POPULATE REQUIRED ATTRIBUTES **********************************/

            v_action_request_tbl(1) := oe_order_pub.g_miss_request_rec;
            v_action_request_tbl(1).request_type := oe_globals.g_book_order;
            v_action_request_tbl(1).entity_code := oe_globals.g_entity_header;
            v_action_request_tbl(1).entity_id := rec_booking_sales_order.order_header_id;   --- header_id
            dbms_output.put_line('Starting of API');
            oe_order_pub.process_order(p_api_version_number => v_api_version_number, p_header_rec => v_header_rec, p_line_tbl => v_line_tbl
            , p_action_request_tbl => v_action_request_tbl
-- OUT variables
            , p_line_adj_tbl => v_line_adj_tbl,
                                      x_header_rec => v_header_rec_out, x_header_val_rec => v_header_val_rec_out, x_header_adj_tbl => v_header_adj_tbl_out
                                      , x_header_adj_val_tbl => v_header_adj_val_tbl_out, x_header_price_att_tbl => v_header_price_att_tbl_out
                                      ,
                                      x_header_adj_att_tbl => v_header_adj_att_tbl_out, x_header_adj_assoc_tbl => v_header_adj_assoc_tbl_out
                                      , x_header_scredit_tbl => v_header_scredit_tbl_out, x_header_scredit_val_tbl => v_header_scredit_val_tbl_out
                                      , x_line_tbl => v_line_tbl_out,
                                      x_line_val_tbl => v_line_val_tbl_out, x_line_adj_tbl => v_line_adj_tbl_out, x_line_adj_val_tbl => v_line_adj_val_tbl_out
                                      , x_line_price_att_tbl => v_line_price_att_tbl_out, x_line_adj_att_tbl => v_line_adj_att_tbl_out
                                      ,
                                      x_line_adj_assoc_tbl => v_line_adj_assoc_tbl_out, x_line_scredit_tbl => v_line_scredit_tbl_out,
                                      x_line_scredit_val_tbl => v_line_scredit_val_tbl_out, x_lot_serial_tbl => v_lot_serial_tbl_out,
                                      x_lot_serial_val_tbl => v_lot_serial_val_tbl_out,
                                      x_action_request_tbl => v_action_request_tbl_out, x_return_status => v_return_status, x_msg_count => v_msg_count
                                      , x_msg_data => v_msg_data);

            COMMIT;
            dbms_output.put_line('Completion of API');
            IF v_return_status = fnd_api.g_ret_sts_success THEN
                COMMIT;
                dbms_output.put_line('Booking of an Existing Order is Success ' || v_return_status);
            ELSE
                dbms_output.put_line('Booking of an Existing Order failed:'
                                     || v_return_status
                                     || v_msg_data);
                ROLLBACK;
                FOR i IN 1..v_msg_count LOOP
                    v_msg_data := oe_msg_pub.get(p_msg_index => i, p_encoded => 'F');
                    dbms_output.put_line(i
                                         || ') '
                                         || v_msg_data);
                END LOOP;

            END IF;

            dbms_output.put_line('END IF HUA');
            update_booking_details_stag(rec_booking_sales_order.order_header_id);
            dbms_output.put_line('END LOOP SAY PHLAY AYA');
        END LOOP;
    END booking_sales_order;

    

    
    
    

    /*******************************************************************************************************************
    * Program Name   : SALES_ORDER_CREATION
    * Language       : PL/SQL
    * Description    : Procedure To Create Sales Order
    * History        :
    * WHO              WHAT                                                          WHEN
    * --------------   -------------------------------------------------------       --------------
    *                    Procedure To Create Sales Order                                 08-JAN-2024
    *******************************************************************************************************************/

    PROCEDURE sales_order_creation IS

		/**********PROCEDURE FOR SALES ORDER CREATION ******************/
        l_return_status              VARCHAR2(1000);
        l_msg_count                  NUMBER;
        l_msg_data                   VARCHAR2(1000);
        p_api_version_number         NUMBER := 1.0;
        p_init_msg_list              VARCHAR2(10) := fnd_api.g_false;
        p_return_values              VARCHAR2(10) := fnd_api.g_false;
        p_action_commit              VARCHAR2(10) := fnd_api.g_false;
        x_return_status              VARCHAR2(1);
        x_msg_count                  NUMBER;
        x_msg_data                   VARCHAR2(100);
        l_header_rec                 oe_order_pub.header_rec_type;
        l_line_tbl                   oe_order_pub.line_tbl_type;
        l_action_request_tbl         oe_order_pub.request_tbl_type;
        l_header_adj_tbl             oe_order_pub.header_adj_tbl_type;
        l_line_adj_tbl               oe_order_pub.line_adj_tbl_type;
        l_header_scr_tbl             oe_order_pub.header_scredit_tbl_type;
        l_line_scredit_tbl           oe_order_pub.line_scredit_tbl_type;
        l_request_rec                oe_order_pub.request_rec_type;
        x_header_rec                 oe_order_pub.header_rec_type := oe_order_pub.g_miss_header_rec;
        p_old_header_rec             oe_order_pub.header_rec_type := oe_order_pub.g_miss_header_rec;
        p_header_val_rec             oe_order_pub.header_val_rec_type := oe_order_pub.g_miss_header_val_rec;
        p_old_header_val_rec         oe_order_pub.header_val_rec_type := oe_order_pub.g_miss_header_val_rec;
        p_header_adj_tbl             oe_order_pub.header_adj_tbl_type := oe_order_pub.g_miss_header_adj_tbl;
        p_old_header_adj_tbl         oe_order_pub.header_adj_tbl_type := oe_order_pub.g_miss_header_adj_tbl;
        p_header_adj_val_tbl         oe_order_pub.header_adj_val_tbl_type := oe_order_pub.g_miss_header_adj_val_tbl;
        p_old_header_adj_val_tbl     oe_order_pub.header_adj_val_tbl_type := oe_order_pub.g_miss_header_adj_val_tbl;
        p_header_price_att_tbl       oe_order_pub.header_price_att_tbl_type := oe_order_pub.g_miss_header_price_att_tbl;
        p_old_header_price_att_tbl   oe_order_pub.header_price_att_tbl_type := oe_order_pub.g_miss_header_price_att_tbl;
        p_header_adj_att_tbl         oe_order_pub.header_adj_att_tbl_type := oe_order_pub.g_miss_header_adj_att_tbl;
        p_old_header_adj_att_tbl     oe_order_pub.header_adj_att_tbl_type := oe_order_pub.g_miss_header_adj_att_tbl;
        p_header_adj_assoc_tbl       oe_order_pub.header_adj_assoc_tbl_type := oe_order_pub.g_miss_header_adj_assoc_tbl;
        p_old_header_adj_assoc_tbl   oe_order_pub.header_adj_assoc_tbl_type := oe_order_pub.g_miss_header_adj_assoc_tbl;
        p_header_scredit_tbl         oe_order_pub.header_scredit_tbl_type := oe_order_pub.g_miss_header_scredit_tbl;
        p_old_header_scredit_tbl     oe_order_pub.header_scredit_tbl_type := oe_order_pub.g_miss_header_scredit_tbl;
        p_header_scredit_val_tbl     oe_order_pub.header_scredit_val_tbl_type := oe_order_pub.g_miss_header_scredit_val_tbl;
        p_old_header_scredit_val_tbl oe_order_pub.header_scredit_val_tbl_type := oe_order_pub.g_miss_header_scredit_val_tbl;
        x_line_val_tbl               oe_order_pub.line_val_tbl_type;
        x_line_adj_tbl               oe_order_pub.line_adj_tbl_type;
        x_line_adj_val_tbl           oe_order_pub.line_adj_val_tbl_type;
        x_line_price_att_tbl         oe_order_pub.line_price_att_tbl_type;
        x_line_adj_att_tbl           oe_order_pub.line_adj_att_tbl_type;
        x_line_adj_assoc_tbl         oe_order_pub.line_adj_assoc_tbl_type;
        x_line_scredit_tbl           oe_order_pub.line_scredit_tbl_type;
        x_line_scredit_val_tbl       oe_order_pub.line_scredit_val_tbl_type;
        x_lot_serial_tbl             oe_order_pub.lot_serial_tbl_type;
        x_lot_serial_val_tbl         oe_order_pub.lot_serial_val_tbl_type;
        x_action_request_tbl         oe_order_pub.request_tbl_type;
        p_line_tbl                   oe_order_pub.line_tbl_type := oe_order_pub.g_miss_line_tbl;
        p_old_line_tbl               oe_order_pub.line_tbl_type := oe_order_pub.g_miss_line_tbl;
        p_line_val_tbl               oe_order_pub.line_val_tbl_type := oe_order_pub.g_miss_line_val_tbl;
        p_old_line_val_tbl           oe_order_pub.line_val_tbl_type := oe_order_pub.g_miss_line_val_tbl;
        p_line_adj_tbl               oe_order_pub.line_adj_tbl_type := oe_order_pub.g_miss_line_adj_tbl;
        p_old_line_adj_tbl           oe_order_pub.line_adj_tbl_type := oe_order_pub.g_miss_line_adj_tbl;
        p_line_adj_val_tbl           oe_order_pub.line_adj_val_tbl_type := oe_order_pub.g_miss_line_adj_val_tbl;
        p_old_line_adj_val_tbl       oe_order_pub.line_adj_val_tbl_type := oe_order_pub.g_miss_line_adj_val_tbl;
        p_line_price_att_tbl         oe_order_pub.line_price_att_tbl_type := oe_order_pub.g_miss_line_price_att_tbl;
        p_old_line_price_att_tbl     oe_order_pub.line_price_att_tbl_type := oe_order_pub.g_miss_line_price_att_tbl;
        p_line_adj_att_tbl           oe_order_pub.line_adj_att_tbl_type := oe_order_pub.g_miss_line_adj_att_tbl;
        p_old_line_adj_att_tbl       oe_order_pub.line_adj_att_tbl_type := oe_order_pub.g_miss_line_adj_att_tbl;
        p_line_adj_assoc_tbl         oe_order_pub.line_adj_assoc_tbl_type := oe_order_pub.g_miss_line_adj_assoc_tbl;
        p_old_line_adj_assoc_tbl     oe_order_pub.line_adj_assoc_tbl_type := oe_order_pub.g_miss_line_adj_assoc_tbl;
        p_line_scredit_tbl           oe_order_pub.line_scredit_tbl_type := oe_order_pub.g_miss_line_scredit_tbl;
        p_old_line_scredit_tbl       oe_order_pub.line_scredit_tbl_type := oe_order_pub.g_miss_line_scredit_tbl;
        p_line_scredit_val_tbl       oe_order_pub.line_scredit_val_tbl_type := oe_order_pub.g_miss_line_scredit_val_tbl;
        p_old_line_scredit_val_tbl   oe_order_pub.line_scredit_val_tbl_type := oe_order_pub.g_miss_line_scredit_val_tbl;
        p_lot_serial_tbl             oe_order_pub.lot_serial_tbl_type := oe_order_pub.g_miss_lot_serial_tbl;
        p_old_lot_serial_tbl         oe_order_pub.lot_serial_tbl_type := oe_order_pub.g_miss_lot_serial_tbl;
        p_lot_serial_val_tbl         oe_order_pub.lot_serial_val_tbl_type := oe_order_pub.g_miss_lot_serial_val_tbl;
        p_old_lot_serial_val_tbl     oe_order_pub.lot_serial_val_tbl_type := oe_order_pub.g_miss_lot_serial_val_tbl;
        p_action_request_tbl         oe_order_pub.request_tbl_type := oe_order_pub.g_miss_request_tbl;
        x_header_val_rec             oe_order_pub.header_val_rec_type;
        x_header_adj_tbl             oe_order_pub.header_adj_tbl_type;
        x_header_adj_val_tbl         oe_order_pub.header_adj_val_tbl_type;
        x_header_price_att_tbl       oe_order_pub.header_price_att_tbl_type;
        x_header_adj_att_tbl         oe_order_pub.header_adj_att_tbl_type;
        x_header_adj_assoc_tbl       oe_order_pub.header_adj_assoc_tbl_type;
        x_header_scredit_tbl         oe_order_pub.header_scredit_tbl_type;
        x_header_scredit_val_tbl     oe_order_pub.header_scredit_val_tbl_type;
        x_debug_file                 VARCHAR2(100);
        l_line_tbl_index             NUMBER := 0;
        l_msg_index_out              NUMBER(10);
        lc_api_error_message         VARCHAR2(2000);
        CURSOR cup_oe_hdr IS
        SELECT DISTINCT
            temp_cust_po_number,
            transactional_curr_code,
            TO_DATE(pricing_date),
            customer_id,
            price_list_id,
            sold_from_org_id,
            salesrep_id,
            ordered_type_id,
            request_id
        FROM
            xxawr_so_hdr_staging
        WHERE
            status_msg = 'V' 
--AND REQUEST_ID=gn_request_id;
            ;

        TYPE cup_oe_hdr_data_type IS
            TABLE OF cup_oe_hdr%rowtype INDEX BY PLS_INTEGER;
        oe_hdr_tbl                   cup_oe_hdr_data_type;
        ln_limit                     NUMBER := 100;
        CURSOR cur_oe_lines (
            p_temp_cust_po_number NUMBER
        ) IS
        SELECT
        RECORD_ID,
            ordered_quantity,
            ship_from_org_id,
            inventory_item_id
        FROM
            xxawr_so_line_staging
        WHERE
                status_msg = 'V'
            AND temp_cust_po_number = p_temp_cust_po_number
--   AND REQUEST_ID=GN_REQUEST_ID ;
            ;

        TYPE cur_oe_data_type IS
            TABLE OF cur_oe_lines%rowtype INDEX BY PLS_INTEGER;
        oe_lines_tbl                 cur_oe_data_type;
        ln_cnt                       NUMBER := 0;
    BEGIN
        dbms_output.put_line('Api Calling -1');
        fnd_global.apps_initialize(1014843, 21623, 660);
        mo_global.init('ONT');
        mo_global.set_policy_context('S', 204);
        oe_msg_pub.initialize;
        oe_debug_pub.initialize;
        x_debug_file := oe_debug_pub.set_debug_mode('FILE');
        oe_debug_pub.setdebuglevel(5);
        OPEN cup_oe_hdr;
        dbms_output.put_line('so create k hdr cursor open hua ');
        LOOP
            dbms_output.put_line('so create k hdr cursor k andar gya');
            FETCH cup_oe_hdr
            BULK COLLECT INTO oe_hdr_tbl LIMIT ln_limit;
            dbms_output.put_line('Api Calling -3.1');
            dbms_output.put_line('HEADER COUNT ' || oe_hdr_tbl.count);
            FOR indx IN 1..oe_hdr_tbl.count LOOP
                dbms_output.put_line('so create k hdr cursor k for k andar gya');
                lc_api_error_message := '';
                l_return_status := '';
                l_header_rec := oe_order_pub.g_miss_header_rec;
                l_header_rec.operation := oe_globals.g_opr_create;
                l_header_rec.transactional_curr_code := oe_hdr_tbl(indx).transactional_curr_code;
                l_header_rec.pricing_date := sysdate;
                l_header_rec.sold_to_org_id := oe_hdr_tbl(indx).customer_id;
--                    l_header_rec.ship_to_org_id := oe_hdr_tbl(indx).ship_from_org_id;
                l_header_rec.price_list_id := oe_hdr_tbl(indx).price_list_id;
                l_header_rec.ordered_date := sysdate;
                l_header_rec.sold_from_org_id := oe_hdr_tbl(indx).sold_from_org_id;
                l_header_rec.salesrep_id := oe_hdr_tbl(indx).salesrep_id;
                l_header_rec.order_type_id := oe_hdr_tbl(indx).ordered_type_id;
                OPEN cur_oe_lines(oe_hdr_tbl(indx).temp_cust_po_number);
                LOOP
                    dbms_output.put_line('Api Calling -4.1');
                    FETCH cur_oe_lines
                    BULK COLLECT INTO oe_lines_tbl LIMIT ln_limit;
                    FOR i IN 1..oe_lines_tbl.count LOOP
                        dbms_output.put_line('order create may line k loop k andar aya aya' || gn_request_id);
                        l_line_tbl_index := l_line_tbl_index + 1;
                        dbms_output.put_line('Line count' || l_line_tbl_index);
						
						
						
						
BEGIN
DBMS_OUTPUT.PUT_LINE('RECORD ID AAAHAA:-===='||oe_lines_tbl(I).RECORD_ID);
UPDATE XXAWR_SO_LINE_STAGING
SET LINE_NUMBER=l_line_tbl_index
WHERE STATUS_MSG='V'
AND RECORD_ID=oe_lines_tbl(I).RECORD_ID;
EXCEPTION
WHEN OTHERS
THEN
DBMS_OUTPUT.PUT_LINE('ERROR OCCURED TO UPDATE LINE NUMBER IN STAGING');

END ;
						
                        l_line_tbl(l_line_tbl_index) := oe_order_pub.g_miss_line_rec;
                        l_line_tbl(l_line_tbl_index).operation := oe_globals.g_opr_create;
                        BEGIN
                            l_line_tbl(l_line_tbl_index).ordered_quantity := oe_lines_tbl(i).ordered_quantity;
                        EXCEPTION
                            WHEN OTHERS THEN
                                dbms_output.put_line('INVALID ORDERED QUANTITY');
                        END;

                        BEGIN
                            l_line_tbl(l_line_tbl_index).ship_from_org_id := oe_lines_tbl(i).ship_from_org_id;
                        EXCEPTION
                            WHEN OTHERS THEN
                                dbms_output.put_line('INVALID SHIP FORM ORG ID');
                        END;

                        BEGIN
                            l_line_tbl(l_line_tbl_index).inventory_item_id := oe_lines_tbl(i).inventory_item_id;
                        EXCEPTION
                            WHEN OTHERS THEN
                                dbms_output.put_line('INVALID ITEM ID');
                        END;

                    END LOOP;

                    l_line_tbl_index := 0;
                    EXIT WHEN oe_lines_tbl.count = 0;
                END LOOP;-- end line loop

                CLOSE cur_oe_lines;
                oe_order_pub.process_order(p_api_version_number => 1.0, p_init_msg_list => fnd_api.g_false, p_return_values => fnd_api.g_false
                , p_action_commit => fnd_api.g_false, x_return_status => l_return_status,
                                          x_msg_count => l_msg_count, x_msg_data => l_msg_data, p_header_rec => l_header_rec, p_line_tbl => l_line_tbl
                                          , p_action_request_tbl => l_action_request_tbl
                                -- OUT PARAMETERS
                                          ,
                                          x_header_rec => x_header_rec, x_header_val_rec => x_header_val_rec, x_header_adj_tbl => x_header_adj_tbl
                                          , x_header_adj_val_tbl => x_header_adj_val_tbl, x_header_price_att_tbl => x_header_price_att_tbl
                                          ,
                                          x_header_adj_att_tbl => x_header_adj_att_tbl, x_header_adj_assoc_tbl => x_header_adj_assoc_tbl
                                          , x_header_scredit_tbl => x_header_scredit_tbl, x_header_scredit_val_tbl => x_header_scredit_val_tbl
                                          , x_line_tbl => p_line_tbl,
                                          x_line_val_tbl => x_line_val_tbl, x_line_adj_tbl => x_line_adj_tbl, x_line_adj_val_tbl => x_line_adj_val_tbl
                                          , x_line_price_att_tbl => x_line_price_att_tbl, x_line_adj_att_tbl => x_line_adj_att_tbl,
                                          x_line_adj_assoc_tbl => x_line_adj_assoc_tbl, x_line_scredit_tbl => x_line_scredit_tbl, x_line_scredit_val_tbl => x_line_scredit_val_tbl
                                          , x_lot_serial_tbl => x_lot_serial_tbl, x_lot_serial_val_tbl => x_lot_serial_val_tbl,
                                          x_action_request_tbl => l_action_request_tbl);

                dbms_output.put_line('Order Header_ID : ' || x_header_rec.header_id);
   
--      dbms_output.put_line('Order line_ID : '||p_line_tbl.line_id);

                FOR i IN 1..l_msg_count LOOP
                    oe_msg_pub.get(p_msg_index => i, p_encoded => fnd_api.g_false, p_data => l_msg_data, p_msg_index_out => l_msg_index_out
                    );

                    dbms_output.put_line('message : ' || l_msg_data);
                    dbms_output.put_line('message index : ' || l_msg_index_out);
                    lc_api_error_message := lc_api_error_message || l_msg_data;
                    dbms_output.put_line('Api Calling -8');
                END LOOP;

   -- Check the return status
                IF l_return_status = fnd_api.g_ret_sts_success THEN
                    dbms_output.put_line('Order Created Successfull');
                ELSE
                    dbms_output.put_line('Order Creation Failed');
                END IF;
--   END LOOP;

                update_order_create_details(oe_hdr_tbl(indx).temp_cust_po_number, x_header_rec.header_id);
            END LOOP;

            EXIT WHEN oe_hdr_tbl.count = 0;
        END LOOP;--end header loop

        CLOSE cup_oe_hdr;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || sqlerrm);
    END sales_order_creation;











  /**********PROCEDURE TO VALIDATE DATA IN STAGING TABLES ******************/

    PROCEDURE xxawr_staging_validation IS

        CURSOR cur_so_header IS
        SELECT
            *
        FROM
            xxawr_so_hdr_staging
        WHERE
            status_msg IS NULL 
--	AND REQUEST_ID = GN_REQUEST_ID;
            ;

        TYPE cur_so_data_type_hdr IS
            TABLE OF cur_so_header%rowtype INDEX BY PLS_INTEGER;
        so_data_hdr             cur_so_data_type_hdr;
        CURSOR cur_so_lines (
            p_temp_cust_po_number IN VARCHAR2
        ) IS
        SELECT
            *
        FROM
            xxawr_so_line_staging
        WHERE
            status_msg IS NULL
            AND temp_cust_po_number = p_temp_cust_po_number
--	AND REQUEST_ID = GN_REQUEST_ID;
            ;

        TYPE cur_so_data_type_line IS
            TABLE OF cur_so_lines%rowtype INDEX BY PLS_INTEGER;
        so_data_line            cur_so_data_type_line;

-->local variable
        ln_currency_count       NUMBER;
        ln_uom_count            NUMBER;
        ln_transaction_quantity NUMBER;
    BEGIN
        dbms_output.put_line(' VALIDATION K LIA AYA');
        dbms_output.put_line('cursor khula');
        OPEN cur_so_header;
        LOOP
            dbms_output.put_line('cursor ka loop kay andar aya');
            FETCH cur_so_header
            BULK COLLECT INTO so_data_hdr LIMIT 500;
            FOR i IN 1..so_data_hdr.count LOOP
                so_data_hdr(i).status_msg := 'V';
                so_data_hdr(i).error_msg := '';
                dbms_output.put_line('fetch k loop k andar ayaa');
                
	/**************************************
     customer validation ie sold to org
	 *****************************************/

                IF so_data_hdr(i).customer_name IS NULL THEN
                    so_data_hdr(i).status_msg := 'E';
                    so_data_hdr(i).error_msg := so_data_hdr(i).error_msg
                                                || 'CUSTOMER NAME CAN NOT BE NULL'
                                                || sqlcode
                                                || '-'
                                                || sqlerrm;

                ELSE
                    BEGIN
                        SELECT
                            hca.cust_account_id
                        INTO so_data_hdr(i).customer_id
                        FROM
                            hz_parties       hp,
                            hz_cust_accounts hca
                        WHERE
                                hp.party_id = hca.party_id
                            AND upper(party_name) = upper(so_data_hdr(i).customer_name);

                    EXCEPTION
                        WHEN OTHERS THEN
                            so_data_hdr(i).status_msg := 'E';
                            so_data_hdr(i).error_msg := so_data_hdr(i).error_msg
                                                        || '-Customer name is invalid'
                                                        || sqlcode
                                                        || sqlerrm;

                    END;
                END IF;
				
				


/*********************************
	*VALIDATING PRICE LIST 
*********************************/

                IF so_data_hdr(i).price_list_name IS NULL THEN
                    so_data_hdr(i).status_msg := 'E';
                    so_data_hdr(i).error_msg := so_data_hdr(i).error_msg
                                                || 'PRICE LIST NAME CAN NOT BE NULL'
                                                || sqlcode
                                                || sqlerrm;

                ELSE
                    BEGIN
                        SELECT
                            price_list_id
                        INTO so_data_hdr(i).price_list_id
                        FROM
                            so_price_lists_vl
                        WHERE
                            lower(name) = lower(so_data_hdr(i).price_list_name);

                    EXCEPTION
                        WHEN OTHERS THEN
                            so_data_hdr(i).status_msg := 'E';
                            so_data_hdr(i).error_msg := so_data_hdr(i).error_msg
                                                        || 'ERROR IN VALIDATING PRICE LIST'
                                                        || sqlcode
                                                        || sqlerrm;

                    END;
                END IF;
	


--Sold from Organization validation

                IF so_data_hdr(i).sold_from_org_name IS NULL THEN
                    so_data_hdr(i).status_msg := 'E';
                    so_data_hdr(i).error_msg := so_data_hdr(i).error_msg
                                                || 'SOLD FROM ORG NAME CAN NOT BE NULL'
                                                || sqlcode
                                                || sqlerrm;

                ELSE
                    BEGIN
                        SELECT
                            organization_id
                        INTO so_data_hdr(i).sold_from_org_id
                        FROM
                            hr_organization_units
                        WHERE
                            lower(name) = lower(so_data_hdr(i).sold_from_org_name);

                    EXCEPTION
                        WHEN OTHERS THEN
                            so_data_hdr(i).status_msg := 'E';
                            so_data_hdr(i).error_msg := so_data_hdr(i).error_msg
                                                        || '-Sold from organization is invalid'
                                                        || sqlcode
                                                        || sqlerrm;

                    END;
                END IF;
                   
                   
					
					
	/********************************
	*SALESPERSON VALIDATION
	*********************************/

                IF so_data_hdr(i).salesrep_name IS NULL THEN
                    so_data_hdr(i).status_msg := 'E';
                    so_data_hdr(i).error_msg := so_data_hdr(i).error_msg
                                                || ' SALES Representative NAME  IS NULL'
                                                || sqlcode
                                                || sqlerrm;

                ELSE
                    BEGIN
                        SELECT
                            salesrep_id
                        INTO so_data_hdr(i).salesrep_id
                        FROM
                            ra_salesreps_all
                        WHERE
                                upper(name) = upper(so_data_hdr(i).salesrep_name)
                            AND ( sysdate BETWEEN start_date_active AND nvl(end_date_active, sysdate + 1) )
                            AND org_id = so_data_hdr(i).sold_from_org_id;

                    EXCEPTION
                        WHEN OTHERS THEN
                            so_data_hdr(i).status_msg := 'E';
                            so_data_hdr(i).error_msg := so_data_hdr(i).error_msg
                                                        || 'ERROR IN VALIDATING SALESPERSON   '
                                                        || sqlcode
                                                        || sqlerrm;

                    END;
                END IF;
	 
	 
	/*******************************
	*VALIDATING ORDER TYPE
	********************************/

                IF so_data_hdr(i).order_type_name IS NULL THEN
                    so_data_hdr(i).status_msg := 'E';
                    so_data_hdr(i).error_msg := so_data_hdr(i).error_msg
                                                || 'ORDER TYPE CAN NOT BE NULL'
                                                || sqlcode
                                                || sqlerrm;

                ELSE
                    BEGIN
                        SELECT
                            transaction_type_id
                        INTO so_data_hdr(i).ordered_type_id
                        FROM
                            oe_transaction_types_tl
                        WHERE
                            upper(name) = upper(so_data_hdr(i).order_type_name);

                    EXCEPTION
                        WHEN OTHERS THEN
                            so_data_hdr(i).status_msg := 'E';
                            so_data_hdr(i).error_msg := so_data_hdr(i).error_msg
                                                        || 'ERROR IN VALIDATING ORDER TYPE'
                                                        || sqlcode
                                                        || sqlerrm;

                    END;
                END IF;
	
	    
						
						
						
						
	/********************************
	*CURRENCY CODE VALIDATION
	*********************************/

                IF so_data_hdr(i).transactional_curr_code IS NULL THEN
                    so_data_hdr(i).status_msg := 'E';
                    so_data_hdr(i).error_msg := so_data_hdr(i).error_msg
                                                || ' TRANSACTIONAL CURRENCY CODE IS NULL'
                                                || sqlcode
                                                || sqlerrm;

                ELSE
                    SELECT
                        COUNT(currency_code)
                    INTO ln_currency_count
                    FROM
                        fnd_currencies
                    WHERE
                        upper(currency_code) = upper(so_data_hdr(i).transactional_curr_code);

                    IF ln_currency_count = 0 THEN
                        so_data_hdr(i).status_msg := 'E';
                        so_data_hdr(i).error_msg := so_data_hdr(i).error_msg
                                                    || ' TRANSACTIONAL CURRENCY CODE DOES NOT EXIST'
                                                    || sqlcode
                                                    || sqlerrm;

                    END IF;

                END IF;
				
                
                --->CURSOR OPEN FOR LINE


                OPEN cur_so_lines(so_data_hdr(i).temp_cust_po_number);
                LOOP
                    dbms_output.put_line('cursor line  ka loop kay andar aya');
                    FETCH cur_so_lines
                    BULK COLLECT INTO so_data_line LIMIT 500;
                    FOR i IN 1..so_data_line.count LOOP
                        so_data_line(i).status_msg := 'V';
                        so_data_line(i).error_msg := '';
                        dbms_output.put_line('fetch k line loop k andar ayaa');
                
                
	/********************************
	*UOM CODE VALIDATION
	*********************************/

                        IF so_data_line(i).uom_code IS NULL THEN
                            so_data_line(i).status_msg := 'E';
                            so_data_line(i).error_msg := so_data_line(i).error_msg
                                                         || ' UOM CODE IS NULL'
                                                         || sqlcode
                                                         || sqlerrm;

                        ELSE
                            SELECT
                                COUNT(uom_code)
                            INTO ln_uom_count
                            FROM
                                mtl_units_of_measure
                            WHERE
                                upper(uom_code) = upper(so_data_line(i).uom_code);

                            IF ln_uom_count = 0 THEN
                                so_data_line(i).status_msg := 'E';
                                so_data_line(i).error_msg := so_data_line(i).error_msg
                                                             || ' UOM_CODE  CODE DOES NOT EXIST'
                                                             || sqlcode
                                                             || sqlerrm;

                            END IF;

                        END IF;
	
/*****************
ship from Org
*******************/

                        IF so_data_line(i).ship_from_org_name IS NULL THEN
                            so_data_line(i).status_msg := 'E';
                            so_data_line(i).error_msg := so_data_line(i).error_msg
                                                         || 'SHIP FROM ORG NAME CAN NOT BE NULL'
                                                         || sqlcode
                                                         || sqlerrm;

                        ELSE
                            BEGIN
                                SELECT
                                    organization_id
                                INTO so_data_line(i).ship_from_org_id
                                FROM
                                    org_organization_definitions
                                WHERE
                                    upper(organization_name) = upper(so_data_line(i).ship_from_org_name);

            		
	
/*********************************
	*ITEM VALIDATION
*********************************/

                                IF so_data_line(i).inventory_item_name IS NULL THEN
                                    so_data_line(i).status_msg := 'E';
                                    so_data_line(i).error_msg := so_data_line(i).error_msg
                                                                 || 'ITEM NAME CAN NOT BE NULL'
                                                                 || sqlcode
                                                                 || sqlerrm;

                                ELSE
                                    BEGIN
                                        SELECT
                                            inventory_item_id
                                        INTO so_data_line(i).inventory_item_id
                                        FROM
                                            mtl_system_items_b
                                        WHERE
                                                upper(segment1) = upper(so_data_line(i).inventory_item_name)
                                            AND organization_id = so_data_line(i).ship_from_org_id;
    
    
    
	/********************************
	*QUANTITY VALIDATION
	*********************************/

                                        IF so_data_line(i).ordered_quantity IS NULL THEN
                                            so_data_line(i).status_msg := 'E';
                                            so_data_line(i).error_msg := so_data_line(i).error_msg
                                                                         || ' QUANTITY IS NULL'
                                                                         || sqlcode
                                                                         || sqlerrm;

                                        ELSE
                                            IF so_data_line(i).ordered_quantity <= 0 THEN
                                                so_data_line(i).status_msg := 'E';
                                                so_data_line(i).error_msg := so_data_line(i).error_msg
                                                                             || ' QUANTITY CAN NOT BE ZERO OR LESS THAN ZERO'
                                                                             || sqlcode
                                                                             || sqlerrm;

                                            ELSE 
	
	/*****************************
	*CHECKING ONHAND QUANTITIES 
	******************************/
                                                BEGIN
                                                    SELECT
                                                        SUM(transaction_quantity),
                                                        inventory_item_id
                                                    INTO
                                                        ln_transaction_quantity,
                                                        so_data_line(i).inventory_item_id
                                                    FROM
                                                        mtl_onhand_quantities
                                                    WHERE
                                                            inventory_item_id = so_data_line(i).inventory_item_id
                                                        AND organization_id = so_data_line(i).ship_from_org_id
                                                    GROUP BY
                                                        inventory_item_id;

                                                    IF ln_transaction_quantity < so_data_line(i).ordered_quantity THEN
                                                        so_data_line(i).status_msg := 'E';
                                                        so_data_line(i).error_msg := so_data_line(i).error_msg
                                                                                     || 'ONHAND QUANITITY FAILED TO SATISFY RESERVATION'
                                                                                     || sqlcode
                                                                                     || sqlerrm;

                                                    END IF;

                                                EXCEPTION
                                                    WHEN OTHERS THEN
                                                        so_data_line(i).status_msg := 'E';
                                                        so_data_line(i).error_msg := so_data_line(i).error_msg
                                                                                     || 'ITEM DOES NOT EXIST IN SELECTED WAREHOUSE'
                                                                                     || sqlcode
                                                                                     || sqlerrm;

                                                END;
                                            END IF;
                                        END IF;

                                    EXCEPTION
                                        WHEN OTHERS THEN
                                            so_data_line(i).status_msg := 'E';
                                            so_data_line(i).error_msg := so_data_line(i).error_msg
                                                                         || 'ITEM NAME DOES NOT EXIST'
                                                                         || sqlcode
                                                                         || sqlerrm;

                                    END;
                                END IF;

                            EXCEPTION
                                WHEN OTHERS THEN
                                    so_data_line(i).status_msg := 'E';
                                    so_data_line(i).error_msg := so_data_line(i).error_msg
                                                                 || 'SHIP FROM ORG DOES NOT EXIST '
                                                                 || sqlcode
                                                                 || sqlerrm;

                            END;
                        END IF;

                        BEGIN
                            UPDATE xxawr_so_line_staging
                            SET
                                ship_from_org_id = so_data_line(i).ship_from_org_id,
                                inventory_item_id = so_data_line(i).inventory_item_id,
                                status_msg = so_data_line(i).status_msg,
                                error_msg = so_data_line(i).error_msg,
                                request_id = gn_request_id
                            WHERE
                                temp_cust_po_number = so_data_line(i).temp_cust_po_number
								and record_id=so_data_line(i).record_id;

                            COMMIT;
                        EXCEPTION
                            WHEN OTHERS THEN
                                dbms_output.put_line('UPDATE ERROR IN LINE'
                                                     || sqlcode
                                                     || '-'
                                                     || sqlerrm);
                        END;

                    END LOOP;

                    EXIT WHEN so_data_line.count = 0;
                END LOOP;

                CLOSE cur_so_lines;
                BEGIN
                    UPDATE xxawr_so_hdr_staging
                    SET
                        salesrep_id = so_data_hdr(i).salesrep_id,
                        ordered_date = sysdate,
--	SHIP_TO_ORG_ID = SO_DATA_HDR(I).SHIP_TO_ORG_ID,
                        ordered_type_id = so_data_hdr(i).ordered_type_id,
                        price_list_id = so_data_hdr(i).price_list_id,
                        customer_id = so_data_hdr(i).customer_id,
                        sold_from_org_id = so_data_hdr(i).sold_from_org_id,
                        status_msg = so_data_hdr(i).status_msg,
                        error_msg = so_data_hdr(i).error_msg,
                        request_id = gn_request_id
                    WHERE
                        temp_cust_po_number = so_data_hdr(i).temp_cust_po_number;

                    dbms_output.put_line('request id is ' || gn_request_id);
                    COMMIT;
                EXCEPTION
                    WHEN OTHERS THEN
                        dbms_output.put_line('UPDATE ERROR IN HEADER'
                                             || sqlcode
                                             || '-'
                                             || sqlerrm);
                END;

            END LOOP;

            EXIT WHEN so_data_hdr.count = 0;
        END LOOP;

        CLOSE cur_so_header;
        dbms_output.put_line('exit hua header and line k validation say');
    END xxawr_staging_validation;

    PROCEDURE main_prg (
        p_errbuff     OUT VARCHAR2,
        p_retcode     OUT VARCHAR2,
        p_action_type IN VARCHAR2
       -- p_interface_id IN NUMBER
    ) IS
    BEGIN
    XXAWR_HARDCODE_VALUE;
      XXAWR_SALES_ORDER_PACKAGE_AWR.xxawr_insert_custom_data_awr(12,
       XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_IN_AWR,
       XXAWR_SALES_ORDER_PACKAGE_AWR.SO_CREATE_OUT_AWR,
       XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_in,
       XXAWR_SALES_ORDER_PACKAGE_AWR.so_line_out);     

        xxawr_staging_validation;
        IF p_action_type = 'CREATE' THEN
            sales_order_creation;
        END IF;
        IF p_action_type = 'CREATE AND BOOK' THEN
            sales_order_creation;
            booking_sales_order;
        END IF;
        IF p_action_type = 'CANCEL' THEN
            sales_order_cancel;
        END IF;
        IF p_action_type = 'UPDATE LINE QUANTITY' THEN
            UPDATE_LINE_QUANTITY;
        END IF;
        
        
    END main_prg;

END XXAWR_SALES_ORDER_PACKAGE_AWR;