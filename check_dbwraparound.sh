#!/bin/bash
OUTPUT=`PGPASSWORD="$1" check_postgres_txn_wraparound --host=localhost --dbuser=$2 --output=simple`
#if [ $OUTPUT -gt 1900000000 ]; then
#	echo "CRITICAL - $OUTPUT"
#elif [ $OUTPUT -eq 1750000000 ]; then
#	echo "WARN - $OUTPUT"
#else
#	echo "OK - $OUTPUT"
#fi
echo $OUTPUT
