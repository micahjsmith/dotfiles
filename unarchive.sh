#!/usr/bin/env bash

# Micah Smith
# unarchive.sh
#   Uncompile dotfiles into a subdirectory for "archiving". We can assume that
#   the tgzs are in the same directory as this script.
#   
#   The files in the archive directory were created by archive.sh.
#   See https://github.com/micahjsmith/dotfiles.git for more information.

set -e

SCRIPTNAME=$(basename "$0")
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

dest=$HOME

for d in bash vim;
do
    mkdir $d && tar -xzf $d.tgz -C $d --strip-components 1 && mv $d "$dest"
done

# todo make this portable?
shopt -s dotglob
for f in $SCRIPTDIR/config/*;
do
    if [ ! -L "$dest/$(basename "$f")" ];
    then
        f1="$(realpath "$f")"
        ln -s "$f1" "$dest" 2>/dev/null \
            && echo "$SCRIPTNAME: linked $f" \
            || echo -e "$SCRIPTNAME: could not link $f (file already exists)\n"\
                       "             try this:\n"\
                       "    echo 'source \"$f1\"' >> $dest/$f"
    fi
done

# is there stuff in setup?
if [ -d "$SCRIPTDIR/config" ] && [ "$(ls -A "$SCRIPTDIR/setup")" ];
then
    echo "$SCRIPTNAME: There are more files in $SCRIPTDIR/setup, "\
                       "in case you are interested."
fi
