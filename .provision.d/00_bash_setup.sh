#!/usr/bin/env bash
# Bash setup script.

# Change shell prompt colors to avoid confusion.
sed -i.bak 's/32m/36m/' .bashrc

# Install CLI utilities.
apt-get install htop tree -y

# Add '.bash_aliases' to the $HOME directory.
cp -p ${STARTERKIT_ROOT}/dotfiles/example.bash_aliases \
/home/vagrant/.bash_aliases

# Add '.bash_profile' to the $HOME directory.
cp -p ${STARTERKIT_ROOT}/dotfiles/example.bash_profile \
/home/vagrant/.bash_profile
# Include the scripts directory in the $PATH.
sed -i 's,STARTERKIT_ROOT,'"${STARTERKIT_ROOT}"',' \
/home/vagrant/.bash_profile

# Check whether everything is in place.
sudo -u vagrant --login helloworld.sh || true
