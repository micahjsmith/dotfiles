#!/usr/bin/env python

from __future__ import print_function

import argparse
import json
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


SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
VIM_DIR = os.path.join(home(), '.vim')


def load_setup_data():
    with open(os.path.join(SCRIPT_DIR, 'data.json'), 'r') as f:
        return json.load(f)


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


def is_descendent(child, parent):
    """Whether child is recursively contained within parent or its children"""
    # note: os.path.commonpath not available until py35
    return not os.path.relpath(child, start=parent).startswith('..')


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


def main(data, minimal=False, extra=False):
    with stacklog(logging.info, 'Setting up vim-pathogen'):
        path = os.path.join(VIM_DIR, 'autoload', 'pathogen.vim')
        if not os.path.isfile(path):
            for d in ['autoload', 'bundle']:
                makedirs(os.path.join(VIM_DIR, d), exist_ok=True)
        download('https://tpo.pe/pathogen.vim', path)

    # install vim bundles
    for c in data['vim']['bundles']:
        with stacklog(logging.info, 'Installing vim bundle {author}/{name}'.format(**c)):
            install_vim_bundle_github(c['author'], c['name'])

    with stacklog(logging.info, 'Installing vim script increment.vim'):
        if not os.path.isfile(os.path.join(VIM_DIR, 'plugin', 'increment.vim')):
            makedirs(os.path.join(VIM_DIR, 'plugin'), exist_ok=True)
            download(
                'http://www.vim.org/scripts/download_script.php?src_id=469',
                os.path.join(VIM_DIR, 'plugin', 'increment.vim')
            )
            # use vim to force converting the increment.vim script to unix
            # line endings
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

    with stacklog(logging.info, 'Setting up solarized colorscheme'):
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
        dirs = []
        if minimal:
            dirs.append(os.path.join(SCRIPT_DIR, 'config', 'min'))
        else:
            dirs.append(os.path.join(SCRIPT_DIR, 'config', 'full'))
        if extra:
            dirs.append(os.path.join(SCRIPT_DIR, 'config', 'extra'))
        exclude = ['.DS_Store']
        for dir in dirs:
            for f in os.listdir(dir):
                if f in exclude:
                    continue
                src = os.path.join(dir, f)
                if os.path.isfile(src):
                    dst = os.path.join(home(), f)
                    if not os.path.isfile(dst):
                        os.symlink(src, dst)
                    else:
                        logging.warning(
                            'Could not link {src} to {dst} (already exists)'
                            .format(src=src, dst=dst))

    if is_mac():
        with stacklog(logging.info, 'Running setup_mac.sh'):
            path = os.path.join(SCRIPT_DIR, 'setup', 'setup_mac.sh')
            subprocess.check_call(path)


def cleanup(data):
    dir = home()
    for f in os.listdir(dir):
        f = os.path.join(dir, f)
        if os.path.islink(f):
            src = os.readlink(f)
            if not os.path.isabs(src):
                src = os.path.join(dir, src)
            if is_descendent(src, SCRIPT_DIR):
                with stacklog(logging.info, 'Unlinking {f}'.format(f=f)):
                    os.remove(f)


if __name__ == '__main__':
    data = load_setup_data()

    parser = argparse.ArgumentParser(description='Setup all my config')
    parser.add_argument(
        '--vimdir',
        help='Path to .vim directory')
    parser.add_argument(
        '--verbose', '-v',
        action='count',
        default=0)
    parser.add_argument(
        '--min',
        dest='minimal',
        action='store_true',
        help='Use minimal versions of core dotfiles')
    parser.add_argument(
        '--extra',
        action='store_true',
        help='Link extra, less-frequently used dotfiles')
    parser.add_argument(
        '--cleanup', '-C',
        action='store_true',
        help='Cleanup links to real dotfiles and exit')

    args = parser.parse_args()

    if args.vimdir is not None:
        VIM_DIR = args.vimdir

    level = logging.WARNING - min(10 * args.verbose, logging.WARNING)
    logging.basicConfig(level=level)

    if args.cleanup:
        with stacklog(print, 'Cleaning up'):
            retcode  = cleanup(data)
        sys.exit(retcode)

    with stacklog(print, 'Setting up'):
        retcode = main(data, minimal=args.minimal, extra=args.extra)
    sys.exit(retcode)
