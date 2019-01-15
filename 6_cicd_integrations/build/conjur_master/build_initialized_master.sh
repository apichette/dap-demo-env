#!/bin/bash
if [[ $# -ne 1 ]]; then
	echo "Provide name for initialized Conjur master image..."
	exit -1
fi
CONJUR_COMMIT_IMAGE=$1
CONJUR_BASE_IMAGE=registry2.itci.conjur.net/conjur-appliance:5.0-stable
CONJUR_MASTER_NAME=conjur_master
CONJUR_BUILD_CONTAINER_NAME=conjur_master
CONJUR_ADMIN_PASSWORD=Cyberark1
CONJUR_ORG_ACCOUNT=dev

docker run -d --restart always \
		--security-opt seccomp:unconfined \
		--name $CONJUR_BUILD_CONTAINER_NAME \
		-p "443:443" -p "636:636" -p "5432:5432" -p "5433:5433" \
		$CONJUR_BASE_IMAGE

docker exec $CONJUR_BUILD_CONTAINER_NAME evoke configure master -h $CONJUR_MASTER_NAME -p $CONJUR_ADMIN_PASSWORD $CONJUR_ORG_ACCOUNT

sleep 5
docker exec $CONJUR_BUILD_CONTAINER_NAME sv stop conjur
sleep 5
docker exec $CONJUR_BUILD_CONTAINER_NAME sv stop pg
sleep 5
docker stop $CONJUR_BUILD_CONTAINER_NAME
sleep 5
docker commit -a "Jody Hunt @ CyberArk jody.hunt@cyberark.com" \
		-m "This is a pre-configured Conjur v5 Master node image" \
		$CONJUR_BUILD_CONTAINER_NAME \
		$CONJUR_COMMIT_IMAGE
docker rm $CONJUR_BUILD_CONTAINER_NAME
