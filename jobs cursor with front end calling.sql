create or replace procedure xxintg_job_id_rp( errbuf varchar2,
reetcode varchar2)
as
cursor cur_jobs(p_job_id jobs.job_id%type)
is 
select *from jobs where job_id=p_job_id;
begin
for rec_jobs in cur_jobs('AD_PRES')
loop
fnd_file.put_line(fnd_file.log, rec_jobs.job_id||' '||rec_jobs.job_title||' '|| rec_jobs.min_salary||' ' || rec_jobs.max_salary);
fnd_file.put_line(fnd_file.output, rec_jobs.job_id||' '||rec_jobs.job_title||' '|| rec_jobs.min_salary||' ' || rec_jobs.max_salary);
end loop;
end xxintg_job_id_rp;

