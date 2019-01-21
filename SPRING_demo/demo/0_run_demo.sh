#!/bin/bash
./add_pets.sh
./list_pets.sh
./get_pet.sh 3
./delete_pets.sh
./list_pets.sh
echo "Contents of /etc/secrets.yml..."
docker exec hello cat /etc/secrets.yml
echo
echo
echo "Opening web page where spring-apps/hello/secret is echoed..."
open http://$CONJUR_MASTER_HOST_NAME:8080
