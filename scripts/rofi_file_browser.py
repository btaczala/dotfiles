import os
from os.path import expanduser
from subprocess import Popen, PIPE
home = expanduser("~")

allowed_files = [".pdf"]
excluded_folders = set("Trash")
stdin = ""

for dirpath, dirs, files in os.walk(home, True, None, False):
    for file in files:
        split = os.path.splitext(file)
        if split[1] in allowed_files: 
            stdin += "{}/{}\n".format(dirpath, file)
p = Popen(['/usr/bin/rofi', '-dmenu', '-i'], stdin=PIPE, stdout=PIPE)
stdout = p.communicate(input=stdin.encode())[0]
stdout = stdout.decode("utf-8")[:-1]
if not stdout: 
    exit
p = Popen(['/usr/bin/mimeo', stdout])
