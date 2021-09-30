#!/usr/bin/env python

from __future__ import print_function

import argparse
import logging
import os
import platform
import subprocess
import sys

from contextlib import contextmanager

try:
    from urllib.request import urlretrieve
except ImportError:
    from urllib import urlretrieve


SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
VIM_DIR = os.path.join(os.path.expanduser('~'), '.vim')


@contextmanager
def stacklog(method, message, *args, **kwargs):
    """Bootstrapped version of https://github.com/micahjsmith/stacklog"""
    message = str(message)
    method(message + '...', *args, **kwargs)
    try:
        yield
    except Exception as e:
        method(message + '...FAILURE', *args, **kwargs)
        raise
    else:
        method(message + '...DONE', *args, **kwargs)


def home():
    return os.path.expanduser('~')


def is_mac():
    return platform.system() == 'Darwin'


def is_wsl():
    try:
        with open('/proc/version', 'r') as f:
            if 'microsoft' in f.read().lower():
                return True
    except Exception:
        pass

    return False


def makedirs(d, exist_ok=False):
    try:
        os.makedirs(d)
    except OSError as e:
        if 'File exists' in e and not exist_ok:
            raise


def is_apple_terminal():
    try:
        return os.environ['TERM_PROGRAM'] == 'Apple_Terminal'
    except KeyError:
        return False


def download(url, destination):
    urlretrieve(url, destination)


def clone(url, destination):
    subprocess.check_call(['git', 'clone', url, destination])


def install_vim_bundle_github(author, name):
    bundle_dir = os.path.join(VIM_DIR, 'bundle', name)
    if not os.path.isdir(bundle_dir):
        url = 'https://github.com/{author}/{name}.git'.format(author=author, name=name)
        clone(url, bundle_dir)

        subprocess.check_call([
            'vim',
            '-u', 'NONE',
            '-c', 'helptags ' + os.path.join(bundle_dir, 'doc'),
            '-c', 'q'
        ])

        
