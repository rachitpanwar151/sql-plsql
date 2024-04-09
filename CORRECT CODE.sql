CREATE OR REPLACE PACKAGE BODY XXAWR_SALES_ORDER_PACKAGE
AS
   /*******************************************************************************************************************
    * $Header         : @(#)
    * Program Name    : XXAWR_SALES_ORDER_PACKAGE.PKB
    * Language        : PL/SQL
    * Description     :
    *
    * History         :
    *
    * WHO              WHAT                                                                  WHEN
    * --------------   -------------------------------------------------                  -----------
    *                    1.0 - AWR SALES ORDER                                               2024
    *******************************************************************************************************************/




/*******************************************************************************************************************
    * Program Name   : UPDATE_ORDER_CANCEL_LINES_DETAILS
    * Language       : PL/SQL
    * Description    : Procedure To UPDATE CANCEL LINE DETAILS INTO Staging Table
    * History        :
    * WHO              WHAT                                                                   WHEN
    * --------------   -------------------------------------------------------             -------------
    *                     Update Data OF CANCEL LINE DETAILS IN STAGING TABLE                   2024
    *******************************************************************************************************************/


      PROCEDURE UPDATE_ORDER_CANCEL_LINES_DETAILS (
        IN_P_HEADER_ID       IN NUMBER,
        IN_P_LINE_ID         IN NUMBER,
        IN_P_OIC_INSTANCE_ID IN NUMBER
        
    ) AS
    BEGIN
    
    
    DBMS_OUTPUT.PUT_LINE('PROCESS STARTED TO UPDATE CANCEL LINES DETAILS');
		/*****************************************************************************************
        PROCEDURE TO UPDATE ORDER NUMBER AND HEADER AND LINE ID AND ERRORS  ENCOUNTERED IN API
        *****************************************************************************************/
        BEGIN
            UPDATE XXAWR_STAGING_LINE_SO ST2
            SET
                FLOW_STATUS_CODE_LINE = ( SELECT DISTINCT FLOW_STATUS_CODE
                    FROM OE_ORDER_LINES_ALL OE
                    WHERE 1=1
                        AND   OE.HEADER_ID = IN_P_HEADER_ID
                        AND   OE.ORG_ID    = GN_ORG_ID
                        AND   OE.LINE_ID   = IN_P_LINE_ID
                ),
                STATUS='CANCELLED LINE',
                CREATED_BY=GN_USER_ID,
                LAST_UPDATED_BY=GN_USER_ID,
                CREATION_DATE=SYSDATE,
                LAST_UPDATE_DATE=SYSDATE

                WHERE 1=1
                AND ST2.STG_DEL_INSTR_STATUS = 'CANCEL LINE'
                AND ST2.ORDER_HEADER_ID      = IN_P_HEADER_ID
                AND ST2.LINE_ID              = IN_P_LINE_ID
                AND OIC_INSTANCE_ID          = IN_P_OIC_INSTANCE_ID;
 
            DBMS_OUTPUT.PUT_LINE('CANCELLED LINE ID IS '||IN_P_LINE_ID);
            COMMIT;
            EXCEPTION
            WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('CANNOT UPDATE LINE CANCEL DETAILS'||SQLCODE||SQLERRM);
             END;

            END UPDATE_ORDER_CANCEL_LINES_DETAILS;








 /*******************************************************************************************************************
    * Program Name   : SALES_ORDER_CANCEL_LINES
    * Language       : PL/SQL
    * Description    : Procedure To  CANCEL LINE IN SALES ORDER
    * History        :
    * WHO              WHAT                                                          WHEN
    * --------------   -------------------------------------------------------       --------------
    *                   PROCEDURE TO CANCEL A SPECIFIC LINE IN SALES ORDER                  2024
    *******************************************************************************************************************/



PROCEDURE SALES_ORDER_CANCEL_LINES(IN_P_OIC_INSTANCE_ID IN VARCHAR2 )
IS

V_API_VERSION_NUMBER           NUMBER  := 1;
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


CURSOR C_CANCEL_LINES 
IS
SELECT 
DISTINCT *
FROM XXAWR_STAGING_LINE_SO
WHERE 1                         =1
AND UPPER(LINE_CANCEL_FLAG)     = 'Y'
AND UPPER(STG_DEL_INSTR_STATUS) = 'CANCEL LINE'
AND OIC_INSTANCE_ID             = IN_P_OIC_INSTANCE_ID;

TYPE  C_CANCEL_REC IS TABLE OF C_CANCEL_LINES%ROWTYPE INDEX BY PLS_INTEGER;
R_CANCEL C_CANCEL_REC;


BEGIN

DBMS_OUTPUT.PUT_LINE('Starting of script');

-- Setting the Enviroment --

MO_GLOBAL.INIT('ONT');
FND_GLOBAL.APPS_INITIALIZE ( GN_USER_ID , GN_RESP_ID, GN_RESP_APP_ID);
MO_GLOBAL.SET_POLICY_CONTEXT('S',GN_ORG_ID);


OPEN C_CANCEL_LINES;
LOOP

FETCH C_CANCEL_LINES BULK COLLECT INTO R_CANCEL LIMIT 500;
 FOR I IN 1..R_CANCEL.COUNT 
 LOOP

V_ACTION_REQUEST_TBL (1) := OE_ORDER_PUB.G_MISS_REQUEST_REC;

-- Cancel a Line Record --
V_LINE_TBL (1)                      := OE_ORDER_PUB.G_MISS_LINE_REC;
V_LINE_TBL (1).OPERATION            := OE_GLOBALS.G_OPR_UPDATE;
V_LINE_TBL (1).HEADER_ID            := R_CANCEL(I).ORDER_HEADER_ID;
V_LINE_TBL (1).LINE_ID              := R_CANCEL(I).LINE_ID;
V_LINE_TBL (1).ORDERED_QUANTITY     := R_CANCEL(I).ORDERED_QUANTITY;
V_LINE_TBL (1).CANCELLED_FLAG       := UPPER(R_CANCEL(I).LINE_CANCEL_FLAG);
V_LINE_TBL (1).CHANGE_REASON        := UPPER(R_CANCEL(I).LINE_CANCEL_REASON);

DBMS_OUTPUT.PUT_LINE('Starting of API CANCEL ORDER LINE ');

-- Calling the API to cancel a line from an Existing Order --

               OE_ORDER_PUB.PROCESS_ORDER (
                         P_API_VERSION_NUMBER            => V_API_VERSION_NUMBER
                          , P_HEADER_REC                  => V_HEADER_REC
                          , P_LINE_TBL                    => V_LINE_TBL
                          , P_ACTION_REQUEST_TBL          => V_ACTION_REQUEST_TBL
                          , P_LINE_ADJ_TBL                => V_LINE_ADJ_TBL
-- OUT variables
                          , X_HEADER_REC                  => V_HEADER_REC_OUT
                          , X_HEADER_VAL_REC              => V_HEADER_VAL_REC_OUT

                          , X_HEADER_ADJ_TBL              => V_HEADER_ADJ_TBL_OUT

                          , X_HEADER_ADJ_VAL_TBL          => V_HEADER_ADJ_VAL_TBL_OUT
                          , X_HEADER_PRICE_ATT_TBL        => V_HEADER_PRICE_ATT_TBL_OUT
                          , X_HEADER_ADJ_ATT_TBL          => V_HEADER_ADJ_ATT_TBL_OUT
                          , X_HEADER_ADJ_ASSOC_TBL        => V_HEADER_ADJ_ASSOC_TBL_OUT
                          , X_HEADER_SCREDIT_TBL          => V_HEADER_SCREDIT_TBL_OUT
                          , X_HEADER_SCREDIT_VAL_TBL      => V_HEADER_SCREDIT_VAL_TBL_OUT
                          , X_LINE_TBL                    => V_LINE_TBL_OUT
                          , X_LINE_VAL_TBL                => V_LINE_VAL_TBL_OUT
                          , X_LINE_ADJ_TBL                => V_LINE_ADJ_TBL_OUT
                          , X_LINE_ADJ_VAL_TBL            => V_LINE_ADJ_VAL_TBL_OUT
                          , X_LINE_PRICE_ATT_TBL          => V_LINE_PRICE_ATT_TBL_OUT
                          , X_LINE_ADJ_ATT_TBL            => V_LINE_ADJ_ATT_TBL_OUT
                          , X_LINE_ADJ_ASSOC_TBL          => V_LINE_ADJ_ASSOC_TBL_OUT
                          , X_LINE_SCREDIT_TBL            => V_LINE_SCREDIT_TBL_OUT
                          , X_LINE_SCREDIT_VAL_TBL        => V_LINE_SCREDIT_VAL_TBL_OUT
                          , X_LOT_SERIAL_TBL              => V_LOT_SERIAL_TBL_OUT
                          , X_LOT_SERIAL_VAL_TBL          => V_LOT_SERIAL_VAL_TBL_OUT
                          , X_ACTION_REQUEST_TBL          => V_ACTION_REQUEST_TBL_OUT
                          , X_RETURN_STATUS               => V_RETURN_STATUS
                          , X_MSG_COUNT                   => V_MSG_COUNT
                          , X_MSG_DATA                    => V_MSG_DATA
                            );
                        COMMIT;
       DBMS_OUTPUT.PUT_LINE('Completion of API');

      DBMS_OUTPUT.PUT_LINE('STATUS RETURN IS '||V_RETURN_STATUS);
    
    IF V_RETURN_STATUS = FND_API.G_RET_STS_SUCCESS THEN
    COMMIT;
      DBMS_OUTPUT.PUT_LINE ('Line Cancelation in Existing Order is Success ');
       
      UPDATE_ORDER_CANCEL_LINES_DETAILS(R_CANCEL(I).ORDER_HEADER_ID,R_CANCEL(I).LINE_ID,IN_P_OIC_INSTANCE_ID);
 
   ELSE
    DBMS_OUTPUT.PUT_LINE ('Line Cancelation in Existing Order failed:'||V_MSG_DATA);
    
    
/********************************
UPDATE STAING LINE TABLE
********************************/
UPDATE XXAWR_STAGING_LINE_SO
 SET STATUS = 'E'
 ,ERROR_MSG = 'Error in CANCEL Sales Order LINE'
 WHERE 1             = 1
 AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
 AND ORDER_HEADER_ID = R_CANCEL(I).ORDER_HEADER_ID
 AND LINE_ID         =R_CANCEL(I).LINE_ID;

  COMMIT;
    
    
    ROLLBACK;
    FOR I IN 1 .. V_MSG_COUNT
    LOOP
      V_MSG_DATA := OE_MSG_PUB.GET( P_MSG_INDEX => I, 
	                                P_ENCODED   => 'F');
      DBMS_OUTPUT.PUT_LINE( I|| ') '|| V_MSG_DATA);
    END LOOP;
     END IF;   
      END LOOP;
        EXIT WHEN R_CANCEL.COUNT=0;
        END LOOP;
        CLOSE C_CANCEL_LINES;
        EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR OCCURED IN CANCELLING SALES ORDER LINE'||SQLCODE||SQLERRM);
    END SALES_ORDER_CANCEL_LINES;





 /*******************************************************************************************************************
    * Program Name   : UPDATE_ORDER_CANCEL_DETAILS
    * Language       : PL/SQL
    * Description    : Procedure To UPDATE CANCEL  DETAILS INTO Staging Table
    * History        :
    * WHO              WHAT                                                                    WHEN
    * --------------   -----------------------------------------------------------           -----------
    *                   Update COMPLETE ORDER CANCEL DETAILS INTO STAGING TABLE                 2024
    *******************************************************************************************************************/



      PROCEDURE UPDATE_ORDER_CANCEL_DETAILS (
        IN_P_HEADER_ID       IN NUMBER,
        IN_P_OIC_INSTANCE_ID IN NUMBER
    ) AS
    
    
    CURSOR C_LINE
    IS 
    SELECT  DISTINCT * FROM XXAWR_STAGING_LINE_SO
    WHERE 1=1
	AND STATUS      = 'V'
    AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;
	
    BEGIN
    
    
    DBMS_OUTPUT.PUT_LINE('PROCESS STARTED TO UPDATE CANCEL DETAILS');
		/*****************************************************************************************
        PROCEDURE TO UPDATE ORDER NUMBER AND HEADER AND LINE ID AND ERRORS  ENCOUNTERED IN API
        *****************************************************************************************/
    BEGIN
    UPDATE XXAWR_STAGING_HEADER_SO ST1
    SET
    FLOW_STATUS_CODE_HDR = (SELECT DISTINCT FLOW_STATUS_CODE
                    FROM
                        OE_ORDER_HEADERS_ALL OE
                    WHERE
                        OE.HEADER_ID      = IN_P_HEADER_ID
                        AND OE.ORG_ID     = GN_ORG_ID),
                        STATUS        = 'CANCELLED ORDER',
                        CREATED_BY        = GN_USER_ID,
                        LAST_UPDATED_BY   = GN_USER_ID,
                        CREATED_DATE      = SYSDATE,
                        LAST_UPDATED_DATE = SYSDATE,
                        LAST_LOGIN        = GN_USER_ID
                        WHERE 1=1
						AND ST1.ORDER_HEADER_ID     = IN_P_HEADER_ID
                        AND UPPER(ST1.CANCEL_FLAG)  ='Y'
                        AND  OIC_INSTANCE_ID        =IN_P_OIC_INSTANCE_ID;
            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('CANNOT UPDATE BOOKING DETAILS IN HEADER STAING'||SQLCODE||SQLERRM);
        
        END;
 DBMS_OUTPUT.PUT_LINE('CANCELLED HEADER ID IS '||IN_P_HEADER_ID);


       FOR R_LINE IN C_LINE
       LOOP
       BEGIN
            UPDATE XXAWR_STAGING_LINE_SO ST2
            SET
            FLOW_STATUS_CODE_LINE = (
            SELECT DISTINCT FLOW_STATUS_CODE
            FROM OE_ORDER_LINES_ALL OE
            WHERE
            OE.HEADER_ID        = IN_P_HEADER_ID
            AND OE.ORG_ID       = GN_ORG_ID
            AND SF_ORDER_ID     = R_LINE.SF_ORDER_ID),
			
            LINE_CANCEL_FLAG    = 'Y',
            STATUS          = 'CANCELED COMPLETE ORDER',
            CREATED_BY          = GN_USER_ID,
            LAST_UPDATED_BY     = GN_USER_ID,
            CREATION_DATE       = SYSDATE,
            LAST_UPDATE_DATE    = SYSDATE

            WHERE 1=1
            AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;
            COMMIT;
           
        EXCEPTION
        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('CANNOT UPDATE CANCEL ORDER DETAILS'||SQLCODE||SQLERRM);
        END;
        END LOOP;

  	   END UPDATE_ORDER_CANCEL_DETAILS;

    








    /*******************************************************************************************************************
    * Program Name   : SALES_ORDER_CANCEL
    * Language       : PL/SQL
    * Description    : Procedure To CANCEL Sales Order
    * History        :
    * WHO              WHAT                                                          WHEN
    * --------------   -------------------------------------------------------       --------------
    *                     Procedure To CANCEL Sales Order                                2024
    *******************************************************************************************************************/

    PROCEDURE SALES_ORDER_CANCEL(IN_P_OIC_INSTANCE_ID IN VARCHAR2)
    AS

        V_API_VERSION_NUMBER         NUMBER := 1;
        V_RETURN_STATUS              VARCHAR2(2000);
        V_MSG_COUNT                  NUMBER;
        V_MSG_DATA                   VARCHAR2(2000);

-- IN Variables --
        V_HEADER_REC                 OE_ORDER_PUB.HEADER_REC_TYPE;
        V_LINE_TBL                   OE_ORDER_PUB.LINE_TBL_TYPE;
        V_ACTION_REQUEST_TBL         OE_ORDER_PUB.REQUEST_TBL_TYPE;
        V_LINE_ADJ_TBL               OE_ORDER_PUB.LINE_ADJ_TBL_TYPE;

