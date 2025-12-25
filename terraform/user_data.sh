#!/bin/bash
# Simple userdata: install Docker and run nginx

set -e

# Try apt, then yum
if command -v apt-get >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y docker.io
  systemctl enable docker
  systemctl start docker
elif command -v yum >/dev/null 2>&1; then
  yum install -y docker
  systemctl enable docker
  systemctl start docker
fi

# Run nginx container to serve a simple page
docker run -d --name infra-nginx -p 80:80 nginx:stable
