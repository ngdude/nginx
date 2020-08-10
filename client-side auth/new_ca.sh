#!/bin/bash

function usage () {
        echo "$0 [CA section name]"
        exit 1
}

if [ $# -ne 1 ]
then
        usage
fi

CA_NAME="$1"

SSL_DIR="/etc/nginx/ssl"
SSL_PRIVATE_DIR="$SSL_DIR/${CA_NAME}/private"
SSL_CERTS_DIR="$SSL_DIR/${CA_NAME}/certs"
CA_PATH="$SSL_DIR/${CA_NAME}"


mkdir -p ${SSL_PRIVATE_DIR}
mkdir -p ${SSL_CERTS_DIR}

cp -H /usr/lib/ssl/openssl.cnf $SSL_DIR/$1

sed -i "s|default_ca.*|default_ca = $1|" $SSL_DIR/$1/openssl.cnf
sed -i "s|CA_default|$1|" $SSL_DIR/$1/openssl.cnf
sed -i "s|\$dir|$CA_PATH|g" $SSL_DIR/$1/openssl.cnf

touch $SSL_DIR/${CA_NAME}/index.txt
touch $SSL_DIR/${CA_NAME}/index.txt.attr
touch $SSL_DIR/${CA_NAME}/crlnumber

openssl genrsa -out $SSL_PRIVATE_DIR/ca.key 4096

openssl req -config $SSL_DIR/$1/openssl.cnf -nodes -new -x509 -days 1095 -key $SSL_PRIVATE_DIR/ca.key -out $SSL_CERTS_DIR/ca.crt -subj "/C=RU/ST=SSL/L=SSL/O=SSL/OU=dev/CN=ca/emailAddress=admin@mydomain.com"
openssl ca -config $SSL_DIR/$1/openssl.cnf -name ${CA_NAME} -gencrl -keyfile $SSL_PRIVATE_DIR/ca.key -cert $SSL_CERTS_DIR/ca.crt -out $SSL_PRIVATE_DIR/ca.crl -crldays 1095

