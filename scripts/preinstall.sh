#!/bin/sh

# Detect the correct configuration directory
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        rhel|centos|fedora|rocky|almalinux)
            CONFIG_DIR="/etc/sysconfig"
            ;;
        debian|ubuntu)
            CONFIG_DIR="/etc/default"
            ;;
        *)
            echo "Unknown OS. Defaulting to /etc/default"
            CONFIG_DIR="/etc/default"
            ;;
    esac
else
    # Fallback if /etc/os-release is not available
    if [ -d /etc/sysconfig ]; then
        CONFIG_DIR="/etc/sysconfig"
    else
        CONFIG_DIR="/etc/default"
    fi
fi

# Create necessary directories
mkdir -p /etc/derper
mkdir -p /var/cache/derper/certs
mkdir -p /var/lib/derper

