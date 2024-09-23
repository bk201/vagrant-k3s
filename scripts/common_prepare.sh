#!/bin/bash -e

[ "$provision_debug" = "true" ] && set -x

# anything common to all nodes
if [ "$provision_net_install" = "false" ]; then
  exit 0
fi

zypper rr -a && zypper ar  http://free.nchc.org.tw/opensuse/update/leap/15.5/oss/ update && zypper ar http://free.nchc.org.tw/opensuse/distribution/leap/15.5/repo/oss/ oss
zypper ref
zypper in -y apparmor-parser iptables k9s kubernetes-client
