create or replace procedure xxintg_dept_dtls_rp( errbuf varchar2,
reetcode varchar2)
as
cursor cur_dept_dtls(dept_id departments.department_id%type)
is 
select * from departments where
        department_id = dept_id;
    begin
    for
    rec_cur_dept_dtls IN cur_dept_dtls
    ( 90 )
        loop
        fnd_file.put_line ( fnd_file.log, rec_cur_dept_dtls.department_id||' '|| rec_cur_dept_dtls.department_name||' '||rec_cur_dept_dtls.manager_id
        ||' '|| rec_cur_dept_dtls.location_id );
        fnd_file.put_line ( fnd_file.output, rec_cur_dept_dtls.department_id||' '||rec_cur_dept_dtls.department_name||' '||rec_cur_dept_dtls.manager_id
        ||' '||rec_cur_dept_dtls.location_id );
    end
        loop;
    end
        xxintg_dept_dtls_rp;