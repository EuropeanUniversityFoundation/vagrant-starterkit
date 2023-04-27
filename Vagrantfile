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

    # Additional disk for persistent data.
    v.storage :file, :device => 'vdb',
      :size => '5G',
      :allow_existing => true
  end

  # Hostname, same as Vagrant machine name.
  config.vm.hostname = ENV['VM_HOSTNAME']

  # Network definitions.
  if ENV['VM_IPV4']
    config.vm.network :private_network, :ip => ENV['VM_IPV4']
  end

  # Tweaks to the default /vagrant synced folder.
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Unidirectional mounts from host to guest.
  config.vm.synced_folder ".",
    ENV['STARTERKIT_ROOT'],
    type: "rsync",
    rsync__exclude: ".git/"
    # 'rsync__args' breaks this setup - to be investigated.

  if ENV['GITHUB_SSH_DIR']
    config.vm.synced_folder ENV['GITHUB_SSH_DIR'],
      "/home/vagrant/github-ssh",
      type: "rsync"
  end

  if ENV['SSL_CERTS_DIR']
    config.vm.synced_folder ENV['SSL_CERTS_DIR'],
      "/usr/local/share/ca-certificates",
      type: "rsync"
  end

  # Bidirectional mounts between host and guest.
  if ENV['CONFIG_DIR']
    config.vm.synced_folder ENV['CONFIG_DIR'],
      ENV['CONFIG_MNT'] || "/home/vagrant/conf",
      type: "nfs"
  end

  if ENV['VHOSTS_DIR']
    config.vm.synced_folder ENV['VHOSTS_DIR'],
      ENV['VHOSTS_MNT'] || "/var/www/vhosts",
      type: "nfs"
  end

  if ENV['MYSQL_DATA_DIR']
    config.vm.synced_folder ENV['MYSQL_DATA_DIR'],
      ENV['MYSQL_DATA_MNT'] || "/data/mysql",
      type: "nfs"
  end

  # Provisioning script.
  config.vm.provision :shell, path: "provision.sh"

end
