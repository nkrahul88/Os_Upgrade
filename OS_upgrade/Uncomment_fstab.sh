#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Uncomment fstab entries and mount NFS volumes') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----
sid_uppercase="@data.sid_uppercase@"

echo -e "\n[INFO]\tRemoving comment for NFS entries in /etc/fstab\n"
sed -i '/[ ]nfs/ s/#//' /etc/fstab

echo -e "\n[INFO]\tMounting all the Filesystems\n"
mount -a 
df -h |egrep '$sid_uppercase|hana|lss' |grep -v sd


