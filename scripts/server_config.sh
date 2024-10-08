#!/bin/bash -e

[ "$provision_debug" = "true" ] && set -x

cat > /etc/bash.bashrc.local <<EOF
if [ -z "$KUBECONFIG" ]; then
    if [ -e /etc/rancher/rke2/rke2.yaml ]; then
        export KUBECONFIG="/etc/rancher/rke2/rke2.yaml"
    else
        export KUBECONFIG="/etc/rancher/k3s/k3s.yaml"
    fi
fi
export PATH="${PATH}:/var/lib/rancher/rke2/bin:/var/lib/rancher/k3s/data/current/bin"
if [ -z "$CONTAINER_RUNTIME_ENDPOINT" ]; then
    export CONTAINER_RUNTIME_ENDPOINT=unix:///var/run/k3s/containerd/containerd.sock
fi
if [ -z "$IMAGE_SERVICE_ENDPOINT" ]; then
    export IMAGE_SERVICE_ENDPOINT=unix:///var/run/k3s/containerd/containerd.sock
fi

# For ctr
if [ -z "$CONTAINERD_ADDRESS" ]; then
    export CONTAINERD_ADDRESS=/run/k3s/containerd/containerd.sock
fi
EOF
