CREATE OR REPLACE PACKAGE BODY xxintg_table
AS

    PROCEDURE xx_cols (
        p_table_name VARCHAR2,
        p_type       VARCHAR2
    ) AS

        CURSOR cur_tablee (
            L_table_name VARCHAR2
        ) IS
        SELECT
            *
        FROM
            user_tab_cols
        WHERE
            upper(P_table_name) = upper(table_name);

        rec_columns cur_tablee%rowtype;
    BEGIN
        OPEN cur_tablee(p_table_name);
        LOOP
            FETCH cur_tablee INTO rec_columns;
            EXIT WHEN cur_tablee%notfound;
            DBMS_OUTPUT.PUT_LINE(RPAD('COLUMN_NAME',30)||' '||RPAD('DATA_TYPE',30)||
            ' '||RPAD(' SIZE',30));
            dbms_output.put_line(RPAD(rec_columns.column_name,30)
                                 || ' '
                                 ||RPAD( rec_columns.data_type,30)|| ' 
                                 '||RPAD(rec_columns.sample_size,30));
                                 
                                 --select * from user_tab_cols;
        END LOOP;

        CLOSE cur_tablee;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('error occured'
                                 || sqlcode
                                 ||' '|| sqlerrm);
    END xx_cols;

    PROCEDURE xxintg_constraints (
        p_table_name VARCHAR2,
        p_type       VARCHAR2
    ) AS

        CURSOR cur_cons (
            p_con VARCHAR2
        ) 
        IS
        SELECT
            *
        FROM
          user_constraints
        WHERE
            trim(upper(table_name)) = trim(upper(p_con));
--select * from user_constraints;
        rec_cons cur_cons%rowtype;
    BEGIN
        OPEN cur_cons(p_table_name);
        LOOP
            FETCH cur_cons INTO rec_cons;
            EXIT WHEN cur_cons%notfound;
            DBMS_OUTPUT.PUT_LINE(RPAD('TABLE_NAME',30)||' '||RPAD('CONSTRAINTS',30)||
            ' '||RPAD('CONSTRAINT TYPE',30));
            dbms_output.put_line(RPAD(rec_cons.table_name,30)
                                 || '  '
                                 ||RPAD( rec_cons.constraint_name,30)
                                 || '  '||RPAD( rec_cons.constraint_TYPE,30));
                      
--                                 --select * from user_constraints;
        END LOOP;

        CLOSE cur_cons;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlcode
                                 || ' | '
                                 || sqlerrm);
    END xxintg_constraints;

    PROCEDURE xxintg_indexes (
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
            trim(upper(table_name))= trim(upper(p_index));
--select * from user_indexes;
        rec_index cur_index%rowtype;
    BEGIN
        OPEN cur_index(p_table_name);
        LOOP
            FETCH cur_index INTO rec_index;
            EXIT WHEN cur_index%notfound;
DBMS_OUTPUT.PUT_LINE(RPAD('TABLE_NAME',30)||' '||RPAD('INDEX NAME',30)||
' '||RPAD('INDEX TYPE',30));
            dbms_output.put_line(RPAD(rec_index.table_name,30)
                                 || '  '
                                 ||RPAD( rec_index.index_name,30)
                                 || '  '
                                 || rec_index.index_type);

        END LOOP;
--        
--        select * from user_indexes;
        CLOSE cur_index;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlcode
                                 || ' | '
                                 || sqlerrm);
    END xxintg_indexes;

    PROCEDURE xxintg_mainn (
        p_table_name VARCHAR2,
        p_type       VARCHAR2
    ) AS
    BEGIN
        IF
            p_table_name = 'employees'
            AND p_type = 'columns'
        THEN
            xx_cols(p_table_name, p_type);
        ELSIF
            p_table_name = 'employees'
            AND p_type = 'constraints'
        THEN
            xxintg_constraints(p_table_name, p_type);
        ELSIF
            p_table_name = 'employees'
            AND p_type = 'index'
        THEN
            xxintg_indexes(p_table_name, p_type);
        ELSIF
            p_table_name = 'employees'
            AND p_type = 'all'
        THEN
            xx_cols(p_table_name, p_type);
            xxintg_constraints(p_table_name, p_type);
            xxintg_indexes(p_table_name, p_type);
            elsIF
            p_table_name = 'locations'
            AND p_type = 'columns'
        THEN
            xx_cols(p_table_name, p_type);
        ELSIF
            p_table_name = 'locations'
            AND p_type = 'constraints'
        THEN
            xxintg_constraints(p_table_name, p_type);
        ELSIF
            p_table_name = 'locations'
            AND p_type = 'index'
        THEN
            xxintg_indexes(p_table_name, p_type);
        ELSIF
            p_table_name = 'locations'
            AND p_type = 'all'
        THEN
            xx_cols(p_table_name, p_type);
            xxintg_constraints(p_table_name, p_type);
            xxintg_indexes(p_table_name, p_type);
       
       elsIF
            p_table_name = 'departments'
            AND p_type = 'columns'
        THEN
            xx_cols(p_table_name, p_type);
        ELSIF
            p_table_name = 'departments'
            AND p_type = 'constraints'
        THEN
            xxintg_constraints(p_table_name, p_type);
        ELSIF
            p_table_name = 'departments'
            AND p_type = 'index'
        THEN
            xxintg_indexes(p_table_name, p_type);
        ELSIF
            p_table_name = 'departments'
            AND p_type = 'all'
        THEN
            xx_cols(p_table_name, p_type);
            xxintg_constraints(p_table_name, p_type);
            xxintg_indexes(p_table_name, p_type);
       elsIF
            p_table_name = 'jobs'
            AND p_type = 'columns'
        THEN
            xx_cols(p_table_name, p_type);
        ELSIF
            p_table_name = 'jobs'
            AND p_type = 'constraints'
        THEN
            xxintg_constraints(p_table_name, p_type);
        ELSIF
            p_table_name = 'jobs'
            AND p_type = 'index'
        THEN
            xxintg_indexes(p_table_name, p_type);
        ELSIF
            p_table_name = 'jobs'
            AND p_type = 'all'
        THEN
            xx_cols(p_table_name, p_type);
            xxintg_constraints(p_table_name, p_type);
            xxintg_indexes(p_table_name, p_type);
        elsIF
            p_table_name = 'regions'
            AND p_type = 'columns'
        THEN
            xx_cols(p_table_name, p_type);
        ELSIF
            p_table_name = 'regions'
            AND p_type = 'constraints'
        THEN
            xxintg_constraints(p_table_name, p_type);
        ELSIF
            p_table_name = 'regions'
            AND p_type = 'index'
        THEN
            xxintg_indexes(p_table_name, p_type);
        ELSIF
            p_table_name = 'regions'
            AND p_type = 'all'
        THEN
            xx_cols(p_table_name, p_type);
            xxintg_constraints(p_table_name, p_type);
            xxintg_indexes(p_table_name, p_type);
       elsIF
            p_table_name = 'countries'
            AND p_type = 'columns'
        THEN
            xx_cols(p_table_name, p_type);
        ELSIF
            p_table_name = 'countries'
            AND p_type = 'constraints'
        THEN
            xxintg_constraints(p_table_name, p_type);
        ELSIF
            p_table_name = 'countries'
            AND p_type = 'index'
        THEN
            xxintg_indexes(p_table_name, p_type);
        ELSIF
            p_table_name = 'countries'
            AND p_type = 'all'
        THEN
            xx_cols(p_table_name, p_type);
            xxintg_constraints(p_table_name, p_type);
            xxintg_indexes(p_table_name, p_type);
       
        END IF;
    END xxintg_mainn;

END xxintg_table; 

-------------------calling-------------------------

BEGIN
    xxintg_table.xxintg_mainn('jobs', 'ALL');
END
;