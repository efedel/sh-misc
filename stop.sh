#!/bin/bash

sudo /etc/init.d/lastfmsubmitd stop
sudo /etc/init.d/bluetooth stop
sudo /etc/init.d/NetworkManager stop
sudo /etc/init.d/networking stop
sudo /etc/init.d/samba stop
sudo /etc/init.d/cron stop
sudo /etc/init.d/anacron stop
sudo /etc/init.d/klogd stop
sudo /etc/init.d/avahi-daemon stop
sudo /etc/init.d/dbus stop
sudo /etc/init.d/kdm stop

