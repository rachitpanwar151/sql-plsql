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
      IF g_debug_flag = 'YES'
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
	  
	  CURSOR C_DEL (
         IN_STG_HEADER_ID IN VARCHAR2,
		 IN_STG_LINE_ID IN VARCHAR2)
      IS
         SELECT *
           FROM xxaac.xxawr_so_delvy_instr_stg
          WHERE     1 = 1
                AND STATUS = 'N'
                AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                AND STG_HEADER_ID   = IN_STG_HEADER_ID
				AND STG_LINE_ID     = IN_STG_LINE_ID;


      TYPE CUR_SO_DATA_TYPE_DEL IS TABLE OF C_DEL%ROWTYPE
                                       INDEX BY PLS_INTEGER;

      SO_DATA_DEL             CUR_SO_DATA_TYPE_DEL;



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
   --
   
      /********************************************
       * HEADER LEVEL CUSROR
       ********************************************/
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
			   
			   
			   --
			   



                /********************************************
                 * LINE LEVEL CUSROR
                 ********************************************/


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

						/******************************************
                         * Ship from Org
                         ******************************************/
                        
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

                        /******************************************
                         * Item Validation 
                         ******************************************/
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
						
						/******************************************
                         * Item Qty Validation 
                         ******************************************/


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
                     
					 
					 /********************************************
                      * DELIVERY LEVEL CUSROR
                      ********************************************/
					 
					OPEN C_DEL;

					LOOP
					FETCH C_DEL
					BULK COLLECT INTO SO_DATA_DEL
						LIMIT 500;

					print_log (
						'INSIDE FETCH VALIDATION' || SO_DATA_DEL.COUNT);

						FOR I IN 1 .. SO_DATA_DEL.COUNT
						LOOP
						BEGIN 
						
						SO_DATA_DEL (I).STATUS := 'V';
                        SO_DATA_DEL (I).ERROR_MSG := '';
						
						BEGIN
                       SELECT organization_id
                       INTO INV_RES_TBL (indx).organization_id
                       FROM org_organization_definitions
                       WHERE LOWER (organization_name) =
                               LOWER (G_ORGANIZATION_NAME);
                               
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        SO_DATA_DEL (I).ERROR_MSG :=
                              SO_DATA_DEL (I).ERROR_MSG
                           || ' - '
                           || 'Organization not exist';
                        SO_DATA_DEL (I).STATUS := 'E';
                  END;
						
						/******************************************
                         * UNRESERVE VALIDATION 
                         ******************************************/
						 
						 if UPPER (SO_DATA_DEL (I).stg_del_instr_status) = 'BOOKED'
						 then 
						 
						 SELECT count(1) into l_count
						 FROM OE_ORDER_HEADERS_ALL
						  WHERE ORG_ID  = 
						  and GLOBAL_ATTRIBUTE1 = SO_DATA_DEL (I).sf_id
						  and GLOBAL_ATTRIBUTE2 = SO_DATA_HDR (I).header_ref_id
						  exits ( select 1 oe_order_lines_all 
						            where ol.header_id = oh.Header
									and GLOBAL_ATTRIBUTE1 = SO_DATA_DEL (I).oracle_del_ref_id
									and GLOBAL_ATTRIBUTE2 = SO_DATA_DEL (I).sf_del_id 
									and GLOBAL_ATTRIBUTE2 = SO_DATA_line (I).oracle_line_ref_id
									);
									
									if l_count >0 
									then 
									 SO_DATA_DEL (I).ERROR_MSG :=
										'Order Already Exist'
										|| SQLCODE
										|| '-'
									|| SQLERRM;
										SO_DATA_DEL (I).STATUS := 'E';
									end if;
									
									BEGIN 
									select MAX(STG.reservervation_id) 
									INTO SO_DATA_DEL (I).reservervation_id
									from xxaac.xxawr_so_delvy_instr_stg STG
									where 1=1
									AND oracle_del_ref_id = 
									SO_DATA_DEL (I).oracle_del_ref_id
									and sf_order_id = SO_DATA_DEL (I).sf_order_id
									AND STATUS ='P'
									AND EXISTS
										(SELECT 1
										FROM mtl_reservations mr
										WHERE mr.reservation_id = stg_del.reservation_id);
										
									EXCEPTION 
									WHEN OTHERS 
									THEN 
									SO_DATA_DEL (I).reservervation_id := NULL;
									END IF;						
					              END IF;
						 
						 if UPPER (SO_DATA_DEL (I).stg_del_instr_status) = 'CANCEL'
						 then 
						 BEGIN 
						 SELECT HEADER_ID into SO_DATA_DEL (I).ORACLE_ORDER_HEADER_ID
						 FROM OE_ORDER_HEADERS_ALL
						  WHERE ORG_ID  = 
						  and GLOBAL_ATTRIBUTE1 = SO_DATA_DEL (I).sf_id
						  and GLOBAL_ATTRIBUTE2 = SO_DATA_HDR (I).oracle_ref_id
						  AND exits ( select 1 oe_order_lines_all 
						            where ol.header_id = oh.Header
									and GLOBAL_ATTRIBUTE1 = SO_DATA_DEL (I).oracle_del_ref_id
									and GLOBAL_ATTRIBUTE2 = SO_DATA_DEL (I).sf_del_id 
									and GLOBAL_ATTRIBUTE2 = SO_DATA_line (I).oracle_line_ref_id
									);
						EXCEPTION 
						WHEN OTHERS 
						
						END;
						 
						 END IF;
						 
						 if UPPER (SO_DATA_DEL (I).stg_del_instr_status) = 'RESERVE'
						 then 
						 
						 END IF;
						 
						 if UPPER (SO_DATA_DEL (I).stg_del_instr_status) = 'UNRESERVE'
						 then 
						 
						 END IF;
						 
						 /*********************************
                          * VALIDATING Transaction Source
                          *********************************/
						  
						 if UPPER (SO_DATA_DEL (I).stg_del_instr_status) in
						 (
						 'UNRESERVE' ,'RESERVE')
						 then 
						 
						   BEGIN 
						   SELECT transaction_source_type_id
							 INTO SO_DATA_DEL(I).demand_source_id
						   FROM MTL_TXN_SOURCE_TYPES
						   WHERE 1 = 1
							AND transaction_source_type_name =
								   'AWRL SF Orders Reservations';
						   EXCEPTION 
						   WHEN OTHERS 
						    SO_DATA_DEL (I).ERROR_MSG :=
                              'Invalid Transaction Type Source'
                              || SQLCODE
                              || '-'
                              || SQLERRM;
                            SO_DATA_DEL (I).STATUS := 'E';
						   END;
						 
						 end if;
						 
						 EXCEPTION
                        WHEN OTHERS
                        THEN
                           SO_DATA_DEL (I).ERROR_MSG :=
                              'Unexpected Error While Validating Delivery Data '
                              || SQLCODE
                              || '-'
                              || SQLERRM;
                           SO_DATA_DEL (I).STATUS := 'E';
                         END;
						 
						   UPDATE xxaac.xxawr_so_delvy_instr_stg
                        SET STATUS = SO_DATA_DEL (I).STATUS,
                            ERROR_MSG = SO_DATA_DEL (I).ERROR_MSG,
							demand_source_id = SO_DATA_DEL(I).demand_source_id ,
                            creation_date = sysdate ,
				   last_update_Date = sysdate ,
				   created_by    = SO_DATA_HDR (I).created_by ,
				   last_updated_by = NVL(SO_DATA_HDR (I).last_updated_by,
				     SO_DATA_HDR (I).created_by)
                      WHERE STG_DEL_INSTR_ID = SO_DATA_DEL (I).STG_DEL_INSTR_ID
                            AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;
						 
			   
                         END LOOP;
						
						COMMIT;
                        END LOOP;

                       EXIT WHEN SO_DATA_DEL.COUNT = 0;
                       END LOOP;

                     CLOSE C_DEL;
					 
					 
					 EXCEPTION
                        WHEN OTHERS
                        THEN
                           SO_DATA_LINE (I).ERROR_MSG :=
                              'Unexpected Error While Validating Line Data '
                              || SQLCODE
                              || '-'
                              || SQLERRM;
                           SO_DATA_LINE (I).STATUS := 'E';
                     END;
					 
					
					 
			         /********************************************
                      * END DELIVERY LEVEL CUSROR
                      ********************************************/

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
			   --
			   /********************************************
                * END LINE LEVEL CUSROR
                ********************************************/
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
	  /********************************************
       * END HEADER LEVEL CUSROR
       ********************************************/
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
         SET error_msg = 'No Action Required for Draft', status = 'X'
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
      UPDATE xxaac.xxawr_so_delvy_instr_stg
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
    * Program Name      : DELETE_INTERFACE_DATA
    * Language          : PL/SQL
    * Parameter         :
    * S.No      Name               Required     WHAT
    * =======   ================== =========    ======================================================
    * 1         P_OIC_INSTANCE_ID  Y            Interface ID.
    ***************************************************************************************************/
  
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
	   --
	  /***********************************
       * Load Header Data
       ***********************************/

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
	  --
	  
	  /***********************************
       * Load Line Data
       ***********************************/

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
	  --
	  
	  /***********************************
       * Load Delivery Level Data
       ***********************************/

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
	  
	  /***********************************
       * Delete Interface Data
       ***********************************/
	  
	  delete_interface_data (in_p_oic_instance_id => IN_P_OIC_INSTANCE_ID);
	  
	  COMMIT;

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
   
   /*******************************************************************************************************************
   * Program Name   :
   * Language       : PL/SQL
   * Description    : Procedure To Create Sales Order
   * History        :
   * WHO              WHAT                                                          WHEN
   * --------------   -------------------------------------------------------       --------------
   *                    Procedure To Create Sales Order                                 2024
   *******************************************************************************************************************/

   PROCEDURE sales_order_create  ( in_p_oic_instance_id IN VARCHAR2,
                                   ou_p_status         OUT VARCHAR2,
								   ou_p_err_msg        OUT VARCHAR2)
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
				XSDIS.stg_del_instr_status,
                XSDIS.RECORD_ID,
                XSLS.STG_LINE_ID,
                xsls.LINE_VAT_AMOUNT,
                xsls.LPO_NUMBER,
                XSDIS.SF_LINE_NUM,
                XSDIS.schedule_ship_date,
                XSLS.unit_selling_price,
                xsls.discount,
				xsdis.oracle_order_header_id,
				xsdis.oracle_order_line_id
           FROM xxaac.xxawr_so_lines_stg XSLS,
                xxaac.xxawr_so_delvy_instr_stg XSDIS
          WHERE 1 = 1 AND UPPER (XSLS.STATUS) IN ('V')--, 'S')
                AND UPPER (XSDIS.STG_DEL_INSTR_STATUS) IN
                       ('RESERVE', 'BOOKED')
                AND XSLS.STG_HEADER_ID = XSDIS.STG_HEADER_ID
                AND XSLS.STG_LINE_ID = XSDIS.STG_LINE_ID
                AND XSLS.STG_HEADER_ID = IN_STG_HEADER_ID
                AND XSLS.OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
				AND NOT EXIST(SELECT 1
				                FROM oe_order_headers_all h,
								     oe_order_lines_all l
							   WHERE 1=1--h.header_id = l.header_id
							     AND h.header_id = xsdis.oracle_order_header_id
								 AND l.line_id = xsdis.oracle_order_line_id
								-- AND l.flow_status_code IN ('ENTERED','BOOKED')
								);
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
		 --L_HEADER_REC.GLOBAL_ATTRIBUTE_CATEGORY := 'AWR Lumina SF Order';
         L_HEADER_REC.GLOBAL_ATTRIBUTE1 := REC_HEADER.SF_ID;
         L_HEADER_REC.GLOBAL_ATTRIBUTE2 := REC_HEADER.HEADER_REF_ID;
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
			--L_LINE_TBL (L_LINE_TBL_INDEX).GLOBAL_ATTRIBUTE_CATEGORY := 'AWR Lumina SF Order';
            L_LINE_TBL (L_LINE_TBL_INDEX).GLOBAL_ATTRIBUTE1 :=
               REC_LINE.stg_del_instr_id;
            L_LINE_TBL (L_LINE_TBL_INDEX).GLOBAL_ATTRIBUTE2 :=
               REC_LINE.sf_del_id;
            L_LINE_TBL (L_LINE_TBL_INDEX).GLOBAL_ATTRIBUTE3 :=
               REC_LINE.oracle_del_ref_id;
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
			OU_P_STATUS := 'C';
			OU_P_ERR_MSG := NULL;
            /*SALES_ORDER_BOOKING (IN_P_OIC_INSTANCE_ID,
                                 X_HEADER_REC.HEADER_ID,
                                 L_STATUS,
                                 L_err_msg);*/
         

                      
                      -------------updating lines 
                      
                     /* UPDATE xxaac.xxawr_so_lines_stg stg_line
                      SET --STATUS = 'C', 
                          oracle_order_header_id = X_HEADER_REC.HEADER_ID,
                          oracle_order_number = (SELECT order_number
                                                   FROM oe_order_headers_all oe_h
                                                  WHERE oe_h.header_id = x_header_rec.header_id)
                          oracle_line_id = (SELECT line_id
                                              FROM oe_order_lines_all oe_l
                                             WHERE oe_l.header_id = x_header_rec.header_id
                                               AND stg_line.oracle_line_number =oe_l.line_number),  
                          oracle_line_status =
										   (SELECT flow_STATUS_code
										      FROM oe_order_lines_all oe_l
										     WHERE oe_l.header_id = x_header_rec.header_id
										       AND stg_line.oracle_line_number =oe_l.line_number)
                      WHERE     1 = 1
                      AND stg_line.oic_instance_id = in_p_oic_instance_id
                      AND stg_header_id = rec_header.stg_header_id
					  AND status = 'V'
                      AND EXISTS
                              (SELECT 1
								 FROM xxaac.xxawr_so_delvy_instr_stg stg_del
							    WHERE stg_line.STG_line_ID = stg_del.stg_line_id
								  AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
								  AND stg_line.stg_header_id = stg_del.STG_HEADER_ID
								  AND UPPER (stg_del.stg_del_instr_status) in ('RESERVE','BOOKED'));*/

               --------- Update Delivery


               FOR rec_line_c IN C_LINES (REC_HEADER.STG_HEADER_ID)
               LOOP
                  UPDATE xxaac.xxawr_so_delvy_instr_stg stg_del
                     SET 
                         oracle_order_header_id = x_header_rec.header_id,
                         oracle_order_number = x_header_rec.order_number,
						 --oracle_order_status = X_HEADER_REC.flow_status_code,
                         -- Booking_flag = 'Y',
                         oracle_order_line_id =
                            (SELECT line_id
                               FROM oe_order_lines_all oe_l
                              WHERE oe_l.header_id = X_HEADER_REC.HEADER_ID
                                    AND oe_l.global_attribute1 =
                                           rec_line_c.stg_del_instr_id)
                   WHERE     1 = 1
                         AND oic_instance_id = in_p_oic_instance_id
						 AND status = 'V'
                         AND stg_header_id = rec_header.stg_header_id
                         AND UPPER (stg_del_instr_status) in ('RESERVE','BOOKED')
                         AND stg_del.record_id = rec_line_c.record_id;
                END LOOP;
           

            COMMIT;

         ELSE
		    OU_P_STATUS := 'E';
			OU_P_ERR_MSG := 'Order creation failed';
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
                                     AND UPPER (stg_del.STG_DEL_INSTR_STATUS)
                                            IN ('RESERVE','BOOKED'));

               --Delivery
               UPDATE xxaac.xxawr_so_delvy_instr_stg
                  SET STATUS = 'E',
                      error_msg =
                         'Error in creating Sales Order - ' || L_err_msg
                WHERE     1 = 1
                      AND oic_instance_id = in_p_oic_instance_id
                      AND stg_header_id = rec_header.stg_header_id
                      AND UPPER (stg_del_instr_status) IN ('RESERVE','BOOKED');
            END IF;

               COMMIT;
            END;
         END IF;
      END LOOP;    ---REC_HEADER
   EXCEPTION
      WHEN OTHERS
      THEN
         ou_p_status  := 'E';
         ou_p_err_msg :=
               'Error while inserting data to staging table - '
            || SQLCODE
            || '~'
            || SQLERRM;
   END sales_order_create;
   ----

   /*******************************************************************************************************************
   * Program Name   : SALES_ORDER_BOOKING
   * Language       : PL/SQL
   * Description    : Procedure To book sales order
   * History        :
   * WHO              WHAT                                                          WHEN
   * --------------   -------------------------------------------------------       --------------
   *                        BOOKING SALES ORDER                                            2024
   *******************************************************************************************************************/
   PROCEDURE sales_order_booking (in_p_oic_instance_id      IN     VARCHAR2,
                                  --IN_P_OE_HDR_ID         IN      VARCHAR2,
                                  out_p_status              OUT    VARCHAR2,
                                  out_p_err_msg             OUT    VARCHAR2)
   AS
   
    CURSOR c_book
	IS
	SELECT DISTINCT d.oracle_order_header_id
	  FROM xxaac.xxawr_so_delvy_instr_stg d
	 WHERE oic_instance_id = in_p_oic_instance_id
	   AND d.stg_del_instr_status = 'BOOKED'
	   AND d.status = 'V'
	   AND EXISTS (SELECT 1
					 FROM oe_order_headers_all h,
						  oe_order_lines_all l
				    WHERE h.header_id = l.header_id
					  AND h.header_id = d.oracle_order_header_id
					  AND l.line_id = d.oracle_order_line_id
					  AND l.flow_status_code IN ('ENTERED')
				   );
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
     FOR rec_book IN c_book 
	   LOOP
      DBMS_OUTPUT.PUT_LINE (
         'Sales Order Booking Process Started. Header ID - '
         || rec_book.oracle_order_header_id);

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
      V_ACTION_REQUEST_TBL (1).ENTITY_ID := rec_book.oracle_order_header_id;      --- header_id
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
         out_p_status := v_return_status;
         out_p_err_msg := null;
      ELSE
         DBMS_OUTPUT.PUT_LINE (
               'Booking of an Existing Order failed:'
            || V_RETURN_STATUS
            || ' ~ '
            || V_MSG_DATA);
         out_p_status := v_return_status;
		 out_p_err_msg := 'Error in booking of Sales Order';

         FOR I IN 1 .. V_MSG_COUNT
         LOOP
            V_MSG_DATA := OE_MSG_PUB.GET (P_MSG_INDEX => I, P_ENCODED => 'F');
         END LOOP;

         OUT_P_ERR_MSG := V_MSG_DATA;
         ROLLBACK;
		 
		 UPDATE xxaac.xxawr_so_header_stg
			SET status='E',
			    error_msg='Sales Order booking is unsuccessful'||OUT_P_ERR_MSG
		  WHERE 1=1
		    AND oic_instance_id = in_p_oic_instance_id;


		 UPDATE xxaac.xxawr_so_lines_stg
		    SET status='E',
		        error_msg='Sales Order booking is unsuccessful'||OUT_P_ERR_MSG
		  WHERE 1=1
		    AND oic_instance_id = in_p_oic_instance_id;

         UPDATE xxaac.xxawr_so_delvy_instr_stg
            SET status = 'E',
                error_msg ='booking unscuccessful '||OUT_P_ERR_MSG
          WHERE 1=1
            AND oic_instance_id = in_oic_p_instance_id;
      END IF;
	 
	 COMMIT;
	 
	END LOOP;

   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.PUT_LINE (
               'Error in Sales Order Booking process: '
            || SQLCODE
            || ' ~ '
            || SQLERRM);
   END sales_order_booking;
   ----
   
      /***************************************************************************************************
    * Object Name       : CREATE_RESERVATION_API_PRC
    * Program Type      : Package Procedure.
    * Language          : PL/SQL
    * Parameter        :
    * S.No      Name               Required     WHAT
    * =======   ================== =========    =======================================================
    * 1         CREATE_RESERVATION     Y            OIC_INSTANCE_ID
    ***************************************************************************************************
    * History      :
    * WHO              Version #   WHEN            WHAT
    * ===============  =========   =============   ====================================================
    *                   1.0         14-Jan-2024
    ***************************************************************************************************/

   PROCEDURE create_reservation(in_p_oic_instance_id IN VARCHAR2,
                                 ou_p_status  OUT VARCHAR2, 
                                 ou_p_err_msg OUT VARCHAR2)
