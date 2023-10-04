DECLARE 
P_RETCODE varchar2(4000);
V_REQUEST_SET_EXIST   BOOLEAN := FALSE;
req_id                INTEGER := 0;
l_CONC_PROG_SUBMIT    BOOLEAN := FALSE;
srs_failed            EXCEPTION;
submitprog_failed     EXCEPTION; 
submitset_failed      EXCEPTION;
l_start_date          VARCHAR2(250);
P_ERRBUF varchar2(3000);
L_WAIT_FOR_REQ boolean;
L_PHASE varchar2(200);
    L_STATUS varchar2(200);
    L_DEV_PHASE varchar2(200);
    L_DEV_STATUS varchar2(200);
    L_MESSAGE varchar2(200);
    
    l_user_id varchar2(200):=1014843;
      l_responsibility_id varchar2(200):=24195;
      l_application_id varchar2(200):= 603;
                                  
    
BEGIN

   --To set environment context.

   apps.fnd_global.apps_initialize (l_user_id,
                                    l_responsibility_id,
                                    l_application_id
                                   );




    V_REQUEST_SET_EXIST :=
                          FND_SUBMIT.set_request_set (application   => 'PO',
                            request_set   => 'XXINTG_REQUEST_SET_RP');

IF (NOT V_REQUEST_SET_EXIST)
THEN
RAISE srs_failed;
END IF;

dbms_output.put_line('Calling REQUEST SET first stage');

l_CONC_PROG_SUBMIT :=
fnd_submit.submit_program ('PO',
'XXINTG_PO_INSERT_VALIDATE_RP',
'stage1',
'process type',
'data file name');

IF (NOT l_CONC_PROG_SUBMIT)
THEN
RAISE submitprog_failed;
END IF;

l_CONC_PROG_SUBMIT :=
fnd_submit.submit_program ('PO',
'XXINTG_RECEIPT_PKG_RP',
'stage2');


IF (NOT l_CONC_PROG_SUBMIT)
THEN
RAISE submitprog_failed;
END IF;

l_CONC_PROG_SUBMIT :=
fnd_submit.submit_program ('PO',
'XXINTG_AP_INVOICE_RP',
'stage3');

IF (NOT l_CONC_PROG_SUBMIT)
THEN
RAISE submitprog_failed;
END IF;


dbms_output.put_line( 'Calling submit_set');

select to_char(sysdate,'DD-MON-YYYY HH24:MI:SS')
into l_start_date
from dual;

req_id :=
FND_SUBMIT.submit_set (start_time    => l_start_date,
sub_request   => FALSE);

IF (req_id = 0)
THEN
RAISE submitset_failed;
END IF;
L_WAIT_FOR_REQ :=
    FND_CONCURRENT.WAIT_FOR_REQUEST (req_id
                                    ,5
                                    ,30
                                    ,L_PHASE
                                    ,L_STATUS
                                    ,L_DEV_PHASE
                                    ,L_DEV_STATUS
                                    ,L_MESSAGE);

 

    COMMIT;
EXCEPTION
WHEN srs_failed
THEN
p_errbuf := 'Call to set_request_set failed: ' || fnd_message.get;
p_retcode := 2;
dbms_output.put_line( p_errbuf);
WHEN submitprog_failed
THEN
p_errbuf := 'Call to submit_program failed: ' || fnd_message.get;
p_retcode := 2;
dbms_output.put_line( p_errbuf);
WHEN submitset_failed
THEN
p_errbuf := 'Call to submit_set failed: ' || fnd_message.get;
p_retcode := 2;
dbms_output.put_line( p_errbuf);
END;
