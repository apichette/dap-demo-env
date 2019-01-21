#!/bin/bash

main() {
  curl --cacert $MTLS_CA_CHAIN --cert $MTLS_CERT --key $MTLS_PRIVATE_KEY https://server
#  echo_all
}

echo_all() {
  echo
  echo "MTLS_CA_CHAIN:"; cat $MTLS_CA_CHAIN
  echo
  echo
  echo "MTLS_CERT:"; cat $MTLS_CERT
  echo
  echo
  echo "MTLS_PRIVATE_KEY:"; cat $MTLS_PRIVATE_KEY
  echo
}

main "$@"
