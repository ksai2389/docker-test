#!/bin/bash

DOMAIN="qualcomm.com"

THIS_HOST="$(/bin/hostname)"
OUTPUT_DIR="/tmp/$THIS_HOST"

if [ $# -lt 1 -o "$1" == "--help" -o "$1" == "-h" ]; then
  echo "Usage: $0 <hostname> [cname |...]"
  echo "  Use shortname for hostname and any additional cname(s)."
  echo "  Script will automatically add FQDN with ${DOMAIN} as necessary"
  exit 1
fi

HOSTNAME=$1; shift
SUBJECT="/C=US/ST=California/L=San Diego/O=QUALCOMM/CN=${HOSTNAME}.${DOMAIN}/"

# SAN is a special env var that openssl will use as it's offical
# Subject Alternative Name value in the certificate.
SAN="DNS:${HOSTNAME}.${DOMAIN}, DNS:${HOSTNAME}"

for cname in $*; do
  SAN="${SAN}, DNS:${cname}.${DOMAIN}, DNS:${cname}"
done

mkdir -p -m 700 $OUTPUT_DIR

openssl req -new -newkey rsa:2048 -sha512 -nodes \
  -keyout $OUTPUT_DIR/$HOSTNAME.${DOMAIN}.key -out $OUTPUT_DIR/$HOSTNAME.${DOMAIN}.csr \
  -subj "$SUBJECT" -reqexts SAN \
  -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=$SAN"))

chmod 600 $OUTPUT_DIR/$HOSTNAME.${DOMAIN}.key $OUTPUT_DIR/$HOSTNAME.${DOMAIN}.csr

echo "Created $OUTPUT_DIR/$HOSTNAME.${DOMAIN}.csr"

