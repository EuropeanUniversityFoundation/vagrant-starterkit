# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.env.enable # Enable vagrant-env(.env)

  config.vm.define ENV['VM_HOSTNAME']

  config.vm.box = ENV['VM_BOX']

  config.vm.hostname = ENV['VM_HOSTNAME']

  # Tweaks to the default /vagrant synced folder.
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder ".", "/home/vagrant/vagrant-root", type: "rsync"

  # Overrides for the libvirt provider.
  config.vm.provider :libvirt do |v, override|
    # Hardware limits.
    v.memory = ENV['LIBVIRT_MEMORY'].to_i || 2048
    v.cpus = ENV['LIBVIRT_CPUS'].to_i || 2

    # Libvirt housekeeping.
    v.storage_pool_name = ENV['LIBVIRT_STORAGE_POOL'] || "default"
    v.default_prefix = ENV['LIBVIRT_DEFAULT_PREFIX'] || "starterkit_"
  end
end
