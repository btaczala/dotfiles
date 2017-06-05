#!/bin/bash

termite -c ~/.config/termite/mutt.config -e '/usr/bin/tmux attach-session -t mails'
