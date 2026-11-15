#!/bin/sh
# ram: physical memory in use (active + wired + compressed), like Activity Monitor
# (pN%): how close macOS is to running out of memory (from memory_pressure)
PAGE="$(sysctl -n hw.pagesize)"
TOTAL="$(sysctl -n hw.memsize)"
USED="$(vm_stat | awk -v p="$PAGE" -v t="$TOTAL" '
  /Pages active/ {gsub("\\.","",$3); a=$3}
  /Pages wired down/ {gsub("\\.","",$4); w=$4}
  /occupied by compressor/ {gsub("\\.","",$5); c=$5}
  END {printf "%d", (a + w + c) * p * 100 / t}')"
PRESSURE="$(memory_pressure | awk '/System-wide memory free percentage/ {gsub("%","",$5); print 100 - $5}')"
sketchybar --set ram label="ram ${USED}% (p${PRESSURE}%)"
