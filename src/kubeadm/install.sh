#!/bin/sh
set -e

VERSION="${VERSION:-"latest"}"

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

echo "Activating feature 'kubeadm' with version ${VERSION}"

architecture="$(uname -m)"
case $architecture in
    x86_64) architecture="amd64";;
    aarch64 | armv8*) architecture="arm64";;
    *) echo "(!) Architecture $architecture unsupported"; exit 1 ;;
esac

echo "Detected architecture: ${architecture}"

if ! command -v curl > /dev/null; then
    # Curl is not available. Attempt to install it.
    if command -v apt > /dev/null; then
        apt-get update
        apt-get install -yq curl
    else
        # Assume RPM based system
        dnf install -yq curl
    fi
fi

if [ "${VERSION}" = "latest" ]; then
    RELEASE="$(curl -sSL https://dl.k8s.io/release/stable.txt)"
else
    RELEASE="${VERSION}"
fi

echo "Installing kubeadm ${RELEASE}."
curl -L -o /usr/local/bin/kubeadm https://dl.k8s.io/release/${RELEASE}/bin/linux/${architecture}/kubeadm

chmod +x /usr/local/bin/kubeadm

echo "Done!"
