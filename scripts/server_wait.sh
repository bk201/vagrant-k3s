#!/bin/bash -e

[ "$provision_debug" = "true" ] && set -x

# wait node is ready
retries=0
while [ true ]; do
  status=$(kubectl get nodes | grep "^$(cat /etc/hostname)" | awk '{print $2}')

  if [ "$status" = "Ready" ]; then
    echo "node status is ready."
    break
  else
    echo "node status is $status."
  fi

  if [ $retries -eq 60 ]; then
    echo "timeout to wait for node to be ready!"
    journalctl -u k3s
    exit 1
  fi

  retries=$((retries+1))
  echo "retry in 5 seconds..."
  sleep 5
done
