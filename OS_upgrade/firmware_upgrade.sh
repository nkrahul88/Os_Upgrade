############################
#iLO Firmware Upgrade Steps
############################
#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Firmware upgrade - iLO/System/Mellanox NIC') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

ilo_version=`dmidecode -t bios | grep "Firmware Revision"| awk '{print $3}'`
bios_revision=`dmidecode -t bios | grep "BIOS Revision" | awk '{print $3}'`
hardware_model=`dmidecode -t system | grep "Product Name" |cut -d " " -f5`
bios_version=`dmidecode -t bios |grep -i version | cut -d ":" -f2`


if [ "$hardware_model" == "Gen9" ] 
    then
    echo -e "\nContinuing with Firmware Upgrade for $hardware_model"
#wget the rhelbundle from SALT to /var/tmp and untar it
    data_center=hostname | cut -d "." -f2
    wget http://salt.$data_center.ariba.com/rhel76bundle.tar.gz -P /var/tmp
    tar -zxvf /var/tmp/rhel76bundle.tar.gz -C /var/tmp
############################
# iLO Upgrade Steps
############################ 
        if [ "$ilo_version" == "2.73" ]
        then
            echo -e "\n[INFO]\tNothing to do, ILO Firmware is UP-TO-DATE"
        else
            rpm -ivh /var/tmp/rhel76bundle/firmware-ilo4-2.73-1.1.i386.rpm
            if [ "$?" == 0 ]
                then
                yes | sh /usr/lib/i386-linux-gnu/firmware-ilo4-2.73-1.1/setup
                echo -e "\n[ OK ]\tILO Firmware was UPDATED Successfully !!!"
            else
                echo -e "\n[ERROR]\tILO Firmware Package was NOT installed, Please Review"
                exit 1
            fi
        fi

############################
# BIOS Firmware Upgrade Steps
############################        
        echo -e "\nContinuing with BIOS Firmware"
        if [ "$bios_revision" == "2.76" ]; then
           echo -e "\n[INFO]\tNothing to do, BIOS Firmware is UP-TO-DATE"
        elif [ "$bios_version" == " U17" ]; then
           rpm -ivh /var/tmp/rhel76bundle/firmware-system-u17-2.76_2019_10_21-1.1.i386.rpm
           if [ "$?" == 0 ]
           then
                echo -e "y\nn" | sh /usr/lib/i386-linux-gnu/firmware-system-u17-2.76_2019_10_21-1.1/setup
                echo -e "\n[ OK ]\tBIOS Firmware was UPDATED Sucessfully !!!"
           else
             echo -e "\n[ERROR]\tBIOS Firmware Package was NOT installed, Please Review"
             exit 1
           fi
		elif [ "$bios_version" == " P89" ]; then
           rpm -ivh /var/tmp/rhel76bundle/firmware-system-p89-2.76_2019_10_21-1.1.i386.rpm
           if [ "$?" == 0 ]
           then
                echo -e "y\nn" | sh /usr/lib/i386-linux-gnu/firmware-system-p89-2.76_2019_10_21-1.1/setup
                echo -e "\n[INFO]\tBIOS Firmware was UPDATED Sucessfully !!!"
           else
             echo -e "\n[ERROR]\tBIOS Firmware Package was NOT installed, Please Review"
             exit 1			               
			fi
		fi	

#########################
# Verify if Mellanox NIC
#########################
nic=`cat /proc/net/bonding/bond0 | grep Interface | awk '{print $3}' | head -1`
nic_dirver=`ethtool -i $nic |grep driver |awk '{print $2}'`

if [ $nic_dirver == "mlx5_core" ]
    then
    ####################################################################
    #Install Mellanox NIC Firmware
    ###################################################################
    echo -e "\n[INFO]\tStarting MELLANOX FIRMWARE Upgrade"
    mlnxnicdrv=`ethtool -i eth0 | grep ^version | awk '{ print $2}'`
    if [ "$mlnxnicdrv" == "5.0-1.0.0.0" ]; then
        echo -e "\n[INFO]\tMellanox NIC Firmware Version is UP-TO-DATE"
    else
        echo -e "\n[INFO]\tStarting to INSTALL & FLASH MELLANOX NIC Firmware"
        rpm -ivh /var/tmp/rhel76bundle/firmware-nic-mellanox-ethernet-only-1.0.11-1.1.x86_64.rpm
        echo -e "y\ny" | sh /usr/lib/x86_64-linux-gnu/firmware-nic-mellanox-ethernet-only-1.0.11-1.1/setup
        if [ "$?" == 0 ]
        then
            echo -e "\n[ OK ]\tMellanox NIC Firmware INSTALLED & FLASHED Sucessfully !!!"
        else
            echo -e "\n[ERROR]\tMellanox NIC Firmware Install failed, Please Review"
            exit 1
        fi
    fi    
    else
    echo -e "\n[INFO]\tMellanox NIC Firmware & Driver Not found\n"
fi 

else
    echo -e "\n\n[INFO]\tThis is not a Proliant Gen 9 Series!!!"
fi

