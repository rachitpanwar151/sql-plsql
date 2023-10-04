create or replace package body BEFORE_AND_AFTER_REPORT
as

    function before_report(p_segment IN varchar2)
    return boolean
    is
    A VARCHAR2(200);
    B VARCHAR2(200);
    C VARCHAR2(400);
        begin
        A:='before';
        B:='REPORT';
        C:=A||'-'||B;
        DBMS_OUTPUT.PUT_LINE(C);       
        return true;
    exception
        when others then
        return false;
  
    --lexcial variable 
--
--    p_dpt_condition := 'and department =''' CS ''';

    end before_report;



    function after_report(p_po_line_id IN number)
    return boolean
    is
  D VARCHAR2(200);
  E VARCHAR2(200);
  F VARCHAR2(400);
    begin
        --after report logic
D:='AFTER';
E:='REPORT';
F:=D||'-'||E;
DBMS_OUTPUT.PUT_LINE(F);
RETURN TRUE;
  exception
        when others then
        return false;
  
    end after_report;

 end BEFORE_AND_AFTER_REPORT;
