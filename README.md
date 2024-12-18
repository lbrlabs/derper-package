# Tailscale DERP Server Package

This repository provides packages for deploying the Tailscale DERP server and XDP DERP server on systems using systemd. The package includes systemd service files, configuration scripts, and instructions for setting up and managing the servers. It supports both RPM-based distributions (RHEL, CentOS, Fedora, Rocky, AlmaLinux) and Debian-based distributions (Debian, Ubuntu).

## Files Included

### Systemd Service Files

#### `derper.service`
This service manages the Tailscale DERP server.
```ini
[Unit]
Description=Tailscale DERP Server
After=network.target
StartLimitIntervalSec=0
StartLimitBurst=0

[Service]
LimitNOFILE=990000
User=0
Group=0
ExecStart=/usr/bin/derper -certdir=/var/cache/derper/certs
Restart=on-failure
RestartSec=5
AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
```

#### `xdpderper.service`
This service manages the XDP DERP server.
```ini
[Unit]
StartLimitIntervalSec=0
StartLimitBurst=0

[Service]
ExecStart=xdpderper --dst-port=3478 --mode=xdpdrv
Restart=on-failure
LimitNOFILE=990000
AmbientCapabilities=CAP_NET_BIND_SERVICE
User=0
Group=0

[Install]
WantedBy=multi-user.target
```

### Configuration Script
A setup script to detect the appropriate configuration directory based on the operating system and create necessary directories and configuration files.

#### `setup-derper.sh`
```bash
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

# Create a configuration file if it doesn't exist
if [ ! -f "$CONFIG_DIR/derper" ]; then
    echo "# Configuration file for DERP server" > "$CONFIG_DIR/derper"
    echo "HOSTNAME=your-default-hostname.example.com" >> "$CONFIG_DIR/derper"
    echo "Configuration file created at $CONFIG_DIR/derper"
else
    echo "Configuration file already exists at $CONFIG_DIR/derper"
fi
```

## Recommendations

### Using Systemd Drop-in Files
The DERP server binary (`derper`) has limited support for configuration or environment variables for certain flags. It is recommended to use systemd drop-in files to override the `ExecStart` directive for customized configurations. For example:

```bash
sudo systemctl edit derper.service
```

Add the following content to override the `ExecStart`:

```ini
[Service]
ExecStart=
ExecStart=/usr/bin/derper -certdir=/var/cache/derper/certs -some-custom-flag=value
```

Reload systemd and restart the service:
```bash
sudo systemctl daemon-reload
sudo systemctl restart derper.service
```

## Directory Structure
- `/etc/derper`: Configuration directory for DERP server.
- `/var/cache/derper/certs`: Directory for storing SSL certificates.
- `/var/lib/derper`: Additional data storage.

## Installation

### RPM-based Distributions
1. Install the RPM package using `yum` or `dnf`:
   ```bash
   sudo yum install derper-package.rpm
   ```
2. Run the setup script:
   ```bash
   sudo sh setup-derper.sh
   ```
3. Enable and start the service:
   ```bash
   sudo systemctl enable derper.service
   sudo systemctl start derper.service
   ```

### Debian-based Distributions
1. Install the Debian package using `dpkg`:
   ```bash
   sudo dpkg -i derper-package.deb
   ```
2. Run the setup script:
   ```bash
   sudo sh setup-derper.sh
   ```
3. Enable and start the service:
   ```bash
   sudo systemctl enable derper.service
   sudo systemctl start derper.service
   ```

## Customization
For additional customization, use the configuration script or edit the systemd service files as described above.

## Troubleshooting
Check the status of the services:
```bash
sudo systemctl status derper.service
sudo systemctl status xdpderper.service
```

View logs:
```bash
journalctl -u derper.service
journalctl -u xdpderper.service
```

