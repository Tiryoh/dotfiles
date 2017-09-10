.PHONY: all prezto vim deinvim bash tmux git pyenv zsh_completion

all:


prezto:
	/bin/zsh ./etc/init/install_prezto.sh

vim:
	/bin/bash ./etc/init/backup_vim.sh
	ln -s ${PWD}/vim ${HOME}/.vim
	ln -s ${PWD}/vimrc ${HOME}/.vimrc
	mkdir ${HOME}/.vim/swap
	mkdir ${HOME}/.vim/backup
	mkdir ${HOME}/.vim/dict

deinvim:
	/bin/bash ./etc/init/install_deinvim.sh

bash:
	/bin/bash ./etc/init/backup_bash.sh
	ln -s ${PWD}/inputrc ${HOME}/.inputrc
	ln -s ${PWD}/bashrc ${HOME}/.bashrc
	ln -s ${PWD}/bash_profile ${HOME}/.bash_profile

tmux:
	ln -s ${PWD}/tmux.conf ${HOME}/.tmux.conf

git:
	ln -s ${PWD}/gitconfig ${HOME}/.gitconfig

pyenv:
	git clone https://github.com/yyuu/pyenv.git ${HOME}/.pyenv
	git clone https://github.com/pyenv/pyenv-virtualenv.git ${HOME}/.pyenv/plugins/pyenv-virtualenv

zsh_completion:
	/bin/bash ./etc/init/install_zsh_completion.sh

