#!/bin/bash

gcalcli agenda --nocolor | cut -d " " -f 4- | head -2 | tail -1 | sed "s/^ *//g" | sed "s/    / /g" | cut -c1-19
