#!/bin/sh
source "$CONFIG_DIR/colors.sh"

if [ "$SELECTED" = "true" ]; then
  sketchybar --set "$NAME" background.color=$ACCENT icon.color=0xff1e1e2e
else
  sketchybar --set "$NAME" background.color=$ITEM_BG icon.color=$SUBTEXT
fi