-- OUT Variables --
        V_HEADER_REC_OUT             OE_ORDER_PUB.HEADER_REC_TYPE;
        V_HEADER_VAL_REC_OUT         OE_ORDER_PUB.HEADER_VAL_REC_TYPE;
        V_HEADER_ADJ_TBL_OUT         OE_ORDER_PUB.HEADER_ADJ_TBL_TYPE;
        V_HEADER_ADJ_VAL_TBL_OUT     OE_ORDER_PUB.HEADER_ADJ_VAL_TBL_TYPE;
        V_HEADER_PRICE_ATT_TBL_OUT   OE_ORDER_PUB.HEADER_PRICE_ATT_TBL_TYPE;
        V_HEADER_ADJ_ATT_TBL_OUT     OE_ORDER_PUB.HEADER_ADJ_ATT_TBL_TYPE;
        V_HEADER_ADJ_ASSOC_TBL_OUT   OE_ORDER_PUB.HEADER_ADJ_ASSOC_TBL_TYPE;
        V_HEADER_SCREDIT_TBL_OUT     OE_ORDER_PUB.HEADER_SCREDIT_TBL_TYPE;
        V_HEADER_SCREDIT_VAL_TBL_OUT OE_ORDER_PUB.HEADER_SCREDIT_VAL_TBL_TYPE;
        V_LINE_TBL_OUT               OE_ORDER_PUB.LINE_TBL_TYPE;
        V_LINE_VAL_TBL_OUT           OE_ORDER_PUB.LINE_VAL_TBL_TYPE;
        V_LINE_ADJ_TBL_OUT           OE_ORDER_PUB.LINE_ADJ_TBL_TYPE;
        V_LINE_ADJ_VAL_TBL_OUT       OE_ORDER_PUB.LINE_ADJ_VAL_TBL_TYPE;
        V_LINE_PRICE_ATT_TBL_OUT     OE_ORDER_PUB.LINE_PRICE_ATT_TBL_TYPE;
        V_LINE_ADJ_ATT_TBL_OUT       OE_ORDER_PUB.LINE_ADJ_ATT_TBL_TYPE;
        V_LINE_ADJ_ASSOC_TBL_OUT     OE_ORDER_PUB.LINE_ADJ_ASSOC_TBL_TYPE;
        V_LINE_SCREDIT_TBL_OUT       OE_ORDER_PUB.LINE_SCREDIT_TBL_TYPE;
        V_LINE_SCREDIT_VAL_TBL_OUT   OE_ORDER_PUB.LINE_SCREDIT_VAL_TBL_TYPE;
        V_LOT_SERIAL_TBL_OUT         OE_ORDER_PUB.LOT_SERIAL_TBL_TYPE;
        V_LOT_SERIAL_VAL_TBL_OUT     OE_ORDER_PUB.LOT_SERIAL_VAL_TBL_TYPE;
        V_ACTION_REQUEST_TBL_OUT     OE_ORDER_PUB.REQUEST_TBL_TYPE;
        V_MSG_INDEX                  NUMBER;
        V_DATA                       VARCHAR2(2000);
        V_LOOP_COUNT                 NUMBER;
        V_DEBUG_FILE                 VARCHAR2(200);
        B_RETURN_STATUS              VARCHAR2(200);
        B_MSG_COUNT                  NUMBER;
        B_MSG_DATA                   VARCHAR2(2000);
        CURSOR C_CANCEL IS
        SELECT DISTINCT
            ORDER_HEADER_ID,CANCEL_FLAG,CANCEL_REASON
        FROM
            XXAWR_STAGING_HEADER_SO
        WHERE
        1=1
            AND OIC_INSTANCE_ID  = IN_P_OIC_INSTANCE_ID
            AND CANCEL_FLAG      ='Y'
            AND CANCEL_REASON IS NOT NULL 
            AND STATUS       ='V';

        TYPE C_CANCEL_REC IS TABLE OF C_CANCEL%ROWTYPE INDEX BY PLS_INTEGER;
        R_CANCEL C_CANCEL_REC;

    BEGIN
        DBMS_OUTPUT.PUT_LINE('Starting of script CANCEL ORDER');

-- Setting the Enviroment --

        MO_GLOBAL.INIT('ONT');
        FND_GLOBAL.APPS_INITIALIZE(GN_USER_ID , GN_RESP_ID, GN_RESP_APP_ID);
        MO_GLOBAL.SET_POLICY_CONTEXT('S', GN_ORG_ID);

-- CANCEL HEADER --
     OPEN C_CANCEL;
     LOOP  
     FETCH C_CANCEL BULK COLLECT INTO R_CANCEL LIMIT 500;
     FOR I IN 1..R_CANCEL.COUNT 
     LOOP
            V_HEADER_REC                := OE_ORDER_PUB.G_MISS_HEADER_REC;
            V_HEADER_REC.OPERATION      := OE_GLOBALS.G_OPR_UPDATE;
            V_HEADER_REC.HEADER_ID      := R_CANCEL(I).ORDER_HEADER_ID;
            V_HEADER_REC.CANCELLED_FLAG := R_CANCEL(I).CANCEL_FLAG;
            V_HEADER_REC.CHANGE_REASON  := R_CANCEL(I).CANCEL_REASON;
            DBMS_OUTPUT.PUT_LINE('Starting of API ORDER CANCEL');

-- CALLING THE API TO CANCEL AN ORDER --

            OE_ORDER_PUB.PROCESS_ORDER(P_API_VERSION_NUMBER  => V_API_VERSION_NUMBER, 
			                           P_HEADER_REC          => V_HEADER_REC,
									   P_LINE_TBL            => V_LINE_TBL
                                      , P_ACTION_REQUEST_TBL => V_ACTION_REQUEST_TBL
                                      , P_LINE_ADJ_TBL       => V_LINE_ADJ_TBL
-- OUT variables

                                      ,X_HEADER_REC            => V_HEADER_REC_OUT
									  , X_HEADER_VAL_REC       => V_HEADER_VAL_REC_OUT
                                      , X_HEADER_ADJ_TBL       => V_HEADER_ADJ_TBL_OUT
                                      , X_HEADER_ADJ_VAL_TBL   => V_HEADER_ADJ_VAL_TBL_OUT
									  , X_HEADER_PRICE_ATT_TBL => V_HEADER_PRICE_ATT_TBL_OUT
                                      , X_HEADER_ADJ_ATT_TBL   => V_HEADER_ADJ_ATT_TBL_OUT
									  , X_HEADER_ADJ_ASSOC_TBL => V_HEADER_ADJ_ASSOC_TBL_OUT
                                      , X_HEADER_SCREDIT_TBL   => V_HEADER_SCREDIT_TBL_OUT
									  , X_HEADER_SCREDIT_VAL_TBL => V_HEADER_SCREDIT_VAL_TBL_OUT
                                      , X_LINE_TBL               => V_LINE_TBL_OUT,
                                      X_LINE_VAL_TBL             => V_LINE_VAL_TBL_OUT
									  , X_LINE_ADJ_TBL           => V_LINE_ADJ_TBL_OUT
									  , X_LINE_ADJ_VAL_TBL       => V_LINE_ADJ_VAL_TBL_OUT
                                      , X_LINE_PRICE_ATT_TBL     => V_LINE_PRICE_ATT_TBL_OUT
									  , X_LINE_ADJ_ATT_TBL       => V_LINE_ADJ_ATT_TBL_OUT
                                      , X_LINE_ADJ_ASSOC_TBL     => V_LINE_ADJ_ASSOC_TBL_OUT
									  , X_LINE_SCREDIT_TBL       => V_LINE_SCREDIT_TBL_OUT,
                                      X_LINE_SCREDIT_VAL_TBL     => V_LINE_SCREDIT_VAL_TBL_OUT
									  , X_LOT_SERIAL_TBL         => V_LOT_SERIAL_TBL_OUT,
                                      X_LOT_SERIAL_VAL_TBL       => V_LOT_SERIAL_VAL_TBL_OUT,
                                      X_ACTION_REQUEST_TBL       => V_ACTION_REQUEST_TBL_OUT
									  , X_RETURN_STATUS          => V_RETURN_STATUS
									  , X_MSG_COUNT              => V_MSG_COUNT
                                      , X_MSG_DATA               => V_MSG_DATA);

            DBMS_OUTPUT.PUT_LINE('Completion of API');
            IF V_RETURN_STATUS = FND_API.G_RET_STS_SUCCESS THEN
                COMMIT;
                DBMS_OUTPUT.PUT_LINE('Order Cancellation Success : ' || V_HEADER_REC_OUT.HEADER_ID);
                UPDATE_ORDER_CANCEL_DETAILS(R_CANCEL(I).ORDER_HEADER_ID,IN_P_OIC_INSTANCE_ID);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Order Cancellation failed:' || V_MSG_DATA);

/********************************
Update Staging HEADER 
********************************/
            UPDATE XXAWR_STAGING_HEADER_SO
            SET STATUS      = 'E'
            , ERROR_MSG         = 'Error in BOOKING Sales Order HEADER'
            WHERE 1 = 1
            AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
            AND ORDER_HEADER_ID = R_CANCEL(I).ORDER_HEADER_ID;
 
/********************************
Update Staging LINE
********************************/
            UPDATE XXAWR_STAGING_LINE_SO
            SET STATUS      = 'E'
            , ERROR_MSG         = 'Error in BOOKING Sales Order LINE'
            WHERE 1 = 1  
            AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
            AND ORDER_HEADER_ID = R_CANCEL(I).ORDER_HEADER_ID;
  COMMIT;
                ROLLBACK;
                FOR I IN 1..V_MSG_COUNT LOOP
                    V_MSG_DATA := OE_MSG_PUB.GET(P_MSG_INDEX => I
					                             , P_ENCODED => 'F');
                    DBMS_OUTPUT.PUT_LINE(I
                                         || ') '
                                         || V_MSG_DATA);
                END LOOP;

            END IF;

          END LOOP;
        EXIT WHEN R_CANCEL.COUNT=0;
        END LOOP;
        CLOSE C_CANCEL;
          EXCEPTION WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ERROR OCCURED IN CANCELLING SALES ORDER'||SQLCODE||SQLERRM);
    
	 END SALES_ORDER_CANCEL;







 /*******************************************************************************************************************
    * Program Name   : UPDATE_BOOKING_DETAILS_STAG
    * Language       : PL/SQL
    * Description    : Procedure To UPDATE BOOKING DETAILS INTO Staging Table
    * History        :
    * WHO              WHAT                                                          WHEN
    * --------------   ---------------------------------------------------       --------------
    *                     UPDATE BOOKING DETAILS INTO STAGING TABLES                2024
    *******************************************************************************************************************/

    PROCEDURE UPDATE_BOOKING_DETAILS_STAG (
        IN_P_HEADER_ID       IN NUMBER,
        IN_P_OIC_INSTANCE_ID IN NUMBER

    ) AS
    
    CURSOR C_UPDATE_HDR 
    IS 
    SELECT *
    FROM XXAWR_STAGING_LINE_SO
    WHERE  ORDER_HEADER_ID  =IN_P_HEADER_ID
    AND UPPER(STATUS)IN ('P','V')
    AND OIC_INSTANCE_ID    =IN_P_OIC_INSTANCE_ID ;
    
    
    CURSOR C_UPDATE_LINE   
    IS 
    SELECT DISTINCT *
    FROM XXAWR_STAGING_LINE_SO
    WHERE 1=1
    AND ORDER_HEADER_ID=IN_P_HEADER_ID
    AND UPPER(STG_DEL_INSTR_STATUS)='BOOK'
    AND UPPER(STATUS) IN ('P','V')
    AND OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID;
    
    
    
    BEGIN
        DBMS_OUTPUT.PUT_LINE('STARTED BOOKING UPDATE PROCESS '||IN_P_HEADER_ID);
      FOR R_UPDATE_HDR IN  C_UPDATE_HDR
        LOOP
        BEGIN
            UPDATE XXAWR_STAGING_HEADER_SO ST1
            SET
            ST1.ORDER_HEADER_ID= (
                    SELECT DISTINCT
                        OE.HEADER_ID
                    FROM
                        OE_ORDER_HEADERS_ALL OE
                    WHERE
                            OE.HEADER_ID      = IN_P_HEADER_ID
                        AND OE.ORG_ID         = GN_ORG_ID
                ),
                            ST1.ORDER_NUMBER= (
                    SELECT 
                    
                    DISTINCT
                        OE.ORDER_NUMBER
                    FROM
                        OE_ORDER_HEADERS_ALL OE
                    WHERE
                            OE.HEADER_ID      = IN_P_HEADER_ID
                        AND OE.ORG_ID         = GN_ORG_ID
                ),
                ST1.FLOW_STATUS_CODE_HDR      = (
                    SELECT DISTINCT
                        OE.FLOW_STATUS_CODE
                    FROM
                        OE_ORDER_HEADERS_ALL OE
                    WHERE
                            OE.HEADER_ID       = IN_P_HEADER_ID
                        AND OE.ORG_ID          = GN_ORG_ID
                ),
                STATUS                     = 'B',
                CREATED_BY                     = GN_USER_ID,
                LAST_UPDATED_BY                = GN_USER_ID,
                CREATED_DATE                   = SYSDATE,
                LAST_UPDATED_DATE              = SYSDATE,
                LAST_LOGIN                     = GN_USER_ID
            WHERE
            1=1
                 AND ST1.SF_ORDER_ID           = R_UPDATE_HDR.SF_ORDER_ID
                 AND OIC_INSTANCE_ID           = IN_P_OIC_INSTANCE_ID
                 AND STG_HEADER_ID             = R_UPDATE_HDR.STG_HEADER_ID ;
            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('CANNOT UPDATE BOOKING DETAILS IN HEADER STAING'||SQLCODE||SQLERRM);
        END;
          END LOOP;


FOR R_UPDATE_LINE IN C_UPDATE_LINE
LOOP
        BEGIN
        
            UPDATE XXAWR_STAGING_LINE_SO ST2
            SET
                ST2.FLOW_STATUS_CODE_LINE   = (
                    SELECT DISTINCT OE.FLOW_STATUS_CODE
                    FROM OE_ORDER_LINES_ALL OE
                    WHERE
                    OE.HEADER_ID            = IN_P_HEADER_ID
                    AND OE.ORG_ID           = GN_ORG_ID ),
                STATUS                  = 'B',
                CREATED_BY                  = GN_USER_ID,
                LAST_UPDATED_BY             = GN_USER_ID,
                CREATION_DATE               = SYSDATE,
                LAST_UPDATE_DATE            = SYSDATE
                WHERE
                    ST2.ORDER_HEADER_ID     = IN_P_HEADER_ID
                    AND UPPER(STG_DEL_INSTR_STATUS) IN ('BOOK')
                    AND OIC_INSTANCE_ID     = IN_P_OIC_INSTANCE_ID
                    AND STG_LINE_ID         = R_UPDATE_LINE.STG_LINE_ID;
            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(' CANNOT UPDATE BOOKING DETAILS IN LINE STAGING'||SQLCODE||SQLERRM);
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


    PROCEDURE SALES_ORDER_BOOKING(IN_P_OIC_INSTANCE_ID IN VARCHAR2 )
    AS

        V_API_VERSION_NUMBER         NUMBER := 1;
        V_RETURN_STATUS              VARCHAR2(2000);
        V_MSG_COUNT                  NUMBER;
        V_MSG_DATA                   VARCHAR2(2000);

-- IN Variables --
        V_HEADER_REC                 OE_ORDER_PUB.HEADER_REC_TYPE;
        V_LINE_TBL                   OE_ORDER_PUB.LINE_TBL_TYPE;
        V_ACTION_REQUEST_TBL         OE_ORDER_PUB.REQUEST_TBL_TYPE;
        V_LINE_ADJ_TBL               OE_ORDER_PUB.LINE_ADJ_TBL_TYPE;

