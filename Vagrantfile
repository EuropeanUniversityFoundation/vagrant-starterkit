# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.env.enable # Enable vagrant-env(.env)

  config.vm.define ENV['VM_HOSTNAME']

  config.vm.box = ENV['VM_BOX']

  config.vm.hostname = ENV['VM_HOSTNAME']

  config.vm.synced_folder ".", "/vagrant", type: "rsync"

  config.vm.provider "libvirt"
end
