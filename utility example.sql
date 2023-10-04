  create or replace  package body xxintg_utility_pkg_rp
  as
  function get_org_id(p_operating_unit in number)return varchar2
  as ln_org_id number;
  begin
  select organization_id into ln_org_id from hr_operating_units where upper(operating_unit)=upper(p_operating_unit);
  exception
  when others then
  fnd_file.put_line(fnd_file.log,'Error in fetching ORG ID : '||sqlcode||'-'||);
  end;
   function get_vendor_id(p_vendor_name in varchar2)return number;
    function get_vendor_site_id(p_vendor_site_code in varchar2,p_org_id in number)return number;
  end xxintg_utility_pkg_rp;