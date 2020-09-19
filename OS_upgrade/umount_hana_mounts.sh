#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Unmount the HANA volumes and Comment NFS entries in fstab') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

echo -e "\n[INFO]\tUnmounting NFS Volumes"
nfsmount=$(mount | awk '/:/ { print $3 }')
echo $nfsmount | xargs umount -l

multipath=`df -h | grep mapper | grep hana |wc -l`
if [ $multipath == 2 ]; then
    multipath_mount=$(mount | awk '/mapper/ { print $3 }')
    echo $multipath_mount | xargs umount -l
fi
df -h

#=====================================
# Commenting NFS entries in /etc/fstab
#=====================================
echo -e "\n[INFO]\tCommenting NFS entries in /etc/fstab"
sed -i '/[ ]nfs/ s/^/#/' /etc/fstab

#=====================================
# Remvoing actimeo in NFS
#=====================================
echo -e "\n[INFO]\tRemvoing actimeo in NFS"
sed -i 's/,actimeo=0//g' /etc/fstab

cat /etc/fstab |grep nfs