#!/bin/bash

ROOT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0})/../../; pwd)

sh ${ROOT_DIR}/etc/vim/install_deinvim2.sh ${ROOT_DIR}/vim/dein
