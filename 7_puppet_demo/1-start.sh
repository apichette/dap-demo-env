#!/bin/bash
set -eou pipefail

CONJUR_APPLIANCE_URL=https://$CONJUR_MASTER_HOST_NAME:$CONJUR_MASTER_PORT

main() {

  echo "-----"
  echo "Bring down all running services"
  docker-compose down

  echo "-----"
  echo "Bring up Puppet Master"
  docker-compose up -d puppet

  CONJUR_CONT_ID=$CONJUR_MASTER_CONTAINER_NAME
  PUPPET_CONT_ID=$(docker-compose ps -q puppet)

  echo "-----"
  echo "Load demo policy and sample secret value"
  docker cp puppetdemo-policy.yml $CLI_CONTAINER_NAME:/policy/puppetdemo-policy.yml
  runIncli conjur authn login -u admin -p Cyberark1
  runIncli conjur policy load root /policy/puppetdemo-policy.yml
  runIncli conjur variable values add puppetdemo/dbpassword 'white rabbit'
  runIncli conjur variable values add puppetdemo/secretkey 'Se(re1Fr0mConjur'

  echo "-----"
  echo "Setup Puppet connection to Conjur service"
  runInPuppet bash -c "echo \"$CONJUR_MASTER_HOST_IP     $CONJUR_MASTER_HOST_NAME\" >> /etc/hosts"
  docker cp ../etc/conjur-$CONJUR_ACCOUNT.pem $PUPPET_CONT_ID:/etc/conjur.pem

  echo "-----"
  echo "Start demo webapp nodes"
  docker-compose up -d dev-webapp
  docker-compose up -d prod-webapp

  echo
  echo "Waiting for Puppet Master initialization..."
  sleep 30
}

runIncli() {
  docker exec -it $CLI_CONTAINER_NAME "$@"
}

runInPuppet() {
  docker-compose exec -T puppet "$@"
}

main "$@"
