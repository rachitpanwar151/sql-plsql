SELECT * FROM PER_PEOPLE_F 
   WHERE person_id=25 and TRUNC(SYSDATE) BETWEEN TRUNC(EFFECTIVE_START_DAte) AND TRUNC(effective_end_date)
   and (current_employee_flag='Y' or currenT_npw_flag='Y');
   