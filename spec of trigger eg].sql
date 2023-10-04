create or replace package before_after_trigger
as
p_segment1 varchar2(200);
 function before_report(p_segment1 in varchar2) return boolean;
 function after_report(p_segment1 in varchar2) return boolean;
 end;