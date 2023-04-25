#!/usr/bin/env bash
# SSL setup script.

if [[ ! -z ${SSL_CERTS_DIR} ]]; then
  SSL_CERTS=/usr/local/share/ca-certificates

  HOSTNAME_F=$(hostname -f)
  echo "SSL certificates for the current FQDN ${HOSTNAME_F}:"
  ls ${SSL_CERTS} | grep -x ${HOSTNAME_F} || echo "- none -"

  HOSTNAME_D=$(hostname -d)
  echo "SSL certificates for the current DNS domain name ${HOSTNAME_D}:"
  ls ${SSL_CERTS} | grep -x ${HOSTNAME_D} || echo "- none -"
fi
