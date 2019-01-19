#!/bin/bash 
set -eu pipefail

source ./mtls-demo.conf

rm -rf server/server.crt
export CONJUR_AUTHN_API_KEY=$(docker exec conjur-cli conjur host rotate_api_key -h $MTLS_SERVER_LOGIN)

pushd ./server >& /dev/null
  ./request_certificate
  chmod 444 ./server.crt
popd >& /dev/null

echo
echo "Created cert for nginx server in $PWD/server/server.crt."
echo
