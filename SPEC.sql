 CREATE OR REPLACE PACKAGE XXAWR_SALES_ORDER_PACKAGE AS
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
    *                   1.0 - AWR SO SPEC                                             2024
    *******************************************************************************************************************/

   /*******************************************************************************************************************
    * Variable       : Declaration and Initialization
    * Description    : Variables Declaration and Initialization
    * History        :
    * WHO               WHAT                                                                 WHEN
    * --------------  ---------------------------------------------------                --------------
    *                    1.0 - AWR SO VARIABLE DECLERATION                               2024
    *******************************************************************************************************************/

/********** DECLARING INITIALIZING GLOBAL VARIABLES ******************/
GN_REQUEST_ID FND_CONCURRENT_REQUESTS.REQUEST_ID%TYPE := FND_PROFILE.VALUE('CONC_REQUEST_ID');
GN_ORG_ID NUMBER;
GN_USER_ID NUMBER;
GN_RESP_APP_ID NUMBER;
GN_RESP_ID NUMBER;

g_resp_id NUMBER;

g_resp_appl_id NUMBER;



    
    
    
    
	/*******************************************************************************************************************
    * Program Name   : MAIN_PROCEDURE
    * Language       : PL/SQL
    * Description    : Procedure MAIN PROCEDURE
    * History        :
    * WHO              WHAT                                                             WHEN
    * --------------   -------------------------------------------------------       --------------
    *                    DRAFT 1.0 IE MAIN PROGRAM DECLERATION IN SPEC                   2024   
    *******************************************************************************************************************/

    PROCEDURE MAIN_PROCEDURE (
        P_STATUS IN VARCHAR2,
        P_ERROR_MSG IN VARCHAR2,
        IN_P_OIC_INSTANCE_ID IN NUMBER
       );

END XXAWR_SALES_ORDER_PACKAGE;