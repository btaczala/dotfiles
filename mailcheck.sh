#!/bin/bash

maildirs="$HOME/.mail/mobica/*/new"
find $maildirs -type f | wc -l
