####################################################################
# Remove Oracle Client
###################################################################
#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Remove Oracle Client & Run lddconfig') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

echo -e "\n[INFO]\tChecking for Oracle Client Package"
rpm -qa | grep oracle11client-opt
if [ "$?" == 0 ]
	then
	rpm -e oracle11client-opt
	echo -e "\n[ OK ]\tRemoved ORACLE CLIENT PACKAGE!!"
	else
	echo -e "\n[INFO]\tOracle Client PACKAGE NOT found, Continuing .."
fi
if [ -e /etc/ld.so.conf.d/10-oracle.conf ]
	then
	mv /etc/ld.so.conf.d/10-oracle.conf /tmp/old_10-oracle.conf
	echo -e "\n[ OK ]\tRemoved Oracle CLIENT CONFIG FILE!!!"
else
	echo -e "\n[INFO]\tOracle CLIENT CONFIG FILE NOT found, Continuing .."
fi
####################################################################
# Run LDCONFIG
###################################################################
echo -e "\n[INFO]\tRunning LDCONFIG**"
/usr/sbin/ldconfig
if [ "$?" == 0 ]
	then
	echo -e "\n[ OK ]\tLDCONFIG completed !!!"
else
	echo -e "\n[WARNING]\tLDCONFIG failed with Errors/Warning. Please Review"
	exit 1
fi
/usr/bin/ldd /usr/bin/dbus-daemon | grep libexpat

