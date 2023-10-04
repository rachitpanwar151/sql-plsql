create directory rp1 as 'D:\';
--DROP DIRECTORY RP1;
grant read,write on directory rp1 to hr;



SELECT * FROM all_directories WHERE directory_name = 'RP1';
