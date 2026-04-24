#!/bin/bash
set -e

if command -v paru &>/dev/null; then
  echo ">> Installation des paquets..."
  paru -S --needed - < ~/.config/package_list.txt

  echo ">> Installation des plugins yazi..."
  ya pack -i

  echo ">> Installation des paquets npm globaux..."
  npm install -g @mariozechner/pi-coding-agent

  echo ">> Application du thème..."
  ~/.config/theme/apply-theme.sh gruvbox

else
    echo "!! paru non trouvé"
fi

echo "=== Terminé ==="
