#!/bin/bash

for i in $*
do
	case $i in
    	-w=* )
		warn=${i#*=}
		;;
    	-c=*)
		crit=${i#*=}
		;;
    	-ct=*)
		controller=${i#*=}
		;;
    	
	-p=*)
		par=${i#*=}
		;;

	-s=*)
		serv=${i#*=}
		;;

	*)
                # unknown option
		;;
  	esac
done

DATA=`wget -q -O - "http://$serv/develop/stats?controller=$controller&parametro=$par"`
#echo  Resultado: $DATA
DATAINT=${DATA/.*}
#echo warning:$warn , Critical:$crit, Controlador:$controller

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
echo "OK - $DATA"
exit 0;
else
STATUS="WARNING - $DATA"
EXIT=1;
fi
if [ $DATAINT -gt $crit ]; then
STATUS="CRITICAL - $DATA - Co:$controller - Pa:$par - C:$crit - W:$warn - Serv:$serv"
EXIT=2;
fi
echo "$STATUS|control=$DATAINT;$warn;$crit"
exit $EXIT
