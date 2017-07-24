#!/bin/bash -eu
[[ -e $HOME/.zsh/completion/_git ]] && exit 0
mkdir -p $HOME/.zsh/completion/git && cd $HOME/.zsh/completion/git
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
cd $HOME/.zsh/completion
ln -s ./git/git-completion.zsh ./_git
