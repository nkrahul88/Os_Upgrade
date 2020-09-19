#########################
# Verify if Mellanox NIC
#########################
#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Mellanox Driver Installation') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

nic=`cat /proc/net/bonding/bond0 | grep Interface | awk '{print $3}' | head -1`
nic_dirver=`ethtool -i $nic |grep driver |awk '{print $2}'`

if [ $nic_dirver == "mlx5_core" ]
    then
    ############################################ 
    #Install dependancy packages for mellanox 5.0-1 driver
    ############################################
    echo -e "\nInstall dependancy packages for mellanox 5.0-1 driver"
    yum -y install tcl tk  
    if [ $? == 0 ]
        then
        echo -e "\n[ OK ]\tDependancy packages installed for mellanox 5.0-1 driver"
        else
        echo -e "\n[ERROR]\tDependancy packages installation FAILED!!!!!"
        exit 1
    fi
######################
#Install mellanox 5.0-1 driver
######################
    echo -e "\n[INFO]\tInstalling mellanox 5.0.1 driver\n" 
    tar -zxvf /var/tmp/rhel76bundle/MLNX_OFED_LINUX-5.0-1.0.0.0-rhel7.6-x86_64.tgz -C /var/tmp/rhel76bundle
    echo -e "y" | sh /var/tmp/rhel76bundle/MLNX_OFED_LINUX-5.0-1.0.0.0-rhel7.6-x86_64/mlnxofedinstall
    if [ $? == 0 ]
        then    
        /etc/init.d/openibd restart
        echo -e "\n[ OK ]\tMellanox 5.0-1 Driver Installed !!!\n"
        ethtool -i $nic
        else
        echo -e "\n[ERROR]\tMellanox 5.0-1 Driver installation FAILED!!!!!\n"
        exit 1
    fi
    else
    echo -e "\n[INFO]\tNot Applicable, Server does not have Mellanox Driver!!!\n"
fi 