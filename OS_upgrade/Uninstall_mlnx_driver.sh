############################
#iLO Firmware Upgrade Steps
############################
#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Uninstall OLD Mellanox NIC Driver') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

#########################
# Verify if Mellanox NIC
#########################
nic=`cat /proc/net/bonding/bond0 | grep Interface | awk '{print $3}' | head -1`
nic_dirver=`ethtool -i $nic |grep driver |awk '{print $2}'`

if [ $nic_dirver == "mlx5_core" ]
then
####################################################################
# Uninstall OLD Mellanox NIC Driver
################################################################### 
echo -e "Uninstalling OLD Mellanox NIC Driver"
nic_version=`ethtool -i $nic |grep ^version |awk '{print $2}'`
    if [ $nic_version == "4.3-1.0.1" ]
        then
            #for RHEL 7.2
            #echo -e "y" | sh /opt/mlnx-en-4.0-2.0.0.1-rhel7.2-x86_64/uninstall.sh
        tar -zxvf /opt/MLNX_OFED_SRC-4.3-1.0.1.0.tgz -C /opt    
        echo -e "y" | sh /opt/MLNX_OFED_SRC-4.3-1.0.1.0/uninstall.sh    
        if [ $? == 0 ]
        then
            echo -e "\n[ OK ]\tOLD Mellanox NIC Driver uninstalled!!!"
        else
            echo -e "\n[ERROR]\tUninstalling Mellanox Driver failed with Errors/Warning. Please Review " 
        exit 1
        fi
    else
        echo -e "\n[INFO]\tNIC Version is $nic_version, Uninstall Not required\n"
    fi    
else
    echo -e "\n[INFO]\tSkipping the Step, Mellanox NIC Firmware & Driver Not found\n"
fi 

####################################################################
# Grub config
################################################################### 
    grub2-mkconfig -o /boot/grub2/grub.cfg
    cp /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r).img.$(date +%m-%d-%H%M%S).bak
    dracut -f -v
