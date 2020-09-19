#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('FSTAB changes for the NFS mounts') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

echo -e "\n[INFO]\tfstab backed up"
cp /etc/fstab /tmp/fstab_`date +%d-%b-%Y-%H-%M`
ls -lrt /tmp/fstab_`date +%d-%b-%Y-%H-%M`

echo -e "\n[INFO]\tAdding entries for LSS mount"
cat /etc/fstab |grep "/hana/shared/$sid_uppercase" > /tmp/fstab.tmp
cat /tmp/fstab.tmp
if [ $? == 0 ]; then
    sed -i '/[ ]nfs/ s/\/shared \/hana/\/lss \/lss/' /tmp/fstab.tmp
    sed -i 's/_shared \/hana/_shared\/lss \/lss/g' /tmp/fstab.tmp
    cat /tmp/fstab.tmp >> /etc/fstab
    cat /etc/fstab |grep lss
    else
    cat /etc/fstab |grep "/hana/shared" > /tmp/fstab.tmp
    cat /tmp/fstab.tmp |grep "_shared "
    if [ $? == 0 ]; then
        sed -i 's/_shared \/hana/_shared\/lss \/lss/g' /tmp/fstab.tmp
        sed -i "s/\/lss\/shared/\/lss\/shared\/$sid_uppercase/g" /tmp/fstab.tmp
        cat /tmp/fstab.tmp >> /etc/fstab
        cat /etc/fstab |grep lss
    else
    exit 1
    fi
fi

echo -e "\n[INFO]\tChange ver4 to ver3 for NFS mounts"
sed -i '/[ ]nfs/ s/vers=4/vers=3/' /etc/fstab
cat /etc/fstab |grep nfs