#!/bin/bash 
set -eu pipefail

source ./mtls-demo.conf

# Create & write root and intermediate CA certificates in ca/ca subdirectory
pushd ca
./generate_ca
popd

# Authenticate as Conjur admin
docker exec -it $CLI_CONTAINER_NAME conjur authn login -u admin -p $CONJUR_ADMIN_PASSWORD
auth_header=$(docker exec -it $CLI_CONTAINER_NAME conjur authn authenticate -H) 

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
