create or replace package emp_dept_valid_and_load_rp1
as

/**************************************************************************************************
VERSION            WHEN            WHO                       WHY
 
1.0           3-AUGUST-2023    RACHIT PANWAR           TO MAKE A PACKAGE SPEC TO UPDATE AND
                                                      AND INSERT DETAILS IN STAGING AND BASE TABLE
                                                      AND MAKING DEPT FIRSTS AND THAN EMP
**************************************************************************************************/

procedure main_procedure(        p_errbuff        OUT VARCHAR2,
        p_retcode        OUT VARCHAR2,
        p_dept_file_name IN VARCHAR2,
        p_emp_file_name  IN VARCHAR2,
        p_process_type IN VARCHAR2);
end emp_dept_valid_and_load_rp1;