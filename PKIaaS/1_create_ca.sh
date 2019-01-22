#!/bin/bash 
set -eu pipefail

source ./mtls-demo.conf

docker-compose build ca

# Create & write root and intermediate CA certificates in ca/ca subdirectory
if [ ! -d ca/ca ]; then
  docker-compose run --rm ca
fi

# Authenticate as Conjur admin
auth_header=$(docker exec -it conjur-cli conjur authn authenticate -H) 

# Use admin creds to store key and intermediate cert
echo Store the intermediate CA private key in Conjur...
curl --data-binary "@ca/ca/intermediate.key" \
     --cacert "$CONJUR_CERT_FILE" \
     -H "$auth_header" \
     "$CONJUR_APPLIANCE_URL/secrets/$CONJUR_ACCOUNT/variable/conjur/$CA_SERVICE_ID/ca/private-key"

echo Store the intermediate certificate chain in Conjur...
curl --data-binary "@ca/ca/ca-chain.crt" \
     --cacert "$CONJUR_CERT_FILE" \
     -H "$auth_header" \
     "$CONJUR_APPLIANCE_URL/secrets/$CONJUR_ACCOUNT/variable/conjur/$CA_SERVICE_ID/ca/cert-chain"

rm -rf ca/ca
