######################
#Enable Salt Highstate
######################
#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Enable Salt Highstate') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

echo -e "\n[INFO]\tEnabling Salt Highstate\n"
salt-call state.enable highstate
echo -e "\n[INFO]\tRunning Salt Highstate\n"
salt-call state.sls highstate
