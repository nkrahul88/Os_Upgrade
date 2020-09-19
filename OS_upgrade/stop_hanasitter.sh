#!/bin/bash

PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
`export PATH`

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Stopping Hanasitter') ]]; then
  echo -e "\n[INFO]\tSkipping the Step as per input.\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

dbUser="@data.dbUser@"

echo -e "\n[INFO]\tStopping hanasitter.\n"
systemctl stop hanasitter
pkill -9 hanasitter
systemctl status hanasitter
