#!/bin/bash
errores=`find /$1/* -maxdepth 0 -mtime 0 -empty -exec du -sh {} \; | wc -l`
backups=`find /$1/* -maxdepth 0 -mtime 0 -exec du -sh {} \; | wc -l`
STATE="0";
status="OK - $backups backups realizados";

if [ $errores -ne 0 ]; then

	status="NOT OK - $errores / $backups backups fallaron";
	STATE="2";
fi
echo $status;
exit $STATE;
