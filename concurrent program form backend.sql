/*********************************************************
* PURPOSE: Submitting a Concurrent Request from backend  *
**********************************************************/
SET SERVEROUTPUT ON;
DECLARE
ln_responsibility_id 	NUMBER;
ln_application_id    	NUMBER;
ln_user_id           	NUMBER;
ln_request_id           NUMBER;
BEGIN
 
  SELECT DISTINCT fr.responsibility_id,
                  frx.application_id
             INTO ln_responsibility_id,
                  ln_application_id
             FROM apps.fnd_responsibility frx,
                  apps.fnd_responsibility_tl fr
            WHERE fr.responsibility_id = frx.responsibility_id
        AND UPPER (fr.responsibility_name) LIKE UPPER('PO');
 
   SELECT user_id INTO ln_user_id FROM fnd_user WHERE user_name = 'RPANWAR';
 
  --To setup environment.
 
  apps.fnd_global.apps_initialize (ln_user_id,ln_responsibility_id,ln_application_id);
 
  --Submitting Concurrent Request
 
  ln_request_id := fnd_request.submit_request ( 
                            application   => 'APPLICATION_SHORT_NAME', 
                            program       => 'XXINTG_SUMBIT_FROM_BACKEND_RP_CP', 
                            description   => 'CONCURRENT PROGRAM TO SUBMIT FROM BACKEND ', 
                            start_time    => sysdate, 
                            sub_request   => FALSE
  );
 
  COMMIT;
 
  IF ln_request_id = 0
  THEN
     dbms_output.put_line ('Concurrent request failed to submit');
  ELSE
     dbms_output.put_line('Successfully Submitted the Concurrent Request');
  END IF;
 
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('Error While Submitting Concurrent Request '
                        ||TO_CHAR(SQLCODE)||'-'||sqlerrm);
END;
