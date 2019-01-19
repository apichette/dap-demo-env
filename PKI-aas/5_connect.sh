#!/bin/bash -e

# Determine which extra services should be loaded when working with authenticators
USAGE=true
RESTART_SERVER=false
INCLUDE_CERT_CHAIN=false
INCLUDE_CLIENT_CERT=false
while [ ! -z "$1" ] ; do
  USAGE=false
  case "$1" in
    --restart-server ) RESTART_SERVER=true ; shift ;;
    --ca-chain ) INCLUDE_CERT_CHAIN=true ; shift ;;
    --client-cert ) INCLUDE_CLIENT_CERT=true ; shift ;;
     * ) USAGE=true; shift ;;
  esac
done

if [[ $USAGE = true ]]; then
  printf "Usage: %s [--restart-server] [--ca-chain] [--client-cert] \n\n" $0
  exit -1
fi

if [[ $RESTART_SERVER == true ]]; then
  echo "Starting server..."
  docker-compose rm -fs server > /dev/null 2>&1
  docker-compose build server > /dev/null 2>&1
  docker-compose up -d server > /dev/null 2>&1
fi

connect_args=""

if [[ $INCLUDE_CERT_CHAIN = true ]]; then
  connect_args="$args --cacert /client/ca-chain.crt"
fi

if [[ $INCLUDE_CLIENT_CERT = true ]]; then
  connect_args="$connect_args --cert /client/client.crt --key /client/client.key"
fi

echo "Connecting client (Certificate Chain=$INCLUDE_CERT_CHAIN, Client Certificate=$INCLUDE_CLIENT_CERT)..."
docker-compose run --rm client bash -c "curl $connect_args https://server" || true
