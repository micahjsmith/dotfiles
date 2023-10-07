#!/usr/bin/env bash

# Micah Smith
# setup_mac.sh
#   Setup mac-specific config. No need to re-write this in Python.

SCRIPTNAME=$(basename "$0")
SCRIPTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATAJSONPATH=$(realpath "${SCRIPTDIR}/../data.json")

# Config
if [ -f ~/.bash_profile ] && grep -q '. ~/.bashrc' ~/.bash_profile; then
    # pass
    true
else
    echo '. ~/.bashrc' >>~/.bash_profile
fi

# Install brew
if ! command -v brew >/dev/null 2>&1; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install jq to bootstrap other installs :(
if ! command -v jq >/dev/null 2>&1; then
    brew install jq
fi

# Other brew
# TODO path to data.json!
for pkg in $(jq -r '.brew.formulas | join(" ")' "${DATAJSONPATH}"); do
    if ! brew list -1 --formula | grep -q "$pkg"; then
        brew install "$pkg"
    fi
done

# Brew casks
for pkg in $(jq -r '.brew.casks | join(" ")' "${DATAJSONPATH}"); do
    if ! brew list -1 --cask | grep -q "$pkg"; then
        # split into cask, cmd pair if cask is provided
        cmd="${pkg##*/}"
        cask="${pkg%$cmd}"
        cask="${cask%/}"
        if [[ -n "$cask" ]]; then
            brew tap "$cask"
        fi

        brew install --cask "$cmd"
    fi
done

# Place GNU coreutils and findutils ahead on the path
# shellcheck disable=2016
if ! grep -q coreutils ~/.bashrc.local; then
    echo 'export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"' >>~/.bashrc.local
    echo 'export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"' >>~/.bashrc.local
fi

# install key bindings for fzf
if [ ! -f "$HOME/.bash/installed-fzf-key-bindings" ]; then
    "$(brew --prefix)/opt/fzf/install" --key-bindings --no-completion --no-update-rc
    touch "$HOME/.bash/installed-fzf-key-bindings"
fi
