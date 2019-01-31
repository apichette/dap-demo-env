#!/bin/bash

if [[ $PLATFORM != kubernetes ]]; then
  echo "PLATFORM not set to 'kubernetes'."
  echo "Edit and source demo.config before running this script."
  exit -1
fi

case $1 in
  stop )
	minikube stop
	exit 0
	;;
  delete )
	minikube delete 
	rm -rf $KUBECONFIGDIR ~/.minikube ~/.kube
	exit 0
	;;
  reinstall )
	minikube delete
	rm -rf $KUBECONFIGDIR ~/.minikube ~/.kube
        unset KUBECONFIG
	;;
  start )
	if [[ ! -f $KUBECONFIG ]]; then
	  unset KUBECONFIG
	fi
	;;
  * )
	echo "Usage: $0 [ reinstall | start | stop | delete ]"
	exit -1
	;;
esac

if [[ "$(minikube status | grep Running)" != "" ]]; then
  echo "Your minikube environment is already up - skipping creation!"
else
  minikube start --memory "$MINIKUBE_VM_MEMORY" \
                  --vm-driver virtualbox \
                  --kubernetes-version "$KUBERNETES_VERSION"
  if [[ ! -d $KUBECONFIGDIR ]]; then
    mkdir $KUBECONFIGDIR
    cp -r ~/.kube/* $KUBECONFIGDIR
    rm -rf ~/.kube
    export KUBECONFIG=$KUBECONFIGDIR/config
  fi
fi
eval $(minikube docker-env)

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
