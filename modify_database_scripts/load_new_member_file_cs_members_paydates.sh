#!/bin/bash

###
# WARNING: This script will truncate the table! Do not use this to update membership data.
# load initial file of members into cs_members.paydates
###

if [ $# -eq 0 ]; then echo "ERROR: please supply .csv receipt file on command line" >&2 ; exit 1; fi

fileToLoad=$(readlink -e "$1")
if [ "${fileToLoad}"X = ""X ]; then echo "ERROR: $1 not found" >&2 ; exit 1; fi
if [ ! -s  "${fileToLoad}" ]; then echo "ERROR: ${fileToLoad} not found or empty" >&2 ; exit 1; fi

sql="truncate cs_members.paydates"
echo "$sql"
echo

echo "$sql" | `cat mysql_creds`


echo "Load data from file into cs_members.paydates"
sql="LOAD DATA LOCAL INFILE '${fileToLoad}'
 INTO TABLE cs_members.paydates
 FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES
 (
 firstName,
 lastName,
 paypalName,
 emailPaypal,
 memberType,
 paymentDuration,
 hasKey,
 isGrandfathered,
 firstPayment,
 lastPayment,
 paymentDue, 
 paymentMethod,
 accountStatus,
 accountActivityDate
);
SELECT 'NUMBER OF WARNINGS: ',@@warning_count;
SHOW WARNINGS LIMIT 10;
"
echo "$sql" | `cat mysql_creds`

echo "Done."
