#!/bin/bash
curl https://raw.githubusercontent.com/Shougo/dein-installer.vim/main/installer.sh > ${PWD}/installer.sh
sh ${PWD}/installer.sh ${PWD}/vim/dein
rm -f ${PWD}/installer.sh
