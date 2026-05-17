# ==============================================================================
# PLUGINS
# ==============================================================================

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086"
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/plugins/you-should-use/you-should-use.plugin.zsh

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
# INIT
# ==============================================================================

eval "$(starship init zsh)" # prompt
eval "$(atuin init zsh)"    # command line completion

# ==============================================================================
# VI MODE
# ==============================================================================
# Activer keymap vi
bindkey -v

# Remapper les touches en mode normal
bindkey -M vicmd 'h' backward-char
bindkey -M vicmd 't' atuin-up-search
bindkey -M vicmd 'n' atuin-up-search
bindkey -M vicmd 's' forward-char

# ==============================================================================
# OPTIONS ZSH
# ==============================================================================

setopt AUTO_CD              # taper un répertoire = cd
setopt CORRECT              # suggestion de correction

# ==============================================================================
# OUTILS
# ==============================================================================

eval "$(zoxide init zsh --cmd cd)"                                    # zoxide (cd)
alias ll="eza -la --icons --git --group-directories-first"            # eza (ls)
alias lt="eza -la --icons --tree --level=2 --group-directories-first"
alias ls="eza --icons --group-directories-first"

alias ps="procs"                                                      # procs (ps)
alias htop="btop"                                                     # btop (htop)
alias netw="bandwich"                                                 # bandwich => network monitoring

alias ddocker="lazydocker"                                            # lazydocker (docker)
alias ggit="lazygit"                                                  # lazygit (git)

alias find="fd"                                                       # fd (find)
ffind() { fd "$1" / --hidden --no-ignore }
alias grep="rg"                                                       # rg (grep)
rrg() { rg "$1" --hidden --no-ignore }

alias mman="tldr"                                                     # tldr (man)
alias regex="grex"                                                    # grex => regex generator
alias xx="handlr open"                                                # open

# ==============================================================================
# SCRIPTS
# ==============================================================================

# Hyprland — switch keymap
alias azerty="sed -i 's/^\$keymaps_conf_file =.*$/\$keymaps_conf_file = azerty.conf/' ~/.config/hypr/hyprland.conf && hyprctl reload"
alias dvp="sed -i 's/^\$keymaps_conf_file =.*$/\$keymaps_conf_file = dvp.conf/' ~/.config/hypr/hyprland.conf && hyprctl reload"

# Maintenance
alias save_package_list="paru -Qe > ~/.config/package_list.txt"

# Journaling
template() {
  sed \
  "s/{{date:MM-YYYY}}/$(date +%m-%Y)/g; \
  s/{{date:DD-MM-YYYY}}/$(date +%d-%m-%Y)/g; \
  s/{{date:DD-MM-YYYY HH:mm}}/$(date +%d-%m-%Y\ %H:%M)/g" \
  "$1" > "$2"
}

alias daily="template $VAULT_PATH/templates/carnet_de_bord/daily-note.md"
