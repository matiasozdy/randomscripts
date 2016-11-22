#!/bin/bash
USED=`sudo -u postgres df --output=pcent $1 | tail -1 | cut -d"%" -f1`
FREE=`expr 100 - $USED`
echo "$FREE"
