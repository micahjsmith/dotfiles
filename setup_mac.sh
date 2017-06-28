#!/usr/bin/env bash

# Micah Smith
# setup_mac.sh
#   Setup mac-specific config.

echo 

# Config
if [[ -f ~/.bash_profile && $(grep -q 'source ~/.bashrc' ~/.bash_profile) ]];
then
    # pass
    true
else
    echo 'source ~/.bashrc' >> ~/.bash_profile
fi

# Brew
if ! which brew >/dev/null 2>&1;
then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# GNU coreutils
if ! brew list | grep -q coreutils;
then
    brew install coreutils
    echo 'export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"' >> ~/.bashrc.local
    echo 'export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"' >> ~/.bashrc.local
fi

# Other brew
for pkg in tmux wget gnu-which;
do
    if ! brew list | grep -q $pkg; then brew install $pkg; fi
done