IS
   p_rsv                     inv_reservation_global.mtl_reservation_rec_type;
   p_dummy_sn                inv_reservation_global.serial_number_tbl_type;
   x_msg_count               NUMBER;
   x_msg_data                VARCHAR2(240);
   x_rsv_id                  NUMBER;
   x_dummy_sn                inv_reservation_global.serial_number_tbl_type;
   x_status                  VARCHAR2(1);
   x_qty                     NUMBER ;
   x_return_STATUS           VARCHAR2 (1);
  
   
   CURSOR c_reserve
   is
   SELECT D.*,E.ITEM_ID
     FROM xxaac.xxawr_so_del_instr_stg d ,
          xxaac.xxawr_so_lines_stg e
    WHERE d.oic_instance_id = in_p_oic_instance_id
      AND d.stg_line_id = e.stg_line_id
      AND d.stg_header_id = e.stg_header_id
      AND d.stg_del_instr_status = 'RESERVE'
      AND d.status = 'V'
      AND EXISTS (SELECT 1
                    FROM oe_order_headers_all h,
                         oe_order_lines_all l 
                   WHERE h.header_id = d.oracle_order_header_id
                     AND L.line_id = d.oracle_order_line_id
                     AND l.flow_status_code = 'ENTERED'
                     AND h.flow_status_code = 'ENTERED'
                  );
                  
   TYPE t_reserve IS TABLE OF c_reserve%ROWTYPE INDEX BY PLS_INTEGER;
   v_reserve t_reserve;
  
     lv_subinv_code            VARCHAR2 (30);
   

  BEGIN
   OPEN c_reserve;
   FETCH c_reserve BULK COLLECT INTO v_reserve;
     FOR indx IN 1..v_reserve.COUNT
            LOOP   
   --These value will be fetched from cursor 
  
   
