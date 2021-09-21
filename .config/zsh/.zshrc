# Simon's config for the Zoomer Shell based on Luke's config for the Zoomer Shell

# Prompt + colors
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}%(!.#.$)%b "
setopt autocd
stty stop undef
setopt interactive_comments

# History in cache directory
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history

# Load aliases and shortcuts if available
sourcealias() {
  [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
  [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
  [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"
}
sourcealias

# Source all zsh files
sourcedotfiles() {
  # .zshrc will automatically run `sourcealias`
  source "$ZDOTDIR/.zshrc"
  [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/profile" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/profile"
  echo "Reloaded all zsh dotfiles"
}

# Basic auto/tab completion
autoload -U compinit
zstyle ":completion:*" menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes
function zle-keymap-select() {
  case $KEYMAP in
    vicmd) echo -ne "\e[1 q";;
    viins|main) echo -ne "\e[5 q";;
  esac
}
zle -N zle-keymap-select

function zle-line-init() {
  zle -K viins
  echo -ne "\e[5 q"
}
zle -N zle-line-init

echo -ne "\e[5 q"
function preexec() { echo -ne "\e[5 q" ; }

# Use lf to switch directories and bind it to ctrl-o
function lfcd() {
  tmp="$(mktemp)"
  lf -last-dir-path="$tmp" "$@"
  if [ -f "$tmp" ]; then
    dir="$(cat "$tmp")"
    rm -f "$tmp" >/dev/null
    [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
  fi
}
bindkey -s '^o' "lfcd\n"

# Copy cwd with ctrl-p
bindkey -s '^p' "pwdcp\n"

# Calculator on ctrl-a
bindkey -s '^a' "bc -lq\n"

# ^[[P == DELETE
bindkey '^[[P' delete-char

# Edit line with ctrl-e
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Add ssh keys to agent if not present
[ "$(ssh-add -L)" = "The agent has no identities." ] && ssh-add ~/.ssh/id_rsa

# Load syntax highlighting. Should be last
source $HOME/.local/share/zsh-syntax/zsh-syntax-highlighting.plugin.zsh 2>/dev/null
