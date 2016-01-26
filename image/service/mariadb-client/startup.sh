#!/bin/bash -e

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x

FIRST_START_DONE="${CONTAINER_STATE_DIR}/docker-mariadb-client-first-start-done"
# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

  if [ "${ROUNDCUBE_MARIADB_CLIENT_TLS,,}" == "true" ]; then
    # generate a certificate and key if files don't exists
    # https://github.com/osixia/docker-light-baseimage/blob/stable/image/service-available/:cfssl/assets/tool/cfssl-helper
    cfssl-helper ${MARIADB_CLIENT_CFSSL_PREFIX} "${CONTAINER_SERVICE_DIR}/mariadb-client/assets/certs/$ROUNDCUBE_MARIADB_CLIENT_TLS_CRT_FILENAME" "${CONTAINER_SERVICE_DIR}/mariadb-client/assets/certs/$ROUNDCUBE_MARIADB_CLIENT_TLS_KEY_FILENAME" "${CONTAINER_SERVICE_DIR}/mariadb-client/assets/certs/$ROUNDCUBE_MARIADB_CLIENT_TLS_CA_CRT_FILENAME"
  fi

  touch $FIRST_START_DONE
fi

exit 0
