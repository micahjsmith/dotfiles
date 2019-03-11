#!/usr/bin/env bash

# Micah Smith
# setup_mac.sh
#   Setup mac-specific config.

# Config
if [ -f ~/.bash_profile ] && grep -q 'source ~/.bashrc' ~/.bash_profile;
then
    # pass
    true
else
    echo 'source ~/.bashrc' >> ~/.bash_profile
fi

# Install brew
if ! command -v brew >/dev/null 2>&1;
then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install GNU coreutils
if ! brew list | grep -q coreutils;
then
    brew install coreutils
    echo 'export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"' >> ~/.bashrc.local
    echo 'export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"' >> ~/.bashrc.local
fi

# Other brew
for pkg in tmux wget gnu-which shellcheck fzf reattach-to-user-namespace;
do
    if ! brew list | grep -q $pkg; then
        brew install $pkg
    fi
done

# install key bindings for fzf
if [ ! -f "$HOME/.bash/installed-fzf-key-bindings" ]; then
    "$(brew --prefix)/opt/fzf/install" --key-bindings --no-completion --no-update-rc
    touch "$HOME/.bash/installed-fzf-key-bindings"
fi
