# dotfiles

Micah's dotfiles: bashrc, vimrc, etc.

- License: MIT License

## Setup a new box

1. Go to System Settings > Privacy & Security > App Management and add or enable your terminal.

2. Run

    ```
    ./setup.py
    ```

## Archive dotfiles

```
./archive.sh
```

## Unarchive dotfiles

```
cd path/to/archive/directory
./unarchive.sh
```

## Todo

[ ] use [git contrib's git
prompt](https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh) rather than third party (jimeh)
[ ] activate python/conda env when creating new pane in tmux
