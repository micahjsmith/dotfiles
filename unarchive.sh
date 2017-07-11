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
for f in $SCRIPTDIR/config/*;
do
    if [ ! -h "$dest/$(basename $f)" ];
    then
        f1="$(realpath $f)"
        ln -s "$f1" "$dest" 2>/dev/null \
            && echo "$SCRIPTNAME: linked $f" \
            || { echo "$SCRIPTNAME: could not link $f (file already exists)"; \
                 echo "             (try echo 'source \"$f1\"' >> $dest/$f)" }
    fi
done
