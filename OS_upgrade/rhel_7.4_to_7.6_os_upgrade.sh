#!/bin/bash
#Note 1: This shell script is ONLY applicable for RHEL 7.4 to 7.6 Upgrade on ProLiant DL580 Gen9 leveraging SALT
#Note 2: Pre-requisites : make sure Firmware & Mellanox driver rpms are placed under /root/rhel76bundle/
#!/bin/bash
#########################################################
# Script to Upgrade RHEL 7.4 to 7.6 using Salt
#########################################################
#
###echo -e " Current Redhat Version is:"
cat /etc/redhat-release
echo -e "\n"
#
#
###################################################################
# Confirm from User if Console Access of the Host is Accessible
####################################################################
#
echo "Do you Confirm Console Access to the Host is Accessible ( yes / no ) : " ; read consoleaccess
if [ $consoleaccess == yes  ] ; then
        echo -e "\tThank you for confirming the Console Access, Continuing..."
elif [ $consoleaccess == no  ] ; then
        echo -e "\tPlease make sure Console is Accessible before running this Script"
        exit 0
else
        echo -e "\tPlease enter a valid input"
        exit 0
fi
echo -e "\n"

###################################################################
#Verify if the host is applicable for Rhel 7.4 to 7.6 Minor Upgrade
####################################################################
#
ostype=`cat /etc/redhat-release | cut -d " " -f1-2`
osver=`cat /etc/redhat-release | cut -d " " -f7`

if [ "$ostype" == "Red Hat" ] && [ "$osver" == "7.4" ]
then
        echo -e "This is Redhat 7.4 OS Proceeding with the script !"
else
        echo -e "!!!!This Host/OS is NOT applicable for Upgrade. Kindly Review!!!"
#       exit 0
fi
echo -e "\n"
#


###################################################################
#Pre-Upgrade / Pre-checks for Upgrade
####################################################################
#1. Disable Salt Highstate
###################################################################
#
#echo -e"Disabling Salt Highstate"
#salt-call state.disable highstate

####################################################################
#2. Remove 	 Client
###################################################################
echo -e "**Reviewing Oracle Client Package**"
oraclient=`rpm -qa | grep oracle11client`

if [ "$?" == 0 ] ;then
        echo -e "\tSuccessfully Removed ORACLE CLIENT RPM PACKAGE!!"
else
        echo -e "\tOracle Client PACKAGE was NOT found, Continuing .."
fi
if [ -e /etc/ld.so.conf.d/10-oracle.conf ] ;then
        mv /etc/ld.so.conf.d/10-oracle.conf /tmp/old_10-oracle.conf
        echo -e "\t\tSuccessfully Removed Oracle CLIENT CONFIG FILE!!"
else
        echo -e "\t\tOracle CLIENT CONFIG FILE NOT found, Continuing .."
fi
echo -e "\n"


####################################################################
#3. Run LDCONFIG
###################################################################
echo -e "**Running LDCONFIG**"
ldconfig
if [ "$?" == 0 ] ;then
        echo -e "\tLDCONFIG completed successfully!!"
else
        echo -e "\tLDCONFIG failed with Errors/Warning. Please Review "
fi
echo -e " "
echo -e "**Running Shared Library Dependency**"
ldd /usr/bin/dbus-daemon | grep libexpat
echo -e "\n"


####################################################################
#4. Backup & Review FSTAB Entries
###################################################################
cp /etc/fstab /etc/fstab_`date +%d-%b-%Y`
echo -e "\tBacked up /etc/fstab!!"
echo -e "\n"
echo -e "**Printing current Mounts on the system**\n"
df -h


####################################################################
#5. Unmount NFS Mounts & Comment NFS shares in FSTAB
###################################################################
echo -e "\n"
echo -e "**Reviewing NFS Mounts in FSTAB**"
#nfsmount=$(mount | awk '/:/ { print $3 }')
#echo $nfsmount | xargs umount
echo -e "\tNFS Mounts UN-MOUNTED Successfully !!"
sed -e '/[ ]/nfs s/^/#/' /etc/fstab
echo -e "\t\tNFS Shares has been Commented Successfully !!"
cat /etc/fstab
echo -e "\n"


####################################################################
## RHEL / FIRMWARE UPGRADE STEPS
###################################################################

