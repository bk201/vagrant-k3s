require 'yaml'

$root_dir = File.dirname(File.expand_path(__FILE__))
$settings = YAML.load_file(File.join($root_dir, "settings.yaml"))
$runtime_type = ""
$box = ""

def detect_runtime
  # example: v1.24.5-rc4+rke2r1
  # groups: [v1.24.5-rc4+rke2r1, 1.24.5, rc4, rke2, r1]
  m = $settings['kubernetes_version'].match(/^v(1.2[34].\d+)-?(.*)\+(k3s|rke2)(r?\d)/)
  if m.nil?
    puts "Unsupported Kubernetes runtime #{$settings['kubernetes_version']}"
    exit(1)
  end

  $runtime_type = m[3]
  $box = "bk201z/#{$runtime_type}-#{m[1]}"
  # TODO: check box exists

  File.open(File.join($root_dir, "runtime"), "w") { |f| f.write $runtime_type }
end

detect_runtime


$provision_server_config = <<-PROVISION_SERVER_CONFIG
cat > /etc/bash.bashrc.local <<EOF
if [ -z "$KUBECONFIG" ]; then
    if [ -e /etc/rancher/rke2/rke2.yaml ]; then
        export KUBECONFIG="/etc/rancher/rke2/rke2.yaml"
    else
        export KUBECONFIG="/etc/rancher/k3s/k3s.yaml"
    fi
fi
export PATH="${PATH}:/var/lib/rancher/rke2/bin"
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

PROVISION_SERVER_CONFIG


$provision_server = <<-PROVISION_SERVER
INSTALL_K3S_SKIP_DOWNLOAD=true K3S_TOKEN=#{$settings['token']} k3s-install.sh

PROVISION_SERVER


$provision_agent = <<-PROVISION_AGENT
INSTALL_K3S_SKIP_DOWNLOAD=true K3S_TOKEN=#{$settings['token']} K3S_URL=https://#{$settings['server_ip']}:6443 k3s-install.sh

PROVISION_AGENT


Vagrant.configure("2") do |config|
  # config.vm.box_url = "file://packer/output-leap15dot4/package.box"
	# config.vm.box = "test"
  # config.vm.box = "opensuse/Leap-15.3.x86_64"
  config.vm.box = $box
  # config.vm.box_version = ""
  config.vm.synced_folder ".", "/vagrant", disabled: true

  (1..$settings['cluster_size']).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.hostname = "node#{i}"
      node.vm.provider "libvirt" do |lv|
        lv.driver = $settings['driver']
        lv.connect_via_ssh = false
        lv.qemu_use_session = false

        if $settings['driver'] == 'kvm'
          lv.cpu_mode = 'host-passthrough'
        end

        lv.memory = 8192
        lv.cpus = 8

        if $settings['ci']
          lv.management_network_name = 'vagrant-libvirt-ci'
          lv.management_network_address = '192.168.124.0/24'
        end

        lv.storage :file, :size => '50G', :device => 'vdb'
        # lv.graphics_ip = '0.0.0.0'
      end

      node.vm.provision "shell", path: './scripts/common_prepare.sh'
      # The first node is server, others are workers
      if i == 1
        node.vm.provision "shell", inline: $provision_server_config
        node.vm.provision "shell", inline: $provision_server
        node.vm.provision "shell", path: './scripts/server_wait.sh'
      else
        node.vm.provision "shell", inline: $provision_agent
      end
    end
  end
end
