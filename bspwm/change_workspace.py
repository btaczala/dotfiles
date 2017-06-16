from subprocess import Popen, PIPE
import json

process = Popen(['/usr/bin/bspc', 'query', '-M'], stdout=PIPE)
stdout = process.communicate()[0]
monitors = stdout.decode("utf-8")[:-1]
print(monitors)

workspaces = []
for monitor in monitors.splitlines(): 
    process = Popen(['/usr/bin/bspc', 'query', '-D', '-m', monitor], stdout=PIPE)
    stdout = process.communicate()[0]
    ids = stdout.decode("utf-8")[:-1]
    for singleId in ids.splitlines():
        print("Single id {}", singleId)
        process2 = Popen(['/usr/bin/bspc', 'query', '-T', '-d', singleId], stdout=PIPE)
        jsonS,_ = process2.communicate();
        js = json.loads(jsonS)
        a = js['name']
        workspaces.append((singleId,a))

    # workspaces += stdout.decode("utf-8")[:-1]
    # workspaces += "\n"
print(workspaces)

workspaces_ids =""
for (id, name) in workspaces: 
    workspaces_ids += name
    workspaces_ids += "\n"

print(workspaces_ids)
p = Popen(['/usr/bin/rofi', '-dmenu', '-i', '-p', 'select workspace:'], stdin=PIPE, stdout=PIPE)
stdout = p.communicate(input=workspaces_ids.encode())[0]
selected = stdout.decode("utf-8")[:-1]

print (selected)
for (id, name) in workspaces:
    if selected == name:
        print('Launching {} id {}'.format( name, id))
        Popen(['/usr/bin/bspc', 'desktop', '-f', id])

