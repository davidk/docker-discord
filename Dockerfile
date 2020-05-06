# DESCRIPTION:  Containerized Discord
# AUTHOR:        davidk
# COMMENTS:      This Dockerfile wraps Discord into a Docker container.
#                Based on Jess Frazelle's work at: https://github.com/jessfraz/
#
# USAGE:
#
#    # Build image
#    docker build -t discord --build-arg DOWNLOAD_LINK=PATH_TO_CANARY_OR_NORMAL_BUILD .
#
#    # Run it!
#    docker run -v /tmp/.X11-unix:/tmp/.X11-unix \
#    --device /dev/snd \
#    -v discordSettings:/home/discord \
#    -v /dev/shm:/dev/shm:z \
#    -v /etc/localtime:/etc/localtime:ro \
#    -v /var/run/dbus:/var/run/dbus \
#    -v /var/run/user/$(id -u)/bus:/var/run/user/1000/bus \
#    -e DBUS_SESSION_BUS_ADDRESS="unix:path=/var/run/user/1000/bus" \
#    -e DISPLAY=unix$DISPLAY --rm --group-add $(getent group audio | cut -d: -f3) discord
#
#    # If this fails, it might either be SELinux or
#    # just needing to allow access to your local X session
#    xhost local:root
#
# VOLUME MANAGEMENT:
#
#    # Remove and wipe settings
#    docker volume rm discordSettings
#
#    # Information about where stuff is
#    docker volume inspect discordSettings

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
  libgtk-3-0 \
  libcanberra-gtk3-module \
  libnotify4 \
  libnss3 \
  libxkbfile1 \
  libxss1 \
  libxtst6 \
  libx11-xcb1 \
  xdg-utils \
  libatomic1 \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get autoremove -y \
  && apt-get autoclean

RUN groupadd discord \
    && useradd -g discord --create-home --home-dir /home/discord discord

WORKDIR /home/discord

# DOWNLOAD_LINK
# Canary URL: https://discordapp.com/api/download/ptb?platform=linux&format=deb
# Stable URL: https://discordapp.com/api/download?platform=linux&format=deb
#
# Deb URL: curl -sSI 'https://discordapp.com/api/download/ptb?platform=linux&format=deb' | grep -F 'location: ' | awk '{print $2}' | tr -d '[:space:]'
# Version: curl -sSI 'https://discordapp.com/api/download?platform=linux&format=deb' | grep -i 'location: ' | awk '{print $2}' | tr -d '[:space:]' | sed -e 's/.*discord-//g' | sed -e 's/.deb//g'
#

ARG DOWNLOAD_LINK

RUN apt-get update && apt-get install -y \
  curl \
  ca-certificates \
  --no-install-recommends \
  && curl -sSL "${DOWNLOAD_LINK}" > discord.deb \
  && dpkg -i discord.deb \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get purge -y --auto-remove curl \
  && apt-get autoclean \
  && chown -R discord:discord /home/discord

COPY start.sh /opt/scripts/
RUN chmod +x /opt/scripts/start.sh

VOLUME /home/discord/
ENTRYPOINT [ "/opt/scripts/start.sh" ]
