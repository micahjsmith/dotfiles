#!/usr/bin/env bash

# Micah Smith
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

OPTS=`getopt -o hv:w --long help,vimdir:,windows -n 'parse-options' -- "$@"`

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

SCRIPTNAME=$(basename $0)
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if which wget >/dev/null 2>&1; then
    download="wget -q -O"
else
    download="curl -LSso"
fi

### Vim setup

# Setup vim-pathogen
if [ ! -f "$VIMDIR/autoload/pathogen.vim" ];
then
    mkdir -p $VIMDIR/autoload $VIMDIR/bundle
    $download $VIMDIR/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    echo "$SCRIPTNAME: installed pathogen.vim"
fi

# Setup vim-fugitive
if [ ! -d "$VIMDIR/bundle/vim-fugitive" ];
then
    git clone https://github.com/tpope/vim-fugitive.git $VIMDIR/bundle/vim-fugitive
    vim -u NONE -c "helptags $VIMDIR/bundle/vim-fugitive/doc" -c q
    echo "$SCRIPTNAME: installed vim-fugitive"
fi

# Setup julia-vim
if [ ! -d "$VIMDIR/bundle/julia-vim" ];
then
    git clone https://github.com/JuliaLang/julia-vim.git $VIMDIR/bundle/julia-vim
    vim -u NONE -c "helptags $VIMDIR/bundle/julia-vim/doc" -c q
    echo "$SCRIPTNAME: installed julia-vim"
fi

# Setup tabular
if [ ! -d "$VIMDIR/bundle/tabular" ];
then
    git clone https://github.com/godlygeek/tabular.git $VIMDIR/bundle/tabular
    vim -u NONE -c "helptags $VIMDIR/bundle/tabular/doc" -c q
    echo "$SCRIPTNAME: installed tabular"
fi

# Setup vim-airline
if [ ! -d "$VIMDIR/bundle/vim-airline" ];
then
    git clone https://github.com/bling/vim-airline.git $VIMDIR/bundle/vim-airline
    vim -u NONE -c "helptags $VIMDIR/bundle/vim-airline/doc" -c q
    echo "$SCRIPTNAME: installed vim-airline"
fi

# Setup vim-airline-themes
if [ ! -d "$VIMDIR/bundle/vim-airline-themes" ];
then
    git clone https://github.com/vim-airline/vim-airline-themes $VIMDIR/bundle/vim-airline-themes
    vim -u NONE -c "helptags $VIMDIR/bundle/vim-airline-themes/doc" -c q
    echo "$SCRIPTNAME: installed vim-airline-themes"
fi

# Setup vim-markdown
if [ ! -d "$VIMDIR/bundle/vim-markdown" ];
then
    git clone https://github.com/plasticboy/vim-markdown.git $VIMDIR/bundle/vim-markdown
    vim -u NONE -c "helptags $VIMDIR/bundle/vim-markdown/doc" -c q
    echo "$SCRIPTNAME: installed vim-markdown"
fi

# Setup increment.vim
if [ ! -f "$VIMDIR/plugin/increment.vim" ];
then
    mkdir -p "$VIMDIR/plugin"
    $download "$VIMDIR/plugin/increment.vim" http://www.vim.org/scripts/download_script.php?src_id=469
    vim -u NONE -c 'e ++ff=dos' -c 'w ++ff=unix' -c q "$VIMDIR/plugin/increment.vim"
    echo "$SCRIPTNAME: installed increment.vim"
fi

# Setup vim-expand-region
if [ ! -d "$VIMDIR/bundle/vim-expand-region" ];
then
    git clone https://github.com/terryma/vim-expand-region.git $VIMDIR/bundle/vim-expand-region
    vim -u NONE -c "helptags $VIMDIR/bundle/vim-expand-region/doc" -c q
    echo "$SCRIPTNAME: installed vim-expand-region"
fi

# Setup indentLine
if [ ! -d "$VIMDIR/bundle/indentLine" ];
then
    git clone https://github.com/Yggdroot/indentLine.git $VIMDIR/bundle/indentLine
    vim -u NONE -c "helptags $VIMDIR/bundle/indentLine/doc" -c q
    echo "$SCRIPTNAME: installed indentLine"
fi

# Setup linediff.vim
if [ ! -d "$VIMDIR/bundle/linediff.vim" ];
then
    git clone https://github.com/AndrewRadev/linediff.vim.git $VIMDIR/bundle/linediff.vim
    vim -u NONE -c "helptags $VIMDIR/bundle/linediff.vim/doc" -c q
    echo "$SCRIPTNAME: installed linediff.vim"
fi

# Setup vim-unimpaired
if [ ! -d "$VIMDIR/bundle/vim-unimpaired" ];
then
    git clone https://github.com/tpope/vim-unimpaired.git $VIMDIR/bundle/vim-unimpaired
    vim -u NONE -c "helptags $VIMDIR/bundle/vim-unimpaired/doc" -c q
    echo "$SCRIPTNAME: installed vim-unimpaired"
fi

# Setup vim-colors-solarized
if [ ! -d "$VIMDIR/bundle/vim-colors-solarized" ];
then
    git clone https://github.com/altercation/vim-colors-solarized.git \
        $VIMDIR/bundle/vim-colors-solarized
    vim -u NONE -c "helptags $VIMDIR/bundle/vim-colors-solarized/doc" -c q
    echo "$SCRIPTNAME: installed vim-colors-solarized"
fi

# Setup vim-surround
if [ ! -d "$VIMDIR/bundle/vim-surround" ];
then
    git clone https://github.com/tpope/vim-surround.git $VIMDIR/bundle/vim-surround
    vim -u NONE -c "helptags $VIMDIR/bundle/vim-surround/doc" -c q
    echo "$SCRIPTNAME: installed vim-surround"
fi

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

# Setup solarized
if ps -p$PPID 2>/dev/null | grep -q gnome-terminal &&  \
    [ ! -d ~/.bash/gnome-terminal-colors-solarized ];
then
    mkdir -p ~/.bash/gnome-terminal-colors-solarized
    git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git \
        ~/.bash/gnome-terminal-colors-solarized
    echo "$SCRIPTNAME: installed gnome-terminal-colors-solarized"
fi

if echo $TERM_PROGRAM | grep -q Apple_Terminal && \
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
    if [ ! -h "$HOME/.dir_colors" ];
    then
        ln -s ~/.bash/dircolors-solarized/dircolors.256dark ~/.dir_colors
        eval `dircolors ~/.dir_colors`
    fi
    echo "$SCRIPTNAME: installed dircolors-solarized"
fi

# Install aws4d utils
if [ ! -d ~/.bash/aws4d ];
then
    git clone https://github.com/micahjsmith/aws4d.git \
        ~/.bash/aws4d
    echo "$SCRIPTNAME: installed aws4d"
fi

if [ ! -d ~/.bash/tmux-resurrect ];
then
    git clone https://github.com/tmux-plugins/tmux-resurrect \
        ~/.bash/tmux-resurrect
    echo "$SCRIPTNAME: installed tmux-resurrect"
fi

### Dotfiles
for FILE in .bashrc .vimrc .tmux.conf .gitconfig .vrapperrc .pylintrc;
do
    if [ ! -h "$HOME/$FILE" ];
    then
        ln --symbolic --target-directory $HOME $SCRIPTDIR/$FILE
        echo "$SCRIPTNAME: linked $FILE"
    fi
done
