#!/bin/bash
#
### Check status replicas.
#
HOST="$1"
PORT="$2"
URL="http://${HOST}:${PORT}/solr/admin/replication/index.jsp"

MASTER=`curl -s ${URL} | grep "Replicatable Index Version" | awk {'print $5'}`
SLAVE=`curl -s ${URL} | grep "Index Version" | grep -v '<td>' | awk {'print $5'}`

#printf "Master ${MASTER}\n"
#printf "Slave ${SLAVE}\n"

if [ "${MASTER}" -eq "${SLAVE}" ]; then
	echo "Replicacion OK"
	exit 0
else
	echo "Diff de replicacion `expr ${MASTER} - ${SLAVE}`"
	exit 2
fi
