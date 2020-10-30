for i in `ip a s |grep UP | awk -F ':' '{print $2}' |egrep 'eno|ens|eth|bond'|grep -v "@"`
    do
        echo -e "Checking for NIC :  "$i""
		        result=`ethtool $i | grep Link | awk '/:/ {print $3}'`
        if [ "$result" == yes ] ; then
                echo -e "[INFO]\t Link is UP for $i\n"
        else
                echo -e "[ALERT]\t Link is DOWN for $i\n"
        fi
	ethtool $i | egrep 'Speed|Duplex'
	ethtool -i $i | egrep 'driver|version' | head -2
done