#!/bin/sh
# vpn is on if a built-in vpn service is connected or a utun interface has an IPv4 address
if scutil --nc list 2>/dev/null | grep -q "(Connected)" \
   || ifconfig | awk '/^[a-z0-9]+:/ {i = ($1 ~ /^utun/)} /\tinet / && i {f=1} END {exit !f}'; then
  sketchybar --set "$NAME" label="vpn on" icon.color=0xffa6e3a1
else
  sketchybar --set "$NAME" label="vpn off" icon.color=0xff9399b2
fi
