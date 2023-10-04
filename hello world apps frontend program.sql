create or replace procedure xxintg_hello_world_rp(errbuff out varchar2,retcode out varchar2)
as
begin 
fnd_file.put_line(fnd_file.log,'hello world');
fnd_file.put_line(fnd_file.output,'hellow world');
end xxintg_hello_world_rp;