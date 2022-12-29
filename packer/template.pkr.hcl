source "vagrant" "leap15dot4" {
  communicator = "ssh"
  source_path = "opensuse/Leap-15.4.x86_64"
  provider = "libvirt"
#  add_force = true
}

build {
  sources = ["source.vagrant.leap15dot4"]

  provisioner "shell" {
    environment_vars = [
      "RUNTIME_VERSION=v1.24.9+k3s1"
    ]
    execute_command = "sudo -S bash -c '{{ .Vars }} {{ .Path }}'"
    script = "provision.sh"
  }
}
