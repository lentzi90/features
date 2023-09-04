#!/bin/sh
set -e

VERSION="${VERSION:-"latest"}"

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

echo "Activating feature 'kwok' with version ${VERSION}"

architecture="$(uname -m)"
case $architecture in
    x86_64) architecture="amd64";;
    aarch64 | armv8*) architecture="arm64";;
    *) echo "(!) Architecture $architecture unsupported"; exit 1 ;;
esac

if ! command -v wget > /dev/null; then
    # Wget is not available. Attempt to install it.
    if command -v apt > /dev/null; then
        apt-get update
        apt-get install -yq wget
    else
        # Assume RPM based system
        dnf install -yq wget
    fi
fi

echo "Detected architecture: ${architecture}"

wget --quiet -O /usr/local/bin/kwokctl "https://github.com/kubernetes-sigs/kwok/releases/download/${VERSION}/kwokctl-linux-${architecture}"
chmod +x /usr/local/bin/kwokctl

wget --quiet -O /usr/local/bin/kwok "https://github.com/kubernetes-sigs/kwok/releases/download/${VERSION}/kwok-linux-${architecture}"
chmod +x /usr/local/bin/kwok

echo "Done!"
