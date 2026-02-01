FROM node:lts

ARG DEBIAN_FRONTEND="noninteractive"

# Prerequisites
RUN \
  apt-get update && \
  apt-get install -y \
    --no-install-recommends \
    --no-install-suggests \
    gnupg \
    ca-certificates \
    libvips-tools \
    python3 \
    python3-pip \
    python3-venv \
    tzdata \
    wget \
    curl \
    yq && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /var/log/*

# Install jelly-fin ffmpeg and link /usr/lib/jellyfin-ffmpeg/ffmpeg to /usr/bin/ffmpeg
RUN \
  wget -O - https://repo.jellyfin.org/jellyfin_team.gpg.key | apt-key add - && \
  echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/$( awk -F'=' '/^ID=/{ print $NF }' /etc/os-release ) $( awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release ) main" | tee /etc/apt/sources.list.d/jellyfin.list && \
  apt-get update && \
  apt-get install -y \
    --no-install-recommends \
    --no-install-suggests \
    jellyfin-ffmpeg7 && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /var/log/* && \
  ln -s /usr/lib/jellyfin-ffmpeg/ffmpeg /usr/bin/ffmpeg

#ARG EMBY_VERSION="4.9.3.0"

WORKDIR /home

#COPY build.sh emby*.deb /tmp/
#RUN /tmp/build.sh "${EMBY_VERSION}"

COPY package.json index.js ./
RUN npm install --omit=dev

EXPOSE 80
EXPOSE 5004

CMD ["node", "index.js"]
