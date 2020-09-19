###########################
# Verify iLO connectivity
###########################
#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Verify iLO connectivity') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

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
ILO_Status=`fence_ilo4 -a $iLO_ip -l clusteruser -p `/usr/local/bin/pcs-ilo-decrypt-passwd` -o status |awk '{print $2}'`
if [ "ILO_Status" == "ON" ]; then
    echo -e "[ OK ] ILO Status is ON"
	else
	echo -e "[ERROR] unable to get ILO status"
	exit 1
fi	  
	  