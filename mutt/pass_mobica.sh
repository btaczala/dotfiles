#/bin/sh

sed -n -e 's,^machine imap\.gmail\.com login bartosz.taczala@mobica.com password \(.*\),\1,p' < ~/.netrc
