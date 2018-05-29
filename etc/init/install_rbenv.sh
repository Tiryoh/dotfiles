#!/usr/bin/env bash
set -eu

[[ ! -d ~/.rbenv ]] && git clone https://github.com/rbenv/rbenv.git ~/.rbenv || cd ~/.rbenv && git pull
mkdir -p ~/.rbenv/plugins
[[ ! -d ~/.rbenv/plugins/ruby-build ]] && git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build || cd ~/.rbenv/plugins/ruby-build && git pull
~/.rbenv/bin/rbenv init
