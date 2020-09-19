#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Post Upgrade Validation') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

#SID Details
sid_uppercase="@data.sid_uppercase@"
sid_crypt="@data.sid_crypt@"

#OS version
post_osver=`cat /etc/redhat-release`
echo -e "\n[INFO]\tOS Upgraded to $post_osver"
	
#crypt user
cyrptuser=`cat /etc/passwd|grep "$sid"crypt`|awk -F":" '{print $1}'
echo -e "\n[INFO]\t$cyrptuser user Added"

#LSS folder
lss_folder=`ls -lrtd /lss/shared/$sid_uppercase`
echo -e "\n[INFO]\tLSS folder Created\n\t$lss_folder"

#iLO Firmware
ilo_version=`dmidecode -t bios | grep "Firmware Revision"| awk '{print $3}'`
echo -e "\n[INFO]\tiLO firmware version = $ilo_version"

#System Firmware
bios_version=`dmidecode -t bios | grep "BIOS Revision" | awk '{print $3}'`
echo -e "\n[INFO]\tBIOS firmware version = $bios_version"

#NIC Driver version
nic=`cat /proc/net/bonding/bond0 | grep Interface | awk '{print $3}' | head -1`
nic_dirver=`ethtool -i $nic |grep driver |awk '{print $2}'`
mlnxnicdrv=`ethtool -i $nic | grep ^version | awk '{ print $2}'`
echo -e "\n[INFO]\tNIC Driver version = $nic_dirver"
echo -e "\n[INFO]\tNIC Firmware version = $mlnxnicdrv"

#libatomic & compat-sap/tuned profile  Pcakages
echo -e "\n[INFO]\tlibatomic, compat-sap, tuned profile Packages Installed"
rpm -qa |egrep 'compat-sap|libatomic|tuned' |sort -n


