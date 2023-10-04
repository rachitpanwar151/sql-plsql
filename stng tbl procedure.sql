PROCEDURE insert_stg (
       
        p_batch_id       IN xxintg_emp_stg.batch_id%TYPE
       
    ) AS
    BEGIN
        INSERT INTO xxintg_emp_stg VALUES (
            record_stg.nextval,
            1,
            'Alok',
            'Pundir',
            'ap12@gmail.com',
            1236567890,
            sysdate,
            'It_Prog',
            25300,
            0.5,
            2,
            10,
            'Programmer',
            'IT',
            p_batch_id,
            'N',
            ' '
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('data already exist');
    END insert_stg;