#!/usr/bin/env bash

# Bash setup script.

# Change shell prompt colors to avoid confusion.
sed -i.bak 's/32m/36m/' .bashrc

# Install CLI utilities.
apt-get install htop tree -y
