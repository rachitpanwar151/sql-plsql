/* Formatted on 4/27/2024 3:19:15 PM (QP5 v5.163.1008.3004) */
CREATE OR REPLACE PACKAGE BODY XXAWR_SO_SF_OIC_PKG
AS
   /*******************************************************************************************************************
    * $Header         : @(#)
    * Program Name    : XXAWR_SO_SF_OIC_PKG11.PKB
    * Language        : PL/SQL
    * Description     :
    *
    * History         :
    *
    * WHO              WHAT                                                                  WHEN
    * --------------   -------------------------------------------------                  -----------
    *                    1.0 - AWR SALES ORDER                                               2024
    ***********************************************************************/


   PROCEDURE print_log (p_error_msg IN VARCHAR2)
   IS
   BEGIN
      IF g_debug_flag = 'Y'
      THEN
         DBMS_OUTPUT.PUT_LINE (p_error_msg);
      END IF;
   END PRINT_LOG;



   PROCEDURE data_wrapping (IN_P_OIC_INSTANCE_ID IN VARCHAR2)
   IS
   BEGIN
      --update line
      UPDATE xxaac.xxawr_so_lines_stg stg_ln
         SET STATUS = 'E',
             ERROR_MSG = ERROR_MSG || '-' || 'Header Level Error'
       WHERE EXISTS
                (SELECT 1
                   FROM xxaac.xxawr_so_header_stg stg
                  WHERE STATUS = 'E'
                        AND stg.OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID);


      --Update delivery

      UPDATE xxaac.xxawr_so_delvy_instr_stg stg_ln
         SET STATUS = 'E',
             ERROR_MSG = ERROR_MSG || '-' || 'Header Level Error'
       WHERE EXISTS
                (SELECT 1
                   FROM xxaac.xxawr_so_header_stg stg
                  WHERE STATUS = 'E'
                        AND stg.OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID);



      UPDATE xxaac.xxawr_so_lines_stg stg_ln
         SET STATUS = 'E',
             ERROR_MSG = ERROR_MSG || '-' || 'Delivery Level Error'
       WHERE EXISTS
                (SELECT 1
                   FROM xxaac.xxawr_so_delvy_instr_stg stg
                  WHERE STATUS = 'E'
                        AND stg.OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID);

      UPDATE xxaac.xxawr_so_header_stg stg_hdr
         SET STATUS = 'E',
             ERROR_MSG = ERROR_MSG || '-' || 'Delivery Level Error'
       WHERE EXISTS
                (SELECT 1
                   FROM xxaac.xxawr_so_delvy_instr_stg stg
                  WHERE STATUS = 'E'
                        AND stg.OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID);


      UPDATE xxaac.xxawr_so_delvy_instr_stg stg_ln
         SET STATUS = 'E', ERROR_MSG = ERROR_MSG || '-' || 'Line Level Error'
       WHERE EXISTS
                (SELECT 1
                   FROM xxaac.xxawr_so_lines_stg stg
                  WHERE STATUS = 'E'
                        AND stg.OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID);

      UPDATE xxaac.xxawr_so_header_stg stg_hdr
         SET STATUS = 'E', ERROR_MSG = ERROR_MSG || '-' || 'Line Level Error'
       WHERE EXISTS
                (SELECT 1
                   FROM xxaac.xxawr_so_lines_stg stg
                  WHERE STATUS = 'E'
                        AND stg.OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID);
   END data_wrapping;


   /***********************************************************
    * Program Name   : update_stg_sts_msg
    * Language       : PL/SQL
    * Description    : Procedure OF main
    * History        :
    * WHO              WHAT                                                          WHEN
    * --------------   -------------------------------------------------------       --------------
    *                    Procedure OF update_stg_sts_msg                                     2024
    *******************************************************************************************************************/
   PROCEDURE update_table (in_p_oic_instance_id   IN VARCHAR2,
                           in_p_status            IN VARCHAR2,
                           in_p_error_msg         IN VARCHAR2,
                           in_header_id           IN NUMBER,
                           in_line_id             IN NUMBER,
                           in_delvy_id            IN NUMBER,
                           in_staging_name        IN VARCHAR2)
   IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        --> variable declaration
        l_error_msg VARCHAR2(100);
   BEGIN
      /* Update xxawr_so_header_stg1 Table */

      UPDATE xxaac.xxawr_so_header_stg
         SET status = in_p_status, error_msg = in_p_error_msg
       WHERE oic_instance_id = in_p_oic_instance_id;



      /* Update xxawr_so_lines_stg1 Table */

      UPDATE xxaac.xxawr_so_lines_stg
         SET status = in_p_status, error_msg = in_p_error_msg
       WHERE oic_instance_id = in_p_oic_instance_id;



      /* Update xxawr_so_delvy_instr_intf1 Table */

      UPDATE xxaac.xxawr_so_delvy_instr_stg
         SET status = in_p_status, error_msg = in_p_error_msg
       WHERE oic_instance_id = in_p_oic_instance_id;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_error_msg :=
               'Error in Update Stagging Table Status/Message Process - '
            || SQLCODE
            || ' ~ '
            || SQLERRM;
            
        print_log (l_error_msg);
   END update_table;



   /*******************************************************************************************************************
   * Program Name   : DELETE_INTERFACE_DATA
   * Language       : PL/SQL
   * Description    : Procedure to delete data from Interface table
   * History        :
   * WHO              WHAT                                                          WHEN
   * --------------   -------------------------------------------------------       --------------
   *                    Procedure OF DELETE_INTERFACE_DATA                              2024
   *******************************************************************************************************************/


   PROCEDURE delete_interface_data (in_p_oic_instance_id IN VARCHAR2)
   IS
   BEGIN
      DELETE FROM xxaac.xxawr_so_header_intf
            WHERE oic_instance_id = in_p_oic_instance_id;

      DELETE FROM xxaac.xxawr_so_lines_intf
            WHERE oic_instance_id = in_p_oic_instance_id;

      DELETE FROM xxaac.xxawr_so_delvy_instr_intf
            WHERE oic_instance_id = in_p_oic_instance_id;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (
               'Main Error at DELETE_INTERFACE_DATA: '
            || SQLCODE
            || '-'
            || SQLERRM);
   END delete_interface_data;



   /*******************************************************************************************************************
     * Program Name   : SALES_ORDER_CANCEL
     * Language       : PL/SQL
     * Description    : Procedure To CANCEL Sales Order
     * History        :
     * WHO              WHAT                                                          WHEN
     * --------------   -------------------------------------------------------       --------------
     *                     Procedure To CANCEL Sales Order                                2024
     *******************************************************************************************************************/
   PROCEDURE SALES_ORDER_CANCEL (IN_P_OIC_INSTANCE_ID IN VARCHAR2)
   AS
      V_API_VERSION_NUMBER           NUMBER := 1;
      V_RETURN_STATUS                VARCHAR2 (2000);
      V_MSG_COUNT                    NUMBER;
      V_MSG_DATA                     VARCHAR2 (2000);

      -- IN Variables --
      V_HEADER_REC                   OE_ORDER_PUB.HEADER_REC_TYPE;
      V_LINE_TBL                     OE_ORDER_PUB.LINE_TBL_TYPE;
      V_ACTION_REQUEST_TBL           OE_ORDER_PUB.REQUEST_TBL_TYPE;
      V_LINE_ADJ_TBL                 OE_ORDER_PUB.LINE_ADJ_TBL_TYPE;

      -- OUT Variables --
      V_HEADER_REC_OUT               OE_ORDER_PUB.HEADER_REC_TYPE;
      V_HEADER_VAL_REC_OUT           OE_ORDER_PUB.HEADER_VAL_REC_TYPE;
      V_HEADER_ADJ_TBL_OUT           OE_ORDER_PUB.HEADER_ADJ_TBL_TYPE;
      V_HEADER_ADJ_VAL_TBL_OUT       OE_ORDER_PUB.HEADER_ADJ_VAL_TBL_TYPE;
      V_HEADER_PRICE_ATT_TBL_OUT     OE_ORDER_PUB.HEADER_PRICE_ATT_TBL_TYPE;
      V_HEADER_ADJ_ATT_TBL_OUT       OE_ORDER_PUB.HEADER_ADJ_ATT_TBL_TYPE;
      V_HEADER_ADJ_ASSOC_TBL_OUT     OE_ORDER_PUB.HEADER_ADJ_ASSOC_TBL_TYPE;
      V_HEADER_SCREDIT_TBL_OUT       OE_ORDER_PUB.HEADER_SCREDIT_TBL_TYPE;
      V_HEADER_SCREDIT_VAL_TBL_OUT   OE_ORDER_PUB.HEADER_SCREDIT_VAL_TBL_TYPE;
      V_LINE_TBL_OUT                 OE_ORDER_PUB.LINE_TBL_TYPE;
      V_LINE_VAL_TBL_OUT             OE_ORDER_PUB.LINE_VAL_TBL_TYPE;
      V_LINE_ADJ_TBL_OUT             OE_ORDER_PUB.LINE_ADJ_TBL_TYPE;
      V_LINE_ADJ_VAL_TBL_OUT         OE_ORDER_PUB.LINE_ADJ_VAL_TBL_TYPE;
      V_LINE_PRICE_ATT_TBL_OUT       OE_ORDER_PUB.LINE_PRICE_ATT_TBL_TYPE;
      V_LINE_ADJ_ATT_TBL_OUT         OE_ORDER_PUB.LINE_ADJ_ATT_TBL_TYPE;
      V_LINE_ADJ_ASSOC_TBL_OUT       OE_ORDER_PUB.LINE_ADJ_ASSOC_TBL_TYPE;
      V_LINE_SCREDIT_TBL_OUT         OE_ORDER_PUB.LINE_SCREDIT_TBL_TYPE;
      V_LINE_SCREDIT_VAL_TBL_OUT     OE_ORDER_PUB.LINE_SCREDIT_VAL_TBL_TYPE;
      V_LOT_SERIAL_TBL_OUT           OE_ORDER_PUB.LOT_SERIAL_TBL_TYPE;
      V_LOT_SERIAL_VAL_TBL_OUT       OE_ORDER_PUB.LOT_SERIAL_VAL_TBL_TYPE;
      V_ACTION_REQUEST_TBL_OUT       OE_ORDER_PUB.REQUEST_TBL_TYPE;
      V_MSG_INDEX                    NUMBER;
      V_DATA                         VARCHAR2 (2000);
      V_LOOP_COUNT                   NUMBER;
      V_DEBUG_FILE                   VARCHAR2 (200);
      B_RETURN_STATUS                VARCHAR2 (200);
      B_MSG_COUNT                    NUMBER;
      B_MSG_DATA                     VARCHAR2 (2000);
      L_resr_Id                      mtl_reservations.reservation_id%TYPE;
      l_rsv                          inv_reservation_global.mtl_reservation_rec_type;
      l_msg_count                    NUMBER;
      l_msg_data                     VARCHAR2 (240);
      l_rsv_id                       NUMBER;
      l_dummy_sn                     inv_reservation_global.serial_number_tbl_type;
      l_STATUS                       VARCHAR2 (1);
      x_return_STATUS                VARCHAR2 (1);
      x_msg_data                     VARCHAR2 (1000);
      L_count                        NUMBER;
      L_order_header_id              OE_ORDER_HEADERS_ALL.header_id%TYPE;
      L_order_line_id                OE_ORDER_lineS_ALL.line_id%TYPE;
      L_quantity_to_be_delivered     OE_ORDER_lineS_ALL.ordered_quantity%TYPE;


      CURSOR c_so_cancel
      IS
         SELECT oracle_order_header_id,
                oracle_order_line_id,
                quantity_to_be_delivered,
                stg_del_instr_id
           FROM xxaac.xxawr_so_header_stg STG_HD,
                xxaac.xxawr_so_delvy_instr_stg stg_del
          WHERE     1 = 1
                AND stg_del.STG_HEADER_ID = stg_hd.STG_HEADER_ID
                AND UPPER (stg_del.stg_del_instr_status) = 'BOOKED'
                AND stg_del.status = 'S'
                AND stg_hd.sf_order_id IN
                       (SELECT stg_hd1.sf_order_id
                          FROM xxaac.xxawr_so_lines_stg stg_ln1,
                               xxaac.xxawr_so_header_stg stg_HD1,
                               xxaac.xxawr_so_delvy_instr_stg stg_del1
                         WHERE 1 = 1
                               AND stg_del1.STG_HEADER_ID =
                                      stg_ln1.stg_header_id
                               AND stg_del1.STG_HEADER_ID =
                                      stg_hd1.STG_HEADER_ID
                               AND stg_ln1.STG_LINE_ID = stg_del1.STG_LINE_ID
                               AND UPPER (stg_del1.stg_del_instr_status) =
                                      'CANCELLED'
                               AND stg_del1.status = 'N'
                               AND stg_del1.oic_instance_id =
                                      IN_P_OIC_INSTANCE_ID
                               AND stg_del1.stg_del_instr_id =
                                      stg_del.stg_del_instr_id);

      TYPE c_so_cancel_type IS TABLE OF c_so_cancel%ROWTYPE
                                  INDEX BY PLS_INTEGER;

      R_SO_CANCEL                    c_so_cancel_type;
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('Starting of script CANCEL ORDER');

      --CANCEL PREVIOUS DRAFT SO
      UPDATE xxaac.xxawr_so_delvy_instr_stg stg_del
         SET status = 'S'
       WHERE     stg_del.stg_del_instr_status = 'CANCELLED'
             AND stg_del.OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
             AND stg_del.status = 'N'
             AND stg_del.stg_del_instr_id =
                    (SELECT stg_del1.stg_del_instr_id
                       FROM xxaac.xxawr_so_header_stg stg_hd1,
                            xxaac.xxawr_so_delvy_instr_stg stg_del1,
                            xxaac.xxawr_so_lines_stg stg_ln1
                      WHERE 1 = 1
                            AND stg_del1.STG_HEADER_ID =
                                   stg_ln1.stg_header_id
                            AND stg_del1.STG_HEADER_ID =
                                   stg_hd1.STG_HEADER_ID
                            AND stg_ln1.STG_LINE_ID = stg_del1.STG_LINE_ID
                            AND LOWER (stg_del1.stg_del_instr_status) =
                                   'draft'
                            AND EXISTS
                                   (SELECT 1
                                      FROM xxaac.xxawr_so_lines_stg stg_ln
                                     WHERE stg_del.STG_HEADER_ID =
                                              stg_ln.STG_HEADER_ID
                                           AND stg_ln.STG_LINE_ID =
                                                  stg_del.STG_LINE_ID
                                           AND UPPER (stg_ln.item_code) =
                                                  UPPER (stg_ln1.item_code)
                                           AND stg_ln.OIC_INSTANCE_ID =
                                                  in_p_oic_instance_id)
                            AND stg_hd1.sf_order_id =
                                   (SELECT sf_order_id
                                      FROM xxaac.xxawr_so_header_stg stg_hd
                                     WHERE stg_del.stg_header_id =
                                              stg_hd.stg_header_id
                                           AND stg_hd.OIC_INSTANCE_ID =
                                                  IN_P_OIC_INSTANCE_ID));

      --CANCEL PREVIOUS RESERVED SO (FIRST UNRESERVE RESERVED ORDER AND THEN UPDATE STATUS)
      BEGIN
         SELECT stg_del.RESERVATION_id
           INTO L_resr_Id
           FROM xxaac.xxawr_so_delvy_instr_stg stg_del
          WHERE status = 'S'
                AND UPPER (stg_del.stg_del_instr_status) = 'RESERVE'
                AND EXISTS
                       (SELECT 1
                          FROM xxaac.xxawr_so_header_stg stg_hd1,
                               xxaac.xxawr_so_delvy_instr_stg stg_del1,
                               xxaac.xxawr_so_lines_stg stg_ln1
                         WHERE 1 = 1
                               AND stg_del1.STG_HEADER_ID =
                                      stg_ln1.stg_header_id
                               AND stg_del1.STG_HEADER_ID =
                                      stg_hd1.STG_HEADER_ID
                               AND stg_ln1.STG_LINE_ID = stg_del1.STG_LINE_ID
                               AND EXISTS
                                      (SELECT 1
                                         FROM xxaac.xxawr_so_lines_stg stg_ln
                                        WHERE stg_del.STG_HEADER_ID =
                                                 stg_ln.STG_HEADER_ID
                                              AND stg_ln.STG_LINE_ID =
                                                     stg_del.STG_LINE_ID
                                              AND UPPER (stg_ln.item_code) =
                                                     UPPER (
                                                        stg_ln1.item_code)
                                              AND stg_ln.OIC_INSTANCE_ID =
                                                     stg_del.oic_instance_id)
                               AND stg_del.stg_del_instr_id =
                                      stg_del1.stg_del_instr_id
                               AND LOWER (stg_del1.stg_del_instr_status) =
                                      'cancelled'
                               AND stg_del1.oic_instance_id =
                                      in_p_oic_instance_id
                               AND stg_hd1.sf_order_id =
                                      (SELECT sf_order_id
                                         FROM xxaac.xxawr_so_header_stg stg_hd
                                        WHERE stg_del.stg_header_id =
                                                 stg_hd.stg_header_id
                                              AND stg_hd.OIC_INSTANCE_ID =
                                                     stg_del.oic_instance_id))
                AND EXISTS
                       (SELECT 1
                          FROM mtl_reservations
                         WHERE RESERVATiON_id = stg_del.RESERVATiON_id);

         l_rsv.reservation_id := L_resr_Id;
         inv_reservation_pub.delete_reservation (
            p_api_version_number   => 1.0,
            p_init_msg_lst         => fnd_api.g_true,
            x_return_STATUS        => l_STATUS,
            x_msg_count            => l_msg_count,
            x_msg_data             => l_msg_data,
            p_rsv_rec              => l_rsv,
            p_serial_number        => l_dummy_sn);

         IF l_STATUS = 'S'
         THEN
            DBMS_OUTPUT.PUT_LINE (
               'UNRESERVED Successful for RESERVATON ID :' || L_resr_Id);

            UPDATE xxaac.xxawr_so_delvy_instr_stg
               SET status = 'S'
             WHERE     UPPER (stg_del_instr_status) = 'CANCELLED'
                   AND status = 'N'
                   AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;
         ELSE
            UPDATE xxaac.xxawr_so_delvy_instr_stg
               SET status = l_STATUS, ERROR_MSG = l_msg_data
             WHERE     UPPER (stg_del_instr_status) = 'CANCELLED'
                   AND status = 'N'
                   AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;
         END IF;

         COMMIT;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.PUT_LINE (
               'NO REVIOUS RESERVATON HISTORY FOUND : ' || SQLERRM);
      END;

      --CANCEL LINES/SO HEADER
      OPEN C_SO_CANCEL;

      LOOP
         FETCH C_SO_CANCEL
         BULK COLLECT INTO R_SO_CANCEL
         LIMIT 50;

         FOR indx IN 1 .. R_SO_CANCEL.COUNT
         LOOP
            BEGIN
               SELECT COUNT (1)
                 INTO L_count
                 FROM oe_order_lines_all
                WHERE header_id = R_SO_CANCEL (indx).ORACLE_ORDER_HEADER_ID
                      AND UPPER (FLOW_STATUS_CODE) IN
                             ('AWAITING_SHIPPING', 'ENTERED');

               DBMS_OUTPUT.PUT_LINE (
                     'Line Count for Header ID: '
                  || R_SO_CANCEL (indx).ORACLE_ORDER_HEADER_ID
                  || ' - '
                  || L_COUNT);
               MO_GLOBAL.INIT ('ONT');
               FND_GLOBAL.APPS_INITIALIZE (g_user_id,
                                           g_resp_id1,
                                           g_resp_app_id1);
               MO_GLOBAL.SET_POLICY_CONTEXT ('S', G_ORG_ID);

               IF L_count = 1
               THEN
                  V_HEADER_REC := OE_ORDER_PUB.G_MISS_HEADER_REC;
                  V_HEADER_REC.OPERATION := OE_GLOBALS.G_OPR_UPDATE;
                  V_HEADER_REC.HEADER_ID :=
                     R_SO_CANCEL (indx).ORACLE_ORDER_HEADER_ID;
                  -- V_HEADER_REC.HEADER_ID := R_CANCEL (I).ORACLE_ORDER_HEADER_ID;
                  V_HEADER_REC.CANCELLED_FLAG := 'Y';
                  V_HEADER_REC.CHANGE_REASON := 'BUSINESS REQUIREMENT';
                  DBMS_OUTPUT.PUT_LINE ('Starting of API ORDER CANCEL');

                  -- CALLING THE API TO CANCEL AN ORDER --

                  OE_ORDER_PUB.PROCESS_ORDER (
                     P_API_VERSION_NUMBER       => V_API_VERSION_NUMBER,
                     P_HEADER_REC               => V_HEADER_REC,
                     P_LINE_TBL                 => V_LINE_TBL,
                     P_ACTION_REQUEST_TBL       => V_ACTION_REQUEST_TBL,
                     P_LINE_ADJ_TBL             => V_LINE_ADJ_TBL -- OUT variables
                                                                 ,
                     X_HEADER_REC               => V_HEADER_REC_OUT,
                     X_HEADER_VAL_REC           => V_HEADER_VAL_REC_OUT,
                     X_HEADER_ADJ_TBL           => V_HEADER_ADJ_TBL_OUT,
                     X_HEADER_ADJ_VAL_TBL       => V_HEADER_ADJ_VAL_TBL_OUT,
                     X_HEADER_PRICE_ATT_TBL     => V_HEADER_PRICE_ATT_TBL_OUT,
                     X_HEADER_ADJ_ATT_TBL       => V_HEADER_ADJ_ATT_TBL_OUT,
                     X_HEADER_ADJ_ASSOC_TBL     => V_HEADER_ADJ_ASSOC_TBL_OUT,
                     X_HEADER_SCREDIT_TBL       => V_HEADER_SCREDIT_TBL_OUT,
                     X_HEADER_SCREDIT_VAL_TBL   => V_HEADER_SCREDIT_VAL_TBL_OUT,
                     X_LINE_TBL                 => V_LINE_TBL_OUT,
                     X_LINE_VAL_TBL             => V_LINE_VAL_TBL_OUT,
                     X_LINE_ADJ_TBL             => V_LINE_ADJ_TBL_OUT,
                     X_LINE_ADJ_VAL_TBL         => V_LINE_ADJ_VAL_TBL_OUT,
                     X_LINE_PRICE_ATT_TBL       => V_LINE_PRICE_ATT_TBL_OUT,
                     X_LINE_ADJ_ATT_TBL         => V_LINE_ADJ_ATT_TBL_OUT,
                     X_LINE_ADJ_ASSOC_TBL       => V_LINE_ADJ_ASSOC_TBL_OUT,
                     X_LINE_SCREDIT_TBL         => V_LINE_SCREDIT_TBL_OUT,
                     X_LINE_SCREDIT_VAL_TBL     => V_LINE_SCREDIT_VAL_TBL_OUT,
                     X_LOT_SERIAL_TBL           => V_LOT_SERIAL_TBL_OUT,
                     X_LOT_SERIAL_VAL_TBL       => V_LOT_SERIAL_VAL_TBL_OUT,
                     X_ACTION_REQUEST_TBL       => V_ACTION_REQUEST_TBL_OUT,
                     X_RETURN_STATUS            => V_RETURN_STATUS,
                     X_MSG_COUNT                => V_MSG_COUNT,
                     X_MSG_DATA                 => V_MSG_DATA);

                  DBMS_OUTPUT.PUT_LINE ('Completion of API');

                  IF V_RETURN_STATUS = FND_API.G_RET_STS_SUCCESS
                  THEN
                     COMMIT;
                     DBMS_OUTPUT.PUT_LINE (
                        'Order Cancellation Success : '
                        || R_SO_CANCEL (indx).ORACLE_ORDER_HEADER_ID);



                     UPDATE xxaac.xxawr_so_delvy_instr_stg
                        SET status = 'S',
                            ORACLE_ORDER_HEADER_ID =
                               R_SO_CANCEL (indx).ORACLE_ORDER_HEADER_ID,
                            oracle_order_line_id =
                               R_SO_CANCEL (indx).ORACLE_ORDER_LINE_ID
                      WHERE     status = 'N'
                            AND UPPER (stg_del_instr_status) = 'CANCELLED'
                            AND oic_instance_id = in_p_oic_instance_id
                            AND STG_DEL_INSTR_ID =
                                   R_SO_CANCEL (indx).stg_del_instr_id;
                  ELSE
                     DBMS_OUTPUT.PUT_LINE (
                        'Order Cancellation failed : '
                        || V_HEADER_REC_OUT.HEADER_ID);

                     UPDATE xxaac.xxawr_so_delvy_instr_stg
                        SET status = 'E', ERROR_MSG = V_MSG_DATA
                      WHERE     status = 'N'
                            AND UPPER (stg_del_instr_status) = 'CANCELLED'
                            AND oic_instance_id = in_p_oic_instance_id
                            AND STG_DEL_INSTR_ID =
                                   R_SO_CANCEL (indx).stg_del_instr_id;
                  END IF;

                  COMMIT;
               ELSIF L_count > 1
               THEN
                  --CANCEL THAT SPECIFIC LINE/DELIVERY
                  v_action_request_tbl (1) := oe_order_pub.g_miss_request_rec;

                  -- Cancel a Line Record --
                  v_line_tbl (1) := oe_order_pub.g_miss_line_rec;
                  v_line_tbl (1).operation := oe_globals.g_opr_update;
                  v_line_tbl (1).header_id :=
                     R_SO_CANCEL (indx).ORACLE_ORDER_HEADER_ID;
                  v_line_tbl (1).line_id :=
                     R_SO_CANCEL (indx).ORACLE_ORDER_line_ID;
                  v_line_tbl (1).ordered_quantity :=
                     R_SO_CANCEL (indx).quantity_to_be_delivered;
                  v_line_tbl (1).cancelled_flag := 'Y';
                  v_line_tbl (1).change_reason := 'BUSINESS REQUIREMENT';
                  DBMS_OUTPUT.put_line ('Starting of API CANCEL ORDER LINE ');

                  -- Calling the API to cancel a line from an Existing Order --

                  oe_order_pub.process_order (
                     p_api_version_number       => v_api_version_number,
                     p_header_rec               => v_header_rec,
                     p_line_tbl                 => v_line_tbl,
                     p_action_request_tbl       => v_action_request_tbl,
                     p_line_adj_tbl             => v_line_adj_tbl -- OUT variables
                                                                 ,
                     x_header_rec               => v_header_rec_out,
                     x_header_val_rec           => v_header_val_rec_out,
                     x_header_adj_tbl           => v_header_adj_tbl_out,
                     x_header_adj_val_tbl       => v_header_adj_val_tbl_out,
                     x_header_price_att_tbl     => v_header_price_att_tbl_out,
                     x_header_adj_att_tbl       => v_header_adj_att_tbl_out,
                     x_header_adj_assoc_tbl     => v_header_adj_assoc_tbl_out,
                     x_header_scredit_tbl       => v_header_scredit_tbl_out,
                     x_header_scredit_val_tbl   => v_header_scredit_val_tbl_out,
                     x_line_tbl                 => v_line_tbl_out,
                     x_line_val_tbl             => v_line_val_tbl_out,
                     x_line_adj_tbl             => v_line_adj_tbl_out,
                     x_line_adj_val_tbl         => v_line_adj_val_tbl_out,
                     x_line_price_att_tbl       => v_line_price_att_tbl_out,
                     x_line_adj_att_tbl         => v_line_adj_att_tbl_out,
                     x_line_adj_assoc_tbl       => v_line_adj_assoc_tbl_out,
                     x_line_scredit_tbl         => v_line_scredit_tbl_out,
                     x_line_scredit_val_tbl     => v_line_scredit_val_tbl_out,
                     x_lot_serial_tbl           => v_lot_serial_tbl_out,
                     x_lot_serial_val_tbl       => v_lot_serial_val_tbl_out,
                     x_action_request_tbl       => v_action_request_tbl_out,
                     x_return_status            => v_return_status,
                     x_msg_count                => v_msg_count,
                     x_msg_data                 => v_msg_data);

                  IF V_RETURN_STATUS = FND_API.G_RET_STS_SUCCESS
                  THEN
                     COMMIT;
                     DBMS_OUTPUT.PUT_LINE (
                        'Order LINE Cancellation Success : '
                        || V_HEADER_REC_OUT.HEADER_ID);

                     UPDATE xxaac.xxawr_so_delvy_instr_stg
                        SET status = 'S',
                            ORACLE_ORDER_HEADER_ID =
                               R_SO_CANCEL (indx).ORACLE_ORDER_HEADER_ID,
                            oracle_order_line_id =
                               R_SO_CANCEL (indx).ORACLE_ORDER_LINE_ID
                      WHERE     status = 'N'
                            AND UPPER (stg_del_instr_status) = 'CANCELLED'
                            AND oic_instance_id = in_p_oic_instance_id
                            AND STG_DEL_INSTR_ID =
                                   R_SO_CANCEL (indx).stg_del_instr_id;
                  ELSE
                     DBMS_OUTPUT.PUT_LINE (
                        'Order Cancellation failed : '
                        || V_HEADER_REC_OUT.HEADER_ID);

                     UPDATE xxaac.xxawr_so_delvy_instr_stg
                        SET status = 'E', ERROR_MSG = V_MSG_DATA
                      WHERE     status = 'N'
                            AND UPPER (stg_del_instr_status) = 'CANCELLED'
                            AND oic_instance_id = in_p_oic_instance_id
                            AND STG_DEL_INSTR_ID =
                                   R_SO_CANCEL (indx).stg_del_instr_id;
                  END IF;

                  COMMIT;
                  DBMS_OUTPUT.PUT_LINE ('SO CANCEL Line Count : ' || L_count);
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  DBMS_OUTPUT.PUT_LINE (
                     'ERROR IN FETCHING PREVIOS SO DETAILS FOR CANCEL: '
                     || SQLERRM);
            END;
         END LOOP;

         EXIT WHEN R_SO_CANCEL.COUNT = 0;
      END LOOP;

      CLOSE c_so_cancel;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.PUT_LINE (
            'ERROR OCCURED IN CANCELLING SALES ORDER' || SQLCODE || SQLERRM);
   END SALES_ORDER_CANCEL;


   /*******************************************************************************************************************
      * Program Name   : UPDATE_ORDER_CREATE_DETAILS
      * Language       : PL/SQL
      * Description    : Procedure To UPDATE ORDER CREATION DETAILS INTO Staging Table
      * History        :
      * WHO              WHAT                                                          WHEN
      * --------------   -------------------------------------------------------       --------------
      *                   Update Data in order details in Staging Table                   2024
      *******************************************************************************************************************/
   PROCEDURE UPDATE_ORDER_CREATE_DETAILS (IN_SF_ORDER_ID         IN VARCHAR2,
                                          IN_P_HEADER_ID         IN NUMBER,
                                          IN_P_OIC_INSTANCE_ID   IN NUMBER)
   AS
      CURSOR C_LINE
      IS
         SELECT XSLS.STG_LINE_ID,
                XSDIS.RECORD_ID,
                XSDIS.stg_header_id,
                XSDIS.ORACLE_LINE_NUMBER,
                XSDIS.STG_DEL_INSTR_STATUS
           FROM xxaac.xxawr_so_lines_stg XSLS,
                xxaac.xxawr_so_delvy_instr_stg XSDIS
          WHERE     1 = 1
                AND XSLS.STATUS = 'V'
                AND XSLS.OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                AND XSLS.STG_HEADER_ID = XSDIS.STG_HEADER_ID
                AND XSLS.STG_LINE_ID = XSDIS.STG_LINE_ID;
   BEGIN
      /*****************************************************************************************
      PROCEDURE TO UPDATE ORDER NUMBER AND HEADER AND LINE ID AND ERRORS  ENCOUNTERED IN API
      *****************************************************************************************/
      BEGIN
         DBMS_OUTPUT.PUT_LINE ('STARTRED ORDER CREAT UPDATE DETAILS');


         UPDATE xxaac.xxawr_so_header_stg
            SET CUSTOMER_PO_NUM =
                   NVL (
                      (SELECT DISTINCT OE.ORDER_NUMBER
                         FROM OE_ORDER_HEADERS_ALL OE
                        WHERE OE.HEADER_ID = IN_P_HEADER_ID
                              AND OE.ORG_ID = G_ORG_ID),
                      0)
                   + NVL (LPO_NUMBER, 0),
                STATUS = 'P',
                CREATED_BY = g_user_id,
                LAST_UPDATED_BY = g_user_id,
                creation_date = SYSDATE,
                LAST_UPDATED_DATE = SYSDATE,
                LAST_LOGIN = g_user_id
          WHERE     1 = 1
                AND SF_ORDER_ID = IN_SF_ORDER_ID
                AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;

         COMMIT;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.PUT_LINE ('CANT UPDATE ALL DATA IN HEADER STAGING');
      END;


      FOR REC_LINE IN C_LINE
      LOOP
         BEGIN
            DBMS_OUTPUT.put_line (in_p_header_id);

            UPDATE xxaac.xxawr_so_delvy_instr_stg
               SET ORACLE_ORDER_HEADER_ID = IN_P_HEADER_ID,
                   ORACLE_ORDER_LINE_ID =
                      (SELECT LINE_ID
                         FROM OE_ORDER_LINES_ALL
                        WHERE 1 = 1
                              AND LINE_NUMBER = REC_LINE.ORACLE_LINE_NUMBER
                              AND ORACLE_LINE_NUMBER =
                                     REC_LINE.ORACLE_LINE_NUMBER
                              AND HEADER_ID = IN_P_HEADER_ID
                              AND ORG_ID = G_ORG_ID),
                   ORACLE_ORDER_NUMBER =
                      (SELECT DISTINCT OE.ORDER_NUMBER
                         FROM OE_ORDER_HEADERS_ALL OE
                        WHERE OE.HEADER_ID = IN_P_HEADER_ID
                              AND OE.ORG_ID = G_ORG_ID),
                   STATUS = 'P',
                   ORDER_LINE_STATUS =
                      (SELECT DISTINCT FLOW_STATUS_CODE
                         FROM OE_ORDER_LINES_ALL OE
                        WHERE     1 = 1
                              AND OE.HEADER_ID = IN_P_HEADER_ID
                              AND OE.ORG_ID = G_ORG_ID),
                   CREATED_BY = g_user_id,
                   LAST_UPDATED_BY = g_user_id,
                   CREATION_DATE = SYSDATE,
                   LAST_UPDATE_DATE = SYSDATE
             WHERE     STG_HEADER_ID = REC_LINE.stg_header_id
                   AND UPPER (REC_LINE.STG_DEL_INSTR_STATUS) = 'BOOKED'
                   AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;

            COMMIT;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.PUT_LINE ('CANT UPDATE ALL DATA IN LINE STAGING');
         END;
      END LOOP;
   END UPDATE_ORDER_CREATE_DETAILS;


   /*******************************************************************************************************************
      * Program Name   : UPDATE_BOOKING_DETAILS_STAG
      * Language       : PL/SQL
      * Description    : Procedure To UPDATE BOOKING DETAILS INTO Staging Table
      * History        :
      * WHO              WHAT                                                          WHEN
      * --------------   ---------------------------------------------------       --------------
      *                     UPDATE BOOKING DETAILS INTO STAGING TABLES                2024
      *******************************************************************************************************************/

   PROCEDURE UPDATE_BOOKING_DETAILS_STAG (IN_P_HEADER_ID         IN NUMBER,
                                          IN_P_OIC_INSTANCE_ID   IN NUMBER)
   AS
      CURSOR C_UPDATE_LINE
      IS
         SELECT DISTINCT *
           FROM xxaac.xxawr_so_delvy_instr_stg
          WHERE     1 = 1
                AND ORACLE_ORDER_HEADER_ID = IN_P_HEADER_ID
                AND UPPER (STG_DEL_INSTR_STATUS) = 'BOOKED'
                AND UPPER (STATUS) = 'S'
                AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;
   BEGIN
      DBMS_OUTPUT.PUT_LINE (
         'STARTED BOOKING UPDATE PROCESS ' || IN_P_HEADER_ID);


      FOR R_UPDATE_LINE IN C_UPDATE_LINE
      LOOP
         BEGIN
            UPDATE xxaac.xxawr_so_delvy_instr_stg ST2
               SET ST2.ORDER_LINE_STATUS =
                      (SELECT DISTINCT OE.FLOW_STATUS_CODE
                         FROM OE_ORDER_LINES_ALL OE
                        WHERE OE.HEADER_ID = IN_P_HEADER_ID
                              AND OE.ORG_ID = G_ORG_ID),
                   STATUS = 'S',
                   CREATED_BY = g_user_id,
                   LAST_UPDATED_BY = g_user_id,
                   CREATION_DATE = SYSDATE,
                   LAST_UPDATE_DATE = SYSDATE
             WHERE     ST2.ORACLE_ORDER_HEADER_ID = IN_P_HEADER_ID
                   AND UPPER (STG_DEL_INSTR_STATUS) IN ('BOOKED')
                   AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                   AND STG_LINE_ID = R_UPDATE_LINE.STG_LINE_ID;

            COMMIT;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.PUT_LINE (
                     ' CANNOT UPDATE BOOKING DETAILS IN LINE STAGING'
                  || SQLCODE
                  || SQLERRM);
         END;
      END LOOP;
   END UPDATE_BOOKING_DETAILS_STAG;



   /*******************************************************************************************************************
   * Program Name   : SALES_ORDER_BOOKING
   * Language       : PL/SQL
   * Description    : Procedure To book sales order
   * History        :
   * WHO              WHAT                                                          WHEN
   * --------------   -------------------------------------------------------       --------------
   *                        BOOKING SALES ORDER                                            2024
   *******************************************************************************************************************/
   PROCEDURE SALES_ORDER_BOOKING (IN_P_OIC_INSTANCE_ID   IN     VARCHAR2,
                                  IN_P_OE_HDR_ID         IN     VARCHAR2,
                                  OUT_P_STATUS              OUT VARCHAR2,
                                  OUT_P_ERR_MSG             OUT VARCHAR2)
   AS
      V_API_VERSION_NUMBER           NUMBER := 1;
      V_RETURN_STATUS                VARCHAR2 (2000);
      V_MSG_COUNT                    NUMBER;
      V_MSG_DATA                     VARCHAR2 (2000);

      -- IN Variables --
      V_HEADER_REC                   OE_ORDER_PUB.HEADER_REC_TYPE;
      V_LINE_TBL                     OE_ORDER_PUB.LINE_TBL_TYPE;
      V_ACTION_REQUEST_TBL           OE_ORDER_PUB.REQUEST_TBL_TYPE;
      V_LINE_ADJ_TBL                 OE_ORDER_PUB.LINE_ADJ_TBL_TYPE;

      -- OUT Variables --
      V_HEADER_REC_OUT               OE_ORDER_PUB.HEADER_REC_TYPE;
      V_HEADER_VAL_REC_OUT           OE_ORDER_PUB.HEADER_VAL_REC_TYPE;
      V_HEADER_ADJ_TBL_OUT           OE_ORDER_PUB.HEADER_ADJ_TBL_TYPE;
      V_HEADER_ADJ_VAL_TBL_OUT       OE_ORDER_PUB.HEADER_ADJ_VAL_TBL_TYPE;
      V_HEADER_PRICE_ATT_TBL_OUT     OE_ORDER_PUB.HEADER_PRICE_ATT_TBL_TYPE;
      V_HEADER_ADJ_ATT_TBL_OUT       OE_ORDER_PUB.HEADER_ADJ_ATT_TBL_TYPE;
      V_HEADER_ADJ_ASSOC_TBL_OUT     OE_ORDER_PUB.HEADER_ADJ_ASSOC_TBL_TYPE;
      V_HEADER_SCREDIT_TBL_OUT       OE_ORDER_PUB.HEADER_SCREDIT_TBL_TYPE;
      V_HEADER_SCREDIT_VAL_TBL_OUT   OE_ORDER_PUB.HEADER_SCREDIT_VAL_TBL_TYPE;
      V_LINE_TBL_OUT                 OE_ORDER_PUB.LINE_TBL_TYPE;
      V_LINE_VAL_TBL_OUT             OE_ORDER_PUB.LINE_VAL_TBL_TYPE;
      V_LINE_ADJ_TBL_OUT             OE_ORDER_PUB.LINE_ADJ_TBL_TYPE;
      V_LINE_ADJ_VAL_TBL_OUT         OE_ORDER_PUB.LINE_ADJ_VAL_TBL_TYPE;
      V_LINE_PRICE_ATT_TBL_OUT       OE_ORDER_PUB.LINE_PRICE_ATT_TBL_TYPE;
      V_LINE_ADJ_ATT_TBL_OUT         OE_ORDER_PUB.LINE_ADJ_ATT_TBL_TYPE;
      V_LINE_ADJ_ASSOC_TBL_OUT       OE_ORDER_PUB.LINE_ADJ_ASSOC_TBL_TYPE;
      V_LINE_SCREDIT_TBL_OUT         OE_ORDER_PUB.LINE_SCREDIT_TBL_TYPE;
      V_LINE_SCREDIT_VAL_TBL_OUT     OE_ORDER_PUB.LINE_SCREDIT_VAL_TBL_TYPE;
      V_LOT_SERIAL_TBL_OUT           OE_ORDER_PUB.LOT_SERIAL_TBL_TYPE;
      V_LOT_SERIAL_VAL_TBL_OUT       OE_ORDER_PUB.LOT_SERIAL_VAL_TBL_TYPE;
      V_ACTION_REQUEST_TBL_OUT       OE_ORDER_PUB.REQUEST_TBL_TYPE;

      L_HEADER_REC                   OE_ORDER_PUB.HEADER_REC_TYPE;
   BEGIN
      DBMS_OUTPUT.PUT_LINE (
         'Sales Order Booking Process Started. Header ID - '
         || IN_P_OE_HDR_ID);

      /*****************INITIALIZE ENVIRONMENT*************************************/

      FND_GLOBAL.APPS_INITIALIZE (g_user_id, g_resp_id1, g_resp_app_id1);
      MO_GLOBAL.INIT ('ONT');
      MO_GLOBAL.SET_POLICY_CONTEXT ('S', G_ORG_ID);

      /*****************INITIALIZE HEADER RECORD******************************/
      L_HEADER_REC := OE_ORDER_PUB.G_MISS_HEADER_REC;

      /***********POPULATE REQUIRED ATTRIBUTES **********************************/

      V_ACTION_REQUEST_TBL (1) := OE_ORDER_PUB.G_MISS_REQUEST_REC;
      V_ACTION_REQUEST_TBL (1).REQUEST_TYPE := OE_GLOBALS.G_BOOK_ORDER;
      V_ACTION_REQUEST_TBL (1).ENTITY_CODE := OE_GLOBALS.G_ENTITY_HEADER;
      V_ACTION_REQUEST_TBL (1).ENTITY_ID := IN_P_OE_HDR_ID;      --- header_id
      DBMS_OUTPUT.PUT_LINE ('Starting of API');
      OE_ORDER_PUB.PROCESS_ORDER (
         P_API_VERSION_NUMBER       => V_API_VERSION_NUMBER,
         P_HEADER_REC               => V_HEADER_REC,
         P_LINE_TBL                 => V_LINE_TBL,
         P_ACTION_REQUEST_TBL       => V_ACTION_REQUEST_TBL   -- OUT variables
                                                           ,
         P_LINE_ADJ_TBL             => V_LINE_ADJ_TBL,
         X_HEADER_REC               => V_HEADER_REC_OUT,
         X_HEADER_VAL_REC           => V_HEADER_VAL_REC_OUT,
         X_HEADER_ADJ_TBL           => V_HEADER_ADJ_TBL_OUT,
         X_HEADER_ADJ_VAL_TBL       => V_HEADER_ADJ_VAL_TBL_OUT,
         X_HEADER_PRICE_ATT_TBL     => V_HEADER_PRICE_ATT_TBL_OUT,
         X_HEADER_ADJ_ATT_TBL       => V_HEADER_ADJ_ATT_TBL_OUT,
         X_HEADER_ADJ_ASSOC_TBL     => V_HEADER_ADJ_ASSOC_TBL_OUT,
         X_HEADER_SCREDIT_TBL       => V_HEADER_SCREDIT_TBL_OUT,
         X_HEADER_SCREDIT_VAL_TBL   => V_HEADER_SCREDIT_VAL_TBL_OUT,
         X_LINE_TBL                 => V_LINE_TBL_OUT,
         X_LINE_VAL_TBL             => V_LINE_VAL_TBL_OUT,
         X_LINE_ADJ_TBL             => V_LINE_ADJ_TBL_OUT,
         X_LINE_ADJ_VAL_TBL         => V_LINE_ADJ_VAL_TBL_OUT,
         X_LINE_PRICE_ATT_TBL       => V_LINE_PRICE_ATT_TBL_OUT,
         X_LINE_ADJ_ATT_TBL         => V_LINE_ADJ_ATT_TBL_OUT,
         X_LINE_ADJ_ASSOC_TBL       => V_LINE_ADJ_ASSOC_TBL_OUT,
         X_LINE_SCREDIT_TBL         => V_LINE_SCREDIT_TBL_OUT,
         X_LINE_SCREDIT_VAL_TBL     => V_LINE_SCREDIT_VAL_TBL_OUT,
         X_LOT_SERIAL_TBL           => V_LOT_SERIAL_TBL_OUT,
         X_LOT_SERIAL_VAL_TBL       => V_LOT_SERIAL_VAL_TBL_OUT,
         X_ACTION_REQUEST_TBL       => V_ACTION_REQUEST_TBL_OUT,
         X_RETURN_STATUS            => V_RETURN_STATUS,
         X_MSG_COUNT                => V_MSG_COUNT,
         X_MSG_DATA                 => V_MSG_DATA);


      IF V_RETURN_STATUS = FND_API.G_RET_STS_SUCCESS
      THEN
         COMMIT;
         DBMS_OUTPUT.PUT_LINE (
            'Booking of an Existing Order is Success: ' || V_RETURN_STATUS);
         OUT_P_STATUS := V_RETURN_STATUS;
         OUT_P_ERR_MSG := NULL;
      ELSE
         DBMS_OUTPUT.PUT_LINE (
               'Booking of an Existing Order failed:'
            || V_RETURN_STATUS
            || ' ~ '
            || V_MSG_DATA);
         OUT_P_STATUS := V_RETURN_STATUS;

         FOR I IN 1 .. V_MSG_COUNT
         LOOP
            V_MSG_DATA := OE_MSG_PUB.GET (P_MSG_INDEX => I, P_ENCODED => 'F');
         END LOOP;

         OUT_P_ERR_MSG := V_MSG_DATA;
         ROLLBACK;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.PUT_LINE (
               'Error in Sales Order Booking process: '
            || SQLCODE
            || ' ~ '
            || SQLERRM);
   END SALES_ORDER_BOOKING;



   /*******************************************************************************************************************
   * Program Name   :
   * Language       : PL/SQL
   * Description    : Procedure To Create Sales Order
   * History        :
   * WHO              WHAT                                                          WHEN
   * --------------   -------------------------------------------------------       --------------
   *                    Procedure To Create Sales Order                                 2024
   *******************************************************************************************************************/

   PROCEDURE SALES_ORDER_CREATION (IN_P_OIC_INSTANCE_ID IN VARCHAR2)
   IS
      /**********PROCEDURE FOR SALES ORDER CREATION ******************/
      L_RETURN_STATUS                VARCHAR2 (1000);
      L_MSG_COUNT                    NUMBER;
      L_MSG_DATA                     VARCHAR2 (1000);
      P_API_VERSION_NUMBER           NUMBER := 1.0;
      P_INIT_MSG_LIST                VARCHAR2 (10) := FND_API.G_FALSE;
      P_RETURN_VALUES                VARCHAR2 (10) := FND_API.G_FALSE;
      P_ACTION_COMMIT                VARCHAR2 (10) := FND_API.G_FALSE;
      X_RETURN_STATUS                VARCHAR2 (1);
      X_MSG_COUNT                    NUMBER;
      X_MSG_DATA                     VARCHAR2 (100);
      L_HEADER_REC                   OE_ORDER_PUB.HEADER_REC_TYPE;
      L_LINE_TBL                     OE_ORDER_PUB.LINE_TBL_TYPE;
      L_ACTION_REQUEST_TBL           OE_ORDER_PUB.REQUEST_TBL_TYPE;
      L_HEADER_ADJ_TBL               OE_ORDER_PUB.HEADER_ADJ_TBL_TYPE;
      L_LINE_ADJ_TBL                 OE_ORDER_PUB.LINE_ADJ_TBL_TYPE;
      L_HEADER_SCR_TBL               OE_ORDER_PUB.HEADER_SCREDIT_TBL_TYPE;
      L_LINE_SCREDIT_TBL             OE_ORDER_PUB.LINE_SCREDIT_TBL_TYPE;
      L_REQUEST_REC                  OE_ORDER_PUB.REQUEST_REC_TYPE;
      X_HEADER_REC                   OE_ORDER_PUB.HEADER_REC_TYPE
                                        := OE_ORDER_PUB.G_MISS_HEADER_REC;
      P_OLD_HEADER_REC               OE_ORDER_PUB.HEADER_REC_TYPE
                                        := OE_ORDER_PUB.G_MISS_HEADER_REC;
      P_HEADER_VAL_REC               OE_ORDER_PUB.HEADER_VAL_REC_TYPE
                                        := OE_ORDER_PUB.G_MISS_HEADER_VAL_REC;
      P_OLD_HEADER_VAL_REC           OE_ORDER_PUB.HEADER_VAL_REC_TYPE
                                        := OE_ORDER_PUB.G_MISS_HEADER_VAL_REC;
      P_HEADER_ADJ_TBL               OE_ORDER_PUB.HEADER_ADJ_TBL_TYPE
                                        := OE_ORDER_PUB.G_MISS_HEADER_ADJ_TBL;
      P_OLD_HEADER_ADJ_TBL           OE_ORDER_PUB.HEADER_ADJ_TBL_TYPE
                                        := OE_ORDER_PUB.G_MISS_HEADER_ADJ_TBL;
      P_HEADER_ADJ_VAL_TBL           OE_ORDER_PUB.HEADER_ADJ_VAL_TBL_TYPE
                                        := OE_ORDER_PUB.G_MISS_HEADER_ADJ_VAL_TBL;
      P_OLD_HEADER_ADJ_VAL_TBL       OE_ORDER_PUB.HEADER_ADJ_VAL_TBL_TYPE
                                        := OE_ORDER_PUB.G_MISS_HEADER_ADJ_VAL_TBL;
      P_HEADER_PRICE_ATT_TBL         OE_ORDER_PUB.HEADER_PRICE_ATT_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_HEADER_PRICE_ATT_TBL;
      P_OLD_HEADER_PRICE_ATT_TBL     OE_ORDER_PUB.HEADER_PRICE_ATT_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_HEADER_PRICE_ATT_TBL;
      P_HEADER_ADJ_ATT_TBL           OE_ORDER_PUB.HEADER_ADJ_ATT_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_HEADER_ADJ_ATT_TBL;
      P_OLD_HEADER_ADJ_ATT_TBL       OE_ORDER_PUB.HEADER_ADJ_ATT_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_HEADER_ADJ_ATT_TBL;
      P_HEADER_ADJ_ASSOC_TBL         OE_ORDER_PUB.HEADER_ADJ_ASSOC_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_HEADER_ADJ_ASSOC_TBL;
      P_OLD_HEADER_ADJ_ASSOC_TBL     OE_ORDER_PUB.HEADER_ADJ_ASSOC_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_HEADER_ADJ_ASSOC_TBL;
      P_HEADER_SCREDIT_TBL           OE_ORDER_PUB.HEADER_SCREDIT_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_HEADER_SCREDIT_TBL;
      P_OLD_HEADER_SCREDIT_TBL       OE_ORDER_PUB.HEADER_SCREDIT_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_HEADER_SCREDIT_TBL;
      P_HEADER_SCREDIT_VAL_TBL       OE_ORDER_PUB.HEADER_SCREDIT_VAL_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_HEADER_SCREDIT_VAL_TBL;
      P_OLD_HEADER_SCREDIT_VAL_TBL   OE_ORDER_PUB.HEADER_SCREDIT_VAL_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_HEADER_SCREDIT_VAL_TBL;
      X_LINE_VAL_TBL                 OE_ORDER_PUB.LINE_VAL_TBL_TYPE;
      X_LINE_ADJ_TBL                 OE_ORDER_PUB.LINE_ADJ_TBL_TYPE;
      X_LINE_ADJ_VAL_TBL             OE_ORDER_PUB.LINE_ADJ_VAL_TBL_TYPE;
      X_LINE_PRICE_ATT_TBL           OE_ORDER_PUB.LINE_PRICE_ATT_TBL_TYPE;
      X_LINE_ADJ_ATT_TBL             OE_ORDER_PUB.LINE_ADJ_ATT_TBL_TYPE;
      X_LINE_ADJ_ASSOC_TBL           OE_ORDER_PUB.LINE_ADJ_ASSOC_TBL_TYPE;
      X_LINE_SCREDIT_TBL             OE_ORDER_PUB.LINE_SCREDIT_TBL_TYPE;
      X_LINE_SCREDIT_VAL_TBL         OE_ORDER_PUB.LINE_SCREDIT_VAL_TBL_TYPE;
      X_LOT_SERIAL_TBL               OE_ORDER_PUB.LOT_SERIAL_TBL_TYPE;
      X_LOT_SERIAL_VAL_TBL           OE_ORDER_PUB.LOT_SERIAL_VAL_TBL_TYPE;
      X_ACTION_REQUEST_TBL           OE_ORDER_PUB.REQUEST_TBL_TYPE;
      P_LINE_TBL                     OE_ORDER_PUB.LINE_TBL_TYPE
                                        := OE_ORDER_PUB.G_MISS_LINE_TBL;
      P_OLD_LINE_TBL                 OE_ORDER_PUB.LINE_TBL_TYPE
                                        := OE_ORDER_PUB.G_MISS_LINE_TBL;
      P_LINE_VAL_TBL                 OE_ORDER_PUB.LINE_VAL_TBL_TYPE
                                        := OE_ORDER_PUB.G_MISS_LINE_VAL_TBL;
      P_OLD_LINE_VAL_TBL             OE_ORDER_PUB.LINE_VAL_TBL_TYPE
                                        := OE_ORDER_PUB.G_MISS_LINE_VAL_TBL;
      P_LINE_ADJ_TBL                 OE_ORDER_PUB.LINE_ADJ_TBL_TYPE
                                        := OE_ORDER_PUB.G_MISS_LINE_ADJ_TBL;
      P_OLD_LINE_ADJ_TBL             OE_ORDER_PUB.LINE_ADJ_TBL_TYPE
                                        := OE_ORDER_PUB.G_MISS_LINE_ADJ_TBL;
      P_LINE_ADJ_VAL_TBL             OE_ORDER_PUB.LINE_ADJ_VAL_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_LINE_ADJ_VAL_TBL;
      P_OLD_LINE_ADJ_VAL_TBL         OE_ORDER_PUB.LINE_ADJ_VAL_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_LINE_ADJ_VAL_TBL;
      P_LINE_PRICE_ATT_TBL           OE_ORDER_PUB.LINE_PRICE_ATT_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_LINE_PRICE_ATT_TBL;
      P_OLD_LINE_PRICE_ATT_TBL       OE_ORDER_PUB.LINE_PRICE_ATT_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_LINE_PRICE_ATT_TBL;
      P_LINE_ADJ_ATT_TBL             OE_ORDER_PUB.LINE_ADJ_ATT_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_LINE_ADJ_ATT_TBL;
      P_OLD_LINE_ADJ_ATT_TBL         OE_ORDER_PUB.LINE_ADJ_ATT_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_LINE_ADJ_ATT_TBL;
      P_LINE_ADJ_ASSOC_TBL           OE_ORDER_PUB.LINE_ADJ_ASSOC_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_LINE_ADJ_ASSOC_TBL;
      P_OLD_LINE_ADJ_ASSOC_TBL       OE_ORDER_PUB.LINE_ADJ_ASSOC_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_LINE_ADJ_ASSOC_TBL;
      P_LINE_SCREDIT_TBL             OE_ORDER_PUB.LINE_SCREDIT_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_LINE_SCREDIT_TBL;
      P_OLD_LINE_SCREDIT_TBL         OE_ORDER_PUB.LINE_SCREDIT_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_LINE_SCREDIT_TBL;
      P_LINE_SCREDIT_VAL_TBL         OE_ORDER_PUB.LINE_SCREDIT_VAL_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_LINE_SCREDIT_VAL_TBL;
      P_OLD_LINE_SCREDIT_VAL_TBL     OE_ORDER_PUB.LINE_SCREDIT_VAL_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_LINE_SCREDIT_VAL_TBL;
      P_LOT_SERIAL_TBL               OE_ORDER_PUB.LOT_SERIAL_TBL_TYPE
                                        := OE_ORDER_PUB.G_MISS_LOT_SERIAL_TBL;
      P_OLD_LOT_SERIAL_TBL           OE_ORDER_PUB.LOT_SERIAL_TBL_TYPE
                                        := OE_ORDER_PUB.G_MISS_LOT_SERIAL_TBL;
      P_LOT_SERIAL_VAL_TBL           OE_ORDER_PUB.LOT_SERIAL_VAL_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_LOT_SERIAL_VAL_TBL;
      P_OLD_LOT_SERIAL_VAL_TBL       OE_ORDER_PUB.LOT_SERIAL_VAL_TBL_TYPE
         := OE_ORDER_PUB.G_MISS_LOT_SERIAL_VAL_TBL;
      P_ACTION_REQUEST_TBL           OE_ORDER_PUB.REQUEST_TBL_TYPE
                                        := OE_ORDER_PUB.G_MISS_REQUEST_TBL;
      X_HEADER_VAL_REC               OE_ORDER_PUB.HEADER_VAL_REC_TYPE;
      X_HEADER_ADJ_TBL               OE_ORDER_PUB.HEADER_ADJ_TBL_TYPE;
      X_HEADER_ADJ_VAL_TBL           OE_ORDER_PUB.HEADER_ADJ_VAL_TBL_TYPE;
      X_HEADER_PRICE_ATT_TBL         OE_ORDER_PUB.HEADER_PRICE_ATT_TBL_TYPE;
      X_HEADER_ADJ_ATT_TBL           OE_ORDER_PUB.HEADER_ADJ_ATT_TBL_TYPE;
      X_HEADER_ADJ_ASSOC_TBL         OE_ORDER_PUB.HEADER_ADJ_ASSOC_TBL_TYPE;
      X_HEADER_SCREDIT_TBL           OE_ORDER_PUB.HEADER_SCREDIT_TBL_TYPE;
      X_HEADER_SCREDIT_VAL_TBL       OE_ORDER_PUB.HEADER_SCREDIT_VAL_TBL_TYPE;
      X_DEBUG_FILE                   VARCHAR2 (100);
      L_LINE_TBL_INDEX               NUMBER := 0;
      L_MSG_INDEX_OUT                NUMBER (10);
      L_API_ERROR_MESSAGE            VARCHAR2 (2000);

      L_STATUS                       VARCHAR2 (1);
      L_err_msg                      VARCHAR2 (1000);

      CURSOR C_HEADER
      IS
         SELECT DISTINCT *
           FROM xxaac.xxawr_so_header_stg stg_hd1
          WHERE     1 = 1
                AND STATUS = 'V'
                AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;



      CURSOR C_LINES (
         IN_STG_HEADER_ID NUMBER)
      IS
         SELECT XSDIS.quantity_to_be_delivered,
                XSLS.ITEM_ID,
                XSLS.SF_LINE_ID,
                XSLS.SHIP_FROM_ORG_ID,
                XSDIS.stg_del_instr_id,
                XSDIS.RECORD_ID,
                XSLS.STG_LINE_ID,
                xsls.LINE_VAT_AMOUNT,
                xsls.LPO_NUMBER,
                XSDIS.SF_LINE_NUM,
                XSDIS.schedule_ship_date,
                XSLS.unit_selling_price,
                xsls.discount
           FROM xxaac.xxawr_so_lines_stg XSLS,
                xxaac.xxawr_so_delvy_instr_stg XSDIS
          WHERE 1 = 1 AND UPPER (XSLS.STATUS) IN ('V', 'S')
                --                and upper(decode('N','UNRESERVED','UNRESERVED'))
                --                and upper(nvl(XSDIS.status,'UNRESERVED'))='UNRESERVED'
                AND UPPER (XSDIS.STG_DEL_INSTR_STATUS) IN
                       ('UNRESERVE', 'BOOKED')
                AND XSLS.STG_HEADER_ID = XSDIS.STG_HEADER_ID
                AND XSLS.STG_LINE_ID = XSDIS.STG_LINE_ID
                AND XSLS.STG_HEADER_ID = IN_STG_HEADER_ID
                AND XSLS.OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                AND EXISTS
                       (SELECT NVL (
                                  (SELECT 1
                                     FROM xxaac.xxawr_so_delvy_instr_stg XSDIS1
                                    WHERE XSDIS1.STG_DEL_INSTR_ID =
                                             XSDIS.STG_DEL_INSTR_ID
                                          AND UPPER (
                                                 XSDIS.STG_DEL_INSTR_STATUS) =
                                                 'DRAFT'),
                                  1)
                          FROM DUAL);
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('Api Calling  SO CREATION -1');

      DBMS_OUTPUT.put_line (
            'App Initialization: '
         || g_user_id
         || '-'
         || g_resp_id1
         || '-'
         || g_resp_app_id1);
     


      FOR REC_HEADER IN C_HEADER
      LOOP
         DBMS_OUTPUT.PUT_LINE (' INSIDE CREATE    ');
		 
		  FND_GLOBAL.APPS_INITIALIZE (REC_HEADER.CREATED_BY, g_resp_id1, g_resp_app_id1);
      MO_GLOBAL.INIT ('ONT');
      MO_GLOBAL.SET_POLICY_CONTEXT ('S', G_ORG_ID);


         L_API_ERROR_MESSAGE := '';
         L_RETURN_STATUS := '';
         L_HEADER_REC := OE_ORDER_PUB.G_MISS_HEADER_REC;
         L_HEADER_REC.OPERATION := OE_GLOBALS.G_OPR_CREATE;



         L_HEADER_REC.TRANSACTIONAL_CURR_CODE :=
            REC_HEADER.TRANSACTIONAL_CURR_CODE;
         L_HEADER_REC.PRICING_DATE := SYSDATE;
         L_HEADER_REC.SOLD_TO_ORG_ID := REC_HEADER.CUSTOMER_ID;
         --                l_header_rec.ship_to_org_id := REC_HEADER.ship_from_org_id;
         L_HEADER_REC.PRICE_LIST_ID := REC_HEADER.PRICE_LIST_ID;
         L_HEADER_REC.ORDERED_DATE := SYSDATE;     -- REC_HEADER.ORDERED_DATE;
         L_HEADER_REC.SOLD_FROM_ORG_ID := G_ORG_ID;
         L_HEADER_REC.SALESREP_ID := REC_HEADER.SALESREP_ID;
         L_HEADER_REC.ORDER_TYPE_ID := REC_HEADER.ORDERED_TYPE_ID;     --2214;
         L_HEADER_REC.ATTRIBUTE1 := REC_HEADER.SF_ORDER_ID;
         L_HEADER_REC.ATTRIBUTE2 := REC_HEADER.LPO_NUMBER;
         -- L_HEADER_REC.TAX_VALUE := REC_HEADER.LINE_VAT_AMOUNT;
         L_HEADER_REC.PAYMENT_TERM_ID := REC_HEADER.PAYMENT_TERM_ID;


         --P_HEADER_REC.freight_carrier_code:=


         FOR REC_LINE IN C_LINES (REC_HEADER.STG_HEADER_ID)
         LOOP
            L_LINE_TBL_INDEX := L_LINE_TBL_INDEX + 1;
            DBMS_OUTPUT.PUT_LINE ('Line count' || L_LINE_TBL_INDEX);


            BEGIN
               UPDATE xxaac.xxawr_so_delvy_instr_stg
                  SET ORACLE_LINE_NUMBER = L_LINE_TBL_INDEX
                WHERE STATUS = 'N'        --AND RECORD_ID = REC_LINE.RECORD_ID
                                  ;

               COMMIT;
            EXCEPTION
               WHEN OTHERS
               THEN
                  DBMS_OUTPUT.PUT_LINE (
                        'ERROR OCCURED TO UPDATE LINE NUMBER IN STAGING'
                     || SQLCODE
                     || SQLERRM);
            END;



            BEGIN
               UPDATE xxaac.xxawr_so_lines_stg
                  SET ORACLE_LINE_NUMBER = L_LINE_TBL_INDEX
                WHERE STATUS = 'V' AND STG_LINE_ID = REC_LINE.STG_LINE_ID;

               COMMIT;
            EXCEPTION
               WHEN OTHERS
               THEN
                  DBMS_OUTPUT.PUT_LINE (
                        'ERROR OCCURED TO UPDATE LINE NUMBER IN STAGING'
                     || SQLCODE
                     || SQLERRM);
            END;



            L_LINE_TBL (L_LINE_TBL_INDEX) := OE_ORDER_PUB.G_MISS_LINE_REC;
            L_LINE_TBL (L_LINE_TBL_INDEX).OPERATION := OE_GLOBALS.G_OPR_CREATE;

            L_LINE_TBL (L_LINE_TBL_INDEX).ORDERED_QUANTITY :=
               REC_LINE.quantity_to_be_delivered;
            L_LINE_TBL (L_LINE_TBL_INDEX).SHIP_FROM_ORG_ID :=
               REC_LINE.SHIP_FROM_ORG_ID;
            L_LINE_TBL (L_LINE_TBL_INDEX).INVENTORY_ITEM_ID :=
               REC_LINE.ITEM_ID;
            L_LINE_TBL (L_LINE_TBL_INDEX).ATTRIBUTE1 :=
               REC_LINE.stg_del_instr_id;
            L_LINE_TBL (L_LINE_TBL_INDEX).ATTRIBUTE2 := REC_LINE.SF_LINE_NUM;
            L_LINE_TBL (L_LINE_TBL_INDEX).schedule_ship_date :=
               REC_LINE.schedule_ship_date;
            L_LINE_TBL (L_LINE_TBL_INDEX).CALCULATE_PRICE_FLAG := 'N';
            L_LINE_TBL (L_LINE_TBL_INDEX).TAX_VALUE :=
               REC_LINE.LINE_VAT_AMOUNT;                   --Adding VAT Amount
            L_LINE_TBL (L_LINE_TBL_INDEX).unit_selling_price :=
               REC_LINE.unit_selling_price;
            L_LINE_TBL (L_LINE_TBL_INDEX).unit_list_price :=
               REC_LINE.unit_selling_price;         --Added Unit Selling Price
         --  p_Line_Adj_val_tbl.discount:= REC_LINE.discount;  --- for line discount Amount

         END LOOP;                                            -- end line loop

         l_action_request_tbl (1) := OE_ORDER_PUB.G_MISS_REQUEST_REC;
         l_action_request_tbl (1).REQUEST_TYPE := OE_GLOBALS.G_BOOK_ORDER;
         l_action_request_tbl (1).ENTITY_CODE := OE_GLOBALS.G_ENTITY_HEADER;
         L_LINE_TBL_INDEX := 0;

         OE_ORDER_PUB.PROCESS_ORDER (
            P_API_VERSION_NUMBER       => 1.0,
            P_INIT_MSG_LIST            => FND_API.G_FALSE,
            P_RETURN_VALUES            => FND_API.G_FALSE,
            P_ACTION_COMMIT            => FND_API.G_FALSE,
            X_RETURN_STATUS            => L_RETURN_STATUS,
            X_MSG_COUNT                => L_MSG_COUNT,
            X_MSG_DATA                 => L_MSG_DATA,
            P_HEADER_REC               => L_HEADER_REC,
            P_LINE_TBL                 => L_LINE_TBL,
            P_ACTION_REQUEST_TBL       => L_ACTION_REQUEST_TBL,
            -- OUT PARAMETERS
            X_HEADER_REC               => X_HEADER_REC,
            X_HEADER_VAL_REC           => X_HEADER_VAL_REC,
            X_HEADER_ADJ_TBL           => X_HEADER_ADJ_TBL,
            X_HEADER_ADJ_VAL_TBL       => X_HEADER_ADJ_VAL_TBL,
            X_HEADER_PRICE_ATT_TBL     => X_HEADER_PRICE_ATT_TBL,
            X_HEADER_ADJ_ATT_TBL       => X_HEADER_ADJ_ATT_TBL,
            X_HEADER_ADJ_ASSOC_TBL     => X_HEADER_ADJ_ASSOC_TBL,
            X_HEADER_SCREDIT_TBL       => X_HEADER_SCREDIT_TBL,
            X_HEADER_SCREDIT_VAL_TBL   => X_HEADER_SCREDIT_VAL_TBL,
            X_LINE_TBL                 => P_LINE_TBL,
            X_LINE_VAL_TBL             => X_LINE_VAL_TBL,
            X_LINE_ADJ_TBL             => X_LINE_ADJ_TBL,
            X_LINE_ADJ_VAL_TBL         => X_LINE_ADJ_VAL_TBL,
            X_LINE_PRICE_ATT_TBL       => X_LINE_PRICE_ATT_TBL,
            X_LINE_ADJ_ATT_TBL         => X_LINE_ADJ_ATT_TBL,
            X_LINE_ADJ_ASSOC_TBL       => X_LINE_ADJ_ASSOC_TBL,
            X_LINE_SCREDIT_TBL         => X_LINE_SCREDIT_TBL,
            X_LINE_SCREDIT_VAL_TBL     => X_LINE_SCREDIT_VAL_TBL,
            X_LOT_SERIAL_TBL           => X_LOT_SERIAL_TBL,
            X_LOT_SERIAL_VAL_TBL       => X_LOT_SERIAL_VAL_TBL,
            X_ACTION_REQUEST_TBL       => L_ACTION_REQUEST_TBL);
         COMMIT;

         DBMS_OUTPUT.PUT_LINE ('L_RETURN_STATUS IS    ' || L_RETURN_STATUS);



         -- Check the return status
         IF L_RETURN_STATUS = FND_API.G_RET_STS_SUCCESS
         THEN
            DBMS_OUTPUT.PUT_LINE ('Order Created Successfull');
            DBMS_OUTPUT.PUT_LINE (
               'Order Header_ID : ' || X_HEADER_REC.HEADER_ID);
            SALES_ORDER_BOOKING (IN_P_OIC_INSTANCE_ID,
                                 X_HEADER_REC.HEADER_ID,
                                 L_STATUS,
                                 L_err_msg);

            IF L_status = 'E'
            THEN
               --Header
               UPDATE xxaac.xxawr_so_header_stg
                  SET STATUS = 'E',
                      ERROR_MSG =
                         'Error in booking Sales Order - ' || L_err_msg
                WHERE     1 = 1
                      AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                      AND STG_HEADER_ID = REC_HEADER.STG_HEADER_ID;

               --Lines
               UPDATE xxaac.xxawr_so_lines_stg stg_line
                  SET STATUS = 'E',
                      ERROR_MSG =
                         'Error in booking Sales Order - ' || L_err_msg
                WHERE     1 = 1
                      AND stg_line.OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                      AND STG_HEADER_ID = REC_HEADER.STG_HEADER_ID
                      AND EXISTS
                             (SELECT 1
                                FROM xxaac.xxawr_so_delvy_instr_stg stg_del
                               WHERE stg_line.STG_line_ID =
                                        stg_del.stg_line_id
                                     AND OIC_INSTANCE_ID =
                                            IN_P_OIC_INSTANCE_ID
                                     AND stg_line.stg_header_id =
                                            stg_del.STG_HEADER_ID
                                     AND UPPER (stg_del.STG_DEL_INSTR_STATUS) =
                                            'BOOKED');

               --Delivery
               UPDATE xxaac.xxawr_so_delvy_instr_stg
                  SET STATUS = 'E',
                      ERROR_MSG =
                         'Error in booking Sales Order - ' || L_err_msg
                WHERE     1 = 1
                      AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                      AND STG_HEADER_ID = REC_HEADER.STG_HEADER_ID
                      AND UPPER (STG_DEL_INSTR_STATUS) = 'BOOKED';
            ELSE
               --Header
               UPDATE xxaac.xxawr_so_header_stg
                  SET STATUS = 'S',
                      ORACLE_HEADER_STATUS =
                         (SELECT flow_STATUS_code
                            FROM oe_order_headers_all oe_l
                           WHERE oe_l.header_id = X_HEADER_REC.HEADER_ID),
                      CUSTOMER_PO_NUM = X_HEADER_REC.CUST_PO_NUMBER
                WHERE     1 = 1
                      AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                      AND STG_HEADER_ID = REC_HEADER.STG_HEADER_ID;

               --Lines
               UPDATE xxaac.xxawr_so_lines_stg stg_line
                  SET STATUS = 'S',
                      ORACLE_ORDER_HEADER_ID = X_HEADER_REC.HEADER_ID,
                      ORACLE_ORDER_NUMBER = X_HEADER_REC.ORDER_NUMBER,
                      oracle_line_status =
                         (SELECT flow_STATUS_code
                            FROM oe_order_lines_all oe_l
                           WHERE oe_l.header_id = X_HEADER_REC.HEADER_ID
                                 AND stg_line.ORACLE_LINE_NUMBER =
                                        oe_l.line_number)
                WHERE     1 = 1
                      AND stg_line.OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                      AND STG_HEADER_ID = REC_HEADER.STG_HEADER_ID
                      AND EXISTS
                             (SELECT 1
                                FROM xxaac.xxawr_so_delvy_instr_stg stg_del
                               WHERE stg_line.STG_line_ID =
                                        stg_del.stg_line_id
                                     AND OIC_INSTANCE_ID =
                                            IN_P_OIC_INSTANCE_ID
                                     AND stg_line.stg_header_id =
                                            stg_del.STG_HEADER_ID
                                     AND UPPER (stg_del.STG_DEL_INSTR_STATUS) =
                                            'BOOKED');

               --Delivery

               FOR rec_line_c IN C_LINES (REC_HEADER.STG_HEADER_ID)
               LOOP
                  UPDATE xxaac.xxawr_so_delvy_instr_stg stg_del
                     SET STATUS = 'S',
                         ORACLE_ORDER_HEADER_ID = X_HEADER_REC.HEADER_ID,
                         ORACLE_ORDER_NUMBER = X_HEADER_REC.ORDER_NUMBER,
                         -- Booking_flag = 'Y',
                         oracle_order_line_id =
                            (SELECT line_id
                               FROM oe_order_lines_all oe_l
                              WHERE oe_l.header_id = X_HEADER_REC.HEADER_ID
                                    AND oe_l.attribute2 =
                                           rec_line_c.sf_line_num)
                   WHERE     1 = 1
                         AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                         AND STG_HEADER_ID = REC_HEADER.STG_HEADER_ID
                         AND UPPER (STG_DEL_INSTR_STATUS) = 'BOOKED'
                         AND stg_del.record_id = rec_line_c.record_id;
               END LOOP;
            END IF;

            COMMIT;
         ELSE
            DBMS_OUTPUT.PUT_LINE ('Order Creation Failed');

            FOR I IN 1 .. L_MSG_COUNT
            LOOP
               OE_MSG_PUB.GET (P_MSG_INDEX       => I,
                               P_ENCODED         => FND_API.G_FALSE,
                               P_DATA            => L_MSG_DATA,
                               P_MSG_INDEX_OUT   => L_MSG_INDEX_OUT);
               DBMS_OUTPUT.PUT_LINE ('message : ' || L_MSG_DATA);
               L_err_msg := L_err_msg || ' - Error in SO CREATION API - ';
               DBMS_OUTPUT.PUT_LINE ('message index : ' || L_MSG_INDEX_OUT);
               L_API_ERROR_MESSAGE := L_API_ERROR_MESSAGE || L_MSG_DATA;
            END LOOP;

            BEGIN
               /********************************
               Update Staging HEADER
               ********************************/
               UPDATE xxaac.xxawr_so_header_stg
                  SET STATUS = 'E',
                      ERROR_MSG =
                            'Error in creating Sales Order'
                         || '    '
                         || L_API_ERROR_MESSAGE
                WHERE     1 = 1
                      AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                      AND STG_HEADER_ID = REC_HEADER.STG_HEADER_ID;

               --Lines
               UPDATE xxaac.xxawr_so_lines_stg stg_line
                  SET STATUS = 'E',
                      ERROR_MSG =
                         'Error in creating Sales Order - ' || L_err_msg
                WHERE     1 = 1
                      AND stg_line.OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                      AND STG_HEADER_ID = REC_HEADER.STG_HEADER_ID
                      AND EXISTS
                             (SELECT 1
                                FROM xxaac.xxawr_so_delvy_instr_stg stg_del
                               WHERE stg_line.STG_line_ID =
                                        stg_del.stg_line_id
                                     AND OIC_INSTANCE_ID =
                                            IN_P_OIC_INSTANCE_ID
                                     AND stg_line.stg_header_id =
                                            stg_del.STG_HEADER_ID
                                     AND UPPER (stg_del.STG_DEL_INSTR_STATUS) =
                                            'BOOKED');

               --Delivery
               UPDATE xxaac.xxawr_so_delvy_instr_stg
                  SET STATUS = 'E',
                      ERROR_MSG =
                         'Error in creating Sales Order - ' || L_err_msg
                WHERE     1 = 1
                      AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                      AND STG_HEADER_ID = REC_HEADER.STG_HEADER_ID
                      AND UPPER (STG_DEL_INSTR_STATUS) = 'BOOKED';


               COMMIT;
            EXCEPTION
               WHEN OTHERS
               THEN
                  DBMS_OUTPUT.put_line (
                     'error in updating header stg in so creation');
                  DBMS_OUTPUT.put_line (
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ());
            END;
         END IF;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.PUT_LINE ('Error: ' || SQLCODE || '--' || SQLERRM);
         DBMS_OUTPUT.put_line (DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ());
   END SALES_ORDER_CREATION;

   /***************************************************************************************************
    * Object Name       : CREATE_RESERVATION_API_PRC
    * Program Type      : Package Procedure.
    * Language          : PL/SQL
    * Parameter        :
    * S.No      Name               Required     WHAT
    * =======   ================== =========    =======================================================
    * 1         CREATE_RESERVATION_API_PRC     Y            OIC_INSTANCE_ID
    ***************************************************************************************************
    * History      :
    * WHO              Version #   WHEN            WHAT
    * ===============  =========   =============   ====================================================
    *                   1.0         14-Jan-2024
    ***************************************************************************************************/

   PROCEDURE CREATE_RESERVATION_API_PRC (IN_P_OIC_INSTANCE_ID IN VARCHAR2)
   AS
      p_rsv                inv_reservation_global.mtl_reservation_rec_type;
      p_dummy_sn           inv_reservation_global.serial_number_tbl_type;
      x_msg_count          NUMBER;
      x_msg_data           VARCHAR2 (240);
      x_rsv_id             NUMBER;
      x_dummy_sn           inv_reservation_global.serial_number_tbl_type;
      x_STATUS             VARCHAR2 (1);
      x_qty                NUMBER;
      lv_subinv_code       VARCHAR2 (30);


      l_demand_source_id   NUMBER;



      ----------------------------------------
      CURSOR C_CREATE_RES_API
      IS
         SELECT XSLS.*,
                XSDIS.STG_DEL_INSTR_STATUS,
                XSDIS.RECORD_ID,
                XSDIS.REQUIREMENT_DATE,
                XSDIS.quantity_to_be_delivered,
                --  XSDIS.ITEM_ID,
                XSDIS.UOM_CODE UOM
           FROM xxaac.xxawr_so_lines_stg XSLS,
                xxaac.xxawr_so_delvy_instr_stg XSDIS
          WHERE     1 = 1
                AND XSLS.OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                AND XSDIS.STATUS = 'V'
                AND XSLS.STATUS = 'V'
                AND XSLS.STG_HEADER_ID = XSDIS.STG_HEADER_ID
                AND XSLS.STG_LINE_ID = XSDIS.STG_LINE_ID
                AND UPPER (XSDIS.STG_DEL_INSTR_STATUS) = 'RESERVE';

      TYPE C_CREATE_RES_API_TBL_TYPE IS TABLE OF C_CREATE_RES_API%ROWTYPE
                                           INDEX BY PLS_INTEGER;

      CRT_RES_TBL          C_CREATE_RES_API_TBL_TYPE;
   BEGIN
      fnd_global.apps_initialize (g_user_id, 59997, 401);

      OPEN C_CREATE_RES_API;

      LOOP
         FETCH C_CREATE_RES_API
         BULK COLLECT INTO CRT_RES_TBL
         LIMIT 100;

         FOR INDX IN 1 .. CRT_RES_TBL.COUNT
         LOOP
            BEGIN
               SELECT transaction_source_type_id
                 INTO l_demand_source_id
                 FROM MTL_TXN_SOURCE_TYPES
                WHERE 1 = 1
                      AND transaction_source_type_name =
                             'AWRL SF Orders Reservations';

               DBMS_OUTPUT.put_line ('Demand ID : ' || l_demand_source_id);
               p_rsv.requirement_date := CRT_RES_TBL (INDX).REQUIREMENT_DATE;
               p_rsv.organization_id := CRT_RES_TBL (INDX).ORGANIZATION_ID; --mtl_parameters.organization id
               p_rsv.INVENTORY_ITEM_ID := CRT_RES_TBL (INDX).ITEM_ID; --mtl_system_items.ITEM_ID;
               p_rsv.demand_source_type_id := l_demand_source_id; ---- inv_reservation_global.g_source_type_oe; -- which is 2
               p_rsv.demand_source_name := 'TEST_RESERVE1'; -- AWRL_reserve_sf_order_id
               p_rsv.demand_source_header_id := NULL; -- CRT_RES_TBL(INDX).ORDER_HEADER_ID;
               p_rsv.demand_source_line_id := NULL; --CRT_RES_TBL(INDX).ORDER_LINE_ID;
               p_rsv.PRIMARY_UOM_CODE := CRT_RES_TBL (INDX).UOM_CODE;  --'Ea';
               p_rsv.primary_uom_id := NULL;
               p_rsv.reservation_uom_code := CRT_RES_TBL (INDX).UOM_CODE;
               p_rsv.reservation_uom_id := NULL;
               p_rsv.reservation_quantity :=
                  CRT_RES_TBL (INDX).quantity_to_be_delivered; --CRT_RES_TBL(INDX).STG_del_instruction_quantity
               p_rsv.primary_reservation_quantity :=
                  CRT_RES_TBL (INDX).quantity_to_be_delivered;         --null;
               p_rsv.lot_number := NULL;                       --p_lot_number;
               p_rsv.locator_id := NULL;
               p_rsv.supply_source_type_id :=
                  inv_reservation_global.g_source_type_inv;
               p_rsv.ship_ready_flag := NULL;
               p_rsv.primary_uom_id := NULL;
               p_rsv.reservation_uom_id := NULL;
               p_rsv.subinventory_code := NULL;                       --'102';
               p_rsv.subinventory_id := NULL;
               p_rsv.attribute15 := NULL;
               p_rsv.attribute14 := NULL;
               p_rsv.attribute13 := NULL;
               p_rsv.attribute12 := NULL;
               p_rsv.attribute11 := NULL;
               p_rsv.attribute10 := NULL;
               p_rsv.attribute9 := NULL;
               p_rsv.attribute8 := NULL;
               p_rsv.attribute7 := NULL;
               p_rsv.attribute6 := NULL;
               p_rsv.attribute5 := NULL;
               p_rsv.attribute4 := NULL;
               p_rsv.attribute3 := NULL;
               p_rsv.attribute2 := NULL;
               p_rsv.attribute1 := NULL;
               p_rsv.attribute_category := NULL;
               p_rsv.lpn_id := NULL;
               p_rsv.pick_slip_number := NULL;
               p_rsv.lot_number_id := NULL;
               p_rsv.revision := NULL;
               p_rsv.external_source_line_id := NULL;
               p_rsv.external_source_code := NULL;
               p_rsv.autodetail_group_id := NULL;
               p_rsv.reservation_uom_id := NULL;
               p_rsv.primary_uom_id := NULL;
               p_rsv.demand_source_delivery := NULL;
               p_rsv.supply_source_line_detail := NULL;
               p_rsv.supply_source_name := NULL;
               p_rsv.supply_source_header_id := NULL;
               p_rsv.supply_source_line_id := NULL;

               inv_reservation_pub.create_reservation (
                  p_api_version_number   => 1.0,
                  x_return_STATUS        => x_STATUS,
                  x_msg_count            => x_msg_count,
                  x_msg_data             => x_msg_data,
                  p_rsv_rec              => p_rsv,
                  p_serial_number        => p_dummy_sn,
                  x_serial_number        => x_dummy_sn,
                  x_quantity_reserved    => x_qty,
                  x_reservation_id       => x_rsv_id);

               COMMIT;
               DBMS_OUTPUT.put_line ('Return STATUS    = ' || x_STATUS);
               DBMS_OUTPUT.put_line (
                  'msg count        = ' || TO_CHAR (x_msg_count));
               DBMS_OUTPUT.put_line ('msg data         = ' || x_msg_data);
               DBMS_OUTPUT.put_line (
                  'Quantity reserved = ' || TO_CHAR (x_qty));
               DBMS_OUTPUT.put_line (
                  'Reservation id   = ' || TO_CHAR (x_rsv_id));

               ---------------------------------------------------
               --For Getting Reservation Id in Staging TAble
               ---------------------------------------------------

               IF (x_STATUS <> 'S')
               THEN
                  UPDATE xxaac.xxawr_so_delvy_instr_stg
                     SET STATUS = x_STATUS, ERROR_MSG = x_msg_data
                   WHERE     1 = 1
                         AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                         AND STATUS = 'V'
                         AND STG_line_ID = CRT_RES_TBL (INDX).STG_line_ID
                         AND STG_HEADER_ID = CRT_RES_TBL (INDX).STG_HEADER_ID --   AND RECORD_ID=CRT_RES_TBL(INDX).RECORD_ID
                                                                             ;
               ELSE
                  UPDATE xxaac.xxawr_so_delvy_instr_stg
                     SET RESERVATION_ID = TO_CHAR (x_rsv_id), STATUS = 'S' --x_STATUS
                   --                               ,demand_source_type_id=l_demand_source_id
                   WHERE     1 = 1
                         AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                         AND STATUS = 'V'
                         AND STG_line_ID = CRT_RES_TBL (INDX).STG_line_ID
                         AND STG_HEADER_ID = CRT_RES_TBL (INDX).STG_HEADER_ID
                         AND UPPER (stg_del_instr_status) = 'RESERVE';
               END IF;


               IF x_msg_count >= 1
               THEN
                  FOR I IN 1 .. x_msg_count
                  LOOP
                     DBMS_OUTPUT.put_line (
                        I || '. '
                        || SUBSTR (
                              FND_MSG_PUB.Get (p_encoded => FND_API.G_FALSE),
                              1,
                              255));
                  END LOOP;
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  DBMS_OUTPUT.put_line (
                     'Coming In REATE rESERVATUON PROCEDURE ');
            END;
         END LOOP;

         EXIT WHEN CRT_RES_TBL.COUNT = 0;
      END LOOP;

      COMMIT;

      CLOSE C_CREATE_RES_API;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.PUT_LINE (
               'Unexpected Error in Create Reservation API _-'
            || SQLCODE
            || '-'
            || SQLERRM);
   END CREATE_RESERVATION_API_PRC;


   /***************************************************************************************************
    * Object Name       : ONHAND_QTY_API
    * Program Type      : Package Procedure.
    * Language          : PL/SQL
    * Parameter        :
    * S.No      Name               Required     WHAT
    * =======   ================== =========    =======================================================
    * 1         IN_P_OIC_INSTANCE_ID     Y            OIC_INSTANCE_ID
    ***************************************************************************************************
    * History      :
    * WHO              Version #   WHEN            WHAT
    * ===============  =========   =============   ====================================================
    *                   1.0         14-Jan-2024
    ***************************************************************************************************/

   PROCEDURE onhand_qty_api (p_item_id         IN     VARCHAR2,
                             p_org_id          IN     VARCHAR2,
                             x_qty_atr            OUT NUMBER,
                             X_RETURN_STATUS      OUT VARCHAR2,
                             x_msg_data           OUT VARCHAR2)
   AS
      v_api_return_STATUS   VARCHAR2 (1);
      v_qty_oh              NUMBER;
      v_qty_res_oh          NUMBER;
      v_qty_res             NUMBER;
      v_qty_sug             NUMBER;
      v_qty_att             NUMBER;
      v_qty_atr             NUMBER;            --Quantity available to reserve
      v_msg_count           NUMBER;
      v_msg_data            VARCHAR2 (1000);
   --v_ITEM_ID  VARCHAR2(250) := '243205';
   --v_organization_id    VARCHAR2(10)  := 'G_ORG_ID';

   BEGIN
      inv_quantity_tree_grp.clear_quantity_cache;

      DBMS_OUTPUT.put_line ('Transaction Mode');
      DBMS_OUTPUT.put_line ('Onhand For the Item :' || p_item_id);
      DBMS_OUTPUT.put_line ('Organization        :' || p_org_id);

      apps.INV_QUANTITY_TREE_PUB.QUERY_QUANTITIES (
         p_api_version_number    => 1.0,
         p_init_msg_lst          => apps.fnd_api.g_false,
         x_return_STATUS         => v_api_return_STATUS,
         x_msg_count             => v_msg_count,
         x_msg_data              => v_msg_data,
         p_organization_id       => p_org_id,
         p_INVENTORY_ITEM_ID     => p_item_id,
         p_tree_mode             => apps.inv_quantity_tree_pub.g_transaction_mode,
         p_onhand_source         => 3,
         p_is_revision_control   => FALSE,
         p_is_lot_control        => FALSE,
         p_is_serial_control     => FALSE,
         p_revision              => NULL,
         p_lot_number            => NULL,
         p_subinventory_code     => NULL,
         p_locator_id            => NULL,
         x_qoh                   => v_qty_oh,
         x_rqoh                  => v_qty_res_oh,
         x_qr                    => v_qty_res,
         x_qs                    => v_qty_sug,
         x_att                   => v_qty_att,
         x_atr                   => v_qty_atr);


      x_qty_atr := v_qty_atr;
      X_RETURN_STATUS := v_api_return_STATUS;
      X_msg_data := v_msg_data;

      DBMS_OUTPUT.put_line ('on hand Quantity                :' || v_qty_oh);
      DBMS_OUTPUT.put_line (
         'Reservable quantity on hand     :' || v_qty_res_oh);
      DBMS_OUTPUT.put_line ('Quantity reserved               :' || v_qty_res);
      DBMS_OUTPUT.put_line ('Quantity suggested              :' || v_qty_sug);
      DBMS_OUTPUT.put_line ('Quantity Available To Transact  :' || v_qty_att);
      DBMS_OUTPUT.put_line ('Quantity Available To Reserve   :' || v_qty_atr);
   END onhand_qty_api;


   /***************************************************************************************************
    * Object Name       : ITEM_RES_INV_VALIDATION_PRC
    * Program Type      : Package Procedure.
    * Language          : PL/SQL
    * Parameter        :
    * S.No      Name               Required     WHAT
    * =======   ================== =========    =======================================================
    * 1         IN_P_OIC_INSTANCE_ID     Y            OIC_INSTANCE_ID
    ***************************************************************************************************
    * History      :
    * WHO              Version #   WHEN            WHAT
    * ===============  =========   =============   ====================================================
    *                   1.0         14-Jan-2024
    ***************************************************************************************************/



   PROCEDURE ITEM_RES_INV_VALIDATION_PRC (IN_P_OIC_INSTANCE_ID   IN VARCHAR2,
                                          IN_ACTION_TYPE         IN VARCHAR2)
   IS
      L_COUNT           NUMBER;

      CURSOR C_ITEM_RES
      IS
         SELECT XSDIS.STG_DEL_INSTR_STATUS,
                XSDIS.RECORD_ID,
                xsdis.requirement_date,
                XSLS.*
           FROM xxaac.xxawr_so_delvy_instr_stg XSDIS,
                xxaac.xxawr_so_lines_stg XSLS
          WHERE     1 = 1
                AND XSLS.OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                AND XSDIS.STATUS = 'N'
                AND XSLS.STG_HEADER_ID = XSDIS.STG_HEADER_ID
                AND XSLS.STG_LINE_ID = XSDIS.STG_LINE_ID;

      TYPE C_ITEM_RES_TBL_TYPE IS TABLE OF C_ITEM_RES%ROWTYPE
                                     INDEX BY PLS_INTEGER;

      INV_RES_TBL       C_ITEM_RES_TBL_TYPE;

      --Varriable for Item available to reserve
      L_qty_atr         NUMBER;
      --Varriable for Onhand qty API STATUS
      L_return_STATUS   VARCHAR2 (1);
      --Varriable for Onhand quantity Error message
      L_error_msg       VARCHAR2 (1000);
   BEGIN
      OPEN C_ITEM_RES;

      LOOP
         FETCH C_ITEM_RES
         BULK COLLECT INTO INV_RES_TBL
         LIMIT 100;

         FOR INDX IN 1 .. INV_RES_TBL.COUNT
         LOOP
            BEGIN
               INV_RES_TBL (INDX).STATUS := 'V';
               INV_RES_TBL (INDX).ERROR_MSG :=
                  INV_RES_TBL (INDX).ERROR_MSG || NULL;

               -----------------------------------------------------
               --Organization name Validation
               -----------------------------------------------------
               BEGIN
                  SELECT organization_id
                    INTO INV_RES_TBL (indx).organization_id
                    FROM org_organization_definitions
                   WHERE LOWER (organization_name) =
                            LOWER (G_ORGANIZATION_NAME);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     INV_RES_TBL (INDX).ERROR_MSG :=
                           INV_RES_TBL (INDX).ERROR_MSG
                        || ' - '
                        || 'Organization not exist';
                     INV_RES_TBL (INDX).STATUS := 'E';
               END;



               /*********************************************
               UOM CODE VALIDATION
               *********************************************/
               BEGIN
                  SELECT COUNT (1)
                    INTO L_COUNT
                    FROM MTL_UNITS_OF_MEASURE_TL
                   WHERE UPPER (UOM_CODE) =
                            UPPER (INV_RES_TBL (indx).UOM_CODE) --  AND organization_id = INV_RES_TBL(indx).organization_id
                                                               ;

                  IF L_COUNT < 1
                  THEN
                     INV_RES_TBL (INDX).ERROR_MSG :=
                           INV_RES_TBL (INDX).ERROR_MSG
                        || ' - '
                        || 'UOM  CODE DOES not exist ';
                     INV_RES_TBL (INDX).STATUS := 'E';
                  ELSIF L_COUNT > 1
                  THEN
                     INV_RES_TBL (INDX).ERROR_MSG :=
                           INV_RES_TBL (INDX).ERROR_MSG
                        || ' - '
                        || 'UOM CODE SHOUL BE ONE IN BASE TABLE';
                     INV_RES_TBL (INDX).STATUS := 'E';
                  END IF;
               END;


               /*******************************************************
  REQUIREMENT_DATE
  *******************************************************/

               IF INV_RES_TBL (indx).requirement_date IS NULL
               THEN
                  INV_RES_TBL (INDX).ERROR_MSG :=
                        INV_RES_TBL (INDX).ERROR_MSG
                     || ' - '
                     || 'REQUIREMENT DATE CANNOT BE NULL ';
                  INV_RES_TBL (INDX).STATUS := 'E';
               ELSIF INV_RES_TBL (indx).requirement_date < SYSDATE + 7
               THEN
                  INV_RES_TBL (INDX).ERROR_MSG :=
                        INV_RES_TBL (INDX).ERROR_MSG
                     || ' - '
                     || 'REQUIREMENT DATE SHOULD BE GREATER THAN SYSDATE + 7';
                  INV_RES_TBL (INDX).STATUS := 'E';
               END IF;

               ---------------------------------------------------
               -->Inventory Item Name(Desc) VALIDATION
               ---------------------------------------------------

               IF (INV_RES_TBL (indx).ITEM_CODE IS NOT NULL)
               THEN
                  BEGIN
                     SELECT INVENTORY_ITEM_ID
                       INTO INV_RES_TBL (indx).ITEM_ID
                       FROM mtl_system_items_b
                      WHERE LOWER (segment1) =
                               LOWER (INV_RES_TBL (indx).ITEM_CODE)
                            AND organization_id =
                                   INV_RES_TBL (indx).organization_id;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        INV_RES_TBL (INDX).ERROR_MSG :=
                              INV_RES_TBL (INDX).ERROR_MSG
                           || ' - '
                           || 'Item not exist';
                        INV_RES_TBL (INDX).STATUS := 'E';
                  END;
               ELSE
                  INV_RES_TBL (INDX).ERROR_MSG :=
                        INV_RES_TBL (INDX).ERROR_MSG
                     || ' - '
                     || ' organizatION ID DOESNOT EXIST ';
                  INV_RES_TBL (INDX).STATUS := 'E';
               END IF;



               /***********************************************
               ** Updating Staging Table
               ***********************************************/
               BEGIN
                  UPDATE xxaac.xxawr_so_delvy_instr_stg
                     SET                                --who columns updation
                        CREATION_DATE = SYSDATE,
                         CREATED_BY = 0,                          -- g_user_id
                         LAST_UPDATE_DATE = SYSDATE,
                         LAST_UPDATED_BY = 0,                     -- g_user_id
                         STATUS = INV_RES_TBL (INDX).STATUS,
                         ERROR_MSG = INV_RES_TBL (INDX).ERROR_MSG
                   --       ITEM_ID = INV_RES_TBL (INDX).ITEM_ID
                   WHERE     1 = 1
                         AND STATUS = 'N'
                         AND STG_line_ID = INV_RES_TBL (INDX).STG_line_ID
                         AND oic_instance_id = IN_P_OIC_INSTANCE_ID
                         AND record_id = INV_RES_TBL (indx).record_id;

                  COMMIT;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     DBMS_OUTPUT.PUT_LINE (
                        'Unexcpected Erros while Updating Staging DELIVERY table '
                        || SQLCODE
                        || ' - '
                        || SQLERRM);
               END;



               /***********************************************
             ** Updating Staging Table
             ***********************************************/
               BEGIN
                  UPDATE xxaac.xxawr_so_LINES_stg
                     SET                                --who columns updation
                        CREATION_DATE = SYSDATE,
                         CREATED_BY = 0,                          -- g_user_id
                         LAST_UPDATE_DATE = SYSDATE,
                         LAST_UPDATED_BY = 0,                     -- g_user_id
                         STATUS = INV_RES_TBL (INDX).STATUS,
                         ERROR_MSG = INV_RES_TBL (INDX).ERROR_MSG,
                         ORGANIZATION_ID = INV_RES_TBL (INDX).ORGANIZATION_ID
                   WHERE     1 = 1
                         AND STATUS = 'N'
                         AND STG_line_ID = INV_RES_TBL (INDX).STG_line_ID
                         AND oic_instance_id = IN_P_OIC_INSTANCE_ID--    AND record_id = INV_RES_TBL (indx).record_id;
                  ;

                  COMMIT;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     DBMS_OUTPUT.PUT_LINE (
                        'Unexcpected Erros while Updating Staging LINE table '
                        || SQLCODE
                        || ' - '
                        || SQLERRM);
               END;
            EXCEPTION
               WHEN OTHERS
               THEN
                  DBMS_OUTPUT.put_line (
                     'Coming In Validation Procedure--ERROR IN UPDATING FETCHING VALUES');
            END;

            DBMS_OUTPUT.put_line ('Competed validation Prc');
         END LOOP;

         EXIT WHEN INV_RES_TBL.COUNT = 0;
      END LOOP;

      COMMIT;

      CLOSE C_ITEM_RES;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.PUT_LINE (
               'Unexpected Error in Validation Procdure '
            || SQLCODE
            || '-'
            || SQLERRM);
   END ITEM_RES_INV_VALIDATION_PRC;



   /***************************************************************************************************
    * Object Name       : UNRESERVE_ITEM_API_PRC
    * Program Type      : Package Procedure.
    * Language          : PL/SQL
    * Parameter        :
    * S.No      Name               Required     WHAT
    * =======   ================== =========    =======================================================
    * 1         UNRESERVE_ITEM_API_PRC     Y            OIC_INSTANCE_ID
    ***************************************************************************************************
    * History      :
    * WHO              Version #   WHEN            WHAT
    * ===============  =========   =============   ====================================================
    *                   1.0         2024
    ***************************************************************************************************/

   PROCEDURE UNRESERVE_ITEM_API_PRC (IN_P_OIC_INSTANCE_ID IN VARCHAR2)
   AS
      l_rsv                inv_reservation_global.mtl_reservation_rec_type;
      l_msg_count          NUMBER;
      l_msg_data           VARCHAR2 (240);
      l_rsv_id             NUMBER;
      l_dummy_sn           inv_reservation_global.serial_number_tbl_type;
      l_STATUS             VARCHAR2 (1);
      x_return_STATUS      VARCHAR2 (1);
      x_msg_data           VARCHAR2 (1000);
      l_demand_source_id   NUMBER;

      --CURSOR TO CHECK RESERVATION HISTORY WITH SF ORDER ID
      CURSOR c_rsrv_chk
      IS
         SELECT stg_del.reservation_id rsv_id, stg_hd.sf_order_id sf_id
           FROM xxaac.xxawr_so_delvy_instr_stg stg_del,
                xxaac.xxawr_so_header_stg stg_hd,
                xxaac.xxawr_so_lines_stg stg_ln
          WHERE     stg_del.stg_header_id = stg_ln.Stg_header_id
                AND stg_ln.stg_header_id = stg_hd.stg_header_id
                AND stg_del.Stg_line_id = stg_ln.Stg_line_id
                AND stg_hd.status = 'S'
                AND stg_hd.sf_order_id IN
                       (SELECT stg_hd1.sf_order_id
                          FROM xxaac.xxawr_so_header_stg stg_hd1,
                               xxaac.xxawr_so_lines_stg stg_ln1,
                               xxaac.xxawr_so_delvy_instr_stg stg_del1
                         WHERE stg_del1.status = 'V'
                               AND stg_hd1.oic_instance_id =
                                      in_p_oic_instance_id
                               AND stg_del1.stg_header_id =
                                      stg_ln1.stg_header_id
                               AND stg_ln1.Stg_header_id =
                                      stg_hd1.stg_header_id
                               AND stg_del1.Stg_line_id = stg_ln1.stg_line_id
                               AND UPPER (stg_del1.stg_del_instr_status) IN
                                      ('BOOKED', 'UNRESERVE', 'CANCELLED')
                               AND UPPER (stg_ln.item_code) =
                                      UPPER (stg_ln1.item_code)
                               AND STG_DEL.STG_DEL_INSTR_ID =
                                      STG_DEL1.STG_DEL_INSTR_ID)
                AND EXISTS
                       (SELECT 1
                          FROM mtl_reservations mr
                         WHERE mr.reservation_id = stg_del.reservation_id);

      TYPE c_rsrv_chk_type IS TABLE OF c_rsrv_chk%ROWTYPE
                                 INDEX BY PLS_INTEGER;

      rsv_tbl              c_rsrv_chk_type;

      --CURSOR TO FETCH NEW SF ORDER RECORD
      CURSOR c_stg_dtl
      IS
         SELECT stg_hd1.sf_order_id sf_id, stg_ln1.item_code item_code
           FROM xxaac.xxawr_so_header_stg stg_hd1,
                xxaac.xxawr_so_lines_stg stg_ln1,
                xxaac.xxawr_so_delvy_instr_stg stg_del1
          WHERE     UPPER (stg_hd1.status) IN ('V', 'N')
                AND stg_hd1.oic_instance_id = in_p_oic_instance_id
                AND stg_del1.stg_header_id = stg_ln1.stg_header_id
                AND stg_ln1.Stg_header_id = stg_hd1.stg_header_id
                AND stg_del1.Stg_line_id = stg_ln1.stg_line_id
                AND UPPER (stg_del1.stg_del_instr_status) IN
                       ('BOOKED', 'UNRESERVE');

      TYPE c_stg_dtl_type IS TABLE OF c_stg_dtl%ROWTYPE
                                INDEX BY PLS_INTEGER;

      stg_tbl              c_stg_dtl_type;
   BEGIN
      DBMS_OUTPUT.put_line ('Unreserved Process Initiated');
      fnd_global.apps_initialize (g_user_id, 59997, 401);

      BEGIN
         SELECT transaction_source_type_id
           INTO l_demand_source_id
           FROM MTL_TXN_SOURCE_TYPES
          WHERE 1 = 1
                AND transaction_source_type_name =
                       'AWRL SF Orders Reservations';

         OPEN c_stg_dtl;

         LOOP
            FETCH c_stg_dtl
            BULK COLLECT INTO stg_tbl
            LIMIT 50;

            FOR indx IN 1 .. stg_tbl.COUNT
            LOOP
               BEGIN
                  OPEN c_rsrv_chk;

                  LOOP
                     FETCH c_rsrv_chk
                     BULK COLLECT INTO rsv_tbl
                     LIMIT 50;

                     FOR indx1 IN 1 .. rsv_tbl.COUNT
                     LOOP
                        BEGIN
                           IF stg_tbl (indx).sf_id = rsv_tbl (indx1).sf_id
                           THEN
                              DBMS_OUTPUT.put_line (
                                 'reservation_id found : '
                                 || rsv_tbl (indx1).rsv_id);

                              --CALLING Unreservation Process:
                              l_rsv.reservation_id := rsv_tbl (indx1).rsv_id;
                              l_rsv.demand_source_type_id :=
                                 l_demand_source_id;

                              inv_reservation_pub.delete_reservation (
                                 p_api_version_number   => 1.0,
                                 p_init_msg_lst         => fnd_api.g_true,
                                 x_return_STATUS        => l_STATUS,
                                 x_msg_count            => l_msg_count,
                                 x_msg_data             => l_msg_data,
                                 p_rsv_rec              => l_rsv,
                                 p_serial_number        => l_dummy_sn);

                              COMMIT;

                              IF UPPER (l_STATUS) = 'S'
                              THEN
                                 UPDATE xxaac.xxawr_so_delvy_instr_stg stg_del
                                    SET reservation_id =
                                           rsv_tbl (indx1).rsv_id,
                                        status = 'Unreserved'
                                  WHERE status = 'N'
                                        AND oic_instance_id =
                                               in_p_oic_instance_id
                                        AND stg_tbl (indx).sf_id =
                                               rsv_tbl (indx1).sf_id
                                        AND UPPER (
                                               stg_del.stg_del_instr_status) IN
                                               ('BOOKED', 'UNRESERVE')
                                        AND EXISTS
                                               (SELECT 1
                                                  FROM xxaac.xxawr_so_lines_stg stg_ln
                                                 WHERE stg_ln.Stg_line_id =
                                                          stg_del.Stg_line_id
                                                       AND UPPER (
                                                              stg_ln.item_code) =
                                                              UPPER (
                                                                 stg_tbl (
                                                                    indx).item_code)
                                                       AND oic_instance_id =
                                                              in_p_oic_instance_id);

                                 COMMIT;
                              ELSE
                                 DBMS_OUTPUT.put_line (
                                    'FAILED TO UNRESERVE ITEM');

                                 FOR i IN 1 .. l_msg_count
                                 LOOP
                                    DBMS_OUTPUT.put_line (l_msg_data);
                                 END LOOP;
                              END IF;
                           END IF;
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              DBMS_OUTPUT.PUT_LINE (
                                 'Error in Unreserved Item process cursor C_RSRV_CHK - '
                                 || SQLCODE
                                 || '-'
                                 || SQLERRM);
                              DBMS_OUTPUT.put_line (
                                 DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ());
                        END;
                     END LOOP;

                     EXIT WHEN rsv_tbl.COUNT = 0;
                  END LOOP;

                  CLOSE c_rsrv_chk;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     DBMS_OUTPUT.PUT_LINE (
                        'Error in Unreserved Item process cursor C_STG_DTL -'
                        || SQLCODE
                        || '-'
                        || SQLERRM);
               END;
            END LOOP;

            EXIT WHEN stg_tbl.COUNT = 0;
         END LOOP;

         CLOSE c_stg_dtl;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.PUT_LINE (
                  'Invalid Transaction Source Name -'
               || SQLCODE
               || '-'
               || SQLERRM);
      END;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.PUT_LINE (
            'Error in Main Unreservation -' || SQLCODE || '-' || SQLERRM);
   END UNRESERVE_ITEM_API_PRC;

   --
   /*******************************************************************************************************************
   * Program Name   : WRAPPER_PROGRAM
   * Language       : PL/SQL
   * Description    : Procedure OF main
   * History        :
   * WHO              WHAT                                                          WHEN
   * --------------   -------------------------------------------------------       --------------
   *                    Procedure OF WRAPPER_PROGRAM                                     2024
   *******************************************************************************************************************/

   PROCEDURE wrapper_program (in_p_oic_instance_id IN VARCHAR2)
   IS
      CURSOR c_stg_del_instr_status
      IS
         SELECT *
           FROM xxaac.xxawr_so_delvy_instr_stg
          WHERE     1 = 1
                AND oic_instance_id = in_p_oic_instance_id
                AND NVL (status, 'N') = ('N');

      CURSOR c_header
      IS
         SELECT *
           FROM xxaac.xxawr_so_header_stg
          WHERE     1 = 1
                AND oic_instance_id = in_p_oic_instance_id
                AND NVL (status, 'N') = ('N');

      L_id              VARCHAR2 (240);
      L_count           NUMBER;
      L_status          VARCHAR2 (240);
      L_cancel_flag     VARCHAR2 (20);
      L_cancel_reason   VARCHAR2 (240);
      L_err_msg         VARCHAR2 (1000);
   BEGIN
      SELECT COUNT (1)
        INTO L_count
        FROM xxaac.xxawr_so_delvy_instr_stg stg_del
       WHERE UPPER (STG_DEL_INSTR_STATUS) = 'CANCELLED'
             AND oic_instance_id = in_p_oic_instance_id
             AND EXISTS
                    (SELECT 1
                       FROM OE_ORDER_HEADERS_ALL oha
                      WHERE 1 = 1
                            AND FLOW_STATUS_CODE IN ('ENTERED', 'BOOKED'));

      IF L_count > 0
      THEN
         SALES_ORDER_CANCEL (IN_P_OIC_INSTANCE_ID); --Calling Sales Order Cancel Process
      ELSE
         FOR r_stg_del_instr_status IN c_stg_del_instr_status
         LOOP
            IF r_stg_del_instr_status.stg_del_instr_id IS NOT NULL
            THEN
               DBMS_OUTPUT.put_line (
                  r_stg_del_instr_status.stg_del_instr_status);

               IF UPPER (r_stg_del_instr_status.stg_del_instr_status) =
                     'RESERVE'
               THEN
                  ITEM_RES_INV_VALIDATION_PRC (
                     IN_P_OIC_INSTANCE_ID,
                     R_STG_DEL_INSTR_STATUS.STG_DEL_INSTR_STATUS);
                  CREATE_RESERVATION_API_PRC (IN_P_OIC_INSTANCE_ID);
               ELSIF UPPER (r_stg_del_instr_status.stg_del_instr_status) =
                        'UNRESERVE'
               THEN
                  ITEM_RES_INV_VALIDATION_PRC (
                     IN_P_OIC_INSTANCE_ID,
                     R_STG_DEL_INSTR_STATUS.STG_DEL_INSTR_STATUS);
                  UNRESERVE_ITEM_API_PRC (IN_P_OIC_INSTANCE_ID);
               ELSIF UPPER (r_stg_del_instr_status.stg_del_instr_status) =
                        'BOOKED'
               THEN
                  FOR r_header IN c_header
                  LOOP
                     BEGIN
                        --validation_data (IN_P_OIC_INSTANCE_ID);

                        UNRESERVE_ITEM_API_PRC (IN_P_OIC_INSTANCE_ID);

                        SALES_ORDER_CREATION (IN_P_OIC_INSTANCE_ID);
                     END;
                  END LOOP;
               END IF;
            END IF;
         END LOOP;
      END IF;
   END wrapper_program;


   --


   /***************************************************************************************************
    * Program Type      : Package Function.
    * Program Name      : VALIDATION_DATA
    * Language          : PL/SQL
    * Parameter         :
    * S.No      Name               Required     WHAT
    * =======   ================== =========    ======================================================
    * 1         P_OIC_INSTANCE_ID  Y            Interface ID. error message.
    ***************************************************************************************************/

   PROCEDURE validation_data (IN_P_OIC_INSTANCE_ID IN VARCHAR2)
   AS
      CURSOR C_HEADER
      IS
         SELECT *
           FROM xxaac.xxawr_so_header_stg
          WHERE     1 = 1
                AND STATUS = 'N'
                AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;

      TYPE CUR_SO_DATA_TYPE_HDR IS TABLE OF C_HEADER%ROWTYPE
                                      INDEX BY PLS_INTEGER;

      SO_DATA_HDR              CUR_SO_DATA_TYPE_HDR;



      CURSOR C_LINES (
         IN_STG_HEADER_ID IN VARCHAR2)
      IS
         SELECT *
           FROM xxaac.xxawr_so_lines_stg
          WHERE     1 = 1
                AND STATUS = 'N'
                AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                AND STG_HEADER_ID = IN_STG_HEADER_ID;


      TYPE CUR_SO_DATA_TYPE_LINE IS TABLE OF C_LINES%ROWTYPE
                                       INDEX BY PLS_INTEGER;

      SO_DATA_LINE             CUR_SO_DATA_TYPE_LINE;



      -->local variable
      L_CURRENCY_COUNT         NUMBER;
      L_UOM_COUNT              NUMBER;
      L_TRANSACTION_QUANTITY   NUMBER;
      L_COUNT                  NUMBER;

      --

      l_err_msg                VARCHAR2 (4000);
      l_status                 VARCHAR2 (1);
      l_line_errored_flag      VARCHAR2 (1);
      l_hdr_errored_flag       VARCHAR2 (1);
   BEGIN
      OPEN C_HEADER;

      LOOP
         FETCH C_HEADER
         BULK COLLECT INTO SO_DATA_HDR
         LIMIT 500;

         print_log (
            'INSIDE FETCH VALIDATION' || SO_DATA_HDR.COUNT);

         FOR I IN 1 .. SO_DATA_HDR.COUNT
         LOOP
            BEGIN
               SO_DATA_HDR (I).STATUS := 'V';
               SO_DATA_HDR (I).ERROR_MSG := '';


               print_log ('INSIDE VALIDATE');
			   
			   /******************************************
                * Oracle User validation
                ******************************************/
				
			BEGIN 
			   select FU.USER_ID INTO SO_DATA_HDR (I).CREATED_BY 
			   from per_people_f ppf , fnd_user FU
			    where ppf.person_id = fu.employee_id
				and (current_employee_flag ='Y' OR current_npw_flag='Y')
				AND and trunc(sysdate) between ppf.effective_start_date 
				and ppf.EFFECTIVE_END_DATE
				AND PPF.EMPLOYEE_NUMBER = SO_DATA_HDR (I).created_By_Oracle_User;
			
			EXCEPTION 
			WHEN OTHERS THEN
			
			SO_DATA_HDR (I).STATUS := 'E';
                     SO_DATA_HDR (I).ERROR_MSG :=
                           SO_DATA_HDR (I).ERROR_MSG
                        || '- Oracle Last Updated by Employee is invalid'
                        || SQLCODE
                        || SQLERRM;
			
		   END;
		   
		   BEGIN 
			   select FU.USER_ID INTO SO_DATA_HDR (I).last_updated_by  
			   from per_people_f ppf , fnd_user FU
			    where ppf.person_id = fu.employee_id
				and (current_employee_flag ='Y' OR current_npw_flag='Y')
				AND and trunc(sysdate) between ppf.effective_start_date 
				and ppf.EFFECTIVE_END_DATE
				AND PPF.EMPLOYEE_NUMBER = SO_DATA_HDR (I).lastupdated_By_Oracle_User;
			
			EXCEPTION 
			WHEN OTHERS THEN
			
			SO_DATA_HDR (I).STATUS := 'E';
                     SO_DATA_HDR (I).ERROR_MSG :=
                           SO_DATA_HDR (I).ERROR_MSG
                        || '- Oracle Created by Employee is invalid'
                        || SQLCODE
                        || SQLERRM;
			
		   END;
				
			   


              /******************************************
               * Customer validation ie sold to org
               *********************************************/

               BEGIN
                  SELECT HCA.ACCOUNT_NUMBER
                    INTO SO_DATA_HDR (I).SOLD_TO_CUST_ACC_NUM
                    FROM HZ_CUST_ACCOUNTS HCA
                   WHERE HCA.CUST_ACCOUNT_ID = SO_DATA_HDR (I).CUSTOMER_ID;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     SO_DATA_HDR (I).STATUS := 'E';
                     SO_DATA_HDR (I).ERROR_MSG :=
                           SO_DATA_HDR (I).ERROR_MSG
                        || '- Customer ID is invalid'
                        || SQLCODE
                        || SQLERRM;
               END;



               /************************************
                * VALIDATING for payment term
                ************************************/

               BEGIN
                  SELECT hcaa.PAYMENT_TERM_ID
                    INTO SO_DATA_HDR (I).payment_term_id
                    FROM hz_cust_accounts_all hcaa, ra_terms rt
                   WHERE rt.term_id = hcaa.PAYMENT_TERM_ID
                         AND hcAa.CUST_ACCOUNT_ID =
                                SO_DATA_HDR (I).CUSTOMER_ID;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     SO_DATA_HDR (I).STATUS := 'E';
                     SO_DATA_HDR (I).ERROR_MSG :=
                           SO_DATA_HDR (I).ERROR_MSG
                        || '- Payment Term is not Valid'
                        || SQLCODE
                        || SQLERRM;
               END;



               /********************************
                * SALESPERSON VALIDATION
                ********************************/
               BEGIN
                  SELECT rsp.salesrep_id
                    INTO SO_DATA_HDR (I).SALESREP_ID
                    FROM ra_salesreps_all rsp, per_all_people_f papf
                   WHERE rsp.salesrep_number = papf.employee_number
                         AND rsp.org_id = g_org_id
                         AND papf.employee_number =
                                so_data_hdr (i).oracle_employee_number
                         AND current_employee_flag = 'Y'
                         AND TRUNC (SYSDATE) BETWEEN TRUNC (
                                                        start_date_active)
                                                 AND NVL (
                                                        TRUNC (
                                                           end_date_active),
                                                        TRUNC (SYSDATE + 1))
                         AND ROWNUM < 2;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     SO_DATA_HDR (I).STATUS := 'E';
                     SO_DATA_HDR (I).ERROR_MSG :=
                        SO_DATA_HDR (I).ERROR_MSG
                        || '-Either Employee does not exist or is Inactive or is not assigned with the Role of Salesperson'
                        || SQLCODE
                        || SQLERRM;
               END;


               /*******************************
               * VALIDATING ORDER TYPE
               ********************************/

               BEGIN
                  SELECT TRANSACTION_TYPE_ID
                    INTO SO_DATA_HDR (I).ORDERED_TYPE_ID
                    FROM OE_TRANSACTION_TYPES_TL
                   WHERE UPPER (NAME) =
                            UPPER (SO_DATA_HDR (I).ORDER_TYPE_NAME);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     SO_DATA_HDR (I).STATUS := 'E';
                     SO_DATA_HDR (I).ERROR_MSG :=
                           SO_DATA_HDR (I).ERROR_MSG
                        || 'Order Type is not Valid'
                        || SQLCODE
                        || SQLERRM;
               END;


               /********************************
                * CURRENCY CODE VALIDATION
                *********************************/

               BEGIN
                  SELECT COUNT (CURRENCY_CODE)
                    INTO L_CURRENCY_COUNT
                    FROM FND_CURRENCIES
                   WHERE UPPER (CURRENCY_CODE) =
                            UPPER (SO_DATA_HDR (I).TRANSACTIONAL_CURR_CODE);

                  IF L_CURRENCY_COUNT = 0
                  THEN
                     SO_DATA_HDR (I).STATUS := 'E';
                     SO_DATA_HDR (I).ERROR_MSG :=
                           SO_DATA_HDR (I).ERROR_MSG
                        || 'Rransactional Currency is not Valid'
                        || SQLCODE
                        || SQLERRM;
                  END IF;
               END;

               /*********************************
                * VALIDATING PRICE LIST
                *********************************/
               BEGIN
                  SELECT DISTINCT oha.PRICE_LIST_ID
                    INTO SO_DATA_HDR (I).PRICE_LIST_ID
                    FROM OE_ORDER_HEADERS_ALL oha, qp_list_headers qlh
                   WHERE ORG_ID = G_ORG_ID
                         AND oha.price_list_id = qlh.list_header_id
                         AND oha.ORDER_TYPE_ID =
                                SO_DATA_HDR (I).ORDERED_TYPE_ID
                         AND qlh.currency_code =
                                SO_DATA_HDR (I).TRANSACTIONAL_CURR_CODE
                         AND (TRUNC (SYSDATE) BETWEEN TRUNC (
                                                         qlh.start_date_active)
                                                  AND TRUNC (
                                                         NVL (
                                                            qlh.end_date_active,
                                                            SYSDATE + 1)))
                         AND qlh.active_flag = 'Y';
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     BEGIN
                        SELECT COUNT (PRICE_LIST_ID)
                          INTO L_COUNT
                          FROM hz_cust_accounts
                         WHERE CUST_ACCOUNT_ID =
                                  SO_DATA_HDR (I).SOLD_TO_CUST_ACC_NUM;

                        IF L_COUNT = 0
                        THEN
                           BEGIN
                              SELECT PRICE_LIST_ID
                                INTO SO_DATA_HDR (I).PRICE_LIST_ID
                                FROM OE_TRANSACTION_TYPES_ALL OTTA,
                                     OE_TRANSACTION_TYPES_TL OTTL
                               WHERE UPPER (OTTL.NAME) =
                                        UPPER (
                                           SO_DATA_HDR (I).ORDER_TYPE_NAME)
                                     AND OTTA.TRANSACTION_TYPE_ID =
                                            OTTL.TRANSACTION_TYPE_ID
                                     AND transaction_type_code = 'ORDER'
                                     AND otta.org_id = g_org_id;
                           EXCEPTION
                              WHEN OTHERS
                              THEN
                                 SO_DATA_HDR (I).STATUS := 'E';
                                 SO_DATA_HDR (I).ERROR_MSG :=
                                    SO_DATA_HDR (I).ERROR_MSG
                                    || 'Price list is missing in transaction level'
                                    || '    '
                                    || SQLCODE
                                    || '   '
                                    || SQLERRM;
                           END;
                        ELSE
                           IF L_COUNT = 1
                           THEN
                              BEGIN
                                 SELECT PRICE_LIST_ID
                                   INTO SO_DATA_HDR (I).PRICE_LIST_ID
                                   FROM hz_cust_accounts
                                  WHERE CUST_ACCOUNT_ID =
                                           SO_DATA_HDR (I).SOLD_TO_CUST_ACC_NUM;
                              EXCEPTION
                                 WHEN OTHERS
                                 THEN
                                    SO_DATA_HDR (I).STATUS := 'E';
                                    SO_DATA_HDR (I).ERROR_MSG :=
                                       SO_DATA_HDR (I).ERROR_MSG
                                       || ' - Price List doesnot exist in accounts level '
                                       || SQLCODE
                                       || SQLERRM;
                              END;
                           END IF;
                        END IF;
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           SO_DATA_HDR (I).STATUS := 'E';
                           SO_DATA_HDR (I).ERROR_MSG :=
                                 SO_DATA_HDR (I).ERROR_MSG
                              || ' Price List doesnot exist '
                              || SQLCODE
                              || SQLERRM;
                     END;
               END;



               --->CURSOR OPEN FOR LINE


               OPEN C_LINES (SO_DATA_HDR (I).STG_HEADER_ID);

               LOOP
                  FETCH C_LINES
                  BULK COLLECT INTO SO_DATA_LINE
                  LIMIT 500;

                  FOR I IN 1 .. SO_DATA_LINE.COUNT
                  LOOP
                     BEGIN
                        SO_DATA_LINE (I).STATUS := 'V';
                        SO_DATA_LINE (I).ERROR_MSG := '';


                        /*****************
                         * Ship from Org
                         *******************/
                        BEGIN
                           SELECT ORGANIZATION_ID
                             INTO SO_DATA_LINE (I).SHIP_FROM_ORG_ID
                             FROM ORG_ORGANIZATION_DEFINITIONS
                            WHERE UPPER (ORGANIZATION_code) = UPPER ('LM1');
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              SO_DATA_LINE (I).STATUS := 'E';
                              SO_DATA_LINE (I).ERROR_MSG :=
                                 'Error in Valdating Organzation';
                        END;

                        --
                        BEGIN
                           SELECT INVENTORY_ITEM_ID, PRIMARY_UOM_CODE
                             INTO SO_DATA_LINE (I).ITEM_ID,
                                  SO_DATA_LINE (I).UOM_CODE
                             FROM mtl_system_items_b
                            WHERE LOWER (segment1) =
                                     LOWER (SO_DATA_LINE (I).ITEM_CODE)
                                  AND organization_id =
                                         SO_DATA_LINE (I).SHIP_FROM_ORG_ID
                                  AND PURCHASING_ITEM_FLAG = 'Y'
                                  AND SHIPPABLE_ITEM_FLAG = 'Y'
                                  AND INVENTORY_ITEM_FLAG = 'Y';
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              SO_DATA_LINE (I).STATUS := 'E';
                              SO_DATA_LINE (I).ERROR_MSG :=
                                    SO_DATA_LINE (I).ERROR_MSG
                                 || ' -'
                                 || 'Error in Validating Item';
                        END;


                        BEGIN
                             SELECT SUM (TRANSACTION_QUANTITY)
                               INTO L_TRANSACTION_QUANTITY
                               FROM MTL_ONHAND_QUANTITIES
                              WHERE INVENTORY_ITEM_ID =
                                       SO_DATA_LINE (I).ITEM_ID
                                    AND ORGANIZATION_ID =
                                           SO_DATA_LINE (I).SHIP_FROM_ORG_ID
                           GROUP BY INVENTORY_ITEM_ID;

                           IF L_TRANSACTION_QUANTITY <
                                 SO_DATA_LINE (I).ORDERED_QUANTITY
                           THEN
                              SO_DATA_LINE (I).STATUS := 'E';
                              SO_DATA_LINE (I).ERROR_MSG :=
                                 SO_DATA_LINE (I).ERROR_MSG
                                 || ' - ONHAND QUANITITY FAILED TO SATISFY RESERVATION';
                           END IF;
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              SO_DATA_LINE (I).STATUS := 'E';
                              SO_DATA_LINE (I).ERROR_MSG :=
                                    SO_DATA_LINE (I).ERROR_MSG
                                 || ' -'
                                 || l_err_msg
                                 || SQLCODE
                                 || '-'
                                 || SQLERRM;
                        END;
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           SO_DATA_LINE (I).ERROR_MSG :=
                              'Unexpected Error While VAlidating Line Data '
                              || SQLCODE
                              || '-'
                              || SQLERRM;
                           SO_DATA_LINE (I).STATUS := 'E';
                     END;

                     UPDATE xxaac.xxawr_so_lines_stg
                        SET SHIP_FROM_ORG_ID =
                               SO_DATA_LINE (I).SHIP_FROM_ORG_ID,
                            ITEM_ID = SO_DATA_LINE (I).ITEM_ID,
                            STATUS = SO_DATA_LINE (I).STATUS,
                            ERROR_MSG = SO_DATA_LINE (I).ERROR_MSG,
                            ORGANIZATION_ID = G_ORG_ID,
							creation_date = sysdate ,
				   last_update_Date = sysdate ,
				   created_by    = SO_DATA_HDR (I).created_by ,
				   last_updated_by = NVL(SO_DATA_HDR (I).last_updated_by,
				     SO_DATA_HDR (I).created_by)
                      WHERE STG_HEADER_ID = SO_DATA_LINE (I).STG_HEADER_ID
                            AND SF_LINE_ID = SO_DATA_LINE (I).SF_LINE_ID
                            AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;

                     COMMIT;
                  END LOOP;

                  EXIT WHEN SO_DATA_LINE.COUNT = 0;
               END LOOP;

               CLOSE C_LINES;
            EXCEPTION
               WHEN OTHERS
               THEN
                  SO_DATA_HDR (I).ERROR_MSG :=
                        'Unexcepted Error in Validate Header Data'
                     || SQLCODE
                     || ' - '
                     || SQLERRM;
                  SO_DATA_HDR (I).STATUS := 'E';
            END;

            UPDATE xxaac.xxawr_so_header_stg
               SET payment_term_id = SO_DATA_HDR (I).payment_term_id,
                   ORDERED_TYPE_ID = SO_DATA_HDR (I).ORDERED_TYPE_ID,
                   PRICE_LIST_ID = SO_DATA_HDR (I).PRICE_LIST_ID,
                   SOLD_TO_CUST_ACC_NUM = SO_DATA_HDR (I).SOLD_TO_CUST_ACC_NUM,
                   SOLD_FROM_ORG_ID = G_ORG_ID,
                   ORG_ID = G_ORG_ID,
                   STATUS = SO_DATA_HDR (I).STATUS,
                   ERROR_MSG = SO_DATA_HDR (I).ERROR_MSG,
				   creation_date = sysdate ,
				   last_update_Date = sysdate ,
				   created_by    = SO_DATA_HDR (I).created_by ,
				   last_updated_by = NVL(SO_DATA_HDR (I).last_updated_by,
				     SO_DATA_HDR (I).created_by)
             WHERE     1 = 1
                   AND SF_ORDER_ID = SO_DATA_HDR (I).SF_ORDER_ID
                   AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;

            COMMIT;
         END LOOP;

         EXIT WHEN SO_DATA_HDR.COUNT = 0;
      END LOOP;

      CLOSE C_HEADER;
   -- Change added on 27-04-24


   EXCEPTION
      WHEN OTHERS
      THEN
         l_err_msg :=
               'Unexpected Error In validation_data '
            || '-'
            || SQLCODE
            || '-'
            || SQLERRM;

         UPDATE xxaac.xxawr_so_header_stg
            SET status = 'E', ERROR_MSG = l_err_msg
          WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

         --
         UPDATE xxaac.xxawr_so_lines_stg
            SET status = 'E', ERROR_MSG = l_err_msg
          WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

         --
         UPDATE xxaac.xxawr_so_delvy_instr_stg
            SET status = 'E', ERROR_MSG = l_err_msg
          WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

         --
         COMMIT;
   END validation_data;


   /***************************************************************************************************
    * Program Type      : Package Function.
    * Program Name      : VALIDATE_REQUIRED
    * Language          : PL/SQL
    * Parameter         :
    * S.No      Name               Required     WHAT
    * =======   ================== =========    ======================================================
    * 1         P_OIC_INSTANCE_ID  Y            Interface ID. error message.
    ***************************************************************************************************/

   PROCEDURE validate_required (in_p_oic_instance_id IN VARCHAR2)
   IS
      --> variable declaration
      l_error_msg   VARCHAR2 (1000);
   BEGIN
      /********************************************
        POPULATE ORACLE REF ID
       ********************************************/
      UPDATE xxaac.xxawr_so_header_stg
         SET oracle_ref_id = STG_HEADER_ID
       WHERE     oic_instance_id = in_p_oic_instance_id
             AND status = 'N'
             AND oracle_ref_id IS NULL;

      	  
	   /********************************************
        Validate Oracle User
       ********************************************/
	   
	   UPDATE xxaac.xxawr_so_header_stg
         SET ERROR_MSG = 'Oracle User is Required', STATUS = 'E'
       WHERE     oic_instance_id = in_p_oic_instance_id
           AND ( created_By_Oracle_User IS NULL
		    or lastupdated_By_Oracle_Use is null)
		    

      /********************************************
        Validate Sales Force ID
       ********************************************/

      UPDATE xxaac.xxawr_so_header_stg
         SET ERROR_MSG = 'SalesForce ID is Required', STATUS = 'E'
       WHERE SF_ORDER_ID IS NULL AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;

      /********************************************
        Validate Customer
       ********************************************/

      UPDATE xxaac.xxawr_so_header_stg
         SET ERROR_MSG = ERROR_MSG || ' - ' || 'Customer is Required',
             STATUS = 'E'
       WHERE CUSTOMER_ID IS NULL AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;


      /********************************************
           Validate Salesrep
      ********************************************/

      UPDATE xxaac.xxawr_so_header_stg
         SET ERROR_MSG = ERROR_MSG || ' - ' || 'Oracle Employee is Required',
             STATUS = 'E'
       WHERE ORACLE_EMPLOYEE_NUMBER IS NULL
             AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;


      /********************************************
          Validate Ship to Location
         ********************************************/

      UPDATE xxaac.xxawr_so_header_stg
         SET ERROR_MSG = ERROR_MSG || ' - ' || 'Ship To Location is Required',
             STATUS = 'E'
       WHERE SHIP_TO_LOCATION IS NULL
             AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;

      /********************************************
        Validate Bill To Location
       ********************************************/

      UPDATE xxaac.xxawr_so_header_stg
         SET ERROR_MSG = ERROR_MSG || ' - ' || 'Bill To Location is Required',
             STATUS = 'E'
       WHERE BILL_TO_LOCATION IS NULL
             AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;

      /********************************************
        Validate Order Date
       ********************************************/

      UPDATE xxaac.xxawr_so_header_stg
         SET ERROR_MSG = ERROR_MSG || ' - ' || 'Order Date is Required',
             STATUS = 'E'
       WHERE ORDERED_DATE IS NULL AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;

      /********************************************
        Validate Payment Term
       ********************************************/
      /*
            UPDATE xxaac.xxawr_so_header_stg
               SET ERROR_MSG = ERROR_MSG || ' - ' || 'Payment Term can not be null',
                   STATUS = 'E'
             WHERE PAYMENT_TERM IS NULL AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;
             */

      /********************************************
        Validate Order Type
       ********************************************/

      UPDATE xxaac.xxawr_so_header_stg
         SET ERROR_MSG = ERROR_MSG || ' - ' || 'Order Type is Required',
             STATUS = 'E'
       WHERE ORDER_TYPE_NAME IS NULL
             AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;

      /********************************************
        Validate Currency Code
       ********************************************/

      UPDATE xxaac.xxawr_so_header_stg
         SET ERROR_MSG =
                   ERROR_MSG
                || ' - '
                || 'Transactional Currency Code is Required',
             STATUS = 'E'
       WHERE TRANSACTIONAL_CURR_CODE IS NULL
             AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;


      -- Validate Line Level Data


      /********************************************
       POPULATE ORACLE LINE REF ID
      ********************************************/
      UPDATE xxaac.xxawr_so_lines_stg
         SET ORACLE_LINE_REF_ID = STG_LINE_ID
       WHERE     oic_instance_id = in_p_oic_instance_id
             AND status = 'N'
             AND ORACLE_LINE_REF_ID IS NULL;



      /********************************************
        Validate Order Qty
       ********************************************/

      UPDATE xxaac.xxawr_so_lines_stg
         SET ERROR_MSG = ERROR_MSG || ' - ' || 'Order Qty is Required',
             status = 'E'
       WHERE ORDERED_QUANTITY IS NULL
             AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;

      /********************************************
        Validate Item
       ********************************************/
      UPDATE xxaac.xxawr_so_lines_stg
         SET ERROR_MSG = ERROR_MSG || ' - ' || 'Item CODE is Required',
             status = 'E'
       WHERE ITEM_CODE IS NULL AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;


      /****************************
      * Validate Draft Status SO
      ******************************/

      --Update Delivery Table
      UPDATE xxaac.xxawr_so_delvy_instr_stg
         SET error_msg = 'No Action Required for Draft', status = 'S'
       WHERE UPPER (stg_del_instr_status) = 'DRAFT'
             AND oic_instance_id = IN_P_OIC_INSTANCE_ID;



      -- Commented on 27-03-24

      /*
            UPDATE xxaac.xxawr_so_lines_stg stg_ln
            SET ERROR_MSG =
                         CASE
                         WHEN (SELECT COUNT (1)
                               FROM xxaac.xxawr_so_delvy_instr_stg stg_del
                                WHERE status = 'E'
                                AND stg_del.stg_line_id = stg_ln.stg_line_id
                                AND oic_instance_id = in_p_oic_instance_id) =
                                (SELECT COUNT (1)
                                FROM xxaac.xxawr_so_delvy_instr_stg stg_del
                                WHERE 1 = 1
                                AND stg_del.stg_line_id = stg_ln.stg_line_id
                                AND oic_instance_id = in_p_oic_instance_id)
                          THEN
                            'Delivery Level Error'
                          ELSE
                            NULL
                      END,
                   status =
                          CASE
                          WHEN (SELECT COUNT (1)
                                FROM xxaac.xxawr_so_delvy_instr_stg stg_del
                                WHERE     status = 'E'
                                AND stg_del.stg_line_id = stg_ln.stg_line_id
                                AND oic_instance_id = in_p_oic_instance_id) =
                                (SELECT COUNT (1)
                                FROM xxaac.xxawr_so_delvy_instr_stg stg_del
                                WHERE 1 = 1
                                AND stg_del.stg_line_id = stg_ln.stg_line_id
                                AND oic_instance_id = in_p_oic_instance_id)
                          THEN
                            'E'
                          ELSE
                            'N'
                          END
                          WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

      */

      --Update Header Table

      /*  --commented on 27-04-24
                      UPDATE xxaac.xxawr_so_header_stg stg_hdr
                      SET ERROR_MSG =
                      CASE
                         WHEN (SELECT COUNT (1)
                               FROM xxaac.xxawr_so_lines_stg stg_line
                                WHERE status = 'E'
                                AND stg_line.stg_header_id = stg_hdr.stg_header_id
                                AND oic_instance_id = in_p_oic_instance_id) =
                                (SELECT COUNT (1)
                                FROM xxaac.xxawr_so_lines_stg stg_line
                                WHERE 1 = 1
                                AND stg_line.stg_header_id = stg_hdr.stg_header_id
                                AND oic_instance_id = in_p_oic_instance_id)
                         THEN
                            'Line Level Error'
                         ELSE
                            NULL
                      END,
                   STATUS =
                      CASE
                         WHEN (SELECT COUNT (1)
                               FROM xxaac.xxawr_so_lines_stg stg_line
                               WHERE status = 'E'
                               AND stg_line.stg_header_id = stg_hdr.stg_header_id
                               AND oic_instance_id = in_p_oic_instance_id) =
                               (SELECT COUNT (1)
                               FROM xxaac.xxawr_so_lines_stg stg_line
                               WHERE 1 = 1
                               AND stg_line.stg_header_id = stg_hdr.stg_header_id
                               AND oic_instance_id = in_p_oic_instance_id)
                         THEN
                            'E'
                         ELSE
                            'N'
                      END
                      WHERE OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;

      */



      /********************************************
       POPULATE ORACLE LINE REF ID
      ********************************************/
      UPDATE xxaac.xxawr_so_DELVY_INSTR_stg
         SET ORACLE_DEL_REF_ID = RECORD_ID
       WHERE     oic_instance_id = in_p_oic_instance_id
             AND status = 'N'
             AND ORACLE_DEL_REF_ID IS NULL;


      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_error_msg :=
               'Unexpected Error In validate_required '
            || '-'
            || SQLCODE
            || '-'
            || SQLERRM;

         UPDATE xxaac.xxawr_so_header_stg
            SET status = 'E', ERROR_MSG = l_error_msg
          WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

         --
         UPDATE xxaac.xxawr_so_lines_stg
            SET status = 'E', ERROR_MSG = l_error_msg
          WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

         --
         UPDATE xxaac.xxawr_so_delvy_instr_stg
            SET status = 'E', ERROR_MSG = l_error_msg
          WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

         --
         COMMIT;
   END validate_required;

   --

   /***************************************************************************************************
    * Program Type      : Package Function.
    * Program Name       : GET_DEFUALT_VALUES
    * Language          : PL/SQL
    * Parameter         :
    * S.No      Name               Required     WHAT
    * =======   ================== =========    ======================================================
    * 1         P_ERROR_MSG        Y            Error Message.
    * 2         P_STATUS           Y            Error Status.
    ***************************************************************************************************/
   PROCEDURE get_defualt_values (P_status    OUT VARCHAR2,
                                 p_err_msg   OUT VARCHAR2)
   IS
   BEGIN
      SELECT TO_NUMBER (fl.attribute1),
             (SELECT APPLICATION_ID
                FROM FND_RESPONSIBILITY_VL
               WHERE RESPONSIBILITY_ID = TO_NUMBER (fl.attribute1)),
             TO_NUMBER (fl.attribute2),
             TO_NUMBER (fl.attribute3),
             fl.attribute4,
             TO_NUMBER (fl.attribute5),
             TO_NUMBER (fl.attribute7),
             (SELECT APPLICATION_ID
                FROM FND_RESPONSIBILITY_VL
               WHERE RESPONSIBILITY_ID = TO_NUMBER (fl.attribute7))
        INTO g_resp_id,
             g_resp_app_id,
             g_org_id,
             g_user_id,
             g_debug_flag,
             g_inv_org_id,
             g_resp_id1,
             g_resp_app_id1
        FROM fnd_lookup_VALUES fl
       WHERE fl.lookup_type = 'XXAWR_SF_OIC_LUM_INTG'
             AND fl.enabled_flag = 'Y'
             AND TRUNC (SYSDATE) BETWEEN TRUNC (
                                            NVL (fl.START_DATE_ACTIVE,
                                                 SYSDATE))
                                     AND TRUNC (
                                            NVL (fl.END_DATE_ACTIVE,
                                                 SYSDATE + 1))
             AND fl.attribute1 IS NOT NULL
             AND fl.attribute2 IS NOT NULL
             AND fl.attribute3 IS NOT NULL
             AND fl.attribute4 IS NOT NULL
             AND fl.attribute5 IS NOT NULL
             AND fl.lookup_code = g_integration_name;

      P_status := 'S';
      p_err_msg := NULL;
   EXCEPTION
      WHEN OTHERS
      THEN
         P_status := 'E';
         p_err_msg :=
            'Error in Fetching Default Setup' || SQLCODE || ' - ' || SQLERRM;
         g_resp_id := NULL;
         g_resp_app_id := NULL;
         g_org_id := NULL;
         g_user_id := NULL;
         g_debug_flag := NULL;
         g_inv_org_id := NULL;
   END get_defualt_values;

   --

   /***************************************************************************************************
    * Program Type      : Package Function.
    * Program Name      : LOAD_STG_DATA
    * Language          : PL/SQL
    * Parameter         :
    * S.No      Name               Required     WHAT
    * =======   ================== =========    ======================================================
    * 1         P_OIC_INSTANCE_ID  Y            Interface ID. error message.
    * 2         P_ERROR_MSG        Y            Error Message.
    * 3         P_STATUS           Y            Error Status.
    ***************************************************************************************************/
   --

   PROCEDURE load_stg_data (IN_P_OIC_INSTANCE_ID   IN     VARCHAR2,
                            out_status                OUT VARCHAR2,
                            out_error_msg             OUT VARCHAR2)
   IS
      l_count       NUMBER;
      l_status      VARCHAR2 (200);
      l_error_msg   VARCHAR2 (2000);
   BEGIN
      out_status := 'S';
      out_error_msg := NULL;


      --Checking interface data (all three tables are populated for Sales Order or not)

      /*SELECT COUNT (1)
        INTO L_COUNT
        FROM XXAAC.xxawr_so_header_intf hdr,
             XXAAC.xxawr_so_lines_intf lne,
             XXAAC.xxawr_so_delvy_instr_intf delv
       WHERE     1 = 1
             AND hdr.STG_HEADER_ID = lne.STG_HEADER_ID
             AND lne.STG_LINE_ID = delv.STG_LINE_ID
             AND hdr.STG_HEADER_ID = delv.STG_HEADER_ID
             AND hdr.OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;
             */


      BEGIN
         INSERT INTO xxaac.xxawr_so_header_stg
            SELECT *
              FROM XXAAC.xxawr_so_header_intf
             WHERE OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;
      EXCEPTION
         WHEN OTHERS
         THEN
            out_status := 'E';
            out_error_msg :=
                  'Error while inserting data in header table - '
               || SQLCODE
               || '~'
               || SQLERRM;
      END;

      BEGIN
         INSERT INTO xxaac.xxawr_so_lines_stg
            SELECT *
              FROM XXAAC.xxawr_so_lines_intf
             WHERE OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;
      EXCEPTION
         WHEN OTHERS
         THEN
            out_status := 'E';
            out_error_msg :=
                  'Error while inserting data in line table - '
               || SQLCODE
               || '~'
               || SQLERRM;
      END;

      BEGIN
         INSERT INTO xxaac.xxawr_so_delvy_instr_stg
            SELECT *
              FROM XXAAC.xxawr_so_delvy_instr_intf
             WHERE OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;
      EXCEPTION
         WHEN OTHERS
         THEN
            out_status := 'E';
            out_error_msg :=
                  'Error while inserting data in delivery table - '
               || SQLCODE
               || '~'
               || SQLERRM;
      END;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_status := 'E';
         l_error_msg :=
               'Error while inserting data to staging table - '
            || SQLCODE
            || '~'
            || SQLERRM;
   END load_stg_data;

   --

   /***************************************************************************************************
    * Program Type      : Package Function.
    * Program Name      : MAIN
    * Language          : PL/SQL
    * Parameter         :
    * S.No      Name               Required     WHAT
    * =======   ================== =========    ======================================================
    * 1         P_OIC_INSTANCE_ID  Y            Interface ID. error message.
    * 2         P_ERROR_MSG        Y            Error Message.
    * 3         P_STATUS           Y            Error Status.
    ***************************************************************************************************/
   --

   PROCEDURE main (in_p_oic_instance_id   IN     VARCHAR2,
                   out_p_status              OUT VARCHAR2,
                   out_p_error_message       OUT VARCHAR2)
   IS
      --Declaring local variables
      L_return_status    VARCHAR2 (2);
      L_return_message   VARCHAR2 (1000);
      L_status           VARCHAR2 (3);
      L_err_msg          VARCHAR2 (4000);

      L_status_ins       VARCHAR2 (200);
      L_error_ins        VARCHAR2 (2000);
   BEGIN
      --
      g_request_id := 0;


      /***********************************
       * Load Staging Data
       ***********************************/
      l_status := NULL;
      l_err_msg := NULL;
      --


      load_stg_data (in_p_oic_instance_id   => in_p_oic_instance_id,
                     out_status             => L_status,
                     out_error_msg          => L_err_msg);

      IF L_status = 'E'
      THEN
         out_p_status := L_status;
         out_p_error_message := L_err_msg;
      ELSE
         l_status := NULL;
         l_err_msg := NULL;

         /***********************************
          * Get Default Values
          ***********************************/

         get_defualt_values (P_status => l_status, P_ERR_MSG => L_err_msg);



         IF l_status = 'E'
         THEN
            --
            /***********************************
             * Update table with headers.
             ***********************************/

            UPDATE xxaac.xxawr_so_header_stg
               SET status = l_status, ERROR_MSG = L_err_msg
             WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

            --
            UPDATE xxaac.xxawr_so_lines_stg
               SET status = l_status, ERROR_MSG = L_err_msg
             WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

            --
            UPDATE xxaac.xxawr_so_delvy_instr_stg
               SET status = l_status, ERROR_MSG = L_err_msg
             WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;



            COMMIT;
         ELSE
            --
            /***********************************
             * Validate Required Columns.
             ***********************************/
            --

            validate_required (IN_P_OIC_INSTANCE_ID => IN_P_OIC_INSTANCE_ID);

            /***********************************
             * Calling data wrapping
             ***********************************/

            data_wrapping (IN_P_OIC_INSTANCE_ID => IN_P_OIC_INSTANCE_ID);

            /***********************************
             * Validate Staging Data.
             ***********************************/
            --
            validation_data (IN_P_OIC_INSTANCE_ID => IN_P_OIC_INSTANCE_ID);

            /***********************************
             * Calling data wrapping
             ***********************************/

            data_wrapping (IN_P_OIC_INSTANCE_ID => IN_P_OIC_INSTANCE_ID);

            --
            l_status := NULL;
            l_err_msg := NULL;

            SELECT status, ERROR_MSG
              INTO l_status, l_err_msg
              FROM xxaac.xxawr_so_header_stg
             WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

            IF l_status = 'E'
            THEN
               out_p_status := 'E';
               out_p_error_message := l_err_msg;
            ELSE
               --

               /***********************************
                * Submit Sales Order Creation.
                ***********************************/
               print_log ('User Id- ' || g_user_id);
               print_log ('REsp Id- ' || g_resp_id);
               print_log ('REsp Appl Id- ' || g_resp_app_id);
               print_log ('Org Id- ' || G_ORG_ID);

               FND_GLOBAL.APPS_INITIALIZE (g_user_id,
                                           g_resp_id,
                                           g_resp_app_id);
               MO_GLOBAL.INIT ('ONT');
               MO_GLOBAL.SET_POLICY_CONTEXT ('S', G_ORG_ID);

               g_request_id :=
                  FND_REQUEST.SUBMIT_REQUEST (
                     application   => 'XXAAC',
                     program       => 'XXAWRL_SF_OIC_SO_CREATION',
                     description   => 'XXAWRL SF OIC Sales Order Creation Process',
                     start_time    => SYSDATE,
                     sub_request   => NULL,
                     argument1     => IN_P_OIC_INSTANCE_ID);

               COMMIT;

               IF g_request_id = 0
               THEN
                  out_p_status := 'E';
                  out_p_error_message :=
                     'Error while submitting Sales Order Creation Process';

                  /***********************************
                     * Update table with headers.
                     ***********************************/

                  UPDATE xxaac.xxawr_so_header_stg
                     SET status = out_p_status, ERROR_MSG = L_err_msg
                   WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

                  --
                  UPDATE xxaac.xxawr_so_lines_stg
                     SET status = out_p_status,
                         ERROR_MSG = out_p_error_message
                   WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

                  --
                  UPDATE xxaac.xxawr_so_delvy_instr_stg
                     SET status = out_p_status,
                         ERROR_MSG = out_p_error_message
                   WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;
               ELSE
                  out_p_status := 'S';
                  out_p_error_message :=
                     'Sales Order Creation Process is submitted Successfully'
                     || g_request_id;

                  UPDATE xxaac.xxawr_so_header_stg
                     SET status = 'S',
                         ERROR_MSG =
                            'Sales Order Creation Process is submitted Successfully'
                            || g_request_id,
                         request_id = g_request_id
                   WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

                  --
                  UPDATE xxaac.xxawr_so_lines_stg
                     SET status = 'S',
                         ERROR_MSG =
                            'Sales Order Creation Process is submitted Successfully'
                            || g_request_id,
                         request_id = g_request_id
                   WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

                  --
                  UPDATE xxaac.xxawr_so_delvy_instr_stg
                     SET status = 'S',
                         ERROR_MSG =
                            'Sales Order Creation Process is submitted Successfully'
                            || g_request_id,
                         request_id = g_request_id
                   WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;
               END IF;
            END IF;
         END IF;
     
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         out_p_status := 'E';
         out_p_error_message :=
            'Unexcepted Error in Main Process - ' || SQLCODE || SQLERRM;

         UPDATE xxaac.xxawr_so_header_stg
            SET status = out_p_status, ERROR_MSG = out_p_error_message
          WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

         --
         UPDATE xxaac.xxawr_so_lines_stg
            SET status = out_p_status, ERROR_MSG = out_p_error_message
          WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

         --
         UPDATE xxaac.xxawr_so_delvy_instr_stg
            SET status = out_p_status, ERROR_MSG = out_p_error_message
          WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

         --
         COMMIT;

         print_log (out_p_error_message);
   END main;

   --

   /***************************************************************************************************
    * Program Type      : Package Function.
    * Program Name      : SALES_ORDER_CREATION
    * Language          : PL/SQL
    * Parameter         :
    * S.No      Name               Required     WHAT
    * =======   ================== =========    ======================================================
    * 1         P_OIC_INSTANCE_ID  Y            Interface ID. error message.
    ***************************************************************************************************/


   PROCEDURE SALES_ORDER_CREATION (X_ERRBUF                  OUT VARCHAR2,
                                   X_RETCODE                 OUT NUMBER,
                                   IN_P_OIC_INSTANCE_ID   IN     VARCHAR2)
   IS
   BEGIN
      fnd_file.put_line (fnd_file.LOG, 'Coming to Run Wrapper Program');
   --wrapper_program (in_p_oic_instance_id);

   EXCEPTION
      WHEN OTHERS
      THEN
         X_ERRBUF :=
            'Unexcepted Error in Main Process - ' || SQLCODE || SQLERRM;

         X_RETCODE := 2;



         UPDATE xxaac.xxawr_so_header_stg
            SET status = 'E', ERROR_MSG = X_ERRBUF
          WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

         --
         UPDATE xxaac.xxawr_so_lines_stg
            SET status = 'E', ERROR_MSG = X_ERRBUF
          WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

         --
         UPDATE xxaac.xxawr_so_delvy_instr_stg
            SET status = 'E', ERROR_MSG = X_ERRBUF
          WHERE OIC_INSTANCE_ID = in_p_oic_instance_id;

         --
         COMMIT;

   END SALES_ORDER_CREATION;
END XXAWR_SO_SF_OIC_PKG;