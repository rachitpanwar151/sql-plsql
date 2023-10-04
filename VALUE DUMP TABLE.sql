CREATE TABLE alltablecolums (
    employee_id     NUMBER,
    employee_name   VARCHAR2(100),-- FIRST_NAME||LAST_NAME 
    hiredate        DATE,
    job_id          VARCHAR2(100),
    job_TITLE        VARCHAR2(200),
    salary          NUMBER,
    commission_pct  NUMBER,
    EMP_manager_id      NUMBER,
    EMP_manager_name    VARCHAR2(200),
    department_id   NUMBER,
    department_name VARCHAR2(300),
    location_id     VARCHAR2(100),
    location_name   VARCHAR2(300),
    country_id      VARCHAR2(200),
    country_name    VARCHAR2(300),
    region_id       NUMBER,
    region_name     VARCHAR2(200)
     );
     
     SELECT * FROM ALLTABLECOLUMS order by 1;
     
select * from employees;
DROP TABLE ALLTABLECOLUMS;