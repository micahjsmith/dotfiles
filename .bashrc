# .bashrc

#Add to path.
PATH=$HOME/local/bin:$PATH

# Add coreutils to path with normal names.
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# Random settings
export TERM='xterm-256color'              # Preferred color terminal
export EDITOR=vim                         # Default editor
mesg n                                    # Disallow others to write
stty -ixon                                # Disable <C-s> that hangs terminal
bind '"\e[A": history-search-backward' 2>/dev/null    # Arrows search from current cmd
bind '"\e[B": history-search-forward'  2>/dev/null   # Arrows search from current cmd
umask 0002                                # Default file creation mode
set bell-style none                       # Try to avoid bells
unset SSH_ASKPASS                         # So the display doesn't come up for git

# Which which
# `brew install gnu-which` on OSX
if gwhich --version 2>/dev/null | grep -q GNU
then
    which ()
    {
        (alias; declare -f) | gwhich  --tty-only --read-alias --read-functions --show-tilde --show-dot $@
    }
    export -f which
fi

# Colorize PS1, and add git branch. See https://github.com/jimeh/git-aware-prompt
export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh" 2>/dev/null
export PS1="\[$(tput setaf 4)\][\[$(tput setaf 4)\]\u\[$(tput setaf 4)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 2)\]\W\[$(tput setaf 4)\] \[$(tput setaf 5)\]\${git_branch}\[$(tput setaf 4)\]]\\$ \[$(tput sgr0)\]"

# User specific aliases
alias ..='\cd ..'
alias ...='cd ../..'
alias e='evince'
alias latest='\ls -t | head -n 1'
alias makel='make 2>&1 | less'
alias mm='$(history -p !!).m'
alias tmuxa='tmux attach -t'
alias tmuxd='tmux detach'
alias xopen='xdg-open'

# Invoking vim
if which mvim 2>1 >/dev/null; then
    alias vim='mvim -v'
fi
alias v='vim'

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
    cd "$1"
  elif [ "$#" = "2" ]; then
    cd "${PWD/$1/$2}"
  else
    echo "[c] USAGE: c dirname"
    echo "[c] USAGE: c old new"
    return 1
  fi
}

# Zsh-like cd + list the files in the directory
cl(){
  c "$*" && ls
}

# Access nth most recent modified file.
latestn(){
  \ls -t | head -n $1 | tail -n 1  
}

# The names of the n most recently modified files in this directory and all
# subdirectories. See http://stackoverflow.com/a/4561987/2514228
latestr(){
  find . -type f -printf '%T@ %p\n' | sort -n | tail -n $1 | cut -f2 -d" "
}

# Quick calculator function, from user fizz on CLF
?(){
  echo "$*" | bc -l
}

# Compile single table and view as pdf
pdftable(){
  pdflatex \
    "\\documentclass{article}\\begin{document}\\input{$1}\\end{document}" \
    && evince article.pdf && rm -i 'article.*'
} 

# Don't display executables as bold.
LS_COLORS=${LS_COLORS/ex=01;32:/ex=00;32:}

# System-specific proxies
source ~/.proxies 2>/dev/null

# Aliases that are paths to certain directories.
source ~/.aliases 2>/dev/null
