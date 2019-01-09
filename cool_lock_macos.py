#!/usr/bin/env python3

from subprocess import call
from wasp_spotify_bindings.core import Wasp
from time import sleep
import Quartz

spotify_state=Wasp.get_state()

status_ = spotify_state["state"]

if status_ == "playing": 
    Wasp.pause()

call(["m", "lock"])

d = Quartz.CGSessionCopyCurrentDictionary()
while d and d.get("CGSSessionScreenIsLocked", 0) == 1: 
    sleep(1)
    d = Quartz.CGSessionCopyCurrentDictionary()

if status_ == "playing": 
    Wasp.play()
