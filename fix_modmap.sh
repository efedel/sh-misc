#!/usr/bin/sh

#xmodmap -verbose -e "keycode 0x85 = XF86Tools"
#xmodmap -verbose -e "keysym Hyper_L = XF86Tools"
xmodmap -verbose -e "keycode 133 = XF86Tools"
xmodmap -pk | grep Tools
