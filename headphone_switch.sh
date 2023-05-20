#!/bin/sh

TOS_ENABLED=`amixer -c 0 cget name="IEC958 Playback Switch",index=0 | \
	     tail -1 | grep 'values=on'`

if [ -n "$TOS_ENABLED" ]; then
	amixer -c 0 cset name='IEC958 Playback Switch',index=0 off
	amixer -c 0 cset name='Master Playback Switch',index=0 on
else
	amixer -c 0 cset name='IEC958 Playback Switch',index=0 on
	amixer -c 0 cset name='Master Playback Switch',index=0 off
fi
