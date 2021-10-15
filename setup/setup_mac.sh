#!/usr/bin/env bash

# Micah Smith
# setup_mac.sh
#   Setup mac-specific config. No need to re-write this in Python.

# Config
if [ -f ~/.bash_profile ] && grep -q '. ~/.bashrc' ~/.bash_profile;
then
    # pass
    true
else
    echo '. ~/.bashrc' >> ~/.bash_profile
fi

# Install brew
if ! command -v brew >/dev/null 2>&1;
then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install jq to bootstrap other installs :(
if ! command -v jq >/dev/null 2>&1;
then
    brew install jq
fi

# Other brew
# TODO path to data.json!
for pkg in $(jq -r '.brew.formulas | join(" ")' data.json);
do
    if ! brew list | grep -q $pkg; then
        brew install $pkg
    fi
done

# Place GNU coreutils and findutils ahead on the path
if ! grep -q coreutils ~/.bashrc.local;
then
    echo 'export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"' >> ~/.bashrc.local
    echo 'export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"' >> ~/.bashrc.local
fi

# install key bindings for fzf
if [ ! -f "$HOME/.bash/installed-fzf-key-bindings" ]; then
    "$(brew --prefix)/opt/fzf/install" --key-bindings --no-completion --no-update-rc
    touch "$HOME/.bash/installed-fzf-key-bindings"
fi
