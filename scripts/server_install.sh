#!/bin/bash -e

[ "$provision_debug" = "true" ] && set -x

if [ "$provision_net_install" = "true" ]; then
  curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="$provision_kubernetes_version" K3S_TOKEN="$provision_token" sh -s - 
else
  INSTALL_K3S_SKIP_DOWNLOAD=true K3S_TOKEN="$provision_token" k3s-install.sh
fi
