#!/bin/bash -e

[ "$provision_debug" = "true" ] && set -x

# anything common to all nodes
if [ "$provision_net_install" = "false" ]; then
  exit 0
fi

zypper rr -a && zypper ar  http://free.nchc.org.tw/opensuse/update/leap/15.5/oss/ update && zypper ar http://free.nchc.org.tw/opensuse/distribution/leap/15.5/repo/oss/ oss
zypper ref
zypper in -y apparmor-parser iptables k9s


KUBECTL_VERSION="v1.29.9"
curl -sfL https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl > /usr/bin/kubectl && chmod +x /usr/bin/kubectl

