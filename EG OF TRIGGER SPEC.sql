create or replace package before_after_trigger
as
p_segment1  varchar2(200);
 function before_report return boolean;
--  function after_report return boolean;
END before_after_trigger;


select * from per_people_f;