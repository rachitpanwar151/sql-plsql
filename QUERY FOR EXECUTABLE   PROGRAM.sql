SELECT * FROM FND_EXECUTABLES_FORM_V ;




------------------------------------------------------------------
SELECT  FEV.user_executable_name,FEV.executable_name,FAV.application_name,FEV.executable_name
,FEV.description,FEV.execution_method_code,FEV.user_executable_name
FROM
        fnd_executables_vl FEV,
        fnd_application_vl FAV
        WHERE
        FEV.application_id = FAV.application_id
        AND FEV.user_executable_name='XXINTG_DEPARTMENT_RP';
        
        
        SELECT * FROM fnd_executables_vl;
        SELECT * FROM fnd_application_vl;