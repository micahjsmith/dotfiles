#!/usr/bin/env bash

# Micah Smith
# archive.sh
#   Compile dotfiles into a subdirectory for "archiving".

set -e

# hack- sha of head commit
sha=$(git rev-list HEAD^..HEAD | cut -c 1-8)

reldir=./archive/archive-$sha
mkdir -p $reldir
absdir=$(realpath $reldir)

pushd $HOME >/dev/null 2>&1
tar -czf $absdir/.vim.tgz .vim
tar -czf $absdir/.bash.tgz .bash
popd >/dev/null 2>&1

cp -r ./config $absdir/
cp ./unarchive.sh $absdir

echo "Archive created in $absdir"
