
   DECLARE
   l_responsibility_id   NUMBER;
   l_application_id      NUMBER;
   l_user_id             NUMBER;
   l_request_id          NUMBER;
   lc_boolean2           BOOLEAN;
   
BEGIN
begin
SELECT DISTINCT fr.responsibility_id, frx.application_id
              INTO l_responsibility_id, l_application_id
              FROM apps.fnd_responsibility frx, apps.fnd_responsibility_tl fr
             WHERE fr.responsibility_id = frx.responsibility_id
               AND LOWER (fr.responsibility_name) LIKE
                                               LOWER ('XML Publisher Administrator');
end;
begin
   SELECT user_id
     INTO l_user_id
     FROM fnd_user
    WHERE user_name = 'RPANWAR';
end;

   --To set environment context.

   apps.fnd_global.apps_initialize (l_user_id,
                                    l_responsibility_id,
                                    l_application_id
                                   );

   --Submitting Concurrent Request

   l_request_id :=
      fnd_request.submit_request
         (application      => 'XXINTG',                --Application Short Name
          program          => 'XXINTG_XML_RP',             --Conc Program Short Name
          description      => ' program for submitting xml report by rachit panwar',       --Conc Program Description
          start_time       => SYSDATE,
          sub_request      => FALSE,
          argument1        => 6969
         );

   COMMIT;

   IF l_request_id = 0
   THEN
      DBMS_OUTPUT.put_line ('Concurrent request failed to submit');
   ELSE
      DBMS_OUTPUT.put_line ('Successfully Submitted the Concurrent Request');
   END IF;
--
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (   'Error While Submitting Concurrent Request '
                            || TO_CHAR (SQLCODE)
                            || '-'
                            || SQLERRM
                           );
end; 