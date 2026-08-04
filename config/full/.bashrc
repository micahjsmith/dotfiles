#!/usr/bin/env bash
# Micah Smith's .bashrc

# if [ -f /etc/profile ]; then
#     PATH=""
#     . /etc/profile
# fi

# Exit if not interactive
[[ $- != *i* ]] && return

# Add homebrew dirs to path
[[ ":$PATH:" != *":/usr/local/bin:"* ]] && PATH="/usr/local/bin:${PATH}"
[[ ":$PATH:" != *":$HOME/local/bin:"* ]] && PATH="$HOME/local/bin:${PATH}"
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && PATH="$HOME/.local/bin:${PATH}"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Add cargo dir to path
[[ ":$PATH:" != *":$HOME/.cargo/bin:"* ]] && PATH="$HOME/.cargo/bin:${PATH}"

# Random settings
export TERM='xterm-256color'                       # Color terminal... see blog.sanctum.geek.nz/term-strings
export VISUAL=vim                                  # Default editor
export EDITOR=vim                                  # Default editor
mesg n                                             # Disallow others to write (interactive term only)
stty -ixon                                         # Disable <C-s> that hangs terminal (interactive term only)
bind '"\e[A": history-search-backward' 2>/dev/null # Arrows search from current cmd
bind '"\e[B": history-search-forward'  2>/dev/null # Arrows search from current cmd
umask 0002                                         # Default file creation mode
set bell-style none                                # Try to avoid bells...
unset SSH_ASKPASS                                  # So the display doesn't come up for git
shopt -s globstar || true                          # Enable globstar option (bash 4+)

# Colors

# Set solarized palette on gnome-terminal
if pgrep -q -P $PPID gnome-terminal 2>/dev/null;
then
    # ~/.bash/gnome-terminal-colors-solarized/set_dark.sh 2>&1 >/dev/null
    # export GNOME_SOLARIZED_DARK=1

    # shellcheck source=/dev/null
    . ~/.bash/gnome-terminal-colors-solarized/set_light.sh >/dev/null 2>&1
    export GNOME_SOLARIZED_LIGHT=1
fi

# Use solarized for `ls --color` output
if [ -f ~/.bash/dircolors-solarized/dircolors.256dark ]; then
    # FIXME: dircolors binary is part of coreutils which may not be on PATH yet
    eval "$(/opt/homebrew/bin/gdircolors ~/.bash/dircolors-solarized/dircolors.256dark)"
fi
LS_COLORS=${LS_COLORS/ex=01;32:/ex=00;32:}         # Don't display executables as bold

# PS1

# Colorized PS1 that shows git branch. See https://github.com/jimeh/git-aware-prompt
. ~/.bash/git-aware-prompt/prompt.sh 2>/dev/null
export PS1="\n\[$(tput setaf 4)\][ \[$(tput setaf 4)\]\u\[$(tput setaf 4)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 2)\]\W\[$(tput setaf 1)\] \[$(tput setaf 5)\]\${git_branch}\[$(tput setaf 4)\] ]\[$(tput sgr0)\]\n\\$ "

# git completion
# See https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
. "$HOME/.bash/git-completion/git-completion.bash" 2>/dev/null

# User specific aliases
alias ..='\cd ..'
alias ...='\cd ../..'
alias ....='\cd ../../..'
alias g='git'
__git_complete g __git_main  # See https://stackoverflow.com/a/24665529/
alias it='git'
alias makel='make 2>&1 | less'
alias sbrc='. ~/.bashrc'
alias tmuxa='tmux attach -t'
alias tmuxd='tmux detach'
alias v=vim
alias j=jupyter
alias i=invoke
alias ag='ag -p ~/.ignore'
alias rr='cd $(git rev-parse --show-toplevel)'
alias k=kubectl
alias tf=terraform

#Change what ls displays
export CLICOLOR=true
alias ls='\ls'
alias l='\ls -AF'
alias l1='\ls -AF1'
alias ll='\ls -AhlF'
alias lsd='\ls -d1 */'
alias lld='\ls -dhl */'
alias llth='\ls -AhltF | head'

# Imitate zsh-like cd
c(){
  if [ "$#" = "1" ]; then
    cd "$1" || return 1
  elif [ "$#" = "2" ]; then
    cd "${PWD/$1/$2}" || return 1
  else
    echo "[c] USAGE: c dirname"
    echo "[c] USAGE: c old new"
    return 1
  fi
}

# python environments

## pyenv setup
# if command -v pyenv 1>/dev/null 2>&1; then
#   eval "$(pyenv init -)"
# fi

## poetry setup
export POETRY_VIRTUALENVS_IN_PROJECT=true

# Password-less ssh
# not sure that this works correctly
# see http://mah.everybody.org/docs/ssh
SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"
if [ -z "$SSH_AUTH_SOCK" ] && [ -x "$SSHAGENT" ]; then
    eval "$($SSHAGENT $SSHAGENTARGS)"
    trap "kill $SSH_AGENT_PID" 0
fi

# From fzf installation
[ -f ~/.fzf.bash ] && . ~/.fzf.bash

# See https://support.apple.com/en-us/HT208050
export BASH_SILENCE_DEPRECATION_WARNING=1

# See https://discourse.jupyter.org/t/jupyter-paths-priority-order/7771
export JUPYTER_PREFER_ENV_PATH=1

# See https://github.com/pypa/pipx/issues/1288#issuecomment-1991265545
export PIPX_HOME=$HOME/.local/pipx


# System-specific proxies, directories, aliases, etc.
# shellcheck source=/dev/null
. ~/.bashrc.local 2>/dev/null
. "$HOME/.cargo/env"

# pnpm
export PNPM_HOME="/Users/micahsmith/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
