# .bashrc

#Add to path.
PATH=$PATH:$HOME/local/bin

# Add coreutils to path with normal names.
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# Random settings
export TERM='xterm-256color'              # Preferred color terminal
export EDITOR=vim                         # Default editor
mesg n                                    # Disallow others to write
stty -ixon                                # Disable <C-s> that hangs terminal
bind '"\e[A": history-search-backward'    # Arrows search from current cmd
bind '"\e[B": history-search-forward'     # Arrows search from current cmd
umask 0002                                # Default file creation mode
set bell-style none                       # Try to avoid bells
unset SSH_ASKPASS                         # So the display doesn't come up for git

# Colorize PS1
export PS1="\[$(tput bold)\]\[$(tput setaf 4)\][\[$(tput setaf 4)\]\u\[$(tput setaf 4)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 2)\]\W\[$(tput setaf 4)\]]\\$ \[$(tput sgr0)\]"

# System-specific proxies
source ~/.proxies

# Aliases that are paths to certain directories.
source ~/.aliases

# User specific aliases
alias ..='\cd ..'
alias ...='cd ../..'
alias e='evince'
alias latest='\ls -t | head -n 1'
alias mm='$(history -p !!).m'
alias tmuxa='tmux attach -t'
alias tmuxd='tmux detach'
alias v='vim'
alias xopen='xdg-open'

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
