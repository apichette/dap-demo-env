#!/bin/bash
if [[ $# < 1 ]]; then
  echo "Specify number of pet to retrieve."
  exit -1
fi
echo "Getting pet $1..."
curl $CONJUR_MASTER_HOST_NAME:8080/pet/$1
echo
echo
