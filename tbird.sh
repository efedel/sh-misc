#!/bin/sh

MOZ_REMOTE=`ls --color=never /usr/lib/thunderbird-[0-9]*/*remote-client|head -1`

if $MOZ_REMOTE 'ping()'; then
	$MOZ_REMOTE -a thunderbird 'mailto()'
else
	thunderbird -compose &
fi
