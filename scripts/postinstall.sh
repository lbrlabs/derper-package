#!/bin/sh
# Reload systemd daemon to account for new/updated service files
systemctl daemon-reload

# Enable services
systemctl enable xdpderper.service
systemctl enable derper.service

# Start services
systemctl start xdpderper.service
systemctl start derper.service

# setcap
sudo setcap 'cap_net_bind_service=+ep' /usr/bin/derper
sudo setcap 'cap_net_bind_service=+ep' /usr/bin/xdpderper