BEGIN
   FND_GLOBAL.APPS_INITIALIZE (g_user_id, g_resp_id, g_resp_app_id);  ---to_be updated

   p_rsv.requirement_date            := NVL(v_reserve(INDX).requirement_date, SYSDATE+7);
   p_rsv.organization_id             := g_inv_org_id   ; --mtl_parameters.organization id
   p_rsv.inventory_item_id           := v_reserve(INDX).item_id;--mtl_system_items.Inventory_item_id;
   p_rsv.demand_source_type_id       := inv_reservation_global.g_source_type_oe; -- which is 2 in  MTL_TXN_SOURCE_TYPES.TRANSACTION_SOURCE_TYPE_ID
   p_rsv.demand_source_name          := NULL;
   p_rsv.demand_source_header_id     := v_reserve(INDX).oracle_order_header_id;      --1334166 ; --mtl_sales_orders.sales_order_id
   p_rsv.demand_source_line_id       := v_reserve(INDX).oracle_order_line_id;        --48067;--4912468 ; -- oe_order_lines.line_id
   p_rsv.primary_uom_code            := v_reserve(INDX).uom_code;     --'Ea';
   p_rsv.primary_uom_id              := NULL;
   p_rsv.reservation_uom_code        := NULL;
   p_rsv.reservation_uom_id          := NULL;
   p_rsv.reservation_quantity        := v_reserve(INDX).quantity_to_be_delivered;
   p_rsv.primary_reservation_quantity := v_reserve(INDX).quantity_to_be_delivered;--null;
   p_rsv.lot_number                  := NULL;--p_lot_number;
   p_rsv.locator_id                  := NULL;
   p_rsv.supply_source_type_id       := inv_reservation_global.g_source_type_inv;
   p_rsv.ship_ready_flag             := NULL;
   p_rsv.primary_uom_id              := NULL;
   p_rsv.reservation_uom_id          := NULL;
   p_rsv.subinventory_code           :=  NULL;  --'102';
   p_rsv.subinventory_id             :=  NULL;
   p_rsv.attribute15                 :=   NULL ;
   p_rsv.attribute14                 :=   NULL ;       
   p_rsv.attribute13                 :=   NULL ;
   p_rsv.attribute12                 :=   NULL ;
   p_rsv.attribute11                 :=   NULL ; 
   p_rsv.attribute10                 :=   NULL ;
   p_rsv.attribute9                  :=   NULL ;     
   p_rsv.attribute8                  :=   NULL ; 
   p_rsv.attribute7                  :=   NULL ;
   p_rsv.attribute6                  :=   NULL ; 
   p_rsv.attribute5                  :=   NULL ;      
   p_rsv.attribute4                  :=   NULL ;  
   p_rsv.attribute3                  :=   NULL ;
   p_rsv.attribute2                  :=   NULL ;  
   p_rsv.attribute1                  :=   NULL ;  
   p_rsv.attribute_category          :=   NULL ;
   p_rsv.lpn_id                      :=   NULL ;
   p_rsv.pick_slip_number            :=   NULL ;
   p_rsv.lot_number_id               :=   NULL ;
   p_rsv.revision                    :=   NULL ;
   p_rsv.external_source_line_id     :=   NULL ;     
   p_rsv.external_source_code        :=   NULL ;     
   p_rsv.autodetail_group_id         :=   NULL ;    
   p_rsv.reservation_uom_id          :=   NULL ;    
   p_rsv.primary_uom_id              :=   NULL ;   
   p_rsv.demand_source_delivery      :=   NULL ;
   p_rsv.supply_source_line_detail   :=   NULL;
   p_rsv.supply_source_name          :=   NULL;
   p_rsv.supply_source_header_id     :=   NULL; 
   p_rsv.supply_source_line_id       :=   NULL;   
     
   inv_reservation_pub.create_reservation
   (
        p_api_version_number       =>       1.0
      , x_return_status            =>       x_status
      , x_msg_count                =>       x_msg_count
      , x_msg_data                 =>       x_msg_data
      , p_rsv_rec                  =>       p_rsv
      , p_serial_number            =>       p_dummy_sn
      , x_serial_number            =>       x_dummy_sn
      , x_quantity_reserved        =>       x_qty
      , x_reservation_id           =>       x_rsv_id
      
   );
   
   
   
