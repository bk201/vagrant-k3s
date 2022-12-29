#!/bin/bash -e

[ "$provision_debug" = "true" ] && set -x

# anything common to all nodes
if [ "$provision_net_install" = "false" ]; then
  exit 0
fi

zypper ref
zypper in -y apparmor-parser iptables
