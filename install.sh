#!/bin/bash
# Idempotent macOS setup: SketchyBar, fastfetch, Übersicht widgets (Catppuccin Mocha, mono, square).
# Usage: ./install.sh   (safe to re-run; existing configs are backed up once to *.bak-<timestamp>)
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
WIDGETS="$HOME/Library/Application Support/Übersicht/widgets"
STAMP="$(date +%s)"

[ "$(uname)" = "Darwin" ] || { echo "macOS only"; exit 1; }
command -v brew >/dev/null || { echo "Install Homebrew first: https://brew.sh"; exit 1; }

echo "==> Installing packages"
brew bundle --file="$REPO/Brewfile"

link() { # link <src> <dst>: symlink, backing up a real file or dir first
  local src="$1" dst="$2"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then return; fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then mv "$dst" "$dst.bak-$STAMP"; fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
}

echo "==> Linking configs"
link "$REPO/sketchybar" "$HOME/.config/sketchybar"
link "$REPO/fastfetch"  "$HOME/.config/fastfetch"
link "$REPO/starship/starship.toml" "$HOME/.config/starship.toml"
link "$REPO/nvim"        "$HOME/.config/nvim"
link "$REPO/zsh/zshrc"     "$HOME/.zshrc"
link "$REPO/zsh/zshenv"    "$HOME/.zshenv"
link "$REPO/zsh/hushlogin" "$HOME/.hushlogin"
chmod +x "$REPO"/sketchybar/sketchybarrc "$REPO"/sketchybar/colors.sh "$REPO"/sketchybar/plugins/*.sh

echo "==> Copying Übersicht widgets"
mkdir -p "$WIDGETS"
rsync -a "$REPO/ubersicht/widgets/" "$WIDGETS/"

echo "==> Terminal.app theme (Catppuccin Mocha)"
open "$REPO/terminal/catppuccin-mocha.terminal"; sleep 2
defaults write com.apple.Terminal "Default Window Settings" "catppuccin-mocha"
defaults write com.apple.Terminal "Startup Window Settings" "catppuccin-mocha"

echo "==> Shell"
touch "$HOME/.zshrc"
# starship must be initialised by your shell setup (e.g. zim: zmodule https://github.com/joke/zim-starship,
# or: eval "$(starship init zsh)"). fastfetch goes last so it prints after everything loads.
grep -qx 'fastfetch' "$HOME/.zshrc" || printf '\nfastfetch\n' >> "$HOME/.zshrc"

echo "==> Building ssid-helper (shows the Wi-Fi name; needs Xcode command line tools)"
if command -v swiftc >/dev/null; then "$REPO/helpers/ssid-helper/build.sh"; else echo "swiftc missing: run xcode-select --install, then re-run"; fi
open -g -a "$HOME/.local/share/ssid-helper/ssid-helper.app" 2>/dev/null || true

echo "==> Starting services"
brew services restart sketchybar >/dev/null
open -a "Übersicht" || true

cat <<MSG

Done. Manual steps (macOS does not allow scripting these):
  1. System Settings > Privacy & Security > Screen & System Audio Recording: allow Übersicht.
  2. Optional: auto-hide the native menu bar (Control Center) if SketchyBar overlaps it.
  3. Widget positions assume the Dock is on the left (63 px wide). Edit left/bottom in
     ubersicht/widgets/*/index.* if yours differs, then re-run ./install.sh.
  4. Wallpaper: set wallpapers/mocha-ascii-4k.png in System Settings > Wallpaper.
  5. github-contributions: set GH_USER in ubersicht/widgets/github-contributions.widget/index.coffee.
MSG
