#!/bin/bash
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > ${PWD}/installer.sh
sh ${PWD}/installer.sh ${PWD}/vim/dein
rm -f ${PWD}/installer.sh
