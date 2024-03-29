export VISUAL=vim                                  # Default editor
export EDITOR=vim                                  # Default editor
bind '"\e[A": history-search-backward' 2>/dev/null # Arrows search from current cmd
bind '"\e[B": history-search-forward'  2>/dev/null # Arrows search from current cmd
alias ..='\cd ..'
alias ...='\cd ../..'
alias c='\cd'
alias g='git'
alias v='vim'
alias l='\ls -AFG'
alias ll='\ls -AhlFG'

. ~/.bashrc.local 2>/dev/null
