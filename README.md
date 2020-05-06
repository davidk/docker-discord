# docker-discord

This will run the latest release version of Discord in a Docker container:

Canary:
    
    keyglitch/discord:canary
    
Stable:

    keyglitch/discord:stable
    

Depending on the version, Discord will likely download updates and quit, stopping the container -- just re-run to start since the volume it downloads to is persisted.

Note: SELinux on Fedora isn't too happy with this container (mostly to do with desktop notifications through libnotify), so be sure to add exceptions as needed. Sound is also quite finicky, and is not muxed with the host (so playing audio on the host will block the container, vice versa).

    docker run -v /tmp/.X11-unix:/tmp/.X11-unix \
    --device /dev/snd \
    -v discordSettings:/home/discord \
    -v /dev/shm:/dev/shm:z \
    -v /etc/localtime:/etc/localtime:ro \
    -v /var/run/dbus:/var/run/dbus \
    -v /var/run/user/$(id -u)/bus:/var/run/user/1000/bus \
    -e DBUS_SESSION_BUS_ADDRESS="unix:path=/var/run/user/1000/bus" \
    -v /var/run/user/$(id -u)/pulse:/var/run/user/1000/pulse \
    -e PULSE_SERVER="unix:/run/user/1000/pulse/native" \
    -e DISPLAY=unix$DISPLAY \
    --rm \
    --group-add $(getent group audio | cut -d: -f3) \
    keyglitch/discord:stable
