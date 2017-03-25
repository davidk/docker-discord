#!/bin/bash
# Allow access to the bus for notifications (libnotify)
chown 1000:1000 /var/run/user/1000/bus
su discord -c /usr/bin/discord-canary
