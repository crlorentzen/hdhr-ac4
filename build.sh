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


LOCAL_EMBY_DEB=""
orig_args="$@"
orig_argc=$#

# Check for local/cached emby*deb
set -- /tmp/emby*.deb

if [[ ! -e "$1" ]]; then
    echo "No emby .deb files found"
elif [[] "$#" -gt 1 ]]; then
    echo "ERROR: Multiple emby .deb files found"
    exit 1
else
    echo "Found one file: $1"
    LOCAL_EMBY_DEB=$1
fi

set -- "${orig_args}"
if [[ ${orig_argc} -ne "$#" ]]; then
  echo "argument restoration failed"
  exit 1
fi

# If no LOCAL_EMBY_DEB, get_emby
if [[ -z "${LOCAL_EMBY_DEB:-}" ]]; then
  get_emby $1
fi

BUILD_DIR=$(mktemp -d)
pushd "${BUILD_DIR}"
LOCAL_EMBY_DEB=(/tmp/emby*.deb)

install_ffmpeg ${LOCAL_EMBY_DEB}

popd
rm -rf /tmp/*