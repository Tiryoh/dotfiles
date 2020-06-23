.PHONY: all prezto vim deinvim bash tmux git pyenv zsh_completion

.DEFAULT_GOAL := help

help:
	@echo "@Tiryoh's dotfiles installer"
	@echo "Usage: Make [target]"
	@echo "target:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

prezto: ## install prezto from https://github.com/Tiryoh/prezto
	zsh ./etc/init/install_prezto.sh

vim: ## install vimrc without dein.vim
	/bin/bash ./etc/init/backup_vim.sh
	ln -s ${PWD}/vim ${HOME}/.vim
	ln -s ${PWD}/vimrc ${HOME}/.vimrc
	mkdir ${HOME}/.vim/swap
	mkdir ${HOME}/.vim/backup
	mkdir ${HOME}/.vim/dict

deinvim: ## install dein.vim (vimrc settings required)
	/bin/bash ./etc/init/install_deinvim.sh

_install_deinvim: ## setup dein.vim from installed files
	/bin/bash -c 'vim -c ":silent! call dein#install() | :q"'

bash: ## install bashrc
	/bin/bash ./etc/init/backup_bash.sh
	ln -s ${PWD}/inputrc ${HOME}/.inputrc
	ln -s ${PWD}/bashrc ${HOME}/.bashrc
	ln -s ${PWD}/bash_profile ${HOME}/.bash_profile
	ln -s ${PWD}/bash_completion ${HOME}/.bash_completion

tmux: ## install tmux settings
	ln -s ${PWD}/tmux.conf ${HOME}/.tmux.conf

git: ## install gitconfig
	ln -s ${PWD}/gitconfig ${HOME}/.gitconfig

pyenv: ## install pyenv
	git clone https://github.com/yyuu/pyenv.git ${HOME}/.pyenv
	git clone https://github.com/pyenv/pyenv-virtualenv.git ${HOME}/.pyenv/plugins/pyenv-virtualenv

zsh_completion: ## install zsh_completion
	/bin/bash ./etc/init/install_zsh_completion.sh

