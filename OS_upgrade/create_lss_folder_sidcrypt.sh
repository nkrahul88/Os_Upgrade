#################################
# Create LSS folder and SIDcrypt user
#################################
#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Create LSS folder for HANA SPS05 and add SIDcrypt user') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

sid_uppercase="@data.sid_uppercase@"
sid_crypt="@data.sid_crypt@"
cryptPassword="@option.cryptPassword@"

# Run salt users state
salt-call state.sls users

# Verify user added
cryptuser=`grep $sid_crypt /etc/passwd | awk -F ":" '{print $1}'`
if [ "$cryptuser" == "$sid_crypt" ]
    then
        #Add <SID>crypt group		
        #groupadd "$sid"crypt
        # Create LSS folder
		mkdir -p /lss/shared/$sid_uppercase
        mount /lss/shared/$sid_uppercase
        cp /etc/skel/.* /usr/sap/$sid_uppercase/lss/home
        chown -R $sid_crypt:sapsys /lss
        chown -R $sid_crypt:$sid_crypt /lss/shared/$sid_uppercase
        echo -e "\n[ OK ]\t$sid_crypt user Exists\n"
        echo -e "\n[ OK ]\tLSS Folder Created\n"
        ls -lrtd /lss/shared/$sid_uppercase
    else
        echo -e "\nCreating crypt user and LSS Folder"
        mkdir -p /usr/sap/$sid_uppercase/lss/home
		mkdir -p /lss/shared/$sid_uppercase
        mount /lss/shared/$sid_uppercase
	    useradd -d /usr/sap/$sid_uppercase/lss/home $sid_crypt
	    echo $cryptPassword | passwd --stdin $sid_crypt
	    cp /etc/skel/.* /usr/sap/$sid_uppercase/lss/home
	    #groupadd $sid_crypt
        chown -R $sid_crypt:sapsys /lss
        chown -R $sid_crypt:$sid_crypt /lss/shared/$sid_uppercase
        echo -e "\n[ OK ]\t$sid_crypt user Created\n"
        echo -e "\n[ OK ]\tLSS Folder Created\n"
        ls -lrtd /lss/shared/$sid_uppercase
fi    
