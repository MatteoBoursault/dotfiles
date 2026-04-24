# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
plugins=(zsh-autosuggestions zsh-syntax-highlighting you-should-use) # zsh-vi-mode
source $ZSH/oh-my-zsh.sh

# Environment variables
export EDITOR=nvim
export VAULT_PATH=$HOME/my_vault
export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$PATH$PATH"

# Secrets
[[ -f ~/.secrets.env ]] && source ~/.secrets.env

# Aliases et function
alias ll="ls -lha"
alias xx="xdg-open"

alias azerty="sed -i 's/^\$keymaps_conf_file =.*$/\$keymaps_conf_file = azerty' ~/.config/hypr/hyprland.conf"
alias dvp="sed -i 's/^\$keymaps_conf_file =.*$/\$keymaps_conf_file = dvp' ~/.config/hypr/hyprland.conf"

alias save_package_list="paru -Qe > ~/.config/package_list.txt"

template() {
  sed \
  "s/{{date:MM-YYYY}}/$(date +%m-%Y)/g; \
  s/{{date:DD-MM-YYYY}}/$(date +%d-%m-%Y)/g; \
  s/{{date:DD-MM-YYYY HH:mm}}/$(date +%d-%m-%Y\ %H:%M)/g" \
  "$1" > "$2";
}

alias daily="template $VAULT_PATH/templates/carnet_de_bord/daily-note.md "
