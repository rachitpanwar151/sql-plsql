CREATE OR REPLACE PACKAGE BODY xxintg_table

/******************************************************************************************************
version              when                   who               why
1.0.1                16-july-23         RACHIT PANWAR   CURSOR FOR PRINTING TABLE DETAILS ACCORDING TO CONDITIONS
********************************************************************************************************/ 

AS

/*****************************************
PROCEDRUE FOR  PRINTING  columns OF TABLES
*******************************************/

   PROCEDURE table_columns (
        p_table_name VARCHAR2,
        p_type       VARCHAR2
    ) AS
        CURSOR cur_table_col (
            table_name VARCHAR2
        ) IS
        SELECT
            *
        FROM
            user_tab_cols
        WHERE
            upper(p_table_name) = upper(table_name);

        rec_columns cur_table_col%rowtype;
    BEGIN
        OPEN cur_table_col('p_table_name');
        dbms_output.put_line(rpad('TABLE COLUMN', 20, ' ')
                             || ' | '
                             || 'DATA_TYPE');

        LOOP
            FETCH cur_table_col INTO rec_columns;
            EXIT WHEN cur_table_col%notfound;
            dbms_output.put_line(rpad(rec_columns.column_name, 20, ' ')
                                 || ' | '
                                 || rec_columns.data_type);
        END LOOP;

        CLOSE cur_table_col;
        dbms_output.put_line('');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('error occured'
                                 || sqlcode
                                 || sqlerrm);
    END table_columns;

/******************************************
procedure for table constraints.
**********************************************/
PROCEDURE table_constraints (
        p_table_name VARCHAR2,
        p_type       VARCHAR2
    ) AS

        CURSOR cur_cons (
            p_con VARCHAR2
        ) IS
        SELECT
            *
        FROM
            user_constraints
        WHERE
            upper(table_name) = upper(p_con);
--select * from  user_cons_COLUMNS where table_name ='EMPLOYEES'
        rec_cons cur_cons%rowtype;
    BEGIN
        OPEN cur_cons(p_table_name);
        dbms_output.put_line(rpad('CONSTRAINT NAME', 25, ' '));
        LOOP
            FETCH cur_cons INTO rec_cons;
            EXIT WHEN cur_cons%notfound;
            dbms_output.put_line(rpad(rec_cons.constraint_name, 25, ' ')
                                 || '  ');
                                 END LOOP;

        
        CLOSE cur_cons;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlcode
                                 || ' | '
                                 || sqlerrm);
    END table_constraints;

/**********************************************
procedure for table index.
**************************************************/
PROCEDURE table_indexes (
        p_table_name VARCHAR2,
        p_type       VARCHAR2
    ) AS

        CURSOR cur_index (
            p_index VARCHAR2
        ) IS
        SELECT
            *
        FROM
            user_indexes
        WHERE
            upper(table_name) = upper(p_index);
--select * from user_indexes where upper(table_name)=upper('employees');
        rec_index cur_index%rowtype;
    BEGIN
        OPEN cur_index(p_table_name);
        dbms_output.put_line(rpad('INDEX_NAME', 25, ' ')
                             || ' | '
                             || 'INDEX_TYPE');
        LOOP
            FETCH cur_index INTO rec_index;
            EXIT WHEN cur_index%notfound;
            dbms_output.put_line(rpad(rec_index.index_name, 25, ' ')
                                 || ' | '
                                 || rec_index.index_type);

        END LOOP;

        CLOSE cur_index;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlcode
                                 || ' | '
                                 || sqlerrm);
    END table_indexes;

/***************************************************************
MAIN PROCEDURE FOR CALLING
*****************************************************************/

    PROCEDURE xxintg_mainn (
        p_table_name VARCHAR2,
        p_type       VARCHAR2
    ) AS
    BEGIN
        IF p_table_name IS NULL OR p_type IS NULL THEN
            dbms_output.put_line('null is not allowed');
       ELSIF
        p_type = 'columns'
        THEN
            table_columns(p_table_name, p_type);

        ELSIF
        p_type = 'constraints'
        THEN
            table_constraints(p_table_name, p_type);
        ELSIF
        p_type = 'index'
        THEN
            table_indexes(p_table_name, p_type);
        ELSIF
        p_type = 'all'
        THEN
            table_columns(p_table_name, p_type);
            table_constraints(p_table_name, p_type);
            table_indexes(p_table_name, p_type);
        END IF;
    END xxintg_mainn;

END xxintg_table;

 
-------------------calling-------------------------

BEGIN
    xxintg_table.xxintg_mainn('departments', 'all');
END;