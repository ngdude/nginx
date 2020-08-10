#!/bin/bash

function usage () {
        echo "$0 [CA section name] [username]"
        exit 1
}

if [ $# -ne 2 ]
then
        usage
fi

CA_NAME="$1"
USERNAME="$2"

SSL_DIR="/etc/nginx/ssl"
SSL_PRIVATE_DIR="$SSL_DIR/${CA_NAME}/private"
SSL_CERTS_DIR="$SSL_DIR/${CA_NAME}/certs"
USERS_DIR="${SSL_CERTS_DIR}/users"

openssl ca -config $SSL_DIR/$1/openssl.cnf -name ${CA_NAME} -revoke ${USERS_DIR}/${USERNAME}.crt -keyfile $SSL_PRIVATE_DIR/ca.key -cert $SSL_CERTS_DIR/ca.crt

openssl ca -config $SSL_DIR/$1/openssl.cnf -name ${CA_NAME} -gencrl -keyfile $SSL_PRIVATE_DIR/ca.key -cert $SSL_CERTS_DIR/ca.crt -out $SSL_PRIVATE_DIR/ca.crl -crldays 1095
