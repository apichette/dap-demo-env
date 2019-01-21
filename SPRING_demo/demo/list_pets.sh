#!/bin/bash
echo "Listing all pets..."
curl $CONJUR_MASTER_HOST_NAME:8080/pets
echo
echo
