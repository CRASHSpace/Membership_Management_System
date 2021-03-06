#!/bin/bash
#
# Read in file of all payments to our account from paypal
# Scrape out the payments that are for memberships and not for kits or other junk
#
# Let me know if any member has changed payment tiers
# Let me know if any members are new
#
# Figure out the most recent payment for each member in the system
# Update the database with the latest payment for each member
#
# at0mbxmb@gmail.com


# GLOBAL VARS
todaysDate="$(date -d "today" +%Y-%m-%d)"

# READ: raw file of all payments
paymentsFile="data/payments_paypal_2013-03-07.csv"

# WRITE: file of just memebership payments
membershipFile="data/payments_paypal_membership_2013-03-07.csv"
membershipUnchanged="data/payments_paypal_membership_unchanged_2013-03-07.csv"
currentMembers="data/current_members_$todaysDate.csv"
newMembers="data/new_members_$todaysDate.csv"
membersToUpdatePayments="data/members_to_update_in_db_$todaysDate.csv"

warning1Members="data/warning1_2013-03-07.csv"
warning2Members="data/warning2_2013-03-07.csv"
disabledMembers="data/disabled_2013-03-07.csv"


echo "##############################################################################"
echo "# From file of all paypal transactions, make file of all membership payments #"
echo "##############################################################################"

wc -l $paymentsFile
echo "Removing $membershipFile"
rm $membershipFile

if [ ! -s $membershipFile ];
then
	echo "Creating $membershipFile of all membership payments"
	sed 's/1,096/1096/g' $paymentsFile | egrep 'Completed|Updated' | cut -d, -f1,4,8 | tr '[:lower:]' '[:upper:]' | sed 's/"//g;s/ /,/g' | egrep '37.00|91.34|100.00|108.00|199.80|379.60|583.00|1096.00' | sort -t, -k2,2 -k3,3 -k1,1r > $membershipFile 
	echo "wrote membershipFile $membershipFile"
	wc -l $membershipFile
	head -30 $membershipFile
fi

echo
echo check to see if anyone has changed membership levels...
sort -t, -k2,3 -k1,1r $membershipFile | cut -d, -f2,3,4 | sort -u | cut -d, -f1,2 | awk -F, 'BEGIN {OFS = ","} {arr[$0]++} END {for (i in arr) {print i,arr[i]}}' | sort | grep -v ',1$' | head -30

echo
echo test on fake data: check to see if anyone has changed membership levels...
echo TODO: act on these members
sort -t, -k2,3 -k1,1r data/payments_paypal_membership_2013-03-07_FAKE.csv | cut -d, -f2,3,4 | sort -u | cut -d, -f1,2 | awk -F, 'BEGIN {OFS = ","} {arr[$0]++} END {for (i in arr) {print i,arr[i]}}' | sort | grep -v ',1$'

rm $membershipUnchanged
echo
echo remove anyone whose membership level changed from the file. they are to be delt with later.
echo the remaining file will be only the most recent payment of each member whose status has not changed.
grep -v `sort -t, -k2,3 -k1,1r data/payments_paypal_membership_2013-03-07_FAKE.csv | cut -d, -f2,3,4 | sort -u | cut -d, -f1,2 | awk -F, 'BEGIN {OFS = ","} {arr[$0]++} END {for (i in arr) {print i,arr[i]}}' | sort | grep -v ',1$' | cut -d, -f1,2` data/payments_paypal_membership_2013-03-07_FAKE.csv | awk '!x[$2$3]++' FS="," > $membershipUnchanged
wc -l $membershipUnchanged
head $membershipUnchanged 

echo
echo now that we have a file of members who have not changed payment level, we need to locate any NEW members
echo select existing members from DB 

rm $currentMembers
echo "select firstNamePaypal, lastNamePaypal from cs_members.paydates;" | `cat mysql_creds` --skip-column-names | sed 's/\t/,/g' | sort -t, -k1,1 -k2,2 > $currentMembers 
wc -l $currentMembers
head $currentMembers

echo
echo diff existing members against payment file to reveal new members
join -t, -v1 <(cut -d, -f2,3 $membershipUnchanged | sort -t, -k1,1 -k2,2 | sort -u) $currentMembers > $newMembers
wc -l $newMembers
head $newMembers

echo
echo TODO: if number of new members exceeds number than can be handled by egrep, alert!

echo
echo remove new members from file
egrep -v `cat $newMembers | tr '\n' '|' | sed '$s/.$//'` $membershipUnchanged > $membersToUpdatePayments

wc -l $membersToUpdatePayments
head $membersToUpdatePayments





echo "Done."




