####################################################################
## RHEL / FIRMWARE UPGRADE STEPS
###################################################################
#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('OS Upgrade Job - Setup YUM Repo with Salt') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

####################################################################
#1. Setup YUM Repo with salt
###################################################################
echo -e "\n**Setting up YUM Repo using SALT & moving all existing repo files under /root/old_repo_files**"
mkdir /root/old_repo_files
mv /etc/yum.repos.d/* /root/old_repo_files

salt-call state.sls yum

if [ -e "/etc/yum.repos.d/rhel-server-7.6-os-optional.mirrorlist" ] && [ -e "/etc/yum.repos.d/rhel-server-7.6-os-base.mirrorlist" ]; then
    echo -e "\n[INFO]\tYUM Repo using SALT setup Completed Successfully!!"
else
    echo -e "\n[ERROR]\tYUM Repo not found, please review !!!"
    exit 1
fi

####################################################################
#2. Clean up YUM Cache
###################################################################
echo -e "\n[INFO]\tCleaning up YUM Cache"
yum clean all
rm -rf /var/cache/yum/*
echo -e "\n[INFO]\tYum Cache Cleared !!"

