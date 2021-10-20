#!/bin/bash

set -euxo pipefail


cd $HOME/.timewarrior
git fetch
git pull
git status
git commit -a -m "$(date)"
git push
