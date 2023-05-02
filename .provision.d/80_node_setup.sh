#!/usr/bin/env bash
# NodeJS setup script.

if [[ ! -z ${NODE_VERSIONS} ]]; then
  NPM_ALIAS=${STARTERKIT_ROOT}/.provision.d/snippets/npm.bash_aliases
  cat ${NPM_ALIAS} >> /home/vagrant/.bash_aliases

  for v in ${NODE_VERSIONS[@]}
  do
    echo -e "NodeJS version: $v"

    LATEST_URL=https://nodejs.org/dist/latest-v$v.x/
    DIST=linux-x64.tar.gz
    TARBALL=$( curl -s ${LATEST_URL} | grep ${DIST} | awk -F '"' '{print $2}' )
    wget -q ${LATEST_URL}${TARBALL} -P /tmp/nodejs

    NODE_ROOT=/usr/local/bin/node
    mkdir -p ${NODE_ROOT}/$v
    tar -zxf /tmp/nodejs/${TARBALL} -C ${NODE_ROOT}/$v --strip-components=1
    update-alternatives --install /usr/bin/node node ${NODE_ROOT}/$v/bin/node $v

    sudo -u vagrant node --version
    sudo -u vagrant $(dirname $(realpath $(which node)))/npm --version
  done
fi
