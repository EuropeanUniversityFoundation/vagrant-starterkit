#!/usr/bin/env bash
# Git setup script.

# Install git in the system.
apt-get install git -y

# Global configuration for the system user, including GitHub access.
GITCONFIG_FILE=/home/vagrant/.gitconfig

if [[ ! -z ${GIT_NAME} ]]; then
  sudo -u vagrant git config --file ${GITCONFIG_FILE} \
  --add user.name "${GIT_NAME}"
fi

if [[ ! -z ${GIT_EMAIL} ]]; then
  sudo -u vagrant git config --file ${GITCONFIG_FILE} \
  --add user.email "${GIT_EMAIL}"
fi

if [[ ! -z ${GITHUB_USERNAME} ]]; then
  sudo -u vagrant git config --file ${GITCONFIG_FILE} \
  --add github.username "${GITHUB_USERNAME}"
fi

if [[ ! -z ${GITHUB_TOKEN} ]]; then
  sudo -u vagrant git config --file ${GITCONFIG_FILE} \
  --add github.token "${GITHUB_TOKEN}"
fi

if [[ ! -z ${GITHUB_SSH_DIR} ]]; then
  # Establish SSH access to GitHub.
  cp -p /home/vagrant/github-ssh/* /home/vagrant/.ssh/
  # Connect to GitHub; prevent script from exiting.
  sudo -u vagrant ssh -T -o "StrictHostKeyChecking no" git@github.com || true
fi