-- OUT Variables --
        V_HEADER_REC_OUT             OE_ORDER_PUB.HEADER_REC_TYPE;
        V_HEADER_VAL_REC_OUT         OE_ORDER_PUB.HEADER_VAL_REC_TYPE;
        V_HEADER_ADJ_TBL_OUT         OE_ORDER_PUB.HEADER_ADJ_TBL_TYPE;
        V_HEADER_ADJ_VAL_TBL_OUT     OE_ORDER_PUB.HEADER_ADJ_VAL_TBL_TYPE;
        V_HEADER_PRICE_ATT_TBL_OUT   OE_ORDER_PUB.HEADER_PRICE_ATT_TBL_TYPE;
        V_HEADER_ADJ_ATT_TBL_OUT     OE_ORDER_PUB.HEADER_ADJ_ATT_TBL_TYPE;
        V_HEADER_ADJ_ASSOC_TBL_OUT   OE_ORDER_PUB.HEADER_ADJ_ASSOC_TBL_TYPE;
        V_HEADER_SCREDIT_TBL_OUT     OE_ORDER_PUB.HEADER_SCREDIT_TBL_TYPE;
        V_HEADER_SCREDIT_VAL_TBL_OUT OE_ORDER_PUB.HEADER_SCREDIT_VAL_TBL_TYPE;
        V_LINE_TBL_OUT               OE_ORDER_PUB.LINE_TBL_TYPE;
        V_LINE_VAL_TBL_OUT           OE_ORDER_PUB.LINE_VAL_TBL_TYPE;
        V_LINE_ADJ_TBL_OUT           OE_ORDER_PUB.LINE_ADJ_TBL_TYPE;
        V_LINE_ADJ_VAL_TBL_OUT       OE_ORDER_PUB.LINE_ADJ_VAL_TBL_TYPE;
        V_LINE_PRICE_ATT_TBL_OUT     OE_ORDER_PUB.LINE_PRICE_ATT_TBL_TYPE;
        V_LINE_ADJ_ATT_TBL_OUT       OE_ORDER_PUB.LINE_ADJ_ATT_TBL_TYPE;
        V_LINE_ADJ_ASSOC_TBL_OUT     OE_ORDER_PUB.LINE_ADJ_ASSOC_TBL_TYPE;
        V_LINE_SCREDIT_TBL_OUT       OE_ORDER_PUB.LINE_SCREDIT_TBL_TYPE;
        V_LINE_SCREDIT_VAL_TBL_OUT   OE_ORDER_PUB.LINE_SCREDIT_VAL_TBL_TYPE;
        V_LOT_SERIAL_TBL_OUT         OE_ORDER_PUB.LOT_SERIAL_TBL_TYPE;
        V_LOT_SERIAL_VAL_TBL_OUT     OE_ORDER_PUB.LOT_SERIAL_VAL_TBL_TYPE;
        V_ACTION_REQUEST_TBL_OUT     OE_ORDER_PUB.REQUEST_TBL_TYPE;
        
        L_HEADER_REC OE_ORDER_PUB.HEADER_REC_TYPE;

        CURSOR C_BOOKING_SO IS
        SELECT DISTINCT
            ORDER_HEADER_ID
        FROM
            XXAWR_STAGING_LINE_SO
        WHERE
        1=1
        AND UPPER(STATUS) IN ('P', 'V')
              AND UPPER(STG_DEL_INSTR_STATUS) IN ('BOOK')
            AND OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID;
  
    BEGIN
    
        FOR R_BOOKING_SO IN C_BOOKING_SO
        LOOP
            DBMS_OUTPUT.PUT_LINE( 'BOOK K LOOP K ANDAR AYA' || R_BOOKING_SO.ORDER_HEADER_ID);

 /*****************INITIALIZE ENVIRONMENT*************************************/

        FND_GLOBAL.APPS_INITIALIZE(GN_USER_ID , GN_RESP_ID, GN_RESP_APP_ID);
        MO_GLOBAL.INIT('ONT');
        MO_GLOBAL.SET_POLICY_CONTEXT('S',GN_ORG_ID);

	/*****************INITIALIZE HEADER RECORD******************************/
            L_HEADER_REC := OE_ORDER_PUB.G_MISS_HEADER_REC;

	/***********POPULATE REQUIRED ATTRIBUTES **********************************/

            V_ACTION_REQUEST_TBL(1)              := OE_ORDER_PUB.G_MISS_REQUEST_REC;
            V_ACTION_REQUEST_TBL(1).REQUEST_TYPE := OE_GLOBALS.G_BOOK_ORDER;
            V_ACTION_REQUEST_TBL(1).ENTITY_CODE  := OE_GLOBALS.G_ENTITY_HEADER;
            V_ACTION_REQUEST_TBL(1).ENTITY_ID    := R_BOOKING_SO.ORDER_HEADER_ID;   --- header_id
            DBMS_OUTPUT.PUT_LINE( 'Starting of API');
            OE_ORDER_PUB.PROCESS_ORDER(P_API_VERSION_NUMBER => V_API_VERSION_NUMBER,
                                       P_HEADER_REC         => V_HEADER_REC, 
                                       P_LINE_TBL           => V_LINE_TBL
                                     , P_ACTION_REQUEST_TBL => V_ACTION_REQUEST_TBL
                                   -- OUT variables
                                     , P_LINE_ADJ_TBL       => V_LINE_ADJ_TBL,
                                      X_HEADER_REC          => V_HEADER_REC_OUT, 
                                      X_HEADER_VAL_REC      => V_HEADER_VAL_REC_OUT,
                                      X_HEADER_ADJ_TBL      => V_HEADER_ADJ_TBL_OUT
                                      , X_HEADER_ADJ_VAL_TBL=> V_HEADER_ADJ_VAL_TBL_OUT,
                                      X_HEADER_PRICE_ATT_TBL=> V_HEADER_PRICE_ATT_TBL_OUT
                                      ,X_HEADER_ADJ_ATT_TBL => V_HEADER_ADJ_ATT_TBL_OUT, 
                                      X_HEADER_ADJ_ASSOC_TBL=> V_HEADER_ADJ_ASSOC_TBL_OUT
                                      , X_HEADER_SCREDIT_TBL=> V_HEADER_SCREDIT_TBL_OUT, 
                                      X_HEADER_SCREDIT_VAL_TBL => V_HEADER_SCREDIT_VAL_TBL_OUT
                                      , X_LINE_TBL             => V_LINE_TBL_OUT
                                      ,X_LINE_VAL_TBL          => V_LINE_VAL_TBL_OUT,
                                      X_LINE_ADJ_TBL           => V_LINE_ADJ_TBL_OUT
                                      , X_LINE_ADJ_VAL_TBL     => V_LINE_ADJ_VAL_TBL_OUT
                                      , X_LINE_PRICE_ATT_TBL   => V_LINE_PRICE_ATT_TBL_OUT
                                      , X_LINE_ADJ_ATT_TBL     => V_LINE_ADJ_ATT_TBL_OUT
                                      ,X_LINE_ADJ_ASSOC_TBL    => V_LINE_ADJ_ASSOC_TBL_OUT
                                      , X_LINE_SCREDIT_TBL     => V_LINE_SCREDIT_TBL_OUT,
                                      X_LINE_SCREDIT_VAL_TBL   => V_LINE_SCREDIT_VAL_TBL_OUT
                                      , X_LOT_SERIAL_TBL       => V_LOT_SERIAL_TBL_OUT,
                                      X_LOT_SERIAL_VAL_TBL     => V_LOT_SERIAL_VAL_TBL_OUT,
                                      X_ACTION_REQUEST_TBL     => V_ACTION_REQUEST_TBL_OUT
                                      , X_RETURN_STATUS        => V_RETURN_STATUS
                                      , X_MSG_COUNT            => V_MSG_COUNT
                                      , X_MSG_DATA             => V_MSG_DATA);

            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Completion of API');
            IF V_RETURN_STATUS = FND_API.G_RET_STS_SUCCESS THEN
                COMMIT;
                DBMS_OUTPUT.PUT_LINE('Booking of an Existing Order is Success ' || V_RETURN_STATUS);
             
               UPDATE_BOOKING_DETAILS_STAG(R_BOOKING_SO.ORDER_HEADER_ID,IN_P_OIC_INSTANCE_ID);
            
            
            ELSE
                DBMS_OUTPUT.PUT_LINE( 'Booking of an Existing Order failed:'
                                                || V_RETURN_STATUS
                                                || V_MSG_DATA);
                ROLLBACK;


/********************************
Update Staging
********************************/
        UPDATE XXAWR_STAGING_HEADER_SO
        SET STATUS      = 'E'
        , ERROR_MSG         = 'Error in BOOKING Sales Order HEADER'
        WHERE 1 = 1
        AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
        AND ORDER_HEADER_ID = R_BOOKING_SO.ORDER_HEADER_ID;
 
/********************************
Update Staging
********************************/
        UPDATE XXAWR_STAGING_LINE_SO
        SET STATUS     = 'E'
        , ERROR_MSG        = 'Error in BOOKING Sales Order LINE'
        WHERE 1 = 1
        AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
        AND ORDER_HEADER_ID = R_BOOKING_SO.ORDER_HEADER_ID;
         COMMIT;


      FOR I IN 1..V_MSG_COUNT
      LOOP
          V_MSG_DATA := OE_MSG_PUB.GET(P_MSG_INDEX => I
		                               , P_ENCODED => 'F');
          DBMS_OUTPUT.PUT_LINE(I     || ') '                || V_MSG_DATA);
                END LOOP;

            END IF;
        END LOOP;
    END SALES_ORDER_BOOKING;



/*******************************************************************************************************************
    * Program Name   : UPDATE_ORDER_CREATE_DETAILS
    * Language       : PL/SQL
    * Description    : Procedure To UPDATE ORDER CREATION DETAILS INTO Staging Table
    * History        :
    * WHO              WHAT                                                          WHEN
    * --------------   -------------------------------------------------------       --------------
    *                   Update Data in order details in Staging Table                   2024
    *******************************************************************************************************************/
    PROCEDURE UPDATE_ORDER_CREATE_DETAILS (
                IN_SF_ORDER_ID       IN VARCHAR2,
                IN_P_HEADER_ID       IN NUMBER,
                IN_P_OIC_INSTANCE_ID IN NUMBER
    )
    AS

    CURSOR C_LINE
    IS
    SELECT LINE_NUMBER,STG_LINE_ID
    FROM XXAWR_STAGING_LINE_SO
    WHERE STATUS    ='V'
    AND OIC_INSTANCE_ID =IN_P_OIC_INSTANCE_ID;
    BEGIN
		/*****************************************************************************************
        PROCEDURE TO UPDATE ORDER NUMBER AND HEADER AND LINE ID AND ERRORS  ENCOUNTERED IN API
        *****************************************************************************************/
        BEGIN

   DBMS_OUTPUT.PUT_LINE('STARTRED ORDER CREAT UPDATE DETAILS');


            UPDATE XXAWR_STAGING_HEADER_SO
            SET
                ORDER_HEADER_ID = IN_P_HEADER_ID,
                ORDER_NUMBER    = (
                    SELECT DISTINCT
                        OE.ORDER_NUMBER
                    FROM
                        OE_ORDER_HEADERS_ALL OE
                        
                    WHERE
                            OE.HEADER_ID = IN_P_HEADER_ID
                        AND OE.ORG_ID = GN_ORG_ID
                ),
                FLOW_STATUS_CODE_HDR = (
                    SELECT
                        FLOW_STATUS_CODE
                    FROM
                        OE_ORDER_HEADERS_ALL OE
                    WHERE 1=1
                        AND OE.HEADER_ID = IN_P_HEADER_ID
                        AND OE.ORG_ID = GN_ORG_ID
                )
                ,CUSTOMER_PO_NUM=nvl( (
                    SELECT DISTINCT
                        OE.ORDER_NUMBER
                    FROM
                        OE_ORDER_HEADERS_ALL OE
                        
                    WHERE
                            OE.HEADER_ID = IN_P_HEADER_ID
                        AND OE.ORG_ID = GN_ORG_ID
                ),0)+NVL(LPO_NUMBER,0)
                ,STATUS='P',
                CREATED_BY=GN_USER_ID,
                LAST_UPDATED_BY=GN_USER_ID,
                CREATED_DATE=SYSDATE,
                LAST_UPDATED_DATE=SYSDATE,
                LAST_LOGIN=GN_USER_ID
            WHERE 1=1
            AND SF_ORDER_ID = IN_SF_ORDER_ID
            AND OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID;
            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('CANT UPDATE ALL DATA IN HEADER STAGING');
        END;


        FOR REC_LINE IN C_LINE
        LOOP
        BEGIN

            UPDATE XXAWR_STAGING_LINE_SO
            SET
                ORDER_HEADER_ID = IN_P_HEADER_ID,
                LINE_ID=(SELECT LINE_ID FROM OE_ORDER_LINES_ALL
                WHERE LINE_NUMBER=REC_LINE.LINE_NUMBER
                AND HEADER_ID=IN_P_HEADER_ID),
                 ORDER_NUMBER    = (
                    SELECT DISTINCT
                        OE.ORDER_NUMBER
                    FROM
                        OE_ORDER_HEADERS_ALL OE
                    WHERE
                            OE.HEADER_ID = IN_P_HEADER_ID
                        AND OE.ORG_ID = GN_ORG_ID )          
                ,STATUS='P'
                ,FLOW_STATUS_CODE_LINE = (
                    SELECT DISTINCT  FLOW_STATUS_CODE
                    FROM OE_ORDER_LINES_ALL OE
                    WHERE 1=1
                        AND OE.HEADER_ID = IN_P_HEADER_ID
                        AND OE.ORG_ID = GN_ORG_ID
                        AND LINE_NUMBER=REC_LINE.LINE_NUMBER
                ),
                CREATED_BY=GN_USER_ID,
                LAST_UPDATED_BY=GN_USER_ID,
                CREATION_DATE=SYSDATE,
                LAST_UPDATE_DATE=SYSDATE
                
--               ,STG_HEADER_ID=(SELECT
--                DISTINCT  STG_HEADER_ID FROM XXAWR_STAGING_HEADER_SO
--                WHERE ORDER_HEADER_ID=IN_P_HEADER_ID
--                AND OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID)
            
            WHERE
                    SF_ORDER_ID = IN_SF_ORDER_ID
                    AND LINE_NUMBER=REC_LINE.LINE_NUMBER
                    AND UPPER(STG_DEL_INSTR_STATUS) IS NOT NULL --('DRAFT')
                    AND OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID

;
            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('CANT UPDATE ALL DATA IN LINE STAGING');
