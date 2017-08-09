# DESCRIPTION:  Discord in Docker!
# AUTHOR:        davidk
# COMMENTS:      This Dockerfile wraps Discord into a Docker container.
#                Tested on Fedora 25.
#                Derived from Jess Frazelle's Atom Dockerfile: https://raw.githubusercontent.com/jessfraz/dockerfiles/master/atom/Dockerfile
#
# USAGE
#
#       # Build image
#       docker build -t discord .
#
#       # Run it!
#       docker run -v /tmp/.X11-unix:/tmp/.X11-unix \
#       --device /dev/snd \
#       -v discordSettings:/home/discord \
#       -v /dev/shm:/dev/shm:z \
#       -v /etc/localtime:/etc/localtime:ro \
#       -v /var/run/dbus:/var/run/dbus \
#       -v /var/run/user/$(id -u)/bus:/var/run/user/1000/bus \
#       -e DBUS_SESSION_BUS_ADDRESS="unix:path=/var/run/user/1000/bus" \
#       -e DISPLAY=unix$DISPLAY --rm --group-add $(getent group audio | cut -d: -f3) discord
#
#      # If this fails, it might either be SELinux or
#      # just needing to allow access to your local X session.
#      # See if there is anything in /var/log/audit/audit.log or try:
#      xhost local:root
#
# VOLUME MANAGEMENT
#
#      # Remove and wipe settings
#      docker volume rm discordSettings
#
#      # Information about where stuff is
#      docker volume inspect discordSettings

FROM debian:stretch

RUN apt-get update && apt-get install -y \
  libc++1 \
  libappindicator1 \
  gconf2 \
  gconf-service \
  gvfs-bin \
  libasound2 \
  libcap2 \
  libgconf-2-4 \
  libgnome-keyring-dev \
  libgtk2.0-0 \
  libnotify4 \
  libnss3 \
  libxkbfile1 \
  libxss1 \
  libxtst6 \
  libx11-xcb1 \
  xdg-utils \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get autoremove -y \
  && apt-get autoclean

RUN groupadd discord \
  && useradd -g discord --create-home --home-dir /home/discord discord

WORKDIR /home/discord
ENV DISCORD_VER 0.0.2

RUN apt-get update && apt-get install -y \
  curl \
  ca-certificates \
  --no-install-recommends \
  && curl -sSL https://dl.discordapp.net/apps/linux/${DISCORD_VER}/discord-${DISCORD_VER}.deb > /home/discord/discord-${DISCORD_VER}.deb \
  && dpkg -i discord-${DISCORD_VER}.deb \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get purge -y --auto-remove curl ca-certificates \
  && apt-get autoclean \
  && chown -R discord:discord /home/discord

COPY start.sh /opt/scripts/
RUN chmod +x /opt/scripts/start.sh

VOLUME /home/discord/
ENTRYPOINT [ "/opt/scripts/start.sh" ]
