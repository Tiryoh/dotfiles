# dotfiles

my dotfiles

[![license](https://img.shields.io/github/license/tiryoh/dotfiles.svg?maxAge=2592000)](./LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/tiryoh/dotfiles.svg?maxAge=2592000)](https://github.com/Tiryoh/dotfiles/issues)
[![Travis](https://travis-ci.org/Tiryoh/dotfiles.svg?branch=dev%2Fautobuild)](https://travis-ci.org/Tiryoh/dotfiles)

## Table of Contents

* Requirements
* Usage
* Vim Shortcuts
* License

## Requirements

requires the following to run:

  * Vim
    * make
    * curl
    * Vim 7.4 (+clipboard +lua)
  * bash
    * make
    * bash
  * zsh
    * make
    * git
    * wget
    * zsh
  * tmux
    * make
    * tmux
  * git
    * make
    * git

## Usage

* git clone scripts on your home directory

```
git clone https://github.com/Tiryoh/dotfiles.git
```

* move to `dotfiles` dir and install new settings

```
cd $HOME/dotfiles
```

  * vim
    * install `dein.vim`

    ```
    make deinvim
    ```

    * install new vim settings

    ```
    make vim
    ```

  * bash
    * install new bashrc and imputrc

    ```
    make bash
    ```

  * zsh
    * install prezto and zsh_completion

    ```
    make prezto
    make zsh_completion
    ```

  * tmux
    * install new tmux.conf

    ```
    make tmux
    ```

  * git
  Don't forget to change user.email and user.name.

done!!!

## Vim Shortcuts

e.g.)
* [esc]
  * jj
* comment/comment out
  * gcc
* quick run
  * :Q

## tmux Shortcuts

* prefix key
  * Ctrl-b
* Open new window
  * prefix + c
* View window list
  * prefix + w
* Select next/previous window
  * prefix + n
  * prefix + p
  * prefix + Ctrl-l
  * prefix + Ctrl-h
* Move panes
  * prefix + {
  * prefix + }
  * prefix + Ctrl-o
* Select pane
  * prefix + l
  * prefix + k
  * prefix + j
  * prefix + h
* Resize pane
  * prefix + L
  * prefix + K
  * prefix + J
  * prefix + H
* Reload config
  * prefix + r

## License

This repository is licensed under the MIT license, see [LICENSE](./LICENSE).

Unless attributed otherwise, everything is under the MIT license.

Copyright (c) 2016-2017 [Tiryoh](https://github.com/Tiryoh)