####################################################################
#1. Setup Salt Repo
###################################################################
echo -e "**Setting up YUM Repo using SALT & moving all existing repo files under /root/old_repo_files**"
mkdir /root/old_repo_files
mv /etc/yum.repos.d/* /root/old_repo_files
#salt-call state.sls yum
if [ -e "/etc/yum.repos.d/rhel-server-7.6-os-optional.mirrorlist" ] && [ -e "/etc/yum.repos.d/rhel-server-7.6-os-base.mirrorlist" ]; then
        echo -e "\tYUM Repo using SALT setup Completed Successfully!!"
else
        echo -e "\t!!!YUM Repo not found, please review !!!"
        #exit 0
fi
echo -e "\n"


####################################################################
#2. Clean up YUM Cache
###################################################################
echo -e "**Cleaning up YUM Cache**"
yum clean all
rm -rf /var/cache/yum/*
echo -e "\tSuccessfully cleaned all YUM Cache!!"
echo -e "\n"


####################################################################
#3. Main Upgrade Steps
###################################################################
echo -e "**Starting Upgrade Steps**"
echo -e "\tErasing RPM's whichever is Found : tuned, tuned-profiles-sap-hana, resource-agents-sap-hana, resource-agents, pacemaker, pcs"
echo -e " "
rpm -e tuned tuned-profiles-sap-hana resource-agents-sap-hana resource-agents pacemaker pcs 
if [ "$?" == 0  ]; then
        echo -e "\tErased Packages Successfully!!"
else
        echo -e "\n\tEither Some Packages were NOT Found or None of the packages were Found !!"
fi
echo -e "\n"
echo -e "**Working on Actual OS UPGRADE**\n\n"
yum -y update
if [ "$?" != 0  ]; then
        echo -e "\n\tYUM UPDATE Failed because of some Dependencies or some other reason, Trying without the dependencies\n\n"
        yum -y update --skip-broken
elif [ "$?" == 0  ] ; then
        echo -e "\n"
fi
post_osver=`cat /etc/redhat-release | cut -d " " -f7`
if [ "$post_osver" == "7.6" ]
then
        echo -e "\t\n\nRedhat 7.6 Upgrade was SUCCESSFUL!!"
else
        echo -e "\n\n\tUpgrade was NOT Successful, Please Review!!!"
#       exit 0
fi
echo -e "\n"


####################################################################
#4. Firmware Upgrade Steps
###################################################################
echo -e "**Starting FIRMWARE Upgrade Steps**"
ilo_firmware_path="salturl"
bios_firmware_path="salturl"
ilo_version=`dmidecode -t bios | grep "Firmware Revision" | cut -d: -f2`
bios_version=`dmidecode -t bios | grep "BIOS Revision" | cut -d: -f2`
product_info=`dmidecode -t system | grep "Product Name" | cut -d: -f2`
if [ "$product_info" == " ProLiant DL580 Gen9" ] ; then
        echo -e "\nContinuing with Firmware Upgrade for $product_info"
        if [ "$ilo_version" == " 2.73" ]; then
                echo -e "\n\tNothing to do, ILO Firmware is UP-TO-DATE"
        else
                rpm -ivh /root/rhel76bundle/firmware-ilo4-2.73-1.1.i386.rpm
                if [ "$?" == 0 ];then
                        yes | sh /usr/lib/i386-linux-gnu/firmware-ilo4-2.73-1.1/setup
                        echo -e "\n\n\tILO Firmware was UPDATED Sucessfully !!"
                else
                        echo -e "\tILO Firmware Package was NOT installed, Please Review"
                fi
        fi
        echo -e "\n\nContinuing with BIOS Firmware"
        if [ "$bios_version" == " 2.76" ]; then
                        echo -e "Nothing to do, BIOS Firmware is UP-TO-DATE"
        else
                rpm -ivh /root/rhel76bundle/firmware-system-u17-2.76_2019_10_21-1.1.i386.rpm
                if [ "$?" == 0 ];then
                        yes | sh /usr/lib/i386-linux-gnu/firmware-system-u17-2.76_2019_10_21-1.1/setup
                        echo -e "\n\n\tBIOS Firmware was UPDATED Sucessfully !!"
                else
                        echo -e "\tBIOS Firmware Package was NOT installed, Please Review"
                fi
        fi

else
        echo -e "\n\n\tFirmware Upgrade was NOT PERFORMED"
        echo -e " Note : Only if host is Proliant DL580 Gen 9 Firmware Upgrade can be performed"
fi
echo -e "\n"


####################################################################
#4. Install Mellanox NIC Firmware
###################################################################
echo -e "**Starting MELLANOX FIRMWARE Upgrade **"
echo -e "\n"
rpm -ivh /root/rhel76bundle/firmware-nic-mellanox-ethernet-only-1.0.11-1.1.x86_64.rpm
mellnicfirm=`ethtool -i eth0 | grep firmware-version | awk '{ print $2}'`
if [ "$mellnicfirm" == "14.26.1040" ] ; then
        echo -e "\tNothing to do, Mellanox NIC Firmware Version is UP-TO-DATE"
else
        echo -e "\tStarting to INSTALL & FLASH MELLANOX NIC Firmware"
        yes | sh /usr/lib/x86_64-linux-gnu/firmware-nic-mellanox-ethernet-only-1.0.11-1.1/setup
        if [ "$?" == 0 ];then
                echo -e "\n\n\tMellanox NIC Firmware INSTALLED & FLASHED Sucessfully !!"
        else
                echo -e "\tMellanox NIC Firmware Install failed, Please Review"
                exit 0
        fi


fi
echo -e "\n"


#!/usr/bin/expect
spawn ssh administrator@10.163.70.125
expect "password"
send "welcome1a\r"
interact

