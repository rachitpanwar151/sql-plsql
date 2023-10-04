create or replace package body xxintg_regions_pkg_rp
as
procedure xxintg_region
as
cursor cur_regions(p_region_id regions.region_id%type)
is 
select * from regions where region_id=p_region_id;
begin
for rec_regions in cur_regions (2)
loop 
fnd_file.put_line(fnd_file.log, rec_regions.region_id||' '||rec_regions.region_name);
fnd_file.put_line(fnd_file.output, rec_regions.region_id||' '||rec_regions.region_name);
end loop;
end xxintg_region;
 procedure main_procedure(errbuff out varchar2, reetcode out
 varchar2)
 as
 begin
 xxintg_region;
 end main_procedure;
 end xxintg_regions_pkg_rp;