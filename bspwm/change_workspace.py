from subprocess import Popen, PIPE

process = Popen(['/usr/bin/bspc', 'query', '-M'], stdout=PIPE)
stdout = process.communicate()[0]
monitors = stdout.decode("utf-8")[:-1]
print(monitors)

workspaces = ""
for monitor in monitors.splitlines(): 
    process = Popen(['/usr/bin/bspc', 'query', '-D', '-m', monitor], stdout=PIPE)
    stdout = process.communicate()[0]
    workspaces += stdout.decode("utf-8")[:-1]
    workspaces += "\n"

p = Popen(['/usr/bin/rofi', '-dmenu', '-i', '-p', 'select workspace:'], stdin=PIPE, stdout=PIPE)
stdout = p.communicate(input=workspaces.encode())[0]
required = stdout.decode("utf-8")[:-1]

print (required)
Popen(['/usr/bin/bspc', 'desktop', '-f', required])
