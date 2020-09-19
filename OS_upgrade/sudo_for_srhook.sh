#=========================================================
# Update the sudo configuration to allow the hook script 
#=========================================================
#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Update the sudo configuration to allow the hook script') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

sid_uppercase="@data.sid_uppercase@"
dbUser="@data.dbUser@"

cat  <<EOF>> /etc/sudoers.d/20-saphana
Cmnd_Alias SOK   = /usr/sbin/crm_attribute -n hana_`echo $sid_uppercase`_glob_srHook -v SOK -t crm_config -s SAPHanaSR
Cmnd_Alias SFAIL = /usr/sbin/crm_attribute -n hana_`echo $sid_uppercase`_glob_srHook -v SFAIL -t crm_config -s SAPHanaSR
$dbUser ALL=(ALL) NOPASSWD: SOK, SFAIL
EOF
