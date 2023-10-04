select 
fcr.request_id,
fcp.concurrent_program_name cp_short_name,
fcr.phase_code,
fcr.status_code
,fcr.ARGUMENT1
,fcr.ARGUMENT2
,fcr.ARGUMENT3
,fcr.ARGUMENT4
,fcr.ARGUMENT5
,fcr.ARGUMENT6
,fcr.ARGUMENT7
,fcr.ARGUMENT8
,fcr.ARGUMENT9
,fcr.ARGUMENT10
,fcr.ARGUMENT11
,fcr.ARGUMENT12
,fcr.ARGUMENT13
,fcr.ARGUMENT14
,fcr.ARGUMENT15
from 
fnd_concurrent_requests fcr,fnd_concurrent_programs fcp
where
fcr.concurrent_program_id=fcp.concurrent_program_id
and fcr.request_id='7712696'
;

select * from fnd_concurrent_requests where request_id='7712696';