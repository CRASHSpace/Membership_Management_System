#!/bin/bash

todaysDate="$(date -d "today" +%Y-%m-%d)"

warning1Members="data/warning1_$todaysDate.csv"
warning2Members="data/warning2_$todaysDate.csv"
disabledMembers="data/disabled_$todaysDate.csv"

SUBJECT1="Crashspace_Misses_You"
SUBJECT2="Crashspace_REALLY_Misses_You"
SUBJECT3="Disable_These_Accounts"

# GLOBAL VARS
todaysDate="$(date -d "today" +%Y-%m-%d)"

# READ FILE
warning1Email="data/email_warning1.txt"
warning2Email="data/email_warning2.txt"

warning1Members="data/warning1_$todaysDate.csv"
warning2Members="data/warning2_$todaysDate.csv"
disabledMembers="data/disabled_$todaysDate.csv"

# WRITE File
membershipToday="data/membership_$todaysDate.csv"

# send out Warning 1
#cat $warning1Members | while read EMAIL
echo "at0mbxmb@gmail.com" | while read EMAIL
do
	cat $warning1Email | mail -s"Crashspace Misses You!" $EMAIL -- -f membership@crashspace.org  
done


# send out Warning 2
#cat $warning2Members | while read EMAIL
echo "at0mbxmb@gmail.com" | while read EMAIL
do
        cat $warning2Email | mail -s"Crashspace REALLY Misses You!" $EMAIL -- -f membership@crashspace.org
done

# send out members to disable to michelle
# once you have more than one day of data, use diff to only send the new ones
cat $disabledMembers | mail -s"Disable These Accounts" at0mbxmb@gmail.com

# make a log of the membership data on each run, just in case
echo "select * from cs_members.paydates;" | `cat mysql_creds` > $membershipToday 



echo "Update expired Warning 2 members to Disabled"
echo "update paydates set accountStatus = 'DISABLED' where endDate <= '$todaysDate' and accountStatus = 'WARNING2';" | mysql -u devg_crashspace -pgobblegobble -h mysql.devg.crashspacela.com cs_members

echo "Update expired Warning 1 members to Warning 2"
echo "update paydates set accountStatus = 'WARNING2' where endDate <= '$todaysDate' and accountStatus = 'WARNING1';" | mysql -u devg_crashspace -pgobblegobble -h mysql.devg.crashspacela.com cs_members

echo "Update newly expired ACTIVE members to Warning 1"
echo "update paydates set accountStatus = 'WARNING1' where endDate <= '$todaysDate' and accountStatus = 'ACTIVE';" | mysql -u devg_crashspace -pgobblegobble -h mysql.devg.crashspacela.com cs_members


# Collect all members to disable: accountStaus = 'DISABLED' and endDate <= '$todaysDate'
echo "select email from cs_members.paydates where accountStatus = 'DISABLED' and method = 'PAYPAL' and note <> 'IGNORE';"
echo "select email from cs_members.paydates where accountStatus = 'DISABLED' and method = 'PAYPAL' and note <> 'IGNORE';" | `cat mysql_creds` cs_members --skip-column-names > $disabledMembers

# Collect all members for Warning 2: accountStaus = 'WARNING2' and endDate <= '$todaysDate'
echo "select email from cs_members.paydates where accountStatus = 'WARNING2' and method = 'PAYPAL' and note <> 'IGNORE';"
echo "select email from cs_members.paydates where accountStatus = 'WARNING2' and method = 'PAYPAL' and note <> 'IGNORE';" | `cat mysql_creds` cs_members --skip-column-names > $warning2Members

# Collect all members for Warning 1: accountStaus = 'ACTIVE' and endDate <= '$todaysDate'
echo "select email from cs_members.paydates where accountStatus = 'WARNING1' and method = 'PAYPAL' and note <> 'IGNORE';"
echo "select email from cs_members.paydates where accountStatus = 'WARNING1' and method = 'PAYPAL' and note <> 'IGNORE';" | `cat mysql_creds` cs_members --skip-column-names > $warning1Members


echo "done"


