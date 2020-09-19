#!/bin/bash

PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
`export PATH`

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Checking Successful Database Stop') ]]; then
  echo -e "\n[INFO]\tSkipping the Step as per input.\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

dbUser="@data.dbUser@"
sid_uppercase="@data.sid_uppercase@"

echo -e "\n[INFO] Checking Hana Database Health after Stopping Database.\n\t Executing command -->python landscapeHostConfiguration.py<-- and validating if Status is ERROR for all components.\n"

while true
do
echo "********************************************************************************"
sudo -S su - $dbUser -c "cd /usr/sap/$sid_uppercase/HDB00/exe/python_support; python landscapeHostConfiguration.py"
echo "********************************************************************************"
sudo -S su - $dbUser -c "cd /usr/sap/$sid_uppercase/HDB00/exe/python_support; python landscapeHostConfiguration.py | grep -iq 'overall host status: error'"
op1=$?
if [ $op1 -eq 0 ]
    then
        echo -e "\n[INFO]\tHana Database Stopped Successfully.\n"
        break
    else 
        echo -e "\n[WARNING]\tUnable to Stop Database. Checking again after 30 seconds.\n"
        sleep 30
fi
done
