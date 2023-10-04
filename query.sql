select * from FND_CONCURRENT_PROGRAMS_VL ;
select * from FND_CONCURRENT_PROGRAMS;
select * from FND_CONCURRENT_PROGRAMS_TL;


select fcpvl.user_concurrent_program_name,fcp.concurrent_program_name,
fcp.executable_id,fcp.application_id,fcpvl.description,
fcpvl.executable_id,fcpvl.execution_method_code,
fcp.output_file_type,fdfcu.column_seq_num,fdfcu.end_user_column_name,
fdfcuv.description,fdfcuv.enabled_flag,fdfcuv.flex_value_set_id
,fdfcuv.display_size,fdfcu.concatenation_description_len,fdfcu.form_left_prompt,
fdfcut.form_above_prompt
from  FND_CONCURRENT_PROGRAMS fcp,FND_CONCURRENT_PROGRAMS_VL fcpvl ,
FND_DESCR_FLEX_COL_USAGE_VL  fdfcuv,
        fnd_descr_flex_column_usages  fdfcu
        ,fnd_descr_flex_col_usage_tl fdfcut
        where
 fdfcuv.descriptive_flexfield_name = fdfcu.descriptive_flexfield_name 
 and fcp.execution_method_code=fcpvl.execution_method_code and
fcp.output_file_type=fcpvl.output_file_type and
fdfcuv.application_id=fdfcu.application_id and
fcp.concurrent_program_id=fcpvl.concurrent_program_id
and fcp.application_id=fcpvl.application_id
and fcp.executable_id=fcpvl.executable_id
and fdfcu.enabled_flag=fdfcuv.enabled_flag;

SELECT * FROM LOCATIONS;

select * from fnd_concurrent_programs;
select * from FND_DESCR_FLEX_COL_USAGE_VL ;

        select * from fnd_concurrent_programs_vl; 
select * from mtl_system_items_b where segment1 = 'ducati_clutch';

select * from FND_DESCR_FLEX_COL_USAGE_VL ;
select * from fnd_descr_flex_column_usages;
select * from fnd_descr_flex_col_usage_tl;