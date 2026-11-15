# Agent setup guide

Goal: reproduce this macOS desktop rice on a new machine. Run `./install.sh` from the repo root, then
walk the user through the manual steps it prints. Do not push or commit for the user.

## Layout
- `sketchybar/`: `sketchybarrc`, `colors.sh` (Catppuccin Mocha palette), `plugins/*.sh`. Symlinked to `~/.config/sketchybar`.
  Reload with `sketchybar --reload`.
- `fastfetch/config.jsonc`: minimal config tuned for a light terminal. Symlinked to `~/.config/fastfetch`.
- `ubersicht/widgets/*.widget`: copied (not linked) to `~/Library/Application Support/Übersicht/widgets`.
  Widgets are CoffeeScript or JSX; they hot-reload on save.
- `claude/`: Claude Code statusline backup. `claude-code-budget-status.js` (already has the light-theme colors) goes to
  `~/.claude/`; merge `statusline-settings.json` into `~/.claude/settings.json`. `statusline-light-theme-colors.patch` is the
  color diff, only needed to re-apply onto an unpatched copy of the script.
- `starship/starship.toml`: Mocha-palette prompt, linked to `~/.config/starship.toml`.
- `terminal/catppuccin-mocha.terminal`: Terminal.app profile (from catppuccin/Terminal.app), imported by `install.sh`. Font JetBrainsMono NFM 13, 140x40 window, closes on shell exit.
- `zsh/`: `zshrc`, `zshenv`, `hushlogin` (silences "Last login"; `zshenv` sets `SHELL_SESSIONS_DISABLE=1`). Linked to `~/.zshrc`, `~/.zshenv`, `~/.hushlogin`.
- `nvim/`: IDE-style Neovim (0.11+) on lazy.nvim, Catppuccin Mocha. Linked to `~/.config/nvim`. LSP via mason, blink.cmp, conform, treesitter (main branch), snacks (picker/explorer/lazygit), DAP. First launch installs everything; `lazy-lock.json` pins versions. Run `nvim --headless "+Lazy! sync" +qa` to bootstrap.
- `wallpapers/`: 4K Mocha wallpaper (set manually).
- `helpers/ssid-helper/`: tiny Swift app bundle that writes the Wi-Fi name to `~/.cache/sketchybar/ssid`.
  macOS redacts the SSID for processes without Location permission, so `plugins/wifi.sh` launches this app (at most once a minute). The user must allow its Location prompt once.
- `Brewfile`: formulae, casks and fonts.

## Style rules
- Font: JetBrainsMono Nerd Font Mono. Palette: Catppuccin Mocha. Square corners (radius 0), 1px `#45475a` borders.
- No em dashes in code, comments or docs.

## Machine-specific values to check
- SketchyBar bar: `height=28`, `y_offset=5` assume a 38 px menu bar (notch MacBook). Use `y_offset = (menubar_height - bar_height) / 2`.
- Widgets: `left: 83px` assumes a left Dock of 63 px. Query with:
  `osascript -l JavaScript -e 'ObjC.import("AppKit"); const v=$.NSScreen.mainScreen.visibleFrame; v.origin.x'`
- Widget sizes: macfetch is 654x232 px, github-contributions sits above it (`bottom: 262px`), bluetooth is top right.
- `github-contributions` needs `GH_USER` set in `index.coffee`.
- `bluetooth-battery-status` reads third-party batteries from `pmset -g accps`. Needs Xcode CLT for a one-off `swift` icon render.
- `theme-controller` is fixed to dark mode (`modeSource: 'light'`, scheme `Catppuccin Mocha`).

## Verify
- `sketchybar --query bar | grep -E 'height|y_offset'`
- `pgrep -l Übersicht`
- Widgets only show on the desktop (behind windows).
