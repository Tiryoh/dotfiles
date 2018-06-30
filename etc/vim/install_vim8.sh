#!/usr/bin/env bash
set -eu
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:jonathonf/vim
sudo apt-get update
sudo apt-get install -y vim
