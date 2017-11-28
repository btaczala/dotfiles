#!/bin/bash

xrandr | grep eDP | grep connected | awk '{print $1}'
