#!/bin/bash
# Allow access to the bus for notifications (libnotify)
chown 1000:1000 -R /var/run/user/1000
[[ -e "/usr/bin/discord" ]] && su discord -c /usr/bin/discord || su discord -c /usr/bin/discord-ptb
