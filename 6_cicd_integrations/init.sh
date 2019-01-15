#!/bin/bash 
# this script:
# - executes in the CLI container
# - mounts the demo root directory at /demo_root
# - loads policy from the mounted fs
# - initializes variables 
# - creates conjur* conjurization files in the mounted fs

conjur init -u $CONJUR_APPLIANCE_URL -a $CONJUR_ACCOUNT --force=true << END
yes
END

conjur authn login -u $CONJUR_ADMIN_NAME -p $CONJUR_ADMIN_PASSWORD
cd /demo_root
conjur policy load root policy.yml
conjur variable values add secrets/test-db_username ThisIsTheTESTDBuserName
conjur variable values add secrets/test-db_password 10938471084710238470973
conjur variable values add secrets/prod-db_username ThisIsThePRODDBuserName
conjur variable values add secrets/prod-db_password aoiuaspduperjqkjnsoudoo

CONJUR_AUTHN_API_KEY=$(conjur host rotate_api_key --host $CONJUR_AUTHN_LOGIN)

# create configuration and identity files (AKA conjurize the host)
cp ~/conjur-$CONJUR_ACCOUNT.pem .

echo "Generating identity file..."
cat <<IDENTITY_EOF | tee conjur.identity
machine $CONJUR_APPLIANCE_URL/authn
  login host/$CONJUR_AUTHN_LOGIN
  password $CONJUR_AUTHN_API_KEY
IDENTITY_EOF

echo
echo "Generating host configuration file..."
cat <<CONF_EOF | tee conjur.conf
---
appliance_url: $CONJUR_APPLIANCE_URL
account: $CONJUR_ACCOUNT
netrc_path: "/etc/conjur.identity"
cert_file: "/etc/conjur-$CONJUR_ACCOUNT.pem"
CONF_EOF
