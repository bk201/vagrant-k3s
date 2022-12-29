#!/bin/bash -e

[ "$provision_debug" = "true" ] && set -x

if [ "$provision_net_install" = "true" ]; then
  curl -sfL https://get.k3s.io | K3S_TOKEN="$provision_token" K3S_URL="https://${provision_server_ip}:6443" INSTALL_K3S_VERSION="$provision_kubernetes_version" sh -s - 
else
  INSTALL_K3S_SKIP_DOWNLOAD=true K3S_TOKEN="$provision_token" K3S_URL="https://${provision_server_ip}:6443" k3s-install.sh
fi
