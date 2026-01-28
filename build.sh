#!/bin/bash

set -o nounset
set -o pipefail
set -x

EMBY_VERSION="${1}"

if [ -z ${EMBY_VERSION} ]; then
  echo "No Emby Version Provided"
  exit 1
fi

# Download the correct Emby version for this architecture
echo "Detected architecture: $(uname -m)"
if [ "${LINK:-}" ]; then
  echo "Overriding Emby release"
  LINK=$LINK
elif [ "$(uname -m)" == "x86_64" ]; then
  LINK="https://github.com/MediaBrowser/Emby.Releases/releases/download/${EMBY_VERSION}/emby-server-deb_${EMBY_VERSION}_amd64.deb"
elif [ "$(uname -m)" == "aarch64" ]; then
  LINK="https://github.com/MediaBrowser/Emby.Releases/releases/download/${EMBY_VERSION}/emby-server-deb_${EMBY_VERSION}_arm64.deb"
else
  echo "Unknown architecture. Set the LINK environment variable to a URL of a .deb file from https://github.com/MediaBrowser/Emby.Releases/releases"
  exit 1
fi

BUILD_DIR=$(mktemp -d)
pushd "${BUILD_DIR}"
echo "Downloading Emby from ${LINK}"
curl -L -o emby.deb ${LINK}
ar x emby.deb data.tar.xz
tar xf data.tar.xz


# Put the ffmpeg binaries in the right place, ignoring missing files
mv opt/emby-server/bin/ffmpeg /usr/bin/ffmpeg
mv opt/emby-server/lib/libav*.so.* /usr/lib/ || true
mv opt/emby-server/lib/libpostproc.so.* /usr/lib/ || true
mv opt/emby-server/lib/libsw* /usr/lib/ || true
mv opt/emby-server/extra/lib/libva*.so.* /usr/lib/ || true
mv opt/emby-server/extra/lib/libdrm.so.* /usr/lib/ || true
mv opt/emby-server/extra/lib/libmfx.so.* /usr/lib/ || true
mv opt/emby-server/extra/lib/libOpenCL.so.* /usr/lib/ || true

popd
rm -rf /tmp/*