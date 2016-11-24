#!/bin/bash
OUTPUT=`PGPASSWORD="$1" check_postgres_backends --host=localhost --dbuser=$2 --output=simple -w 95 -c 100`
#EXITSTAT=$?
#if [ $EXITSTAT -eq 0 ]; then
#	echo "OK - $OUTPUT conns"
#elif [ $EXITSTAT -eq 1 ]; then
#	echo "WARN - $OUTPUT conns"
#elif [ $EXITSTAT -eq 2 ]; then
#	echo "CRIT - $OUTPUT conns"
#fi
echo $OUTPUT
