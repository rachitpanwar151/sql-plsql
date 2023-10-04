CREATE OR REPLACE PACKAGE xxintg_table AS
    PROCEDURE xxintg_mainn (
        p_table_name VARCHAR2,
        p_type       VARCHAR2
    );

END xxintg_table;