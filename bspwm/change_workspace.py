from subprocess import Popen, PIPE

process = Popen(['/usr/bin/bspc', 'query', '-M'], stdout=PIPE)
stdout = process.communicate()[0]
monitor = stdout.decode("utf-8")[:-1]


process = Popen(['/usr/bin/bspc', 'query', '-D', '-m', monitor], stdout=PIPE)
stdout = process.communicate()[0]
monitor = stdout.decode("utf-8")[:-1]

# for desktop in monitor.splitlines():
    # print (desktop)

p = Popen(['/usr/bin/rofi', '-dmenu', '-i'], stdin=PIPE, stdout=PIPE)
stdout = p.communicate(input=monitor.encode())[0]
required = stdout.decode("utf-8")[:-1]

print (required)
Popen(['/usr/bin/bspc', 'desktop', '-f', required])