END ;
END LOOP;
    END UPDATE_ORDER_CREATE_DETAILS;



    /*******************************************************************************************************************
    * Program Name   : SALES_ORDER_CREATION
    * Language       : PL/SQL
    * Description    : Procedure To Create Sales Order
    * History        :
    * WHO              WHAT                                                          WHEN
    * --------------   -------------------------------------------------------       --------------
    *                    Procedure To Create Sales Order                                 2024
    *******************************************************************************************************************/

    PROCEDURE SALES_ORDER_CREATION(IN_P_OIC_INSTANCE_ID IN VARCHAR2
    
    )IS

		/**********PROCEDURE FOR SALES ORDER CREATION ******************/
        L_RETURN_STATUS              VARCHAR2(1000);
        L_MSG_COUNT                  NUMBER;
        L_MSG_DATA                   VARCHAR2(1000);
        P_API_VERSION_NUMBER         NUMBER := 1.0;
        P_INIT_MSG_LIST              VARCHAR2(10) := FND_API.G_FALSE;
        P_RETURN_VALUES              VARCHAR2(10) := FND_API.G_FALSE;
        P_ACTION_COMMIT              VARCHAR2(10) := FND_API.G_FALSE;
        X_RETURN_STATUS              VARCHAR2(1);
        X_MSG_COUNT                  NUMBER;
        X_MSG_DATA                   VARCHAR2(100);
        L_HEADER_REC                 OE_ORDER_PUB.HEADER_REC_TYPE;
        L_LINE_TBL                   OE_ORDER_PUB.LINE_TBL_TYPE;
        L_ACTION_REQUEST_TBL         OE_ORDER_PUB.REQUEST_TBL_TYPE;
        L_HEADER_ADJ_TBL             OE_ORDER_PUB.HEADER_ADJ_TBL_TYPE;
        L_LINE_ADJ_TBL               OE_ORDER_PUB.LINE_ADJ_TBL_TYPE;
        L_HEADER_SCR_TBL             OE_ORDER_PUB.HEADER_SCREDIT_TBL_TYPE;
        L_LINE_SCREDIT_TBL           OE_ORDER_PUB.LINE_SCREDIT_TBL_TYPE;
        L_REQUEST_REC                OE_ORDER_PUB.REQUEST_REC_TYPE;
        X_HEADER_REC                 OE_ORDER_PUB.HEADER_REC_TYPE := OE_ORDER_PUB.G_MISS_HEADER_REC;
        P_OLD_HEADER_REC             OE_ORDER_PUB.HEADER_REC_TYPE := OE_ORDER_PUB.G_MISS_HEADER_REC;
        P_HEADER_VAL_REC             OE_ORDER_PUB.HEADER_VAL_REC_TYPE := OE_ORDER_PUB.G_MISS_HEADER_VAL_REC;
        P_OLD_HEADER_VAL_REC         OE_ORDER_PUB.HEADER_VAL_REC_TYPE := OE_ORDER_PUB.G_MISS_HEADER_VAL_REC;
        P_HEADER_ADJ_TBL             OE_ORDER_PUB.HEADER_ADJ_TBL_TYPE := OE_ORDER_PUB.G_MISS_HEADER_ADJ_TBL;
        P_OLD_HEADER_ADJ_TBL         OE_ORDER_PUB.HEADER_ADJ_TBL_TYPE := OE_ORDER_PUB.G_MISS_HEADER_ADJ_TBL;
        P_HEADER_ADJ_VAL_TBL         OE_ORDER_PUB.HEADER_ADJ_VAL_TBL_TYPE := OE_ORDER_PUB.G_MISS_HEADER_ADJ_VAL_TBL;
        P_OLD_HEADER_ADJ_VAL_TBL     OE_ORDER_PUB.HEADER_ADJ_VAL_TBL_TYPE := OE_ORDER_PUB.G_MISS_HEADER_ADJ_VAL_TBL;
        P_HEADER_PRICE_ATT_TBL       OE_ORDER_PUB.HEADER_PRICE_ATT_TBL_TYPE := OE_ORDER_PUB.G_MISS_HEADER_PRICE_ATT_TBL;
        P_OLD_HEADER_PRICE_ATT_TBL   OE_ORDER_PUB.HEADER_PRICE_ATT_TBL_TYPE := OE_ORDER_PUB.G_MISS_HEADER_PRICE_ATT_TBL;
        P_HEADER_ADJ_ATT_TBL         OE_ORDER_PUB.HEADER_ADJ_ATT_TBL_TYPE := OE_ORDER_PUB.G_MISS_HEADER_ADJ_ATT_TBL;
        P_OLD_HEADER_ADJ_ATT_TBL     OE_ORDER_PUB.HEADER_ADJ_ATT_TBL_TYPE := OE_ORDER_PUB.G_MISS_HEADER_ADJ_ATT_TBL;
        P_HEADER_ADJ_ASSOC_TBL       OE_ORDER_PUB.HEADER_ADJ_ASSOC_TBL_TYPE := OE_ORDER_PUB.G_MISS_HEADER_ADJ_ASSOC_TBL;
        P_OLD_HEADER_ADJ_ASSOC_TBL   OE_ORDER_PUB.HEADER_ADJ_ASSOC_TBL_TYPE := OE_ORDER_PUB.G_MISS_HEADER_ADJ_ASSOC_TBL;
        P_HEADER_SCREDIT_TBL         OE_ORDER_PUB.HEADER_SCREDIT_TBL_TYPE := OE_ORDER_PUB.G_MISS_HEADER_SCREDIT_TBL;
        P_OLD_HEADER_SCREDIT_TBL     OE_ORDER_PUB.HEADER_SCREDIT_TBL_TYPE := OE_ORDER_PUB.G_MISS_HEADER_SCREDIT_TBL;
        P_HEADER_SCREDIT_VAL_TBL     OE_ORDER_PUB.HEADER_SCREDIT_VAL_TBL_TYPE := OE_ORDER_PUB.G_MISS_HEADER_SCREDIT_VAL_TBL;
        P_OLD_HEADER_SCREDIT_VAL_TBL OE_ORDER_PUB.HEADER_SCREDIT_VAL_TBL_TYPE := OE_ORDER_PUB.G_MISS_HEADER_SCREDIT_VAL_TBL;
        X_LINE_VAL_TBL               OE_ORDER_PUB.LINE_VAL_TBL_TYPE;
        X_LINE_ADJ_TBL               OE_ORDER_PUB.LINE_ADJ_TBL_TYPE;
        X_LINE_ADJ_VAL_TBL           OE_ORDER_PUB.LINE_ADJ_VAL_TBL_TYPE;
        X_LINE_PRICE_ATT_TBL         OE_ORDER_PUB.LINE_PRICE_ATT_TBL_TYPE;
        X_LINE_ADJ_ATT_TBL           OE_ORDER_PUB.LINE_ADJ_ATT_TBL_TYPE;
        X_LINE_ADJ_ASSOC_TBL         OE_ORDER_PUB.LINE_ADJ_ASSOC_TBL_TYPE;
        X_LINE_SCREDIT_TBL           OE_ORDER_PUB.LINE_SCREDIT_TBL_TYPE;
        X_LINE_SCREDIT_VAL_TBL       OE_ORDER_PUB.LINE_SCREDIT_VAL_TBL_TYPE;
        X_LOT_SERIAL_TBL             OE_ORDER_PUB.LOT_SERIAL_TBL_TYPE;
        X_LOT_SERIAL_VAL_TBL         OE_ORDER_PUB.LOT_SERIAL_VAL_TBL_TYPE;
        X_ACTION_REQUEST_TBL         OE_ORDER_PUB.REQUEST_TBL_TYPE;
        P_LINE_TBL                   OE_ORDER_PUB.LINE_TBL_TYPE := OE_ORDER_PUB.G_MISS_LINE_TBL;
        P_OLD_LINE_TBL               OE_ORDER_PUB.LINE_TBL_TYPE := OE_ORDER_PUB.G_MISS_LINE_TBL;
        P_LINE_VAL_TBL               OE_ORDER_PUB.LINE_VAL_TBL_TYPE := OE_ORDER_PUB.G_MISS_LINE_VAL_TBL;
        P_OLD_LINE_VAL_TBL           OE_ORDER_PUB.LINE_VAL_TBL_TYPE := OE_ORDER_PUB.G_MISS_LINE_VAL_TBL;
        P_LINE_ADJ_TBL               OE_ORDER_PUB.LINE_ADJ_TBL_TYPE := OE_ORDER_PUB.G_MISS_LINE_ADJ_TBL;
        P_OLD_LINE_ADJ_TBL           OE_ORDER_PUB.LINE_ADJ_TBL_TYPE := OE_ORDER_PUB.G_MISS_LINE_ADJ_TBL;
        P_LINE_ADJ_VAL_TBL           OE_ORDER_PUB.LINE_ADJ_VAL_TBL_TYPE := OE_ORDER_PUB.G_MISS_LINE_ADJ_VAL_TBL;
        P_OLD_LINE_ADJ_VAL_TBL       OE_ORDER_PUB.LINE_ADJ_VAL_TBL_TYPE := OE_ORDER_PUB.G_MISS_LINE_ADJ_VAL_TBL;
        P_LINE_PRICE_ATT_TBL         OE_ORDER_PUB.LINE_PRICE_ATT_TBL_TYPE := OE_ORDER_PUB.G_MISS_LINE_PRICE_ATT_TBL;
        P_OLD_LINE_PRICE_ATT_TBL     OE_ORDER_PUB.LINE_PRICE_ATT_TBL_TYPE := OE_ORDER_PUB.G_MISS_LINE_PRICE_ATT_TBL;
        P_LINE_ADJ_ATT_TBL           OE_ORDER_PUB.LINE_ADJ_ATT_TBL_TYPE := OE_ORDER_PUB.G_MISS_LINE_ADJ_ATT_TBL;
        P_OLD_LINE_ADJ_ATT_TBL       OE_ORDER_PUB.LINE_ADJ_ATT_TBL_TYPE := OE_ORDER_PUB.G_MISS_LINE_ADJ_ATT_TBL;
        P_LINE_ADJ_ASSOC_TBL         OE_ORDER_PUB.LINE_ADJ_ASSOC_TBL_TYPE := OE_ORDER_PUB.G_MISS_LINE_ADJ_ASSOC_TBL;
        P_OLD_LINE_ADJ_ASSOC_TBL     OE_ORDER_PUB.LINE_ADJ_ASSOC_TBL_TYPE := OE_ORDER_PUB.G_MISS_LINE_ADJ_ASSOC_TBL;
        P_LINE_SCREDIT_TBL           OE_ORDER_PUB.LINE_SCREDIT_TBL_TYPE := OE_ORDER_PUB.G_MISS_LINE_SCREDIT_TBL;
        P_OLD_LINE_SCREDIT_TBL       OE_ORDER_PUB.LINE_SCREDIT_TBL_TYPE := OE_ORDER_PUB.G_MISS_LINE_SCREDIT_TBL;
        P_LINE_SCREDIT_VAL_TBL       OE_ORDER_PUB.LINE_SCREDIT_VAL_TBL_TYPE := OE_ORDER_PUB.G_MISS_LINE_SCREDIT_VAL_TBL;
        P_OLD_LINE_SCREDIT_VAL_TBL   OE_ORDER_PUB.LINE_SCREDIT_VAL_TBL_TYPE := OE_ORDER_PUB.G_MISS_LINE_SCREDIT_VAL_TBL;
        P_LOT_SERIAL_TBL             OE_ORDER_PUB.LOT_SERIAL_TBL_TYPE := OE_ORDER_PUB.G_MISS_LOT_SERIAL_TBL;
        P_OLD_LOT_SERIAL_TBL         OE_ORDER_PUB.LOT_SERIAL_TBL_TYPE := OE_ORDER_PUB.G_MISS_LOT_SERIAL_TBL;
        P_LOT_SERIAL_VAL_TBL         OE_ORDER_PUB.LOT_SERIAL_VAL_TBL_TYPE := OE_ORDER_PUB.G_MISS_LOT_SERIAL_VAL_TBL;
        P_OLD_LOT_SERIAL_VAL_TBL     OE_ORDER_PUB.LOT_SERIAL_VAL_TBL_TYPE := OE_ORDER_PUB.G_MISS_LOT_SERIAL_VAL_TBL;
        P_ACTION_REQUEST_TBL         OE_ORDER_PUB.REQUEST_TBL_TYPE := OE_ORDER_PUB.G_MISS_REQUEST_TBL;
        X_HEADER_VAL_REC             OE_ORDER_PUB.HEADER_VAL_REC_TYPE;
        X_HEADER_ADJ_TBL             OE_ORDER_PUB.HEADER_ADJ_TBL_TYPE;
        X_HEADER_ADJ_VAL_TBL         OE_ORDER_PUB.HEADER_ADJ_VAL_TBL_TYPE;
        X_HEADER_PRICE_ATT_TBL       OE_ORDER_PUB.HEADER_PRICE_ATT_TBL_TYPE;
        X_HEADER_ADJ_ATT_TBL         OE_ORDER_PUB.HEADER_ADJ_ATT_TBL_TYPE;
        X_HEADER_ADJ_ASSOC_TBL       OE_ORDER_PUB.HEADER_ADJ_ASSOC_TBL_TYPE;
        X_HEADER_SCREDIT_TBL         OE_ORDER_PUB.HEADER_SCREDIT_TBL_TYPE;
        X_HEADER_SCREDIT_VAL_TBL     OE_ORDER_PUB.HEADER_SCREDIT_VAL_TBL_TYPE;
        X_DEBUG_FILE                 VARCHAR2(100);
        L_LINE_TBL_INDEX             NUMBER := 0;
        L_MSG_INDEX_OUT              NUMBER(10);
        LC_API_ERROR_MESSAGE         VARCHAR2(2000);



        CURSOR C_HEADER IS
        SELECT *
        FROM
            XXAWR_STAGING_HEADER_SO
        WHERE 1 = 1
        AND STATUS = 'V' 
        AND OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID;
        
        
        
        CURSOR C_LINES (
            P_SF_ORDER_ID NUMBER
        ) IS
        SELECT *
        FROM
            XXAWR_STAGING_LINE_SO
        WHERE 1 = 1
         AND STATUS = 'V'
         AND UPPER(STG_DEL_INSTR_STATUS) IS NOT NULL  -- ('DRAFT')
         AND SF_ORDER_ID = P_SF_ORDER_ID
         AND OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID;



    BEGIN

        DBMS_OUTPUT.PUT_LINE('Api Calling  SO CREATION -1');
        FND_GLOBAL.APPS_INITIALIZE(GN_USER_ID , GN_RESP_ID, GN_RESP_APP_ID);
        MO_GLOBAL.INIT('ONT');
        MO_GLOBAL.SET_POLICY_CONTEXT('S', GN_ORG_ID);
        OE_MSG_PUB.INITIALIZE;
        OE_DEBUG_PUB.INITIALIZE;
        X_DEBUG_FILE := OE_DEBUG_PUB.SET_DEBUG_MODE('FILE');
        OE_DEBUG_PUB.SETDEBUGLEVEL(5);


        FOR REC_HEADER IN C_HEADER
          LOOP

                LC_API_ERROR_MESSAGE := '';
                L_RETURN_STATUS := '';
                L_HEADER_REC := OE_ORDER_PUB.G_MISS_HEADER_REC;
                L_HEADER_REC.OPERATION := OE_GLOBALS.G_OPR_CREATE;
                L_HEADER_REC.TRANSACTIONAL_CURR_CODE := REC_HEADER.TRANSACTIONAL_CURR_CODE;
                L_HEADER_REC.PRICING_DATE := SYSDATE;
                L_HEADER_REC.SOLD_TO_ORG_ID := REC_HEADER.CUSTOMER_ID;
--                l_header_rec.ship_to_org_id := REC_HEADER.ship_from_org_id;
                L_HEADER_REC.PRICE_LIST_ID := REC_HEADER.PRICE_LIST_ID;
                L_HEADER_REC.ORDERED_DATE := SYSDATE;
                L_HEADER_REC.SOLD_FROM_ORG_ID := REC_HEADER.SOLD_FROM_ORG_ID;
                L_HEADER_REC.SALESREP_ID := REC_HEADER.SALESREP_ID;
                L_HEADER_REC.ORDER_TYPE_ID := REC_HEADER.ORDERED_TYPE_ID;
                L_HEADER_REC.ATTRIBUTE1 := REC_HEADER.SF_ORDER_ID;


              FOR REC_LINE IN C_LINES(REC_HEADER.SF_ORDER_ID)
              LOOP
                       L_LINE_TBL_INDEX := L_LINE_TBL_INDEX + 1;
                        DBMS_OUTPUT.PUT_LINE('Line count' || L_LINE_TBL_INDEX);



            BEGIN						
            UPDATE XXAWR_STAGING_LINE_SO
            SET LINE_NUMBER=L_LINE_TBL_INDEX
            WHERE STATUS='V'
            AND STG_LINE_ID=REC_LINE.STG_LINE_ID;
            COMMIT;
            EXCEPTION
           WHEN OTHERS THEN
           DBMS_OUTPUT.PUT_LINE('ERROR OCCURED TO UPDATE LINE NUMBER IN STAGING'||SQLCODE||SQLERRM);
                  END ;

                        L_LINE_TBL(L_LINE_TBL_INDEX) := OE_ORDER_PUB.G_MISS_LINE_REC;
                        L_LINE_TBL(L_LINE_TBL_INDEX).OPERATION := OE_GLOBALS.G_OPR_CREATE;
                        L_LINE_TBL(L_LINE_TBL_INDEX).ORDERED_QUANTITY := REC_LINE.ORDERED_QUANTITY;
                        L_LINE_TBL(L_LINE_TBL_INDEX).SHIP_FROM_ORG_ID := REC_LINE.SHIP_FROM_ORG_ID;
                        L_LINE_TBL(L_LINE_TBL_INDEX).INVENTORY_ITEM_ID := REC_LINE.ITEM_ID;
                        L_LINE_TBL(L_LINE_TBL_INDEX).ATTRIBUTE1 := REC_LINE.SF_LINE_ID;

                        END LOOP;-- end line loop

                L_LINE_TBL_INDEX:=0;
     COMMIT;     

                          OE_ORDER_PUB.PROCESS_ORDER(P_API_VERSION_NUMBER => 1.0,
                           P_INIT_MSG_LIST => FND_API.G_FALSE,
                           P_RETURN_VALUES => FND_API.G_FALSE,
                           P_ACTION_COMMIT => FND_API.G_FALSE,
                           X_RETURN_STATUS => L_RETURN_STATUS,
                           X_MSG_COUNT => L_MSG_COUNT,
                           X_MSG_DATA => L_MSG_DATA, 
                           P_HEADER_REC => L_HEADER_REC, 
                           P_LINE_TBL => L_LINE_TBL,
                           P_ACTION_REQUEST_TBL => L_ACTION_REQUEST_TBL,
                                -- OUT PARAMETERS
                           X_HEADER_REC => X_HEADER_REC,
                           X_HEADER_VAL_REC => X_HEADER_VAL_REC, 
                           X_HEADER_ADJ_TBL => X_HEADER_ADJ_TBL,
                           X_HEADER_ADJ_VAL_TBL => X_HEADER_ADJ_VAL_TBL,
                           X_HEADER_PRICE_ATT_TBL => X_HEADER_PRICE_ATT_TBL,
                           X_HEADER_ADJ_ATT_TBL => X_HEADER_ADJ_ATT_TBL, 
                           X_HEADER_ADJ_ASSOC_TBL => X_HEADER_ADJ_ASSOC_TBL,
                           X_HEADER_SCREDIT_TBL => X_HEADER_SCREDIT_TBL,
                           X_HEADER_SCREDIT_VAL_TBL => X_HEADER_SCREDIT_VAL_TBL,
                           X_LINE_TBL => P_LINE_TBL,
                           X_LINE_VAL_TBL => X_LINE_VAL_TBL, 
                           X_LINE_ADJ_TBL => X_LINE_ADJ_TBL, 
                           X_LINE_ADJ_VAL_TBL => X_LINE_ADJ_VAL_TBL,
                           X_LINE_PRICE_ATT_TBL => X_LINE_PRICE_ATT_TBL, 
                           X_LINE_ADJ_ATT_TBL => X_LINE_ADJ_ATT_TBL,
                            X_LINE_ADJ_ASSOC_TBL => X_LINE_ADJ_ASSOC_TBL, 
                            X_LINE_SCREDIT_TBL => X_LINE_SCREDIT_TBL,
                            X_LINE_SCREDIT_VAL_TBL => X_LINE_SCREDIT_VAL_TBL,
                            X_LOT_SERIAL_TBL => X_LOT_SERIAL_TBL,
                            X_LOT_SERIAL_VAL_TBL => X_LOT_SERIAL_VAL_TBL,
                            X_ACTION_REQUEST_TBL => L_ACTION_REQUEST_TBL);
       
                FOR I IN 1..L_MSG_COUNT
                LOOP
                    OE_MSG_PUB.GET(P_MSG_INDEX => I, 
                    P_ENCODED => FND_API.G_FALSE, 
                    P_DATA => L_MSG_DATA, 
                    P_MSG_INDEX_OUT => L_MSG_INDEX_OUT
                    );

                    DBMS_OUTPUT.PUT_LINE('message : ' || L_MSG_DATA);
                    DBMS_OUTPUT.PUT_LINE('message index : ' || L_MSG_INDEX_OUT);
                    LC_API_ERROR_MESSAGE := LC_API_ERROR_MESSAGE || L_MSG_DATA;
                    DBMS_OUTPUT.PUT_LINE('Api Calling -8');
                END LOOP;

   -- Check the return status
                IF L_RETURN_STATUS = FND_API.G_RET_STS_SUCCESS THEN
                    DBMS_OUTPUT.PUT_LINE('Order Created Successfull');
                    DBMS_OUTPUT.PUT_LINE('Order Header_ID : ' || X_HEADER_REC.HEADER_ID);

                UPDATE_ORDER_CREATE_DETAILS(REC_HEADER.SF_ORDER_ID,X_HEADER_REC.HEADER_ID,
                                            IN_P_OIC_INSTANCE_ID);

                ELSE
                    DBMS_OUTPUT.PUT_LINE('Order Creation Failed');
