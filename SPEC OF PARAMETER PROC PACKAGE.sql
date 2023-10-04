CREATE OR REPLACE PACKAGE XXINTG_PARAMETER 
AS


/********************************************************************************

version     who               when                         why
1.0         rachit panwar     13-july-23                   to make a 
                                                         package specification
*********************************************************************************/

PROCEDURE MAIN_PARAMETER(P_VAL IN VARCHAR2);
END XXINTG_PARAMETER;