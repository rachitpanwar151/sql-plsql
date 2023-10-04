DECLARE
    l_request_id    NUMBER;
   BEGIN
    fnd_global.apps_initialize(user_id => 1014843,
    resp_id => 20707, resp_appl_id => 201);

    l_request_id := fnd_request.submit_request(application => 
    'PO', program => 'xxintg_d_rp',
    description => 'REQUEST CONCURRENT PROGRAM  TO EXECUTE FROM API-BACKEND'
    , start_time => sysdate, sub_request => false);



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