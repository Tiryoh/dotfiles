#!/usr/bin/env bash
set -eu
mkdir -p ~/.bash_completion.d
curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose -o ~/.bash_completion.d/docker-compose
curl -L https://raw.githubusercontent.com/docker/cli/$(docker version --format 'v{{.Server.Version}}')/contrib/completion/bash/docker -o ~/.bash_completion.d/docker
