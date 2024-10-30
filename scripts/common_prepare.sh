#!/bin/bash -e

[ "$provision_debug" = "true" ] && set -x

# anything common to all nodes
if [ "$provision_net_install" = "false" ]; then
  exit 0
fi

zypper rr -a && zypper ar  http://download.opensuse.org/update/leap/15.5/oss/ update && zypper ar http://download.opensuse.org/distribution/leap/15.5/repo/oss/ oss
zypper ref
zypper in -y apparmor-parser iptables k9s wget open-iscsi


# The following steps are for spdk
echo 1024 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
modprobe vfio_pci
modprobe uio_pci_generic
modprobe nvme_tcp
#

exit 0

# leave the code for backup, we can use the kubectl shipped with k3s
if [ -n "$provision_kubernetes_version" ]; then
  kubectl_version=${provision_kubernetes_version%%+k3s*}
  echo "Install kubectl $kubectl_version from upstream..."
  curl -sfL https://dl.k8s.io/release/${kubectl_version}/bin/linux/amd64/kubectl > /usr/bin/kubectl && chmod +x /usr/bin/kubectl
else
  echo "Install kubectl from os repo..."
  zypper in -y kubernetes-client
fi

