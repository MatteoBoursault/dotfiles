# ==============================================================================
# PLUGINS
# ==============================================================================

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086"
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/plugins/you-should-use/you-should-use.plugin.zsh

# ==============================================================================
# PROMPT
# ==============================================================================

eval "$(starship init zsh)"

# ==============================================================================
# OPTIONS ZSH
# ==============================================================================

setopt AUTO_CD              # taper un répertoire = cd
setopt CORRECT              # suggestion de correction
setopt HIST_IGNORE_DUPS     # pas de doublons dans l'historique
setopt HIST_IGNORE_SPACE    # commande précédée d'un espace = pas dans l'historique
setopt SHARE_HISTORY        # partager l'historique entre sessions
setopt EXTENDED_HISTORY     # timestamp dans l'historique

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Complétion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive

# ==============================================================================
# ENVIRONMENT
# ==============================================================================

export EDITOR=nvim
export VAULT_PATH=$HOME/my_vault
export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$PATH"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# Secrets
[[ -f ~/.secrets.env ]] && source ~/.secrets.env

# ==============================================================================
# OUTILS
# ==============================================================================

# zoxide — cd intelligent (remplace cd)
eval "$(zoxide init zsh --cmd cd)"

# ==============================================================================
# ALIASES
# ==============================================================================

# Navigation
alias ll="eza -la --icons --git --group-directories-first"
alias lt="eza -la --icons --tree --level=2 --group-directories-first"
alias ls="eza --icons --group-directories-first"
alias xx="xdg-open"

# Hyprland — switch keymap
alias azerty="sed -i 's/^\$keymaps_conf_file =.*$/\$keymaps_conf_file = azerty.conf/' ~/.config/hypr/hyprland.conf && hyprctl reload"
alias dvp="sed -i 's/^\$keymaps_conf_file =.*$/\$keymaps_conf_file = dvp.conf/' ~/.config/hypr/hyprland.conf && hyprctl reload"

# Maintenance
alias save_package_list="paru -Qe > ~/.config/package_list.txt"

# ==============================================================================
# FONCTIONS
# ==============================================================================

template() {
  sed \
  "s/{{date:MM-YYYY}}/$(date +%m-%Y)/g; \
  s/{{date:DD-MM-YYYY}}/$(date +%d-%m-%Y)/g; \
  s/{{date:DD-MM-YYYY HH:mm}}/$(date +%d-%m-%Y\ %H:%M)/g" \
  "$1" > "$2"
}

alias daily="template $VAULT_PATH/templates/carnet_de_bord/daily-note.md"


