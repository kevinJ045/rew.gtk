#!/bin/bash

# Determine the Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Cannot determine Linux distribution."
    exit 1
fi

# Package(s) to be installed
PACKAGES="gtk4 gtk3 glib gobject-introspection"

# Install the package(s) based on the distribution
case $DISTRO in
    debian|ubuntu|linuxmint)
        sudo apt update
        sudo apt install -y $PACKAGES
        ;;
    arch|manjaro)
        sudo pacman -Syu --noconfirm $PACKAGES
        ;;
    fedora)
        sudo dnf install -y $PACKAGES
        ;;
    alpine)
        sudo apk add $PACKAGES
        ;;
    *)
        echo "Unsupported Linux distribution: $DISTRO"
        echo "Install These Packages Manually: $PACKAGES"
        ;;
esac
