#!/bin/bash 
set -eu pipefail

source ./mtls-demo.conf

rm -rf client/client.crt
export CONJUR_AUTHN_API_KEY=$(docker exec conjur-cli conjur host rotate_api_key -h $MTLS_CLIENT_LOGIN)

pushd ./client >& /dev/null
  ./request_certificate
  chmod 444 ./client.crt
popd >& /dev/null

echo
echo "Created & wrote above nginx client cert in:"
echo "  $PWD/client/client.crt."
echo
