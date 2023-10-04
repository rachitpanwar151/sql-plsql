BEGIN
    fnd_set.add_set_to_group(request_set => 'XXINTG_TEST_RP', 
    set_application => 'PO', --REQUEST SET APPLICATION SHORT NAME
     request_group => 'All Reports',---REQUEST GROUP NAME
     group_application => 'PO'--REQUEST GROUP APPLICATION SHORT NAME
    );

    dbms_output.put_line('"XXINTG_TEST_RP" attached to request group Succesfully ');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error in attaching "XXX_TEST_REQUEST_SET" to Request Group ' || sqlerrm);
END;