#!/bin/bash
if [[ "$KUBERNETES_VERSION" == "" ]]; then
	echo "source kubernetes.config first before running this script."
	exit -1
fi
# if no existing VM, delete past login state and minikube resources 
if [[ "$1" == "reinstall" ]]; then
  minikube delete
  rm -rf $KUBECONFIG ~/.minikube
fi
minikube config set memory $MINIKUBE_VM_MEMORY
minikube start --memory $MINIKUBE_VM_MEMORY --vm-driver virtualbox --kubernetes-version $KUBERNETES_VERSION 
#remove all taints from the minikube node so that pods will get scheduled
sleep 5
kubectl patch node minikube -p '{"spec":{"taints":[]}}'

# if CLI container is running from saved state, restore /etc/hosts entry if needed
if [[ ("$(docker ps | grep $CLI_CONTAINER_NAME)" != "") && $NO_DNS ]]; then
  docker exec -it $CLI_CONTAINER_NAME bash -c "echo \"$CONJUR_MASTER_HOST_IP    $CONJUR_MASTER_HOST_NAME\" >> /etc/hosts"
fi

# delete Exited containers
docker rm $(docker container ls -a | grep Exited | awk '{print $1}') > /dev/null

echo "Waiting for minikube to finish starting..."
minikube status

echo ""
echo "IMPORTANT!  IMPORTANT!  IMPORTANT!  IMPORTANT!"
echo "You need to source kubernetes.config again to reference docker daemon in Minikube..."
echo ""
