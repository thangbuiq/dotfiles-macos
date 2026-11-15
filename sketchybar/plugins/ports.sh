#!/bin/sh
# listening local dev ports (3000-9999 plus common db ports), ignoring macOS system daemons
PORTS="$(lsof -iTCP -sTCP:LISTEN -P -n 2>/dev/null \
  | awk 'NR>1 && $1 !~ /^(ControlCe|rapportd|sharingd|identitys|AirPlay)/ {n=split($9, a, ":"); print a[n]}' \
  | awk '($1 >= 3000 && $1 <= 9999) || $1 == 5432 || $1 == 6379 || $1 == 27017' \
  | sort -nu)"
COUNT="$(printf "%s" "$PORTS" | grep -c .)"
if [ "$COUNT" -eq 0 ]; then
  sketchybar --set "$NAME" label="ports -"
elif [ "$COUNT" -le 3 ]; then
  sketchybar --set "$NAME" label="ports $(echo $PORTS)"
else
  # keep the pill short: first 3 ports, then how many more
  sketchybar --set "$NAME" label="ports $(echo $PORTS | cut -d' ' -f1-3) +$((COUNT - 3))"
fi
