create or replace procedure xxintg_locations_cursor(errbud out varchar2,
reetcode out varchar2)
as
cursor cur_loc(p_loc_id locations.location_id%type)
is 
select * from locations where location_id=p_loc_id;
begin
for rec_loc in cur_loc(1200) 
loop
fnd_file.put_LINE(FND_FILE.LOG,REC_LOC.LOCATION_ID||' '||REC_LOC.STREET_ADDRESS||' '||rec_loc.postal_code
||' '||rec_loc.city||' '||rec_loc.state_province||' '||rec_loc.country_id);
fnd_file.put_LINE(FND_FILE.output,REC_LOC.LOCATION_ID||' '||REC_LOC.STREET_ADDRESS||' '||rec_loc.postal_code
||' '||rec_loc.city||' '||rec_loc.state_province||' '||rec_loc.country_id);
end loop;
end xxintg_locations_cursor;