# Vagrant Starter Kit

This project provides a set of tools and configuration to build (persistent capable) virtual machines managed with **Vagrant** using **libvirt** as the provider.

## Requirements

This Starter Kit requires [Vagrant](https://developer.hashicorp.com/vagrant/docs/installation) and [libvirt](https://libvirt.org/compiling.html) to be installed in the host system.

Additionally, the following **Vagrant** plugins are necessary:

- [vagrant-libvirt](https://vagrant-libvirt.github.io/vagrant-libvirt/#installation)
- [vagrant-env](https://github.com/gosuri/vagrant-env#installation)

## Usage

    cp .env.example .env
    nano .env
    vagrant up

### Additional directories

    mkdir ../ssh      # GITHUB_SSH_DIR
    mkdir ../ssl      # SSL_CERTS_DIR
    mkdir ../conf     # CONFIG_DIR
    mkdir ../vhosts   # VHOSTS_DIR

_Work in progress..._
