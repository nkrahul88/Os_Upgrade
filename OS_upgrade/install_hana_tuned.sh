#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Install and verify HANA related tuned profile') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

#==============================================
# Install and verify HANA related tuned profile
#==============================================
echo -e "\n[INFO]\tInstall and verify HANA related tuned profile"
yum -y install tuned-2.11.0-8.el7 tuned-profiles-sap-hana
if [ $? == 0 ]
    then
    echo -e "\n[INFO]\tHANA related tuned profile RPMs Installed" 
    rpm -qa |grep tuned
	systemctl start tuned
	systemctl enable tuned
	tuned-adm profile sap-hana
	tuned-adm list |grep active
    else
    echo -e "\n[INFO]\tInstalling HANA related tuned profile RPMs FAILED!!!, Please Review"
    exit 1
fi