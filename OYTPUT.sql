
BEGIN
    xxintg_employee_EMAIL_CREATION.mainnn('', 'RoOO', 'SaHAA', '8209297699',
                                              '01-Jun-23', 'IT_PROG', 13000, 0.1, 104,
                                              60);
END;

SELECT * FROM EMPLOYEES order by employee_id desc;

ALTER TABLE EMPLOYEES 
MODIFY EMAIL VARCHAR2(40);
DESC EMPLOYEES;

