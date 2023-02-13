#!/bin/bash
set -e

VERSION="${VERSION:-"latest"}"

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

echo "Activating feature 'tilt' with version ${VERSION}"

architecture="$(uname -m)"
case $architecture in
    x86_64) architecture="x86_64";;
    aarch64 | armv8*) architecture="arm64";;
    *) echo "(!) Architecture $architecture unsupported"; exit 1 ;;
esac

if ! command -v curl > /dev/null; then
    # curl is not available. Attempt to install it.
    if command -v apt > /dev/null; then
        apt-get update
        apt-get install -yq curl
    else
        # Assume RPM based system
        dnf install -yq curl
    fi
fi

echo "Detected architecture: ${architecture}"

curl -fsSL "https://github.com/tilt-dev/tilt/releases/download/${VERSION}/tilt.${VERSION#v}.linux.${architecture}.tar.gz" \
    | tar -xzv tilt

mv ./tilt /usr/local/bin/tilt
chmod +x /usr/local/bin/tilt

echo "Done!"
