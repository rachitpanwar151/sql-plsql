DECLARE
   l_request_id NUMBER;
   l_bol_delivery BOOLEAN;
BEGIN
   fnd_global.apps_initialize (user_id=>1014843
                              ,resp_id=>20707
                              ,resp_appl_id=>201);
 
 
   l_bol_delivery := fnd_request.add_delivery_option (TYPE             => 'E',
                                                      p_argument1      => 'addingn email in Concurrent Program Output',
                                                      p_argument2      => 'rachit.panwar@intelloger.com',
                                                      p_argument3      => 'demo@test.com',  
                                                      p_argument4      => 'demo@test.com'   
                                                     );
			
   l_request_id := fnd_request.submit_request ( application => 'PO'
                                              , program => 'xxintg_dept_rp'
                                              , description => 'Report of Concurrent Program details'
                                              , start_time => sysdate
                                              , sub_request => FALSE
                                              , argument1 => '10'
                                            
                                              );
   COMMIT;
    
   IF l_request_id = 0 THEN
      dbms_output.put_line('Request not submitted error '|| fnd_message.get);
   ELSE
      dbms_output.put_line('Request submitted successfully request id ' || l_request_id);
   END IF;
EXCEPTION
   WHEN OTHERS THEN
     dbms_output.put_line('Unexpected error ' || SQLERRM);   
END;