
/***********************************************
procedure of VALIDATING VALUES
************************************************/
PROCEDURE validate_data (
   p_batch_id NUMBER)
   as
--------------------> CURSOR 

CURSOR CUR_PO_STAG
IS
SELECT * FROM XXINTG_PO_STAGING_TABLE_RP 
WHERE STATUS='N' AND request_ID=p_batch_id;
BEGIN
FOR REC_PO_STAG IN CUR_PO_STAG LOOP
BEGIN 
REC_PO_STAG.STATUS:='V';
/********************************
VALIDATING ORGANISATION NAME
*********************************/
IF REC_PO_STAG.Org_name IS NULL THEN
REC_PO_STAG.STATUS:='E';
REC_PO_STAG.ERROR_msg:='Org_name CANNOT BE NULL';
ELSE
BEGIN
SELECT ORGANIZATION_ID 
INTO REC_PO_STAG.ORG_ID   
FROM HR_operating_units WHERE UPPER(NAME)=UPPER(REC_PO_STAG.Org_name);
EXCEPTION WHEN OTHERS
THEN
REC_PO_STAG.STATUS:='E';
REC_PO_STAG.ERROR_msg:=REC_PO_STAG.ERROR_msg||'-'||'Org_name DOESNT EXIST';
END ;
END IF;

/*************************************************
VENDOR NAME VALIDATION
(**************************************************/
IF REC_PO_STAG.VENDOR_NAME IS NULL THEN
REC_PO_STAG.STATUS:='E';
REC_PO_STAG.ERROR_msg:=REC_PO_STAG.ERROR_msg||'-'||' VENDOR NAME CANNOT BE NULL';
ELSE   
   begin
   SELECT VENDOR_ID 
   INTO REC_PO_STAG.VENDOR_ID 
   FROM AP_SUPPLIERS
   WHERE VENDOR_NAME = REC_PO_STAG.VENDOR_NAME;
   EXCEPTION WHEN OTHERS THEN
   
REC_PO_STAG.STATUS:='E';
REC_PO_STAG.ERROR_msg:=REC_PO_STAG.ERROR_msg||'-'||'VENDOR NAME NOT VALID';
   END;
   END IF;
   
   /***********************************************
   VENDOR SITE CODE VALIDATION
   ************************************************/
   BEGIN
   SELECT VENDOR_SITE_ID INTO REC_PO_STAG.VENDOR_SITE_ID FROM 
   AP_SUPPLIER_SITES_ALL WHERE 
   ORG_ID=REC_PO_STAG.ORG_ID
   AND VENDOR_SITE_CODE=REC_PO_STAG.VENDOR_SITE_CODE
   AND VENDOR_ID=REC_PO_STAG.VENDOR_ID;
   EXCEPTION WHEN OTHERS
   THEN
REC_PO_STAG.STATUS:='E';
REC_PO_STAG.ERROR_msg:=REC_PO_STAG.ERROR_msg||'-'||'VENDOR SITE CODE IS INVALID';
   END ;
   
   
   /******************************
   BUYER VALIDATION
   *******************************/
   
   IF REC_PO_STAG.buyer_NAME IS NULL THEN
REC_PO_STAG.STATUS:='E';
REC_PO_STAG.ERROR_msg:=REC_PO_STAG.ERROR_msg||'BUYER NAME CANNOT BE NULL';
   ELSE 
   BEGIN
    SELECT PPL.PERSON_ID
    INTO   REC_PO_STAG.AGENT_ID
    FROM   PO_AGENTS PA, PER_ALL_PEOPLE_F PPL
    WHERE  PA.AGENT_ID = PPL.PERSON_ID
    AND    TRIM(UPPER(PPL.FULL_NAME)) = TRIM(UPPER(REC_PO_STAG.buyer_NAME))
    and TRUNC(SYSDATE) BETWEEN TRUNC(EFFECTIVE_START_DAte) AND TRUNC(effective_end_date)
   and (current_employee_flag='Y' or currenT_npw_flag='Y');
    EXCEPTION WHEN OTHERS THEN
REC_PO_STAG.STATUS:='E';
REC_PO_STAG.ERROR_msg:=REC_PO_STAG.ERROR_msg||'-'||'BUYER NAME IS INVALID';
   END ;
   END IF;
   /*********************************************
   ITEM_Number NAME VALIDATION 
   **********************************************/
   
   IF REC_PO_STAG.ITEM_Name IS NULL THEN
REC_PO_STAG.STATUS:='E';
REC_PO_STAG.ERROR_msg:=REC_PO_STAG.ERROR_msg||'-'||' ITEM NAME CANNOT BE NULL';
   ELSE 
   BEGIN 
   SELECT INVENTORY_ITEM_ID INTO REC_PO_STAG.ITEM_ID FROM MTL_SYSTEM_ITEMS_B WHERE
   upper(SEGMENT1)=upper(REC_PO_STAG.ITEM_Name)
   and organization_id=REC_PO_STAG.org_id;
   EXCEPTION WHEN OTHERS THEN
REC_PO_STAG.STATUS:='E';
REC_PO_STAG.ERROR_msg:=REC_PO_STAG.ERROR_msg||'-'||' ITEM NAME IS INVALID';
   END ;
   END IF;
   /************************************************
   UNIT OF MEASUREMENT VALIDATION
   *************************************************/
   IF REC_PO_STAG.UOM_CODE IS NULL THEN
REC_PO_STAG.STATUS:='E';
REC_PO_STAG.ERROR_msg:=REC_PO_STAG.ERROR_msg||'-'||' UNIT OF MEASURE CANNOT BE NULL';
END IF;

UPDATE XXINTG_PO_STAGING_TABLE_RP SET
STATUS=REC_PO_STAG.STATUS,
ERROR_msg=REC_PO_STAG.ERROR_msg,
ORG_ID=REC_PO_STAG.ORG_ID,
VENDOR_ID=REC_PO_STAG.VENDOR_ID,
VENDOR_SITE_ID=REC_PO_STAG.VENDOR_SITE_ID,
AGENT_ID=REC_PO_STAG.AGENT_ID,   
ITEM_ID=REC_PO_STAG.ITEM_ID
WHERE  REQUEST_ID=REC_PO_STAG.REQUEST_ID
and record_id=rec_po_stag.record_id;
COMMIT;
EXCEPTION WHEN OTHERS THEN
fnd_file.put_line(fnd_file.output, 'backtrace : ' || dbms_utility.format_error_backtrace);
                    fnd_file.put_line(fnd_file.output, 'UNEXPEXTED ERROR IN VALIDATION '
                                                       || sqlcode
                                                       || '|'
                                                       || sqlerrm);

            END;
        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.output, 'ERROR IN VALIDATING DATA '
                                               || sqlcode
                                               || '-'
                                               || sqlerrm);

            fnd_file.put_line(fnd_file.output, dbms_utility.format_error_backtrace);  
   end validate_data;

