select substr(email,1,instr(email,'.')-1 ) first ,
substr(email,instr(email,'.')+1,instr(email,'@')-instr(email,'.')-1 ) last ,
substr(email,instr(email,'@')+1,instr(email,'.',1,2)-instr(email,'@')-1) gmail_type ,
substr(email,INSTR(email,'.',1,2)+1,length(email)-INSTR(email,'.',1,2)) domain 
from emp_test;

