#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Chassis Firmware Upgrade') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----


#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

hardware_model=`dmidecode -t system | grep "Product Name" |cut -d " " -f5`

if [ "$hardware_model" == "Gen9" ] 
    then
    echo -e "\nContinuing with Chassis Firmware Upgrade for $hardware_model"
    cd /tmp
    echo "Downloading Chassis Firmware"
    dc=`hostname | cut -d "." -f2`
    /usr/bin/wget  http://salt.$dc.ariba.com/yumrepos/hardware/hpe_firmware/apollo6000/2019/latest/hp-firmware-cdale13gen9-1.6.3-1.1.i386.rpm

    #Chassis Firmware
    rpm -ivh /tmp/hp-firmware-cdale13gen9-1.6.3-1.1.i386.rpm
    echo -e "y" |/usr/lib/i386-linux-gnu/hp-firmware-cdale13gen9-1.6.3-1.1/hpsetup
    if [ "$?" == 0 ]
        then
            echo -e "\n[INFO] Chassis Firmware installed"
            break
    else 
            echo -e "\n[ERROR]\t Chassis Firmware Upgrade Failed.Please Investigate\n"
		
    fi
    
else
    echo -e "\n\n[ERROR]\tThis is NOT a Proliant Gen 9 Series!!!"
    exit 1
fi
