BEGIN
    xxintg_validate_and_insert.main_procedure(9, 'VALIDATE ONLY');
END;



BEGIN
    xxintg_validate_and_insert.main_procedure('16', 'VALIDATE only');
    END;


BEGIN
    xxintg_validate_and_insert.main_procedure(1001, 'VALIDATE and insert');-----DUPLICATE
END;

BEGIN
    xxintg_validate_and_insert.main_procedure(9, 'VALIDATE ');---CHECKING FOR CORRECTION DATA
END;

BEGIN
    xxintg_validate_and_insert.main_procedure(12, 'VALIDATE ONLY');
END;


BEGIN
    xxintg_validate_and_insert.main_procedure(1384, 'VALIDATE and insert');
END;

SELECT * FROM XXINTG_STAGING_RP WHERE REQUEST_ID=234 ;


select * from employees where employee_id=420;