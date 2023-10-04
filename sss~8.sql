CREATE OR REPLACE PACKAGE BODY xxintg_show_data 

AS
   PROCEDURE COLUMNS (
        p_table_name VARCHAR2,
        p_value_type VARCHAR2
    ) AS

        CURSOR cur_COLS (
            p_col_value VARCHAR2
        ) IS
        SELECT
            column_name,data_type
        FROM
            user_tab_ COLUMNS
        WHERE
                1 = 1
            AND lower(p_table_name) = lower(p_col_value);

 

        rec_show_data_col cur_show_data_col%TYPE;
    BEGIN
        OPEN cur_show_data_col(('employees'));
        LOOP
            FETCH cur_show_data_col INTO rec_show_data_col;
            EXIT WHEN cur_show_data_col%notfound;
            dbms_output.put_line(rec_show_data_col.column
                                 || ' | '
                                 || rec_show_data_col.data_type);
        END LOOP;

 

        CLOSE cur_show_data_col;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlcode
                                 || ' | '
                                 || sqlerrm);
    END COLUMNS;

--------------------------------------------------------------------------------
    PROCEDURE show_data_cons (
        p_table_name VARCHAR2,
        p_value_type VARCHAR2
    ) AS

 

        CURSOR cur_show_data_cons (
            p_cons_value VARCHAR2
        ) IS
        SELECT
            table_name,constraint_name,column_name
        FROM
            user_cons_ COLUMNS
        WHERE
                1 = 1
            AND lower(p_table_name) = lower(p_cons_value);

 

        rec_show_data_cons cur_show_data_cons%TYPE;
    BEGIN
        OPEN cur_show_data_cons(lower('employees'));
        LOOP
            FETCH cur_show_data_cons INTO rec_show_data_cons;
            EXIT WHEN cur_show_data_cons%notfound;
            dbms_output.put_line(rec_show_data_cons.column
                                 || ' | '
                                 || rec_show_data_cons.data_type);
        END LOOP;

 

        CLOSE cur_show_data_cons;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlcode
                                 || ' | '
                                 || sqlerrm);
    END show_data_cons;
--------------------------------------------------------------------------------
    PROCEDURE show_data_ind (
        p_table_name VARCHAR2,
        p_value_type VARCHAR2
    ) AS

 

        CURSOR cur_show_data_ind (
            p_ind_value VARCHAR2
        ) IS
        SELECT
            table_name,column_name,index_name
        FROM
            user_indexes
        WHERE
                1 = 1
            AND lower(p_table_name) = lower(p_ind_value);

 

        rec_show_data_ind cur_show_data_ind%TYPE;
    BEGIN
        OPEN cur_show_data_ind(lower('employees'));
        LOOP
            FETCH cur_show_data_ind INTO rec_show_data_ind;
            EXIT WHEN cur_show_data_ind%notfound;
            dbms_output.put_line(rec_show_data_ind.column
                                 || ' | '
                                 || rec_show_data_ind.data_type);
        END LOOP;

 

        CLOSE cur_show_data_ind;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlcode
                                 || ' | '
                                 || sqlerrm);
    END show_data_ind;
--------------------------------------------------------------------------------
    PROCEDURE show_data_all (
        p_table_name VARCHAR2,
        p_value_type VARCHAR2
    ) AS
    BEGIN
        IF
            ( lower(p_table_name) = lower('emp') )
            AND ( lower(p_value_type) = lower('all') )
        THEN
            COLUMNS(p_table_name, p_value_type);
            show_data_cons(p_table_name, p_value_type);
            show_data_ind(p_table_name, p_value_type);
        END IF;
    END show_data_all;

 

--------------------------------------------------------------------------------
    PROCEDURE main (
        p_table_name VARCHAR2,
        p_value_type VARCHAR2
    ) AS
    BEGIN
        IF
            p_table_name = 'emp'
            AND p_value_type = 'col'
        THEN
            COLUMNS(p_table_name, p_value_type);
        ELSIF
            p_table_name = 'emp'
            AND p_value_type = 'cons'
        THEN
            show_data_cons(p_table_name, p_value_type);
        ELSIF
            p_table_name = 'emp'
            AND p_value_type = 'ind'
        THEN
            show_data_ind(p_table_name, p_value_type);
        ELSIF
            p_table_name = 'emp'
            AND p_value_type = 'all'
        THEN
            show_data_all(p_table_name, p_value_type);
        ELSE
            dbms_output.put_line('please provide a valid input');
        END IF;
    END main;

 

END xxintg_show_data;