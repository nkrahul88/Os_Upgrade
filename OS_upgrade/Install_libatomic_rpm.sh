#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Install libatomic and compat-sap-c++') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

echo -e "\n[INFO]\tInstalling libatomic and compat-sap-c++ RPMs"
yum install -y libatomic compat-sap-c++-5 compat-sap-c++-6 compat-sap-c++-7 compat-sap-c++-9 
if [ $? == 0 ]
    then
    echo -e "\n[INFO]\tlibatomic and compat-sap-c++ RPMs Installed"  
    rpm -qa |egrep 'compat-sap|libatomic'
    else
    echo -e "\n[INFO]\tInstalling libatomic and compat-sap-c++-9 RPMs FAILED!!!, Please Review"
    exit 1
fi