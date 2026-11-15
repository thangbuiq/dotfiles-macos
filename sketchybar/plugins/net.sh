#!/bin/sh
# network throughput of the default interface, e.g. "↓1.2m ↑80k"
IF="$(route get default 2>/dev/null | awk '/interface:/ {print $2}')"
[ -z "$IF" ] && { sketchybar --set "$NAME" label="↓0k ↑0k"; exit 0; }

STATE="${TMPDIR:-/tmp}/sketchybar_net_state"
read -r IN OUT <<EOT
$(netstat -ib -I "$IF" | awk 'NR==2 {print $7, $10}')
EOT
NOW="$(date +%s)"

if [ -f "$STATE" ]; then
  read -r PIF PIN POUT PT < "$STATE"
  DT=$((NOW - PT))
  if [ "$PIF" = "$IF" ] && [ "$DT" -gt 0 ]; then
    DOWN=$(((IN - PIN) / DT)); UP=$(((OUT - POUT) / DT))
    [ "$DOWN" -lt 0 ] && DOWN=0; [ "$UP" -lt 0 ] && UP=0
    fmt() { awk -v b="$1" 'BEGIN { if (b >= 1048576) printf "%.1fm", b/1048576; else printf "%dk", b/1024 }'; }
    sketchybar --set "$NAME" label="↓$(fmt $DOWN) ↑$(fmt $UP)"
  fi
fi
echo "$IF $IN $OUT $NOW" > "$STATE"
