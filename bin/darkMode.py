#!/usr/bin/env python3

import subprocess
import platform

if platform.system() == "Darwin":
    command = "defaults read -g AppleInterfaceStyle"
    res = subprocess.run(command.split(' '), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    print(res.stdout.decode("utf-8").replace("\n", " "))
