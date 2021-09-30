#!/usr/bin/env bash

SCRIPTNAME=$(basename "$0")
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# *Install* jupyter-vim-binding
if command -v jupyter >/dev/null 2>&1; then
    nbextensionsdir=$(jupyter --data-dir)/nbextensions

    # If not present, create nbextensions dir
    if [ ! -d "${nbextensionsdir}" ];
    then
        mkdir -p "${nbextensionsdir}"
    fi

    # If not present, create a symlink in nbextensions dir to
    # jupyter-vim-binding in .bash. Note: this requires download step above to
    # have completed successfully.
    if [ ! -d "${nbextensionsdir}/vim_binding" ];
    then
        src=$(realpath ~/.bash/jupyter-vim-binding)
        dest=${nbextensionsdir}/vim_binding
        ln -s "$src" "$dest" \
            && echo "$SCRIPTNAME: linked $src to $dest" \
            || echo "$SCRIPTNAME: could not link $src to $dest"
    fi

    # If not enabled, enable the extension.
    if ! jupyter nbextension list 2>/dev/null | grep -q vim_binding;
    then
        jupyter nbextension enable vim_binding/vim_binding
        echo "$SCRIPTNAME: enabled vim_binding/vim_binding"
    fi

    # If not linked, link custom.js.
    if [ ! -L "$HOME/.jupyter/custom/custom.js" ];
    then
        src=$(realpath "$SCRIPTDIR/../config/jupyter/custom.js")
        dest=$(realpath -m -s "$HOME/.jupyter/custom/custom.js")
        destdir=$(dirname "$dest")
        if [ ! -d "$destdir" ];
        then
            mkdir -p "$destdir"
        fi
        # because GNU ln doesn't support BSD -h/-n as we want
        if [ -L "$dest" ];
        then
            rm "$dest"
        fi
        ln -s "$src" "$dest" \
            && echo "$SCRIPTNAME: linked $src to $dest" \
            || echo "$SCRIPTNAME: could not link $src to $dest"\
                                  " (file already exists)"
    fi
fi
