#!/bin/bash
# Builds ~/.local/share/ssid-helper/ssid-helper.app (needs Xcode command line tools).
set -euo pipefail
SRC="$(cd "$(dirname "$0")" && pwd)"
APP="$HOME/.local/share/ssid-helper/ssid-helper.app"
mkdir -p "$APP/Contents/MacOS"
cp "$SRC/Info.plist" "$APP/Contents/Info.plist"
swiftc -O "$SRC/main.swift" -o "$APP/Contents/MacOS/ssid-helper"
codesign --force --sign - "$APP"
echo "built $APP"
