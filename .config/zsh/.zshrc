source ~/.config/zsh/prompt # Powerlevel10k, should be at the top of zshrc

# zsh
source ~/.config/zsh/general
source ~/.config/zsh/vi
source ~/.config/zsh/plugins
source ~/.config/zsh/completion
source ~/.config/zsh/aliases
source ~/.config/zsh/keybindings
source ~/.config/zsh/env

# fzf
source ~/.config/fzf/fzf-config

# Rust
source ~/.cargo/env

# lf
source $HOME/.config/lf/icons

# iTerm2 Shell Integration
export ITERM2_SQUELCH_MARK=1
test -e "${ZDOTDIR}/iterm2_shell_integration.zsh" && source "${ZDOTDIR}/iterm2_shell_integration.zsh"

# Wezterm Shell Integration
[[ -n $WEZTERM_CONFIG_DIR ]] && test -e "${ZDOTDIR}/wezterm_shell_integration.sh" && source "${ZDOTDIR}/wezterm_shell_integration.sh"
