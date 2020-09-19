#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Getting hana mount points') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

#Getting the HANA and LSS mount

mount_count=`df -h | egrep 'hana|lss' |grep -v sd |wc -l`
echo -e "\n[INFO]\t No. of hana and LSS mounts in the server = $mount_count\n"
echo mount_count=$mount_count
df -h | egrep 'hana|lss' |grep -v sd