COMMIT;
   dbms_output.put_line('Return status    = '||x_status);
   dbms_output.put_line('msg count        = '||to_char(x_msg_count));
   dbms_output.put_line('msg data         = '||x_msg_data);
   dbms_output.put_line('Quantity reserved = '||to_char(x_qty));
   dbms_output.put_line('Reservation id   = '||to_char(x_rsv_id));
   
   IF x_return_status ='S'
     THEN 
        ou_p_status := 'S';
		
		UPDATE xxaac.xxawr_so_delvy_instr_stg
            SET reservation_id = x_rsv_id, 
          WHERE oic_instance_id = in_p_oic_instance_id
		    AND stg_del_instr_id = v_reserve(INDX).stg_del_instr_id
			AND status = 'V';
   ELSE
        ou_p_status  := 'E';
        ou_p_err_msg := 'Error in applying the reservation';

   END IF;
        
        
   
   IF x_msg_count >=1 THEN
     FOR I IN 1..x_msg_count
     LOOP
       dbms_output.put_line(I||'. '||SUBSTR(FND_MSG_PUB.Get(p_encoded => FND_API.G_FALSE ),1, 255));
     END LOOP;    

   END IF;
   
   
   
EXCEPTION
   WHEN OTHERS 
     THEN
         ou_p_status  := 'E';
         ou_p_err_msg := 'Error in RESERVATION API';
		 
   END;
   
   IF ou_p_status = 'E'
     THEN
	    UPDATE xxaac.xxawr_so_header_stg
            SET status = ou_p_status, 
			    error_msg = ou_p_err_msg
          WHERE oic_instance_id = in_p_oic_instance_id;

         --
         UPDATE xxaac.xxawr_so_lines_stg
            SET status = ou_p_status, 
			    error_msg = ou_p_err_msg
          WHERE oic_instance_id = in_p_oic_instance_id;

         --
         UPDATE xxaac.xxawr_so_delvy_instr_stg
            SET status = ou_p_status, 
			    error_msg = ou_p_err_msg
          WHERE oic_instance_id = in_p_oic_instance_id;
		  
		COMMIT;
	END IF;
   
   END LOOP;
   
