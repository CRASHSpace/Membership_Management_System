#!/bin/bash
#

echo "######################################################"
echo "# Update lastPayment and endDate for Monthly Members #"
echo "######################################################"

egrep '37.00|100.00|108.00' $membersToUpdatePayments | while read inputline
do
        fNamePaypal="$(echo $inputline | cut -d, -f2)"
        lNamePaypal="$(echo $inputline | cut -d, -f3)"
        updatedPayment="$(date -d "$(echo $inputline | cut -d, -f1)" +%Y-%m-%d)"
        updatedEndDate="$(date -d "$updatedPayment + 1 month" +%Y-%m-%d)"

        echo "$fNamePaypal $lNamePaypal $updatedPayment $updatedEndDate"

        echo "update paydates set lastPayment = '$updatedPayment' where lastNamePaypal = '$lNamePaypal' and firstNamePaypal = '$fNamePaypal' and lastPayment <> '$updatedPayment';" 

        echo "update paydates set endDate = '$updatedEndDate' where lastNamePaypal = '$lNamePaypal' and firstNamePaypal = '$fNamePaypal' and endDate <> '$updatedEndDate';" 
done






echo "Done."




