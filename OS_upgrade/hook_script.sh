#=========================================================
# Adding the hook script to /hana/shared/H05/srHook 
#=========================================================
#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Adding the hook script to /hana/shared/H05/srHook') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

sid_uppercase="@data.sid_uppercase@"
dbUser="@data.dbUser@"

# Adding srHook script

mkdir -p /hana/shared/$sid_uppercase/srHook
cp /usr/share/SAPHanaSR/srHook/SAPHanaSR.py /hana/shared/$sid_uppercase/srHook
chown -R $dbUser:sapsys /hana/shared/$sid_uppercase/srHook
if [ -f "/hana/shared/$sid_uppercase/srHook/SAPHanaSR.py" ]; then
    echo -e "\n[ OK ]\tsrHook script added\n"
	ls -lrt /hana/shared/$sid_uppercase/srHook/SAPHanaSR.py
	else
	echo -e "\n[ERROR]\tsrHook script NOT added. Please review!!!\n"
	exit 1
fi