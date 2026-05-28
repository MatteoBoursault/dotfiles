# ==============================================================================
# SHELL CONFIGURATION
# ==============================================================================
#
# History-related Settings
$env.config.history.file_format = "sqlite"
$env.config.history.max_size = 5_000_000
# Miscellaneous Settings
$env.config.show_banner = false
$env.config.rm.always_trash = true
$env.config.auto_cd_implicit = true
# Commandline Editor Settings
$env.config.edit_mode = "vi"
$env.config.buffer_editor = "nvim"
$env.config.cursor_shape.vi_insert = "line"
$env.config.cursor_shape.vi_normal = "block"
# Completions Behavior
$env.config.completions.algorithm = "substring"
# External Completions
$env.config.completions.external.completer = {|spans|
  carapace $spans.0 nushell ...$spans | from json
}
# Terminal Integration
$env.config.use_kitty_protocol = false
$env.config.shell_integration.osc8 = false
$env.config.shell_integration.osc633 = false
# Keybindings
$env.config.keybindings = []
# Menus
$env.config.menus = []
# Plugins
$env.config.plugins = {}


# ==============================================================================
# ENVIRONMENT
# ==============================================================================

$env.path ++= ["~/.npm-global/bin"]
$env.path ++= ["~/.local/bin/"]

$env.STARSHIP_CONFIG = ($env.HOME | path join ".config/starship/starship.toml")

$env.FZF_DEFAULT_OPT = "--walker-root=/"

$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_MULTILINE_INDICATOR = ""

# Secrets
source ~/.secrets.env

# ==============================================================================
# EXTERNAL
# ==============================================================================

mkdir ($nu.data-dir | path join "vendor/autoload")

carapace _carapace nushell | save -f ($nu.data-dir | path join "vendor/autoload/carapace.nu") # shell command completer
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu") # cd
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu") # prompt

source ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
alias cd = __zoxide_z

# ==============================================================================
# OUTILS
# ==============================================================================

alias ll = eza -la --icons --git --group-directories-first            # eza (ls)
alias lt = eza -la --icons --tree --level=2 --group-directories-first
alias ls = eza --icons --group-directories-first

alias ps = procs                                                      # procs (ps)
alias htop = btop                                                     # btop (htop)
alias netw = bandwich                                                 # bandwich => network monitoring

alias ddocker = lazydocker                                            # lazydocker (docker)
alias ggit = lazygit                                                  # lazygit (git)

alias find = fd                                                       # fd (find)
def ffind [ file_name ] {
  fd $file_name / --hidden --no-ignore
}
alias grep = rg                                                       # rg (grep)
def rrg [ foo ] {
  rg $foo --hidden --no-ignore
}

alias mman = tldr                                                     # tldr (man)
alias regex = grex                                                    # grex => regex generator
alias xx = handlr open                                                # open

# ==============================================================================
# SCRIPTS
# ==============================================================================

# Hyprland — switch keymap
def azerty [] {
  sed -i 's/^local keymaps_conf =.*$/local keymaps_conf = "azerty"/' ~/.config/hypr/hyprland.lua ;
  hyprctl reload
}
def dvp [] {
  sed -i 's/^local keymaps_conf =.*$/local keymaps_conf = "dvp"/' ~/.config/hypr/hyprland.lua ;
  hyprctl reload
}
# Maintenance
alias save_package_list = paru -Qe > ~/.config/package_list.txt