EXIT WHEN v_reserve.COUNT=0;

CLOSE c_reserve;


EXCEPTION
   WHEN OTHERS 
     THEN
         ou_p_status  := 'E';
         ou_p_err_msg := 'Error in applying the reservation';
		 
		 UPDATE xxaac.xxawr_so_header_stg
            SET status = ou_p_status, 
			    error_msg = ou_p_err_msg
          WHERE oic_instance_id = in_p_oic_instance_id;

         --
         UPDATE xxaac.xxawr_so_lines_stg
            SET status = ou_p_status, 
			    error_msg = ou_p_err_msg
          WHERE oic_instance_id = in_p_oic_instance_id;

         --
         UPDATE xxaac.xxawr_so_delvy_instr_stg
            SET status = ou_p_status, 
			    error_msg = ou_p_err_msg
          WHERE oic_instance_id = in_p_oic_instance_id;
		  
		  COMMIT;
End create_reservation;
-----

  /***************************************************************************************************
    * Object Name       : delete_reservation
    * Program Type      : Package Procedure.
    * Language          : PL/SQL
    * Parameter        :
    * S.No      Name               Required     WHAT
    * =======   ================== =========    =======================================================
    * 1         DELETE_RESERVATION     Y            OIC_INSTANCE_ID
    ***************************************************************************************************
    * History      :
    * WHO              Version #   WHEN            WHAT
    * ===============  =========   =============   ====================================================
    *                   1.0         14-Jan-2024
    ***************************************************************************************************/

