#!/bin/bash -eu
BACKUPDIR=${HOME}/.backup/$(date +%Y%m%d_%H-%M-%S)
mkdir -p ${BACKUPDIR}
if [ -e ${HOME}/.vimrc ]; then mv ${HOME}/.vimrc ${BACKUPDIR}/.vimrc.bak; fi;
if [ -e ${HOME}/.vim ]; then mv ${HOME}/.vim ${BACKUPDIR}/.vim.bak; fi;
