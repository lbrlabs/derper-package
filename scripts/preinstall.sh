#!/bin/sh
getent group xdpderper >/dev/null || groupadd -r xdpderper
getent passwd xdpderper >/dev/null || useradd -r -g xdpderper -s /bin/bash -c "XDPDERP server" xdpderper
getent group derper >/dev/null || groupadd -r derper
getent passwd derper >/dev/null || useradd -r -g derper -s /bin/bash -c "DERP server" derper