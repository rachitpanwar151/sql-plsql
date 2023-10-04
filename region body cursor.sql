/******************************
creating package spec
*******************************/
CREATE OR REPLACE PACKAGE xxintg AS

/*************************
creating main procedure
**************************/
    PROCEDURE mainn;

END xxintg;
/*************************
end 
**************************/


/**********************************
creating package body
***********************************/

CREATE OR REPLACE PACKAGE BODY xxintg AS

    PROCEDURE dtls AS

        CURSOR regions_dtls (
            p_region_id regions.region_id%TYPE
        ) IS
        SELECT
            *
        FROM
            regions
        WHERE
            region_id = p_region_id;

        rec_var regions_dtls%rowtype;
    BEGIN
        OPEN regions_dtls(4);
        dbms_output.put_line(rpad('region_id', 30)
                             || ' '
                             || rpad('region_name', 30));

        LOOP
            FETCH regions_dtls INTO rec_var;
            EXIT WHEN regions_dtls%notfound;
            dbms_output.put_line(rpad(rec_var.region_id, 20)
                                 || '  '
                                 || rpad(rec_var.region_name, 20));

        END LOOP;

        CLOSE regions_dtls;
    END;

    PROCEDURE mainn AS
    BEGIN
        dtls;
    END mainn;

END xxintg;


/*******************************
calling
*********************************/

BEGIN
    xxintg.mainn;
END;