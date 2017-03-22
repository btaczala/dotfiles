from subprocess import Popen, PIPE


p = Popen(['/usr/bin/gcalcli', '--nocolor', '--nostarted', 'agenda', 'today', 'tomorrow'], stdout=PIPE)
out = p.communicate()[0]
out = out.decode("utf-8")[1:]

res = ""

for k in out.splitlines(): 
    if k:
        res = k
        break

print (res)

