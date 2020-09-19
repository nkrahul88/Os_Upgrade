#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Verify HANA & LSS mount points are present') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

sid_uppercase="@data.sid_uppercase@"
mount_count="@data.mount_count@"

#Verify if all the HANA & LSS Filesystems are mounted
hana_mnt=`df -h |egrep '$sid_uppercase|hana|lss' |grep -v sd |wc -l`
while true
do
    hana_mnt=`df -h |egrep '$sid_uppercase|hana|lss' |grep -v sd |wc -l`
    echo -e "\n[INFO]\tCurrent HANA & LSS Filesystems mount count: $hana_mnt"
    if [ "$hana_mnt" -ge "$mount_count" ]
    then
        echo -e "\n[INFO]\tAll HANA & LSS Filesystems are mounted\n"
        break
    else
        echo -e "\n[INFO]\tAll HANA & LSS Filesystems are NOT mounted. Checking again after 20 seconds.\n"
        sleep 20
    fi
done
