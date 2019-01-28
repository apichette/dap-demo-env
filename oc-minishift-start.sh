#!/bin/bash -e

if [[ "$KUBECONFIG" == "" ]]; then
  echo "source demo.config before running this script."
  exit -1
fi

if [[ "$1" == "reinstall" ]]; then
  minishift delete -f || true
  rm -rf $KUBECONFIG ~/.minishift
fi

if [[ "$(minishift status | grep Running)" != "" ]]; then
  echo "Your minishift environment is already up - skipping creation!"
else
  minishift start --memory "$MINISHIFT_VM_MEMORY" \
                  --vm-driver virtualbox \
                  --show-libmachine-logs \
                  --openshift-version "$OPENSHIFT_VERSION"
fi
eval $(minishift docker-env)
docker rm $(docker container ls -a | grep Exited | awk '{print $1}')

# if CLI container is running from saved state, restore /etc/hosts entry if needed
if [[ ("$(docker ps | grep $CLI_CONTAINER_NAME)" != "") && $NO_DNS ]]; then
  docker exec -it $CLI_CONTAINER_NAME bash -c "echo \"$CONJUR_MASTER_HOST_IP    $CONJUR_MASTER_HOST_NAME\" >> /etc/hosts"
fi

echo ""
echo "IMPORTANT!  IMPORTANT!  IMPORTANT!  IMPORTANT!"
echo "You need to source ../demo.config again to reference docker daemon in Minishift..."
echo ""
