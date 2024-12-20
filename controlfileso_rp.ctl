OPTIONS ( SKIP=1, ERRORS=1000000, DIRECT=FALSE)
LOAD DATA
append
INTO TABLE APPS.XXINTG_SO_RP
FIELDS TERMINATED BY ","
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
CUSTOMER_NAME   "xxint_common_utils_pkg.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:CUSTOMER_NAME)),CHR(34),NULL))",
SALESPERSON_NUMBER     "xxint_common_utils_pkg.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:SALESPERSON_NUMBER)),CHR(34),NULL))",
SOLD_FROM_ORG  "xxint_common_utils_pkg.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:SOLD_FROM_ORG)),CHR(34),NULL))",
SHIP_FROM_ORG  "xxint_common_utils_pkg.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:SHIP_FROM_ORG)),CHR(34),NULL))",
SHIP_TO_ORG  "xxint_common_utils_pkg.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:SHIP_TO_ORG)),CHR(34),NULL))",
ORDER_TYPE	"xxint_common_utils_pkg.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ORDER_TYPE)),CHR(34),NULL))",
ITEM_NUMBER	"xxint_common_utils_pkg.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ITEM_NUMBER)),CHR(34),NULL))",
PRICE_LIST   "xxint_common_utils_pkg.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:PRICE_LIST)),CHR(34),NULL))",
CURRENCY  "xxint_common_utils_pkg.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:CURRENCY)),CHR(34),NULL))",
LINE_NUM   "xxint_common_utils_pkg.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:LINE_NUM)),CHR(34),NULL))",
QUANTITY          "xxint_common_utils_pkg.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:QUANTITY)),CHR(34),NULL))"
)