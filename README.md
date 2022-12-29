# vagrant-k3s

Create a k3s cluster with Vagrant (libvirt provider) in no time.

## Requirements

- Vagrant
- Vagrant-libvirt
- `yq` and `kubectl` on the host.

## Quick start


1. Edit `settings.yaml`:

    ```
    # A k3s version. Check https://github.com/k3s-io/k3s/releases
    kubernetes_version: v1.24.9+k3s1
    
    # Change to something secret.
    token: sometoken
    
    # Default to 3 nodes. First node is server node and the others are agent nodes.
    cluster_size: 3
    ```

2. Create the cluster.

    ```
    ./new-cluster.sh
    ```

    If everything goes right, a file `kubeconfig` is generated:

    ```
    # export KUBECONFIG=$(pwd)/kubeconfig
    # kubectl get nodes
    ```

3. Tear down the cluster.

   ```
   vagrant destroy
   ```
