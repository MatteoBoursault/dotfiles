#!/usr/bin/env bash
# Applique un thème (palette ANSI 16 couleurs) à kitty, hyprland, wofi,
# yazi, starship et neovim.
#
# Usage:
#   apply-theme.sh <nom>     # ex: apply-theme.sh gruvbox
#   apply-theme.sh           # réapplique le thème courant
#   apply-theme.sh --list

set -euo pipefail

THEME_DIR="$HOME/.config/theme"
CURRENT_FILE="$THEME_DIR/.current-theme"
KEYS=(base00 base01 base02 base03 base04 base05 base06 base07
      base08 base09 base0A base0B base0C base0D base0E base0F
      font font_size)

list_themes() {
    find "$THEME_DIR/themes" -maxdepth 1 -name '*.env' -printf '%f\n' | sed 's/\.env$//' | sort
}

if [[ "${1:-}" == "--list" || "${1:-}" == "-l" ]]; then
    list_themes; exit 0
fi

THEME="${1:-$(cat "$CURRENT_FILE" 2>/dev/null || true)}"

if [[ -z "$THEME" ]]; then
    echo "Aucun thème spécifié et aucun thème courant." >&2
    exit 1
fi

THEME_FILE="$THEME_DIR/themes/$THEME.env"
if [[ ! -f "$THEME_FILE" ]]; then
    echo "Thème introuvable: $THEME" >&2
    exit 1
fi

set -a
# shellcheck disable=SC1090
source "$THEME_FILE"
set +a

render() {
    local sed_args=()
    for key in "${KEYS[@]}"; do
        sed_args+=(-e "s|{{${key}}}|${!key}|g")
    done
    sed "${sed_args[@]}" "$1" > "$2"
}

echo "Thème: $THEME"
render "$THEME_DIR/templates/hypr.tmpl"  "$HOME/.config/hypr/theme.conf"
render "$THEME_DIR/templates/kitty.tmpl" "$HOME/.config/kitty/theme.conf"
render "$THEME_DIR/templates/wofi.tmpl"  "$HOME/.config/wofi/style.css"
render "$THEME_DIR/templates/nvim.tmpl"  "$HOME/.config/nvim/lua/colors.lua"
echo "$THEME" > "$CURRENT_FILE"

hyprctl reload