def main(minimal):
    with stacklog(logging.info, 'Setting up vim-pathogen'):
        path = os.path.join(VIM_DIR, 'autoload', 'pathogen.vim')
        if not os.path.isfile(path):
            for d in ['autoload', 'bundle']:
                makedirs(os.path.join(VIM_DIR, d), exist_ok=True)
        download('https://tpo.pe/pathogen.vim', path)

    # install vim bundles
    vim_bundle_configs = [
        {'author': 'altercation', 'name': 'vim-colors-solarized'},
        {'author': 'AndrewRadev', 'name': 'linediff.vim'},
        {'author': 'bling', 'name': 'vim-airline'},
        {'author': 'plasticboy', 'name': 'vim-markdown'},
        {'author': 'godlygeek', 'name': 'tabular'},
        {'author': 'terryma', 'name': 'vim-expand-region'},
        {'author': 'tpope', 'name': 'vim-dispatch'},
        {'author': 'tpope', 'name': 'vim-fugitive'},
        {'author': 'tpope', 'name': 'vim-surround'},
        {'author': 'tpope', 'name': 'vim-unimpaired'},
        {'author': 'vim-airline', 'name': 'vim-airline-themes'},
        {'author': 'Yggdroot', 'name': 'indentLine'},
        {'author': 'scrooloose', 'name': 'nerdtree'},
        {'author': 'editorconfig', 'name': 'editorconfig-vim'},
        {'author': 'jeffkreeftmeijer', 'name': 'vim-numbertoggle'},
    ]
    for c in vim_bundle_configs:
        with stacklog(logging.info, 'Installing vim bundle {author}/{name}'.format(**c)):
            install_vim_bundle_github(c['author'], c['name'])

    with stacklog(logging.info, 'Installing vim script increment.vim'):
        if not os.path.isfile(os.path.join(VIM_DIR, 'plugin', 'increment.vim')):
            makedirs(os.path.join(VIM_DIR, 'plugin'), exist_ok=True)
            download(
                'http://www.vim.org/scripts/download_script.php?src_id=469',
                os.path.join(VIM_DIR, 'plugin', 'increment.vim')
            )
            subprocess.check_call([
                'vim', '-u', 'NONE', '-c', 'e ++ff=dos', '-c', 'w ++ff=unix', '-c', 'q',
                os.path.join(VIM_DIR, 'plugin', 'increment.vim'),
            ])

    # done with WSL setup
    if is_wsl():
        return

    with stacklog(logging.info, 'Setting up git-aware-prompt'):
        path = os.path.join(home(), '.bash', 'git-aware-prompt')
        if not os.path.isdir(path):
            makedirs(path, exist_ok=True)
            clone('https://github.com/jimeh/git-aware-prompt.git', path)

    with stacklog(logging.info, 'Setting up solarized'):
        path = os.path.join(home(), '.bash', 'osx-terminal.app-colors-solarized')
        if is_apple_terminal() and not os.path.isdir(path):
            makedirs(path, exist_ok=True)
            clone('https://github.com/tomislav/osx-terminal.app-colors-solarized.git', path)
            for theme in ['Dark', 'Light']:
                subprocess.Popen(
                    ['open', os.path.join(path, 'Solarized {theme}.terminal'.format(theme=theme))],
                    close_fds=True
                )

        path = os.path.join(home(), '.bash', 'dircolors-solarized')
        if not os.path.isdir(path):
            makedirs(path, exist_ok=True)
            clone('https://github.com/seebi/dircolors-solarized.git', path)

    with stacklog(logging.info, 'Installing tmux-resurrect'):
        path = os.path.join(home(), '.bash', 'tmux-resurrect')
        if not os.path.isdir(path):
            makedirs(path, exist_ok=True)
            download(
                'https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash',
                os.path.join(path, 'git-completion.bash')
            )

    with stacklog(logging.info, 'Installing jupyter-vim-binding'):
        with stacklog(logging.debug, 'Downloading jupyter-vim-binding'):
            path = os.path.join(home(), '.bash', 'jupyter-vim-binding')
            if not os.path.isdir(path):
                makedirs(path, exist_ok=True)
                clone('https://github.com/lambdalisue/jupyter-vim-binding', path)

        with stacklog(logging.debug, 'Running setup_jupyter.sh'):
            path = os.path.join(SCRIPT_DIR, 'setup', 'setup_jupyter.sh')
            subprocess.check_call(path)

    with stacklog(logging.info, 'Linking dotfiles'):
        if minimal:
            path = os.path.join(SCRIPT_DIR, 'config', 'min')
        else:
            path = os.path.join(SCRIPT_DIR, 'config')
        exclude = ['.DS_Store']
        for f in os.listdir(path):
            if f in exclude:
                continue
            fa = os.path.join(path, f)
            if os.path.isfile(fa):
                dst = os.path.join(home(), f)
                if minimal:
                    dst, ext = os.path.splitext(dst)
                    assert ext == '.min'
                if not os.path.isfile(dst):
                    os.symlink(fa, dst)
                else:
                    logging.warning(
                        'Could not link {src} to {dst} (already exists)'
                        .format(src=fa, dst=dst))

    if is_mac():
        with stacklog(logging.info, 'Running setup_mac.sh'):
            path = os.path.join(SCRIPT_DIR, 'setup', 'setup_mac.sh')
            subprocess.check_call(path)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Setup all my config')
    parser.add_argument('--vimdir', help='Path to .vim directory')
    parser.add_argument('--verbose', '-v', action='count', default=0)
    parser.add_argument('--min', dest='minimal', action='store_true')
    args = parser.parse_args()

    if args.vimdir is not None:
        VIM_DIR = args.vimdir

    level = logging.WARNING - min(10 * args.verbose, logging.WARNING)
    logging.basicConfig(level=level)

    with stacklog(print, 'Setting up'):
        main(args.minimal)
