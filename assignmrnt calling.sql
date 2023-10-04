   -------------------------------------CALLING------------------------------------------------------------------
    
DECLARE
L_STATUS VARCHAR2(5000);
L_ERROR VARCHAR2(7000);
BEGIN
xxintg_emp_update_insert_rp.main_PCKG('' ,
        'RA'     ,
        'PNR'      ,
        'R1@GMAIL.COM'         ,
        '0890557594' ,
        '07-JUN-02'     ,
         'PROGRAMMER'      ,
        10000        ,
        '0.1' ,
        100     ,
        ' MBA'  ,'Roma',
    L_status,
        L_error );
DBMS_OUTPUT.PUT_LINE(L_STATUS||'-'||L_ERROR);
END
;



SELECT * FROM EMPLOYEES ORDER BY 1;

SELECT * FROM DEPARTMENTS;