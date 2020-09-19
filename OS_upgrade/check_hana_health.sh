#!/bin/bash

PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
`export PATH`

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Checking Health of Hana after OS Upgrade') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

dbUser="@data.dbUser@"
sid="@data.sid_uppercase@"

echo -e "\n[INFO] Checking Hana Database Health after OS Upgrade.\n\t Executing command -->python landscapeHostConfiguration.py<-- and validating if Status is OK for all components.\n"
echo -e "\n\t This is a Recursive Check and Hana Database Health will be checked until it is found OK.\n"
while true
do
echo "********************************************************************************"
sudo -S su - $dbUser -c "cd /usr/sap/$sid/HDB00/exe/python_support; python landscapeHostConfiguration.py"
echo "********************************************************************************"
sudo -S su - $dbUser -c "cd /usr/sap/$sid/HDB00/exe/python_support; python landscapeHostConfiguration.py | grep -iq 'overall host status: ok'"
op1=$?
if [ $op1 -eq 0 ]
    then
        echo -e "\n[INFO]\tHana Health Check passed Successfully\n"
        break
    else 
        echo -e "\n[WARNING]\tHana Health Check is not as per requirement.\n\t Checking again after 20 seconds.\n"
        sleep 20
fi
done
