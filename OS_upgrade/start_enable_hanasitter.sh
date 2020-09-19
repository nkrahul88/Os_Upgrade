#!/bin/bash

PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Starting Hanasitter after Server Reboot') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

echo -e "\n[INFO]\tStarting hanasitter after Server Reboot.\n"
sudo systemctl start hanasitter
sudo systemctl status hanasitter
