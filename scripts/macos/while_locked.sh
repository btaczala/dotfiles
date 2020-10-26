#!/bin/bash

locked=$(python -c 'import sys,Quartz; d=Quartz.CGSessionCopyCurrentDictionary(); sys.exit(d and d.get("CGSSessionScreenIsLocked", 0) == 0 and d.get("kCGSSessionOnConsoleKey", 0) == 1)')
res=$?

while [ $res -eq 1 ]; do
    echo "waiting for locked"
    locked=$(python -c 'import sys,Quartz; d=Quartz.CGSessionCopyCurrentDictionary(); sys.exit(d and d.get("CGSSessionScreenIsLocked", 0) == 0 and d.get("kCGSSessionOnConsoleKey", 0) == 1)')
    res=$?
done

locked=$(python -c 'import sys,Quartz; d=Quartz.CGSessionCopyCurrentDictionary(); sys.exit(d and d.get("CGSSessionScreenIsLocked", 0) == 0 and d.get("kCGSSessionOnConsoleKey", 0) == 1)')
res=$?

if [ $res -eq 1 ]; then
    echo "not locked"
else
    while [ $res -eq 0 ]; do
        sleep 5
        echo "locked"
        locked=$(python -c 'import sys,Quartz; d=Quartz.CGSessionCopyCurrentDictionary(); sys.exit(d and d.get("CGSSessionScreenIsLocked", 0) == 0 and d.get("kCGSSessionOnConsoleKey", 0) == 1)')
        res=$?
    done
echo "unlocked!"
fi
osascript -e 'display notification "hello world!"'
