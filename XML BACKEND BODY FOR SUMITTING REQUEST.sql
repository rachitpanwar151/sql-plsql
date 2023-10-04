CREATE OR REPLACE PACKAGE BODY XXINTG_XML_BACKEND
AS
-- This program is used to submit an concurrent program (XML Publisher) from back end.--
   l_responsibility_id   NUMBER;
   l_application_id      NUMBER;
   l_user_id             NUMBER;
   l_request_id          NUMBER;
   lc_boolean2           BOOLEAN;
   PROCEDURE CALLINT_XML_FROM_BACKEND
   AS
   
BEGIN
   --
   SELECT DISTINCT fr.responsibility_id, frx.application_id
              INTO l_responsibility_id, l_application_id
              FROM apps.fnd_responsibility frx, apps.fnd_responsibility_tl fr
             WHERE fr.responsibility_id = frx.responsibility_id
               AND LOWER (fr.responsibility_name) LIKE
                                               LOWER ('XML Publisher Administrator');

   --
   SELECT user_id
     INTO l_user_id
     FROM fnd_user
    WHERE user_name = 'RPANWAR';

   --To set environment context.
   --
   apps.fnd_global.apps_initialize (l_user_id,
                                    l_responsibility_id,
                                    l_application_id
                                   );
   --
   --Submitting Concurrent Request
   --
   lc_boolean2 :=
      fnd_request.add_layout
         (template_appl_name      => 'SQLAP',         --Application Short Name
          template_code           => 'XXINTG_GROUP_TABLE_RP',      -- XML Data Template Code
          template_language       => 'en',
                                       --Use language from template definition
          template_territory      => 'US',
                                      --Use territory from template definition
          output_format           => 'EXCEL'
                                  --Use output format from template definition
         );
   l_request_id :=
      fnd_request.submit_request
         (application      => 'SQLAP',                --Application Short Name
          program          => 'XXINTG_GROUP_TABLE_RP',             --Conc Program Short Name
          description      => 'Test program',       --Conc Program Description
          start_time       => SYSDATE,
          sub_request      => FALSE,
          argument1        => 'Val1',
                         --Give parameter Original values not value set values
          argument2        => 'Val2',
          argument3        => 'Val3'
         );
   --
   COMMIT;

   --
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

END;