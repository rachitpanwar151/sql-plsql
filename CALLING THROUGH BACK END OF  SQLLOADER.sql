DECLARE
    l_request_id NUMBER;
BEGIN
    fnd_global.apps_initialize(user_id => 1014843, resp_id => 20707, resp_appl_id => 201);

    l_request_id := fnd_request.submit_request(
                        application => 'XXINTG',
                        program => 'XXINTG_CUST_DATA_UPLOAD',
                        description => 'REQUEST CONCURRENT PROGRAM  TO EXECUTE FROM API-BACKEND'
                        , start_time => sysdate
                        ,sub_request => FALSE
                        ,argument1 => '/u01/install/APPS/fs1/EBSapps/appl/xxintg/12.0.0/bin/XXINTG_EMP_DATA_UPLOAD_CONTROL_FILE_RP.ctl'
                        ,argument2 => '/tmp/cust/'
                        ,argument3 => 'csv_rp.CSV'
                        ,argument4 => '/tmp/cust/csv_rp.log'
                        , argument5 => '/tmp/cust/csv_rp.bad'
                        ,argument6 => '/tmp/cust/csv_rp.dis'
                        ,argument7 => '/tmp/cust/csv_rp.bad');

    COMMIT;
    IF l_request_id = 0 THEN
        dbms_output.put_line('Request not submitted error ' || fnd_message.get);
    ELSE
        dbms_output.put_line('Request submitted successfully request id ' || l_request_id);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Unexpected error '
                             || sqlcode
                             || ' - '
                             || sqlerrm);
END;