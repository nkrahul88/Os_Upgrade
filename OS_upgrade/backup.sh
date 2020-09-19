#########################################################
# Backup the FS details, NIC configs/routes, PCS output
#########################################################
#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Backup the configuration files') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

#df output
mkdir /var/tmp/backup_for_os_upgrade
df -h >> /var/tmp/backup_for_os_upgrade/df_output_`date +%d-%b-%Y-%H-%M`
echo -e "\n[ DONE ]\tDF output backed UP"

#fstab
cat /etc/fstab >> /var/tmp/backup_for_os_upgrade/fstab_`date +%d-%b-%Y-%H-%M`
echo -e "\n[ DONE ]\tfstab file backed UP"

#NIC config files
cat /etc/sysconfig/network-scripts/ifcfg-* >> /var/tmp/backup_for_os_upgrade/nic_cfg_`date +%d-%b-%Y-%H-%M`
echo -e "\n[ DONE ]\tNIC config filew backed UP"

#ethtool output
for i in `ip a s |grep UP | awk -F ':' '{print $2}' |egrep 'eno|ens|eth|bond'|grep -v "@"`
    do
        ethtool $i  >> /var/tmp/backup_for_os_upgrade/nic_status_$i_`date +%d-%b-%Y-%H-%M`
    done
echo -e "\n[ DONE ]\tethtool output backed UP"

#Current route
route -n >> /var/tmp/backup_for_os_upgrade/route_`date +%d-%b-%Y-%H-%M`
echo -e "\n[ DONE ]\troute file backed UP"

#pcs status output
#pcs status --full >> /var/tmp/backup_for_os_upgrade/pcs_status_`date +%d-%b-%Y-%H-%M`

#Grub config backup
cat /boot/grub2/grub.cfg >> /var/tmp/backup_for_os_upgrade/grub.cfg_`date +%d-%b-%Y-%H-%M`
echo -e "\n[ DONE ]\tgrub config backup"

