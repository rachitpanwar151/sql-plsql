
select  
            rs.REQUEST_SET_NAME request_set,
            rs.user_request_set_name,
            rss.display_sequence,
            cp.user_concurrent_program_name Concurrent_Program,
            e.executable_name,
            e.execution_file_name ,
            lv.meaning file_type,
            fat.application_name Application_Name

           
    from
        fnd_request_sets_vl rs
        ,fnd_req_set_stages_form_v rss
        ,fnd_request_set_programs rsp
        ,fnd_concurrent_programs_vl cp
        ,fnd_executables e
       
        ,fnd_lookup_values lv
        ,fnd_application_tl fat
       
    where 1=1

    and    rs.REQUEST_SET_NAME like 'XXINTG%RP'
    and rs.application_id=rss.set_application_id
    and rs.request_set_id=rss.request_set_id
    and cp.executable_id=e.executable_id  
    and cp.executable_application_id=e.application_id
    and rss.request_set_id=rsp.request_set_id
    and e.application_id=fat.application_id
    and cp.executable_application_id=e.application_id
   
    AND rss.set_application_id = rsp.set_application_id
AND rss.request_set_stage_id = rsp.request_set_stage_id
AND rsp.program_application_id = cp.application_id
AND rsp.concurrent_program_id = cp.concurrent_program_id
AND lv.lookup_code = e.execution_method_code
AND lv.lookup_type = 'CP_EXECUTION_METHOD_CODE'
    and rs.end_date_active is null
    AND lv.LANGUAGE = 'US'
AND fat.LANGUAGE = 'US'
order by 1,3
    ;