#!/bin/bash

cd tailscale
latest_tag=$(git describe --tags `git rev-list --tags --max-count=1`)
echo "Latest upstream tag: $latest_tag"
