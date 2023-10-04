
SELECT
    fcpt.user_concurrent_program_name,
    fcp.concurrent_program_name,
    fa.application_short_name,
    fcpt.description,
    fe.executable_name,
    flv.meaning execution_method,
    fcp.output_file_type
FROM
    fnd_concurrent_programs_tl fcpt,
    fnd_concurrent_programs    fcp,
    fnd_application            fa,
    fnd_executables            fe,
    fnd_lookup_values          flv,
 fnd_concurrent_programs_vl fcpv,
    fnd_application  fa2
    WHERE
        fcpt.concurrent_program_id = fcp.concurrent_program_id
    AND fcpt.application_id = fcp.application_id
        AND fcp.application_id = fa.application_id
   AND fcpt.application_id = fa.application_id
    AND fe.executable_id = fcpv.executable_id
    AND flv.lookup_code = fe.execution_method_code
AND fe.application_id = fa2.application_id
AND flv.lookup_type = ‘CP_EXECUTION_METHOD_CODE’
    AND fcpt.user_concurrent_program_name = 'XXINTG_DEPARTMENT_RP';