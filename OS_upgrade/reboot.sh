#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Reboot Server') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

rebootRequired="@option.rebootRequired@"

sudo -- bash -c "if [[ $rebootRequired == "Yes" ]]; then shutdown -r now; else echo '[INFO] NOT Rebooting Server'; fi"