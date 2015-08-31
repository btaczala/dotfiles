#!/usr/bin/env python2
# vim:shiftwidth=2:tabstop=2
#
# skype-away.py
# 
#   Copyright (c) 2007, David Mohr <david@mcbf.net> 
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Source: https://developer.skype.com/Docs/ApiDoc/FrontPage
#
# 
# 2007-06-22  v0.2  Initial release, tested with skype beta 1.4
#                   Note that the commandline parameter --enable-dbus is
#                   required, and you must NOT specify --system-bus
#

import gtk, dbus, sys

def mood(text=""):
    bus = dbus.SessionBus()
    try:
        proxy = bus.get_object('com.Skype.API', '/com/Skype')
        proxy.Invoke('NAME skype_mood.py')
        proxy.Invoke('PROTOCOL 2')
        command = 'SET PROFILE MOOD_TEXT %s' % text
        return proxy.Invoke(command)
    except:
            print "Could not contact Skype client"
 
def set_status(name):
  #print name
  answer = obj.Invoke("SET "+name)
  #print "answer = ", answer
  if answer != name:
    print "Error setting "+name+": "+answer

def usage():
  print "Usage: %s {STATUS|GET}" % sys.argv[0]
  print "          GET displays the current status"
  print "          Otherwise sets Skype to be in STATUS, where STATUS is one of:"
  print "            online, offline, skypeme, away, na, dnd, invisible"
  sys.exit(1)


if len(sys.argv) < 2:
  usage()

# Initiate a connection to the Session Bus
try:
  bus = dbus.SessionBus()
except Exception:
  print "Could not connect to the Dbus!"
  sys.exit(2)

try:
  obj = bus.get_object(
      "com.Skype.API", "/com/Skype")
except Exception:
  print "Could not connect to Skype on the dbus!"
  sys.exit(3)

answer = obj.Invoke('NAME skype-away.py')
#print "answer = ", answer
if answer != 'OK':
  print "Could not connect to Skype: "+answer
  sys.exit(1)

answer = obj.Invoke('PROTOCOL 5')
if answer != 'PROTOCOL 5':
  print 'This test program only supports Skype API protocol version 5 ('+answer+')'
  sys.exit(1)


if sys.argv[1].lower() == "get":
  print "Current skype", obj.Invoke("GET USERSTATUS")
  sys.exit(0)

stati = ['online', 'offline', 'skypeme', 'away', 'na', 'dnd', 'invisible']

valid_status = 0
for i in range(len(stati)):
  if stati[i] == sys.argv[1].lower():
    valid_status = 1

if valid_status == 0:
  print "Invalid status: ", sys.argv[1]
  usage()

set_status("USERSTATUS "+sys.argv[1].upper())
if len(sys.argv) == 3:
  mood(sys.argv[2])
else:
  mood("")

