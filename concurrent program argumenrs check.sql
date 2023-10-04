-----------Program to check the number of arguments in a CP--------

DECLARE
  --
  l_program_short_name      VARCHAR2 (200);
  l_application             VARCHAR2 (200);
  l_sequence                NUMBER;
  l_parameter               VARCHAR2 (200);
  l_description             VARCHAR2 (200);
  l_enabled                 VARCHAR2 (200);
  l_value_set               VARCHAR2 (200);
  l_default_type            VARCHAR2 (200);
  l_default_value           VARCHAR2 (200);
  l_required                VARCHAR2 (200);
  l_enable_security         VARCHAR2 (200);
  l_range                   VARCHAR2 (200);
  l_display                 VARCHAR2 (200);
  l_display_size            NUMBER;
  l_description_size        NUMBER;
  l_concatenated_descr_size NUMBER;
  l_prompt                  VARCHAR2 (200);
  l_token                   VARCHAR2 (200);
  l_cd_parameter            VARCHAR2 (200);
  l_check                   VARCHAR2 (2);
  --
BEGIN
  --
  l_program_short_name      := 'XXINTG_EMP_D_RP';
  l_application             := 'PO';
  l_sequence                := 10;
  l_enabled                 := 'Y';
  l_value_set               := '240 Characters';
  l_default_type            := NULL;
  l_default_value           := NULL;
  l_required                := 'N';
  l_enable_security         := 'N';
  l_range                   := NULL;
  l_display                 := 'Y';
  l_display_size            := 50;
  l_description_size        := 50;
  l_concatenated_descr_size := 50;
  l_token                   := NULL;
  l_cd_parameter            := NULL;
  --
  --Calling API to create a Parameter for a concurrent program definition
  --
    fnd_global.apps_initialize (user_id           => 1014843,
                               resp_id           => 201,
                               resp_appl_id      => 50578
                              );
    MO_GLOBAL.INIT ('PO');
    FND_REQUEST.SET_ORG_ID (204);
  for i in 1..101
  loop
   l_parameter := 'PARAM'||i;
   l_description := 'this is made by rachit '||i;
   l_prompt := 'Prompt'||i;
   apps.fnd_program.parameter
           (program_short_name                 => l_program_short_name,
            application                        => l_application,
            SEQUENCE                           => l_sequence,
            parameter                          => l_parameter,
            description                        => l_description,
            enabled                            => l_enabled,
            value_set                          => l_value_set,
            default_type                       => l_default_type,
            DEFAULT_VALUE                      => l_default_value,
            required                           => l_required,
            enable_security                    => l_enable_security,
            RANGE                              => l_range,
            display                            => l_display,
            display_size                       => l_display_size,
            description_size                   => l_description_size,
            concatenated_description_size      => l_concatenated_descr_size,
            prompt                             => l_prompt,
            token                              => l_token,
            cd_parameter                       => l_cd_parameter
           );  
  l_sequence := l_sequence+1;
  COMMIT;
  end loop;
EXCEPTION
WHEN OTHERS THEN
    dbms_output.put_line(SQLCODE||'-'||SQLERRM);
END;
