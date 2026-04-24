# dotfiles

Config perso pour Arch Linux + Hyprland.

## Contenu

| App | Config |
|-----|--------|
| Hyprland | `.config/hypr/` (keymaps azerty/dvp, thème Catppuccin Mocha) |
| Kitty | `.config/kitty/` |
| Neovim | `.config/nvim/` |
| Yazi | `.config/yazi/` |
| Wofi | `.config/wofi/` |
| Btop | `.config/btop/` |
| Handlr | `.config/handlr/` |
| Zsh | `.zshrc`, `.zshenv` (oh-my-zsh + agnoster) |
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
│   ├── handlr/        # Associations de fichiers
│   ├── theme/         # Thème Catppuccin Mocha
│   └── package_list.txt
├── .local/bin/        # Scripts perso
└── install.sh         # Script de bootstrap
```
