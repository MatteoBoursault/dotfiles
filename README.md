# dotfiles

Config perso pour Arch Linux + Hyprland.

## Contenu

| App | Config |
|-----|--------|
| Hyprland | `.config/hypr/` (keymaps azerty/dvp) |
| Kitty | `.config/kitty/` |
| Neovim | `.config/nvim/` |
| Yazi | `.config/yazi/` |
| Wofi | `.config/wofi/` |
| Btop | `.config/btop/` |
| Starship | `.config/starship/` |
| Handlr | `.config/handlr/` |
| Zsh | `.zshrc`, `.zshenv` (starship, zoxide, eza) |
| Bash | `.bashrc`, `.bash_profile` |
| Git | `.gitconfig` |

## Installation

```bash
git clone --bare <url> $HOME/.dotfiles
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dot checkout

# Installer les dépendances
chmod +x install.sh
./install.sh
```

## Structure

```
~
├── .config/
│   ├── hypr/          # Hyprland + keymaps
│   ├── kitty/         # Terminal
│   ├── nvim/          # Neovim
│   ├── yazi/          # Gestionnaire de fichiers
│   ├── wofi/          # Lanceur
│   ├── btop/          # Moniteur système
│   ├── starship/      # Prompt
│   ├── handlr/        # Associations de fichiers
│   ├── theme/         # Système de thèmes
│   └── package_list.txt
├── .local/bin/        # Scripts perso
└── install.sh         # Script de bootstrap
```

## Thèmes

Couleurs + police partagées entre kitty, hyprland, wofi, yazi et starship via un
script central :

```bash
~/.config/theme/apply-theme.sh gruvbox
```

Voir [`.config/theme/README.md`](.config/theme/README.md) pour les détails
(structure, conventions, ajout de thèmes/outils).

## Convention de navigation — layout DVP

Tous les outils suivent la même convention directionnelle, calquée sur les
mouvements Neovim :

| Touche | Direction |
|--------|-----------|
| `H` | ← gauche |
| `T` | ↓ bas |
| `N` | ↑ haut |
| `S` | → droite |

Chaque outil utilise un layer de modificateurs distinct pour éviter les
conflits :

| Outil | Modificateur | Usage |
|-------|-------------|-------|
| Hyprland | `Super` | Focus fenêtre WM |
| Hyprland | `Super+Ctrl` | Workspace / monitor |
| Hyprland | `Super+Shift` | Déplacer fenêtre |
| Kitty | `Ctrl+Shift` | Panes, onglets |
| Neovim | *(natif)* | Mouvements curseur |

### Kitty

**Panes**

| Raccourci | Action |
|-----------|--------|
| `Ctrl+Shift+V` | Nouveau split vertical |
| `Ctrl+Shift+B` | Nouveau split horizontal |
| `Ctrl+Shift+C` | Fermer le pane courant |
| `Ctrl+Shift+H` | Focus pane gauche |
| `Ctrl+Shift+T` | Focus pane bas |
| `Ctrl+Shift+N` | Focus pane haut |
| `Ctrl+Shift+S` | Focus pane droite |
| `Ctrl+Shift+←/→/↑/↓` | Redimensionner le pane |

**Onglets**

| Raccourci | Action |
|-----------|--------|
| `Ctrl+Shift+O` | Nouvel onglet (répertoire courant) |
| `Ctrl+Shift+A` | Onglet précédent |
| `Ctrl+Shift+U` | Onglet suivant |
| `Ctrl+Shift+W` | Fermer l'onglet |
| `Ctrl+Shift+R` | Renommer l'onglet |

**Scrollback**

| Raccourci | Action |
|-----------|--------|
| `Ctrl+Shift+F` | Ouvrir scrollback dans le pager |
| `Ctrl+Shift+Z` | Prompt précédent |
| `Ctrl+Shift+X` | Prompt suivant |

### Hyprland

**`Super`**

| Raccourci | Action |
|-----------|--------|
| `Super+H` | Focus fenêtre gauche |
| `Super+T` | Focus fenêtre bas |
| `Super+N` | Focus fenêtre haut |
| `Super+S` | Focus fenêtre droite |
| `Super+A` | Toggle terminal (special workspace) |
| `Super+O` | Toggle file manager |
| `Super+E` | Toggle password manager |
| `Super+U` | Toggle navigateur |
| `Super+C` | Fermer la fenêtre active |
| `Super+R` | Ouvrir le lanceur (wofi) |
| `Super+G` | Quitter Hyprland |

**`Super+Ctrl`**

| Raccourci | Action |
|-----------|--------|
| `Super+Ctrl+N` | Workspace suivant |
| `Super+Ctrl+T` | Workspace précédent |
| `Super+Ctrl+S` | Focus monitor suivant |
| `Super+Ctrl+H` | Focus monitor précédent |

**`Super+Shift`**

| Raccourci | Action |
|-----------|--------|
| `Super+Shift+N` | Déplacer fenêtre vers workspace suivant |
| `Super+Shift+T` | Déplacer fenêtre vers workspace précédent |
| `Super+Shift+S` | Déplacer fenêtre vers monitor suivant |
| `Super+Shift+H` | Déplacer fenêtre vers monitor précédent |

### Neovim — mouvements principaux

| Touche | Action |
|--------|--------|
| `H/T/N/S` | Gauche / bas / haut / droite |
| `Ctrl+H/T/N/S` | Changer de split |
| `Leader+ff` | Recherche de fichiers (fzf) |
| `Leader+fg` | Grep live (fzf) |
| `Leader+fb` | Buffers (fzf) |
| `Leader+e` | Toggle NvimTree |
| `Leader+t` | Terminal flottant |
| `Leader+gd` | Aller à la définition |
| `Leader+ca` | Code action |
| `Leader+rn` | Renommer symbole |
