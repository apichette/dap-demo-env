#!/bin/bash -e
CONJUR_HF_TOKEN=$(docker exec -it conjur-cli conjur hostfactory tokens create puppetdemo | jq -r .[].token)
echo "HF Token:" $CONJUR_HF_TOKEN
sed -e "s#{{ CONJUR_APPLIANCE_URL }}#https://$CONJUR_MASTER_HOST_NAME:$CONJUR_MASTER_PORT#g" ./puppet/manifests/conjur.pp.template |
	sed -e "s#{{ CONJUR_ACCOUNT }}#$CONJUR_ACCOUNT#g" |
	sed -e "s#{{ CONJUR_HF_TOKEN }}#$CONJUR_HF_TOKEN#g" > ./puppet/manifests/conjur.pp
