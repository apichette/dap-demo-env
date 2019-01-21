#!/bin/bash
echo "Adding Lilah..."
curl -XPOST --data '{ "name": "Lilah" }' -H "Content-Type: application/json" $CONJUR_MASTER_HOST_NAME:8080/pet
echo "Adding Lev..."
curl -XPOST --data '{ "name": "Lev" }' -H "Content-Type: application/json" $CONJUR_MASTER_HOST_NAME:8080/pet
echo "Adding Tony..."
curl -XPOST --data '{ "name": "Tony" }' -H "Content-Type: application/json" $CONJUR_MASTER_HOST_NAME:8080/pet
echo "Adding Gus..."
curl -XPOST --data '{ "name": "Gus" }' -H "Content-Type: application/json" $CONJUR_MASTER_HOST_NAME:8080/pet
