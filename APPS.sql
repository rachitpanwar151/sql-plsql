select * from fnd_user where user_name='SYADAV';


select * from user_constraints;


SELECT FCR.REQUEST_ID
      ,FRV.RESPONSIBILITY_NAME
      ,FCPV.CONCURRENT_PROGRAM_NAME PROG_SHORT_NAME
      ,FCPV.USER_CONCURRENT_PROGRAM_NAME CON_PROG_NAME
      ,FU.USER_NAME REQUESTED_BY
FROM
       FND_CONCURRENT_REQUESTS FCR,
       FND_CONCURRENT_PROGRAMS_VL FCPV,
       FND_USER FU,
       FND_RESPONSIBILITY_VL FRV
WHERE 
       FCR.CONCURRENT_PROGRAM_ID=FCR.CONCURRENT_PROGRAM_ID
 AND   FU.USER_ID=FCR.REQUESTED_BY 
 AND   FRV.RESPONSIBILITY_ID=FCR.RESPONSIBILITY_ID
 AND   FCR.REQUEST_ID=7698941;
       
       
SELECT * FROM FND_EXECUTABLES_VL WHERE EXECUTABLE_NAME LIKE 'XXINTG%SY%';





SELECT * FROM FND_USER FU,
              PO_HEADERS_ALL PHA,
              HR_OPERATING_UNITS HOU,
              PO_LINES_ALL PLA,
              PO_LINE_LOCATIONS_ALL PLLA,
              PO_DISTRIBUTIONS_ALL PDA
WHERE FU.USER_ID=PHA.CREATED_BY
AND   HOU.ORGANIZATION_ID=PHA.ORG_ID
AND   PLA.PO_LINE_ID=PHA.PO_HEADER_ID
AND   PLLA.PO_LINE_ID=PLA.PO_LINE_ID
AND   PDA.LINE_LOCATION_ID=PLLA.LINE_LOCATION_ID;


