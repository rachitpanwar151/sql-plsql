create or replace package BEFORE_AND_AFTER_REPORT
as
 function before_report(p_segment IN varchar2)
    return boolean;

    function after_report(p_po_line_id IN number)
    return boolean;

 end BEFORE_AND_AFTER_REPORT;

create TABLE staG_before_report
(
HEADER_ID VARCHAR2(200)
,po_num  VARCHAR2(200)
);