/********************************
Update Staging
********************************/
           UPDATE XXAWR_STAGING_HEADER_SO
           SET STATUS = 'E'
           , ERROR_MSG = 'Error in creating Sales Order'||LC_API_ERROR_MESSAGE
            WHERE 1 = 1
             AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
             AND STG_HEADER_ID   = REC_HEADER.STG_HEADER_ID;
 
/********************************
Update Staging
********************************/
        UPDATE XXAWR_STAGING_LINE_SO
        SET STATUS = 'E'
        , ERROR_MSG = 'Error in creating Sales Order'||LC_API_ERROR_MESSAGE
          WHERE 1 = 1
          AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
          AND SF_ORDER_ID = REC_HEADER.SF_ORDER_ID;
 COMMIT;
                END IF;



            END LOOP;
    EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' ||SQLCODE||'--'|| SQLERRM);
    END SALES_ORDER_CREATION;



    /*******************************************************************************************************************
    * Program Name   : XXAWR_STAGING_VALIDATION
    * Language       : PL/SQL
    * Description    : Procedure To VALIDATE VALUES IN STAGING TABLE
    * History        :
    * WHO              WHAT                                                          WHEN
    * --------------   -------------------------------------------------------       --------------
    *                    Procedure To VALIDATE VALUES IN STAGING TABLE                  2024
    *******************************************************************************************************************/


  /**********PROCEDURE TO VALIDATE DATA IN STAGING TABLES ******************/

    PROCEDURE XXAWR_STAGING_VALIDATION (IN_P_OIC_INSTANCE_ID IN NUMBER)
    
AS
      CURSOR C_HEADER
      IS
        SELECT * FROM
        XXAWR_STAGING_HEADER_SO
        WHERE
        1=1
        AND STATUS ='N'
        AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;         
            
        TYPE CUR_SO_DATA_TYPE_HDR IS TABLE OF C_HEADER%ROWTYPE INDEX BY PLS_INTEGER;
        SO_DATA_HDR             CUR_SO_DATA_TYPE_HDR;




        CURSOR C_LINES (
            P_SF_ORDER_ID IN VARCHAR2
        ) IS
        SELECT * FROM
            XXAWR_STAGING_LINE_SO
        WHERE
        1=1
         AND STATUS ='N'
         AND  OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
         AND  SF_ORDER_ID = P_SF_ORDER_ID ;
           
            
        TYPE CUR_SO_DATA_TYPE_LINE IS TABLE OF C_LINES%ROWTYPE INDEX BY PLS_INTEGER;
        SO_DATA_LINE            CUR_SO_DATA_TYPE_LINE;



-->local variable
        LN_CURRENCY_COUNT       NUMBER;
        LN_UOM_COUNT            NUMBER;
        LN_TRANSACTION_QUANTITY NUMBER;
    BEGIN
        OPEN C_HEADER;
        LOOP
            FETCH C_HEADER
            BULK COLLECT INTO SO_DATA_HDR LIMIT 500;
            FOR I IN 1..SO_DATA_HDR.COUNT 
            LOOP
                SO_DATA_HDR(I).STATUS := 'V';
                SO_DATA_HDR(I).ERROR_MSG := '';


     /******************************************
         Customer validation ie sold to org
	 *********************************************/

                    BEGIN
                        SELECT
                            HCA.CUST_ACCOUNT_ID
                        INTO SO_DATA_HDR(I).CUSTOMER_ID
                        FROM
                            HZ_PARTIES       HP,
                            HZ_CUST_ACCOUNTS HCA
                        WHERE
                                HP.PARTY_ID = HCA.PARTY_ID
                            AND UPPER(PARTY_NAME) = UPPER(SO_DATA_HDR(I).CUSTOMER_NAME);

                    EXCEPTION
                        WHEN OTHERS THEN
                            SO_DATA_HDR(I).STATUS := 'E';
                            SO_DATA_HDR(I).ERROR_MSG := SO_DATA_HDR(I).ERROR_MSG
                                                        || '-Customer name is invalid'
                                                        || SQLCODE
                                                        || SQLERRM;

                    END;

/*********************************
	*VALIDATING PRICE LIST 
*********************************/

                    BEGIN
                        SELECT
                            LIST_HEADER_ID
                        INTO SO_DATA_HDR(I).PRICE_LIST_ID
                        FROM
                            QP_LIST_HEADERS_TL
                        WHERE
                            LOWER(NAME) = LOWER(SO_DATA_HDR(I).PRICE_LIST_NAME);

                    EXCEPTION
                        WHEN OTHERS THEN
                            SO_DATA_HDR(I).STATUS := 'E';
                            SO_DATA_HDR(I).ERROR_MSG := SO_DATA_HDR(I).ERROR_MSG
                                                        || 'ERROR IN VALIDATING PRICE LIST'
                                                        || SQLCODE
                                                        || SQLERRM;

                    END;

/*****************************************
    Sold from Organization validation
*******************************************/
                    BEGIN
                        SELECT
                            ORGANIZATION_ID
                        INTO SO_DATA_HDR(I).SOLD_FROM_ORG_ID
                        FROM
                            HR_ORGANIZATION_UNITS
                        WHERE
                            LOWER(NAME) = LOWER(SO_DATA_HDR(I).SOLD_FROM_ORG_NAME);

                    EXCEPTION
                        WHEN OTHERS THEN
                            SO_DATA_HDR(I).STATUS := 'E';
                            SO_DATA_HDR(I).ERROR_MSG := SO_DATA_HDR(I).ERROR_MSG
                                                        || '-Sold from organization is invalid'
                                                        || SQLCODE
                                                        || SQLERRM;

                    END;


	/********************************
	*SALESPERSON VALIDATION
	*********************************/
                    BEGIN
                        SELECT
                            SALESREP_ID
                        INTO SO_DATA_HDR(I).SALESREP_ID
                        FROM
                            RA_SALESREPS_ALL
                        WHERE
                                UPPER(NAME) = UPPER(SO_DATA_HDR(I).SALESREP_NAME)
                            AND ( SYSDATE BETWEEN START_DATE_ACTIVE AND NVL(END_DATE_ACTIVE, SYSDATE + 1) )
                            AND ORG_ID = SO_DATA_HDR(I).SOLD_FROM_ORG_ID;

                    EXCEPTION
                        WHEN OTHERS THEN
                            SO_DATA_HDR(I).STATUS := 'E';
                            SO_DATA_HDR(I).ERROR_MSG := SO_DATA_HDR(I).ERROR_MSG
                                                        || 'ERROR IN VALIDATING SALESPERSON   '
                                                        || SQLCODE
                                                        || SQLERRM;

                    END;

	/*******************************
	*VALIDATING ORDER TYPE
	********************************/

                    BEGIN
                        SELECT
                            TRANSACTION_TYPE_ID
                        INTO SO_DATA_HDR(I).ORDERED_TYPE_ID
                        FROM
                            OE_TRANSACTION_TYPES_TL
                        WHERE
                            UPPER(NAME) = UPPER(SO_DATA_HDR(I).ORDER_TYPE_NAME);

                    EXCEPTION
                        WHEN OTHERS THEN
                            SO_DATA_HDR(I).STATUS := 'E';
                            SO_DATA_HDR(I).ERROR_MSG := SO_DATA_HDR(I).ERROR_MSG
                                                        || 'ERROR IN VALIDATING ORDER TYPE'
                                                        || SQLCODE
                                                        || SQLERRM;

                    END;




	/********************************
	*CURRENCY CODE VALIDATION
	*********************************/

             BEGIN
                    SELECT
                        COUNT(CURRENCY_CODE)
                    INTO LN_CURRENCY_COUNT
                    FROM
                        FND_CURRENCIES
                    WHERE
                        UPPER(CURRENCY_CODE) = UPPER(SO_DATA_HDR(I).TRANSACTIONAL_CURR_CODE);

                    IF LN_CURRENCY_COUNT = 0 THEN
                        SO_DATA_HDR(I).STATUS := 'E';
                        SO_DATA_HDR(I).ERROR_MSG := SO_DATA_HDR(I).ERROR_MSG
                                                    || ' TRANSACTIONAL CURRENCY CODE DOES NOT EXIST'
                                                    || SQLCODE
                                                    || SQLERRM;

                    END IF;

            END;

                --->CURSOR OPEN FOR LINE



UPDATE XXAWR_STAGING_LINE_SO
SET
STG_HEADER_ID=SO_DATA_HDR(I).STG_HEADER_ID
WHERE 
SF_ORDER_ID=SO_DATA_HDR(I).SF_ORDER_ID
and OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID;


                OPEN C_LINES(SO_DATA_HDR(I).SF_ORDER_ID);
                LOOP

                    FETCH C_LINES
                    BULK COLLECT INTO SO_DATA_LINE LIMIT 500;
                    FOR I IN 1..SO_DATA_LINE.COUNT LOOP
                        SO_DATA_LINE(I).STATUS := 'V';
                        SO_DATA_LINE(I).ERROR_MSG := '';

             
             
                
	/********************************
	*UOM CODE VALIDATION
	*********************************/

                        IF SO_DATA_LINE(I).UOM_CODE IS NULL THEN
                            SO_DATA_LINE(I).STATUS := 'E';
                            SO_DATA_LINE(I).ERROR_MSG := SO_DATA_LINE(I).ERROR_MSG
                                                         || ' UOM CODE IS NULL'
                                                         || SQLCODE
                                                         || SQLERRM;

                        ELSE
                            SELECT
                                COUNT(UOM_CODE)
                            INTO LN_UOM_COUNT
                            FROM
                                MTL_UNITS_OF_MEASURE
                            WHERE
                                UPPER(UOM_CODE) = UPPER(SO_DATA_LINE(I).UOM_CODE);

                            IF LN_UOM_COUNT = 0 THEN
                                SO_DATA_LINE(I).STATUS := 'E';
                                SO_DATA_LINE(I).ERROR_MSG := SO_DATA_LINE(I).ERROR_MSG
                                                             || ' UOM_CODE  CODE DOES NOT EXIST'
                                                             || SQLCODE
                                                             || SQLERRM;

                            END IF;

                        END IF;

/*****************
ship from Org
*******************/

                        IF SO_DATA_LINE(I).SHIP_FROM_ORG_NAME IS NULL THEN
                            SO_DATA_LINE(I).STATUS := 'E';
                            SO_DATA_LINE(I).ERROR_MSG := SO_DATA_LINE(I).ERROR_MSG
                                                         || 'SHIP FROM ORG NAME CAN NOT BE NULL'
                                                         || SQLCODE
                                                         || SQLERRM;

                        ELSE
                            BEGIN
                                SELECT
                                    ORGANIZATION_ID
                                INTO SO_DATA_LINE(I).SHIP_FROM_ORG_ID
                                FROM
                                    ORG_ORGANIZATION_DEFINITIONS
                                WHERE
                                    UPPER(ORGANIZATION_NAME) = UPPER(SO_DATA_LINE(I).SHIP_FROM_ORG_NAME);



/*********************************
	*ITEM VALIDATION
*********************************/

                                IF SO_DATA_LINE(I).ITEM_NAME IS NULL THEN
                                    SO_DATA_LINE(I).STATUS := 'E';
                                    SO_DATA_LINE(I).ERROR_MSG := SO_DATA_LINE(I).ERROR_MSG
                                                                 || 'ITEM NAME CAN NOT BE NULL'
                                                                 || SQLCODE
                                                                 || SQLERRM;

                                ELSE
                                    BEGIN
                                        SELECT
                                            INVENTORY_ITEM_ID
                                        INTO SO_DATA_LINE(I).ITEM_ID
                                        FROM
                                            MTL_SYSTEM_ITEMS_B
                                        WHERE
                                                UPPER(SEGMENT1) = UPPER(SO_DATA_LINE(I).ITEM_NAME)
                                            AND ORGANIZATION_ID = SO_DATA_LINE(I).SHIP_FROM_ORG_ID;



	/********************************
	*QUANTITY VALIDATION
	*********************************/

                                        IF SO_DATA_LINE(I).ORDERED_QUANTITY IS NULL THEN
                                            SO_DATA_LINE(I).STATUS := 'E';
                                            SO_DATA_LINE(I).ERROR_MSG := SO_DATA_LINE(I).ERROR_MSG
                                                                         || ' QUANTITY IS NULL'
                                                                         || SQLCODE
                                                                         || SQLERRM;

                                        ELSE
                                            IF SO_DATA_LINE(I).ORDERED_QUANTITY <= 0 THEN
                                                SO_DATA_LINE(I).STATUS := 'E';
                                                SO_DATA_LINE(I).ERROR_MSG := SO_DATA_LINE(I).ERROR_MSG
                                                                             || ' QUANTITY CAN NOT BE ZERO OR LESS THAN ZERO'
                                                                             || SQLCODE
                                                                             || SQLERRM;

                                            ELSE 

	/*****************************
	*CHECKING ONHAND QUANTITIES 
	******************************/
                                                BEGIN
                                                    SELECT
                                                        SUM(TRANSACTION_QUANTITY),
                                                        INVENTORY_ITEM_ID
                                                    INTO
                                                        LN_TRANSACTION_QUANTITY,
                                                        SO_DATA_LINE(I).ITEM_ID
                                                    FROM
                                                        MTL_ONHAND_QUANTITIES
                                                    WHERE
                                                            INVENTORY_ITEM_ID = SO_DATA_LINE(I).ITEM_ID
                                                        AND ORGANIZATION_ID = SO_DATA_LINE(I).SHIP_FROM_ORG_ID
                                                    GROUP BY
                                                        INVENTORY_ITEM_ID;

                                                    IF LN_TRANSACTION_QUANTITY < SO_DATA_LINE(I).ORDERED_QUANTITY THEN
                                                        SO_DATA_LINE(I).STATUS := 'E';
                                                        SO_DATA_LINE(I).ERROR_MSG := SO_DATA_LINE(I).ERROR_MSG
                                                                                     || 'ONHAND QUANITITY FAILED TO SATISFY RESERVATION'
                                                                                     || SQLCODE
                                                                                     || SQLERRM;

                                                    END IF;

                                                EXCEPTION
                                                    WHEN OTHERS THEN
                                                        SO_DATA_LINE(I).STATUS := 'E';
                                                        SO_DATA_LINE(I).ERROR_MSG := SO_DATA_LINE(I).ERROR_MSG
                                                                                     || 'ITEM DOES NOT EXIST IN SELECTED WAREHOUSE'
                                                                                     || SQLCODE
                                                                                     || SQLERRM;

                                                END;
                                            END IF;
                                        END IF;

                                    EXCEPTION
                                        WHEN OTHERS THEN
                                            SO_DATA_LINE(I).STATUS := 'E';
                                            SO_DATA_LINE(I).ERROR_MSG := SO_DATA_LINE(I).ERROR_MSG
                                                                         || 'ITEM NAME DOES NOT EXIST'
                                                                         || SQLCODE
                                                                         || SQLERRM;

                                    END;
                                END IF;

                            EXCEPTION
                                WHEN OTHERS THEN
                                    SO_DATA_LINE(I).STATUS := 'E';
                                    SO_DATA_LINE(I).ERROR_MSG := SO_DATA_LINE(I).ERROR_MSG
                                                                 || 'SHIP FROM ORG DOES NOT EXIST '
                                                                 || SQLCODE
                                                                 || SQLERRM;

                            END;
                        END IF;

                        BEGIN
     UPDATE XXAWR_STAGING_LINE_SO
                            SET
                                SHIP_FROM_ORG_ID = SO_DATA_LINE(I).SHIP_FROM_ORG_ID,
                                ITEM_ID = SO_DATA_LINE(I).ITEM_ID,
                                STATUS = SO_DATA_LINE(I).STATUS,
                                ERROR_MSG = SO_DATA_LINE(I).ERROR_MSG                     
                       ,ORGANIZATION_ID=GN_ORG_ID
                       WHERE
                                SF_ORDER_ID = SO_DATA_LINE(I).SF_ORDER_ID
								AND SF_LINE_ID=SO_DATA_LINE(I).SF_LINE_ID 
                                AND OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID;

                            COMMIT;
                        EXCEPTION
                            WHEN OTHERS THEN
                                DBMS_OUTPUT.PUT_LINE('UPDATE ERROR IN LINE' || SQLCODE
                                                     || '-'|| SQLERRM);
                                               END;

                    END LOOP;

                    EXIT WHEN SO_DATA_LINE.COUNT = 0;
                END LOOP;

                CLOSE C_LINES;  
                BEGIN
                    UPDATE XXAWR_STAGING_HEADER_SO
                    SET
                        SALESREP_ID = SO_DATA_HDR(I).SALESREP_ID,
                        ORDERED_DATE = SYSDATE,
                        ORDERED_TYPE_ID = SO_DATA_HDR(I).ORDERED_TYPE_ID,
                        PRICE_LIST_ID = SO_DATA_HDR(I).PRICE_LIST_ID,
                        CUSTOMER_ID = SO_DATA_HDR(I).CUSTOMER_ID,
                        SOLD_FROM_ORG_ID = SO_DATA_HDR(I).SOLD_FROM_ORG_ID,
                        ORGANIZATION_ID=GN_ORG_ID,
                        STATUS = SO_DATA_HDR(I).STATUS,
                        ERROR_MSG = SO_DATA_HDR(I).ERROR_MSG
                                          
                    WHERE 1=1
                        AND  SF_ORDER_ID = SO_DATA_HDR(I).SF_ORDER_ID
                        AND  OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID;

                    DBMS_OUTPUT.PUT_LINE('request id is ' || GN_REQUEST_ID);
                    COMMIT;
                EXCEPTION
                    WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('UPDATE ERROR IN HEADER'
                                             || SQLCODE
                                             || '-'
                                             || SQLERRM);
             
                END;

            END LOOP;

            EXIT WHEN SO_DATA_HDR.COUNT = 0;
        END LOOP;

     CLOSE C_HEADER;
    END XXAWR_STAGING_VALIDATION;






