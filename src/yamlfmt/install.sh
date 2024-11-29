#!/bin/bash
set -e

VERSION="${VERSION:-"latest"}"

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

echo "Activating feature 'yamlfmt' with version ${VERSION}"

architecture="$(uname -m)"
case $architecture in
    x86_64) architecture="x86_64";;
    aarch64 | armv8*) architecture="arm64";;
    *) echo "(!) Architecture $architecture unsupported"; exit 1 ;;
esac

if ! command -v curl > /dev/null; then
    # Wget is not available. Attempt to install it.
    if command -v apt > /dev/null; then
        apt-get update
        apt-get install -yq curl
    else
        # Assume RPM based system
        dnf install -yq curl
    fi
fi

echo "Detected architecture: ${architecture}"
# VERSION_NO_V=$(echo "${VERSION}" | sed -e 's/v//g')
curl -fsSL "https://github.com/google/yamlfmt/releases/download/${VERSION}/yamlfmt_${VERSION:1}_Linux_${architecture}.tar.gz" \
    | tar -xzv yamlfmt

mv ./yamlfmt /usr/local/bin/yamlfmt
chmod +x /usr/local/bin/yamlfmt

echo "Done!"
