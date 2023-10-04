SELECT * FROM fnd_application_VL;
SELECT * FROM fnd_executables;
SELECT * FROM fnd_concurrent_programs_Vl;



SELECT 
FAV.APPLICATION_NAME,
FE.EXECUTABLE_NAME,FE.EXECUTION_FILE_NAME,
FCPV.CONCURRENT_PROGRAM_NAME,
FCPV.USER_CONCURRENT_PROGRAM_NAME,
FCPV.OUTPUT_FILE_TYPE,
FCPV.DESCRIPTION,FLV.meaning execution_method
FROM
fnd_application_VL FAV,
fnd_executables FE,
fnd_concurrent_programs_Vl FCPV,
fnd_lookup_values    FLV 
WHERE
FAV.APPLICATION_ID=FCPV.APPLICATION_ID
AND FE.EXECUTABLE_ID=FCPV.EXECUTABLE_ID
AND FLV.lookup_code = FE.execution_method_code
AND FLV.lookup_type =UPPER('cp_execution_method_code')  
AND FCPV.USER_CONCURRENT_PROGRAM_NAME
='XXINTG_DEPARTMENT_RP';



select * from mtl_system_items_b;
SELECT * FROM MTL_SYSTEM_ITEMS_B WHERE SEGMENT1='RP_PHONE';