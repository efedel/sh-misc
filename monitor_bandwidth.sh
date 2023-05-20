#!/usr/bin/env sh

IFACE="wlp170s0"
LIMIT="500 MiB"
CMD="vnstat -i $IFACE -5 --alert 3 3 daily rx $LIMIT"

true
while [ $? -eq 0 ]
do
	sleep 5s
	#$CMD
 	vnstat -i $IFACE -5 --alert 3 3 daily rx 500 MiB
done
echo BANDWIDTH EXCEEDED
msg="BANDWIDTH LIMIT EXCEEDED: `$CMD | tail -1 | cut -d '|' -f 2,3`"
zenity --error --text="$msg"
