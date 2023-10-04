CREATE OR REPLACE PACKAGE XX_INTG_CURSOR_IF_CONDICTION
AS

/********************************************************************************

version     who               when                         wjy
1.0         rachit panwar     13-july-23                   to make a 
                                                         package having procedure
                                                        of main_xurs and checking if confiction
*********************************************************************************/
 
PROCEDURE  MAIN_CURS( P_VAL IN VARCHAR2);
 END XX_INTG_CURSOR_IF_CONDICTION; 