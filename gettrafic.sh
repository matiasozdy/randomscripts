#!/bin/bash
bytesdown1=`/usr/bin/snmpwalk -c $1 -v2c 192.168.4.32 1.3.6.1.4.1.3375.2.1.2.4.4.3.1.5.3.49.46.49 | /usr/bin/cut -d " " -f4`
bytesup1=`/usr/bin/snmpwalk -c $1 -v2c 192.168.4.32 1.3.6.1.4.1.3375.2.1.2.4.4.3.1.3.3.49.46.49 | /usr/bin/cut -d " " -f4`
/bin/sleep 3
bytesdown2=`/usr/bin/snmpwalk -c $1 -v2c 192.168.4.32 1.3.6.1.4.1.3375.2.1.2.4.4.3.1.5.3.49.46.49 | /usr/bin/cut -d " " -f4`
bytesup2=`/usr/bin/snmpwalk -c $1 -v2c 192.168.4.32 1.3.6.1.4.1.3375.2.1.2.4.4.3.1.3.3.49.46.49 | /usr/bin/cut -d " " -f4`

megas=$[ (($bytesdown2 - $bytesdown1)*8 / 30000000) ]
megasu=$[ (($bytesup2 - $bytesup1)*8 / 30000000) ]
if [ "1" == "1" ] ; then 
#echo "Down: "$megasu" Mb/s, Up: "$megas" Mb/s|up="$megas";30;40;0;50 down="$megasu";30;40;0;50"
printf "OK - Down: %s Mb/s, Up: %s Mb/s|up=%s;10;15;0;20 down=%s;10;15;0;20\n" "$megasu" "$megas" "$megas" "$megasu";
STATE="0";

exit $STATE;
fi
