CREATE OR REPLACE PACKAGE xxintg_interface AS
    PROCEDURE mainn (
        p_interfaceid IN NUMBER
        );

END xxintg_interface;

SELECT record_id_SEQ.NEXTVAL FROM DUAL;