/*******************************************************************************************************************
* Program Name   : XXAWR_VALIDATE_NULL
* Program Type   : Procedure
* Language       : PL/SQL
* Description    : This Procedure is used to validate data from Account Legacy.
* History        :
* WHO              WHAT                                                          WHEN
* --------------   -------------------------------------------------------       --------------
*                     Validate ORDER ID                                             2024
*******************************************************************************************************************/
   PROCEDURE XXAWR_VALIDATE_NULL (IN_P_OIC_INSTANCE_ID IN NUMBER)
   IS


   CURSOR C_HEADER
   IS
   SELECT * FROM XXAWR_STAGING_HEADER_SO
   WHERE STATUS='N'
   AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;
   

   BEGIN
                 
                 
                 
                 
                 FOR R_HEADER IN C_HEADER
                 LOOP
                 BEGIN
                   /************************************************
                   * Update table with Error
                   ************************************************/
                     UPDATE XXAWR_STAGING_HEADER_SO
                        SET STATUS = 'E'
                          , ERROR_MSG =  'SF ORDER ID IS NULL'
                          , LAST_UPDATED_DATE = SYSDATE
                          , LAST_UPDATED_BY = GN_USER_ID
                     WHERE 1=1
                     AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                     AND R_HEADER.SF_ORDER_ID IS NULL;
                     COMMIT;
                       EXCEPTION
                        WHEN OTHERS THEN
                          DBMS_OUTPUT.PUT_LINE('Unexpected Error in Validating Null IN HEADER'
                                 || ' - '
                                 || SQLCODE
                                 || ' - '
                                 || SQLERRM);
                                 END ;
     
        BEGIN
         UPDATE XXAWR_STAGING_HEADER_SO
                        SET STATUS = 'E'
                          , ERROR_MSG =  'CUSTOMER NAME  IS NULL'
                          , LAST_UPDATED_DATE = SYSDATE
                          , LAST_UPDATED_BY = GN_USER_ID
                     WHERE 1=1
                     AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                     AND SF_ORDER_ID=R_HEADER.SF_ORDER_ID
                     AND  R_HEADER.CUSTOMER_NAME IS NULL;
                     COMMIT;
                 
                 EXCEPTION
                 WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Unexpected Error in Validating Null IN HEADER'
                                 || ' - '
                                 || SQLCODE
                                 || ' - '
                                 || SQLERRM);
   END;
   
           BEGIN
                        UPDATE XXAWR_STAGING_HEADER_SO
                        SET STATUS = 'E'
                          , ERROR_MSG =  'PRICE LIST NAME IS NULL'
                          , LAST_UPDATED_DATE = SYSDATE
                          , LAST_UPDATED_BY = GN_USER_ID
                     WHERE 1=1
                     AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                     AND SF_ORDER_ID=R_HEADER.SF_ORDER_ID
                     AND R_HEADER.PRICE_LIST_NAME IS NULL
                     AND STATUS = 'N';
                     COMMIT;
          
          EXCEPTION
          WHEN OTHERS THEN
           DBMS_OUTPUT.PUT_LINE('Unexpected Error in Validating Null IN HEADER'
                                 || ' - '
                                 || SQLCODE
                                 || ' - '
                                 || SQLERRM);
   END;
   
   BEGIN
   UPDATE XXAWR_STAGING_HEADER_SO
                        SET STATUS = 'E'
                          , ERROR_MSG =  'SOLD FROM ORG NAME IS NULL'
                          , LAST_UPDATED_DATE = SYSDATE
                          , LAST_UPDATED_BY = GN_USER_ID
                     WHERE 1=1
                     AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                     AND SF_ORDER_ID=R_HEADER.SF_ORDER_ID
                     AND  R_HEADER.SOLD_FROM_ORG_NAME IS NULL
                     AND STATUS = 'N';
                     COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected Error in Validating Null IN HEADER'
                                 || ' - '
                                 || SQLCODE
                                 || ' - '
                                 || SQLERRM);
   END;
   
   
   BEGIN
   UPDATE XXAWR_STAGING_HEADER_SO
                        SET STATUS = 'E'
                          , ERROR_MSG =  'SALES REPRESENTATIVE  NAME IS NULL'
                          , LAST_UPDATED_DATE = SYSDATE
                          , LAST_UPDATED_BY = GN_USER_ID
                     WHERE 1=1
                     AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                      AND SF_ORDER_ID=R_HEADER.SF_ORDER_ID
                     AND R_HEADER.SALESREP_NAME IS NULL 
                     AND STATUS = 'N';
                     COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected Error in Validating Null IN HEADER'
                                 || ' - '
                                 || SQLCODE
                                 || ' - '
                                 || SQLERRM);
   END;
   
   
   BEGIN
   UPDATE XXAWR_STAGING_HEADER_SO
                        SET STATUS = 'E'
                          , ERROR_MSG =  'ORDER TYPE  IS NULL'
                          , LAST_UPDATED_DATE = SYSDATE
                          , LAST_UPDATED_BY = GN_USER_ID
                     WHERE 1=1
                     AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                      AND SF_ORDER_ID=R_HEADER.SF_ORDER_ID
                     AND R_HEADER.ORDER_TYPE_NAME IS NULL
                      AND STATUS = 'N';
                     COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected Error in Validating Null IN HEADER'
                                 || ' - '
                                 || SQLCODE
                                 || ' - '
                                 || SQLERRM);
   END;
   
   BEGIN
   UPDATE XXAWR_STAGING_HEADER_SO
                        SET STATUS = 'E'
                          , ERROR_MSG =  'TRANSACTIONAL CURR CODE IS NULL'
                          , LAST_UPDATED_DATE = SYSDATE
                          , LAST_UPDATED_BY = GN_USER_ID
                     WHERE 1=1
                     AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                      AND SF_ORDER_ID=R_HEADER.SF_ORDER_ID 
                     AND R_HEADER.TRANSACTIONAL_CURR_CODE IS NULL 
                      AND STATUS = 'N';
                     COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected Error in Validating Null IN HEADER'
                                 || ' - '
                                 || SQLCODE
                                 || ' - '
                                 || SQLERRM);
   END;     
   
   END LOOP;
           
            BEGIN
             UPDATE XXAWR_STAGING_LINE_SO
                        SET STATUS = 'E'
                          , ERROR_MSG =  'SF  ORDER Id is null'
                          , LAST_UPDATE_DATE = SYSDATE
                          , LAST_UPDATED_BY = GN_USER_ID
                     WHERE 1=1
                     AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
                     AND SF_ORDER_ID IS NULL
                     AND STATUS = 'N';
    EXCEPTION
        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected Error in Validating Null IN LINE'
                                 || ' - '
                                 || SQLCODE
                                 || ' - '
                                 || SQLERRM);                     
            END;                            
                
      END XXAWR_VALIDATE_NULL;                



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
    
Procedure onhand_qty_api(p_item_id in varchar2,
                         p_org_id in varchar2,
                         x_qty_atr out number,
                         X_RETURN_STATUS OUT VARCHAR2,
                         x_msg_data out varchar2)
as
v_api_return_STATUS VARCHAR2 (1);
v_qty_oh             NUMBER;
v_qty_res_oh         NUMBER;
v_qty_res            NUMBER;
v_qty_sug            NUMBER;
v_qty_att            NUMBER;
v_qty_atr            NUMBER; --Quantity available to reserve
v_msg_count          NUMBER;
v_msg_data           VARCHAR2(1000);
--v_ITEM_ID  VARCHAR2(250) := '243205';
--v_organization_id    VARCHAR2(10)  := '204';

BEGIN

inv_quantity_tree_grp.clear_quantity_cache;

DBMS_OUTPUT.put_line ('Transaction Mode');
DBMS_OUTPUT.put_line ('Onhand For the Item :'|| p_item_id );
DBMS_OUTPUT.put_line ('Organization        :'|| p_org_id);

apps.INV_QUANTITY_TREE_PUB.QUERY_QUANTITIES
(p_api_version_number  => 1.0,
 p_init_msg_lst        => apps.fnd_api.g_false,
 x_return_STATUS       => v_api_return_STATUS,
 x_msg_count           => v_msg_count,
 x_msg_data            => v_msg_data,
 p_organization_id     => p_org_id,
 p_INVENTORY_ITEM_ID   => p_item_id,
 p_tree_mode           => apps.inv_quantity_tree_pub.g_transaction_mode,
 p_onhand_source       => 3,
 p_is_revision_control => FALSE,
 p_is_lot_control      => FALSE,
 p_is_serial_control   => FALSE,
 p_revision            => NULL,
 p_lot_number          => NULL,
 p_subinventory_code   => NULL,
 p_locator_id          => NULL,
 x_qoh                 => v_qty_oh,
 x_rqoh                => v_qty_res_oh,
 x_qr                  => v_qty_res,
 x_qs                  => v_qty_sug,
 x_att                 => v_qty_att,
 x_atr                 => v_qty_atr);


x_qty_atr:=v_qty_atr;
X_RETURN_STATUS:=v_api_return_STATUS;
X_msg_data:=v_msg_data;

DBMS_OUTPUT.put_line ('on hand Quantity                :'|| v_qty_oh);
DBMS_OUTPUT.put_line ('Reservable quantity on hand     :'|| v_qty_res_oh);
DBMS_OUTPUT.put_line ('Quantity reserved               :'|| v_qty_res);
DBMS_OUTPUT.put_line ('Quantity suggested              :'|| v_qty_sug);
DBMS_OUTPUT.put_line ('Quantity Available To Transact  :'|| v_qty_att);
DBMS_OUTPUT.put_line ('Quantity Available To Reserve   :'|| v_qty_atr);

end onhand_qty_api;

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



PROCEDURE ITEM_RES_INV_VALIDATION_PRC(IN_P_OIC_INSTANCE_ID IN NUMBER
                                     ,IN_ACTION_TYPE in varchar2
)

IS 
    CURSOR  C_ITEM_RES IS
        SELECT * 
        FROM XXAWR_STAGING_LINE_SO 
        WHERE 1=1
             and OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID 
             and STATUS ='N'
             ;
    
    TYPE C_ITEM_RES_TBL_TYPE IS
    TABLE OF C_ITEM_RES%rowtype INDEX BY PLS_INTEGER;

   INV_RES_TBL     C_ITEM_RES_TBL_TYPE;

--Varriable for Item available to reserve  
   ln_qty_atr number;
--Varriable for Onhand qty API STATUS
  lc_return_STATUS varchar2(1);
--Varriable for Onhand quantity Error message
  lc_error_msg varchar2(1000);


BEGIN

open C_ITEM_RES;
        LOOP
        FETCH C_ITEM_RES
        BULK COLLECT INTO INV_RES_TBL LIMIT 100;
            FOR INDX IN 1..INV_RES_TBL.COUNT
            LOOP
                    BEGIN

                     INV_RES_TBL(INDX).STATUS:='V';
                 INV_RES_TBL(INDX).ERROR_MSG:=INV_RES_TBL(INDX).ERROR_MSG || NULL;
              
          -----------------------------------------------------
          --Organization name Validation
          -----------------------------------------------------
                 IF 
                    (INV_RES_TBL(indx).ORGANIZATION_NAME IS NOT NULL)
                 THEN
                     BEGIN
                        select 
                        organization_id 
                        into INV_RES_TBL(indx).organization_id
                        from org_organization_definitions
                        where lower(organization_name)=lower(INV_RES_TBL(indx).organization_name);
                     EXCEPTION
                     WHEN 
                     OTHERS THEN
                                INV_RES_TBL(INDX).ERROR_MSG:=INV_RES_TBL(INDX).ERROR_MSG||' - '|| 
                                                    'Organization not exist';
                                INV_RES_TBL(INDX).STATUS := 'E';
                     END;
                    
                 ELSE
                    INV_RES_TBL(INDX).ERROR_MSG:=INV_RES_TBL(INDX).ERROR_MSG||' - '||
                            'Organization Name is mandotary field and can''t be null';
                    INV_RES_TBL(INDX).STATUS:='E';    
                 END IF;    


         ---------------------------------------------------
         -->Inventory Item Name(Desc) VALIDATION
         ---------------------------------------------------

                    IF 
                    (INV_RES_TBL(indx).ITEM_NAME IS NOT NULL) THEN
                        BEGIN
                            SELECT
                                INVENTORY_ITEM_ID,
                                PRIMARY_UOM_CODE
                                
                            INTO
                                INV_RES_TBL(indx).ITEM_ID,
                                INV_RES_TBL(indx).UOM_CODE
                            FROM
                                mtl_system_items_b
                            WHERE
                                lower(segment1) = lower(INV_RES_TBL(indx).ITEM_NAME)
                                AND organization_id = INV_RES_TBL(indx).organization_id; 

                        EXCEPTION
                        WHEN 
                        OTHERS THEN
                                INV_RES_TBL(INDX).ERROR_MSG:=INV_RES_TBL(INDX).ERROR_MSG||' - '|| 
                                                    'Item not exist';
                                INV_RES_TBL(INDX).STATUS := 'E';
                        END;
                    ELSE
                    INV_RES_TBL(INDX).ERROR_MSG:=INV_RES_TBL(INDX).ERROR_MSG||' - '||
                            'Item description is mandotary field and can''t be null';
                    INV_RES_TBL(INDX).STATUS:='E';
                    END IF;

 
 
        -----------------------------------
        --ORDER NUMBER
        -----------------------------------
        /*
                    IF
                    (INV_RES_TBL(INDX).ORDER_NUMBER IS NOT NULL)
                    THEN
                        begin
                            select oola.header_id,oola.line_id
                            into INV_RES_TBL(INDX).ORDER_header_id,INV_RES_TBL(INDX).ORDER_line_id
                            from oe_order_headers_all ooha,
                                 oe_order_lines_all oola
                            where 1=1
                            and ooha.header_id=oola.header_id
                            and ooha.order_number=INV_RES_TBL(INDX).order_number
                            and oola.ITEM_ID=INV_RES_TBL(indx).ITEM_ID
                            and ooha.flow_STATUS_code='ENTERED'
                            ;
                     
                        exception
                        when
                        others then
                            INV_RES_TBL(INDX).ERROR_MSG:=INV_RES_TBL(INDX).ERROR_MSG||' - '|| 
                                                    'Order Number Does Not Exist/Incorrect/or Not in Entered State';
                                INV_RES_TBL(INDX).STATUS := 'E';
                        end;
                    ELSE
                    INV_RES_TBL(INDX).ERROR_MSG:=INV_RES_TBL(INDX).ERROR_MSG||' - '||
                            'Order number is mandotary field and can''t be null';
                   INV_RES_TBL(INDX).STATUS:='E';
                    END IF;

          */       
         
         if (upper(IN_ACTION_TYPE)='RESERVE')
         then
                          
                     -----------------------------
                     ---Requirement Date
                     -----------------------------
                     IF INV_RES_TBL(indx).REQUIREMENT_DATE is null 
                     then
                                    INV_RES_TBL(INDX).ERROR_MSG:=INV_RES_TBL(INDX).ERROR_MSG||' - '||
                                          'Requirement Date is mandotary field and can''t be null';
                                       INV_RES_TBL(INDX).STATUS:='E'; 
                                       
                     Elsif(INV_RES_TBL(indx).REQUIREMENT_DATE>sysdate)
                     then
                                    INV_RES_TBL(INDX).ERROR_MSG:=INV_RES_TBL(INDX).ERROR_MSG||' - '||
                                          'Requirement Date can''t be less then Present Date ';
                                       INV_RES_TBL(INDX).STATUS:='E'; 
                     end if;
               
                                                  
                  -----------------------------------------------------
                       --Validating quantity
                  -----------------------------------------------------
   
                       if(INV_RES_TBL(INDX).RESERVATION_QUANTITY is null)
                       then 
                           INV_RES_TBL(INDX).STATUS :='E';
                           INV_RES_TBL(INDX).error_msg :=INV_RES_TBL(INDX).error_msg||'Reservation Quantity is required field and can''t be null';                        
                       elsif(INV_RES_TBL(INDX).RESERVATION_QUANTITY <= 0)
                       then
                           INV_RES_TBL(INDX).STATUS :='E';
                           INV_RES_TBL(INDX).error_msg :=INV_RES_TBL(INDX).error_msg||'Reservation Quantity can''t be less than or equal to 0';                        
                       else
                       
                       ln_qty_atr:=0;
                       
                       --Calling onhand qunatity procedure to get Available to reserve qunatity
                        onhand_qty_api(INV_RES_TBL(indx).ITEM_ID,
                                      INV_RES_TBL(indx).organization_id,
                                      ln_qty_atr,
                                      lc_return_STATUS,
                                      lc_error_msg);
                                      
                        if(lc_return_STATUS='S')
                        then
                              if(ln_qty_atr<INV_RES_TBL(INDX).RESERVATION_QUANTITY)
                              then
                              INV_RES_TBL(INDX).STATUS :='E';
                              INV_RES_TBL(INDX).error_msg :=INV_RES_TBL(INDX).error_msg||'Quantity demanded for Reservation is greater than Available to Reserve Quantity';                        
                              end if;
                        else
                              INV_RES_TBL(INDX).STATUS :='E';
                              INV_RES_TBL(INDX).error_msg :=INV_RES_TBL(INDX).error_msg||lc_error_msg;                        
                        
                        end if;
   
                       end if;                    
                    
                    
             end if;
                    
                    
                    /***********************************************
                    ** Updating Staging Table
                    ***********************************************/
                    Begin
                    update  XXAWR_STAGING_LINE_SO 
                    set
                        --who columns updation
                        CREATION_DATE=SYSDATE,
                        CREATED_BY=0,         -- g_user_id
                        LAST_UPDATE_DATE=SYSDATE,
                        LAST_UPDATED_BY=0,    -- g_user_id
                        STATUS=INV_RES_TBL(INDX).STATUS,
                        ERROR_MSG=INV_RES_TBL(INDX).ERROR_MSG,
                        --
                        RESERVATION_QUANTITY=INV_RES_TBL(INDX).RESERVATION_QUANTITY,
