#!/bin/sh
# Micah Smith's .bashrc

# if [ -f /etc/profile ]; then
#     PATH=""
#     . /etc/profile
# fi

# Exit if not interactive
[[ $- != *i* ]] && return

#Add to path.
[[ ":$PATH:" != *":$HOME/local/bin:"* ]] && PATH="$HOME/local/bin:${PATH}"

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

# # Which which
# # `brew install gnu-which` on OSX
# if gwhich --version 2>/dev/null | grep -q GNU;
# then
#     which ()
#     {
#         (alias; declare -f) | gwhich  --tty-only --read-alias --read-functions --show-tilde --show-dot $@
#     }
#     export -f which
# fi

# Conda
# Note that this activates the base environment, which prepends `(base)` to PS1.
# Later, we reset PS1. This is okay, because we don't care about displaying base
# environment anyway.
. /usr/local/miniconda3/etc/profile.d/conda.sh >/dev/null 2>&1
conda activate >/dev/null 2>&1

# Colors

# Set solarized palette on gnome-terminal
if ps -p$PPID 2>/dev/null | grep -q gnome-terminal;
then
    # ~/.bash/gnome-terminal-colors-solarized/set_dark.sh 2>&1 >/dev/null
    # export GNOME_SOLARIZED_DARK=1

    # shellcheck source=/dev/null
    . ~/.bash/gnome-terminal-colors-solarized/set_light.sh >/dev/null 2>&1 
    export GNOME_SOLARIZED_LIGHT=1
fi

# Use solarized for `ls --color` output
if [ -f ~/.bash/dircolors-solarized/dircolors.256dark ]; then
    eval `dircolors ~/.bash/dircolors-solarized/dircolors.256dark` 
fi
LS_COLORS=${LS_COLORS/ex=01;32:/ex=00;32:}         # Don't display executables as bold

# PS1
_set_conda_env(){
    if [ "$CONDA_DEFAULT_ENV" != "" ];
    then
        conda_env=" <$CONDA_DEFAULT_ENV>"
    else
        conda_env=""
    fi
}


# Colorized PS1 that shows git branch. See https://github.com/jimeh/git-aware-prompt
export GITAWAREPROMPT=~/.bash/git-aware-prompt
PROMPT_COMMAND="_set_conda_env; $PROMPT_COMMAND"
# shellcheck source=/dev/null
. "$HOME/.bash/git-aware-prompt/main.sh" 2>/dev/null
export PS1="\n\[$(tput setaf 4)\][ \[$(tput setaf 4)\]\u\[$(tput setaf 4)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 2)\]\W\[$(tput setaf 1)\]\${conda_env}\[$(tput setaf 5)\]\${git_branch}\[$(tput setaf 4)\] ]\n\\$ \[$(tput sgr0)\]"

# git completion
# See https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
. "$HOME/.bash/git-completion/git-completion.bash" 2>/dev/null

# User specific aliases
alias ..='\cd ..'
alias ...='\cd ../..'
alias ....='\cd ../../..'
alias e='evince'
alias g='git'
alias it='git'
alias makel='make 2>&1 | less'
alias mm='$(history -p !!).m'
alias sbrc='. ~/.bashrc'
alias tmuxa='tmux attach -t'
alias tmuxd='tmux detach'
alias xopen='xdg-open'

# Invoking vim
if command -v mvim >/dev/null 2>&1; then
    alias vim='mvim -v'
    alias v='mvim -v'
else
    alias v='vim'
fi

#Change what ls displays
alias ls='\ls --color'
alias l='\ls -AF --color'
alias l1='\ls -AF1 --color'
alias ll='\ls -AhlF --color'
alias lsd='\ls -d1 --color */'
alias lld='\ls -dhl --color */'
alias llth='\ls -AhltF --color | head'

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

# Most recent modified file
alias latest='\ls -t | head -n 1'
# nth most recent modified file
latestn(){
  \\ls -t | head -n "$1" | tail -n 1
}
# The names of the n most recently modified files in this directory and all
# subdirectories. See http://stackoverflow.com/a/4561987/2514228
latestr(){
  find . -type f -printf '%T@ %p\n' | sort -n | tail -n "$1" | cut -f2 -d" "
}

# Compile single table and view as pdf
pdftable(){
  pdflatex \
    "\\documentclass{article}\\begin{document}\\input{$1}\\end{document}" \
    && evince article.pdf && rm -i 'article.*'
}

# Concatenate pdfs
pdfconcat(){
    # usage:
    #     $ pdfconcat file1.pdf file2.pdf
    # creates output.pdf
    if ! command -v gs >/dev/null 2>&1; then
        echo 'gs not installed'
        exit 1
    fi

    gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
        -sOutputFile="output.pdf" \
        "$@"
}

# Extract individual pages from pdf
pdfextract(){
    # usage:
    #     $ pdfextract 1,2,4,7- file.pdf
    # creates output.pdf
    if ! command -v gs >/dev/null 2>&1; then
        echo 'gs not installed'
        exit 1
    fi

    gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
        -sOutputFile="output.pdf" \
        -sPageList="$1" \
        "$2"
}

# Mount the current directory in a jupyter/datascience-notebook session.
jpystart(){
    docker run -dit --name jpy-"$(basename "$(pwd)")" \
        -p 8888:8888 \
        -v "$(pwd):/home/jovyan/work:rw" \
        jupyter/datascience-notebook \
    && sleep 15 \
    && docker exec -it jpy-"$(basename "$(pwd)")" jupyter notebook list
}
jpystop(){
    docker rm -f jpy-"$(basename "$(pwd)")"
}

# Utilities for working with AWS CLI
# shellcheck source=/dev/null
. ~/.bash/aws4d/aws4d.sh 2>/dev/null

# Password-less ssh
# TODO does this work correctly?
# see http://mah.everybody.org/docs/ssh
SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"
if [ -z "$SSH_AUTH_SOCK" ] && [ -x "$SSHAGENT" ]; then
    eval "$($SSHAGENT $SSHAGENTARGS)"
    trap "kill $SSH_AGENT_PID" 0
fi

# System-specific proxies, directories, aliases, etc.
# shellcheck source=/dev/null
. ~/.bashrc.local 2>/dev/null

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