PROCEDURE delete_reservation(in_p_oic_instance_id IN VARCHAR2,
                             ou_p_status         OUT VARCHAR2, 
                             ou_p_err_msg        OUT VARCHAR2
                             )
 IS
 
 CURSOR c_unreserve
   is
   SELECT d.*,e.item_id
     FROM xxaac.xxawr_so_del_instr_stg d 
         ,xxaac.xxawr_so_lines_stg e
    WHERE d.oic_instance_id = in_p_oic_instance_id
      AND d.stg_header_id = e.stg_header_id
      AND d.stg_line_id = e.stg_line_id
      AND d.stg_del_instr_status IN ('UNRESERVE','CANCELLED')
      AND d.status = 'V'
      AND EXISTS (SELECT 1
                    FROM oe_order_headers_all h,
                         oe_order_lines_all l,
                         mtl_reservations mr                         
                   WHERE h.header_id = d.oracle_order_header_id
                     AND L.line_id = d.oracle_order_line_id
                     AND l.flow_status_code = 'ENTERED'
                     AND h.flow_status_code = 'ENTERED'
                     AND d.reservation_id = mr.reservation_id
                  );
    
      TYPE t_unreserve IS TABLE of c_unreserve%ROWTYPE INDEX BY PLS_INTEGER;
      v_unreserve t_unreserve;      
      l_rsv       inv_reservation_global.mtl_reservation_rec_type;
      l_msg_count NUMBER;
      l_msg_data  VARCHAR2(240);
      l_rsv_id    NUMBER;
      l_dummy_sn  inv_reservation_global.serial_number_tbl_type;
      l_status    VARCHAR2(1);
      l_sub_inv   VARCHAR2(20);

BEGIN
     
      fnd_global.apps_initialize(1014925,50583,401);
      OPEN c_unreserve;
      FETCH c_unreserve BULK COLLECT INTO v_unreserve limit 500;
        FOR indx IN 1..v_unreserve.COUNT 
          LOOP
            BEGIN            
             SELECT subinventory_code
               INTO l_sub_inv
               FROM mtl_reservations mr
              WHERE reservation_id = v_unreserve(indx).reservation_id;
            EXCEPTION
              WHEN OTHERS
                THEN
                  l_sub_inv := 'FG';
            END;
              
      l_rsv.reservation_id               := v_unreserve(indx).reservation_id;
      l_rsv.organization_id                := g_inv_org_id;
      l_rsv.inventory_item_id            := v_unreserve(indx).item_id;
      l_rsv.demand_source_type_id        := inv_reservation_global.g_source_type_oe; -- order entry
      l_rsv.demand_source_header_id      := v_unreserve(indx).oracle_order_header_id; --oe_order_headers.header_id
      l_rsv.demand_source_line_id        := v_unreserve(indx).oracle_order_line_id; --oe_order_lines.line_id
      l_rsv.supply_source_type_id        := inv_reservation_global.g_source_type_inv;
      l_rsv.subinventory_code            := l_sub_inv;
      

     inv_reservation_pub.delete_reservation
       (
          p_api_version_number        => 1.0
         , p_init_msg_lst              => fnd_api.g_true
         , x_return_status             => l_status
         , x_msg_count                 => l_msg_count
         , x_msg_data                  => l_msg_data
         , p_rsv_rec                   => l_rsv
         , p_serial_number             => l_dummy_sn
         );

     IF l_status = fnd_api.g_ret_sts_success THEN
         dbms_output.put_line('reservation deleted');
         ou_p_status := 'S';
		 
		 UPDATE xxaac.xxawr_so_delvy_instr_stg
            SET reservation_id = NULL, 
          WHERE oic_instance_id = in_p_oic_instance_id
		    AND stg_del_instr_id = v_unreserve(INDX).stg_del_instr_id
			AND status = 'V';
         
     ELSE
        IF l_msg_count >=1 THEN
           FOR I IN 1..l_msg_count    LOOP
             dbms_output.put_line(I||'. '||SUBSTR(FND_MSG_PUB.Get(p_encoded => FND_API.G_FALSE ),1, 255));
           END LOOP; 
           
        END IF;
        ou_p_status := 'E';
        ou_p_err_msg := 'Error in unreserve the order';
		
		UPDATE xxaac.xxawr_so_header_stg
            SET status = ou_p_status, 
			    error_msg = ou_p_err_msg
          WHERE oic_instance_id = in_p_oic_instance_id;

         --
         UPDATE xxaac.xxawr_so_lines_stg
            SET status = ou_p_status, 
			    error_msg = ou_p_err_msg
          WHERE oic_instance_id = in_p_oic_instance_id;

         --
         UPDATE xxaac.xxawr_so_delvy_instr_stg
            SET status = ou_p_status, 
			    error_msg = ou_p_err_msg
          WHERE oic_instance_id = in_p_oic_instance_id;
		  
		COMMIT;
     END IF;
     COMMIT;
    END LOOP;
