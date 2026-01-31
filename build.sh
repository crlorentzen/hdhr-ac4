#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
set -x

get_emby() {
  local EMBY_VERSION=$1
  local BASE_URL="https://github.com/MediaBrowser/Emby.Releases/releases/download/${EMBY_VERSION}"
  local EMBY_DEB="emby-server-deb_${EMBY_VERSION}_"
  
  ARCH="$(uname -m)"

  # Download the correct Emby version for this architecture
  echo "Detected architecture: $(uname -m)"
  case "${ARCH}" in
    x86_64)
    EMBY_DEB+="amd64.deb"
    ;;
  aarch64)
    EMBY_DEB+="arm64.deb"
    ;;
  *)
    echo "Unknown architecture. Please download and and build with a local deb file https://github.com/MediaBrowser/Emby.Releases/releases"
    exit 1
    ;;
  esac

  local URL="${BASE_URL}/${EMBY_DEB}"
  echo "Downloading Emby from ${URL}"
  curl -L -o /tmp/${EMBY_DEB} ${URL}
}

install_ffmpeg() {
  local EMBY_DEB=$1

  echo "Installing ffmpeg components from ${EMBY_DEB}"

  ar x ${EMBY_DEB} data.tar.xz
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
}

# If LOCAL_EMBY_DEB or check for version
LOCAL_EMBY_DEB_FILES=(/tmp/emby*.deb)
LOCAL_EMBY_DEB=""
if (( ${#LOCAL_EMBY_DEB_FILES[@]} == 1 )); then
  LOCAL_EMBY_DEB=LOCAL_EMBY_DEB_FILES[0]
else
  if [[] ! -z "${LOCAL_EMBY_DEB:-}" && "$#" != 1 ]] ; then
    echo "Usage: $0 EMBY_VERSION";
    exit 1;
  else
    get_emby $1
  fi
fi

BUILD_DIR=$(mktemp -d)
pushd "${BUILD_DIR}"
LOCAL_EMBY_DEB=$(ls -1 /tmp/emby*.deb)

install_ffmpeg ${LOCAL_EMBY_DEB}

popd
rm -rf /tmp/*