#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

echo -e "\t[INFO] Current RedHat Version"
cat /etc/redhat-release
echo -e "\n"

echo -e "\t[INFO] Current FSTAB Entries"
cat /etc/fstab
echo -e "\n"

echo -e "\t[INFO] Current Mounts on the system"
df -h
echo -e "\n"

echo -e "\t[INFO] Checking NIC Details"
for i in `ip a s |grep UP | awk -F ':' '{print $2}' |egrep 'eno|ens|eth|bond'|grep -v "@"`
    do
        echo -e "Checking for NIC :  "$i""
        ethtool -i $i
        echo -e "\n"
        ethtool $i
        echo -e "\n"
        result=`ethtool $i | grep Link | awk '/:/ {print $3}'`
        if [ "$result" == yes ] ; then
                echo -e "[INFO]\t Link is UP for $i\n"
        else
                echo -e "[ALERT]\t Link is DOWN for $i\n"
        fi
    done
echo -e "\n"
    
echo -e "\t[INFO] Current Routes configured on the system"
route -n
echo -e "\n"

ilo_decrypt_password="@option.ilo-decrypt-password@"

echo -e "\t[INFO] Checking Current Errors/Warning/Hardware Issues"
cat /var/log/messages | egrep -i 'error|warning|failed'
echo -e "\n"

echo -e "\t[INFO] Checking ILO Connectivity"
iLO_ip=`ipmitool lan print  |grep "IP Address              :" |awk '{print $4}'`		
ping -c 2 $iLO_ip
if [ "$?" -ne 0 ]
then	
	echo -e "\n[ERROR]\tILO not accessible!!!, Please CHECK"
	exit 1
else
    echo -e "\n[ OK ]\tILO is accessible"
fi

#If in cluster verify clusteruser

#ILO_Status=`fence_ilo4 -a $iLO_ip -l clusteruser -p $ilo_decrypt_password -o status |awk '{print $2}'`
#if [ "$ILO_Status" == "ON" ]; then
#    echo -e "\n[ OK ]\tILO Status is ON"
#	else
#	echo -e "\n[ERROR]\tUnable to get ILO status"
#	exit 1
#fi	  
#echo -e "\n"

echo -e "\t[INFO] Checking PCS Cluster Status"
pcs status --full
echo -e "\n"

echo -e "\t[INFO] Checking PCS Service Status"
service pcsd status
echo -e "\n"

echo -e "\t[INFO] Checking if packages are installed"
rpm -qa | egrep 'tuned-2.8.0-5.el7.noarch|tuned-profiles-sap-hana-2.8.0-5.el7_4.2.noarch|resource-agents-sap-hana-3.9.5-105.el7_4.11.x86_64|resource-agents-3.9.5-105.el7_4.11.x86_64 |pacemaker-1.1.16-12.el7_4.8.x86_64|pcs-0.9.158-6.el7_4.1.x86_64|oracle11client-opt-11.2.0.4-1.3.el7.x86_64'
echo -e "\n"

echo -e "\t[INFO] Checking Hardware Info"
dmidecode -t system
echo -e "\n"

echo -e "\t[INFO] Checking Firmware Version Details"
dmidecode -t bios | grep Revision
echo -e "\n"

echo -e "\t[INFO] Checking Current Kernel version"
uname -r
echo -e "\n"

echo -e "\t[INFO] Checking ILO Details"
ipmitool lan print
echo -e "\n"