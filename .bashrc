# .bashrc

# Source global definitions

# Add to path.
export PATH=$PATH:/usr/local/bin:/usr/local/sbin:/sw/bin

# Random settings
export TERM=xterm-color
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
bind "set bell-style none"

# Default editor
export EDITOR='vim'

# System-specific proxies
source ~/.proxies

# User specific aliases and functions
alias ..='cd ..'
alias .l='cd .. && ls'
alias ...='cd ../..'
alias e='evince '
alias latest='\ls -t | head -n 1'

# Note- -G enables color on OS X, whereas --color can be used on Linux.
alias l='\ls -aF -G'
alias ls='\ls -G'
alias l1='\ls -aF1 -G'
alias ll='\ls -ahlF -G'
alias lsd='\ls -d1 -G */'
alias lld='\ls -dl -G */'
alias mm='$(history -p !!).m'
alias tmuxa='tmux attach -t'
alias tmuxd='tmux detach'
alias v='vim'

# Aliases that are paths to certain directories
source ~/.aliases

# The name of the nth most recently modified file
latestn(){
    \ls -t | head -n $1 | tail -n 1
}

# Most frequently used commands, from CLF
freqcmds(){
    history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}

# Quick calculator function, from CLF (user fizz)
?(){
    echo "$*" | bc 0l
}

# Facilitate a simple copy from tmux
tcopy(){
    echo "$1" > /tmp/tcopytmp.txt
    gvim /tmp/tcopytmp.txt
    rm /tmp/tcopytmp.txt
}

# Imitate zsh-like cd
c(){
    if [ $# -eq 1 ]; then
        cd $1
    elif [ $# -eq 2 ]; then
        cd ${PWD/$1/$2}
    else
        echo "[c] USAGE: c dir"
        echo "[c] USAGE: c old new"
        return 1
    fi
}

# Zsh-like cd + list the files in the directory
cl(){
    c $* && ls
}
