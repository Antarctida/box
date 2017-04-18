#!/usr/bin/env bash
#
# Phalcon Box
#
# Copyright (c) 2011-2017, Phalcon Framework Team
#
# The contents of this file are subject to the New BSD License that is
# bundled with this package in the file LICENSE.txt
#
# If you did not receive a copy of the license and are unable to obtain it
# through the world-wide-web, please send an email to license@phalconphp.com
# so that we can send you a copy immediately.
#

# trace ERR through pipes
set -o pipefail

# trace ERR through 'time command' and other functions
set -o errtrace

# set -u : exit the script if you try to use an uninitialised variable
set -o nounset

# set -e : exit the script if any statement returns a non-true return value
set -o errexit

if [ -n "$1" ]; then
	PATH_SSL="/etc/nginx/ssl"

	mkdir -p ${PATH_SSL}

	SSL_CONFIG="${PATH_SSL}/${1}.cnf"
	SSL_KEY="${PATH_SSL}/${1}.key"
	SSL_CERT="${PATH_SSL}/${1}.crt"

	if [ ! -f ${SSL_CONFIG} ] || [ ! -f ${SSL_KEY} ] || [ ! -f ${SSL_CERT} ]; then
		sed -i '/copy_extensions\ =\ copy/s/^#\ //g' /etc/ssl/openssl.cnf

		cat > ${SSL_CONFIG} << EOF
[req]

prompt = no
default_bits = 2048
default_keyfile = ${SSL_KEY}
encrypt_key = no
default_md = sha256
distinguished_name = req_distinguished_name
x509_extensions = v3_ca

[req_distinguished_name]
O=Vagrant
C=UN
CN=${1}

[v3_ca]
basicConstraints = CA:FALSE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alternate_names

[alternate_names]
DNS.1 = ${1}
EOF

		openssl genrsa -out "${SSL_KEY}" 2048 2>/dev/null
		openssl req -new -x509 -config "${SSL_CONFIG}" -out "${SSL_CERT}" -days 365 2>/dev/null

	fi
fi
