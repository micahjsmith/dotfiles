#!/usr/bin/env bash

# setup.sh
#   Setup all my config. Downloads vim plugins, bash git prompt, and creates
#   symlinks of relevant dotfiles to home directory
#
# macOS or Linux usage:
#   ./setup.sh
# Windows usage (WSL):
#   ./setup.sh --windows --vimdir /mnt/c/Users/micahsmith/vimfiles

### Parse options

print_usage_and_exit(){
    #TODO
    echo "usage: ./setup.sh [.]"
};

OPTS=$(getopt -o hv:w --long help,vimdir:,windows -n 'parse-options' -- "$@")
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi
eval set -- "$OPTS"
# Defaults
VIMDIR="$HOME/.vim"
WINDOWS=false

while true; do
    case "$1" in
        -h | --help )
            print_usage_and_exit; break ;;
        -v | --vimdir )
            shift; VIMDIR="$1"; shift ;;
        -w | --windows )
            WINDOWS=true; shift ;;
        -- )
            shift; break ;;
        * )
            break ;;
    esac
done

### Setup

MAC=$(uname | grep -q Darwin && echo "true" || echo "false")
SCRIPTNAME=$(basename "$0")
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if command -v wget >/dev/null 2>&1; then
    download="wget -q -O"
else
    download="curl -LSso"
fi

### Vim setup

install_vim_bundle_github(){
    bundle_author=$1
    bundle_name=$2

    if [ ! -d "${VIMDIR}/bundle/${bundle_name}" ];
    then
        git clone \
            "https://github.com/${bundle_author}/${bundle_name}.git" \
            "${VIMDIR}/bundle/${bundle_name}"
        vim -u NONE -c "helptags ${VIMDIR}/bundle/${bundle_name}/doc" -c q
        echo "${SCRIPTNAME}: installed ${bundle_name}"
    fi
}

# Setup vim-pathogen
if [ ! -f "$VIMDIR/autoload/pathogen.vim" ];
then
    mkdir -p "$VIMDIR/autoload" "$VIMDIR/bundle"
    $download "$VIMDIR/autoload/pathogen.vim" https://tpo.pe/pathogen.vim
    echo "$SCRIPTNAME: installed pathogen.vim"
fi

install_vim_bundle_github   altercation   vim-colors-solarized
install_vim_bundle_github   AndrewRadev   linediff.vim
install_vim_bundle_github   bling         vim-airline
install_vim_bundle_github   JuliaLang     julia-vim
install_vim_bundle_github   plasticboy    vim-markdown
install_vim_bundle_github   terryma       vim-expand-region
install_vim_bundle_github   tpope         vim-surround
install_vim_bundle_github   tpope         vim-fugitive
install_vim_bundle_github   tpope         vim-unimpaired
install_vim_bundle_github   vim-airline   vim-airline-themes
install_vim_bundle_github   Yggdroot      indentLine
install_vim_bundle_github   scrooloose    nerdtree

# Setup increment.vim
if [ ! -f "$VIMDIR/plugin/increment.vim" ];
then
    mkdir -p "$VIMDIR/plugin"
    $download "$VIMDIR/plugin/increment.vim" http://www.vim.org/scripts/download_script.php?src_id=469
    vim -u NONE -c 'e ++ff=dos' -c 'w ++ff=unix' -c q "$VIMDIR/plugin/increment.vim"
    echo "$SCRIPTNAME: installed increment.vim"
fi

### Done with Windows setup.
if $WINDOWS; then
    exit 0
fi

### Bash setup

# Setup git-aware-prompt
if [ ! -d ~/.bash/git-aware-prompt ];
then
    mkdir -p ~/.bash/git-aware-prompt
    git clone https://github.com/jimeh/git-aware-prompt.git ~/.bash/git-aware-prompt
    echo "$SCRIPTNAME: installed git-aware-prompt"
fi

# Setup solarized.
if pgrep gnome-terminal >/dev/null 2>&1 && \
    [ ! -d ~/.bash/gnome-terminal-colors-solarized ];
then
    mkdir -p ~/.bash/gnome-terminal-colors-solarized
    git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git \
        ~/.bash/gnome-terminal-colors-solarized
    echo "$SCRIPTNAME: installed gnome-terminal-colors-solarized"
fi

if echo "$TERM_PROGRAM" | grep -q Apple_Terminal && \
    [ ! -d ~/.bash/osx-terminal.app-colors-solarized ];
then
    mkdir -p ~/.bash/osx-terminal.app-colors-solarized
    git clone https://github.com/tomislav/osx-terminal.app-colors-solarized.git \
        ~/.bash/osx-terminal.app-colors-solarized
    open ~/.bash/osx-terminal.app-colors-solarized/Solarized\ Dark.terminal &
    open ~/.bash/osx-terminal.app-colors-solarized/Solarized\ Light.terminal &
    echo "$SCRIPTNAME: installed osx-terminal.app-colors-solarized"
fi

if [ ! -d ~/.bash/dircolors-solarized ];
then
    mkdir -p ~/.bash/dircolors-solarized
    git clone https://github.com/seebi/dircolors-solarized.git \
        ~/.bash/dircolors-solarized
    echo "$SCRIPTNAME: installed dircolors-solarized"
fi

# Install aws4d utils
if [ ! -d ~/.bash/aws4d ];
then
    mkdir -p ~/.bash/aws4d
    git clone https://github.com/micahjsmith/aws4d.git \
        ~/.bash/aws4d
    echo "$SCRIPTNAME: installed aws4d"
fi

# Install tmux-resurrect
if [ ! -d ~/.bash/tmux-resurrect ];
then
    mkdir -p ~/.bash/tmux-resurrect
    git clone https://github.com/tmux-plugins/tmux-resurrect \
        ~/.bash/tmux-resurrect
    echo "$SCRIPTNAME: installed tmux-resurrect"
fi

# *Download* jupyter-vim-binding
if [ ! -d ~/.bash/jupyter-vim-binding ];
then
    mkdir -p ~/.bash/jupyter-vim-binding
    git clone https://github.com/lambdalisue/jupyter-vim-binding \
        ~/.bash/jupyter-vim-binding
    echo "$SCRIPTNAME: installed jupyter-vim-bindings"
fi

# *Install* jupyter-vim-binding
"${SCRIPTDIR}/setup/setup_jupyter.sh"

### Link dotfiles

# todo make this portable?
shopt -s dotglob
for f in $SCRIPTDIR/config/*;
do
    if [ ! -L "$HOME/$(basename "$f")" ];
    then
        f1="$(realpath "$f")"
        ln -s "$f1" "$HOME" \
            && echo "$SCRIPTNAME: linked $f" \
            || echo -e "$SCRIPTNAME: could not link $f (file already exists)\n" \
                       "\t(try echo \'source \"$f1\"\' >> $HOME/$f)"
    fi
done

### Mac-specific setup

if $MAC; then
    "${SCRIPTDIR}/setup/setup_mac.sh"
fi
