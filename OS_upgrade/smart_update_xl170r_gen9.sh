#!/bin/bash
PATH="$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
export PATH

#-----Skipping Step Code [START]-----
if [[ "@option.skipStep@" =~ ('Firmware Smart Update') ]]; then
  echo -e "\n[INFO] Skipping the step as per Input\n"
  exit 0
fi
#-----Skipping Step Code [END]-----

echo -e "\n[INFO]\t Downloading ISO"
dc=`hostname | cut -d "." -f2`
ls -l /tmp/xlr170-gen9.iso
if [ "$?" == "0" ]
    then
        echo -e "\n[INFO] ISO File already exists \n"
        break
    else
        /usr/bin/wget  http://salt.$dc.ariba.com/yumrepos/hardware/hpe_firmware/gen9/xlr170/2019/latest/xlr170-gen9.iso -P /tmp
        echo -e "\n[INFO] Download Successful, Proceeding further\n"
fi    

echo -e "\n[INFO] Disabling Salt Highstate\n"
sudo -- bash -c "salt-call state.disable highstate"

cat << EOF > .cshrc
#PATH
set path = /sbin /bin /usr/sbin /usr/bin /usr/games /usr/local/sbin /usr/local/bin $HOME/bin
EOF

source ~/.cshrc

cd /tmp
#### changing nosuid on /tmp ###

find_tmp=$(/bin/df -h | grep -i "/tmp" | awk -F' ' '{ print $1}')
#echo $find_tmp
sudo -- bash -c "/bin/mount -o remount,nosuid,nodev $find_tmp /tmp"
sudo -- bash -c "/bin/mount -o loop,rw xlr170-gen9.iso  /mnt"
sudo -- bash -c "/bin/mount -o remount,nosuid,nodev /var/tmp"

## running smart update ##
cd /mnt/packages
echo -e "\n[INFO]\t Executing Smart Update"
sudo -- bash -c "sh smartupdate  --silent"

sleep 10
echo -e "\n[INFO]\t Enabling Salt Highstate\n"
sudo -- bash -c "salt-call state.enable highstate"
