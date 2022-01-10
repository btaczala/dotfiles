#!/bin/bash

set -euxo pipefail


cd $HOME/.timewarrior
git fetch
git pull
git status
git add data
git commit -m "$(date)"
git push
