#!/bin/zsh
git clone --recursive https://github.com/Tiryoh/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  if [ -L "${ZDOTDIR:-$HOME}/.${rcfile:t}" ]; then
    echo "${ZDOTDIR:-$HOME}/.${rcfile:t}" already exists
  else
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  fi
done


