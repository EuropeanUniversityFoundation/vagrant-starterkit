# git setup script.

# Install git in the system.
apt-get install git -y

# Global configuration for the system user, including GitHub access.
GITCONFIG_FILE=/home/vagrant/.gitconfig

cp -p ${VAGRANT_ROOT}/dotfiles/example.gitconfig ${GITCONFIG_FILE}

if [[ ! -z ${GIT_NAME} ]]; then
  sed -i 's/"John Doe"/'"${GIT_NAME}"'/' ${GITCONFIG_FILE}
fi

if [[ ! -z ${GIT_EMAIL} ]]; then
  sed -i 's/john.doe@example.com/'"${GIT_EMAIL}"'/' ${GITCONFIG_FILE}
fi

if [[ ! -z ${GITHUB_USERNAME} ]]; then
  sed -i 's/jdoe/'"${GITHUB_USERNAME}"'/' ${GITCONFIG_FILE}
fi

if [[ ! -z ${GITHUB_TOKEN} ]]; then
  sed -i 's/PAT/'"${GITHUB_TOKEN}"'/' ${GITCONFIG_FILE}
fi
