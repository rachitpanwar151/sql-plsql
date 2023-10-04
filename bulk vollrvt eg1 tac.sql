DECLARE
    CURSOR cur_po_dtl IS
    SELECT
        *
    FROM
        po_headers_all;

    TYPE cur_po_dtl_type IS
        TABLE OF cur_po_dtl%rowtype INDEX BY PLS_INTEGER;
    po_tbl       cur_po_dtl_type;
    l_start_time VARCHAR2(100);
    l_end_time   VARCHAR2(100);
    l_diff_time  VARCHAR2(100);
BEGIN
    l_start_time := dbms_utility.get_time;
    OPEN cur_po_dtl;
    LOOP
        FETCH cur_po_dtl
        BULK COLLECT INTO po_tbl LIMIT 5000;
        FOR indx IN 1..po_tbl.count LOOP
            dbms_output.put_line('Rachit Panwar-' || indx);
        END LOOP;

        EXIT WHEN po_tbl.count = 0;
    END LOOP;

    CLOSE cur_po_dtl;
    l_end_time := dbms_utility.get_time;
    l_diff_time := ( l_end_time - l_start_time ) / 100;
    dbms_output.put_line('Iteration time using Bulk Collect : ' || l_diff_time);
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error : '
                             || sqlcode
                             || ' - '
                             || sqlerrm);
END;