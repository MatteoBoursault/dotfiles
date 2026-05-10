#!/usr/bin/env bash
# Applique un thème à kitty, hyprland, wofi et yazi et starship.
#
# Usage:
#   apply-theme.sh <nom>     # ex: apply-theme.sh gruvbox
#   apply-theme.sh           # réapplique le thème courant
#   apply-theme.sh --list

set -euo pipefail

THEME_DIR="$HOME/.config/theme"
CURRENT_FILE="$THEME_DIR/.current-theme"
VARS='${BG0} ${BG1} ${BG2} ${BG3} ${BG4} ${BG5}
      ${FG0} ${FG1} ${FG2} ${FG3}
      ${RED} ${GREEN} ${YELLOW} ${BLUE} ${MAGENTA} ${CYAN} ${ORANGE} ${PURPLE}
      ${ACCENT} ${BORDER}
      ${FONT_MONO} ${FONT_MONO_SIZE}'

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
    mkdir -p "$(dirname "$2")"
    envsubst "$VARS" < "$1" > "$2"
}

echo "Thème: $THEME"
render "$THEME_DIR/templates/hypr.conf.tmpl"       "$THEME_DIR/hypr.conf"
render "$THEME_DIR/templates/kitty.conf.tmpl"      "$THEME_DIR/kitty.conf"
render "$THEME_DIR/templates/wofi-style.css.tmpl"  "$HOME/.config/wofi/style.css"
render "$THEME_DIR/templates/yazi-theme.toml.tmpl" "$HOME/.config/yazi/theme.toml"
render "$THEME_DIR/templates/starship.toml.tmpl"   "$HOME/.config/starship/starship.toml"

hyprctl reload
