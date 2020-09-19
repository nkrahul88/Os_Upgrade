#!/bin/bash

PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Stop Hana Database') ]]; then
  echo -e "\n[INFO]\tSkipping the Step as per input.\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

dbUser="@data.dbUser@"

sudo -S su - $dbUser HDB stop
if [ "$?" == 0 ]
    then 
        echo "\n[INFO]\tSuccessfully stopped database.\n"
    else 
        echo "\n[ERROR]\tUnable to stop database.\n"
        exit 1
fi
