# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.env.enable # Enable vagrant-env(.env)

  # Identify the machine within Vagrant.
  config.vm.define ENV['VM_HOSTNAME']

  # The box from which to build the machine.
  config.vm.box = ENV['VM_BOX']

  # Overrides for the libvirt provider.
  config.vm.provider :libvirt do |v, override|
    # Libvirt housekeeping.
    v.storage_pool_name = ENV['LIBVIRT_STORAGE_POOL'] || "default"
    v.default_prefix = ENV['LIBVIRT_DEFAULT_PREFIX'] || "starterkit_"

    # Hardware limits.
    v.memory = ENV['LIBVIRT_MEMORY'].to_i || 2048
    v.cpus = ENV['LIBVIRT_CPUS'].to_i || 2
  end

  # Hostname, same as Vagrant machine name.
  config.vm.hostname = ENV['VM_HOSTNAME']

  # Network definitions.
  if ENV['VM_IPV4']
    config.vm.network :private_network, :ip => ENV['VM_IPV4']
  end

  # Tweaks to the default /vagrant synced folder.
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder ".", "/home/vagrant/vagrant-root", type: "rsync"

  # Basic provisioning for testing purposes.
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y apache2
  SHELL

end
