# Micah Smith
# setup.sh
#   Setup all my config. Downloads vim plugins, bash git prompt, and creates
#   symlinks of relevant dotfiles to home directory

SCRIPTNAME=$(basename $0)
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

### Vim setup

# Setup vim-pathogen
if [ ! -f ~/.vim/autoload/pathogen.vim ];
then
    mkdir -p ~/.vim/autoload ~/.vim/bundle
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
else
    echo "$SCRIPTNAME: pathogen.vim already installed"
fi

# Setup vim-fugitive
if [ ! -d ~/.vim/bundle/vim-fugitive ];
then
    git clone https://github.com/tpope/vim-fugitive.git ~/.vim/bundle/vim-fugitive
    vim -u NONE -c "helptags ~/.vim/bundle/vim-fugitive/doc" -c q
else
    echo "$SCRIPTNAME: vim-fugitive already installed"
fi

# Setup julia-vim
if [ ! -d ~/.vim/bundle/julia-vim ];
then
    git clone https://github.com/JuliaLang/julia-vim.git ~/.vim/bundle/julia-vim
    vim -u NONE -c "helptags ~/.vim/bundle/julia-vim/doc" -c q
else
    echo "$SCRIPTNAME: julia-vim already installed"
fi

# Setup tabular
if [ ! -d ~/.vim/bundle/tabular ];
then
    git clone https://github.com/godlygeek/tabular.git ~/.vim/bundle/tabular
    vim -u NONE -c "helptags ~/.vim/bundle/tabular/doc" -c q
else
    echo "$SCRIPTNAME: tabular already installed"
fi

# Setup vim-airline
if [ ! -d ~/.vim/bundle/vim-airline ];
then
    git clone https://github.com/bling/vim-airline.git ~/.vim/bundle/vim-airline
    vim -u NONE -c "helptags ~/.vim/bundle/vim-airline/doc" -c q
else
    echo "$SCRIPTNAME: vim-airline already installed"
fi

# Setup vim-markdown
if [ ! -d ~/.vim/bundle/vim-markdown ];
then
    git clone https://github.com/plasticboy/vim-markdown.git ~/.vim/bundle/vim-markdown
    vim -u NONE -c "helptags ~/.vim/bundle/vim-markdown/doc" -c q
else
    echo "$SCRIPTNAME: vim-markdown already installed"
fi

# Setup increment.vim
if [ ! -f ~/.vim/plugins/increment.vim ];
then
    mkdir -p ~/.vim/plugins
    curl -LSso ~/.vim/plugins/increment.vim http://www.vim.org/scripts/download_script.php?src_id=469
else
    echo "$SCRIPTNAME: increment.vim already installed"
fi

# Setup vim-expand-region
if [ ! -d ~/.vim/bundle/vim-expand-region ];
then
    git clone https://github.com/terryma/vim-expand-region.git ~/.vim/bundle/vim-expand-region
    vim -u NONE -c "helptags ~/.vim/bundle/vim-expand-region/doc" -c q
else
    echo "$SCRIPTNAME: vim-expand-region already installed"
fi

# Setup indentLine
if [ ! -d ~/.vim/bundle/indentLine ];
then
    git clone https://github.com/Yggdroot/indentLine.git ~/.vim/bundle/indentLine
    vim -u NONE -c "helptags ~/.vim/bundle/indentLine/doc" -c q
else
    echo "$SCRIPTNAME: indentLine already installed"
fi

# Setup linediff.vim
if [ ! -d ~/.vim/bundle/linediff.vim ];
then
    git clone https://github.com/AndrewRadev/linediff.vim.git ~/.vim/bundle/linediff.vim
    vim -u NONE -c "helptags ~/.vim/bundle/linediff.vim/doc" -c q
else
    echo "$SCRIPTNAME: linediff.vim already installed"
fi

# Setup vim-unimpaired
if [ ! -d ~/.vim/bundle/vim-unimpaired ];
then
    git clone https://github.com/tpope/vim-unimpaired.git ~/.vim/bundle/vim-unimpaired
    vim -u NONE -c "helptags ~/.vim/bundle/vim-unimpaired/doc" -c q
else
    echo "$SCRIPTNAME: vim-unimpaired already installed"
fi

# Setup vim-colors-solarized
if [ ! -d ~/.vim/bundle/vim-colors-solarized ];
then
    git clone https://github.com/altercation/vim-colors-solarized.git \
        ~/.vim/bundle/vim-colors-solarized
    vim -u NONE -c "helptags ~/.vim/bundle/vim-colors-solarized/doc" -c q
else
    echo "$SCRIPTNAME: vim-colors-solarized already installed"
fi

### Bash setup

# Setup git-aware-prompt
if [ ! -d ~/.bash/git-aware-prompt ];
then
    mkdir -p ~/.bash/git-aware-prompt
    git clone https://github.com/jimeh/git-aware-prompt.git ~/.bash/git-aware-prompt
else
    echo "$SCRIPTNAME: git-aware-prompt already installed"
fi

# Setup solarized
if [ ! -d ~/.bash/gnome-terminal-colors-solarized ];
then
    mkdir -p ~/.bash/gnome-terminal-colors-solarized
    git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git \
        ~/.bash/gnome-terminal-colors-solarized
else
    echo "$SCRIPTNAME: gnome-terminal-colors-solarized already installed"
fi

### Dotfiles
for FILE in .bashrc .vimrc .tmux.conf .gitconfig;
do
    if [ ! -h "$HOME/$FILE" ];
    then
        ln --symbolic --target-directory $HOME $SCRIPTDIR/$FILE
    else
        echo "$SCRIPTNAME: $FILE already linked"
    fi
done
