# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Default box will be overridden by provider-specific boxes
  config.vm.box = "generic/ubuntu2204"

  # Enable SSH forward agent
  # config.ssh.forward_agent = true

  # VMware Fusion specific configuration
  config.vm.provider "vmware_desktop" do |vmware, override|
    override.vm.box = "gyptazy/ubuntu22.04-arm64"  # ARM64 box for Apple Silicon
    vmware.vmx["memsize"] = "2048"
    vmware.vmx["numvcpus"] = "2"
    vmware.vmx["disk.vmdksize"] = "40960"
    # vmware.gui = true
  end

  # Parallels specific configuration
  config.vm.provider "parallels" do |prl, override|
    override.vm.box = "bento/ubuntu-20.04"
    prl.memory = 2048
    prl.cpus = 2
    # prl.update_guest_tools = true
    # prl.check_guest_tools = true
    # prl.customize ["set", :id, "--install-parallels-tools", "off"]
  end

  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "./dev/init_playbook.yaml"
    ansible.raw_arguments = [
      "-i", "./inventory/vagrant.yaml",
      "-e", "@dev/roles/user_setup/vars/vault.yaml",
      "--ask-vault-pass",
    ]
  end

end
