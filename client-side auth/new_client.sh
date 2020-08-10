#!/bin/bash

function usage () {
        echo "$0 [CA section name] [username] [mailto]"
        exit 1
}

if [ $# -ne 3 ]
then
        usage
fi

CA_NAME="$1"
USERNAME="$2"
MAIL_TO="$3"

SSL_DIR="/etc/nginx/ssl"
SSL_PRIVATE_DIR="$SSL_DIR/${CA_NAME}/private"
SSL_CERTS_DIR="$SSL_DIR/${CA_NAME}/certs"
USERS_DIR="${SSL_CERTS_DIR}/users"

mkdir -p ${USERS_DIR}

openssl genrsa -out ${USERS_DIR}/${USERNAME}.key 1024
openssl req -config $SSL_DIR/$1/openssl.cnf -nodes -new -key ${USERS_DIR}/${USERNAME}.key -out ${USERS_DIR}/${USERNAME}.csr -subj "/C=RU/ST=SSL/L=SSL/O=SSL/OU=dev/CN=ca/emailAddress=admin@mydomain.com"

openssl x509 -req -days 1095 -in ${USERS_DIR}/${USERNAME}.csr -CA $SSL_CERTS_DIR/ca.crt -CAkey $SSL_PRIVATE_DIR/ca.key -CAserial $SSL_DIR/${CA_NAME}/serial -CAcreateserial -out ${USERS_DIR}/${USERNAME}.crt

openssl pkcs12 -export -clcerts -in ${USERS_DIR}/${USERNAME}.crt -inkey ${USERS_DIR}/${USERNAME}.key -out ${USERS_DIR}/${USERNAME}.p12 -passout pass:Qwerty@123

echo "Client-side certificate " | mutt -e "set crypt_use_gpgme=no" -a ${USERS_DIR}/${USERNAME}.p12  -s "new cert" -- $MAIL_TO



