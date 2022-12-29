#!/bin/bash -ex

zypper mr --disable repo-backports-update repo-non-oss repo-update-non-oss
zypper in -y apparmor-parser iptables && zypper clean --all

# The script is run with sudo
# The envrionment variable $RUNTIME_VERSION is the k3s verseion

mkdir -p /var/lib/rancher/k3s/agent/images/
cd /var/lib/rancher/k3s/agent/images/ && \
  curl -fL -O https://github.com/k3s-io/k3s/releases/download/$RUNTIME_VERSION/k3s-airgap-images-amd64.tar.zst
cd /usr/local/bin && \
  curl -fL -O https://github.com/k3s-io/k3s/releases/download/$RUNTIME_VERSION/k3s && \
  chmod +x k3s
curl -fL https://get.k3s.io -o /usr/local/bin/k3s-install.sh && \
  chmod +x /usr/local/bin/k3s-install.sh

rm -f /etc/udev/rules.d/*-net.rules
rm -f /var/lib/wicked/*
