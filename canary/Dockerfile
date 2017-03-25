# DESCRIPTION:  Discord Canary in Docker!
# AUTHOR:        davidk
# COMMENTS:      This Dockerfile wraps Discord Canary into a Docker container.
#                Tested on Fedora 25.
#                Based on Jess Frazelle's work at: https://github.com/jessfraz/
#
# USAGE:
#
#         # Build image
#         docker build -t slic3r .
#
#         # Run it!
#	  docker run -v /tmp/.X11-unix:/tmp/.X11-unix --device /dev/snd -v discordCanarySettings:/home/discord -v /dev/shm:/dev/shm:z -v /etc/localtime:/etc/localtime:ro -v /var/run/dbus:/var/run/dbus -v /var/run/user/$(id -u)/bus:/var/run/user/1000/bus -e DBUS_SESSION_BUS_ADDRESS="unix:path=/var/run/user/1000/bus" -e DISPLAY=unix$DISPLAY --rm --group-add $(getent group audio | cut -d: -f3) discordcanary
#
#         # If this fails, it might either be SELinux or
#         # just needing to allow access to your local X session
#         xhost local:root
#
# VOLUME MANAGEMENT:
#
#         # Remove and wipe settings
#         docker volume rm slic3rSettings
#
#         # Information about where stuff is
#         docker volume inspect slic3rSettings

FROM debian:stretch

ENV DISCORD_CANARY_VER 0.0.15

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
  xdg-utils \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get autoremove -y \
  && apt-get autoclean

RUN groupadd discord \
    && useradd -g discord --create-home --home-dir /home/discord discord

WORKDIR /home/discord

RUN apt-get update && apt-get install -y \
  curl \
  ca-certificates \
  --no-install-recommends \
  && curl -sSL https://dl-canary.discordapp.net/apps/linux/${DISCORD_CANARY_VER}/discord-canary-${DISCORD_CANARY_VER}.deb > /home/discord/discord-canary-${DISCORD_CANARY_VER}.deb \
  && dpkg -i /home/discord/discord-canary-${DISCORD_CANARY_VER}.deb \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get purge -y --auto-remove curl ca-certificates \
  && apt-get autoclean \
  && chown -R discord:discord /home/discord

COPY start.sh /opt/scripts/
RUN chmod +x /opt/scripts/start.sh

VOLUME /home/discord/
ENTRYPOINT [ "/opt/scripts/start.sh" ]
