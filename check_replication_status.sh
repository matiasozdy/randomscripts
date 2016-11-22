#!/bin/bash
#DIR=/var/lib/postgresql/9.5/main/pg_xlog
#DIR=/var/lib/postgresql/9.5/main/base
FAILEDLOGS=`sudo -u postgres cat /var/lib/postgresql/9.5/main/pg_log/postgresql-$(date +%a).log | grep "could not connect to primary" | wc -l`
echo "$FAILEDLOGS failed connections to master"
