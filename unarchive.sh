#!/usr/bin/env bash

# Micah Smith
# unarchive.sh
#   Uncompile dotfiles into a subdirectory for "archiving". We can assume that
#   the tgzs are in the same directory as this script.
#   
#   The files in the archive directory were created by archive.sh.
#   See https://github.com/micahjsmith/dotfiles.git for more information.

set -e

SCRIPTNAME=$(basename $0)
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

dest=$HOME

tar -xzf .bash.tgz
tar -xzf .vim.tgz

mv .bash $dest
mv .vim $dest

# todo make this portable?
shopt -s dotglob
for f in config/*;
do
    if [ ! -h "$dest/$(basename $f)" ];
    then
        ln -s $SCRIPTDIR/$f $dest
        echo "$SCRIPTNAME: linked $f"
    fi
done
