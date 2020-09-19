#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

dbUser=`ps -ef | grep -i 'HDB00/exe/sapstartsrv' | egrep -v 'grep' | awk '{print $1}'`
sid=${dbUser%adm*}
sid_uppercase=`echo $sid | tr '[:lower:]' '[:upper:]'`
sid_crypt="$sid"crypt

echo -e "\n[INFO]\tFetching SID Details and DBUser"
echo sid=$sid
echo sid_uppercase=$sid_uppercase
echo sid_crypt=$sid_crypt
echo dbUser=$dbUser