EXCEPTION
  WHEN OTHERS
    THEN
      ou_p_status := 'E';
      ou_p_err_msg := 'ERROR IN UNRESERVATION OF ITEM';
	  
	  UPDATE xxaac.xxawr_so_header_stg
            SET status = ou_p_status, 
			    error_msg = ou_p_err_msg
          WHERE oic_instance_id = in_p_oic_instance_id;

         --
         UPDATE xxaac.xxawr_so_lines_stg
            SET status = ou_p_status, 
			    error_msg = ou_p_err_msg
          WHERE oic_instance_id = in_p_oic_instance_id;

         --
         UPDATE xxaac.xxawr_so_delvy_instr_stg
            SET status = ou_p_status, 
			    error_msg = ou_p_err_msg
          WHERE oic_instance_id = in_p_oic_instance_id;
		  
		COMMIT;
		
END delete_reservation;
-------

/*******************************************************************************************************************
     * Program Name   : SALES_ORDER_CANCEL
     * Language       : PL/SQL
     * Description    : Procedure To CANCEL Sales Order
     * History        :
     * WHO              WHAT                                                          WHEN
     * --------------   -------------------------------------------------------       --------------
     *                     Procedure To CANCEL Sales Order                                2024
     *******************************************************************************************************************/
   PROCEDURE sales_order_cancel (in_p_oic_instance_id IN VARCHAR2 , ou_p_status out varchar2, ou_p_err_msg out varchar2)
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
                AND stg_del.stg_header_id = stg_hd.stg_header_id
                AND UPPER (stg_del.stg_del_instr_status) = 'BOOKED'
                AND stg_del.status = 'S'
                AND stg_hd.sf_order_id IN
                       (SELECT stg_hd1.sf_order_id
                          FROM xxaac.xxawr_so_lines_stg stg_ln1,
                               xxaac.xxawr_so_header_stg stg_HD1,
                               xxaac.xxawr_so_delvy_instr_stg stg_del1
                         WHERE 1 = 1
                               AND stg_del1.stg_header_id =
                                      stg_ln1.stg_header_id
                               AND stg_del1.stg_header_id =
                                      stg_hd1.stg_header_id
                               AND stg_ln1.stg_line_id = stg_del1.stg_line_id
                               AND UPPER (stg_del1.stg_del_instr_status) =
                                      'CANCELLED'
                               AND stg_del1.status = 'V'
                               AND stg_del1.oic_instance_id =
                                      IN_P_OIC_INSTANCE_ID
                               AND stg_del1.stg_del_instr_id =
                                      stg_del.stg_del_instr_id);

      TYPE c_so_cancel_type IS TABLE OF c_so_cancel%ROWTYPE
                                  INDEX BY PLS_INTEGER;

      R_SO_CANCEL                    c_so_cancel_type;
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('Starting of script CANCEL ORDER');

      --CANCEL PREVIOUS DRAFT ORDERs From Staging
      UPDATE xxaac.xxawr_so_delvy_instr_stg stg_del
         SET status = 'S'
       WHERE     stg_del.stg_del_instr_status = 'CANCELLED'
             AND stg_del.oic_instance_id = IN_P_OIC_INSTANCE_ID
             AND stg_del.status = 'V'
             AND stg_del.stg_del_instr_id =
                    (SELECT stg_del1.stg_del_instr_id
                       FROM xxaac.xxawr_so_header_stg stg_hd1,
                            xxaac.xxawr_so_delvy_instr_stg stg_del1,
                            xxaac.xxawr_so_lines_stg stg_ln1
                      WHERE 1 = 1
                            AND stg_del1.stg_header_id =
                                   stg_ln1.stg_header_id
                            AND stg_del1.stg_header_id =
                                   stg_hd1.stg_header_id
                            AND stg_ln1.stg_line_id = stg_del1.stg_line_id
							AND stg_del1.status = 'X'
                            AND LOWER (stg_del1.stg_del_instr_status) =
                                   'draft'
                     )
			 AND NOT EXISTS (SELECT 1
			                   FROM oe_order_lines_all l,
                                    oe_order_header_all h							   
							  WHERE l.global_attribute1 = stg_del.stg_del_instr_id
							    AND h.header_id = l.header_id);

      --CANCEL PREVIOUS RESERVED SO (FIRST UNRESERVE RESERVED ORDER AND THEN UPDATE STATUS)
      BEGIN
         SELECT stg_del.reservation_id
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
                               AND stg_del1.stg_header_id =
                                      stg_ln1.stg_header_id
                               AND stg_del1.stg_header_id =
                                      stg_hd1.stg_header_id
                               AND stg_ln1.stg_line_id = stg_del1.stg_line_id
                               AND EXISTS
                                      (SELECT 1
                                         FROM xxaac.xxawr_so_lines_stg stg_ln
                                        WHERE stg_del.stg_header_id =
                                                 stg_ln.stg_header_id
                                              AND stg_ln.stg_line_id =
                                                     stg_del.stg_line_id
                                              AND UPPER (stg_ln.item_code) =
                                                     UPPER (
                                                        stg_ln1.item_code)
                                              AND stg_ln.oic_instance_id =
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
                         WHERE reservation_id = stg_del.reservation_id);

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
                  V_HEADER_REC.CHANGE_REASON := 'BUSINESS REQUIREMENT';  ----To be updated------------
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
                      WHERE     status = 'V'
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
                      WHERE     status = 'V'
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
					 ou_p_status := v_return_status;
                     DBMS_OUTPUT.PUT_LINE (
                        'Order LINE Cancellation Success : '
                        || V_HEADER_REC_OUT.HEADER_ID);

                     UPDATE xxaac.xxawr_so_delvy_instr_stg
                        SET status = 'S',
                            ORACLE_ORDER_HEADER_ID =
                               R_SO_CANCEL (indx).oracle_order_header_id,
                            oracle_order_line_id =
                               R_SO_CANCEL (indx).oracle_order_line_id
                      WHERE     status = 'V'
                            AND UPPER (stg_del_instr_status) = 'CANCELLED'
                            AND oic_instance_id = in_p_oic_instance_id
                            AND STG_DEL_INSTR_ID =
                                   R_SO_CANCEL (indx).stg_del_instr_id;
                  ELSE
                     DBMS_OUTPUT.PUT_LINE (
                        'Order Cancellation failed : '
                        || V_HEADER_REC_OUT.header_id);
					
					ou_p_status := 'E';
					ou_p_err_msg := 'Error in Sales Order cancellation';

                     UPDATE xxaac.xxawr_so_delvy_instr_stg
                        SET status = 'E', error_msg = v_msg_data
                      WHERE     status = 'V'
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
         UPDATE xxaac.xxawr_so_delvy_instr_stg
            SET status = 'E', 
			    error_msg = 'Error in Cancellation of Sales Order';
          WHERE status = 'V'
		    AND oic_instance_id = in_p_oic_instance_id;
			
		  ou_p_status := 'E';
		  ou_p_err_msg := 'Error in Cancellation of Sales Order';
   END sales_order_cancel;   

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
                     out_status             => l_status,
                     out_error_msg          => L_err_msg);

      IF L_status = 'E'
      THEN
         out_p_status := l_status;
         out_p_error_message := l_err_msg;
      ELSE
	     
	     
		 --
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
					 /*

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
				   */
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
   CURSOR c_stat
      IS
         SELECT DISTINCT 
		        h.sf_id,
				h.oic_instance_id,
				UPPER(d.stg_del_instr_status) del_status,
                COUNT(d.stg_del_instr_id) cnt_del_inst_id				
           FROM 
		        xxaac.xxawr_so_header_stg h,
				xxaac.xxawr_so_delvy_instr_stg d
          WHERE     1 = 1
                AND h.oic_instance_id = in_p_oic_instance_id
				AND d.stg_header_id = h.stg_header_id
                AND h.status = 'V'
				AND d.status = 'V'
	   GROUP BY h.sf_id,
				h.oic_instance_id,
				d.stg_del_instr_status;
				
      L_id              VARCHAR2 (240);
      L_count           NUMBER;
      L_status          VARCHAR2 (240);
      L_cancel_flag     VARCHAR2 (20);
      L_cancel_reason   VARCHAR2 (240);
      L_err_msg         VARCHAR2 (1000);
   
   BEGIN
      fnd_file.put_line (fnd_file.LOG, 'Coming to Run Wrapper Program');
   --wrapper_program (in_p_oic_instance_id);
       FOR rec_stat IN c_stat
	     LOOP
		    IF rec_stat.del_status = 'BOOKED'
			  THEN
				       ---------------create sales order
                       sales_order_create (in_p_oic_instance_id,l_status, l_err_msg);
					   IF l_status = 'C'   --created
					    THEN 
				          ----------------book sales order
						  sales_order_booking (in_p_oic_instance_id,l_status, l_err_msg);
						    
						  IF l_status = 'E'
						   THEN 
						     l_err_msg := l_err_msg||'Error in booking Sales Order';
						  END IF; ---sales_order_book
					   ELSE
					      l_status  := 'E';
					      l_err_msg := l_err_msg||'Error in creating Sales Order for booking';
					   END IF; ---sales_order_creation
			
			-------------------------For status = 'RESERVE'
			ELSIF rec_stat.del_status = 'RESERVE'
			  THEN
				---------API to reserve
				sales_order_create (in_p_oic_instance_id,l_status, l_err_msg);
				IF l_status = 'C'
				 THEN
				   create_reservation (in_p_oic_instance_id,l_status, l_err_msg);
				   IF l_status = 'E'
				     THEN 
					    l_err_msg := l_err_msg||'Error in creating the reservation'; 
				   END IF;
				ELSE
				   l_status  := 'E';
				   l_err_msg := l_err_msg||'Error in creating Sales Order for reservation';
				END IF;
			
            ------------------------For status = 'UNRESERVE'			
			ELSIF rec_stat.del_status = 'UNRESERVE'
			    ---------API to unreserve
				delete_reservation(in_p_oic_instance_id,l_status, l_err_msg);
			
            ------------------------For Status = 'CANCELLED'			
			ELSIF rec_stat.del_status = 'CANCELLED'
			    ---------API to cancel sales order
				sales_order_cancel (in_p_oic_instance_id,l_status, l_err_msg);
			END IF;
			
        END LOOP;

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
		  
		 COMMIT;
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