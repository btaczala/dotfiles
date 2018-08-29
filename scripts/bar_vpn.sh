#!/bin/bash

#nmcli | grep vpn | head -1 | awk '{print $1}'
nmcli c show --active | grep vpn | head -1 | awk '{print $1}'
