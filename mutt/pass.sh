#/bin/sh

sed -n -e 's,^machine imap\.gmail\.com login bartek.taczala@gmail.com password \(.*\),\1,p' < ~/.netrc