--                        ORDER_HEADER_ID=INV_RES_TBL(INDX).ORDER_HEADER_ID,
--                        ORDER_LINE_ID=INV_RES_TBL(INDX).ORDER_LINE_ID,
                        OIC_INSTANCE_ID=INV_RES_TBL(indx).OIC_INSTANCE_ID,---IN_P_OIC_INSTANCE_ID
                        REQUIREMENT_DATE=INV_RES_TBL(indx).REQUIREMENT_DATE,
                        ITEM_ID=INV_RES_TBL(INDX).ITEM_ID,
                        UOM_CODE=INV_RES_TBL(indx).UOM_CODE,
                        ORGANIZATION_ID=INV_RES_TBL(INDX).ORGANIZATION_ID,
                        STG_DEL_INSTR_STATUS=upper(IN_ACTION_TYPE)
                    where 1=1
                    and STATUS='N'
                    and STG_line_ID=INV_RES_TBL(INDX).STG_line_ID
                    and oic_instance_id=IN_P_OIC_INSTANCE_ID
--                    AND REQUEST_ID=G_REQUEST_ID
                    ;

                   
                    EXCEPTION
                    WHEN
                    OTHERS THEN 
                    DBMS_OUTPUT.PUT_LINE('Unexcpected Erros while Updating Staging table '||SQLcode||' - '||SQLERRM);
                    end;
                    
                
                    EXCEPTION 
                    WHEN
                    OTHERS THEN
                        dbms_output.put_line('Coming In Validation Procedure--ERROR IN UPDATING FETCHING VALUES');
                    END ;
                        dbms_output.put_line('Competed validation Prc');
            END LOOP;
                        EXIT 
                        WHEN
                        INV_RES_TBL.count = 0;

        END LOOP;  
      commit;
close C_ITEM_RES;
EXCEPTION
WHEN
OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Unexpected Error in Validation Procdure '||SQLCODE||'-'||SQLERRM);
END ITEM_RES_INV_VALIDATION_PRC;

PROCEDURE CREATE_RESERVATION_API_PRC(IN_P_OIC_INSTANCE_ID IN NUMBER)
AS

   p_rsv                     inv_reservation_global.mtl_reservation_rec_type;
   p_dummy_sn                inv_reservation_global.serial_number_tbl_type;
   x_msg_count               NUMBER;
   x_msg_data                VARCHAR2(240);
   x_rsv_id                  NUMBER;
   x_dummy_sn                inv_reservation_global.serial_number_tbl_type;
   x_STATUS                  VARCHAR2(1);
   x_qty                     NUMBER ;
   lv_subinv_code            VARCHAR2 (30);
   
   
      l_demand_source_id number;


   

   ----------------------------------------
CURSOR C_CREATE_RES_API
is
    SELECT * 
    FROM XXAWR_STAGING_LINE_SO 
    WHERE 1=1
    AND OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID
    AND STATUS='V';
  
TYPE  C_CREATE_RES_API_TBL_TYPE is
TABLE OF C_CREATE_RES_API%ROWTYPE INDEX BY PLS_INTEGER;

CRT_RES_TBL  C_CREATE_RES_API_TBL_TYPE;

   
  
BEGIN
   fnd_global.apps_initialize(0,G_resp_id,G_resp_appl_id);
   
    OPEN C_CREATE_RES_API;

    LOOP
    FETCH C_CREATE_RES_API
    BULK COLLECT INTO CRT_RES_TBL LIMIT 100;
        FOR INDX IN 1..CRT_RES_TBL.count
        LOOP
            BEGIN
            
                    SELECT transaction_source_type_id 
                    into l_demand_source_id
                    FROM MTL_TXN_SOURCE_TYPES
                    WHERE 1=1 
                    and transaction_source_type_name = 'AWRL SF Orders Reservations';            
         
                       
                          p_rsv.requirement_date            := CRT_RES_TBL(INDX).REQUIREMENT_DATE;
                          p_rsv.organization_id             := CRT_RES_TBL(INDX).ORGANIZATION_ID   ; --mtl_parameters.organization id
                          p_rsv.INVENTORY_ITEM_ID           := CRT_RES_TBL(INDX).ITEM_ID;--mtl_system_items.ITEM_ID;
                          p_rsv.demand_source_type_id       :=  l_demand_source_id;---- inv_reservation_global.g_source_type_oe; -- which is 2
                          p_rsv.demand_source_name          := 'TEST_RESERVE1'; -- AWRL_reserve_sf_order_id
                          p_rsv.demand_source_header_id     :=null;  -- CRT_RES_TBL(INDX).ORDER_HEADER_ID;      
                          p_rsv.demand_source_line_id       := null;  --CRT_RES_TBL(INDX).ORDER_LINE_ID;        
                          p_rsv.PRIMARY_UOM_CODE            := CRT_RES_TBL(INDX).UOM_CODE;     --'Ea';
                          p_rsv.primary_uom_id              := NULL;
                          p_rsv.reservation_uom_code        := NULL;
                          p_rsv.reservation_uom_id          := NULL;
                          p_rsv.reservation_quantity        := CRT_RES_TBL(INDX).RESERVATION_QUANTITY;    --CRT_RES_TBL(INDX).STG_del_instruction_quantity
                          p_rsv.primary_reservation_quantity := CRT_RES_TBL(INDX).RESERVATION_QUANTITY;--null;
                          p_rsv.lot_number                  := NULL;--p_lot_number;
                          p_rsv.locator_id                  :=   null;
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
                             , x_return_STATUS            =>       x_STATUS
                             , x_msg_count                =>       x_msg_count
                             , x_msg_data                 =>       x_msg_data
                             , p_rsv_rec                  =>       p_rsv
                             , p_serial_number            =>       p_dummy_sn
                             , x_serial_number            =>       x_dummy_sn
                             , x_quantity_reserved        =>       x_qty
                             , x_reservation_id           =>       x_rsv_id
                             
                          );
                          dbms_output.put_line('Return STATUS    = '||x_STATUS);
                          dbms_output.put_line('msg count        = '||to_char(x_msg_count));
                          dbms_output.put_line('msg data         = '||x_msg_data);
                          dbms_output.put_line('Quantity reserved = '||to_char(x_qty));
                          dbms_output.put_line('Reservation id   = '||to_char(x_rsv_id));
                          
                          ---------------------------------------------------
                          --For Getting Reservation Id in Staging TAble
                          ---------------------------------------------------
                          BEGIN
                          IF (x_STATUS <>'S') THEN
                               UPDATE XXAWR_STAGING_LINE_SO
                               SET   STATUS=x_STATUS,
                                    ERROR_MSG=x_msg_data,
									demand_source_type_id=l_demand_source_id
                               WHERE 1=1
                               AND OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID
                               AND STATUS='V'
                               AND STG_line_ID=CRT_RES_TBL(INDX).STG_line_ID; 

/*
                      --Putting STATUS and Error message in Out parameters          
                        SELECT
                            STATUS,
                            error_msg
                        INTO
                            p_STATUS,
                            p_error_msg
                        FROM
                            XXAWR_STAGING_LINE_SO
                        WHERE
                            oic_instance_id = IN_P_OIC_INSTANCE_ID;
*/
                               
                          ELSE
                          UPDATE XXAWR_STAGING_LINE_SO
                          SET 
                               RESERVATION_ID=to_char(x_rsv_id)
                               ,STATUS=   'P'   --x_STATUS  
							   ,demand_source_type_id=l_demand_source_id
                           WHERE 1=1
                           AND   OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID
                           AND   STATUS='V'
                           AND STG_line_ID=CRT_RES_TBL(INDX).STG_line_ID
                          ;

/*
                         --Putting STATUS and Error message in Out parameters          
                           SELECT
                               STATUS,
                               error_msg
                           INTO
                               p_STATUS,
                               p_error_msg
                           FROM
                               XXAWR_STAGING_LINE_SO
                           WHERE
                               oic_instance_id = IN_P_OIC_INSTANCE_ID;
 */                         
                          END IF;
                     EXCEPTION
                          when
                          OTHERS THEN
                     dbms_output.put_line('Unexpected error in Updating Staging table while using unreserve API '||SQLCODE||' - '||SQLERRM);                       
                          END;
                          
                          IF x_msg_count >=1 THEN
                            FOR I IN 1..x_msg_count
                            LOOP
                              dbms_output.put_line(I||'. '||SUBSTR(FND_MSG_PUB.Get(p_encoded => FND_API.G_FALSE ),1, 255));
                            END LOOP;
                            
                          END IF;


                                        EXCEPTION
                                        WHEN 
                                        OTHERS THEN
                                            dbms_output.put_line('Coming In REATE rESERVATUON PROCEDURE ');
                                        END ;
            
      
         END LOOP;
         
                        EXIT 
                        WHEN
                        CRT_RES_TBL.count = 0;

        END LOOP;
      commit;
close C_CREATE_RES_API;


EXCEPTION
WHEN
OTHERS THEN 
DBMS_OUTPUT.PUT_LINE('Unexpected Error in Create Reservation API _-'||SQLCODE||'-'||sqlerrm);
END CREATE_RESERVATION_API_PRC;




   /***************************************************************************************************
    * Object Name       : $UNRESERVE_ITEM_API_PRC
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


PROCEDURE UNRESERVE_ITEM_API_PRC( IN_P_OIC_INSTANCE_ID in number
--                                 ,p_STATUS          OUT VARCHAR2
--                                 ,p_error_msg       OUT VARCHAR2
)
AS

      l_rsv       inv_reservation_global.mtl_reservation_rec_type;
      l_msg_count NUMBER;
      l_msg_data  VARCHAR2(240);
      l_rsv_id    NUMBER;
      l_dummy_sn  inv_reservation_global.serial_number_tbl_type;
      l_STATUS    VARCHAR2(1);
      x_return_STATUS                  VARCHAR2(1);
      x_msg_data                VARCHAR2(1000);
   l_demand_source_id number;

CURSOR C_UNRESESRVE_ITEM
is
    SELECT * 
    FROM XXAWR_STAGING_LINE_SO 
    WHERE 1=1
    AND OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID
    AND STATUS='V';
  
TYPE  C_UNRESESRVE_ITEM_TBL_TYPE is
TABLE OF C_UNRESESRVE_ITEM%ROWTYPE INDEX BY PLS_INTEGER;

UNRES_ITM_TBL  C_UNRESESRVE_ITEM_TBL_TYPE;

BEGIN

--        
--        mo_global.set_policy_context ('S', 548);
--        mo_global.init ('INV');

      fnd_global.apps_initialize(0,g_resp_id,g_resp_appl_id);
      
    SELECT transaction_source_type_id 
    into l_demand_source_id
    FROM MTL_TXN_SOURCE_TYPES
    WHERE 1=1 
    and transaction_source_type_name = 'AWRL SF Orders Reservations';      
      
OPEN C_UNRESESRVE_ITEM;

    LOOP
    FETCH C_UNRESESRVE_ITEM
    BULK COLLECT INTO UNRES_ITM_TBL LIMIT 100;
        FOR INDX in 1..UNRES_ITM_TBL.count
        LOOP
        
        
            BEGIN

                  
            --      l_rsv.reservation_id               := 6827804;                  
                  l_rsv.organization_id            := UNRES_ITM_TBL(INDX).ORGANIZATION_ID;--207;
                  l_rsv.INVENTORY_ITEM_ID            := UNRES_ITM_TBL(INDX).ITEM_ID;--243205;
                  l_rsv.demand_source_type_id        := l_demand_source_id;-- inv_reservation_global.g_source_type_oe; -- order entry
--                  l_rsv.demand_source_header_id      := UNRES_ITM_TBL(INDX).ORDER_HEADER_ID;--462825; --oe_order_headers.header_id
--                  l_rsv.demand_source_line_id        := UNRES_ITM_TBL(INDX).ORDER_LINE_ID;--771300; --oe_order_lines.line_id
             --     l_rsv.supply_source_type_id        := inv_reservation_global.g_source_type_inv;
            --      l_rsv.subinventory_code            := '102'
                  

                 inv_reservation_pub.delete_reservation
                   (
                      p_api_version_number         => 1.0
                     , p_init_msg_lst              => fnd_api.g_true
                     , x_return_STATUS             => l_STATUS
                     , x_msg_count                 => l_msg_count
                     , x_msg_data                  => l_msg_data
                     , p_rsv_rec                   => l_rsv
                     , p_serial_number             => l_dummy_sn
                     );


  dbms_output.put_line(l_STATUS);
  dbms_output.put_line(l_msg_data);
  
                       ---------------------------------------------------
                       --For Getting Reservation Id in Staging TAble
                       ---------------------------------------------------
                       BEGIN
                       IF (l_STATUS <>'S') THEN
                            UPDATE XXAWR_STAGING_LINE_SO
                            SET   STATUS=l_STATUS,
                                 ERROR_MSG=l_msg_data,
								 demand_source_type_id=l_demand_source_id
								 --Also update the demand source name
                            WHERE 1=1
								AND OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID
								AND STATUS='V'
								AND STG_line_ID=UNRES_ITM_TBL(indx).STG_line_ID
                       ;  
                       ELSE
                       UPDATE XXAWR_STAGING_LINE_SO
                       SET 
                          --  RESERVATION_ID=to_char(x_rsv_id),
                            STATUS='P'--l_STATUS
                            ,ERROR_MSG=l_msg_data    
							,demand_source_type_id=l_demand_source_id
                        WHERE 1=1
								AND OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID
								AND STATUS='V'
								AND STG_line_ID=UNRES_ITM_TBL(indx).STG_line_ID
                       ;
                       END IF;
                       
                       /*
                      --Putting STATUS and Error message in Out parameters          
                     SELECT
                         STATUS,
                         error_msg
                     INTO
                         p_STATUS,
                         p_error_msg
                     FROM
                         XXAWR_STAGING_LINE_SO
                     WHERE
                         oic_instance_id = IN_P_OIC_INSTANCE_ID;
                  */
                       EXCEPTION
                       when 
                       OTHERS THEN
                       dbms_output.put_line('Unexpected error in Updating Staging table while using unreserve API '||SQLCODE||' - '||SQLERRM);
                       END;
                       
                 IF 
                 l_STATUS = fnd_api.g_ret_sts_success THEN
                  dbms_output.put_line('reservation deleted');
                 ELSE
                    IF 
                    l_msg_count >=1 THEN
                       FOR I IN 1..l_msg_count
                       LOOP
                         dbms_output.put_line(I||'. '||SUBSTR(FND_MSG_PUB.Get(p_encoded => FND_API.G_FALSE ),1, 255));
                       END LOOP; 
                    END IF;
                 END IF;
                    
                EXCEPTION WHEN 
                OTHERS THEN
                    dbms_output.put_line('Coming In UNRESERVATUON PROCEDURE ');
                END ;
            END LOOP;
                        EXIT
                        WHEN
                        UNRES_ITM_TBL.count = 0;

        END LOOP;                
      commit;
close C_UNRESESRVE_ITEM;

EXCEPTION
WHEN
OTHERS THEN 
DBMS_OUTPUT.PUT_LINE('Unexpected Error in Uneservation API _-'||SQLCODE||'-'||sqlerrm);

