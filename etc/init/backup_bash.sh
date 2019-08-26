#!/bin/bash -eu
BACKUPDIR=${HOME}/.backup/$(date +%Y%m%d_%H-%M-%S)
mkdir -p ${BACKUPDIR}
if [ -a ${HOME}/.inputrc ]; then mv ${HOME}/.inputrc ${BACKUPDIR}/.inputrc.bak; fi;
if [ -a ${HOME}/.bashrc ]; then mv ${HOME}/.bashrc ${BACKUPDIR}/.bashrc.bak; fi;
if [ -a ${HOME}/.bash_profile ]; then mv ${HOME}/.bash_profile ${BACKUPDIR}/.bash_profile.bak; fi;
if [ -a ${HOME}/.bash_completion ]; then mv ${HOME}/.bash_completion ${BACKUPDIR}/.bash_completion.bak; fi;
