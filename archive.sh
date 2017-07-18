#!/usr/bin/env bash

# Micah Smith
# archive.sh
#   Compile dotfiles into a subdirectory for "archiving".

set -e

# don't proceed if we have uncommitted files.
if [ ! -z "$(git status --short)" ]; then
    echo "Please reset or commit changes before proceeding."
    exit 1
fi

# hack- sha of head commit
sha=$(git rev-list HEAD^..HEAD)
shashort=$(echo "$sha" | cut -c 1-8)

reldir=./archive/archive-$shashort
mkdir -p "$reldir"
absdir=$(realpath "$reldir")

echo "$sha" > "$absdir/SHA"

pushd "$HOME" >/dev/null 2>&1
tar -czf "$absdir/vim.tgz" .vim
tar -czf "$absdir/bash.tgz" .bash
popd >/dev/null 2>&1

cp -r ./config "$absdir/"
cp -r ./setup "$absdir/"
cp ./unarchive.sh "$absdir"

echo "Archive created in $absdir"
