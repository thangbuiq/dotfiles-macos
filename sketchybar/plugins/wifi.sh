#!/bin/sh
# Shows the Wi-Fi name. macOS hides the SSID unless an app has Location permission,
# so ssid-helper.app (see helpers/ssid-helper) writes it to a cache file.
CACHE="$HOME/.cache/sketchybar/ssid"
APP="$HOME/.local/share/ssid-helper/ssid-helper.app"

IF="$(route get default 2>/dev/null | awk '/interface:/ {print $2}')"
WIFI="$(networksetup -listallhardwareports | awk '/Wi-Fi/ {getline; print $2}')"

if [ -z "$IF" ]; then
  sketchybar --set "$NAME" icon=󰖪 label="offline"
elif [ "$IF" != "$WIFI" ]; then
  sketchybar --set "$NAME" icon=󰈀 label="wired"
else
  # refresh the cached name at most once a minute
  AGE=999
  [ -f "$CACHE" ] && AGE=$(( $(date +%s) - $(stat -f %m "$CACHE") ))
  [ "$AGE" -gt 60 ] && [ -d "$APP" ] && open -g -j -a "$APP"
  SSID="$(cat "$CACHE" 2>/dev/null | tr '[:upper:]' '[:lower:]')"
  sketchybar --set "$NAME" icon=󰖩 label="${SSID:-wi-fi}"
fi
