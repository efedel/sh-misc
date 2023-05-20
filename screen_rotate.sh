#!/bin/sh
# script to rotate screen (counter-clockwise) based on current orientation

conn_line=`xrandr | grep ' connected'`
dev=`echo "$conn_line" | cut -d' ' -f 1`
orient=`echo "$conn_line" | cut -d' ' -f 5`

case $orient in
  '(normal' )
    xrandr --output $dev --rotate left
    ;;
  'left' )
    xrandr --output $dev --rotate inverted
    ;;
  'inverted' )
    xrandr --output $dev --rotate right
    ;;
  'right' )
    xrandr --output $dev --rotate normal
    ;;
  * )
    xrandr --output $dev --rotate normal
    ;;
esac
