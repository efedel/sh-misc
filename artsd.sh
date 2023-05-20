#!/bin/sh

NUM_ARTS=`ps auwx | grep /usr/bin/artsd | grep -v grep | wc -l`
if [ "$NUM_ARTS" -lt 1 ]
then
	/usr/bin/artsd -F 10 -S 4096 -s 60 -m artsmessage -l 3 -f &
fi