END UNRESERVE_ITEM_API_PRC;






    /*******************************************************************************************************************
    * Program Name   : WRAPPER_PROGRAM
    * Language       : PL/SQL
    * Description    : Procedure OF MAIN_PROCEDURE
    * History        :
    * WHO              WHAT                                                          WHEN
    * --------------   -------------------------------------------------------       --------------
    *                    Procedure OF WRAPPER_PROGRAM                                     2024
    *******************************************************************************************************************/


    PROCEDURE WRAPPER_PROGRAM (
         IN_P_OIC_INSTANCE_ID IN NUMBER
       )
IS
LN_RESERVATION_ID NUMBER;
---------------------LOCAL VARIABLES ---------------------------------
LN_COUNT  NUMBER;
LC_STATUS VARCHAR2(240);
LN_COUNT1 NUMBER;    
LC_CODE VARCHAR2(240);
LC_CANCEL_FLAG VARCHAR2(240);
LC_CANCEL_REASON VARCHAR2(240);
LN_HEADER_ID NUMBER;
LN_USER_ID NUMBER;
LC_RESP_ID VARCHAR2(240);
LC_RESP_APP_ID VARCHAR2(240);
LN_LINE_ID NUMBER;
LC_ID VARCHAR2(240);



  CURSOR C_HEADER
  IS
  SELECT * FROM 
   XXAWR_STAGING_HEADER_SO
   WHERE 1=1
   AND OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID
   AND STATUS='N';

   CURSOR C_LINE
   IS
   SELECT * FROM XXAWR_STAGING_LINE_SO 
   WHERE 1=1
   AND OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID
   AND STATUS='N';


BEGIN
  

  BEGIN


    BEGIN
    
    /********************************************
                          GETTING USER ID
        *********************************************/


            SELECT USER_ID 
            INTO GN_USER_ID 
            FROM FND_USER 
            WHERE UPPER(USER_NAME)='RPANWAR';
    EXCEPTION WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE('USER NAME DOESNT EXIST'||SQLCODE||'-'||SQLERRM);


END;


BEGIN
        /********************************************************
             GETTING APPLICATION ID AND RESPONSIBILITY ID
        *********************************************************/


             SELECT APPLICATION_ID,RESPONSIBILITY_ID
             INTO GN_RESP_APP_ID,GN_RESP_ID 
             FROM FND_RESPONSIBILITY_TL
             WHERE RESPONSIBILITY_NAME ='Order Management Super User, Vision Operations (USA)';
 EXCEPTION WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE('APPLICATION NAME , RESPONSIBILITY NAME DOESNT EXIST'||SQLCODE||'-'||SQLERRM);



END;

BEGIN
        /********************************************
                GETTING ORGANIZATION ID
        *********************************************/


            SELECT ORGANIZATION_ID
            INTO GN_ORG_ID
            FROM HR_OPERATING_UNITS  
            WHERE 1 = 1
            AND NAME='Vision Operations';

 EXCEPTION WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE('ORGANIZATION ID DOESNT EXIST'||SQLCODE||'-'||SQLERRM);

END;


begin

/********************************************
RESPONSIBILITY NAME AND ITS APPLICATION NAME
********************************************/      
select responsibility_id
      , application_id
into g_resp_id
   , g_resp_appl_id
from fnd_responsibility_tl 
where 1 = 1
and responsibility_name = 'Inventory, Vision Operations (USA)';


end;


FOR R_LINE IN C_LINE 
LOOP

BEGIN
/*************************************
QUERY TO GET DEL INS
**************************************/

SELECT stg_del_instr_id ,NVL(line_cancel_flag,'N') 
INTO LC_ID,LC_CANCEL_FLAG
FROM XXAWR_STAGING_LINE_SO
WHERE 1=1
AND OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID
AND SF_LINE_ID=R_LINE.SF_LINE_ID
AND STG_LINE_ID=R_LINE.STG_LINE_ID;

 EXCEPTION WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE('ERROR OCCURED IN GETTING STG_DEL_INSTR_ID AND LINE CANCEL FLAG'||SQLCODE||'-'||SQLERRM);

END;

IF LC_ID IS NOT NULL
THEN
   BEGIN
   SELECT  STG_DEL_INSTR_STATUS
   INTO LC_STATUS 
   FROM XXAWR_STAGING_LINE_SO 
   WHERE 1=1
   AND OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID
   AND STG_LINE_ID=R_LINE.STG_LINE_ID;
   
   EXCEPTION WHEN OTHERS THEN 
   DBMS_OUTPUT.PUT_LINE('ERROR OCCURED IN GETTING DELIVERY STATUS'||SQLCODE||'--'||SQLERRM);

END;
IF UPPER(LC_STATUS)='RESERVE'
THEN

     ITEM_RES_INV_VALIDATION_PRC(IN_P_OIC_INSTANCE_ID,LC_STATUS);

 CREATE_RESERVATION_API_PRC(IN_P_OIC_INSTANCE_ID
--                                       ,p_STATUS,p_error_msg
                                 );
 
 else if UPPER(LC_STATUS)='BOOK'
  THEN


BEGIN
SELECT COUNT(RESERVATION_ID) INTO LN_COUNT FROM XXAWR_STAGING_LINE_SO
WHERE OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID;
EXCEPTION WHEN
OTHERS THEN
DBMS_OUTPUT.PUT_LINE('ERROR IN FETCHING RESERVATION ID'||SQLCODE||'--'||SQLERRM);
END;
IF LN_COUNT>0
THEN

    UNRESERVE_ITEM_API_PRC(IN_P_OIC_INSTANCE_ID
--                              ,p_STATUS,p_error_msg
                              );

END IF;



    FOR R_HEADER IN C_HEADER 
    LOOP
      BEGIN


    /***************************************************
           CHECKING IS SF ORDER ID EXIST OR NOT 
    *****************************************************/
      SELECT COUNT(ATTRIBUTE1) 
      INTO LN_COUNT FROM OE_ORDER_HEADERS_ALL 
      WHERE ATTRIBUTE1=R_HEADER.SF_ORDER_ID;


          DBMS_OUTPUT.PUT_LINE(LN_COUNT);

     IF LN_COUNT=0             -----------NOT EXIST CONDICTION
   THEN
     XXAWR_VALIDATE_NULL (IN_P_OIC_INSTANCE_ID);
      XXAWR_STAGING_VALIDATION(IN_P_OIC_INSTANCE_ID);

      SALES_ORDER_CREATION(IN_P_OIC_INSTANCE_ID);
      SALES_ORDER_BOOKING(IN_P_OIC_INSTANCE_ID);
    

   ELSE IF LN_COUNT=1            --------------->EXIST CONDICTION
   THEN

    BEGIN
     /********************************************************************
           QUERY FOR  GETTING FLOW STATUS CODE OF EXISTED SF ORDER ID
     *********************************************************************/

        SELECT FLOW_STATUS_CODE 
        INTO LC_CODE 
        FROM OE_ORDER_HEADERS_ALL
        WHERE ATTRIBUTE1=R_HEADER.SF_ORDER_ID;
   
    EXCEPTION WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE('ERROR IN GETTING FLOW STATUS CODE  FROM OE_ORDER_HEADERS_ALL'||SQLCODE||'-'||SQLERRM);


   END;
DBMS_OUTPUT.PUT_LINE(LC_CODE);

IF LC_CODE='ENTERED'
THEN

BEGIN
       /**********************************************
         	   QUERY TO GET HEADER ID 
	   **********************************************/
         
		 SELECT HEADER_ID 
           INTO LN_HEADER_ID  
         FROM OE_ORDER_HEADERS_ALL
         WHERE ATTRIBUTE1=R_HEADER.SF_ORDER_ID 
         AND FLOW_STATUS_CODE='ENTERED';
 EXCEPTION WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE('ERROR IN GETTING HEADER ID  FOR ENTERED STATUS  '||SQLCODE||'-'||SQLERRM);


END;

BEGIN

/*****************************************************************
     UPDATING LINE STAGING TO GET DETAILS OF BOOKING
******************************************************************/

   
UPDATE XXAWR_STAGING_LINE_SO
SET ORDER_HEADER_ID =LN_HEADER_ID
WHERE SF_ORDER_ID=R_HEADER.SF_ORDER_ID
AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID;
--AND UPPER(STG_DEL_INSTR_STATUS)='BOOK';

EXCEPTION WHEN OTHERS
THEN 
DBMS_OUTPUT.PUT_LINE('ERROR OCCURED IN UPDATIND HEADER ID IN LINE  STAGING  TABLE'||SQLCODE ||'---'||SQLERRM);

END ;
  XXAWR_VALIDATE_NULL (IN_P_OIC_INSTANCE_ID);
      XXAWR_STAGING_VALIDATION(IN_P_OIC_INSTANCE_ID);
   
SALES_ORDER_BOOKING(IN_P_OIC_INSTANCE_ID);


ELSE IF LC_CODE='BOOKED' 
THEN




BEGIN
SELECT COUNT(RESERVATION_ID) INTO LN_COUNT FROM XXAWR_INV_RES_STG
WHERE OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID;
EXCEPTION WHEN
OTHERS THEN
DBMS_OUTPUT.PUT_LINE('ERROR IN FETCHING RESERVATION ID'||SQLCODE||'--'||SQLERRM);
END;
IF LN_COUNT=1
THEN
    UNRESERVE_ITEM_API_PRC(IN_P_OIC_INSTANCE_ID
--                              ,p_STATUS,p_error_msg
                              );

END IF;



/****************************************
QUERY OF GETTING HEADER ID 
*****************************************/


BEGIN

SELECT HEADER_ID 
INTO LN_HEADER_ID  FROM OE_ORDER_HEADERS_ALL
WHERE ATTRIBUTE1=R_HEADER.SF_ORDER_ID 
AND FLOW_STATUS_CODE='BOOKED';

 EXCEPTION WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE('ERROR IN GETTING FLOW STATUS CODE IN BOOKED STATUS'||SQLCODE||'-'||SQLERRM);



END;

BEGIN


/**************************************************
   UPDATING HEADER STAGING Table
****************************************************/

UPDATE XXAWR_STAGING_HEADER_SO
SET ORDER_HEADER_ID =LN_HEADER_ID
WHERE SF_ORDER_ID=R_HEADER.SF_ORDER_ID
AND STG_HEADER_ID=R_HEADER.STG_HEADER_ID
AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
AND STATUS='V';

EXCEPTION WHEN OTHERS
THEN 
DBMS_OUTPUT.PUT_LINE('ERROR OCCURED IN UPDATIND HEADER ID IN HEADER  STAGING  TABLE'||SQLCODE ||'---'||SQLERRM);

END ;


--
--BEGIN
/********************************************************************************
   QUERY OF GETTING DETAILS FROM HEADER STAGING TO CHECK CANCEL CONDICTION
********************************************************************************/


SELECT DISTINCT CANCEL_FLAG,CANCEL_REASON 
INTO LC_CANCEL_FLAG, LC_CANCEL_REASON
FROM XXAWR_STAGING_HEADER_SO
WHERE 1=1
AND SF_ORDER_ID=R_HEADER.SF_ORDER_ID
AND STG_HEADER_ID=R_HEADER.STG_HEADER_ID
AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
AND STATUS='N';

--
-- EXCEPTION WHEN OTHERS THEN
--	DBMS_OUTPUT.PUT_LINE('ERROR IN GETTING CANCEL FLAG AND CANCEL REASON '||SQLCODE||'-'||SQLERRM);



--END;
DBMS_OUTPUT.PUT_LINE(LC_CANCEL_FLAG||'          '||LC_CANCEL_REASON);
   
IF LC_CANCEL_FLAG='Y' AND LC_CANCEL_REASON IS NOT NULL
THEN
  XXAWR_VALIDATE_NULL (IN_P_OIC_INSTANCE_ID);
      XXAWR_STAGING_VALIDATION(IN_P_OIC_INSTANCE_ID);

SALES_ORDER_CANCEL(IN_P_OIC_INSTANCE_ID);   


END IF;--SALES ORDER CANCEL
END IF;  --BOOKED
  END IF;--ENTERED
    END IF;--COUNT 1
     END IF;--COUNT 0
       END ;----END OF BEGIN AFTER LOOP
         END LOOP;--END OF HEADER LOOP
           
   
   
  else if UPPER(LC_STATUS)='DRAFT'
  THEN
  XXAWR_VALIDATE_NULL (IN_P_OIC_INSTANCE_ID);
      XXAWR_STAGING_VALIDATION(IN_P_OIC_INSTANCE_ID);

     SALES_ORDER_CREATION(IN_P_OIC_INSTANCE_ID);
else if UPPER(LC_STATUS)='CANCEL LINE' AND LC_CANCEL_FLAG='Y'
THEN



BEGIN
SELECT COUNT(RESERVATION_ID) INTO LN_COUNT FROM XXAWR_INV_RES_STG
WHERE OIC_INSTANCE_ID=IN_P_OIC_INSTANCE_ID;
EXCEPTION WHEN
OTHERS THEN
DBMS_OUTPUT.PUT_LINE('ERROR IN FETCHING RESERVATION ID'||SQLCODE||'--'||SQLERRM);
END;
IF LN_COUNT=1
THEN
    UNRESERVE_ITEM_API_PRC(IN_P_OIC_INSTANCE_ID
--                              ,p_STATUS,p_error_msg
                              );

END IF;




FOR R_HEADER IN C_HEADER
LOOP



/**************************************************************
   QUERY TO GET DETAILS OF CANCEL LINE IN SALES ORDER
***************************************************************/
SELECT DISTINCT(OOHA.HEADER_ID),OOLA.LINE_ID
INTO LN_HEADER_ID, LN_LINE_ID
FROM OE_ORDER_HEADERS_ALL OOHA, OE_ORDER_LINES_ALL OOLA,
XXAWR_STAGING_LINE_SO XSLS
WHERE 1=1
AND OOLA.ATTRIBUTE1= XSLS.SF_LINE_ID
AND OOHA.ATTRIBUTE1=R_HEADER.SF_ORDER_ID 
AND OOLA.ATTRIBUTE1=R_LINE.SF_LINE_ID
AND OOHA.HEADER_ID=OOLA.HEADER_ID
AND OOHA.FLOW_STATUS_CODE='BOOKED'
AND OOLA.FLOW_STATUS_CODE='AWAITING_SHIPPING'
AND XSLS.STG_DEL_INSTR_STATUS='CANCEL LINE';



--END;
--DBMS_OUTPUT.PUT_LINE(' LN_HEADER_ID ID  '||LN_HEADER_ID);

BEGIN


/*****************************************
   UPDATING LINE STAGING 
******************************************/
UPDATE XXAWR_STAGING_LINE_SO
SET ORDER_HEADER_ID =LN_HEADER_ID
, LINE_ID=LN_LINE_ID
WHERE SF_ORDER_ID=R_HEADER.SF_ORDER_ID
AND STG_LINE_ID=R_LINE.STG_LINE_ID
AND OIC_INSTANCE_ID = IN_P_OIC_INSTANCE_ID
AND STATUS='N';
EXCEPTION WHEN OTHERS
THEN 
DBMS_OUTPUT.PUT_LINE('ERROR OCCURED IN UPDATIND HEADER ID AND LINE ID IN LINE  STAGING TABLE'||SQLCODE ||'---'||SQLERRM);

END ;

           SELECT
                  COUNT(DISTINCT ORDER_HEADER_ID) 
                    INTO LN_COUNT FROM
                          XXAWR_STAGING_LINE_SO
                            WHERE
                              UPPER(STG_DEL_INSTR_STATUS) = 'CANCEL LINE'
                     AND UPPER(LINE_CANCEL_FLAG) = 'Y'
            AND LINE_CANCEL_REASON IS NOT NULL;
        

 DBMS_OUTPUT.PUT_LINE('LINE COUNT IS   ' || LN_COUNT);
   
       IF LN_COUNT > 0 THEN
         XXAWR_VALIDATE_NULL (IN_P_OIC_INSTANCE_ID);
      XXAWR_STAGING_VALIDATION(IN_P_OIC_INSTANCE_ID);

    SALES_ORDER_CANCEL_LINES(IN_P_OIC_INSTANCE_ID);

    END IF;
     END LOOP;--HEADER
       END IF;--CANCEL LINE
         END IF;--DRAFT
            END IF;--END IF OF ENTERED
        END IF;  -- END IF OF LINE COUNT 1
       END IF;  -- END IF OF LINE COUNT 0
    END LOOP;
   END;
END WRAPPER_PROGRAM;



    /*******************************************************************************************************************
    * Program Name   : MAIN_PROCEDURE
    * Language       : PL/SQL
    * Description    : Procedure OF MAIN_PROCEDURE
    * History        :
    * WHO              WHAT                                                          WHEN
    * --------------   -------------------------------------------------------       --------------
    *                    Procedure OF MAIN_PROCEDURE                                     2024
    *******************************************************************************************************************/

    PROCEDURE MAIN_PROCEDURE (
        P_STATUS IN VARCHAR2,
        P_ERROR_MSG IN VARCHAR2,
        IN_P_OIC_INSTANCE_ID IN NUMBER
       )
       
       IS 
       BEGIN
     WRAPPER_PROGRAM (IN_P_OIC_INSTANCE_ID);
              
       END MAIN_PROCEDURE;
END XXAWR_SALES_ORDER_PACKAGE; 