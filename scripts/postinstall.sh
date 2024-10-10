#!/bin/sh
systemctl daemon-reload
systemctl enable xdpderper.service
systemctl enable derper.service
systemctl start xdpderper.service
systemctl start derper.service