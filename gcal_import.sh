#!/bin/bash

TERMINAL=evilvte
CONFIG=~/.gcalclirc

$TERMINAL -e bash -c "echo 'Importing invite...' ; \
                      gcalcli --detail-url=short \
                        --calendar='Eric Davis' \
                        import -v \"$1\" ; \
                      read -p 'press enter to exit: '"
