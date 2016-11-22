#!/bin/bash

while getopts ":w:c:t:p:s:" opt; do
case $opt in
	w)
	warn=$OPTARG;
	;;
	c)
	crit=$OPTARG;
	;;
	t)
	controller=$OPTARG;
	;;
	p)
	par=$OPTARG;
	;;
	s)
	serv=$OPTARG;
	;;
esac
done
DATA=`wget -q -O - "http://$serv/develop/stats?controller=$controller&parametro=$par"`
DATAINT=${DATA/.*}

a1=$DATAINT
a=$(echo $a1|awk '{if($1 > 0) print $1; else print $1"*-1"}')
b=$(echo "scale=2;$a/$a + 1" | bc -l 2>/dev/null)

if [[ $b > 1 ]]
then
   sleep 1;
else
   DATAINT=0;
fi
if [ $DATAINT -lt $warn ]; then
	STATUS="OK - $DATA";
	echo "$STATUS|control=$DATAINT;$warn;$crit";
	exit 0;
elif [ $DATAINT -lt $crit ]; then
	STATUS="WARNING - $DATA";
	echo "$STATUS|control=$DATAINT;$warn;$crit";
	exit 1;
elif [ $DATAINT -gt $crit ]; then
	STATUS="CRITICAL - $DATA";
	echo "$STATUS|control=$DATAINT;$warn;$crit";
	exit 2;
fi
