#!/bin/sh
USED="$(df -k /System/Volumes/Data | awk 'NR==2 {gsub("%","",$5); print $5}')"
sketchybar --set "$NAME" label="disk ${USED}%"
