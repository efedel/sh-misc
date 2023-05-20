#!/bin/sh
tp_dev='SynPS/2 Synaptics TouchPad'
state=`xinput list-props "$tp_dev" | grep 'Device Enabled' | cut -d':' -f2 | tr -d '\t '`
if [ $state -eq 1 ]
then
  xinput disable "$tp_dev"
else
  xinput enable "$tp_dev"
fi

